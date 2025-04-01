// ---- FONTS ----
surface.CreateFont( "nss_50", {
	font = "Tahoma", --  Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = 50,
	weight = 10,
	blursize = 0,
	scanlines = 0,
	antialias = true,
} )
surface.CreateFont( "nss_40", {
	font = "Tahoma", --  Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = 40,
	weight = 10,
	blursize = 0,
	scanlines = 0,
	antialias = true,
} )
surface.CreateFont( "nss_30", {
	font = "Tahoma", --  Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = 30,
	weight = 10,
	blursize = 0,
	scanlines = 0,
	antialias = true,
} )
surface.CreateFont( "nss_20", {
	font = "Tahoma", --  Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = 20,
	weight = 10,
	blursize = 0,
	scanlines = 0,
	antialias = true,
} )
surface.CreateFont( "nss_15", {
	font = "Tahoma", --  Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = 15,
	weight = 10,
	blursize = 0,
	scanlines = 0,
	antialias = true,
} )

function nss:OpenCashRegisterGUI(ent,owned,notowned)

	local Owned = owned
	local Oselected,OID = nil
	local Onselected,OnID = nil

    ent.frame = vgui.Create("DFrame")
        ent.frame:SetSize(690,400)
        ent.frame:Center()
    	ent.frame:MakePopup()
        ent.frame:ShowCloseButton(true)
        ent.frame:SetDraggable(false)
        ent.frame:SetTitle(nss:getPhrase("CashRegister"))
		nss:PaintFrame( ent.frame)


	local MPanel = vgui.Create("DPanel", ent.frame)
		MPanel:SetWidth( ent.frame:GetWide()*.75)
		MPanel:Dock(LEFT)
		MPanel:DockMargin(0,0,0,0)
		MPanel.Paint = function() end

	local IPanel = vgui.Create("DPanel", ent.frame)
		IPanel:Dock(FILL)
		IPanel:DockMargin(0,0,0,5)
		nss:PaintPanel(IPanel)
		IPanel.PaintOver = function(s,w,h)
			draw.SimpleText(DarkRP.formatMoney(ent:GetMoney()),"nss_30",w*.5,20,Color(0,200,120),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
			draw.SimpleText(nss:getPhrase("Tax",(nss.Conf.Tax*100)),"nss_20",5,50,Color(255,255,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
			draw.SimpleText(nss:getPhrase("MaxItems",table.Count(owned),nss.Conf.ItemsLimit(ent:CPPIGetOwner())),"nss_20",5,70,Color(255,255,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
		end

		
	local ClaimButton = vgui.Create("DButton",IPanel)
		ClaimButton:SetTall(30)
		ClaimButton:SetWide(IPanel:GetWide()-10)
		ClaimButton:DockMargin( 5, 0, 5, 5 )
		ClaimButton:Dock(BOTTOM)
		ClaimButton.text = nss:getPhrase("Claim")
		ClaimButton:SetText("")
		ClaimButton.Paint = function(s,w,h)

			draw.RoundedBox(7.5,0,0,w,h,nss.Conf.GuiColor)
			draw.SimpleText(s.text,"nss_20",w*.5,h*.5,Color(255,255,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
		end
		function ClaimButton:OnCursorEntered()
			ClaimButton.Paint = function(s,w,h)
				draw.RoundedBox(7.5,0,0,w,h,Color(255,255,255))
				draw.SimpleText(s.text,"nss_20",w*.5,h*.5,nss.Conf.GuiColor,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
			end
		end
		function ClaimButton:OnCursorExited()
			ClaimButton.Paint = function(s,w,h)
				draw.RoundedBox(7.5,0,0,w,h,nss.Conf.GuiColor)
				draw.SimpleText(s.text,"nss_20",w*.5,h*.5,Color(255,255,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
			end
		end
		ClaimButton.DoClick = function()
			notification.AddLegacy(nss:getPhrase("CollectedNotify",DarkRP.formatMoney(ent:GetMoney())),NOTIFY_GENERIC,5)
			net.Start("nss_gui")
				net.WriteInt(4,4)
				net.WriteEntity(ent)
			net.SendToServer()
			
		end

	local BPanel = vgui.Create("DPanel",MPanel)
		BPanel:SetWide(MPanel:GetWide())
		BPanel:SetTall(40)
		BPanel:Dock(BOTTOM)
		BPanel:DockMargin(0,0,0,0)
		BPanel.Paint = function() end


	local AddButton = vgui.Create("DButton",BPanel)
		AddButton:SetTall(40)
		AddButton:SetWide(BPanel:GetWide()/2-7.5)
		AddButton:DockMargin( 5, 0, 5, 5 )
		AddButton:Dock(LEFT)
		AddButton:SetText(nss:getPhrase("Add"))
		nss:PaintItemButton(AddButton,Color(255,255,255),nss.Conf.GuiColor)
		AddButton.DoClick = function()
			if Oselected and OID then
				Derma_StringRequest("",nss:getPhrase("EnterPrice"),"2500",
				function(text)
					net.Start("nss_gui")
						net.WriteInt(1,4)
						net.WriteEntity(notowned[OID].ent)
						net.WriteEntity(ent)
						net.WriteInt(tonumber(text),32)
					net.SendToServer()
				end,
				function(text) end,nss:getPhrase("Confirm"),nss:getPhrase("Cancel"))
			end
		end
	
	local RemoveButton = vgui.Create("DButton",BPanel)
		RemoveButton:SetTall(40)
		RemoveButton:SetWide(BPanel:GetWide()/2-7.5)
		RemoveButton:DockMargin( 5, 0, 5, 5 )
		RemoveButton:Dock(RIGHT)
		RemoveButton:SetText(nss:getPhrase("Disown"))
		nss:PaintItemButton(RemoveButton,Color(255,255,255),Color(255,50,50))
		RemoveButton.DoClick = function()
			if Onselected and OnID then
				Derma_Query(
					nss:getPhrase("DisownAsk",nss.Conf.EntitiesWL[OnID:GetClass()].customPrintName(OnID)),"",nss:getPhrase("Confirm"),function()
					net.Start("nss_gui")
						net.WriteInt(3,4)
						net.WriteEntity(OnID)
						net.WriteEntity(ent)
					net.SendToServer()
				end,nss:getPhrase("Cancel"),function() end)
			end
		end

	local LPanel = vgui.Create("DPanel",MPanel)
		LPanel:SetWidth(MPanel:GetWide()/2-7.5)
		LPanel:Dock(LEFT)
		LPanel:DockMargin(5,0,0,5)
		nss:PaintPanel(LPanel)
	local RPanel = vgui.Create("DPanel",MPanel)
		RPanel:SetWidth(MPanel:GetWide()/2-7.5)
		RPanel:Dock(RIGHT)
		RPanel:DockMargin(0,0,5,5)
		nss:PaintPanel(RPanel)


	local Olist = vgui.Create("DScrollPanel",LPanel)
		Olist:Dock(FILL)
		nss:PaintScroll(Olist)

	
	for k,v in pairs(notowned) do

		if v.ent:GetNWBool("nss_forsale") then continue end

		local ent = nss.Conf.EntitiesWL[v.ent:GetClass()]
		local OItemPanel =  vgui.Create("DButton",Olist)
		OItemPanel:SetText(ent.customPrintName(v.ent))
		OItemPanel:SetTall(35)
		OItemPanel:Dock(TOP)
		OItemPanel:DockMargin(5,5,5,0)
		OItemPanel.i1 = nss:getPhrase("Distance",math.Round(v.dist * 1.905 / 100,2))
		nss:PaintItemButton(OItemPanel,Color(255,255,255),nss.Conf.GuiColor)
		OItemPanel.DoClick = function()
			if ispanel(Oselected) then Oselected.PaintOver = function() end end
			Oselected = OItemPanel
			OID = k
			Oselected.PaintOver = function(s,w,h)
				surface.SetDrawColor(Color(255,50,50))
				surface.DrawOutlinedRect(0,0,w,h,1)
			end

		end
	end
	local Onlist = vgui.Create("DScrollPanel",RPanel)
		Onlist:Dock(FILL)
		nss:PaintScroll(Onlist)

	for k,_ in pairs(owned) do
		if !k:GetNWBool("nss_forsale") then continue end
		local Cent = nss.Conf.EntitiesWL[k:GetClass()]

		local OnItemPanel =  vgui.Create("DButton",Onlist)
		OnItemPanel:SetText(Cent.customPrintName(k))
		OnItemPanel:SetTall(35)
		OnItemPanel:Dock(TOP)
		OnItemPanel:DockMargin(5,5,5,0)
		OnItemPanel.i1 = nss:getPhrase("Distance",math.Round(ent:GetPos():Distance(k:GetPos()) * 1.905 / 100,2))
		nss:PaintItemButton(OnItemPanel,Color(255,255,255),nss.Conf.GuiColor)
		OnItemPanel.DoClick = function()
			if ispanel(Onselected) then Onselected.PaintOver = function() end end
			Onselected = OnItemPanel
			OnID = k
			Onselected.PaintOver = function(s,w,h)
				surface.SetDrawColor(Color(255,50,50))
				surface.DrawOutlinedRect(0,0,w,h,1)
			end

		end
	end
end

function nss:OpenItemGUI(ent)

    if IsValid(ent.frame) then return end
    ent.frame = vgui.Create("DFrame")
        ent.frame:SetSize(250,85)
        ent.frame:Center()
        ent.frame:MakePopup()
        ent.frame:ShowCloseButton(false)
        ent.frame:SetDraggable(false)
		ent.frame:SetTitle(nss:getPhrase("Buy",nss.Conf.EntitiesWL[ent:GetClass()].customPrintName(ent)))
		nss:PaintFrame(ent.frame)

	local closeButton = vgui.Create("DButton",ent.frame)
		closeButton:SetWide(45)
		closeButton:DockMargin( 5, 5, 5, 5 )
		closeButton:Dock(RIGHT)
		closeButton:SetText("X")
		nss:PaintItemButton(closeButton,Color(255,50,50),Color(155,50,50))
		closeButton.DoClick = function()
			ent.frame:Remove()
		end
	local buyButton = vgui.Create("DButton",ent.frame)
		buyButton:DockMargin( 5, 5, 5, 5 )
		buyButton:Dock(FILL)
		buyButton:SetText(nss:getPhrase("BuyFor",DarkRP.formatMoney(ent:GetNWInt("nss_cost"))))
		nss:PaintItemButton(buyButton,Color(255,255,255),nss.Conf.GuiColor)
		buyButton.DoClick = function()
			ent.frame:Remove()
			net.Start("nss_gui")
				net.WriteInt(2,4)
				net.WriteEntity(ent)
			net.SendToServer()
		end
end

local blur = Material( "pp/blurscreen" )
function nss:Blur( panel, layers, density, alpha, type )
	if not type then type = 0 end
	-- Its a scientifically proven fact that blur improves a script
	local x, y = panel:LocalToScreen(0, 0)

	surface.SetDrawColor( 255, 255, 255, alpha )
	surface.SetMaterial( blur )

	for i = 1, 3 do
		blur:SetFloat( "$blur", ( i / layers ) * density )
		blur:Recompute()

		render.UpdateScreenEffectTexture()
		if type == 0 then
			surface.DrawTexturedRect( -x, -y, ScrW(), ScrH() )
		else
			JNVoiceMod:Circle(panel:GetWide()/2,panel:GetTall()/2 , panel:GetWide()/2, 100 )
		end
	end
end


function nss:PaintFrame(frame)

	frame.title = frame:GetTitle()
	frame:SetTitle("")
	frame.Paint = function(s,w,h)
		nss:Blur(s, 255, 150, 255)
		surface.SetDrawColor(0,0,0,200)
		surface.DrawRect(0,0,w,h)
		surface.SetDrawColor(nss.Conf.GuiColor)
		surface.DrawOutlinedRect(0,0,w,h,1)
		surface.DrawRect(0,0,w,25)
	end
	frame.PaintOver = function(self,w,h)
		draw.SimpleText(frame.title,"nss_20",w/2,12,Color( 255, 255, 255, 255 ),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
	end

end
function nss:PaintPanel(panel)

	panel.Paint = function(s,w,h)
		surface.SetDrawColor(24,24,24,80)
		surface.DrawRect(0,0,w,h)
		surface.SetDrawColor(nss.Conf.GuiColor)
		surface.DrawOutlinedRect(0,0,w,h,1)
	end

end
function nss:PaintItemPanel(panel)

	panel.Paint = function(s,w,h)
		surface.SetDrawColor(24,24,24,80)
		surface.DrawRect(0,0,w,h)
		surface.SetDrawColor(nss.Conf.GuiColor)
		surface.DrawOutlinedRect(0,0,w,h,1)
	end

end
function nss:PaintItemButton(button,ColorIdle,ColorHover)
	button.text = button:GetText()
	button:SetText("")
	local x = .5
	if button.i1 then x = .35 end
	button.Paint = function(s,w,h)
		surface.SetDrawColor(0,0,0,100)
		surface.DrawRect(0,0,w,h)
		surface.SetDrawColor(nss.Conf.GuiColor)
		surface.DrawOutlinedRect(0,0,w,h,1)
		draw.SimpleText(button.text,"nss_20",w/2,h*x,ColorIdle,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)

		if button.i1 then 
		draw.SimpleText(button.i1,"nss_15",w/2,h*.75,ColorIdle,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
		end
	end
	function button:OnCursorEntered()
		button.Paint = function( s,w,h )
			surface.SetDrawColor(0,0,0,100)
			surface.DrawRect(0,0,w,h)
			surface.SetDrawColor(nss.Conf.GuiColor)
			surface.DrawOutlinedRect(0,0,w,h,1)
			draw.SimpleText(button.text,"nss_20",w/2,h*x,ColorHover,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
			if button.i1 then 
				draw.SimpleText(button.i1,"nss_15",w/2,h*.75,ColorIdle,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
			end
		end
	end
	function button:OnCursorExited()
		button.Paint = function( s,w,h )
			surface.SetDrawColor(0,0,0,100)
			surface.DrawRect(0,0,w,h)
			surface.SetDrawColor(nss.Conf.GuiColor)
			surface.DrawOutlinedRect(0,0,w,h,1)
			draw.SimpleText(button.text,"nss_20",w/2,h*x,ColorIdle,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
			if button.i1 then 
				draw.SimpleText(button.i1,"nss_15",w/2,h*.75,ColorIdle,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
			end
		end
	end
end
function nss:PaintScroll(scroll,ColorKnob)
	scroll.VBar.Paint = function(s,w,h)

	end
	scroll.VBar.btnGrip.Paint = function(s,w,h)
		draw.RoundedBox(5,0,3,w-5,h-6,nss.Conf.GuiColor)
	end
	scroll.VBar:SetHideButtons(true)
end