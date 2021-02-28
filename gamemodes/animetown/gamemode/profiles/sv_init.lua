include( "sv_profile.lua" )
include( "sv_signup.lua" )

AddCSLuaFile( "cl_profile.lua" )
AddCSLuaFile( "cl_signup.lua" )
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "cl_list.lua" )

hook.Add( "PlayerUse", "repix_AnimeTown_ShowProfile", function( ply, ent )
    if ( !IsValid( ply ) ) then return end
    if ( !IsValid( ent ) ) then return end
    if ( !ent:IsPlayer() ) then return end

    local dist = ent:GetPos():Distance( ply:GetPos() )
    if ( dist <= 128 ) then
        profile.Open( ply, ent:SteamID() )
    end
end )
