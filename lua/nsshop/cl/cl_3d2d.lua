hook.Add("PostDrawTranslucentRenderables", "nss_3d2ddraw", function()

    local ents = nss:Find(LocalPlayer(),400)
    for k,v in pairs(ents) do
        if !v.ent:GetNWBool("nss_forsale") then continue end
        local cl = nss.Conf.EntitiesWL[v.ent:GetClass()].customFloatingText
        local ang = Angle(0,LocalPlayer():EyeAngles().yaw-90,90)
        
        cam.Start3D2D(v.ent:GetPos()+ang:Up()*cl.UpOffset+ang:Right()*cl.RightOffset+ang:Forward()*cl.ForwardOffset,ang,0.1)
            local textoffset = 0
            for k2,v2 in pairs(cl.text) do
                if k2 == "money" then
                    surface.SetFont(v2.font)
                    local text = DarkRP.formatMoney( v.ent:GetNWInt("nss_cost") or 0 )
                    local x,y = surface.GetTextSize( text )

                    surface.SetTextColor(v2.textColor)
                    surface.SetTextPos(-x/2,textoffset)
                    surface.DrawText( text )

                    textoffset = textoffset + y + cl.Padding
                    
                else
                    surface.SetFont(v2.font)
                    local text = v2.text(v.ent)
                    local x,y = surface.GetTextSize( text )

                    surface.SetTextColor(v2.textColor)
                    surface.SetTextPos(-x/2,textoffset)
                    surface.DrawText( text )

                    textoffset = textoffset + y + cl.Padding
                end
            end

        cam.End3D2D()
    end

end)
