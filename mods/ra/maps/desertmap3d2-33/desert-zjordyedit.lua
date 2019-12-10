

UnitTypes = { "3tnk", "ftrk", "ttnk", "apc2" }
BeachUnitTypes = { "e1", "e2", "e3", "e4", "e1", "e2", "e3", "e4", "e1", "e2", "e3", "e4", "e1", "e2", "e3", "e4" }
ProxyType = "powerproxy.paratroopers"
ProducedUnitTypes =
{
	{ factory = AlliedBarracks1, types = { "e1", "e3" } },
	{ factory = AlliedBarracks2, types = { "e1", "e3" } },
	{ factory = SovietBarracks1, types = { "dog", "e1", "e2", "e3", "e4", "shok" } },
	{ factory = SovietBarracks2, types = { "dog", "e1", "e2", "e3", "e4", "shok" } },
	{ factory = SovietBarracks3, types = { "dog", "e1", "e2", "e3", "e4", "shok" } },
	{ factory = AlliedWarFactory1, types = { "jeep", "1tnk", "2tnk", "arty", "ctnk" } },
	{ factory = SovietWarFactory1, types = { "3tnk", "4tnk", "v2rl", "ttnk", "apc2" } }
}



T1LooseCounter = 0
T2LooseCounter = 0

ShipUnitTypes = { "1tnk", "1tnk", "jeep", "2tnk", "2tnk" }
ShipUnitTypes2 = { "e1", "e3", "jeep", "1tnk", "2tnk" }

ParadropWaypoints = { Paradrop1, Paradrop2, Paradrop3, Paradrop4, Paradrop5, Paradrop6, Paradrop7, Paradrop8 }

Mig1Waypoints = { Mig11, Mig12, Mig13, Mig14 }
Mig2Waypoints = { Mig21, Mig22, Mig23, Mig24 }

BindActorTriggers = function(a)
	if a.HasProperty("Hunt") then
		if a.Owner == allies or a.Owner == soviets then
			Trigger.OnIdle(a, function(a)
				if a.IsInWorld then
					a.Hunt()
				end
			end)
		else
			Trigger.OnIdle(a, function(a)
				if a.IsInWorld then
					a.AttackMove(AlliedTechnologyCenter.Location)
				end
			end)
		end
	end

	if a.HasProperty("HasPassengers") then
		Trigger.OnDamaged(a, function()
			if a.HasPassengers then
				a.Stop()
				a.UnloadPassengers()
			end
		end)
	end
end




SendSovietUnits = function(entryCell, unitTypes, interval)
	local units = Reinforcements.Reinforce(soviets, unitTypes, { entryCell }, interval)
	Utils.Do(units, function(unit)
		BindActorTriggers(unit)
	end)
	Trigger.OnAllKilled(units, function() SendSovietUnits(entryCell, unitTypes, interval) end)
end

SendMigs = function(waypoints)
	local migEntryPath = { waypoints[1].Location, waypoints[2].Location }
	local migs = Reinforcements.Reinforce(soviets, { "mig" }, migEntryPath, 4)
	Utils.Do(migs, function(mig)
		mig.Move(waypoints[3].Location)
		mig.Move(waypoints[4].Location)
		mig.Destroy()
	end)

	Trigger.AfterDelay(DateTime.Seconds(60), function() SendMigs(waypoints) end)
end

ShipAlliedUnits = function()
	local units = Reinforcements.ReinforceWithTransport(allies, "lst",
		ShipUnitTypes, { LstEntry.Location, LstUnload.Location }, { LstEntry.Location })[2]

	Utils.Do(units, function(unit)
		BindActorTriggers(unit)
	end)

	Trigger.AfterDelay(DateTime.Seconds(37), ShipAlliedUnits)
end

ShipAlliedUnits2 = function()
	local units = Reinforcements.ReinforceWithTransport(allies, "lst",
		ShipUnitTypes2, { LstEntry.Location, LstUnload2.Location }, { LstEntry.Location })[2]

	Utils.Do(units, function(unit)
		BindActorTriggers(unit)
	end)

	Trigger.AfterDelay(DateTime.Seconds(14), ShipAlliedUnits2)
