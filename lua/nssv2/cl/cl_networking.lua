net.Receive("nssv2_net", function()
    local id = net.ReadUInt(4)
    if id == 0 then // open gui
        local cashRegister = net.ReadEntity()
        local itemsForSale = net.ReadTable()
        local stats = net.ReadTable()
        local metalDetectors = net.ReadTable()
        if not cashRegister then return end
        nssv2:OpenCashRegisterGUI(cashRegister,itemsForSale,stats,metalDetectors)
    elseif id == 1 then // update gui (for sale list) 
        local iterator = net.ReadUInt(32)
        local tbl = net.ReadTable()
        local cashRegister = net.ReadEntity()
        if not cashRegister then return end
        if nssv2.ClientData.Frame then 
            local itemsForSale = nssv2.ClientData.Frame.itemsForSale
            itemsForSale[iterator] = tbl   // add newly created table to existing data for client, cuz server already knows
            nssv2.ClientData.Frame.mainPanel.forSalePanel.label:SetText(nssv2:GetPhrase("ItemsForSale",table.Count(itemsForSale),nssv2.Config.CashRegisterMaxItems(cashRegister:GetOwner(),cashRegister)))
            nssv2.ClientData.Frame.mainPanel.forSalePanel.itemScroll:GetCanvas():Clear()    // clear list before populating it again
            nssv2.ClientData.Frame.mainPanel.forSalePanel.itemScroll:PopulateList(nssv2.ClientData.Frame.itemsForSale)
        end
    elseif id == 2 then // update gui after disowning item
        local cashRegister = net.ReadEntity()
        local targetID = net.ReadUInt(32)   // id to be removed from list
        if nssv2.ClientData.Frame then 
            local itemsForSale = nssv2.ClientData.Frame.itemsForSale
            itemsForSale[targetID] = nil
            nssv2.ClientData.Frame.mainPanel.forSalePanel.itemScroll:GetCanvas():Clear()    // clear list before populating it again
            nssv2.ClientData.Frame.mainPanel.forSalePanel.itemScroll:PopulateList(nssv2.ClientData.Frame.itemsForSale)
            nssv2.ClientData.Frame.mainPanel.forSalePanel.label:SetText(nssv2:GetPhrase("ItemsForSale",table.Count(itemsForSale),nssv2.Config.CashRegisterMaxItems(cashRegister:GetOwner(),cashRegister)))
            timer.Simple(5*FrameTime(), function()
                nssv2.ClientData.Frame.mainPanel.avaibleItemsPanel.itemScroll:GetCanvas():Clear()    // clear list before populating it again
                nssv2.ClientData.Frame.mainPanel.avaibleItemsPanel.itemScroll:PopulateList(nssv2:findEntities(cashRegister))
            end)
        end
    elseif id == 3 then // open buy gui
        local item = net.ReadEntity()
        if not item then return end
        nssv2:OpenItemForSaleGUI(item)
    end
end)
