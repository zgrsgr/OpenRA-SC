if Map.LobbyOption("difficulty") == "easy" then
	ReinforceCash = 5000
	JammerNum = 5
	TimeDecreased = DateTime.Seconds(60)
	TimerTicks = DateTime.Seconds(600) --Time before arrival. 600
elseif Map.LobbyOption("difficulty") == "normal" then
	ReinforceCash = 3500
	JammerNum = 5
	TimeDecreased = DateTime.Seconds(60)
	TimerTicks = DateTime.Seconds(900) --Time before arrival. 900
else
	ReinforceCash = 2000
	JammerNum = 5
	TimeDecreased = DateTime.Seconds(30)
	TimerTicks = DateTime.Seconds(900) --Time before arrival. 900
end

RescueActivationCoords = { CPos.New(40,30), CPos.New(40,31) }
RescuableBase = 
	{ 
	RescuablePbox1, RescuablePbox2, RescuableRef, RescuableTent, RescuablePower1, RescuablePower2, RescuableInf1, RescuableInf2, 
	RescuableInf3, RescuableInf4, RescuableInf5, RescuableInf6, RescuableInf7,RescuableInf8	
	}
RescuableSandBag = --Rescuable. LoL!
	{
	sbag1, sbag2, sbag3, sbag4, sbag5, sbag6, sbag7, sbag8, sbag9, sbag10, sbag11, sbag12, sbag13, sbag14, sbag15, sbag16, sbag17, sbag18, sbag19	
	}
	
HarassingUnits = { HarassingUnit1, HarassingUnit2, HarassingUnit3, HarassingUnit4 }

FlavorReinforcingInf = { "e1", "e1", "e1", "e3", "e3"}

ReinforcingUnits1 = { "1tnk", "1tnk", "2tnk", "2tnk" }
ReinforcingUnits2 = { "1tnk", "1tnk", "2tnk", "2tnk" }
ReinforcingUnits3 = { "mcv" }
ReinforcementPath = { ReinforceWay.Location, ReinforceDst.Location}

APC1Path = { ReinforceWay.Location, APC1dest.Location + CVec.New(1,-1) }
APC2Path = { ReinforceWay.Location, APC2dest.Location + CVec.New(1,-1) }

ticked = TimerTicks
addtime = true

Jammers = { Jam1, Jam2, Jam3 }
Domes = { Dome1, Dome2 }
JamDevicesDisabled = 0

Dome1Out = false
Dome2Out = false

timerStarted = false
timerEnded = false
BaseRescued = false


FlavorReinforcements = function()
	--Trigger.AfterDelay(DateTime.Seconds(1), function() Reinforcements.Reinforce(player, ReinforcingUnits1, ReinforcementPath, 20) end)
	Trigger.AfterDelay(DateTime.Seconds(1), function()
		local APC1 = Reinforcements.ReinforceWithTransport(player, "apc", FlavorReinforcingInf, APC1Path)
		
		Trigger.AfterDelay(DateTime.Seconds(3), function()
			APC1[1].Stop()
		end)
	
	end)
	Trigger.AfterDelay(DateTime.Seconds(2), function()
		local APC2 = Reinforcements.ReinforceWithTransport(player, "apc", FlavorReinforcingInf, APC2Path)
		
		Trigger.AfterDelay(DateTime.Seconds(3), function()
			APC2[1].Stop()
		end)
	end)
end

--AI REBUILDING START
RunBaseManagment = function()
	Trigger.AfterDelay(1, function()
		BuildBase()
	end)
	
	Utils.Do(Map.NamedActors, function(actor)
		if actor.Owner == enemy and actor.HasProperty("StartBuildingRepairs") then
			Trigger.OnDamaged(actor, function(building)
				if building.Owner == enemy and building.Health < 3/4 * building.MaxHealth then
					building.StartBuildingRepairs()
				end
			end)
		end
	end)
end

