AddCSLuaFile()
if engine.ActiveGamemode() != "darkrp" then return end
ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Cash Register"
ENT.Spawnable = true
ENT.Category = "Nilixen's Simple Shop"

function ENT:SetupDataTables()
	self:NetworkVar( "Int", 0, "Money" )
end

if SERVER then
	function ENT:Initialize()

        self:SetModel("models/props_c17/cashregister01a.mdl")  --TODO Add model
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetMoveType(MOVETYPE_VPHYSICS )
        self:SetSolid(SOLID_VPHYSICS)
        self:SetUseType(SIMPLE_USE)
    
        local phys = self:GetPhysicsObject()
        if IsValid(phys) then
            phys:Wake()
            phys:SetMass(150)
        end

        if not CPPI then
            self:Remove()
            print("NSS removing nss_cashregister due to lack of CPPI!")
        end

        self.Owned = {}
        self.hp = 100
        self.c = CurTime() + 5
	end

	function ENT:OnTakeDamage(dmg)
        if self:GetMoney() == 0 then
            self:TakePhysicsDamage(dmg)

            self.hp = self.hp - dmg:GetDamage()
            if self.hp <= 0 then
                self:Remove()
            end
        end
	end

    function ENT:Use(ply)

        if self:CPPIGetOwner() == ply then 

            net.Start("nss_gui")
                net.WriteInt(1,4)
                net.WriteEntity(self)
                net.WriteTable(self.Owned)
            net.Send(ply)

        end

    end

    function ENT:Think()
        if self.c <= CurTime() then
            self.c = CurTime()+5
            for k,_ in pairs(self.Owned) do
                if !IsValid(k) then self.Owned[k] = nil continue end
                if self:GetPos():Distance(k:GetPos()) > nss.Conf.MaxRange then
                    nss:DisOwnItem(k)
                end
            end
        end
    end

    function ENT:AddMoney(num)
        local money = self:GetMoney()
        self:SetMoney(money + num)
    end

else

	function ENT:Draw()
		self:DrawModel()

        local dist = self:GetPos( ):Distance( LocalPlayer():GetPos() )
		if dist < 400 then
            local ang = self:GetAngles()
            ang:RotateAroundAxis(ang:Up(), 180)
            ang:RotateAroundAxis(ang:Forward(), 90)       

			cam.Start3D2D(self:GetPos()+ang:Up()*-5.5+ang:Forward()*-9.1,ang,0.05)
                surface.SetDrawColor(Color(0,0,0,200))
                surface.DrawRect(0,-232,270,60)
                surface.SetDrawColor(nss.Conf.GuiColor)
                surface.DrawOutlinedRect(0,-232,270,60)
                surface.DrawOutlinedRect(1,-231,268,58)

                local owner = self:CPPIGetOwner()
                if owner then
                    local nick = string.sub(owner:Name(),1,8)
                    draw.SimpleText(string.len(owner:Name()) > 8 and nick.."..." or nick,"nss_30",5,-195,Color(255,255,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
                else
                    draw.SimpleText("CPPI Loading...","nss_30",5,-195,Color(255,255,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
                end
                draw.SimpleText(DarkRP.formatMoney(self:GetMoney()),"nss_40",260,-205,Color(50,255,50),TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER)
                draw.SimpleText(nss:getPhrase("CashRegister"),"nss_20",5,-220,nss.Conf.GuiColor,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)

            cam.End3D2D()
		end

	end


end	
