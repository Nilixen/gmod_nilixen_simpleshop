net.Receive("nss_gui",function(len)
    local id = net.ReadInt(4)
    if id == 2 then 

        local ent = net.ReadEntity() 
        nss:OpenItemGUI(ent)

    elseif id == 1 then

        local ent = net.ReadEntity() 
        local owned = net.ReadTable()
    
        nss:OpenCashRegisterGUI(ent,owned,nss:Find(ent,nss.Conf.AddRange))
    elseif id == 3 then

        local ent = net.ReadEntity()
        local owned = net.ReadTable()
        local bool = net.ReadBool()
        Derma_Query(bool and nss:getPhrase("Success") or nss:getPhrase("Failed"), "", nss:getPhrase("Ok"),function()
            ent.frame:Remove()
            nss:OpenCashRegisterGUI(ent,owned,nss:Find(ent,nss.Conf.AddRange))
        end)

    end
end)


net.Receive("nss_net",function(len)

    local id = net.ReadInt(4)
    if id == 1 then
        nss.Conf = table.Merge(nss.Conf,net.ReadTable())
    end

end)


