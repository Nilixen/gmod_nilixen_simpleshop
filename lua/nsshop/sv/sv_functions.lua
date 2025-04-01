function nss:SetUpItem(ent,cashregister,cost)
    if !IsValid(ent) then return false end
    if table.Count(cashregister.Owned) >= nss.Conf.ItemsLimit(cashregister:CPPIGetOwner()) then return false end
    if !nss.Conf.EntitiesWL[ent:GetClass()].setUpCheck(ent) then return false end     
    nss.EntitiesForSale[ent] = true

    cashregister.Owned[ent] = true
    ent:SetNWBool("nss_forsale",true)
    ent:SetNWInt("nss_cost",cost)
    ent:SetNWEntity("nss_owner",cashregister)
    ent.OldTouch = ent.Touch
    ent.OldStartTouch = ent.StartTouch
    ent.OldEndTouch = ent.EndTouch

    ent.Touch,ent.StartTouch,ent.EndTouch = function(entt)
        // todo block the other entity from touching this one
        return false
    end
    
    nss.Conf.EntitiesWL[ent:GetClass()].setUpFnc(ent)
    return true

end

function nss:SellItem(ent,ply)

    if !IsValid(ent) then return end

    local cost = ent:GetNWInt("nss_cost")
    local cashregister = ent:GetNWEntity("nss_owner")
    if !ply:canAfford(cost) then return end
    if IsValid(cashregister) then ply:addMoney(-cost) cashregister:AddMoney(cost*(1-nss.Conf.Tax)) end
    nss:DisOwnItem(ent)
    return true
end

function nss:DisOwnItem(ent)

    local cashregister = ent:GetNWEntity("nss_owner")
    if IsValid(cashregister) then
        cashregister.Owned[ent] = nil
    end

    constraint.RemoveConstraints(ent,"NoCollide")       // NOT ACTUALLY WORKING BECOUSE GMOD IS BROKEN SHIT
    ent:GetPhysicsObject():EnableMotion(true)

    ent.Touch = ent.OldTouch
    ent.StartTouch = ent.OldStartTouch
    ent.EndTouch = ent.OldEndTouch

    ent:SetNWBool("nss_forsale",false)
    ent:SetNWInt("nss_cost",0)
    ent:SetNWEntity("nss_owner",nil)

    nss.Conf.EntitiesWL[ent:GetClass()].sellFnc(ent)
    return true
end

function nss:SynchroConf(arg)
    local tbl = table.Copy(nss.Conf)
    tbl.EntitiesWL,tbl.SellItem,tbl.ItemsLimit = nil
    if isbool(arg) then
        net.Start("nss_net")
            net.WriteInt(1,4)
            net.WriteTable(tbl)
        net.Broadcast()
    else
        net.Start("nss_net")
            net.WriteInt(1,4)
            net.WriteTable(tbl)
        net.Send(arg)
    end

end