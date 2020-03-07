
ticks = 0
speed = 5
gdi = 0

Tick = function()
	ticks = ticks + 1
	local t = (ticks + 45) % (360 * speed) * (math.pi / 180) / speed;
	Camera.Position = viewportOrigin + WVec.New(-15360 * math.sin(t), 4096 * math.cos(t), 0)
	if boat1.Location.X < 8 
	then
		boat1.Kill()
		boat1 = Actor.Create("boat", true, { Owner = gdi, Location = CPos.New(87, 34) })
	end
	if boat2.Location.X < 8 
	then
		boat2.Kill()
		boat2 = Actor.Create("boat", true, { Owner = gdi, Location = CPos.New(87, 38) })
	end
	if boat3.Location.X < 8 
	then
		boat3.Kill()
		boat3 = Actor.Create("boat", true, { Owner = gdi, Location = CPos.New(87, 33) })
	end
	if boat4.Location.X < 8 
	then
		boat4.Kill()
		boat4 = Actor.Create("boat", true, { Owner = gdi, Location = CPos.New(87, 39) })
	end
end

WorldLoaded = function()
	gdi = Player.GetPlayer("GDI")
	viewportOrigin = Camera.Position
	LoadTransport(lst1, "htnk")
	LoadTransport(lst2, "mcv")
	LoadTransport(lst3, "htnk")
	local units = { lst1, lst2, lst3}
	for i, unit in ipairs(units) do
		LoopTrack(unit, CPos.New(8, unit.Location.Y), CPos.New(87, unit.Location.Y))
	end
end

LoopTrack = function(actor, left, right)
	actor.ScriptedMove(left)
	actor.Teleport(right)
	actor.CallFunc(function() LoopTrack(actor, left, right) end)
end

LoadTransport = function(transport, passenger)
	transport.LoadPassenger(Actor.Create(passenger, false, { Owner = transport.Owner, Facing = transport.Facing, Location = transportUnload }))
end