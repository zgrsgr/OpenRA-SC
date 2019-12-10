if Map.LobbyOption("difficulty") == "easy" then
	SniperType = "sniper"
	DogType = "dog.tracker"
	PlayerTroopsInfiltrators = { "thf.hijacker", "thf.hijacker", "thf.hijacker", "thf.hijacker", "thf.hijacker"}
	CameraActivation = true
elseif Map.LobbyOption("difficulty") == "normal" then
	SniperType = "sniper.noautotarget"
	DogType = "dog.tracker"
	PlayerTroopsInfiltrators = { "thf.hijacker", "thf.hijacker", "thf.hijacker"}
	CameraActivation = true
else	
	SniperType = "sniper.noautotarget"
	DogType = "dog"
	PlayerTroopsInfiltrators = { "thf.hijacker", "thf.hijacker", "thf.hijacker"}
	CameraActivation = false
end

PlayerTroopsSnipers = { SniperType, SniperType, SniperType }
PlayerTroopsTrackers = { DogType, DogType }

Spy = spy_objective
FirstBarrels = {FirstBarrels1, FirstBarrels2, FirstBarrels3, FirstBarrels4}
SecondBarrels = {SecondBarrels1, SecondBarrels2, SecondBarrels3, SecondBarrels4}
SecondBarrels = {SecondBarrels1, SecondBarrels2, SecondBarrels3, SecondBarrels4}
DestroyablePillbox = pbox1base1
DestroyableJeeps = { JeepExp1, HijackableJeep2 }

Hijackables = {HijackableJeep, HijackableJeep2, Hijackable2tnk, HijackableApc, HijackableTran, HijackableLst, Hijackable1tnk}

rescueDone = false
CondDefeat = false

cameraOutpost1Coords = 
	{ 
	CPos.New(18,39), CPos.New(19,39), CPos.New(20,39), CPos.New(31,29), CPos.New(30,30),
	CPos.New(30,30), CPos.New(30,24), CPos.New(30,23), CPos.New(13,37), CPos.New(14,37)
	}
cameraOutpost2Coords = { CPos.New(65,58), CPos.New(66,58), CPos.New(67,58), CPos.New(68,58) }
cameraOutpost3Coords = { CPos.New(23,19), CPos.New(23,20), CPos.New(23,21) }
cameraOutpost4Coords = { CPos.New(58,48), CPos.New(59,48), CPos.New(60,48), CPos.New(61,48) }
cameraOutpost5Coords = 
    { 
    CPos.New(63,29), CPos.New(63,30), CPos.New(63,31), CPos.New(63,32), 
    CPos.New(65,32), CPos.New(66,32), CPos.New(75,20), CPos.New(68,19),
	CPos.New(67,19), CPos.New(68,20), CPos.New(67,20), CPos.New(66,20),
	CPos.New(65,20), CPos.New(64,20), CPos.New(63,20), CPos.New(63,21),
	CPos.New(63,22), CPos.New(62,22)
    }
cameraOutpost6Coords = 
	{ 
	CPos.New(92,20), CPos.New(93,20), CPos.New(94,20), CPos.New(95,20), CPos.New(96,20), CPos.New(96,21) ,
	CPos.New(80,13), CPos.New(81,13)
	}
	
beachCameraCoords = 
{
CPos.New(107,24), CPos.New(108,24), CPos.New(109,24), CPos.New(110,24), CPos.New(111,24), CPos.New(112,24), CPos.New(113,24), CPos.New(114,24), CPos.New(115,24), CPos.New(116,24), CPos.New(117,24), CPos.New(118,24), CPos.New(119,24), CPos.New(120,24), CPos.New(121,24), CPos.New(122,24), CPos.New(123,24), CPos.New(124,24), CPos.New(125,24), CPos.New(126,24), CPos.New(127,24), CPos.New(128,24)
}
	
checkpointCameraCoords = 
{
CPos.New(76,45), CPos.New(76,44), CPos.New(76,43), CPos.New(76,42), CPos.New(77,42), CPos.New(78,42),
CPos.New(80,59), CPos.New(81,59), CPos.New(82,59), CPos.New(83,59), CPos.New(84,59), CPos.New(85,59),
CPos.New(86,59), CPos.New(87,59), CPos.New(88,59)
}

CrashSiteReveal = {CPos.New(30,8), CPos.New(31,8), CPos.New(32,8), CPos.New(33,8), CPos.New(34,8)}

CivSpySpot = { CivSpyWay1.Location, CivSpyWay2.Location }

Patrol0 = {patrol0inf1, patrol0inf2}
Patrol1 = {patrol1inf1, patrol1inf2}
Patrol2 = {patrol2inf1, patrol2inf2}
Patrol3 = {patrol3inf1, patrol3inf2, patrol3inf3}
Patrol4 = {patrol4inf1, patrol4inf2, patrol4inf3, patrol4inf4, patrol4inf5}
Patrol5 = {patrol5inf1, patrol5inf2, patrol5inf3, patrol5inf4}

