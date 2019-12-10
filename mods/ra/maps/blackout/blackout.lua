

if Map.LobbyOption("difficulty") == "easy" then
	remainingTime = DateTime.Seconds(210)
    SpyType = "spy"
    SpyTypeAfterObj = "spy.afterdome"
    InfiltratedSquad = { "medi", "e3.defendstance", "e3.defendstance", "e1.defendstance", "e1.defendstance" }
    AddedTime = DateTime.Minutes(15)
elseif Map.LobbyOption("difficulty") == "normal" then
	remainingTime = DateTime.Seconds(150)
    SpyType = "spy"
    SpyTypeAfterObj = "spy.afterdome"
    InfiltratedSquad = { "medi", "e3.defendstance", "e3.defendstance", "e1.defendstance", "e1.defendstance" }
    AddedTime = DateTime.Minutes(12)
else 
    remainingTime = DateTime.Seconds(90)
    SpyType = "spy.unarmed"
    SpyTypeAfterObj = "spy.afterdomeunarmed"
    InfiltratedSquad = { "medi", "e3.defendstance", "e3.defendstance", "e1.defendstance", "e1.defendstance" }
    AddedTime = DateTime.Minutes(10)
end

removedCamAbyRadar = false
removedCamBbyRadar = false
removedCamCbyRadar = false
removedCamMbyRadar = false

removedCamAbyPower = false
removedCamBbyPower = false
removedCamCbyPower = false
removedCamMbyPower = false

cameraA_created = false
cameraB_created = false
cameraC_created = false
cameraM_created = false

destroyedPowerA = false
destroyedPowerB = false
destroyedPowerC = false
destroyedPowerM = false

timerStarted = true
addtime = false
AfterInfDome = false
TranPathA = { TranInsertion.Location, CPos.New(12,32) }
TranPathB = { TranInsertion.Location, Flare.Location }
TranPathC = { TranInsertion.Location, MainBaseCam.Location }
TransInsertionType = "tran.insertion"
ObjSamsA = { ObjSamA1, ObjSamA2, ObjSamA3 }
ObjSamsB = { ObjSamB1, ObjSamB2, ObjSamB3 }
ObjSamsC = { ObjSamC1, ObjSamC2, ObjSamC3, ObjSamC4 }
ObjSams = { ObjSamA1, ObjSamA2, ObjSamA3, ObjSamB1, ObjSamB2, ObjSamB3, ObjSamC1, ObjSamC2, ObjSamC3, ObjSamC4 }
PatrolA = { PatrolA00, PatrolA01, PatrolA02, PatrolA03 }
PatrolB = { PatrolB00, PatrolB01, PatrolB02 }
PatrolC = { PatrolC00, PatrolC01, PatrolC02, PatrolC03, PatrolC04 }
PatrolAPath = { PatrolAWay3.Location, PatrolAWay1.Location, PatrolAWay2.Location, PatrolAWay1.Location }
PatrolBPath = { PatrolBWay1.Location, PatrolBWay2.Location }
PatrolCPath = { PatrolCWay1.Location, PatrolCWay2.Location }
InfiltrationPoint = { InfiltrationSpawn.Location, InfiltrationTarget.Location }
Convoy = { "truk.mission" }
ConvoyPathA = { ConvoyStart.Location, ConvoyWay01.Location, ConvoyWay02.Location, ConvoyEndA.Location } 
ConvoyPathB = { ConvoyStart.Location, ConvoyWay01.Location, ConvoyWay02.Location, ConvoyEndB.Location }
ConvoyPathC = { ConvoyStart.Location, ConvoyWay01.Location, ConvoyWay02.Location, ConvoyEndC.Location }
AlliedConvoyPath = { ConvoyStart.Location, InfiltrationSpawn.Location,  }
RadardomeVisionTrigger = { CPos.New(36,8), CPos.New(41,14), CPos.New(42,14), CPos.New(42,15), CPos.New(43,15), CPos.New(44,15), CPos.New(45,15), CPos.New(45,14), CPos.New(46,14) }

            
PowerSupply = 
{ 
    BaseAPower00, BaseAPower01, BaseAPower02, BaseAPower03, BaseBPower00, BaseBPower01, 
    BaseBPower02, BaseCPower00, BaseCPower01, BaseCPower02, BaseCPower03, 
    MainBasePower02, MainBasePower03, MainBasePower04, MainBasePower04, MainBasePower05, 
    MainBasePower06, MainBasePower07, MainBasePower08, MainBasePower09 
}


