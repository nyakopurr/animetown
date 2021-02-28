local meta = FindMetaTable( "Player" )

function meta:Level()
    return self:GetNWInt( "repix_AnimeTown_Level", 0 )
end

function meta:XP()
    return self:GetNWInt( "repix_AnimeTown_XP", 0 )
end
