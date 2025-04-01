nss.Conf = {} or nss.Conf
local c = nss.Conf
function nss:AddEntity(class,tbl)
    nss.Conf.EntitiesWL[class] = tbl
end

-------------- DO NOT TOUCH ANYTHING ABOVE THIS LINE --------------

-- List of entities that are being able to be added to the cash register
c.EntitiesWL = {}
-- Range that the object needs to be even listed in the cash register, to be added.
c.AddRange = 250

-- Range that will make the objects automaticly remove themselves from the cash register and become normal entities
c.MaxRange = 600

-- Max items added to a single cash register
-- return always number.
c.ItemsLimit = function(ply) return ply:GetUserGroup() == "superadmin" and 30 or 15 end

-- In Percent, how much money will be taken from each sale
c.Tax = 0.15 // YOU CAN UPDATE IT LIVE, BUT BE AWARE IT NEED TO BE SHARED BOTH WITH SERVER AND CLIENT, OR IT WILL BE NOT SYNCHED CORRECTLY (not really that is matters)
// YOU SHOULD USE nss:SynchroConf(true) after changeing to synchronize config with all players
// TO CHANGE TAX: nss.Conf.Tax = x, where x is between 0 and 1 (eg. 0.15)

// TO ACCESS Cash register entity, use ent:GetNWEntity("nss_owner"). Total price of an item use ent:GetNWInt("nss_cost"). 
// ply represents the player who bought the item. 
// tax means how much tax was taken from the cash register (price*tax)
// this function is executed every sale.
c.SellItem = function(tax,ent,ply) end

c.Language = "ENG"   // Currently PL or ENG

-- As it says...
c.CanLockpickCashRegister = true
c.CashRegisterLockpickTime = 20

-- Lockpicking time for items listed for sale
c.ForSaleLockpickTime = 5

-- As it says... gui color
c.GuiColor = Color(0,200,120)

--[[ CUSTOM ENTITY SCHEM

    setUpFnc = function(ent) end,                               Executes on setup
    setUpCheck = function(ent) return true end,                 Checks if true before setUpFnc
    sellFnc = function(ent) end,                                Executes when sold, disowned, stolen etc...
    customFloatingText = {                                      
        RightOffset = -25,                                      You will have to experiment with that one
        UpOffset = 0,                                           
        ForwardOffset = 0,
        Padding = 0,
        text = {                                                You can add as many as you want, but "money" have to stay as it is, or no price will be displayed.
            ["1"] = {                                           Order can be sometimes messy
                textColor = Color(255,255,255),                 
                font = "nss_50",                                there are default 50,40,30,20,15 fonts
                text = function(ent)
                    return "Ammo"
                end,
            },
            ["money"] = {
                textColor = Color(50,255,50),
                font = "nss_40",                                there are default 50,40,30,20,15 fonts
            },
        },

    },
    customPrintName = function(ent)                             Displayed in gui of cash register
        return "Ammo"
    end,


]]
// ADD CUSTOM ENTITES HERE
nss:AddEntity("spawned_weapon",{
    setUpFnc = function(ent) ent.IsSpawnedWeapon = false  end,
    setUpCheck = function(ent) return true end,
    sellFnc = function(ent) ent.IsSpawnedWeapon = true  end,
    customFloatingText = {
        RightOffset = -12,
        UpOffset = 5,
        ForwardOffset = 0,
        Padding = 0,
        text = {            
            ["1"] = {
                textColor = Color(255,255,255),
                font = "nss_50",   // there are default 50,40,30,20,10 fonts
                text = function(ent)
                    for k, v in pairs(CustomShipments) do
                        if v.entity == ent:GetWeaponClass() then
                            return v.name
                        end
                    end
                end,
            },
            ["money"] = {
                textColor = Color(50,255,50),
                font = "nss_40",   // there are default 50,40,30,20,10 fonts
            },
        },

    },
    customPrintName = function(ent)
        for k, v in pairs(CustomShipments) do
            if v.entity == ent:GetWeaponClass() then
                return nss:getPhrase("Weapon",v.name)
            end
        end
    end
})
nss:AddEntity("spawned_shipment",{
    setUpFnc = function(ent)
        ent.locked = true
    end,
    setUpCheck = function(ent)
        return !ent.locked
    end,
    sellFnc = function(ent)
        ent.locked = false
    end,
    customFloatingText = {
        RightOffset = -35,
        UpOffset = 25,
        ForwardOffset = 0,
        Padding = 0,
        text = {            
            ["2"] = {
                textColor = Color(255,255,255),
                font = "nss_50",   // there are default 50,40,30,20,10 fonts
                text = function(ent)
                    return CustomShipments[ent:Getcontents()].name
                end,
            },
            ["money"] = {   //HAVE TO BE MONEY TO BE DISPLAYED
                textColor = Color(50,255,50),
                font = "nss_40",   // there are default 50,40,30,20,10 fonts
            },
            ["3"] = {
                textColor = Color(255,255,255),
                font = "nss_50",   // there are default 50,40,30,20,10 fonts
                text = function(ent)
                    return nss:getPhrase("Amount",ent:Getcount())
                end,
            },
        },


    },
    customPrintName = function(ent)
        return nss:getPhrase("Shipment",CustomShipments[ent:Getcontents()].name)
        end,
})
nss:AddEntity("spawned_ammo",{
    setUpFnc = function(ent) end,
    setUpCheck = function(ent) return true end,
    sellFnc = function(ent) end,
    customFloatingText = {
        RightOffset = -25,
        UpOffset = 0,
        ForwardOffset = 0,
        Padding = 0,
        text = {            
            ["1"] = {
                textColor = Color(255,255,255),
                font = "nss_50",   // there are default 50,40,30,20,10 fonts
                text = function(ent)
                    return "Ammo"
                end,
            },
            ["money"] = {
                textColor = Color(50,255,50),
                font = "nss_40",   // there are default 50,40,30,20,10 fonts
            },
        },

    },
    customPrintName = function(ent)
        return "Ammo"
    end,
})
