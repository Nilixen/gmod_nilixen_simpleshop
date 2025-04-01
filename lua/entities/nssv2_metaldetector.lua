AddCSLuaFile()
if engine.ActiveGamemode() != "darkrp" then return end
ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Metal Detector v2"
ENT.Spawnable = false
ENT.Category = "Nilixen's Simple Shop"

function ENT:SetupDataTables()
	self:NetworkVar( "Entity", 0, "Owner" )
end

if SERVER then
	function ENT:Initialize()

        self:SetModel("models/props_wasteland/interior_fence003e.mdl") 
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetMoveType(MOVETYPE_VPHYSICS )
        self:SetSolid(SOLID_VPHYSICS)
        self:SetUseType(SIMPLE_USE)
    
        local phys = self:GetPhysicsObject()
        if IsValid(phys) then
            phys:Wake()
            phys:SetMass(150)
            phys:EnableMotion(false)
        end
        
        

        self.hp = 500
        if not CPPI then
            self:Remove()
            print("NSSV2 removing nssv2_metaldetector due to lack of CPPI!")
        end

	end

	function ENT:OnTakeDamage(dmg)
        self:TakePhysicsDamage(dmg)

        self.hp = self.hp - dmg:GetDamage()
        if self.hp <= 0 then
            self:Remove()
        end
	end

    function ENT:OnRemove()
        if IsValid(self:GetOwner()) then
            self:GetOwner().metalDetectors[self:EntIndex()] = nil
        end
    end

else

    function ENT:Initialize()
        self.mins,self.maxs = self:GetHitBoxBounds(0,0)
        self.t = 0
    end

    function ENT:Think()
        if self.alarm then
            self.t = self.t + 9*FrameTime()
            if self.t > 100 then
                self.t = 0
            end
        end

        local tbl = ents.FindInBox(self:LocalToWorld(self.mins),self:LocalToWorld(self.maxs))
        for k,v in pairs(tbl) do
            if v == self or v:IsWeapon() or v:GetClass() == "prop_physics" then continue end
            if v:GetClass() == "nssv2_itemforsale" then
                self:Alarm()
            end
        end
    end

    function ENT:Alarm()
        if !timer.Exists("alarm"..self:EntIndex()) then
			self.alarm = CreateSound( self, "ambient/alarms/alarm1.wav" )
			self.alarm:SetSoundLevel( 120 )
			self.alarm:PlayEx( 1,100 )
            timer.Create("alarm"..self:EntIndex(),10,1,function()
                if self.alarm then
                    self.alarm:Stop() 
                    self.alarm = nil
                end
            end)
        end
    end

    function ENT:OnRemove()
        if self.alarm then
            self.alarm:Stop() 
            self.alarm = nil
        end
    end

	function ENT:Draw()
        self:DrawModel()

        ang = self:GetAngles()
        ang:RotateAroundAxis(ang:Up(), 90)
        ang:RotateAroundAxis(ang:Forward(), 90)     


        local color = IsValid(self:GetOwner()) and self:GetOwner():GetShopColor():ToColor() or nssv2.guiColors.accentColor
        local alarmColor = (math.floor(math.fmod(self.t,2)) == 0) and color or color_transparent


        cam.Start3D2D(self:GetPos()+ang:Up()*.3,ang,0.1)
            draw.RoundedBox(0,-220,-560,450,50,nssv2.guiColors.boxes.primary)
            draw.SimpleText(nss:getPhrase("MetalDetector"),"nssv2-50",0,-560,color,1,0)
            if self.alarm then
                draw.RoundedBox(0,-300,-580,50,1160,alarmColor)
                draw.RoundedBox(0,250,-580,50,1160,alarmColor)
            end
        cam.End3D2D()

    end

end	
