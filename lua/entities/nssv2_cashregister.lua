AddCSLuaFile()
if engine.ActiveGamemode() != "darkrp" then return end
ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Cash Register v2"
ENT.Spawnable = true
ENT.Category = "Nilixen's Simple Shop"

function ENT:SetupDataTables()
	self:NetworkVar( "Int", 0, "Money" )
	self:NetworkVar( "Vector", 0, "ShopColor" )
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
            print("NSSV2 removing nss_cashregister due to lack of CPPI!")
        end

        self.forSale = {}
        self.stats = {
            totalMoney = 0,
            totalSold = 0,
            time = CurTime(),
        }
        self.metalDetectors = {}
        self.iterator = 0
        self.hp = 250
        self.c = CurTime() + 5

        self:SetShopColor(nssv2.guiColors.accentColor:ToVector())

	end

    function ENT:OnRemove()
        for k,v in pairs(self.metalDetectors) do
            if IsValid(v) then
                v:Remove()
            end
        end
    end

	function ENT:OnTakeDamage(dmg)
        if self:GetMoney() == 0 and table.Count(self.forSale) == 0 then
            self:TakePhysicsDamage(dmg)

            self.hp = self.hp - dmg:GetDamage()
            if self.hp <= 0 then
                self:Remove()
            end
        end
	end
    function ENT:Use(activator,caller)
        if self:CPPIGetOwner() == caller then 

            local tbl = {}
            for k,v in pairs(self.forSale) do
                if not IsValid(v.entity) then self.forSale[k] = nil continue end    // if entity got removed/stolen/used whatever has happened to it, if it does not exist then it will be removed from list
                tbl[k] = {
                    name = v.name,
                    type = v.type,
                    id = v.id,
                    price = v.price,
                    model = v.model,
                }
            end
            net.Start("nssv2_net")
                net.WriteUInt(0, 4)
                net.WriteEntity(self)
                net.WriteTable(tbl)
                net.WriteTable(self.stats)
                net.WriteTable(self.metalDetectors)
            net.Send(caller)
        end

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

                draw.RoundedBox(8, 0, -232, 270, 60, self:GetShopColor():ToColor())
                draw.RoundedBox(8, 1, -231, 268, 58, nssv2.guiColors.boxes.primary)

                local owner = self:CPPIGetOwner()
                if owner then
                    draw.SimpleText(string.len(owner:Name()) > 8 and string.sub(owner:Name(),1,8).."..." or owner:Name(),"nssv2-30",265,-230,Color(255,255,255),TEXT_ALIGN_RIGHT,TEXT_ALIGN_TOP)
                else
                    draw.SimpleText("CPPI Loading...","nssv2-30",5,-195,Color(255,255,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
                end
                draw.SimpleText(DarkRP.formatMoney(self:GetMoney()),"nssv2-40",265,-170,nssv2.guiColors.text.positive,TEXT_ALIGN_RIGHT,TEXT_ALIGN_BOTTOM)
                draw.SimpleText(nssv2:GetPhrase("CashRegister"),"nssv2-20",5,-230,self:GetShopColor():ToColor(),TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)
            cam.End3D2D()
		end
        //nssv2.ClientData.DrawRange = false
        if nssv2.ClientData and nssv2.ClientData.DrawRange then
            render.SetColorMaterial()
            render.DrawSphere( self:GetPos(), -nssv2.Config.CashRegisterAddRange, 25, 25, Color( 50, 0, 0, 100 ) )
            render.DrawSphere( self:GetPos(), nssv2.Config.CashRegisterAddRange, 25, 25, Color( 50, 0, 0, 100 ) )

            render.DrawSphere( self:GetPos(), -nssv2.Config.CashRegisterMaxRange, 25, 25, Color( 0, 0, 50, 100 ) )
            render.DrawSphere( self:GetPos(), nssv2.Config.CashRegisterMaxRange, 25, 25, Color( 0, 0, 50, 100 ) )
        end

	end


end	
