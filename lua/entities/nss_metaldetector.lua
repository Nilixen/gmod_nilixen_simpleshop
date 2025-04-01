AddCSLuaFile()
if engine.ActiveGamemode() != "darkrp" then return end
ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Metal Detector"
ENT.Spawnable = true
ENT.Category = "Nilixen's Simple Shop"

if SERVER then
	function ENT:Initialize()

        self:SetModel("models/props_wasteland/interior_fence002e.mdl") 
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetMoveType(MOVETYPE_VPHYSICS )
        self:SetSolid(SOLID_VPHYSICS)
        self:SetUseType(SIMPLE_USE)
    
        local phys = self:GetPhysicsObject()
        if IsValid(phys) then
            phys:Wake()
            phys:SetMass(150)
        end

        self.hp = 500
        

        if not CPPI then
            self:Remove()
            print("NSS removing nss_metaldetector due to lack of CPPI!")
        end

	end

	function ENT:OnTakeDamage(dmg)
        self:TakePhysicsDamage(dmg)

        self.hp = self.hp - dmg:GetDamage()
        if self.hp <= 0 then
            self:Remove()
        end
	end

else

    function ENT:Initialize()

        self.mins,self.maxs = self:GetHitBoxBounds(0,0)
        self.t = 0
    end

    function ENT:Think()
        local tbl = ents.FindInBox(self:LocalToWorld(self.mins),self:LocalToWorld(self.maxs))
        for k,v in pairs(tbl) do
            if v == self or v:IsWeapon() or v:GetClass() == "prop_physics" then continue end
            if v:GetNWBool("nss_forsale") then
                self:Alarm()
            end
            self:Beep()
            
        end
    end

    function ENT:Alarm()

        
        if !timer.Exists("alarm"..self:EntIndex()) then
			self.sound = CreateSound( self, "ambient/alarms/alarm1.wav" )
			self.sound:SetSoundLevel( 120 )
			self.sound:PlayEx( 1,100 )

            timer.Create("alarm"..self:EntIndex(),10,1,function()
                self.sound:Stop()
                self.sound = nil
            end)

        end
    end
    function ENT:Beep()
        if !timer.Exists("beep"..self:EntIndex()) and !self.trigger then
            self.trigger = true
            timer.Create("beep"..self:EntIndex(),0.2,1,function()
                self.trigger = false
            end)
        end

    end

	function ENT:Draw()
        

		self:DrawModel()

        local dist = self:GetPos( ):Distance( LocalPlayer():GetPos() )
		if dist < 1500 then
            local ang = self:GetAngles()
            ang:RotateAroundAxis(ang:Up(), 90)
            ang:RotateAroundAxis(ang:Forward(), 90)       

			cam.Start3D2D(self:GetPos()+ang:Up()*0.65,ang,0.1)
                if !self.sound then
                    surface.SetDrawColor(self.trigger and Color(255,50,50) or nss.Conf.GuiColor)
                    surface.DrawOutlinedRect(-230,-605,458,140)
                    surface.DrawOutlinedRect(-229,-604,456,138)
                    surface.DrawOutlinedRect(-228,-603,454,136)
                    draw.SimpleText(nss:getPhrase("MetalDetector"),"nss_50",0,-560,nss.Conf.GuiColor,1,0)
                else 
                    self.t = self.t + 1
                    if self.t > 50 then 
                        self.t = 0
                    end
                    local c = self.t > 25 and Color(255,255,255) or Color(255,50,50)
                    surface.SetDrawColor(c)
                    surface.DrawOutlinedRect(-230,-605,458,140)
                    surface.DrawOutlinedRect(-229,-604,456,138)
                    surface.DrawOutlinedRect(-228,-603,454,136)
                    draw.SimpleText(nss:getPhrase("MetalDetector"),"nss_50",0,-560,c,1,0)
                end
			cam.End3D2D()
            ang:RotateAroundAxis(ang:Right(), 180)
			cam.Start3D2D(self:GetPos()+ang:Up()*0.65,ang,0.1)
                if !self.sound then
                    surface.SetDrawColor(self.trigger and Color(255,50,50) or nss.Conf.GuiColor)
                    surface.DrawOutlinedRect(-230,-605,458,140)
                    surface.DrawOutlinedRect(-229,-604,456,138)
                    surface.DrawOutlinedRect(-228,-603,454,136)
                    draw.SimpleText(nss:getPhrase("MetalDetector"),"nss_50",0,-560,nss.Conf.GuiColor,1,0)
                else 
                    self.t = self.t + 1
                    if self.t > 50 then 
                        self.t = 0
                    end
                    local c = self.t > 25 and Color(255,255,255) or Color(255,50,50)
                    surface.SetDrawColor(c)
                    surface.DrawOutlinedRect(-230,-605,458,140)
                    surface.DrawOutlinedRect(-229,-604,456,138)
                    surface.DrawOutlinedRect(-228,-603,454,136)
                    draw.SimpleText(nss:getPhrase("MetalDetector"),"nss_50",0,-560,c,1,0)
                end
			cam.End3D2D()

		end

	end


    function ENT:OnRemove()
        if self.sound then self.sound:Remove() end
    end

end	
