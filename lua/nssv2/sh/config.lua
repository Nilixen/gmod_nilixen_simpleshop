nssv2.Config = nssv2.Config or {}
local c = nssv2.Config

nssv2.guiColors = {
    //accentColor = Color(196,107,255),
    accentColor = Color(62,61,146),
    boxes = {
        blended = Color(0,0,0,120),
        primary = Color(22,22,22),
		secondary = Color(26,26,26),
		tertiary = Color(34,34,34),
    },
    text = {
        primary = Color(201,201,201),
        secondary = Color(144,144,144),
        white = Color(255,255,255),
        positive = Color(40,129,62),
        negative = Color(129,40,40),
    },
}


c.Language = "EN-en"
c.CashRegisterAddRange = 200
c.CashRegisterMaxRange = 1000
c.CashRegisterMaxItems = function(ply,cashRegister) // eg. for a vip higher number
    return 10
end
c.CashRegisterMaxMetalDetectors = function(ply,cashregister)
    return 2
end

c.Tax = 0.05
c.HandleTax = function(_,tax)
    -- tax is amount of money taken from every sale (called when collecting money (even when it's being stolen :shrug: to prevent tax evasion))
end

--[[

    Draw3D2D function is called in itemforsale entity in a draw function, so make it that it suits your needs, here are examples


    example that will follow player around an entity:

    Draw3D2D = function(entity)
        local shopColor = entity:GetOwner():GetShopColor():ToColor()   // have to cast it to Color using ToColor() function, cuz we're storing it as a Vector due to limitations
        local offset = 3
        local lookAng = LocalPlayer():EyeAngles().yaw-90
        local ang = Angle(0,LocalPlayer():EyeAngles().yaw-90,90)    // always looking at player
        local mn, mx = entity:GetRenderBounds()
        local pos = util.LocalToWorld(entity, (mn + mx) * 0.5)
        cam.Start3D2D(pos+ang:Up()*offset-ang:Right()*5,ang,0.05)
            draw.SimpleText(entity:GetDataType(),"nssv2-50Shadow",0,-55,nssv2.guiColors.text.primary,TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP)
            draw.SimpleText(entity:GetDataName(),"nssv2-60Shadow",0,-25,shopColor,TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP)
            draw.SimpleText(DarkRP.formatMoney(entity:GetPrice()),"nssv2-60Shadow",0,15,nssv2.guiColor.text.positive,TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP)
        cam.End3D2D()
    end,



]]
c.SellableEntities = {}
c.SellableEntities["spawned_shipment"] = {
    setUpCheck = function(entity) return true end,
    setUpFunction = function(oldEntity, newEntity) return end, 
    sellFunction = function(entity) return end,
    TypeName = "Shipment",
    CustomName = function(entity)
        return entity:Getcount().."x "..CustomShipments[entity:Getcontents()].name
    end,
    Draw3D2D = function(entity)
        local shopColor = entity:GetOwner():GetShopColor():ToColor() or nssv2.guiColors.accentColor   // have to cast it to Color using ToColor() function, cuz we're storing it as a Vector due to limitations
        local offset = 12.1
        local lookAng = LocalPlayer():EyeAngles().yaw-90
        local ang = entity:GetAngles()    // static rotation
        local mn, mx = entity:GetRenderBounds()
        local pos = util.LocalToWorld(entity, (mn + mx) * 0.5)
        cam.Start3D2D(pos+ang:Up()*offset,ang,0.1)
            draw.RoundedBox(25,-150,-120,300,240,ColorAlpha(nssv2.guiColors.boxes.primary,220))
            draw.SimpleText(entity:GetDataType(),"nssv2-60Shadow",0,-110,nssv2.guiColors.text.primary,TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP)
            draw.SimpleText(entity:GetDataName(),string.len(entity:GetDataName()) > 10 and "nssv2-40Shadow" or "nssv2-70Shadow",0,-35,shopColor,TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP)
            draw.SimpleText(DarkRP.formatMoney(entity:GetPrice()),"nssv2-80Shadow",0,35,nssv2.guiColors.text.positive,TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP)
        cam.End3D2D()
    end,
}
c.SellableEntities["spawned_weapon"] = {
    setUpCheck = function(entity) return true end,
    setUpFunction = function(oldEntity, newEntity) return end, //newEntity is created in place of old entity, which is meant to be saved and deleted
    sellFunction = function(entity) return end,
    TypeName = "Weapon",
    CustomName = function(entity)
        for k, v in pairs(CustomShipments) do
            if v.entity == entity:GetWeaponClass() then
                return entity:Getamount() > 1 and entity:Getamount().."x "..v.name or v.name
            end
        end
    end,
    Draw3D2D = function(entity)
        local shopColor = entity:GetOwner():GetShopColor():ToColor() or nssv2.guiColors.accentColor   // have to cast it to Color using ToColor() function, cuz we're storing it as a Vector due to limitations
        local offset = 3
        local lookAng = LocalPlayer():EyeAngles().yaw-90
        local ang = Angle(0,LocalPlayer():EyeAngles().yaw-90,90)    // always looking at player
        local mn, mx = entity:GetRenderBounds()
        local pos = util.LocalToWorld(entity, (mn + mx) * 0.5)
        cam.Start3D2D(pos+ang:Up()*offset-ang:Right()*5,ang,0.05)
            draw.SimpleText(entity:GetDataType(),"nssv2-50Shadow",0,-55,nssv2.guiColors.text.primary,TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP)
            draw.SimpleText(entity:GetDataName(),"nssv2-60Shadow",0,-25,shopColor,TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP)
            draw.SimpleText(DarkRP.formatMoney(entity:GetPrice()),"nssv2-60Shadow",0,15,nssv2.guiColors.text.positive,TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP)
        cam.End3D2D()
    end,
}
c.SellableEntities["spawned_ammo"] = {
    setUpCheck = function(entity) return true end,
    setUpFunction = function(oldEntity, newEntity) return end,
    sellFunction = function(entity) return end,
    TypeName = "Ammo",
    CustomName = function(entity) return end,
    Draw3D2D = function(entity)
        local shopColor = entity:GetOwner():GetShopColor():ToColor() or nssv2.guiColors.accentColor    // have to cast it to Color using ToColor() function, cuz we're storing it as a Vector due to limitations
        local offset = 8
        local lookAng = LocalPlayer():EyeAngles().yaw-90
        local ang = Angle(0,LocalPlayer():EyeAngles().yaw-90,90)    // always looking at player
        local mn, mx = entity:GetRenderBounds()
        local pos = util.LocalToWorld(entity, (mn + mx) * 0.5)
        cam.Start3D2D(pos+ang:Up()*offset-ang:Right()*5,ang,0.05)
            draw.SimpleText(entity:GetDataName(),"nssv2-70Shadow",0,-30,shopColor,TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP)
            draw.SimpleText(DarkRP.formatMoney(entity:GetPrice()),"nssv2-70Shadow",0,20,nssv2.guiColors.text.positive,TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP)
        cam.End3D2D()
    end,
}
