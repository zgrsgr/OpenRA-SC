Ftur1 = {type = "ftur", pos = CVec.New(-5,-10), cost = 600, exists = true}
Ftur2 = {type = "ftur", pos = CVec.New(1,-10), cost = 600, exists = true}
Tsla1 = {type = "tsla", pos = CVec.New(-1,-8), cost = 1200, exists = true}
Tsla2 = {type = "tsla", pos = CVec.New(-17,2), cost = 1200, exists = true}
		
Weap = {type = "weap", pos = CVec.New(-8,-3), cost = 2000, exists = true}
Barr = {type = "barr", pos = CVec.New(0,-6), cost = 500, exists = true}
Kenn = {type = "kenn", pos = CVec.New(3,-4), cost = 100, exists = true}
	
Afld1 = {type = "afld", pos = CVec.New(6,4), cost = 500, exists = true}
Afld2 = {type = "afld", pos = CVec.New(6,7), cost = 500, exists = true}
	
Fix = {type = "fix", pos = CVec.New(-2,3), cost = 1200, exists = true}
Dome = {type = "dome", pos = CVec.New(3,-2), cost = 1800, exists = true}
	
Power1 = {type = "apwr", pos = CVec.New(-19,-3), cost = 500, exists = true}
Power2 = {type = "powr", pos = CVec.New(-18,-7), cost = 300, exists = true}
Power3 = {type = "apwr", pos = CVec.New(-16,-8), cost = 500, exists = true}
Power4 = {type = "powr", pos = CVec.New(-11,4), cost = 300, exists = true}
Power5 = {type = "apwr", pos = CVec.New(-8,4), cost = 500, exists = true}
Power6 = {type = "powr", pos = CVec.New(4,-7), cost = 300, exists = true}
Power7 = {type = "apwr", pos = CVec.New(5,-4), cost = 500, exists = true}
Power8 = {type = "apwr", pos = CVec.New(6,-8), cost = 500, exists = true}
		
Proc1 = {type = "proc", pos = CVec.New(-13,-5), cost = 1400, exists = true}
Proc2 = {type = "proc", pos = CVec.New(-9,-7), cost = 1400, exists = true}
Silo1 = {type = "silo", pos = CVec.New(-13,-5), cost = 150, exists = true}
Silo2 = {type = "silo", pos = CVec.New(-11,-5), cost = 150, exists = true}
Silo3 = {type = "silo", pos = CVec.New(-9,-7), cost = 150, exists = true}
Silo4 = {type = "silo", pos = CVec.New(-7,-7), cost = 150, exists = true}

BaseBuildings =
	{
		Ftur1,
		Ftur2,
		Tsla1,
		Tsla2,
		
		Weap,
		Barr,
		Kenn,
		Afld1,
		Afld2,
		Fix,
		Dome,
		
		Power1,
		Power2,
		Power3,
		Power4,
		Power5,
		Power6,
		Power7,
		Power8,
		
		Proc1,
		Proc2,
		Silo1,
		Silo2,
		Silo3,
		Silo4
	}

Trigger.OnKilled(BaseTesla1, function()
	Tsla1.exists = false
end)

Trigger.OnKilled(BaseTesla2, function()
	Tsla2.exists = false
end)

Trigger.OnKilled(BaseFtur1, function()
	Ftur1.exists = false
end)

Trigger.OnKilled(BaseFtur2, function()
	Ftur2.exists = false
end)

Trigger.OnKilled(BasePower1, function()
	Power1.exists = false
end)

Trigger.OnKilled(BasePower2, function()
	Power2.exists = false
end)
	
Trigger.OnKilled(BasePower3, function()
	Power3.exists = false
end)

Trigger.OnKilled(BasePower4, function()
	Power4.exists = false
end)

Trigger.OnKilled(BasePower5, function()
	Power5.exists = false
end)

Trigger.OnKilled(BasePower6, function()
	Power6.exists = false
end)		

Trigger.OnKilled(BasePower7, function()
	Power7.exists = false
end)

Trigger.OnKilled(BasePower8, function()
	Power8.exists = false
end)

Trigger.OnKilled(BaseWeap, function()
	Weap.exists = false
end)

Trigger.OnKilled(BaseBarr, function()
	Barr.exists = false
end)

Trigger.OnKilled(BaseKenn, function()
	Kenn.exists = false
end)

Trigger.OnKilled(BaseFix, function()
	Fix.exists = false
end)

Trigger.OnKilled(BaseAfld1, function()
	Afld1.exists = false
end)

Trigger.OnKilled(BaseAfld2, function()
	Afld2.exists = false
end)

Trigger.OnKilled(BaseDome, function()
	Dome.exists = false
end)

Trigger.OnKilled(BaseRef1, function()
	Proc1.exists = false
end)	

Trigger.OnKilled(BaseRef2, function()
	Proc2.exists = false
end)

Trigger.OnKilled(BaseSilo1, function()
	Silo1.exists = false
end)		

Trigger.OnKilled(BaseSilo2, function()
	Silo2.exists = false
end)		

Trigger.OnKilled(BaseSilo3, function()
	Silo3.exists = false
end)		

Trigger.OnKilled(BaseSilo4, function()
	Silo4.exists = false
end)