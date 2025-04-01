DarkRP.createEntity( nss:getPhrase("CashRegister"), {
    ent = "nss_cashregister",
    model = "models/props_c17/cashregister01a.mdl",
    price = 1000,
    max = 1,
    cmd = "buynsscashregister",
    -- The following fields are OPTIONAL. If you do not need them, or do not need to change them from their defaults, REMOVE them.
    allowed = {TEAM_GUN},
    getPrice = function(ply, price) return price end,
    category = "Other", -- The name of the category it is in. Note: the category must be created!
    sortOrder = 1, -- The position of this thing in its category. Lower number means higher up.
    allowTools = false, -- Whether players (including superadmins!) are allowed to use other tools than just remover. Defaults to false
})
DarkRP.createEntity( nss:getPhrase("MetalDetector"), {
    ent = "nss_metaldetector",
    model = "models/props_wasteland/interior_fence002e.mdl",
    price = 500,
    max = 1,
    cmd = "buynssmetaldetector",
    -- The following fields are OPTIONAL. If you do not need them, or do not need to change them from their defaults, REMOVE them.
    allowed = {TEAM_GUN},
    getPrice = function(ply, price) return price end,
    category = "Other", -- The name of the category it is in. Note: the category must be created!
    sortOrder = 1, -- The position of this thing in its category. Lower number means higher up.
    allowTools = false, -- Whether players (including superadmins!) are allowed to use other tools than just remover. Defaults to false
})

