if engine.ActiveGamemode() == "darkrp" then
	nss = {} or nss
	nss.EntitiesForSale = {}


	for _, v in pairs(file.Find("nsshop/sh/*", "LUA")) do
		include("nsshop/sh/" .. v)
		if SERVER then AddCSLuaFile("nsshop/sh/" .. v) end
	end

	for _, v in pairs(file.Find("nsshop/cl/*", "LUA")) do
		if CLIENT then include("nsshop/cl/" .. v) else AddCSLuaFile("nsshop/cl/" .. v) end
	end

	if SERVER or game.SinglePlayer() then
		for _, v in pairs(file.Find("nsshop/sv/*", "LUA")) do
			include("nsshop/sv/" .. v)
		end
	end
	print("NSS Loaded correctly!")
else
	print("NSS not loaded, DARKRP not detected")
end