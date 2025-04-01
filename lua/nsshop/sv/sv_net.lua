util.AddNetworkString("nss_gui")
util.AddNetworkString("nss_net")
util.AddNetworkString("nss_client")

net.Receive("nss_gui",function(len,ply)
    local id = net.ReadInt(4)
    if id == 1 then     // setup
        local ent = net.ReadEntity()
        local cashregister = net.ReadEntity(ent)
        local cost = net.ReadInt(32)
        local b = nss:SetUpItem(ent,cashregister,cost)

        net.Start("nss_gui")
            net.WriteInt(3,4)
            net.WriteEntity(cashregister)
            net.WriteTable(cashregister.Owned)
            net.WriteBool(b)
        net.Send(ply)
        

        
    elseif id == 2 then     //sell
        local ent = net.ReadEntity()
        nss.Conf.SellItem((ent:GetNWInt("nss_cost")*nss.Conf.Tax),ent,ply)
        nss:SellItem(ent,ply)
    elseif id == 3 then //disown
        local ent = net.ReadEntity()
        local cashregister = net.ReadEntity()
        local b = nss:DisOwnItem(ent)
        net.Start("nss_gui")
            net.WriteInt(3,4)
            net.WriteEntity(cashregister)
            net.WriteTable(cashregister.Owned)
            net.WriteBool(b)
        net.Send(ply)
    elseif id == 4 then
        local ent = net.ReadEntity()
        local money = ent:GetMoney()
        ent:SetMoney(0)
        ply:addMoney(money)

    end

end)

net.Receive("nss_client",function(len,ply)
    nss:SynchroConf(ply)
end)
