
hook.Add( "CanProperty", "nss_propertyblock", function( ply, property, ent )
	if !IsValid(ent) then return end
    if ent:GetNWBool("nss_forsale") then
        return false
    end
end )

hook.Add("canLockpick","nss_canlockpick",function(ply, ent, trace)

    if ent:GetClass() == "nss_cashregister" and ent:GetMoney() > 0 and nss.Conf.CanLockpickCashRegister then return true end
    if ent:GetNWBool("nss_forsale") then return true end

end)
    

hook.Add("lockpickTime","nss_lockpicktime",function(ply, ent)

    if ent:GetClass() == "nss_cashregister" and nss.Conf.CanLockpickCashRegister then return nss.Conf.CashRegisterLockpickTime end
    if ent:GetNWBool("nss_forsale") then return nss.Conf.ForSaleLockpickTime end

end)