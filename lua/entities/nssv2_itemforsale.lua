AddCSLuaFile()
if engine.ActiveGamemode() != "darkrp" then return end
ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Item"
ENT.Spawnable = false
ENT.Category = "Nilixen's Simple Shop"

function ENT:SetupDataTables()
	self:NetworkVar( "Int", 0, "Price" )
	self:NetworkVar( "Int", 1, "ID" )
	self:NetworkVar( "Entity", 0, "Owner" )
	self:NetworkVar( "String", 0, "DataType" )
	self:NetworkVar( "String", 1, "DataName" )
	self:NetworkVar( "String", 2, "DataClass" )

end

if SERVER then
	function ENT:Initialize()
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetMoveType(MOVETYPE_VPHYSICS )
        self:SetSolid(SOLID_VPHYSICS)
        self:SetUseType(SIMPLE_USE)
    
        local phys = self:GetPhysicsObject()
        if IsValid(phys) then
            phys:Wake()
            phys:SetMass(10)
            phys:EnableMotion(false)
        end

        self.timer = CurTime()+1
	end

    function ENT:Use(activator,caller)
        if not IsValid(self:GetOwner()) then return end

        net.Start("nssv2_net")
            net.WriteUInt(3, 4)
            net.WriteEntity(self)
        net.Send(caller)
    end

    function ENT:Release()

        local dupeInfo = self.dupeInfo
        if dupeInfo then
            if IsValid(self:GetOwner()) then
                self:GetOwner().forSale[self:GetID()] = nil // clear table
            end
            local ents, _ = duplicator.Paste(nil,dupeInfo.Entities,dupeInfo.Constraints)
            for k,v in pairs(ents) do
                v:SetPos(self:GetPos())
                v:SetAngles(self:GetAngles())
                v:GetPhysicsObject():EnableMotion(true)
            end
        end
        self:Remove()
    end

    function ENT:Think()
        if self.timer > CurTime() then return end
        self.timer = CurTime()+1
        // check if owner is valid, if not then respawn the ntity
        if not IsValid(self:GetOwner()) then
            self:Release()
            return
        end
        
        if self:GetPos():Distance(self:GetOwner():GetPos()) > nssv2.Config.CashRegisterMaxRange then
            self:Release()
        end
    end

else

	function ENT:Draw()
		self:DrawModel()
        table.insert(nssv2.PostDrawEntities, self)
        
	end

    
    function ENT:PostDraw()
        // todo draw things text etc...
        if not IsValid(self:GetOwner()) then return end
        if not nssv2.Config.SellableEntities[self:GetDataClass()] then return end
        nssv2.Config.SellableEntities[self:GetDataClass()].Draw3D2D(self)
    end


end	
