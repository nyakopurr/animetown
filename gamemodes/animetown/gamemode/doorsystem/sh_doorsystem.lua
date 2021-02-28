local meta = FindMetaTable( "Player" )

function meta:CanLockUnlockDoor( door )
    -- if ( !door:GetNWBool( "repix_AnimeTown_DoorSystem", false ) ) then
    --     return false
    -- end

    local property = door:GetNWString( "repix_AnimeTown_Property", "-" )
    if ( property ~= "-" ) then
        if ( property == "Школа" ) then
            return self:Team() == 2
        elseif ( property == "Полицейский участок" ) then
            return self:Team() == 5
        end
    end

    local owner = door:GetNWString( "repix_AnimeTown_DoorOwner", "-" )
    if ( owner ~= "-" ) then
        return owner == self:SteamID()
    end

    return false
end
