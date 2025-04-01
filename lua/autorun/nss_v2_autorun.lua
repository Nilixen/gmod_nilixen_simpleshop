if engine.ActiveGamemode() == "darkrp" then
	nssv2 = {} or nssv2

    local dir = "nssv2"
	for _, v in pairs(file.Find(dir.."/sh/*", "LUA")) do
		include(dir.."/sh/" .. v)
		if SERVER then AddCSLuaFile(dir.."/sh/" .. v) end
	end

	for _, v in pairs(file.Find(dir.."/language/*", "LUA")) do
		include(dir.."/language/" .. v)
		if SERVER then AddCSLuaFile(dir.."/language/" .. v) end
	end

	for _, v in pairs(file.Find(dir.."/cl/*", "LUA")) do
		if CLIENT then include(dir.."/cl/" .. v) else AddCSLuaFile(dir.."/cl/" .. v) end
	end

	if SERVER or game.SinglePlayer() then
		for _, v in pairs(file.Find(dir.."/sv/*", "LUA")) do
			include(dir.."/sv/" .. v)
		end
	end
	print("NSSV2 Loaded correctly!")
else
	print("NSSV2 not loaded, DARKRP not detected")
end