Trigger.OnKilled(Jam1, function()
	if timerEnded == false then
		CountJammersKilled()
		RemoveTime(TimeDecreased)
	end
end)

Trigger.OnKilled(Jam2, function()
	if timerEnded == false then
		CountJammersKilled()
		RemoveTime(TimeDecreased)
	end
end)

Trigger.OnKilled(Jam3, function()
	if timerEnded == false then
		CountJammersKilled()
		RemoveTime(TimeDecreased)
	end
end)

Trigger.OnCapture(Dome1, function()
	if timerEnded == false then
		if Dome1Out == false then
			RemoveTime(TimeDecreased)
			CountJammersKilled()
			Dome1Out = true
		end
	end
end)

Trigger.OnCapture(Dome2, function()
	if timerEnded == false then
		if Dome2Out == false then
			RemoveTime(TimeDecreased)
			CountJammersKilled()
			Dome2Out = true
		end
	end
end)

Trigger.OnKilled(Dome1, function()
	if timerEnded == false then
		if Dome1Out == false then
			RemoveTime(TimeDecreased)
			CountJammersKilled()
			Dome1Out = true
		end
	end
end)

Trigger.OnKilled(Dome2, function()
	if timerEnded == false then
		if Dome2Out == false then
			RemoveTime(TimeDecreased)
			CountJammersKilled()
			Dome2Out = true
		end
	end
end)

CountJammersKilled = function()
	JamDevicesDisabled = JamDevicesDisabled + 1
	if JamDevicesDisabled >= JammerNum then
		Media.PlaySpeechNotification(player, "ObjectiveMet")
		player.MarkCompletedObjective(DestroyJammers)
	end
end	

Trigger.OnEnteredFootprint(RescueActivationCoords, function(a, id)
	Trigger.RemoveFootprintTrigger(id)
	if BaseRescued == false then
			RescueBase()
	end
end)

RescueBase = function()
	--Assign resources and units to player
	RescuableHarv = Actor.Create("harv", true, { Owner = player, Location = RescuableRef.Location - CVec.New(-3,0) })
	
	BaseRescued = true
	timerStarted = true
	
	Media.PlaySpeechNotification(player, "ObjectiveReached")
	WaitReinforcements = player.AddPrimaryObjective("在援军到来之前坚守阵地")
	DestroyJammers = player.AddSecondaryObjective("在援军到来之前清除所有苏联雷达站与干扰设备")
	
	player.MarkCompletedObjective(ArriveToBase)
	
	Utils.Do(RescuableBase, function(actor)
		actor.Owner = player
	end)
	Utils.Do(RescuableSandBag, function(actor)
		actor.Owner = player
	end)
	player.Cash = 1500
	
	--Assign units to enemy
	Utils.Do(HarassingUnits, function(actor)
		actor.Owner = enemy
	end)
	
	--Activate AI
	ProduceInfantry()
	ProduceArmor()
	BaseBarr.IsPrimaryBuilding = true
end

SendReinforcements = function()
	--ProduceAircraft()
	player.Cash = player.Cash + ReinforceCash
	
	Trigger.AfterDelay(DateTime.Seconds(1), function() Media.PlaySpeechNotification(player, "ReinforcementsArrived") end)
	Trigger.AfterDelay(DateTime.Seconds(1), function() Reinforcements.Reinforce(player, ReinforcingUnits1, ReinforcementPath, 20) end)
	Trigger.AfterDelay(DateTime.Seconds(1), function() Reinforcements.Reinforce(player, ReinforcingUnits2, ReinforcementPath, 20) end)
	Trigger.AfterDelay(DateTime.Seconds(1), function() Reinforcements.Reinforce(player, ReinforcingUnits3, ReinforcementPath, 20) end)
	Trigger.AfterDelay(DateTime.Seconds(2), function()
		DestroySoviets = player.AddPrimaryObjective("肃清本区域的全部敌人")
	end)
	Trigger.AfterDelay(DateTime.Seconds(3), function()
		player.MarkCompletedObjective(WaitReinforcements)
	end)
	if JamDevicesDisabled < 5 then
		player.MarkFailedObjective(DestroyJammers)
		Media.PlaySpeechNotification(player, "ObjectiveNotMet")
	end
