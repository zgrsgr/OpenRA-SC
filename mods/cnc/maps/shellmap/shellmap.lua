
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
	if lst1.Location.X < 8 
	then
		lst1.Kill()
		lst1 = Actor.Create("lst", true, { Owner = gdi, Location = CPos.New(87, 36) })
		LoadTransport(lst1, "htnk")
	end
	if lst2.Location.X < 8 
	then
		lst2.Kill()
		lst2 = Actor.Create("lst", true, { Owner = gdi, Location = CPos.New(87, 36) })
		LoadTransport(lst2, "mcv")
	end
	if lst3.Location.X < 8 
	then
		lst3.Kill()
		lst3 = Actor.Create("lst", true, { Owner = gdi, Location = CPos.New(87, 36) })
		LoadTransport(lst3, "htnk")
	end
end

WorldLoaded = function()
	gdi = Player.GetPlayer("GDI")
	viewportOrigin = Camera.Position
	LoadTransport(lst1, "htnk")
	LoadTransport(lst2, "mcv")
	LoadTransport(lst3, "htnk")
end

LoadTransport = function(transport, passenger)
	transport.LoadPassenger(Actor.Create(passenger, false, { Owner = transport.Owner, Facing = transport.Facing, Location = transportUnload }))
end