SetupAlliedUnits = function()
	
    Spy = Actor.Create(SpyType, true, { Owner = player, Location = EnglandSpy.Location, Facing = 128 })
	Camera.Position = Spy.CenterPosition
	
    Trigger.AfterDelay(DateTime.Seconds(1), function()
    
    end)
	
    Trigger.AfterDelay(DateTime.Seconds(12), function()USSR00.AttackMove(SpyReturn.Location) end)
    
	StartingCam = Actor.Create("camera", true, { Owner = player, Location = StartingCamera1.Location })
    
    Trigger.OnKilled(Spy, function() 
        ussr.MarkCompletedObjective(ussrObj) 
    end) 

end

    
SquadInsertionA = function()
    local flare = Actor.Create("flare", true, { Owner = player, Location = BaseACam.Location })
    Trigger.AfterDelay(DateTime.Seconds(22), flare.Destroy) 
    Media.PlaySpeechNotification(player, "SignalFlare")
    Trigger.AfterDelay(DateTime.Seconds(1), function() Media.PlaySpeechNotification(allies, "AlliedReinforcementsArrived") end)
    trans1 = Reinforcements.ReinforceWithTransport(player, TransInsertionType, InfiltratedSquad, TranPathA, { TranInsertion.Location })[2]
    --local InsertionA = Actor.Create("camera.tesla", true, { Owner = player, Location = BaseACam.Location })
    --Trigger.AfterDelay(DateTime.Seconds(21), InsertionA.Destroy)
end

SquadInsertionB = function()
    local flare = Actor.Create("flare", true, { Owner = player, Location = Flare.Location })
    Trigger.AfterDelay(DateTime.Seconds(22), flare.Destroy)
    Media.PlaySpeechNotification(player, "SignalFlare")
    Trigger.AfterDelay(DateTime.Seconds(2), function() Media.PlaySpeechNotification(player, "AlliedReinforcementsArrived") end) 
    trans2 = Reinforcements.ReinforceWithTransport(player, TransInsertionType, InfiltratedSquad, TranPathB, { TranInsertion.Location })[2]
    --local InsertionB = Actor.Create("camera.tesla", true, { Owner = player, Location = Flare.Location })
    --Trigger.AfterDelay(DateTime.Seconds(21), InsertionB.Destroy)    
end

SquadInsertionC = function()
    local flare = Actor.Create("flare", true, { Owner = player, Location = MainBaseCam.Location })
    Trigger.AfterDelay(DateTime.Seconds(22), flare.Destroy)  
    Media.PlaySpeechNotification(player, "SignalFlare")
    Trigger.AfterDelay(DateTime.Seconds(2), function() Media.PlaySpeechNotification(player, "AlliedReinforcementsArrived") end)
    trans3 = Reinforcements.ReinforceWithTransport(player, TransInsertionType, InfiltratedSquad, TranPathC, { TranInsertion.Location })[2]    
    --local InsertionC = Actor.Create("camera.tesla", true, { Owner = player, Location = BaseACam.Location })
    --Trigger.AfterDelay(DateTime.Seconds(21), InsertionC.Destroy)
end


AddTime = function()
    addtime = true
    remainingTime = remainingTime + AddedTime
    Trigger.AfterDelay(DateTime.Seconds(1), function() addtime = false end)
end


Tick = function()
	
    if remainingTime == DateTime.Minutes(10) then
        Media.PlaySpeechNotification(player, "TenMinutesRemaining")
    elseif remainingTime == DateTime.Minutes(5) then
        Media.PlaySpeechNotification(player, "WarningFiveMinutesRemaining")
    elseif remainingTime == DateTime.Minutes(4) then
        Media.PlaySpeechNotification(player, "WarningFourMinutesRemaining")
    elseif remainingTime == DateTime.Minutes(3) then
        Media.PlaySpeechNotification(player, "WarningThreeMinutesRemaining")
    elseif remainingTime == DateTime.Minutes(2) then
        Media.PlaySpeechNotification(player, "WarningTwoMinutesRemaining")
    elseif remainingTime == DateTime.Minutes(1) then
        Media.PlaySpeechNotification(player, "WarningOneMinuteRemaining")
    end

    if remainingTime > 0 and timerStarted then
        UserInterface.SetMissionText("距离苏军通讯重启完毕还有 " .. Utils.FormatTime(remainingTime), player.Color)
        if not addtime then
            remainingTime = remainingTime - 1
        end
    elseif remainingTime == 0 then
        UserInterface.SetMissionText("")
        ussr.MarkCompletedObjective(ussrObj)
    end
        
    if initialized and player.HasNoRequiredUnits() then
        ussr.MarkCompletedObjective(ussrObj)
    end
    
       
end
    
