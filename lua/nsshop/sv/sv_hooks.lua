hook.Add( "PlayerUse", "nss_useblock", function( ply, ent )
	if !IsValid(ent) then return end
    if ent:GetNWBool("nss_forsale") then
        net.Start("nss_gui")
            net.WriteInt(2,4)
            net.WriteEntity(ent)
        net.Send(ply)
        return false
    end
end )

hook.Add( "canPocket", "nss_pocketblock", function( ply, ent )
	if !IsValid(ent) then return end
    if ent:GetNWBool("nss_forsale") then
        return false
    end
end )


hook.Add( "EntityTakeDamage", "nss_dmgblock", function( ent, dmg )
	if !IsValid(ent) then return end
    if ent:GetNWBool("nss_forsale") then
        dmg:SetDamage(0)
    end

end )

hook.Add( "PhysgunPickup", "nss_canphysgunpickup", function(ply, ent) 

    if !nss.Conf.EntitiesWL[ent:GetClass()] then return end
    if !ent:GetNWBool("nss_forsale") then return end
    if ent:GetNWEntity("nss_owner"):CPPIGetOwner() == ply then return true end

end)

hook.Add( "playerBoughtCustomEntity","nss_cppi", function(ply, entityTable, ent, price) 

    if ent:GetClass() == "nss_cashregister" or ent:GetClass()  == "nss_metaldetector" then
        ent:CPPISetOwner(ply)
    end

end)


hook.Add( "Think" , "nss_blockTouch", function()        // I know... it can be laggy
    local tbl = nss.EntitiesForSale

    for ent,_ in pairs(tbl) do

        if !IsValid(ent) then tbl[ent] = nil continue end
        if !IsValid(ent:GetNWEntity("nss_owner")) then nss:DisOwnItem(ent) continue end
        if !ent:GetNWBool("nss_forsale") then tbl[ent] = nil continue end
        local find = ents.FindInSphere(ent:GetPos(),50)
        for k,v in pairs(find) do
            local cl = v:GetClass()
            if cl == "prop_physics" or v:GetNWBool("nss_forsale") or v:IsWeapon() or v:IsPlayer() then continue end
            constraint.NoCollide(ent,v,0,0)
        end
    end

end)

hook.Add("onLockpickCompleted","nss_lockpickcompleted",function(ply, success, ent)
    if !success then return end
    if !IsValid(ent) then return end
    if ent:GetNWBool("nss_forsale") then 
        ent:GetPhysicsObject():EnableMotion(true)
        return
    end
    if ent:GetClass() == "nss_cashregister" then
        local money = ent:GetMoney()
        ent:SetMoney(0)
        ply:addMoney(money)
    end

end)


--[[
                        CUSTOM ADDONS SUPPORT
]]

// ITEMSTORE - prevent entities from being pickedup
hook.Add( "ItemStoreCanPickup", "nss_itemstore_pocketblock", function(ply, item, ent)
	if !IsValid(ent) then return end
    if ent:GetNWBool("nss_forsale") then
        return false
    end
end)