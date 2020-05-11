--[[
   Copyright 2007-2020 The OpenRA Developers (see AUTHORS)
   This file is part of OpenRA, which is free software. It is made
   available to you under the terms of the GNU General Public License
   as published by the Free Software Foundation, either version 3 of
   the License, or (at your option) any later version. For more
   information, see COPYING.
]]
AlliedBoatReinforcements = { "dd", "dd" }
TimerTicks = DateTime.Minutes(21)
ObjectiveBuildings = { Chronosphere, AlliedTechCenter }
ScientistTypes = { "chan", "chan", "chan", "chan" }
ScientistDiscoveryFootprint = { CPos.New(99, 63), CPos.New(99, 64), CPos.New(99, 65), CPos.New(99, 66), CPos.New(99, 67), CPos.New(100, 63), CPos.New(101, 63), CPos.New(102, 63), CPos.New(103, 63) }
ScientistEvacuationFootprint = { CPos.New(98, 88), CPos.New(98, 87), CPos.New(99, 87), CPos.New(100, 87), CPos.New(101, 87), CPos.New(102, 87), CPos.New(103, 87) }

InitialAlliedReinforcements = function()
	Trigger.AfterDelay(DateTime.Seconds(2), function()
		Media.PlaySpeechNotification(greece, "ReinforcementsArrived")
		Reinforcements.Reinforce(greece, { "mcv" }, { MCVEntry.Location, MCVStop.Location })
		Reinforcements.Reinforce(greece, AlliedBoatReinforcements, { DDEntry.Location, DDStop.Location })
	end)
end

CreateScientists = function()
	scientists = Reinforcements.Reinforce(greece, ScientistTypes, { ScientistsExit.Location })
	Utils.Do(scientists, function(s)
		s.Move(s.Location + CVec.New(0, 1))
		s.Scatter()
	end)

	local flare = Actor.Create("flare", true, { Owner = greece, Location = DefaultCameraPosition.Location + CVec.New(-1, 0) })
	Trigger.AfterDelay(DateTime.Seconds(2), function() Media.PlaySpeechNotification(player, "SignalFlareSouth") end)

	Trigger.OnAnyKilled(scientists, function()
		Media.PlaySpeechNotification(greece, "ObjectiveNotMet")
		greece.MarkFailedObjective(EvacuateScientists)
	end)

	-- Add the footprint trigger in a frame end task (delay 0) to avoid crashes
	local left = #scientists
	Trigger.AfterDelay(0, function()
		local changeOwnerTrigger = Trigger.OnEnteredFootprint(ScientistEvacuationFootprint, function(a, id)
			if a.Owner == greece and a.Type == "chan" then
				a.Owner = england
				a.Stop()
				a.Move(MCVEntry.Location)

				-- Constantly try to reach the exit (and thus avoid getting stuck if the path was blocked)
				Trigger.OnIdle(a, function()
					a.Move(MCVEntry.Location)
				end)
			end
		end)

		-- Use a cell trigger to destroy the scientists preventing the player from causing glitchs by blocking the path
		Trigger.OnEnteredFootprint({ MCVEntry.Location }, function(a, id)
			if a.Owner == england then
				a.Stop()
				a.Destroy()

				left = left - 1
				if left == 0 then
					Trigger.RemoveFootprintTrigger(id)
					Trigger.RemoveFootprintTrigger(changeOwnerTrigger)
					flare.Destroy()

					if not greece.IsObjectiveCompleted(EvacuateScientists) and not greece.IsObjectiveFailed(EvacuateScientists) then
						Media.PlaySpeechNotification(greece, "ObjectiveMet")
						greece.MarkCompletedObjective(EvacuateScientists)
					end
				end
			end
		end)
	end)
end

FinishTimer = function()
	for i = 0, 5 do
		local c = TimerColor
		if i % 2 == 0 then
			c = HSLColor.White
		end

		Trigger.AfterDelay(DateTime.Seconds(i), function() UserInterface.SetMissionText("实验成功了！", c) end)
	end
	Trigger.AfterDelay(DateTime.Seconds(6), function() UserInterface.SetMissionText("") end)
end

