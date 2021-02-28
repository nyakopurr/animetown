util.AddNetworkString( "repix_AnimeTown_IntroBegin" )
util.AddNetworkString( "repix_AnimeTown_IntroReady" )

net.Receive( "repix_AnimeTown_IntroReady", function( len, ply )
    if ( !IsValid( ply ) || !ply:IsPlayer() ) then return end
    if ( ply:GetNWBool( "repix_AnimeTown_Intro", false ) ) then return end

    net.Start( "repix_AnimeTown_IntroBegin" )
        net.WriteBool( true )
    net.Send( ply )

    ply:SetNWBool( "repix_AnimeTown_Intro", true )
    ply:SetPos( Vector( 0, 0, 0 ) )
end )

hook.Add( "PlayerButtonDown", "repix_AnimeTown_Intro", function( ply, btn )
    if ( !IsValid( ply ) || !ply:IsPlayer() ) then return end
    if ( !ply:GetNWBool( "repix_AnimeTown_Intro", false ) ) then return end
    if ( btn ~= KEY_ENTER && btn ~= KEY_SPACE ) then return end

    ply:SetNWBool( "repix_AnimeTown_Intro", false )
    ply:Spawn()

    net.Start( "repix_AnimeTown_IntroBegin" )
        net.WriteBool( false )
    net.Send( ply )
end )