end


ParadropSovietUnits = function()
	local lz = Utils.Random(ParadropWaypoints)
	local units = powerproxy.SendParatroopers(lz.CenterPosition)

	Utils.Do(units, function(a)
		BindActorTriggers(a)
	end)

	Trigger.AfterDelay(DateTime.Seconds(40), ParadropSovietUnits)
end

ProduceUnits = function(t)
	local factory = t.factory
	if not factory.IsDead then
		local unitType = t.types[Utils.RandomInteger(1, #t.types + 1)]
		factory.Wait(Actor.BuildTime(unitType))
		factory.Produce(unitType)
		factory.CallFunc(function() ProduceUnits(t) end)
	end
end

ProduceInfantry = function()
	local delay = Utils.RandomInteger(DateTime.Seconds(3), DateTime.Seconds(9))
	local toBuild = { Utils.Random(UnitType) }
	ussr.Build(toBuild, function(unit)
		IdlingUnits[#IdlingUnits + 1] = unit[1]
		Trigger.AfterDelay(delay, ProduceInfantry)
		if #IdlingUnits >= (AttackGroupSize * 2.5) then
			SendAttack()
		end
	end)
end

SetupAlliedUnits = function()
	Utils.Do(Map.NamedActors, function(a)
		if a.Owner == allies and a.HasProperty("AcceptsCondition") and a.AcceptsCondition("unkillable") then
			a.GrantCondition("unkillable")
			a.Stance = "Defend"
		end
	end)
end

SetupFactories = function()
	Utils.Do(ProducedUnitTypes, function(production)
		Trigger.OnProduction(production.factory, function(_, a) BindActorTriggers(a) end)
	end)
end

ChronoshiftAlliedUnits = function()
	local cells = Utils.ExpandFootprint({ ChronoshiftLocation.Location }, false)
	local units = { }
	for i = 1, #cells do
		local unit = Actor.Create("2tnk", true, { Owner = allies, Facing = 0 })
		BindActorTriggers(unit)
		units[unit] = cells[i]
	end
	Chronosphere.Chronoshift(units)
	Trigger.AfterDelay(DateTime.Seconds(55), ChronoshiftAlliedUnits)
end

ticks = 0
speed = 5

Tick = function()
	if Multi0 ~= nil and Multi0.HasNoRequiredUnits() and not P1Lost then
        P1Lost = true
        Multi0.MarkFailedObjective(WinTheGame1)
        T1LooseCounter = T1LooseCounter +1
    end
    if Multi1 ~= nil and Multi1.HasNoRequiredUnits() and not P2Lost then
        P2Lost = true
        Multi1.MarkFailedObjective(WinTheGame2)
        T1LooseCounter = T1LooseCounter +1
    end
    if Multi2 ~= nil and Multi2.HasNoRequiredUnits() and not P3Lost then
        P3Lost = true
        Multi2.MarkFailedObjective(WinTheGame3)
        T1LooseCounter = T1LooseCounter +1
    end
    if Multi3 ~= nil and Multi3.HasNoRequiredUnits() and not P4Lost then
        P4Lost = true
        Multi3.MarkFailedObjective(WinTheGame4)
        T2LooseCounter = T2LooseCounter +1
    end
    if Multi4 ~= nil and Multi4.HasNoRequiredUnits() and not P5Lost then
        P5Lost = true
        Multi4.MarkFailedObjective(WinTheGame5)
        T2LooseCounter = T2LooseCounter +1
    end
    if Multi5 ~= nil and Multi5.HasNoRequiredUnits() and not P6Lost then
        P6Lost = true
        Multi5.MarkFailedObjective(WinTheGame6)
        T2LooseCounter = T2LooseCounter +1
    end
    if T1LooseCounter == 3 then
        Team2Won()
    end
    if T2LooseCounter == 3 then
        Team1Won()
    end
	ticks = ticks + 1

	local t = (ticks + 45) % (360 * speed) * (math.pi / 180) / speed
end

SetupPlayers = function()
    Multi0 = Player.GetPlayer("Multi0")
    if Multi0 ~= nil then
        WinTheGame1 = Multi0.AddPrimaryObjective("消灭所有敌人！")
    else
    	P1Lost = true
        T1LooseCounter = T1LooseCounter +1
    end
    Multi1 = Player.GetPlayer("Multi1")
    if Multi1 ~= nil then
        WinTheGame2 = Multi1.AddPrimaryObjective("消灭所有敌人！")
    else
    	P2Lost = true
        T1LooseCounter = T1LooseCounter +1
    end
    Multi2 = Player.GetPlayer("Multi2")
    if Multi2 ~= nil then
        WinTheGame3 = Multi2.AddPrimaryObjective("消灭所有敌人！")
    else
    	P3Lost = true
        T1LooseCounter = T1LooseCounter +1
    end
    Multi3 = Player.GetPlayer("Multi3")
    if Multi3 ~= nil then
        WinTheGame4 = Multi3.AddPrimaryObjective("消灭所有敌人！")
    else
    	P4Lost = true
        T2LooseCounter = T2LooseCounter +1
    end
    Multi4 = Player.GetPlayer("Multi4")
    if Multi4 ~= nil then
        WinTheGame5 = Multi4.AddPrimaryObjective("消灭所有敌人！")
    else
    	P5Lost = true
        T2LooseCounter = T2LooseCounter +1
    end
    Multi5 = Player.GetPlayer("Multi5")
    if Multi5 ~= nil then
        WinTheGame6 = Multi5.AddPrimaryObjective("消灭所有敌人！")
    else
    	P6Lost = true
        T2LooseCounter = T2LooseCounter +1
    end
end

Team2Won = function()
    if not P4Lost then
        Multi3.MarkCompletedObjective(WinTheGame4)
    end
    if not P5Lost then
        Multi4.MarkCompletedObjective(WinTheGame5)
    end
    if not P6Lost then
        Multi5.MarkCompletedObjective(WinTheGame6)
    end
end
 
Team1Won = function()
    if not P1Lost then
        Multi0.MarkCompletedObjective(WinTheGame1)
    end
    if not P2Lost then
        Multi1.MarkCompletedObjective(WinTheGame2)
    end
    if not P3Lost then
        Multi2.MarkCompletedObjective(WinTheGame3)
    end
end

WorldLoaded = function()
	SetupPlayers()
	allies = Player.GetPlayer("Allies")
	soviets = Player.GetPlayer("Soviets")

	SetupAlliedUnits()
	SetupFactories()
	ShipAlliedUnits()
	ShipAlliedUnits2()
	powerproxy = Actor.Create(ProxyType, false, { Owner = soviets })
	ParadropSovietUnits()
	Trigger.AfterDelay(DateTime.Seconds(5), ChronoshiftAlliedUnits)
	Utils.Do(ProducedUnitTypes, ProduceUnits)

	Trigger.AfterDelay(DateTime.Seconds(30), function() SendMigs(Mig1Waypoints) end)
	Trigger.AfterDelay(DateTime.Seconds(30), function() SendMigs(Mig2Waypoints) end)

	SendSovietUnits(Entry1.Location, UnitTypes, 54)
	SendSovietUnits(Entry2.Location, UnitTypes, 54)
	SendSovietUnits(Entry3.Location, UnitTypes, 54)
	SendSovietUnits(Entry4.Location, UnitTypes, 54)
	SendSovietUnits(Entry5.Location, UnitTypes, 54)
	SendSovietUnits(Entry6.Location, UnitTypes, 54)
	SendSovietUnits(Entry7.Location, BeachUnitTypes, 15)
	

end
                                                                                           
                                                                                           
                                                                                           
                                                                                           
                                                                                           
                                                                                           
                                                                                           
                                                                                           
                                                                                           
                                                                                           
                                                                                           
                                                                                           
                                                                                           
                                                                                           
                                                                                           
                                                                                           