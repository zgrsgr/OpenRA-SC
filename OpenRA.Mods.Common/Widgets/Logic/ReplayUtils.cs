#region Copyright & License Information
/*
 * Copyright 2007-2020 The OpenRA Developers (see AUTHORS)
 * This file is part of OpenRA, which is free software. It is made
 * available to you under the terms of the GNU General Public License
 * as published by the Free Software Foundation, either version 3 of
 * the License, or (at your option) any later version. For more
 * information, see COPYING.
 */
#endregion

using System;
using OpenRA.FileFormats;

namespace OpenRA.Mods.Common.Widgets.Logic
{
	public static class ReplayUtils
	{
		static readonly Action DoNothing = () => { };

		public static bool PromptConfirmReplayCompatibility(ReplayMetadata replayMeta, Action onCancel = null)
		{
			if (onCancel == null)
				onCancel = DoNothing;

			if (replayMeta == null)
			{
				ConfirmationDialogs.ButtonPrompt("不兼容的录像", "无法读取录像元数据。", onCancel: onCancel);
				return false;
			}

			var version = replayMeta.GameInfo.Version;
			if (version == null)
				return IncompatibleReplayDialog("未知版本", version, onCancel);

			var mod = replayMeta.GameInfo.Mod;
			if (mod == null)
				return IncompatibleReplayDialog("未知mod", mod, onCancel);

			if (!Game.Mods.ContainsKey(mod))
				return IncompatibleReplayDialog("不可用的mod", mod, onCancel);

			if (Game.Mods[mod].Metadata.Version != version)
				return IncompatibleReplayDialog("不兼容的版本", version, onCancel);

			if (replayMeta.GameInfo.MapPreview.Status != MapStatus.Available)
				return IncompatibleReplayDialog("不可用的地图", replayMeta.GameInfo.MapUid,  onCancel);

			return true;
		}

		static bool IncompatibleReplayDialog(string type, string name, Action onCancel)
		{
			var error = "这个录像有一个问题， " + type;
			error += string.IsNullOrEmpty(name) ? "。" : ":\n{0}".F(name);

			ConfirmationDialogs.ButtonPrompt("不兼容的录像", error, onCancel: onCancel);

			return false;
		}
	}
}