DefendChronosphereCompleted = function()
	local cells = Utils.ExpandFootprint({ ChronoshiftLocation.Location }, false)
	local units = { }
	for i = 1, #cells do
		local unit = Actor.Create("2tnk", true, { Owner = greece, Facing = 0 })
		units[unit] = cells[i]
	end
	Chronosphere.Chronoshift(units)

	Trigger.AfterDelay(DateTime.Seconds(3), function()
		greece.MarkCompletedObjective(DefendChronosphere)
		greece.MarkCompletedObjective(KeepBasePowered)
	end)
end

ticked = TimerTicks
Tick = function()
	ussr.Cash = 5000

	if ussr.HasNoRequiredUnits() then
		greece.MarkCompletedObjective(DefendChronosphere)
		greece.MarkCompletedObjective(KeepBasePowered)
	end

	if greece.HasNoRequiredUnits() then
		ussr.MarkCompletedObjective(BeatAllies)
	end

	if ticked > 0 then
		UserInterface.SetMissionText("超时空技术实验将在" .. Utils.FormatTime(ticked) .. "后完成", TimerColor)
		ticked = ticked - 1
	elseif ticked == 0 and (greece.PowerState ~= "Normal") then
		greece.MarkFailedObjective(KeepBasePowered)
	elseif ticked == 0 then
		DefendChronosphereCompleted()
		ticked = ticked - 1
	end
end

WorldLoaded = function()
	greece = Player.GetPlayer("Greece")
	ussr = Player.GetPlayer("USSR")
	england = Player.GetPlayer("England")

	DefendChronosphere = greece.AddPrimaryObjective("不惜一切代价保护超时空传送仪和科技中心。")
	KeepBasePowered = greece.AddPrimaryObjective("计时结束时，确保超时空传送仪供电稳定。")
	EvacuateScientists = greece.AddSecondaryObjective("救援并撤离岛上的科学家到指定地点。")
	BeatAllies = ussr.AddPrimaryObjective("击败盟军的部队。")

	Trigger.OnObjectiveAdded(greece, function(p, id)
		Media.DisplayMessage(p.GetObjectiveDescription(id), "新的" .. string.lower(p.GetObjectiveType(id)))
	end)
	Trigger.OnObjectiveCompleted(greece, function(p, id)
		Media.DisplayMessage(p.GetObjectiveDescription(id), "目标完成")
	end)
	Trigger.OnObjectiveFailed(greece, function(p, id)
		Media.DisplayMessage(p.GetObjectiveDescription(id), "目标失败")
	end)

	Trigger.OnPlayerLost(greece, function()
		Trigger.AfterDelay(DateTime.Seconds(1), function()
			Media.PlaySpeechNotification(greece, "MissionFailed")
		end)
	end)
	Trigger.OnPlayerWon(greece, function()
		Trigger.AfterDelay(DateTime.Seconds(1), function()
			Media.PlaySpeechNotification(greece, "MissionAccomplished")
		end)
	end)

	Trigger.AfterDelay(DateTime.Minutes(1), function()
		Media.PlaySpeechNotification(greece, "TwentyMinutesRemaining")
	end)
	Trigger.AfterDelay(DateTime.Minutes(11), function()
		Media.PlaySpeechNotification(greece, "TenMinutesRemaining")
	end)
	Trigger.AfterDelay(DateTime.Minutes(16), function()
		Media.PlaySpeechNotification(greece, "WarningFiveMinutesRemaining")
	end)
	Trigger.AfterDelay(DateTime.Minutes(18), function()
		Media.PlaySpeechNotification(greece, "WarningThreeMinutesRemaining")
	end)
	Trigger.AfterDelay(DateTime.Minutes(20), function()
		Media.PlaySpeechNotification(greece, "WarningOneMinuteRemaining")
	end)

	PowerProxy = Actor.Create("powerproxy.paratroopers", false, { Owner = ussr })

	Camera.Position = DefaultCameraPosition.CenterPosition
	TimerColor = greece.Color

	Trigger.OnAnyKilled(ObjectiveBuildings, function()
		greece.MarkFailedObjective(DefendChronosphere)
	end)

	Trigger.OnEnteredFootprint(ScientistDiscoveryFootprint, function(a, id)
		if a.Owner == greece and not scientistsTriggered then
			scientistsTriggered = true
			Trigger.RemoveFootprintTrigger(id)
			CreateScientists()
		end
	end)

	InitialAlliedReinforcements()
	ActivateAI()
end