end

AddTime = function()
    if timerEnded == false then 
		ticked = ticked + DateTime.Seconds(60)
	end
end

RemoveTime = function(t)
	if timerEnded == false then 
		if ticked < t then
			ticked = 0
		else
			ticked = ticked - t
			TimerColor = HSLColor.Yellow
			Trigger.AfterDelay(DateTime.Seconds(1), function() TimerColor = HSLColor.White end)
		end
	end
end

FinishTimer = function()
	timerEnded = true
	for i = 0, 5, 1 do
		local c = TimerColor
		if i % 2 == 0 then
			c = HSLColor.White
		end
		
		Trigger.AfterDelay(DateTime.Seconds(i), function() UserInterface.SetMissionText("Time has ended.", c) end)
	end
	Trigger.AfterDelay(DateTime.Seconds(6), function() UserInterface.SetMissionText("") end)
end

Tick = function()
	
	if timerStarted == true then
		if ticked > 0 then
			UserInterface.SetMissionText("距援军抵达还有" .. Utils.FormatTime(ticked), TimerColor)
			ticked = ticked - 1
		elseif ticked == 0 then
			FinishTimer()
			ticked = ticked - 1
			Trigger.AfterDelay(DateTime.Seconds(1), function() SendReinforcements() end)
		end
	end
	
	if player.HasNoRequiredUnits() then
		enemy.MarkCompletedObjective(ussrObj)
	end
	
	if enemy.HasNoRequiredUnits() then
		player.MarkCompletedObjective(DestroySoviets)
	end
	
end

InitTriggers = function()
    Camera.Position = ReinforceDst.CenterPosition
	
	enemy.Cash = 100000
	Trigger.AfterDelay(DateTime.Seconds(20), function() 
		if BaseRescued == false then
			RescueBase()
		end
	end)
	
	FlavorReinforcements()
	
	if Map.LobbyOption("difficulty") == "hard" then
		Actor.Create("3tnk", true, { Owner = enemy, Location = HardHeavyLoc.Location, Facing = 128 })
		Actor.Create("dog", true, { Owner = enemy, Location = HardDogsLoc.Location, SubCell = 1, Facing = 64 })
		Actor.Create("dog", true, { Owner = enemy, Location = HardDogsLoc.Location, SubCell = 2, Facing = 128 })
	end
	
end

InitObjectives = function()
    Trigger.OnObjectiveAdded(player, function(p, id)
		Media.DisplayMessage(p.GetObjectiveDescription(id), "新的" .. string.lower(p.GetObjectiveType(id)))
	end)

	ArriveToBase = player.AddPrimaryObjective("确认前哨站位置")
	ussrObj = enemy.AddPrimaryObjective("消灭盟军")
	
	Trigger.OnObjectiveCompleted(player, function(p, id)
		Media.DisplayMessage(p.GetObjectiveDescription(id), "任务目标已完成")
	end)
	Trigger.OnObjectiveFailed(player, function(p, id)
		Media.DisplayMessage(p.GetObjectiveDescription(id), "任务目标已失败")
	end)
	Trigger.OnPlayerLost(player, function()
		Media.PlaySpeechNotification(player, "MissionFailed")
	end)
	Trigger.OnPlayerWon(player, function()
		Media.PlaySpeechNotification(player, "MissionAccomplished")
	end)
end

WorldLoaded = function()
	player = Player.GetPlayer("Greece")
	enemy = Player.GetPlayer("USSR")

	InitObjectives()
	InitTriggers()
    
    TimerColor = player.Color
	RunBaseManagment()
end
