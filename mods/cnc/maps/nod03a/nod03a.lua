--[[
   Copyright 2007-2019 The OpenRA Developers (see AUTHORS)
   This file is part of OpenRA, which is free software. It is made
   available to you under the terms of the GNU General Public License
   as published by the Free Software Foundation, either version 3 of
   the License, or (at your option) any later version. For more
   information, see COPYING.
]]
NodUnits = { "bike", "e3", "e1", "bggy", "e1", "e3", "bike", "bggy" }
FirstAttackWave = { "e1", "e1", "e1", "e2", }
SecondThirdAttackWave = { "e1", "e1", "e2", }

SendAttackWave = function(units, spawnPoint)
	Reinforcements.Reinforce(enemy, units, { spawnPoint }, DateTime.Seconds(1), function(actor)
		actor.AttackMove(PlayerBase.Location)
	end)
end

InsertNodUnits = function()
	Media.PlaySpeechNotification(player, "Reinforce")
	Reinforcements.Reinforce(player, NodUnits, { NodEntry.Location, NodRallyPoint.Location })
	Trigger.AfterDelay(DateTime.Seconds(9), function()
		Reinforcements.Reinforce(player, { "mcv" }, { NodEntry.Location, PlayerBase.Location })
	end)
end

WorldLoaded = function()
	player = Player.GetPlayer("Nod")
	enemy = Player.GetPlayer("GDI")

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

	gdiObjective = enemy.AddPrimaryObjective("消灭所有敌人")
	nodObjective1 = player.AddPrimaryObjective("占领监狱")
	nodObjective2 = player.AddSecondaryObjective("消灭所有敌人")

	Trigger.OnCapture(TechCenter, function()
		Trigger.AfterDelay(DateTime.Seconds(2), function()
			player.MarkCompletedObjective(nodObjective1)
		end)
	end)

	Trigger.OnKilled(TechCenter, function()
		player.MarkFailedObjective(nodObjective1)
	end)

	InsertNodUnits()
	Trigger.AfterDelay(DateTime.Seconds(20), function() SendAttackWave(FirstAttackWave, AttackWaveSpawnA.Location) end)
	Trigger.AfterDelay(DateTime.Seconds(50), function() SendAttackWave(SecondThirdAttackWave, AttackWaveSpawnB.Location) end)
	Trigger.AfterDelay(DateTime.Seconds(100), function() SendAttackWave(SecondThirdAttackWave, AttackWaveSpawnC.Location) end)
end

Tick = function()
	if DateTime.GameTime > 2 then
		if player.HasNoRequiredUnits() then
			enemy.MarkCompletedObjective(gdiObjective)
		end
		if enemy.HasNoRequiredUnits() then
			player.MarkCompletedObjective(nodObjective2)
		end
	end
end
