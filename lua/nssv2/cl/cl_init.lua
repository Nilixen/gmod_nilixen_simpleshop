surface.CreateFont("nssv2-15", {font = "LEMONMILK-Regular", size = 15})
surface.CreateFont("nssv2-20", {font = "LEMONMILK-Regular", size = 20})
surface.CreateFont("nssv2-25", {font = "LEMONMILK-Regular", size = 25})
surface.CreateFont("nssv2alt-25", {font = "Calibri", size = 25})
surface.CreateFont("nssv2-30", {font = "LEMONMILK-Regular", size = 30})
surface.CreateFont("nssv2alt-30", {font = "Calibri", size = 30})
surface.CreateFont("nssv2-30Shadow", {font = "LEMONMILK-Regular", size = 30, shadow=true})
surface.CreateFont("nssv2-40", {font = "LEMONMILK-Regular", size = 40})
surface.CreateFont("nssv2-40Shadow", {font = "LEMONMILK-Regular", size = 40, shadow=true})
surface.CreateFont("nssv2-50", {font = "LEMONMILK-Regular", size = 50})
surface.CreateFont("nssv2-50Shadow", {font = "LEMONMILK-Regular", size = 50, shadow=true})
surface.CreateFont("nssv2-60", {font = "LEMONMILK-Regular", size = 60})
surface.CreateFont("nssv2-60Shadow", {font = "LEMONMILK-Regular", size = 60, shadow=true})
surface.CreateFont("nssv2-70", {font = "LEMONMILK-Regular", size = 70})
surface.CreateFont("nssv2-70Shadow", {font = "LEMONMILK-Regular", size = 70, shadow=true})
surface.CreateFont("nssv2-80", {font = "LEMONMILK-Regular", size = 80})
surface.CreateFont("nssv2-80Shadow", {font = "LEMONMILK-Regular", size = 80, shadow=true})

nssv2.ClientData = nssv2.ClientData or {}

nssv2.PostDrawEntities = {}
function nssv2:PostDraw()
	for k, v in pairs(nssv2.PostDrawEntities) do
		if IsValid(v) and v.PostDraw and v:GetPos():Distance( LocalPlayer():GetPos() ) < 500 then
			v:PostDraw()
		end
	end
	nssv2.PostDrawEntities = {}
end
hook.Add( "PostDrawOpaqueRenderables", "nssv2_PostDraw", nssv2.PostDraw )


function nssv2:findEntities(cashRegister)

    local tbl = ents.FindInSphere(cashRegister:GetPos(), nssv2.Config.CashRegisterAddRange)
    local rTbl = {}

    for k,v in pairs(tbl) do
        if not nssv2.Config.SellableEntities[v:GetClass()] then continue end
        if not nssv2.Config.SellableEntities[v:GetClass()].setUpCheck(v) then continue end
        rTbl[table.Count(rTbl)+1] = {
            ent = v,
            dist = cashRegister:GetPos():Distance(v:GetPos()),
        }    
    end
    return rTbl
    
    
end


