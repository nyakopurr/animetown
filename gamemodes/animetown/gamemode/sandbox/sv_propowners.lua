hook.Add( "PlayerSpawnedProp", "SetPropOwner", function( ply, mdl, ent )
    if ( !IsValid( ply ) ) then return end
    if ( !IsValid( ent ) ) then return end

    ent:SetNWString( "GModRP_Prop_Owner", ply:SteamID() )
end )

hook.Add( "PlayerSpawnedRagdoll", "SetPropOwner", function( ply, mdl, ent )
    if ( !IsValid( ply ) ) then return end
    if ( !IsValid( ent ) ) then return end

    ent:SetNWString( "GModRP_Prop_Owner", ply:SteamID() )
end )

hook.Add( "PlayerSpawnedSENT", "SetPropOwner", function( ply, mdl, ent )
    if ( !IsValid( ply ) ) then return end
    if ( !IsValid( ent ) ) then return end

    ent:SetNWString( "GModRP_Prop_Owner", ply:SteamID() )
end )

hook.Add( "PlayerSpawnedVehicle", "SetPropOwner", function( ply, mdl, ent )
    if ( !IsValid( ply ) ) then return end
    if ( !IsValid( ent ) ) then return end

    ent:SetNWString( "GModRP_Prop_Owner", ply:SteamID() )
end )

gameevent.Listen( "player_disconnect" )
hook.Add( "player_disconnect", "CleanDisconnectedPlayerProps", function( data )
    for _, prop in pairs( ents.GetAll() ) do
        if ( prop:GetNWString( "GModRP_Prop_Owner", "" ) == data.networkid ) then
            SafeRemoveEntity( prop )
        end
    end
end )

hook.Add( "CanProperty", "PropertyOwner", function( ply, property, ent )
    if ( property == "ignite" ) then return false end
    if ( property == "drive" ) then return false end
	if ( !ply:IsAdmin() && ent:GetNWString( "GModRP_Prop_Owner", "" ) ~= ply:SteamID() ) then return false end
end )