InitTriggers = function()
    
    Actor.Create("camera.map", true, { Owner = ussr, Location = MapCamera1.Location }) --Enemy  Map vision.
    Actor.Create("camera.map", true, { Owner = ussr, Location = MapCamera2.Location })
    
    
	Trigger.OnInfiltrated(Radardome, function()
        Trigger.ClearAll(Spy)
        player.MarkCompletedObjective(infRadardome)
        AfterInfDome = true
        AddTime()
        destroySams = player.AddSecondaryObjective("清除敌方的防空阵地以确保援军的安全抵达")

        Trigger.AfterDelay(DateTime.Seconds(1), function()
           
            if Map.LobbyOption("difficulty") == "easy" then
                alliedDome = Actor.Create("dome", true, { Owner = player, Location = OffmapRadar.Location })
                alliedPower = Actor.Create("powr", true, { Owner = player, Location = OffmapPower.Location })
                vision_tesla1 = Actor.Create("camera.tesla", true, { Owner = player, Location = TeslaCam00.Location })
                vision_tesla2 = Actor.Create("camera.tesla", true, { Owner = player, Location = TeslaCam01.Location })
                vision_tesla3 = Actor.Create("camera.tesla", true, { Owner = player, Location = TeslaCam02.Location })
                vision_tesla4 = Actor.Create("camera.tesla", true, { Owner = player, Location = TeslaCam03.Location })
                vision_tesla5 = Actor.Create("camera.tesla", true, { Owner = player, Location = TeslaCam04.Location })
            end
            
            if destroyedPowerA == false then
                if Map.LobbyOption("difficulty") == "easy" or Map.LobbyOption("difficulty") == "normal" then
                    BaseACamera = Actor.Create("camera.base", true, { Owner = player, Location = BaseACam.Location })
                    cameraA_created = true
                end
            end
            
            if destroyedPowerB == false then
                if Map.LobbyOption("difficulty") == "easy" or Map.LobbyOption("difficulty") == "normal" then
                    BaseBCamera = Actor.Create("camera.base", true, { Owner = player, Location = Flare.Location })
                    cameraB_created = true
                end
            end
            
            if destroyedPowerC == false then
                if Map.LobbyOption("difficulty") == "easy" or Map.LobbyOption("difficulty") == "normal" then    
                    BaseCCamera = Actor.Create("camera.base", true, { Owner = player, Location = BaseCCam.Location })
                    cameraC_created = true
                end
            end        
            if destroyedPowerM == false then
                if Map.LobbyOption("difficulty") == "easy" or Map.LobbyOption("difficulty") == "normal" then
                    MainBaseCamera = Actor.Create("camera.base", true, { Owner = player, Location = MainBaseCam.Location })
                    cameraM_created = true
                end
            end
            
            Spy = Actor.Create(SpyTypeAfterObj, true, { Owner = player, Location = Radardome.Location })
            Spy.DisguiseAsType("e1", ussr)
            Spy.Move(SpyReturn.Location)
            Trigger.OnKilled(Spy, function() 
                ussr.MarkCompletedObjective(ussrObj) 
            end) 
        end)     
        
      
	end)
    
        Trigger.OnAllKilled({ BaseAPower00, BaseAPower01, BaseAPower02, BaseAPower03 }, function() 
        destroyedPowerA = true
        if cameraA_created == true then    
            if removedCamAbyRadar == false then 
                BaseACamera.Destroy()
                removedCamAbyPower = true
            end
        end
    end)
   
    Trigger.OnAllKilled({BaseBPower00, BaseBPower01, BaseBPower02}, function()
        destroyedPowerB = true
        if cameraB_created == true then
            if removedCamBbyRadar == false then 
                BaseBCamera.Destroy()
                removedCamBbyPower = true
            end
        end
    end)
    
    Trigger.OnAllKilled({ BaseCPower00, BaseCPower01, BaseCPower02, BaseCPower03 }, function()
        destroyedPowerC = true
        if cameraC_created == true then
            if removedCamCbyRadar == false then 
                BaseCCamera.Destroy()
                removedCamCbyPower = true
            end
        end
	end)
    
    Trigger.OnAllKilled({ MainBasePower02, MainBasePower03, MainBasePower04, MainBasePower04, MainBasePower05, MainBasePower06, MainBasePower07, MainBasePower08, MainBasePower09 }, function()
        destroyedPowerM = true
        if cameraM_created == true then
            if removedCamMbyRadar == false then
                MainBaseCamera.Destroy() 
                removedCamMbyPower = true
            end
        end
	end)

    Trigger.OnKilled(Radardome, function()
        if DomeCam then 
            DomeCam.Destroy() 
        end
        
        if removedCamAbyPower == false then
            removedCamAbyRadar = true
            BaseACamera.Destroy()
        end
        
        if removedCamBbyPower == false then
            removedCamBbyRadar = true
            BaseBCamera.Destroy()
        end
        
        if removedCamCbyPower == false then
            removedCamCbyRadar = true 
            BaseCCamera.Destroy()
        end
        
        if removedCamMbyPower == false then
            removedCamMbyRadar = true
            MainBaseCamera.Destroy()
        end
        
        if AfterInfDome == false then ussr.MarkCompletedObjective(ussrObj)
        
        else
            if AfterInfDome == true and Map.LobbyOption("difficulty") == "easy" then
                alliedPower.Destroy()
                alliedDome.Destroy()
                vision_tesla1.Destroy()
                vision_tesla2.Destroy()
                vision_tesla3.Destroy()
                vision_tesla4.Destroy()
                vision_tesla5.Destroy()
            end
        end
    end)
    
    Trigger.OnAllKilled(ObjSamsA, function()
        Trigger.AfterDelay(0, SquadInsertionA)
    end)
    
    Trigger.OnAllKilled(ObjSamsB, function()
        Trigger.AfterDelay(0, SquadInsertionB)
    end)
    
    Trigger.OnAllKilled(ObjSamsC, function()
        Trigger.AfterDelay(0, SquadInsertionC)
    end)
    
    Trigger.OnAllKilled(ObjSams, function()
            player.MarkCompletedObjective(destroySams)
    end)
    
    Trigger.OnEnteredFootprint(RadardomeVisionTrigger, function(a, id)
	if a.Owner == player then
            DomeCam = Actor.Create("camera.base", true, { Owner = player, Location = RadardomeVision.Location }) 
            Trigger.RemoveFootprintTrigger(id) end
    end)
    
    
    Trigger.OnAllKilled(PowerSupply, function()
		player.MarkCompletedObjective(destroyPowerplants)
        player.MarkCompletedObjective(spySurvive)
	end)
    
    