function nssv2:OpenItemForSaleGUI(item)

    if nssv2.ClientData.FrameSale then 
        nssv2.ClientData.FrameSale:Remove()
    end

    local shopColor = item:GetOwner():GetShopColor():ToColor()
    local canAfford = LocalPlayer():canAfford(item:GetPrice())



    nssv2.ClientData.FrameSale = vgui.Create("EditablePanel")
    local frame = nssv2.ClientData.FrameSale
    frame.itemsForSale = itemsForSale
    frame:SetSize(250,145)
    frame:Center()
    frame:MakePopup()
    // header
        frame.header = frame:Add("Panel")
        frame.header:Dock(TOP)
        frame.header.Paint = function (panel,w,h)
            draw.RoundedBoxEx(6,0,0,w,h,shopColor,true,true,false,false)
            draw.RoundedBox(0,0,h-3,w,3,nssv2.guiColors.boxes.blended)
            draw.SimpleText(nssv2:GetPhrase("ItemForSale"), "nssv2-30Shadow", w/2, h/2, nssv2.guiColors.text.white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end


        frame.mainPanel = frame:Add("Panel")
        local mainPanel = frame.mainPanel
        mainPanel:Dock(FILL)
        mainPanel.Paint = function(s,w,h)
            draw.RoundedBoxEx(6,0,0,w,h,nssv2.guiColors.boxes.secondary,false,false,true,true)
       end

        frame.mainPanel.info = frame.mainPanel:Add("Panel")
        local info = frame.mainPanel.info
        info:Dock(TOP)
        info.Paint = function(s,w,h)
            if not IsValid(item) then return end
            draw.SimpleText(item:GetDataType(), "nssv2-20", w/2,0, nssv2.guiColors.text.primary, TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP)
            draw.SimpleText(item:GetDataName(), string.len(item:GetDataName()) < 10 and "nssv2-40" or "nssv2-30", w/2,50, shopColor, TEXT_ALIGN_CENTER,TEXT_ALIGN_BOTTOM)
            draw.SimpleText(DarkRP.formatMoney(item:GetPrice()), string.len(item:GetPrice()) < 10 and "nssv2-40" or "nssv2-30", w/2,40, nssv2.guiColors.text.positive, TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP)
        end

        frame.mainPanel.cancelButton = frame.mainPanel:Add("DButton")
        local cancelButton = frame.mainPanel.cancelButton
        cancelButton:DockMargin(4,4,4,4)
        cancelButton:Dock(RIGHT)
        cancelButton:SetText(nssv2:GetPhrase("Cancel"))
        cancelButton:SetTextColor(nssv2.guiColors.text.white)
        cancelButton:SetFont("nssv2-20")
        cancelButton.DoClick = function()
            frame:Remove()
        end
        cancelButton.fill = 0
        cancelButton.posx, cancelButton.posy = 0,0
        cancelButton.Paint = function(s,w,h)
            draw.RoundedBox(6,0,0,w,h,nssv2.guiColors.text.negative)
            if s:IsHovered() then
                s.fill = Lerp(5* FrameTime(),s.fill,1.1)
                s.posx,s.posy = s:CursorPos()
            else
                s.fill = Lerp(5 * FrameTime(),s.fill,0)
            end
            draw.RoundedBox(s:GetWide(),s.posx-(s:GetWide()*s.fill),s.posy-(s:GetWide()*s.fill),(s:GetWide()*s.fill)*2,(s:GetWide()*s.fill)*2,nssv2.guiColors.boxes.blended)
        end

        frame.mainPanel.confirmButton = frame.mainPanel:Add("DButton")
        local confirmButton = frame.mainPanel.confirmButton
        confirmButton:DockMargin(4,4,4,4)
        confirmButton:Dock(LEFT)
        confirmButton:SetText(canAfford and nssv2:GetPhrase("Buy") or nssv2:GetPhrase("CantAfford"))
        confirmButton:SetTextColor(nssv2.guiColors.text.white)
        confirmButton:SetFont("nssv2-20")
        confirmButton.DoClick = function()
            if not canAfford then return end
            net.Start("nssv2_net")
                net.WriteUInt(2,4)
                net.WriteEntity(item)
            net.SendToServer()
            frame:Remove()
        end

        confirmButton.fill = 0
        confirmButton.posx, confirmButton.posy = 0,0
        confirmButton.Paint = function(s,w,h)
            draw.RoundedBox(6,0,0,w,h,(canAfford and nssv2.guiColors.text.positive or nssv2.guiColors.text.negative))
            if s:IsHovered() and canAfford then
                s.fill = Lerp(5* FrameTime(),s.fill,1.1)
                s.posx,s.posy = s:CursorPos()
            else
                s.fill = Lerp(5 * FrameTime(),s.fill,0)
            end
            draw.RoundedBox(s:GetWide(),s.posx-(s:GetWide()*s.fill),s.posy-(s:GetWide()*s.fill),(s:GetWide()*s.fill)*2,(s:GetWide()*s.fill)*2,nssv2.guiColors.boxes.blended)
        end



        frame.mainPanel.PerformLayout = function(s,w,h)
            s.info:SetTall(h*.70)
            s.cancelButton:SetWide(w/2-8)
            s.confirmButton:SetWide(w/2-8)
        end

    frame.PerformLayout = function(s,w,h)
        s.header:SetTall(32)
    end
    frame.Think = function(s)
        if not IsValid(item) then
            s:Remove()
        end
    end
end

function nssv2:OpenCashRegisterGUI(cashRegister,itemsForSale,stats,metalDetectors)

    if nssv2.ClientData.Frame then 
        nssv2.ClientData.Frame:Remove()
    end

    local shopColor = cashRegister:GetShopColor():ToColor()

    nssv2.ClientData.Frame = vgui.Create("EditablePanel")
    local frame = nssv2.ClientData.Frame
    frame.itemsForSale = itemsForSale
    frame:SetSize(1000,600)
    frame:Center()
    frame:MakePopup()
    // header
        frame.header = frame:Add("Panel")
        frame.header:Dock(TOP)
        frame.header.Paint = function (panel,w,h)
            draw.RoundedBoxEx(6,0,0,w,h,shopColor,true,true,false,false)
            draw.RoundedBox(0,0,0,w,h,nssv2.guiColors.boxes.blended)
            draw.RoundedBox(0,0,h-3,w,3,nssv2.guiColors.boxes.blended)
            draw.SimpleText(nssv2:GetPhrase("CashRegister"), "nssv2-30Shadow", w/2, h/2, nssv2.guiColors.text.white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
            frame.header.closeButton = frame.header:Add("DButton")
            local closeButton = frame.header.closeButton
            closeButton:DockMargin(4,4,4,7)
            closeButton:Dock(RIGHT)
            closeButton:SetText(nssv2:GetPhrase("Close"))
            closeButton:SetTextColor(nssv2.guiColors.text.white)
            closeButton:SetFont("nssv2-20")
            closeButton.DoClick = function()
                frame:Remove()
            end
            closeButton.fill = 0
            closeButton.posx, closeButton.posy = 0,0
            closeButton.Paint = function(s,w,h)
                draw.RoundedBox(6,0,0,w,h,Color(200,50,50))
                if s:IsHovered() then
                    s.fill = Lerp(5* FrameTime(),s.fill,1.1)
                    s.posx,s.posy = s:CursorPos()
                else
                    s.fill = Lerp(5 * FrameTime(),s.fill,0)
                end
                draw.RoundedBox(s:GetWide(),s.posx-(s:GetWide()*s.fill),s.posy-(s:GetWide()*s.fill),(s:GetWide()*s.fill)*2,(s:GetWide()*s.fill)*2,nssv2.guiColors.boxes.blended)
            end
            // settings button
            frame.header.settingsButton = frame.header:Add("DButton")
            local settingsButton = frame.header.settingsButton
            settingsButton:DockMargin(4,4,4,7)
            settingsButton:Dock(RIGHT)
            settingsButton:SetText(nssv2:GetPhrase("Settings"))
            settingsButton:SetTextColor(nssv2.guiColors.text.white)
            settingsButton:SetFont("nssv2-20")
            settingsButton.DoClick = function()
                frame.settings:SetVisible(true)
                frame.mainPanel:SetVisible(false)
                frame.header.settingsButton:SetVisible(false)
                frame.header.backSettingsButton:SetVisible(true)
            end
            settingsButton.fill = 0
            settingsButton.posx, settingsButton.posy = 0,0
            settingsButton.Paint = function(s,w,h)
                draw.RoundedBox(6,0,0,w,h,Color(40,94,129))
                if s:IsHovered() then
                    s.fill = Lerp(5* FrameTime(),s.fill,1.1)
                    s.posx,s.posy = s:CursorPos()
                else
                    s.fill = Lerp(5 * FrameTime(),s.fill,0)
                end
                draw.RoundedBox(s:GetWide(),s.posx-(s:GetWide()*s.fill),s.posy-(s:GetWide()*s.fill),(s:GetWide()*s.fill)*2,(s:GetWide()*s.fill)*2,nssv2.guiColors.boxes.blended)
            end
            // back from settings button
            frame.header.backSettingsButton = frame.header:Add("DButton")
            local backSettingsButton = frame.header.backSettingsButton
            backSettingsButton:DockMargin(4,4,4,7)
            backSettingsButton:Dock(RIGHT)
            backSettingsButton:SetText(nssv2:GetPhrase("Back"))
            backSettingsButton:SetTextColor(nssv2.guiColors.text.white)
            backSettingsButton:SetFont("nssv2-20")
            backSettingsButton.DoClick = function()
                frame.settings:SetVisible(false)
                frame.mainPanel:SetVisible(true)
                frame.header.backSettingsButton:SetVisible(false)
                frame.header.settingsButton:SetVisible(true)
                net.Start("nssv2_net")
                    net.WriteUInt(4,4)
                    net.WriteEntity(cashRegister)
                    net.WriteTable(frame.settings.colorPanel.picker:GetColor())
                net.SendToServer()
            end
            backSettingsButton.fill = 0
            backSettingsButton.posx, backSettingsButton.posy = 0,0
            backSettingsButton.Paint = function(s,w,h)
                draw.RoundedBox(6,0,0,w,h,Color(54,112,52))
                if s:IsHovered() then
                    s.fill = Lerp(5* FrameTime(),s.fill,1.1)
                    s.posx,s.posy = s:CursorPos()
                else
                    s.fill = Lerp(5 * FrameTime(),s.fill,0)
                end
                draw.RoundedBox(s:GetWide(),s.posx-(s:GetWide()*s.fill),s.posy-(s:GetWide()*s.fill),(s:GetWide()*s.fill)*2,(s:GetWide()*s.fill)*2,nssv2.guiColors.boxes.blended)
            end
            backSettingsButton:SetVisible(false)

        frame.header.PerformLayout = function(s,w,h)
            s.closeButton:SizeToContentsX(8)
            s.settingsButton:SizeToContentsX(8)
            s.backSettingsButton:SizeToContentsX(8)
        end

    // settings panel

        frame.settings = frame:Add("Panel")
        local settings = frame.settings
        settings:Dock(FILL)
        settings.Paint = function(s,w,h)
            draw.RoundedBoxEx(6,0,0,w,h,nssv2.guiColors.boxes.secondary,false,false,true,true)
        end
        settings:SetVisible(false)

        // color panel
            frame.settings.colorPanel = frame.settings:Add("Panel")
            local colorPanel = frame.settings.colorPanel
            colorPanel:Dock(LEFT)
            colorPanel:DockMargin(8,8,4,8)
            colorPanel.Paint = function(s,w,h)
                draw.RoundedBox(6,0,0,w,h,nssv2.guiColors.boxes.tertiary)
            end

                frame.settings.colorPanel.label = frame.settings.colorPanel:Add("DLabel")
                local label = frame.settings.colorPanel.label
                label:Dock(TOP)
                label:DockMargin(0,0,0,4)
                label:SetContentAlignment(8)
                label:SetText(nssv2:GetPhrase("ThemeSettings"))
                label:SetTextColor(nssv2.guiColors.text.primary)
                label:SetFont("nssv2alt-30")

                frame.settings.colorPanel.picker = frame.settings.colorPanel:Add("DColorMixer")
                local colorPicker = frame.settings.colorPanel.picker
                colorPicker:Dock(TOP)
                colorPicker:SetAlphaBar(false)
                colorPicker:DockMargin(4,4,4,4)
                colorPicker:SetColor(shopColor)
                colorPicker.ValueChanged = function(s, col)
                    shopColor = col
                end

            colorPanel.PerformLayout = function(s,w,h)
                s.label:SizeToContentsY()
            end

            frame.settings.metalDetectorPanel = frame.settings:Add("Panel")
            local metalDetectorPanel = frame.settings.metalDetectorPanel
            metalDetectorPanel:Dock(TOP)
            metalDetectorPanel:DockMargin(4,8,8,4)
            metalDetectorPanel.Paint = function(s,w,h)
                draw.RoundedBox(6,0,0,w,h,nssv2.guiColors.boxes.tertiary)
            end

                frame.settings.metalDetectorPanel.label = frame.settings.metalDetectorPanel:Add("DLabel")
                local label = frame.settings.metalDetectorPanel.label
                label:Dock(TOP)
                label:DockMargin(0,0,0,4)
                label:SetContentAlignment(8)
                label:SetText(nssv2:GetPhrase("AdditionsSettings"))
                label:SetTextColor(nssv2.guiColors.text.primary)
                label:SetFont("nssv2alt-30")

                frame.settings.metalDetectorPanel.spawnPanel = frame.settings.metalDetectorPanel:Add("Panel")
                local spawnPanel = frame.settings.metalDetectorPanel.spawnPanel
                spawnPanel:Dock(LEFT)

                frame.settings.metalDetectorPanel.spawnPanel.label = frame.settings.metalDetectorPanel.spawnPanel:Add("DLabel")
                local label = frame.settings.metalDetectorPanel.spawnPanel.label
                label:Dock(TOP)
                label:DockMargin(4,0,4,4)
                label:SetContentAlignment(8)
                label:SetText(nssv2:GetPhrase("MetalDetectorCount",table.Count(metalDetectors),nssv2.Config.CashRegisterMaxMetalDetectors(LocalPlayer(),cashRegister)))
                label:SetTextColor(nssv2.guiColors.text.primary)
                label:SetFont("nssv2alt-25")

                // add button
                frame.settings.metalDetectorPanel.spawnPanel.spawnButton = frame.settings.metalDetectorPanel.spawnPanel:Add("DButton")
                local spawnButton = frame.settings.metalDetectorPanel.spawnPanel.spawnButton
                spawnButton:DockMargin(4,4,4,4)
                spawnButton:Dock(FILL)
                spawnButton:SetText("")
                spawnButton.DoClick = function()
                    local bool = table.Count(metalDetectors) < nssv2.Config.CashRegisterMaxMetalDetectors(LocalPlayer(),cashRegister)
                    if not bool then return end
                    net.Start("nssv2_net")
                        net.WriteUInt(5,4)
                        net.WriteEntity(cashRegister)
                    net.SendToServer()
                    table.insert(metalDetectors,1,{})
                    frame.settings.metalDetectorPanel.spawnPanel.label:SetText(nssv2:GetPhrase("MetalDetectorCount",table.Count(metalDetectors),nssv2.Config.CashRegisterMaxMetalDetectors(LocalPlayer(),cashRegister)))
                end
                spawnButton.fill, spawnButton.sfill = 0,0
                spawnButton.posx, spawnButton.posy = 0,0
                spawnButton.Paint = function(s,w,h)
                    local bool = table.Count(metalDetectors) < nssv2.Config.CashRegisterMaxMetalDetectors(LocalPlayer(),cashRegister)

                    draw.RoundedBox(6,0,0,w,h,nssv2.guiColors.text.positive)
                    draw.RoundedBox(6,0,0,w,h,ColorAlpha(nssv2.guiColors.text.negative,255*s.sfill))

                    if s:IsHovered() then
                        s.fill = Lerp(3* FrameTime(),s.fill,1.1)
                        s.posx,s.posy = s:CursorPos()
                    else
                        s.fill = Lerp(5 * FrameTime(),s.fill,0)
                    end
                    if bool then
                        s.sfill = Lerp(3* FrameTime(),s.sfill,0)
                    else
                        s.sfill = Lerp(5 * FrameTime(),s.sfill,1)
                    end
                    draw.RoundedBox(s:GetWide(),s.posx-(s:GetWide()*s.fill),s.posy-(s:GetWide()*s.fill),(s:GetWide()*s.fill)*2,(s:GetWide()*s.fill)*2,nssv2.guiColors.boxes.blended)
                    draw.SimpleText(bool and nssv2:GetPhrase("Spawn") or nssv2:GetPhrase("LimitReached"),"nssv2-20",w/2,h/2, nssv2.guiColors.text.white,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
                
                end


            metalDetectorPanel.PerformLayout = function(s,w,h)
                s.label:SizeToContentsY()
                s.spawnPanel.label:SizeToContentsY()
                s.spawnPanel:SetWide(w*0.35)
            end

        frame.settings.PerformLayout = function(s,w,h)
            s.colorPanel:SetWide(w/3-8)
            s.metalDetectorPanel:SetTall(100)
        end

    // main panel
        frame.mainPanel = frame:Add("Panel")
        local mainPanel = frame.mainPanel
        mainPanel.selected = {}
        mainPanel.Select = function(s,selection,type,panel,ent)
            mainPanel.selected = {type = type, selection = selection, panel = panel, entity = ent}
            if type == "a" then
                mainPanel.editPanel.addPanel:SetVisible(true)
                mainPanel.editPanel.ownedPanel:SetVisible(false)
            elseif type == "o" then
                mainPanel.editPanel.addPanel:SetVisible(false)
                mainPanel.editPanel.ownedPanel:SetVisible(true)
            end
        end
        mainPanel.IsSelected = function(s,panel)
            return s.selected.panel == panel 
        end
        mainPanel:Dock(FILL)
        mainPanel.Paint = function(s,w,h)
            draw.RoundedBoxEx(6,0,0,w,h,nssv2.guiColors.boxes.secondary,false,false,true,true)
        end
    // avaible items panel
            frame.mainPanel.avaibleItemsPanel = frame.mainPanel:Add("Panel")
            local avaibleItemsPanel = frame.mainPanel.avaibleItemsPanel
            avaibleItemsPanel:Dock(LEFT)
            avaibleItemsPanel:DockMargin(8,8,4,8)
            avaibleItemsPanel.Paint = function(s,w,h)
                draw.RoundedBox(6,0,0,w,h,nssv2.guiColors.boxes.tertiary)
            end
            frame.mainPanel.avaibleItemsPanel.label = frame.mainPanel.avaibleItemsPanel:Add("DLabel")
            local label = frame.mainPanel.avaibleItemsPanel.label
            label:Dock(TOP)
            label:DockMargin(0,0,0,4)
            label:SetContentAlignment(8)
            label:SetText(nssv2:GetPhrase("AvaibleItems"))
            label:SetTextColor(nssv2.guiColors.text.primary)
            label:SetFont("nssv2alt-30")


            frame.mainPanel.avaibleItemsPanel.itemScroll = frame.mainPanel.avaibleItemsPanel:Add("DScrollPanel")
            local itemScroll = frame.mainPanel.avaibleItemsPanel.itemScroll
            itemScroll:Dock(FILL)
            itemScroll:DockMargin(0,0,0,4)
            itemScroll:GetVBar():SetWide(0)
            itemScroll.Children = {}
            itemScroll.PopulateList = function(s,itemsFound)
                for i,tbl in ipairs(itemsFound) do
                    local ent = tbl.ent
                    local dist = tbl.dist
                    local confEnt = nssv2.Config.SellableEntities[ent:GetClass()]
                    local itemPanel = itemScroll:Add("DButton")
                    itemPanel:SetText("")
                    itemPanel:Dock(TOP)
                    itemPanel:DockMargin(4,0,4,4)
                    itemPanel:SetTall(60)
                    itemPanel.fill = 0
                    itemPanel.Paint = function(s,w,h)
                        if s:IsHovered() or s.model:IsHovered() or frame.mainPanel:IsSelected(s) then
                            s.fill = math.min(Lerp(10*FrameTime(),s.fill,1.02),1)
                        else
                            s.fill = math.max(Lerp(15*FrameTime(),s.fill,-0.02),0)
                        end
                        draw.RoundedBox(6,0,0,w,h,nssv2.guiColors.boxes.primary)
                        draw.RoundedBox(6,0,0,w,h,ColorAlpha(shopColor,255*s.fill))
                        draw.RoundedBox(6,1,1,w-2,h-2,nssv2.guiColors.boxes.primary)
                    end
                    itemPanel.PaintOver = function(s,w,h)
                        draw.SimpleText(confEnt.CustomName(ent) and confEnt.TypeName or "", "nssv2-20", w/2, 0, nssv2.guiColors.text.primary, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
                        draw.SimpleText(confEnt.CustomName(ent) or confEnt.TypeName or "", "nssv2-30", w/2, h/2, shopColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                        draw.SimpleText(nssv2:GetPhrase("Distance",math.Round(dist * 1.905 / 100,2)), "nssv2-15", w/2, h, nssv2.guiColors.text.secondary, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
                    
                        draw.RoundedBox(6,1,1,w-2,h-2,ColorAlpha(color_black,250*s.fill))
                        draw.SimpleText(frame.mainPanel:IsSelected(s) and nssv2:GetPhrase("Selected") or nssv2:GetPhrase("Select") , "nssv2-30", w/2, h/2, ColorAlpha(shopColor,255*s.fill), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                    end
                    itemPanel.DoClick = function(s)
                        frame.mainPanel:Select(i,"a",s,ent)
                    end
                    itemScroll.Children[i] = itemPanel

                        itemPanel.model = itemPanel:Add("DModelPanel")
                        local model = itemPanel.model
                        model:Dock(LEFT)
                        model:DockMargin(4,4,4,4)
                        model.LayoutEntity = function() return end
                        model:SetModel(ent:GetModel() or "model/error.mdl")
                        local mn, mx = model.Entity:GetRenderBounds()
                        local size = 0
                        size = math.max(size, math.abs(mn.x) + math.abs(mx.x))
                        size = math.max(size, math.abs(mn.y) + math.abs(mx.y))
                        size = math.max(size, math.abs(mn.z) + math.abs(mx.z))
                        local vector = Vector(20, 20, 20)
                        local fov = size*1.25
                        model:SetFOV(fov)
                        model:SetCamPos(Vector(size, size, size) + vector)
                        model:SetLookAt((mn + mx) * 0.5)
                        model:SetAmbientLight(Color(255,255,255))

                    itemPanel.PerformLayout = function(s,w,h)
                        model:SetWide(h)
                    end
                end
            end
            itemScroll:PopulateList(nssv2:findEntities(cashRegister))

            
    // items for sale panel
            frame.mainPanel.forSalePanel = frame.mainPanel:Add("Panel")
            local forSalePanel = frame.mainPanel.forSalePanel
            forSalePanel:Dock(RIGHT)
            forSalePanel:DockMargin(4,8,8,8)
            forSalePanel.Paint = function(s,w,h)
                draw.RoundedBox(6,0,0,w,h,nssv2.guiColors.boxes.tertiary)
            end
            frame.mainPanel.forSalePanel.label = frame.mainPanel.forSalePanel:Add("DLabel")
            local label = frame.mainPanel.forSalePanel.label
            label:Dock(TOP)
            label:DockMargin(0,0,0,4)
            label:SetContentAlignment(8)
            label:SetText(nssv2:GetPhrase("ItemsForSale",table.Count(itemsForSale),nssv2.Config.CashRegisterMaxItems(cashRegister:GetOwner(),cashRegister)))
            label:SetTextColor(nssv2.guiColors.text.primary)
            label:SetFont("nssv2alt-30")

            frame.mainPanel.forSalePanel.itemScroll = frame.mainPanel.forSalePanel:Add("DScrollPanel")
            local itemScroll = frame.mainPanel.forSalePanel.itemScroll
            itemScroll:Dock(FILL)
            itemScroll:DockMargin(0,0,0,4)
            itemScroll:GetVBar():SetWide(0)
            itemScroll.Children = {}

            itemScroll.PopulateList = function(s,tbl)
                if not tbl then return end
                for k,v in pairs(tbl) do
                    local itemPanel = itemScroll:Add("DButton")
                    itemPanel:SetText("")
                    itemPanel:Dock(TOP)
                    itemPanel:DockMargin(4,0,4,4)
                    itemPanel:SetTall(60)
                    itemPanel.fill = 0
                    itemPanel.Paint = function(s,w,h)
                        if s:IsHovered() or s.model:IsHovered() or frame.mainPanel:IsSelected(s) then
                            s.fill = math.min(Lerp(10*FrameTime(),s.fill,1.02),1)
                        else
                            s.fill = math.max(Lerp(15*FrameTime(),s.fill,-0.02),0)
                        end
                        draw.RoundedBox(6,0,0,w,h,nssv2.guiColors.boxes.primary)
                        draw.RoundedBox(6,0,0,w,h,ColorAlpha(shopColor,255*s.fill))
                        draw.RoundedBox(6,1,1,w-2,h-2,nssv2.guiColors.boxes.primary)
                    end
                    itemPanel.PaintOver = function(s,w,h)
                        draw.SimpleText(v.name and v.type, "nssv2-20", w/2, 0, nssv2.guiColors.text.primary, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
                        draw.SimpleText(v.name or v.type or "Invalid Name!", "nssv2-25", w/2, h/2, shopColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                        draw.SimpleText(DarkRP.formatMoney(v.price) or "Invalid Price!", "nssv2-20", w/2, h, nssv2.guiColors.text.positive, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
                        draw.SimpleText(nssv2:GetPhrase("ID",v.id), "nssv2-15", w, 0, nssv2.guiColors.text.secondary, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)

                        draw.RoundedBox(6,1,1,w-2,h-2,ColorAlpha(color_black,250*s.fill))
                        draw.SimpleText(frame.mainPanel:IsSelected(s) and nssv2:GetPhrase("Selected") or nssv2:GetPhrase("Select") , "nssv2-30", w/2, h/2, ColorAlpha(shopColor,255*s.fill), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                    end
                    itemPanel.DoClick = function(s)
                        frame.mainPanel:Select(k,"o",s,nil)
                        frame.mainPanel.editPanel.ownedPanel.disownSlider:SetSlideX(0)
                        frame.mainPanel.editPanel.ownedPanel.disownSlider.toBeDisowned = false
                    end
                    

                    itemScroll.Children[k] = itemPanel

                        itemPanel.model = itemPanel:Add("DModelPanel")
                        local model = itemPanel.model
                        model:Dock(LEFT)
                        model:DockMargin(4,4,4,4)
                        model.LayoutEntity = function() return end
                        model:SetModel(v.model or "model/error.mdl")
                        local mn, mx = model.Entity:GetRenderBounds()
                        local size = 0
                        size = math.max(size, math.abs(mn.x) + math.abs(mx.x))
                        size = math.max(size, math.abs(mn.y) + math.abs(mx.y))
                        size = math.max(size, math.abs(mn.z) + math.abs(mx.z))
                        local vector = Vector(20, 20, 20)
                        local fov = size*1.25
                        model:SetFOV(fov)
                        model:SetCamPos(Vector(size, size, size) + vector)
                        model:SetLookAt((mn + mx) * 0.5)
                        model:SetAmbientLight(Color(255,255,255))

                    itemPanel.PerformLayout = function(s,w,h)
                        model:SetWide(h)
                    end

                end
            end
            itemScroll:PopulateList(frame.itemsForSale)

           

    // edit panel

            frame.mainPanel.editPanel = frame.mainPanel:Add("Panel")
            local editPanel = frame.mainPanel.editPanel
            editPanel:Dock(TOP)
            editPanel:DockMargin(4,8,4,8)
            editPanel.Paint = function(s,w,h)
                draw.RoundedBox(6,0,0,w,h,nssv2.guiColors.boxes.tertiary)
                draw.SimpleText(frame.mainPanel.selected.selection == nil and nssv2:GetPhrase("SelectItemFirst") or "", "nssv2-20", w/2, h/2, nssv2.guiColors.text.secondary, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end
                frame.mainPanel.editPanel.label = frame.mainPanel.editPanel:Add("DLabel")
                local label = frame.mainPanel.editPanel.label
                label:Dock(TOP)
                label:DockMargin(0,0,0,0)
                label:SetContentAlignment(8)
                label:SetText(nssv2:GetPhrase("Edit"))
                label:SetTextColor(nssv2.guiColors.text.primary)
                label:SetFont("nssv2alt-30")
                
            // add Panel
                frame.mainPanel.editPanel.addPanel = frame.mainPanel.editPanel:Add("Panel")
                local addPanel = frame.mainPanel.editPanel.addPanel
                addPanel:Dock(FILL)
                addPanel.Paint = function(s,w,h)
                    local confEnt = nssv2.Config.SellableEntities[frame.mainPanel.selected.entity:GetClass()]
                    local ent = frame.mainPanel.selected.entity
                    draw.SimpleText(confEnt.CustomName(ent) and confEnt.TypeName or "", "nssv2-20", w/2, 0, nssv2.guiColors.text.primary, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
                    draw.SimpleText(confEnt.CustomName(ent) or confEnt.TypeName or "", "nssv2-30", w/2, 15, shopColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
                end

                    // add button
                    frame.mainPanel.editPanel.addPanel.addButton = frame.mainPanel.editPanel.addPanel:Add("DButton")
                    local addButton = frame.mainPanel.editPanel.addPanel.addButton
                    addButton:DockMargin(4,8,4,4)
                    addButton:Dock(BOTTOM)
                    addButton:SetText("")
                    addButton.DoClick = function()
                        if table.Count(frame.itemsForSale) >= nssv2.Config.CashRegisterMaxItems(LocalPlayer(),cashRegister) then return end
                        local bool = (frame.mainPanel.editPanel.addPanel.priceEntry:GetInt() or 0) > 0
                        if not bool then return end
                        net.Start("nssv2_net")
                            net.WriteUInt(0,4)
                            net.WriteEntity(cashRegister)
                            net.WriteEntity(frame.mainPanel.selected.entity)
                            net.WriteUInt(frame.mainPanel.editPanel.addPanel.priceEntry:GetInt(),32)
                        net.SendToServer()
                        mainPanel.editPanel.addPanel:SetVisible(false)  // make add panel not visible to prevent errors
                        frame.mainPanel.selected.panel:Remove() // remove panel to prevent errors 
                        frame.mainPanel.selected = {}   // clear selected
                    end
                    addButton.fill,addButton.hov = 0,0
                    addButton.Paint = function(s,w,h)
                        local limitMet = table.Count(frame.itemsForSale) < nssv2.Config.CashRegisterMaxItems(LocalPlayer(),cashRegister)
                        local priceEntered = (frame.mainPanel.editPanel.addPanel.priceEntry:GetInt() or 0) > 0
                        local bool = limitMet and priceEntered
                        if bool then
                            s.fill = Lerp(5* FrameTime(),s.fill,1.1)
                        else
                            s.fill = Lerp(5 * FrameTime(),s.fill,0)
                        end
                        if s:IsHovered() and bool then
                            s.hov = math.min(Lerp(5* FrameTime(),s.hov,1.1),1)
                        else
                            s.hov = math.max(Lerp(5 * FrameTime(),s.hov,-0.1),0)
                        end

                        draw.RoundedBox(6,0,0,w,h,nssv2.guiColors.text.negative)
                        draw.RoundedBox(6,0,0,w,h,ColorAlpha(nssv2.guiColors.text.positive,s.fill*255))
                        draw.RoundedBox(6,0,0,w*s.hov,h,nssv2.guiColors.boxes.blended)
                        
                        draw.SimpleText(bool and nssv2:GetPhrase("Add") or limitMet and nssv2:GetPhrase("EnterPrice") or nssv2:GetPhrase("LimitReached"),"nssv2-20",w/2,h/2, nssv2.guiColors.text.white,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
                    end


                // price entry
                    frame.mainPanel.editPanel.addPanel.priceEntry = frame.mainPanel.editPanel.addPanel:Add("DTextEntry")
                    local priceEntry = frame.mainPanel.editPanel.addPanel.priceEntry
                    priceEntry:Dock(BOTTOM)
                    priceEntry:DockMargin(4,4,4,0)
                    priceEntry:SetNumeric(true)
                    priceEntry:SetFont("nssv2-30")
                    priceEntry.Paint = function(s,w,h)
                        draw.RoundedBox(6,0,0,w,h,nssv2.guiColors.boxes.secondary)
                        s:DrawTextEntryText(s:IsEditing() and nssv2.guiColors.text.primary or nssv2.guiColors.text.secondary, nssv2.guiColors.boxes.blended, shopColor)		
                    end
                
                addPanel:SetVisible(false)

                // owned Pannel
                frame.mainPanel.editPanel.ownedPanel = frame.mainPanel.editPanel:Add("Panel")
                local ownedPanel = frame.mainPanel.editPanel.ownedPanel
                ownedPanel:Dock(FILL)
                ownedPanel.data = {}
                ownedPanel.Paint = function(s,w,h)
                    s.data = frame.itemsForSale[frame.mainPanel.selected.selection] or s.data
                    draw.SimpleText(s.data.name and s.data.type or "", "nssv2-20", w/2, 0, nssv2.guiColors.text.primary, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
                    draw.SimpleText(s.data.name or s.data.type or "", "nssv2-30", w/2, 15, shopColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
                    draw.SimpleText(DarkRP.formatMoney(s.data.price) or "Invalid Price!", "nssv2-20", w/2, 40, nssv2.guiColors.text.positive, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
                end

                frame.mainPanel.editPanel.ownedPanel.disownSlider = frame.mainPanel.editPanel.ownedPanel:Add("DSlider")
                local disownSlider = frame.mainPanel.editPanel.ownedPanel.disownSlider
                disownSlider:Dock(BOTTOM)
                disownSlider:DockMargin(4,0,4,4)
                disownSlider:SetSlideX(0)
                disownSlider:SetTrapInside( true )
                disownSlider.fill = 0
                disownSlider.toBeDisowned = false
                disownSlider.Paint = function(s,w,h)
                    if s:GetSlideX() > 0.9 then
                        s.fill = Lerp(5*FrameTime(),s.fill,1)
                    else
                        s.fill = Lerp(15*FrameTime(),s.fill,0)
                    end

                    draw.RoundedBox(6,0,0,w,h,nssv2.guiColors.boxes.secondary)
                    draw.SimpleText(nssv2:GetPhrase("SlideToDisOwn"), "nssv2-20", w/2, h/2, nssv2.guiColors.text.primary, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                    draw.RoundedBox(6,1,1,(w-5)*s:GetSlideX()+5,h-2,shopColor)
                    draw.RoundedBox(6,1,1,(w-5)*s:GetSlideX()+5,h-2,nssv2.guiColors.boxes.blended)
                    draw.RoundedBox(6,(w-15)*s:GetSlideX(),1,15,h-2,shopColor)
                    draw.SimpleText(nssv2:GetPhrase("NowRelease"), "nssv2-20", w/2, h/2, ColorAlpha(nssv2.guiColors.text.primary,255*s.fill), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

                end
                disownSlider.Knob.Paint = function(s,w,h) end // make invisible, cuz we're drawing custom one in slider paint
                disownSlider.Think = function(s)
                    if not s:IsEditing() then
                        s:SetSlideX(Lerp(5*FrameTime(),s:GetSlideX(),0))
                    end
                    if s:GetSlideX() > 0.9 then    // if player swipes past 0.95 mark then mark to be disowned 
                        disownSlider.toBeDisowned = true
                    end

                    if s:GetSlideX() < 0.9 and disownSlider.toBeDisowned and s:IsEditing() then    // if player swipes back to the start, then abort
                        disownSlider.toBeDisowned = false
                    elseif s:GetSlideX() <= 0.005 and disownSlider.toBeDisowned and not s:IsEditing() then
                        net.Start("nssv2_net")
                            net.WriteUInt(1,4)
                            net.WriteEntity(cashRegister)
                            net.WriteUInt(frame.mainPanel.selected.selection,32)
                        net.SendToServer()
                        disownSlider.toBeDisowned = false
                        mainPanel.editPanel.ownedPanel:SetVisible(false)  // make add panel not visible to prevent errors
                        frame.mainPanel.selected.panel:Remove() // remove panel to prevent errors 
                        frame.mainPanel.selected = {}   // clear selected
                    end
                    
                end
                disownSlider.OnMousePressed = function(s) end
                ownedPanel:SetVisible(false)


            editPanel.PerformLayout = function(s,w,h)
                s.label:SizeToContentsY()
                s.addPanel.addButton:SetTall(30)
                s.addPanel.priceEntry:SetTall(30)
                s.ownedPanel.disownSlider:SetTall(40)

            end

            // money panel

            frame.mainPanel.moneyPanel = frame.mainPanel:Add("Panel")
            local moneyPanel = frame.mainPanel.moneyPanel
            moneyPanel:Dock(BOTTOM)
            moneyPanel:DockMargin(4,0,4,8)
            moneyPanel.Paint = function(s,w,h)
                draw.RoundedBox(6,0,0,w,h,nssv2.guiColors.boxes.tertiary)
            end
            
                frame.mainPanel.moneyPanel.label = frame.mainPanel.moneyPanel:Add("DLabel")
                local label = frame.mainPanel.moneyPanel.label
                label:Dock(TOP)
                label:SetContentAlignment(8)
                label:SetText(nssv2:GetPhrase("Money"))
                label:SetTextColor(nssv2.guiColors.text.primary)
                label:SetFont("nssv2alt-30")

                frame.mainPanel.moneyPanel.collectButton = frame.mainPanel.moneyPanel:Add("DButton")
                local collectButton = frame.mainPanel.moneyPanel.collectButton
                collectButton:DockMargin(4,8,4,4)
                collectButton:Dock(BOTTOM)
                collectButton:SetText("")
                collectButton.DoClick = function()
                    net.Start("nssv2_net")
                        net.WriteUInt(3,4)
                        net.WriteEntity(cashRegister)
                    net.SendToServer()
                end
                collectButton.fill,collectButton.hov = 0,0
                collectButton.Paint = function(s,w,h)

                    local bool = cashRegister:GetMoney() > 0
                    if bool then
                        s.fill = Lerp(5* FrameTime(),s.fill,1.1)
                    else
                        s.fill = Lerp(5 * FrameTime(),s.fill,0)
                    end
                    if s:IsHovered() and bool then
                        s.hov = math.min(Lerp(5* FrameTime(),s.hov,1.1),1)
                    else
                        s.hov = math.max(Lerp(5 * FrameTime(),s.hov,-0.1),0)
                    end

                    draw.RoundedBox(6,0,0,w,h,nssv2.guiColors.text.negative)
                    draw.RoundedBox(6,0,0,w,h,ColorAlpha(nssv2.guiColors.text.positive,s.fill*255))
                    draw.RoundedBox(6,0,0,w*s.hov,h,nssv2.guiColors.boxes.blended)
                    
                    draw.SimpleText(bool and nssv2:GetPhrase("Collect",DarkRP.formatMoney(math.max(cashRegister:GetMoney()* (1-nssv2.Config.Tax),0))) or nssv2:GetPhrase("NothingToCollect"),"nssv2-20",w/2,h/2, nssv2.guiColors.text.white,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
                end

                frame.mainPanel.moneyPanel.money = frame.mainPanel.moneyPanel:Add("Panel")
                local moneyInfo = frame.mainPanel.moneyPanel.money
                moneyInfo:Dock(FILL)
                moneyInfo.Paint = function(s,w,h)
                    draw.SimpleText(DarkRP.formatMoney(cashRegister:GetMoney()),"nssv2-40",w*.5,0,nssv2.guiColors.text.positive,TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP)
                    draw.SimpleText(nssv2:GetPhrase("Tax",nssv2.Config.Tax*100),"nssv2-20",w*.5,40,nssv2.guiColors.text.primary,TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP)
                    draw.SimpleText(nssv2:GetPhrase("TaxInfo"),"nssv2-15",w*.5,55,nssv2.guiColors.text.primary,TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP)
                end


            moneyPanel.PerformLayout = function(s,w,h)
                s.label:SizeToContentsY()
                s.collectButton:SetTall(40)

            end
            // stats panel

            frame.mainPanel.statsPanel = frame.mainPanel:Add("Panel")
            local statsPanel = frame.mainPanel.statsPanel
            statsPanel:Dock(FILL)
            statsPanel:DockMargin(4,0,4,8)
            statsPanel.Paint = function(s,w,h)
                draw.RoundedBox(6,0,0,w,h,nssv2.guiColors.boxes.tertiary)
            end

                frame.mainPanel.statsPanel.label = frame.mainPanel.statsPanel:Add("DLabel")
                local label = frame.mainPanel.statsPanel.label
                label:Dock(TOP)
                label:SetContentAlignment(8)
                label:SetText(nssv2:GetPhrase("Stats"))
                label:SetTextColor(nssv2.guiColors.text.primary)
                label:SetFont("nssv2alt-30")
                label.Paint = function(s,w,h)

                end

                frame.mainPanel.statsPanel.stats = frame.mainPanel.statsPanel:Add("Panel")
                local statsInfo = frame.mainPanel.statsPanel.stats
                statsInfo:Dock(TOP)
                local curtime = CurTime()
                statsInfo.Paint = function(s,w,h)
                    local totaltime = CurTime() - stats.time
                    local hr = math.floor(totaltime/3600)
                    local min = math.floor((totaltime - hr*3600 ) /60)
                    local sec = math.floor(totaltime - (hr*3600) - (min * 60))
                    draw.SimpleText(nssv2:GetPhrase("OpenFor",hr,min,sec),"nssv2-30",w*.5,0,nssv2.guiColors.text.primary,TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP)
                    draw.SimpleText(nssv2:GetPhrase("ProfitPerHour",DarkRP.formatMoney(math.ceil(stats.totalMoney/((curtime - stats.time)/3600)))),"nssv2-25",w*.5,25,nssv2.guiColors.text.primary,TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP)
                    
                    draw.SimpleText(nssv2:GetPhrase("TotalMoney",DarkRP.formatMoney(stats.totalMoney)),"nssv2-25",w*.5,55,nssv2.guiColors.text.secondary,TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP)
                    draw.SimpleText(nssv2:GetPhrase("TotalSold",stats.totalSold),"nssv2-25",w*.5,75,nssv2.guiColors.text.secondary,TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP)
                    
                end 


                frame.mainPanel.statsPanel.itemCount = frame.mainPanel.statsPanel:Add("Panel")
                local itemCount = frame.mainPanel.statsPanel.itemCount
                itemCount:Dock(TOP)

            statsPanel.PerformLayout = function(s,w,h)
                s.label:SizeToContentsY()
                s.stats:SetTall(h-s.label:GetTall())
            end


        frame.mainPanel.PerformLayout = function(s,w,h)
            s.avaibleItemsPanel.label:SizeToContentsY()
            s.avaibleItemsPanel:SetWide(w/3-8)
            s.forSalePanel.label:SizeToContentsY()
            s.forSalePanel:SetWide(w/3-8)
            s.editPanel:SetTall(150)
            s.moneyPanel:SetTall(150)
        end

    frame.PerformLayout = function(s,w,h)
        s.header:SetTall(32)
    end
    frame.Paint = function(s,w,h)
        draw.RoundedBoxEx(6,0,30,w,h-30,nssv2.guiColors.boxes.secondary,false,false,true,true)
        draw.SimpleText(nssv2:GetPhrase("SomethingWentWrong"), "nssv2-40", w/2, h/2, nssv2.guiColors.text.secondary, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end






end