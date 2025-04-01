function nss:Find(ent,dist)

    local tbl = ents.FindInSphere(ent:GetPos(), dist)
    local rTbl = {}

    for k,v in pairs(tbl) do
        if nss.Conf.EntitiesWL[v:GetClass()] then
            rTbl[table.Count(rTbl)+1] = {
                ent = v,
                dist = v:GetPos():Distance(ent:GetPos()),
            }
        end    
    end
    return rTbl
    
end

function nss:getPhrase(name,...)

    return string.format(nss.Lang[nss.Conf.Language][name],...) 

end