Patrol0Path = {patrol0way1.Location, patrol0way2.Location}
Patrol1Path = {patrol1way1.Location, patrol1way2.Location, patrol1way3.Location, patrol1way2.Location}
Patrol2Path = {patrol2way1.Location, patrol2way2.Location}
Patrol3Path = 
{
patrol3way1.Location, patrol3way2.Location, patrol3way3.Location, patrol3way4.Location, patrol3way3.Location, patrol3way2.Location
}
Patrol4Path = {patrol4way1.Location, patrol4way2.Location}
Patrol5Path = {patrol5way1.Location, patrol5way2.Location, patrol5way3.Location}

PatrolTime = DateTime.Seconds(3)

IntroSequence = function()
	OuterPatrol1.Move(InfantryTakesPos.Location)
	OuterPatrol2.Move(InfantryTakesPos.Location)
	
	Trigger.AfterDelay(DateTime.Seconds(5), function()
		CivSpy.Move(CivSpyWay1.Location)
	end)
end

Trigger.OnEnteredFootprint(CivSpySpot, function (a, id)
	Trigger.RemoveFootprintTrigger(id)
	Trigger.AfterDelay(DateTime.Seconds(3), GivePlayerUnits)
	Trigger.AfterDelay(DateTime.Seconds(15), startCam.Destroy)
end)

GivePlayerUnits = function()
	Snipers = 
	Reinforcements.Reinforce(player, PlayerTroopsSnipers, {InfiltrationEntry.Location, InfiltrationDst1.Location}, 10)
	
	Reinforcements.Reinforce(player, PlayerTroopsTrackers, {InfiltrationEntry.Location, InfiltrationDst1.Location}, 10)
	Reinforcements.Reinforce(player, PlayerTroopsInfiltrators, {InfiltrationEntry.Location, InfiltrationDst2.Location}, 10)
	
	if Map.LobbyOption("difficulty") ~= "easy" then
		Media.DisplayMessage("我们只有在收到你的确切指令之后才会开火", "狙击手")
	end
	if Map.LobbyOption("difficulty") ~= "hard" then
		Media.DisplayMessage("这些受过特训的军犬可以帮助我们侦察敌情", "狙击手")
	end	
	SniperSurviveObjStart()
end

ActivatePatrols = function()
	GroupPatrol(Patrol0, Patrol0Path, PatrolTime)
	GroupPatrol(Patrol1, Patrol1Path, PatrolTime)
	GroupPatrol(Patrol2, Patrol2Path, PatrolTime)
	GroupPatrol(Patrol3, Patrol3Path, PatrolTime)
	GroupPatrol(Patrol4, Patrol4Path, PatrolTime)
	GroupPatrol(Patrol5, Patrol5Path, PatrolTime)
end

Trigger.OnEnteredFootprint(cameraOutpost1Coords, function(a, id)
    if a.Owner == player then
        Trigger.RemoveFootprintTrigger(id)
        camOut1 = Actor.Create("camera.medium", true, { Owner = player, Location = cameraOutpost1.Location })
    end
end)

Trigger.OnEnteredFootprint(cameraOutpost2Coords, function(a, id)
    if a.Owner == player then
        Trigger.RemoveFootprintTrigger(id)
        camOut2 = Actor.Create("camera.medium", true, { Owner = player, Location = cameraOutpost2.Location })
    end
end)

Trigger.OnEnteredFootprint(cameraOutpost3Coords, function(a, id)
    if a.Owner == player then
        Trigger.RemoveFootprintTrigger(id)
        camOut3 = Actor.Create("camera.medium", true, { Owner = player, Location = cameraOutpost3.Location })
    end
end)

Trigger.OnEnteredFootprint(cameraOutpost4Coords, function(a, id)
    if a.Owner == player then
        Trigger.RemoveFootprintTrigger(id)
        camOut4 = Actor.Create("camera.medium", true, { Owner = player, Location = cameraOutpost4.Location })
    end
end)

Trigger.OnEnteredFootprint(cameraOutpost5Coords, function(a, id)
    if a.Owner == player then
        Trigger.RemoveFootprintTrigger(id)
        camOut5 = Actor.Create("camera.medium", true, { Owner = player, Location = cameraOutpost5.Location })
    end
end)

Trigger.OnEnteredFootprint(cameraOutpost6Coords, function(a, id)
    if a.Owner == player then
        Trigger.RemoveFootprintTrigger(id)
        cam1Out6 = Actor.Create("camera", true, { Owner = player, Location = camera1Outpost6.Location })
		cam2Out6 = Actor.Create("camera", true, { Owner = player, Location = camera2Outpost6.Location })
    end
end)

Trigger.OnEnteredFootprint(beachCameraCoords, function(a, id)
    if a.Owner == player then
        Trigger.RemoveFootprintTrigger(id)
        camBeach = Actor.Create("camera", true, { Owner = player, Location = camerabeach.Location })
    end
end)

Trigger.OnEnteredFootprint(checkpointCameraCoords, function(a, id)
    if a.Owner == player then
        Trigger.RemoveFootprintTrigger(id)
        camCP = Actor.Create("camera", true, { Owner = player, Location = checkpointCamera.Location })
    end
end)

