function nssv2:GetPhrase(name,...) // language
    if nssv2.Lang[nssv2.Config.Language or "EN-en"][name] then
        return string.format(nssv2.Lang[nssv2.Config.Language or "EN-en"][name],...) 
    else
        return name
    end
end
