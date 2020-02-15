SeaEntryPath1 = { SeaEntry1.Location, SeaLanding1.Location }

SeaEntryPath2 = { SeaEntry2.Location, SeaLanding2.Location }

SeaEntryPath3 = { SeaEntry3.Location, SeaLanding3.Location }

SeaEntryPath4 = { SeaEntry4.Location, SeaLanding1.Location }

ParadropPoints = { CPos.New(4,37), CPos.New(3,18), CPos.New(52,43), CPos.New(58,8) }		--Points where troops will be paradropped
ParadropTroops = { "e1", "e1", "sniper", "e4", "e4", "shok", "shok"}		--Troop types to be paradropped

BaseObjects = { Object1, Object2, Object3, Object4, Object5, Object6, Object7, Object8, Object9, Object10, Object11, Object12,  Object13 }

ShipUnitTypes1 = { "e1", "e1", "e2", "3tnk", "3tnk"}
ShipUnitTypes2 = { "e1", "ttnk", "ftrk", "e3", "e3"}
ShipUnitTypes3 = { "e2", "shok", "e4", "v2rl", "shok"}
ShipUnitTypes4 = { "e1", "4tnk", "e2", "ttnk", "ttnk"}

Subs = { "msub", "msub" }

ReinforcePath1 = { ReinforceEntry1.Location, ReinforceStop1.Location }
ReinforcePath2 = { ReinforceEntry2.Location, ReinforceStop2.Location }
ReinforcePath3 = { ReinforceEntry3.Location, ReinforceStop3.Location }
ReinforcePath4 = { ReinforceEntry4.Location, ReinforceStop4.Location }

ScoutTeam1 = { "2tnk", "2tnk", "arty", "arty", "apc"}
ScoutTeam2 = { "e1", "e1", "e1", "e1", "e1", "arty", "2tnk", "2tnk"}
ScoutTeam3 = { "e2", "jeep", "1tnk", "apc", "jeep"}
ScoutTeam4 = { "e3", "e3", "2tnk", "2tnk", "1tnk"}

MCVTeam = { "jeep", "jeep", "mcv", "mnly", "e6", "e6", "e6", "e6" }
MCVPath = { ReinforceEntry1.Location, AlliedBase.Location }
SubPath = { SubPoint1.Location, SubPoint2.Location }

TimeLimitReached = false
delay = 72

---------------------------------------------
--   Sends the MCV when the game starts    --
---------------------------------------------
SendMCV = function()
	local units = Reinforcements.Reinforce(player, MCVTeam, MCVPath, DateTime.Seconds(2))
	local mcv = units[3]
	Trigger.OnKilled(mcv, MissionFailed)
	Media.PlaySpeechNotification(player, "ReinforcementsArrived")
end

SendSubs = function()
    units = Reinforcements.Reinforce(opponent, Subs, SubPath, DateTime.Seconds(2))
	Utils.Do(units, function(unit)
		BindActorTriggers(unit)
	end)
end

------------------------------------
--   Called when the game ends    --
------------------------------------
SendReinforcements = function()
	Reinforcements.Reinforce(player, ScoutTeam1, ReinforcePath1, DateTime.Seconds(2))
	Reinforcements.Reinforce(player, ScoutTeam2, ReinforcePath2, DateTime.Seconds(1))
	Reinforcements.Reinforce(player, ScoutTeam3, ReinforcePath3, DateTime.Seconds(2))
	Reinforcements.Reinforce(player, ScoutTeam4, ReinforcePath4, DateTime.Seconds(1))
	Media.PlaySpeechNotification(player, "ReinforcementsArrived")
	--Trigger.AfterDelay(DateTime.Seconds(30), MissionAccomplished)
	Cleanup()
end


AirStrike = function()
	local lz = AlliedBase.Location
	local start = Map.CenterOfCell(Map.RandomEdgeCell()) + WVec.New(0, 0, Actor.CruiseAltitude("badr"))	
	local bomber = Actor.Create("mig", true, { CenterPosition = start, Owner = opponent, Facing = (Map.CenterOfCell(lz) - start).Facing })
	bomber.AttackMove(AlliedBase.Location)
	if TimeLimitReached == false then
		Trigger.AfterDelay(DateTime.Seconds(10), AirStrike )
	end
end