RemoveCameras = function(cam)
	if not cam.IsDead then
		cam.Destroy()
	end
end

GroupPatrol = function(units, waypoints, delay)
	local i = 1
	local stop = false

	Utils.Do(units, function(unit)
		Trigger.OnIdle(unit, function()
			if stop then
				return
			end
			if unit.Location == waypoints[i] then
				local bool = Utils.All(units, function(actor) return actor.IsIdle end)
				if bool then
					stop = true
					i = i + 1
					if i > #waypoints then
						i = 1
					end
					Trigger.AfterDelay(delay, function() stop = false end)
				end
			else
				unit.AttackMove(waypoints[i])
			end
		end)
	end)
end

--BARRELS
Trigger.OnKilled(Wall1Barrel, function() 
	if not DestroyableSbag.IsDead then 
        DestroyableSbag.Kill()
    end
end)

Trigger.OnAnyKilled(FirstBarrels, function() 
	if not DestroyablePillbox.IsDead then
        DestroyablePillbox.Kill()
    end
    if not JeepExp1.IsDead then
        DestroyableJeeps[1].Kill()
    end
end)

Trigger.OnAnyKilled(SecondBarrels, function() 
	if HijackableJeep2.Owner ~= player and HijackableJeep2.Location ~= CPos.New(44,54) then
        DestroyableJeeps[2].Kill()
    else
        return
    end
end)

Trigger.OnEnteredProximityTrigger(CrashSiteLoc.CenterPosition, WDist.FromCells(4), function(a, id)
    if a.Owner == player and rescueDone == false then
        Trigger.RemoveProximityTrigger(id)
		Actor.Create("camera", true, { Owner = player, Location = cameraObjective.Location })
        player.MarkCompletedObjective(FindCrashSite)
		Media.DisplayMessage("已确认目标位置", "Soldier")
    end
end)

Trigger.OnKilled(Spy, function(killed, killedBy) 
	if killedBy.Type == "sniper" or killedBy.Type == "sniper.noautotarget" then
		player.MarkFailedObjective(KillwoSniper)
		player.MarkCompletedObjective(SniperSurvive)
		player.MarkCompletedObjective(KillSpy)
	else
		player.MarkCompletedObjective(KillwoSniper)
		player.MarkCompletedObjective(SniperSurvive)
		player.MarkCompletedObjective(KillSpy)
	end
end)
	
SniperSurviveObjStart = function()
	Trigger.OnAnyKilled(Snipers, function()
		player.MarkFailedObjective(SniperSurvive)
	end)
end

Tick = function()
	if CondDefeat == true then
		if player.HasNoRequiredUnits() then
			enemy.MarkCompletedObjective(DenySoviets)
		end
	end
	
	if enemy.Resources >= enemy.ResourceCapacity then
		enemy.Resources = enemy.ResourceCapacity * 0.75
	end
	
	if HijackableJeep.Owner ~= neutral then
		RemoveCameras(camOut1)
	end
	
	if HijackableTran.Owner ~= enemy then
		RemoveCameras(camOut3)
	end
end

InitObjectives = function()
	Trigger.OnObjectiveAdded(player, function(p, id)
		Media.DisplayMessage(p.GetObjectiveDescription(id), "新的" .. string.lower(p.GetObjectiveType(id)) .. "任务目标")
	end)

	KillSpy = player.AddPrimaryObjective("杀死盟军特务")
	KillwoSniper = player.AddSecondaryObjective("使用狙击手以外的单位杀死盟军特务")
	FindCrashSite = player.AddSecondaryObjective("找到侦察机坠机地点")
	SniperSurvive = player.AddSecondaryObjective("确保全体狙击手安全")
	
	DenySoviets = enemy.AddPrimaryObjective("抵御苏军")

	Trigger.OnObjectiveCompleted(player, function(p, id)
		Media.DisplayMessage(p.GetObjectiveDescription(id), "任务目标已完成")
	end)
	Trigger.OnObjectiveFailed(player, function(p, id)
		Media.DisplayMessage(p.GetObjectiveDescription(id), "任务目标已失败")
	end)

	Trigger.OnPlayerLost(player, function()
		Media.PlaySpeechNotification(player, "Lose")
	end)
	Trigger.OnPlayerWon(player, function()
		Media.PlaySpeechNotification(player, "Win")
	end)
end

InitTriggers = function()
	Camera.Position = StartingCameraLoc.CenterPosition
	startCam = Actor.Create("camera", true, { Owner = player, Location = StartingCameraLoc.Location })
	
	Trigger.AfterDelay(DateTime.Seconds(20), function() 
		CondDefeat = true
	end)
	
	Trigger.AfterDelay(DateTime.Seconds(5), IntroSequence)
end

WorldLoaded = function()
	player = Player.GetPlayer("USSR")
	enemy = Player.GetPlayer("Greece")
	neutral = Player.GetPlayer("Neutral")

	InitObjectives()
	InitTriggers()
	Trigger.AfterDelay(DateTime.Seconds(3), ActivatePatrols)
end