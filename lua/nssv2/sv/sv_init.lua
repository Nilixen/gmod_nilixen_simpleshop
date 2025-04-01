// allows owner of item to pickup and freeze items
hook.Add( "PhysgunPickup", "nssv2_canphysgunpickup", function(ply, ent) 
    if (ent:GetClass() == "nssv2_itemforsale" or ent:GetClass("nssv2_metaldetector")) and
    IsValid(ent:GetOwner()) and
    ent:GetOwner():CPPIGetOwner() == ply then
         return true
    end
end)

hook.Add( "canPocket", "nssv2_pocketblock", function( ply, ent )
    if ent:GetClass() == "nssv2_itemforsale" or ent:GetClass() == "nssv2_cashregister" then return false end
end )

// set owner to entities that were bought by players
hook.Add( "playerBoughtCustomEntity","nssv2_cppi", function(ply, entityTable, ent, price) 
    if ent:GetClass() == "nssv2_cashregister" then
        ent:CPPISetOwner(ply)
    end
end)

hook.Add("canLockpick","nssv2_canlockpick",function(ply, ent, trace)
    if ent:GetClass() == "nssv2_cashregister" and ent:GetMoney() > 0 then return true end
    if ent:GetClass() == "nssv2_itemforsale" then return true end
end)
 
hook.Add("lockpickTime","nssv2_lockpicktime",function(ply, ent)
    if ent:GetClass() == "nssv2_cashregister" then return math.random(30,60) end
    if ent:GetClass() == "nssv2_itemforsale" then return math.random(10,20) end
end)

hook.Add("onLockpickCompleted","nssv2_lockpickcompleted",function(ply, success, ent)
    if success then
        if IsValid(ent) then
            if ent:GetClass() == "nssv2_itemforsale" then 
                local phys = ent:GetPhysicsObject()
                phys:EnableMotion(true)
                return
            end
            if ent:GetClass() == "nssv2_cashregister" then
                local money = ent:GetMoney()
                local tax = money*nssv2.Config.Tax
                nssv2.Config:HandleTax(tax)
                ent:SetMoney(0)
                ply:addMoney(money-tax)
            end
        end
    end

end)