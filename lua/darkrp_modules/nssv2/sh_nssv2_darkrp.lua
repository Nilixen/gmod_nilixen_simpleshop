DarkRP.createEntity( nssv2:GetPhrase("CashRegister"), {
    ent = "nssv2_cashregister",
    model = "models/props_c17/cashregister01a.mdl",
    price = 1000,
    max = 1,
    cmd = "buynssv2cashregister",
    -- The following fields are OPTIONAL. If you do not need them, or do not need to change them from their defaults, REMOVE them.
    allowed = {TEAM_GUN},
    getPrice = function(ply, price) return price end,
    category = "Other", -- The name of the category it is in. Note: the category must be created!
    sortOrder = 1, -- The position of this thing in its category. Lower number means higher up.
    allowTools = false, -- Whether players (including superadmins!) are allowed to use other tools than just remover. Defaults to false
})
