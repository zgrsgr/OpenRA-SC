#region Copyright & License Information
/*
 * Copyright 2007-2019 The OpenRA Developers (see AUTHORS)
 * This file is part of OpenRA, which is free software. It is made
 * available to you under the terms of the GNU General Public License
 * as published by the Free Software Foundation, either version 3 of
 * the License, or (at your option) any later version. For more
 * information, see COPYING.
 */
#endregion

using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.IO;
using System.Net;
using System.Text;
using ICSharpCode.SharpZipLib.Zip;
using OpenRA.Primitives;
using OpenRA.Support;
using OpenRA.Widgets;

namespace OpenRA.Mods.Common.Widgets.Logic
{
	public class DownloadPackageLogic : ChromeLogic
	{
		static readonly string[] SizeSuffixes = { "bytes", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB" };
		readonly ModContent.ModDownload download;
		readonly Action onSuccess;

		readonly Widget panel;
		readonly ProgressBarWidget progressBar;

		Func<string> getStatusText = () => "";
		string downloadHost;

		[ObjectCreator.UseCtor]
		public DownloadPackageLogic(Widget widget, ModContent.ModDownload download, Action onSuccess)
		{
			this.download = download;
			this.onSuccess = onSuccess;

			Log.AddChannel("install", "install.log");

			panel = widget.Get("PACKAGE_DOWNLOAD_PANEL");
			progressBar = panel.Get<ProgressBarWidget>("PROGRESS_BAR");

			var statusLabel = panel.Get<LabelWidget>("STATUS_LABEL");
			var statusFont = Game.Renderer.Fonts[statusLabel.Font];
			var status = new CachedTransform<string, string>(s => WidgetUtils.TruncateText(s, statusLabel.Bounds.Width, statusFont));
			statusLabel.GetText = () => status.Update(getStatusText());

			var text = "已下载 {0}".F(download.Title);
			panel.Get<LabelWidget>("TITLE").Text = text;

			ShowDownloadDialog();
		}

		void ShowDownloadDialog()
		{
			getStatusText = () => "获取镜像列表...";
			progressBar.Indeterminate = true;

			var retryButton = panel.Get<ButtonWidget>("RETRY_BUTTON");
			retryButton.IsVisible = () => false;

			var cancelButton = panel.Get<ButtonWidget>("CANCEL_BUTTON");

			var file = Path.Combine(Path.GetTempPath(), Path.GetRandomFileName());

			Action deleteTempFile = () =>
			{
				Log.Write("install", "Deleting temporary file " + file);
				File.Delete(file);
			};

			Action<DownloadProgressChangedEventArgs> onDownloadProgress = i =>
			{
				var dataReceived = 0.0f;
				var dataTotal = 0.0f;
				var mag = 0;
				var dataSuffix = "";

				if (i.TotalBytesToReceive < 0)
				{
					mag = (int)Math.Log(i.BytesReceived, 1024);
					dataReceived = i.BytesReceived / (float)(1L << (mag * 10));
					dataSuffix = SizeSuffixes[mag];

					getStatusText = () => "已从{2}下载 {0:0.00} {1}".F(dataReceived,
						dataSuffix,
						downloadHost ?? "未知主机");
					progressBar.Indeterminate = true;
				}
				else
				{
					mag = (int)Math.Log(i.TotalBytesToReceive, 1024);
					dataTotal = i.TotalBytesToReceive / (float)(1L << (mag * 10));
					dataReceived = i.BytesReceived / (float)(1L << (mag * 10));
					dataSuffix = SizeSuffixes[mag];

					getStatusText = () => "已从{4}下载{1:0.00}/{2:0.00} {3} ({0}%)".F(i.ProgressPercentage,
						dataReceived, dataTotal, dataSuffix,
						downloadHost ?? "未知主机");
					progressBar.Indeterminate = false;
				}

				progressBar.Percentage = i.ProgressPercentage;
			};

			Action<string> onExtractProgress = s => Game.RunAfterTick(() => getStatusText = () => s);

			Action<string> onError = s => Game.RunAfterTick(() =>
			{
				Log.Write("install", "Download failed: " + s);

				progressBar.Indeterminate = false;
				progressBar.Percentage = 100;
				getStatusText = () => "错误: " + s;
				retryButton.IsVisible = () => true;
				cancelButton.OnClick = Ui.CloseWindow;
			});

			Action<AsyncCompletedEventArgs> onDownloadComplete = i =>
			{
				if (i.Cancelled)
				{
					deleteTempFile();
					Game.RunAfterTick(Ui.CloseWindow);
					return;
				}

				if (i.Error != null)
				{
					deleteTempFile();
					onError(Download.FormatErrorMessage(i.Error));
					return;
				}

				// Validate integrity
				if (!string.IsNullOrEmpty(download.SHA1))
				{
					getStatusText = () => "正在验证...";
					progressBar.Indeterminate = true;

					var archiveValid = false;
					try
					{
						using (var stream = File.OpenRead(file))
						{
							var archiveSHA1 = CryptoUtil.SHA1Hash(stream);
							Log.Write("install", "Downloaded SHA1: " + archiveSHA1);
							Log.Write("install", "Expected SHA1: " + download.SHA1);

							archiveValid = archiveSHA1 == download.SHA1;
						}
					}
					catch (Exception e)
					{
						Log.Write("install", "SHA1 calculation failed: " + e.ToString());
					}

					if (!archiveValid)
					{
						onError("验证失败");
						deleteTempFile();
						return;
					}
				}

				// Automatically extract
				getStatusText = () => "正在提取...";
				progressBar.Indeterminate = true;

				var extracted = new List<string>();
				try
				{
					using (var stream = File.OpenRead(file))
					using (var z = new ZipFile(stream))
					{
						foreach (var kv in download.Extract)
						{
							var entry = z.GetEntry(kv.Value);
							if (entry == null || !entry.IsFile)
								continue;

							onExtractProgress("正在提取 " + entry.Name);
							Log.Write("install", "Extracting " + entry.Name);
							var targetPath = Platform.ResolvePath(kv.Key);
							Directory.CreateDirectory(Path.GetDirectoryName(targetPath));
							extracted.Add(targetPath);

							using (var zz = z.GetInputStream(entry))
							using (var f = File.Create(targetPath))
								zz.CopyTo(f);
						}

						z.Close();
					}

					Game.RunAfterTick(() => { Ui.CloseWindow(); onSuccess(); });
				}
				catch (Exception e)
				{
					Log.Write("install", "Archive extraction failed: " + e.ToString());

					foreach (var f in extracted)
					{
						Log.Write("install", "Deleting " + f);
						File.Delete(f);
					}

					onError("提取失败");
				}
				finally
				{
					deleteTempFile();
				}
			};

			Action<string> downloadUrl = url =>
			{
				Log.Write("install", "Downloading " + url);

				downloadHost = new Uri(url).Host;
				var dl = new Download(url, file, onDownloadProgress, onDownloadComplete);
				cancelButton.OnClick = dl.CancelAsync;
				retryButton.OnClick = ShowDownloadDialog;
			};

			if (download.MirrorList != null)
			{
				Log.Write("install", "Fetching mirrors from " + download.MirrorList);

				Action<DownloadDataCompletedEventArgs> onFetchMirrorsComplete = i =>
				{
					progressBar.Indeterminate = true;

					if (i.Cancelled)
					{
						Game.RunAfterTick(Ui.CloseWindow);
						return;
					}

					if (i.Error != null)
					{
						onError(Download.FormatErrorMessage(i.Error));
						return;
					}

					try
					{
						var data = Encoding.UTF8.GetString(i.Result);
						var mirrorList = data.Split(new[] { '\n' }, StringSplitOptions.RemoveEmptyEntries);
						downloadUrl(mirrorList.Random(new MersenneTwister()));
					}
					catch (Exception e)
					{
						Log.Write("install", "Mirror selection failed with error:");
						Log.Write("install", e.ToString());
						onError("在线镜像不可用，请尝试从原光盘安装。");
					}
				};

				var updateMirrors = new Download(download.MirrorList, onDownloadProgress, onFetchMirrorsComplete);
				cancelButton.OnClick = updateMirrors.CancelAsync;
				retryButton.OnClick = ShowDownloadDialog;
			}
			else
				downloadUrl(download.URL);
		}
	}
}