end

FinishTimer = function()
	for i = 0, 5, 1 do
		local c = TimerColor
		if i % 2 == 0 then
			c = HSLColor.White
		end
		Trigger.AfterDelay(DateTime.Seconds(i), function()
            ussr.MarkCompletedObjective(ussrObj) 
            UserInterface.SetMissionText("")
        end)
	end
end


ActivatePatrols = function()
	GroupPatrol(PatrolA, PatrolAPath, DateTime.Seconds(3))
	GroupPatrol(PatrolB, PatrolBPath, DateTime.Seconds(2))
    GroupPatrol(PatrolC, PatrolCPath, DateTime.Seconds(5))

	local units = Map.ActorsInBox(Map.TopLeft, Map.BottomRight, function(self) return self.Owner == soviets and self.HasProperty("AutoTarget") end)
	Utils.Do(units, function(unit)
		unit.Stance = "Defend"
	end)
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


SendConvoy = function()
	trucks1 = Reinforcements.Reinforce(ussr, Convoy, ConvoyPathA, 20 )
    trucks2 = Trigger.AfterDelay(DateTime.Seconds(1), function()Reinforcements.Reinforce(ussr, Convoy, ConvoyPathB, 20 ) end)
    trucks3 = Trigger.AfterDelay(DateTime.Seconds(2), function()Reinforcements.Reinforce(ussr, Convoy, ConvoyPathC, 20 ) end)
    
    Trigger.AfterDelay(DateTime.Seconds(3), function() spytruck = Reinforcements.Reinforce(ussrradar, Convoy, AlliedConvoyPath, 20) end)
 
    Trigger.AfterDelay(DateTime.Seconds(9), function()
        Reinforcements.Reinforce(player, InfiltratedSquad, InfiltrationPoint, 5)
    end)
    
    
    
    --Trigger.OnKilled(Spy, function() 
    --   ussr.MarkCompletedObjective(ussrObj) 
    --end) 
end


InitObjectives = function()
	Trigger.OnObjectiveAdded(player, function(p, id)
		Media.DisplayMessage(p.GetObjectiveDescription(id), "新的" .. string.lower(p.GetObjectiveType(id)) .. "任务目标")
	end)

	ussrObj = ussr.AddPrimaryObjective("阻止盟军的行动")
    infRadardome = player.AddPrimaryObjective("渗透苏军的雷达站")
	destroyPowerplants = player.AddPrimaryObjective("摧毁所有敌军发电设施")
	spySurvive = player.AddPrimaryObjective("必须确保间谍存活")
	
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

  

WorldLoaded = function()
	player = Player.GetPlayer("ENGLAND")
	ussr = Player.GetPlayer("USSR")
	ussrradar = Player.GetPlayer("USSRRADAR")
    
	InitObjectives()
	InitTriggers()
	
    SetupAlliedUnits()
	
	SendConvoy()
	
	Trigger.AfterDelay(DateTime.Seconds(10), ActivatePatrols)
	
    
    Trigger.AfterDelay(DateTime.Seconds(1), function() Media.PlaySpeechNotification(allies, "MissionTimerInitialised") end)
    
    TimerColor = player.Color
    
    


end