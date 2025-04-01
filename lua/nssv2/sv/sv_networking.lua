if SERVER then 
    util.AddNetworkString( "nssv2_net" )
end

net.Receive("nssv2_net",function(len,ply)

    local id = net.ReadUInt(4)
    // copy and save item
    if id == 0 then
        local cashRegister = net.ReadEntity()
        local target = net.ReadEntity()
        local price = net.ReadUInt(32)

        if cashRegister:CPPIGetOwner() != ply or cashRegister:GetClass() != "nssv2_cashregister" then return end

        if not IsValid(cashRegister) or not IsValid(target) or price <= 0 then return end
        if table.Count(cashRegister.forSale) >= nssv2.Config.CashRegisterMaxItems(ply,cashRegister) then return end
        local ent = nssv2.Config.SellableEntities[target:GetClass()]
        
        if not ent:setUpCheck(target) then return end 

        local iterator = cashRegister.iterator


        // create custom item
        local item = ents.Create("nssv2_itemforsale")
        item:SetModel(target:GetModel())
        item:SetPos(target:GetPos())
        item:SetAngles(target:GetAngles())
        item:SetPrice(price)
        item:SetOwner(cashRegister)
        item:SetID(iterator+1)
        item:SetDataType(ent.CustomName(target) and ent.TypeName or "")
        item:SetDataName(ent.CustomName(target) or ent.TypeName or "Invalid name!")
        item:SetDataClass(target:GetClass())
        item:CPPISetOwner(ply)
        item.dupeInfo = duplicator.Copy(target)

        ent:setUpFunction(target,item) // execute setupfunction

        cashRegister.forSale[iterator+1] = {
            id = iterator+1,
            price = price,
            type =  ent.CustomName(target) and ent.TypeName or "",
            name = ent.CustomName(target) or ent.TypeName or "Invalid name!",
            owner = cashRegister,
            model = target:GetModel(),
            entity = item,   // to do, create entity in a place of old one
        }
        local v = cashRegister.forSale[iterator+1]
        local c_tbl = {
            name = v.name,
            type = v.type,
            id = v.id,
            price = v.price,
            model = v.model,
        }
        // update players gui to contain added item
        net.Start("nssv2_net")
            net.WriteUInt(1,4)
            net.WriteUInt(iterator+1,32)
            net.WriteTable( c_tbl )
            net.WriteEntity(cashRegister)
        net.Send(ply)

        target:Remove()
        item:Spawn()    // spawn item right after deleting target entity

        cashRegister.iterator = cashRegister.iterator + 1 // to maintain continuity in ids

    elseif id == 1 then // disown
        local cashRegister = net.ReadEntity()
        local targetID = net.ReadUInt(32)   // item to be disowned

        if cashRegister:CPPIGetOwner() != ply or cashRegister:GetClass() != "nssv2_cashregister" then return end

        if not cashRegister.forSale[targetID] then return end
        if not IsValid(cashRegister.forSale[targetID].entity) then return end
        cashRegister.forSale[targetID].entity:Release()   
        net.Start("nssv2_net")
            net.WriteUInt(2,4)
            net.WriteEntity(cashRegister)
            net.WriteUInt(targetID,32)
        net.Send(ply)
    elseif id == 2 then // buy
        local item = net.ReadEntity()

        if not IsValid(item) or item:GetClass() != "nssv2_itemforsale" or not IsValid(item:GetOwner()) then return end
        if not ply:canAfford(item:GetPrice()) then return end
        item:GetOwner().stats.totalSold = item:GetOwner().stats.totalSold + 1
        item:GetOwner().stats.totalMoney = item:GetOwner().stats.totalMoney + item:GetPrice()
        ply:addMoney(-item:GetPrice() or 0)
        item:GetOwner():SetMoney(item:GetOwner():GetMoney(0)+item:GetPrice())
        item:Release()

    elseif id == 3 then // collect
        local cashRegister = net.ReadEntity()
        if not IsValid(cashRegister) then return end
        if cashRegister:CPPIGetOwner() != ply or cashRegister:GetClass() != "nssv2_cashregister" then return end

        local money = cashRegister:GetMoney()
        local tax = math.max(money*nssv2.Config.Tax,0)

        nssv2.Config:HandleTax(tax)
        cashRegister:SetMoney(0)
        ply:addMoney(money-tax)
    elseif id == 4 then // settings
        local cashRegister = net.ReadEntity()
        if not IsValid(cashRegister) then return end
        if cashRegister:CPPIGetOwner() != ply or cashRegister:GetClass() != "nssv2_cashregister" then return end

        local color = net.ReadTable()
        cashRegister:SetShopColor(Color(color.r,color.g,color.b):ToVector())
    elseif id == 5 then // spawn metal detector
        local cashRegister = net.ReadEntity()
        if not IsValid(cashRegister) then return end
        if cashRegister:CPPIGetOwner() != ply or cashRegister:GetClass() != "nssv2_cashregister" then return end

        local ang = cashRegister:GetAngles()
        ang:RotateAroundAxis(ang:Up(),90)
        local detector = ents.Create("nssv2_metaldetector")
            detector:SetPos(cashRegister:GetPos()+cashRegister:GetAngles():Up()*40)
            detector:SetAngles(ang)
            detector:SetOwner(cashRegister)
            detector:CPPISetOwner(ply)
        detector:Spawn()
        cashRegister.metalDetectors[detector:EntIndex()] = detector

    end

end)