BindActorTriggers = function(a)
	-- if a.HasProperty("Hunt") then
		-- if a.Owner == opponent then
			-- a.AttackMove(AlliedBase.Location)
			--Trigger.OnIdle(a, a.Hunt)
		-- else
			-- Trigger.OnIdle(a, a.Hunt)
			--Trigger.OnIdle(a, function(a) a.AttackMove(AlliedBase.Location) end)
		-- end
	-- end
	Trigger.OnIdle(a, a.Hunt)
	-- if a.HasProperty("HasPassengers") then
		-- Trigger.OnDamaged(a, function()
			-- if a.HasPassengers then
				-- a.Stop()
				-- a.UnloadPassengers()
			-- end
		-- end)
	-- end
end

ParadropUnits = function()
	local lz = Utils.Random(ParadropPoints)
--	local start = Map.CenterOfCell(Map.RandomEdgeCell()) + WVec.New(0, 0, Actor.CruiseAltitude("badr"))
--	local transport = Actor.Create("badr", true, { CenterPosition = start, Owner = opponent, Facing = (Map.CenterOfCell(lz) - start).Facing })

--	Utils.Do(ParadropTroops, function(type)
--		local a = Actor.Create(type, false, { Owner = opponent })
--		BindActorTriggers(a)
--		transport.LoadPassenger(a)
--	end)

--	transport.Paradrop(lz)

	DetonationPoint = Actor.Create("waypoint", true, { Location = lz, Owner = opponent })
	ParaProxy = Actor.Create("powerproxy.normandie", false, { Owner = opponent })
	ParaTroops = ParaProxy.SendParatroopers(DetonationPoint.CenterPosition)
	Utils.Do(ParaTroops, function(a)
		Trigger.OnAddedToWorld(a, function()
			 if not a.IsDead and a.IsInWorld then BindActorTriggers(a) end
		end)
	end)
	
	if TimeLimitReached == false then
		Trigger.AfterDelay(DateTime.Seconds(30), ParadropUnits)
	end
end

MassParadrop = function()
--	num = 1
--	Utils.Do(ParadropPoints, function(type)
--		local lz = ParadropPoints[num].Location
--		local start = Map.CenterOfCell(Map.RandomEdgeCell()) + WVec.New(0, 0, Actor.CruiseAltitude("badr"))
--		local transport = Actor.Create("badr", true, { CenterPosition = start, Owner = opponent, Facing = (Map.CenterOfCell(lz) - start).Facing })

--		Utils.Do(ParadropTroops, function(type)
--			local a = Actor.Create(type, false, { Owner = opponent })
--			transport.LoadPassenger(a)
--		end)
--		transport.Paradrop(lz)
--		num = num + 1
--	end)
	num = 1
	Utils.Do(ParadropPoints, function(type)
		local lz = ParadropPoints[num]
		DetonationPoint = Actor.Create("waypoint", true, { Location = lz, Owner = opponent })

		ParaProxy = Actor.Create("powerproxy.normandie", false, { Owner = opponent })

		ParaTroops = ParaProxy.SendParatroopers(DetonationPoint.CenterPosition)
		Utils.Do(ParaTroops, function(a)
			Trigger.OnAddedToWorld(a, function()
				 if not a.IsDead and a.IsInWorld then BindActorTriggers(a) end
			end)
		end)
		num = num + 1
	end)
	if TimeLimitReached == false then
		Trigger.AfterDelay(DateTime.Seconds(120), ParadropUnits)
	end
end

ShipSovietUnits1 = function()
	local units = Reinforcements.ReinforceWithTransport(opponent, "lst", ShipUnitTypes1, SeaEntryPath1, { SeaEntry1.Location})[2]

	Utils.Do(units, function(unit)
		BindActorTriggers(unit)
	end)
	if TimeLimitReached == false then
		Trigger.AfterDelay(DateTime.Seconds(delay), ShipSovietUnits1)
	end
end

ShipSovietUnits2 = function()
	local units = Reinforcements.ReinforceWithTransport(opponent, "lst", ShipUnitTypes2, SeaEntryPath2, { SeaEntry2.Location})[2]

	Utils.Do(units, function(unit)
		BindActorTriggers(unit)
	end)
	if TimeLimitReached == false then
		Trigger.AfterDelay(DateTime.Seconds(delay), ShipSovietUnits2)
	end
