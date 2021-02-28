local spawnZone = {
    Vector( 2114.186768, -7644.633301, -111.401428 ), Vector( 1593.539551, -7072.610352, 512.824524 )
}

hook.Add( "EntityTakeDamage", "repix_AnimeTown_Spawnzone.PreventDamage", function( ply, dmg )
    if ( !IsValid( ply ) || !ply:IsPlayer() ) then return end

    -- Disable propkilling
    local attacker = dmg:GetAttacker()
    local inflictor = dmg:GetInflictor()

    -- this doesn't work smh
    if ( attacker:GetClass() == "prop_physics" || inflictor:GetClass() == "prop_physics" ) then
        dmg:ScaleDamage( 0 )
        dmg:SetDamage( 0 )
        return true
    end

    -- Disable spawnkilling
    if ( ply:GetPos():WithinAABox( spawnZone[1], spawnZone[2] ) ) then
        dmg:ScaleDamage( 0 )
        dmg:SetDamage( 0 )
        return true
    end

    -- Disable Stunbaton killing
    if ( inflictor:IsWeapon() && inflictor:GetClass() == "weapon_stunstick" ) then
        dmg:ScaleDamage( 0 )
        dmg:SetDamage( 0 )
        return true
    end
end )

hook.Add( "PlayerCanSeePlayersChat", "repix_AnimeTown_AllTalk.Disable", function( t, tO, l, s )
    if ( IsValid( l ) && IsValid( s ) ) then
        if ( l:IsPlayer() && s:IsPlayer() ) then
            local lPos = l:GetPos()
            local sPos = s:GetPos()
            if ( lPos:DistToSqr( sPos ) > 329^2 ) then
                return false
            end
        end
    end
end )

hook.Add( "PlayerCanHearPlayersVoice", "repix_AnimeTown_AllTalk.Disable", function( l, t )
    if ( l:GetPos():DistToSqr( t:GetPos() ) > 329^2 ) then
        return false, true
    end
end )