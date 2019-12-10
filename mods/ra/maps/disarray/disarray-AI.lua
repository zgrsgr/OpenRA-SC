
SovietInfantryTypes = { "e1", "e2", "e4" }
InfAttack = { }
SovietVehicleTypes = { "3tnk", "3tnk", "v2rl" }
ArmorAttack = { }
SovietAircraftType = { "yak", "yak" }
AttackAircraft = { }

ProductionInterval = 30
	--{
	--30,
	--0,--normal = DateTime.Seconds(15),
	--0--hard = DateTime.Seconds(5)
	--}

AttackPaths = 
	{
		{Path3, Path4},
		{Path3, Path5},
		{Path1, Path2, Path6 },
		{Path1, Path2, Path4 }
	}

IdleHunt = function(unit) 
	if not unit.IsDead then Trigger.OnIdle(unit, unit.Hunt) end 
end

IdlingUnits = function()
	local lazyUnits = Utils.Where(Map.ActorsInWorld, function(actor)
		return actor.HasProperty("Hunt") and (actor.Owner == enemy) end)

	Utils.Do(lazyUnits, function(unit)
		Trigger.OnDamaged(unit, function()
			Trigger.ClearAll(unit)
			Trigger.AfterDelay(0, function() IdleHunt(unit) end)
		end)
	end)
end

Paradrop = function()
	
end

BuildBase = function()
	for i,v in ipairs(BaseBuildings) do
		if not v.exists then
			
			BuildBuilding(v)
			return
		end
	end
	Trigger.AfterDelay(DateTime.Seconds(10), BuildBase)
end
	
BuildBuilding = function(building)
	Trigger.AfterDelay(Actor.BuildTime(building.type), function()
		if BaseFact.IsDead or BaseFact.Owner ~= enemy then 
			return
		end
		
		local actor = Actor.Create(building.type, true, { Owner = enemy, Location = BaseFactLocation.Location + building.pos })
		enemy.Cash = enemy.Cash - building.cost

		building.exists = true
		Trigger.OnKilled(actor, function() building.exists = false end)
		Trigger.OnDamaged(actor, function(building)
			if building.Owner == enemy and building.Health < building.MaxHealth * 3/4 then
				building.StartBuildingRepairs()
				
			end
		end)

		Trigger.AfterDelay(DateTime.Seconds(10), BuildBase)
	end)
end

ProduceInfantry = function()
	if not ( Barr.exists or Barr.Owner ~= enemy ) then
		Media.PlaySoundNotification(enemy, "AlertBuzzer")
	--[[	return
	elseif baseharv.IsDead and enemy.Resources <= 299 then]]
		return
	end

	local delay = Utils.RandomInteger(DateTime.Seconds(3), DateTime.Seconds(9))
	local toBuild = { Utils.Random(SovietInfantryTypes) }
	local Path = Utils.Random(AttackPaths)
	enemy.Build(toBuild, function(unit)
		
		InfAttack[#InfAttack + 1] = unit[1]
		if #InfAttack >= 8 then
			Media.PlaySpeechNotification(enemy, "ReinforcementsArrived") 
			SendUnits(InfAttack, Path)
			InfAttack = { }
			Trigger.AfterDelay(DateTime.Seconds(30), ProduceInfantry)
		else
			Trigger.AfterDelay(delay, ProduceInfantry)
		end
	end)
end

ProduceArmor = function()
	if not (Weap.exists or Weap.Owner ~= enemy) then
		return
	--elseif baseharv.IsDead and enemy.Resources <= 599 then
	--	return
	end

	local delay = Utils.RandomInteger(DateTime.Seconds(12), DateTime.Seconds(17))
	local toBuild = { Utils.Random(SovietVehicleTypes) }
	local Path = Utils.Random(AttackPaths)
	enemy.Build(toBuild, function(unit)
		ArmorAttack[#ArmorAttack + 1] = unit[1]

		if #ArmorAttack >= 3 then
			SendUnits(ArmorAttack, Path)
			ArmorAttack = { }
			Trigger.AfterDelay(DateTime.Minutes(1), ProduceArmor)
		else
			Trigger.AfterDelay(delay, ProduceArmor)
		end
	end)
end

ProduceAircraft = function()  --FUNCTION STARTS
	if not Afld1.exists and not Afld2.exists then --CHECKS IF THERE IS AN AIRFIELD IN THE FIRST PLACE
		--Media.PlaySoundNotification(enemy, "AlertBuzzer") --NOISE IF DOESN'T FIND ANY
		return --ENDS IF THERE IS NO AIRFIELD
	end

	enemy.Build(SovietAircraftType, function(units) --BUILDS AIRCRAFT OF AIRCRAFT TYPE
		local yak = units[1]	--Units to build
		AttackAircraft[#AttackAircraft + 1] = yak

		Trigger.OnKilled(yak, ProduceAircraft)

		local alive = Utils.Where(AttackAircraft, function(y) return not y.IsDead end)
		if #alive < 2 then
			Trigger.AfterDelay(DateTime.Seconds(ProductionInterval--[[[Map.LobbyOption("difficulty")] / 2]]), ProduceAircraft)
		end

		TargetAndAttack(yak)
	end)
end

TargetAndAttack = function(yak, target)
	if not target or target.IsDead or (not target.IsInWorld) then
		local enemies = Utils.Where(Map.ActorsInWorld, function(self) return self.Owner == player and self.HasProperty("Health") and yak.CanTarget(self) end)
		if #enemies > 0 then
			target = Utils.Random(enemies)
		end
	end

	if target and yak.AmmoCount() > 0 and yak.CanTarget(target) then
		yak.Attack(target)
	else
		yak.ReturnToBase()
	end

	yak.CallFunc(function()
		TargetAndAttack(yak, target)
	end)
end

SendUnits = function(units, waypoints)
	Utils.Do(units, function(unit)
		if not unit.IsDead then
			Utils.Do(waypoints, function(waypoint)
				unit.AttackMove(waypoint.Location)
			end)
			IdleHunt(unit)
		end
	end)
end