end

ShipSovietUnits3 = function()
	local units = Reinforcements.ReinforceWithTransport(opponent, "lst", ShipUnitTypes3, SeaEntryPath3, { SeaEntry3.Location})[2]

	Utils.Do(units, function(unit)
		BindActorTriggers(unit)
	end)
	if TimeLimitReached == false then
		Trigger.AfterDelay(DateTime.Seconds(delay), ShipSovietUnits3)
	end
end

ShipSovietUnits4 = function()
	local units = Reinforcements.ReinforceWithTransport(opponent, "lst", ShipUnitTypes4, SeaEntryPath4, { SeaEntry2.Location})[2]

	Utils.Do(units, function(unit)
		BindActorTriggers(unit)
	end)
	if TimeLimitReached == false then
		Trigger.AfterDelay(DateTime.Seconds(delay), ShipSovietUnits4)
	end
	delay = delay - 2
end

--------------------------------------------
--   Called when Mission is successful    --
--------------------------------------------
MissionAccomplished = function()
	Trigger.AfterDelay(DateTime.Seconds(2), function() 
		Media.PlaySpeechNotification(player, "Win")
	end)
	Trigger.AfterDelay(DateTime.Seconds(4), function() 
		player.MarkCompletedObjective(primaryObjective0)
	end)
end

-------------------------------------------
--   Called when Mission is a failure    --
-------------------------------------------
MissionFailed = function()
	Trigger.AfterDelay(DateTime.Seconds(2), function() 
		Media.PlaySpeechNotification(player, "Lose")
	end)
	Trigger.AfterDelay(DateTime.Seconds(4), function() 
		player.MarkFailedObjective(primaryObjective0)
	end)
end

Cleanup = function()
	Trigger.AfterDelay(DateTime.Seconds(30), MissionAccomplished)
end

WorldLoaded = function()

	player = Player.GetPlayer("Allies")
	opponent = Player.GetPlayer("USSR")

	Trigger.OnObjectiveAdded(player, function(p, id)
		Media.DisplayMessage(p.GetObjectiveDescription(id), "新的" .. p.GetObjectiveType(id))
	end)
	Trigger.OnObjectiveCompleted(player, function(p, id) Media.DisplayMessage(p.GetObjectiveDescription(id), "任务目标已完成")	end)
	Trigger.OnObjectiveFailed(player, function(p, id) Media.DisplayMessage(p.GetObjectiveDescription(id), "任务目标已失败") end)

	--Displaying map details
	Media.DisplayMessage(" 诺曼底防御战 || 地图版本：0.95 || 由 Umair Azfar Khan 创作\n" )
	primaryObjective0 = player.AddPrimaryObjective("坚守诺曼底！")
	--secondaryObjective0 = player.AddSecondaryObjective("Destroy the missile subs.")
	
	Trigger.AfterDelay(DateTime.Seconds(5), function() Media.PlaySpeechNotification(player, "TwentyMinutesRemaining") end)
	
	Trigger.AfterDelay(DateTime.Seconds(10), function() SendMCV() end)

	Trigger.OnAllKilled(BaseObjects, MissionFailed)
	Trigger.AfterDelay(DateTime.Seconds(300), ShipSovietUnits1)
	Trigger.AfterDelay(DateTime.Seconds(305), ShipSovietUnits2)
	Trigger.AfterDelay(DateTime.Seconds(450), ShipSovietUnits3)
	Trigger.AfterDelay(DateTime.Seconds(455), ShipSovietUnits4)
	Trigger.AfterDelay(DateTime.Seconds(180), ParadropUnits)
	Trigger.AfterDelay(DateTime.Seconds(720), MassParadrop)
	Trigger.AfterDelay(DateTime.Seconds(900), AirStrike)
	Trigger.AfterDelay(DateTime.Seconds(1200), function() 
		TimeLimitReached = true 
		SendReinforcements()
	end)
	
	if TimeLimitReached == true then
		SendReinforcements()
	end
	--Initializing Camera
	Trigger.AfterDelay(DateTime.Seconds(1), function() Actor.Create("camera", true, { Owner = player, Location = CameraPoint.Location }) end)
	Camera.Position = CameraPoint.CenterPosition			--Centering the map to the Location

end
