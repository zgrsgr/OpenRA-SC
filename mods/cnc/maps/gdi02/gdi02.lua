	--[[
   Copyright 2007-2019 The OpenRA Developers (see AUTHORS)
   This file is part of OpenRA, which is free software. It is made
   available to you under the terms of the GNU General Public License
   as published by the Free Software Foundation, either version 3 of
   the License, or (at your option) any later version. For more
   information, see COPYING.
]]
nodInBaseTeam = { RushBuggy, RushRifle1, RushRifle2, RushRifle3 }
MobileConstructionVehicle = { "mcv" }
EngineerReinforcements = { "e6", "e6", "e6" }
VehicleReinforcements = { "jeep" }

AttackerSquadSize = 3

ReinforceWithLandingCraft = function(units, transportStart, transportUnload, rallypoint)
	local transport = Actor.Create("oldlst", true, { Owner = player, Facing = 0, Location = transportStart })
	local subcell = 0
	Utils.Do(units, function(a)
		transport.LoadPassenger(Actor.Create(a, false, { Owner = transport.Owner, Facing = transport.Facing, Location = transportUnload, SubCell = subcell }))
		subcell = subcell + 1
	end)

	transport.ScriptedMove(transportUnload)

	transport.CallFunc(function()
		Utils.Do(units, function()
			local a = transport.UnloadPassenger()
			a.IsInWorld = true
			a.MoveIntoWorld(transport.Location - CVec.New(0, 1))

			if rallypoint ~= nil then
				a.Move(rallypoint)
			end
		end)
	end)

	transport.Wait(5)
	transport.ScriptedMove(transportStart)
	transport.Destroy()
end

Reinforce = function(units)
	Media.PlaySpeechNotification(player, "Reinforce")
	ReinforceWithLandingCraft(units, lstStart.Location, lstEnd.Location)
end

BridgeheadSecured = function()
	Reinforce(MobileConstructionVehicle)
	Trigger.AfterDelay(DateTime.Seconds(15), NodAttack)
	Trigger.AfterDelay(DateTime.Seconds(30), function() Reinforce(EngineerReinforcements) end)
	Trigger.AfterDelay(DateTime.Seconds(120), function() Reinforce(VehicleReinforcements) end)
end

NodAttack = function()
	local nodUnits = enemy.GetGroundAttackers()
	if #nodUnits > AttackerSquadSize * 2 then
		local attackers = Utils.Skip(nodUnits, #nodUnits - AttackerSquadSize)
		Utils.Do(attackers, function(unit)
			unit.AttackMove(NodAttackWaypoint.Location)
			Trigger.OnIdle(unit, unit.Hunt)
		end)
		Trigger.OnAllKilled(attackers, function() Trigger.AfterDelay(DateTime.Seconds(15), NodAttack) end)
	end
end

WorldLoaded = function()
	player = Player.GetPlayer("GDI")
	enemy = Player.GetPlayer("Nod")

	Trigger.OnObjectiveAdded(player, function(p, id)
		Media.DisplayMessage(p.GetObjectiveDescription(id), "新的" .. string.lower(p.GetObjectiveType(id)))
	end)
	Trigger.OnObjectiveCompleted(player, function(p, id)
		Media.DisplayMessage(p.GetObjectiveDescription(id), "目标完成")
	end)
	Trigger.OnObjectiveFailed(player, function(p, id)
		Media.DisplayMessage(p.GetObjectiveDescription(id), "目标失败")
	end)

	Trigger.OnPlayerWon(player, function()
		Media.PlaySpeechNotification(player, "Win")
	end)

	Trigger.OnPlayerLost(player, function()
		Media.PlaySpeechNotification(player, "Lose")
	end)

	nodObjective = enemy.AddPrimaryObjective("消灭所有GDI单位")
	gdiObjective1 = player.AddPrimaryObjective("肃清所有Nod武装力量")
	gdiObjective2 = player.AddSecondaryObjective("占领泰伯利亚精炼厂")

	Trigger.OnCapture(NodRefinery, function() player.MarkCompletedObjective(gdiObjective2) end)
	Trigger.OnKilled(NodRefinery, function() player.MarkFailedObjective(gdiObjective2) end)

	Trigger.OnAllKilled(nodInBaseTeam, BridgeheadSecured)
end

Tick = function()
	if player.HasNoRequiredUnits() then
		enemy.MarkCompletedObjective(nodObjective)
	end
	if enemy.HasNoRequiredUnits() then
		player.MarkCompletedObjective(gdiObjective1)
	end
end
