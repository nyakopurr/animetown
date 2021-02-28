module( "police", package.seeall )

JailPositions = {
    ["rp_animeplanet"] = {
        { Vector( 4073.105957, -4710.071777, 184.031250 ), Angle( 0, 90, 0 ) },
        { Vector( 4204.520996, -4708.845215, 184.031250 ), Angle( 0, 90, 0 ) },
        { Vector( 4324.104492, -4707.974121, 184.031250 ), Angle( 0, 90, 0 ) }
    }
}

function Arrest( ply, time )
    if ( !IsValid( ply ) ) then return end
    if ( !time ) then time = 3 * 60 end
    if ( ply:GetNWBool( "repix_AnimeTown_Arrested", false ) ) then return end
    if ( ply:Team() == 5 ) then return end -- is cp

    if ( ply:InVehicle() ) then ply:ExitVehicle() end

    if ( JailPositions && JailPositions[ game.GetMap() ] ) then
        local pos = table.Random( JailPositions[ game.GetMap() ] )[1]
        local ang = table.Random( JailPositions[ game.GetMap() ] )[2]

        if ( isvector( pos ) ) then
            ply:SetPos( pos )
        end

        if ( isangle( ang ) ) then
            ply:SetEyeAngles( ang )
            ply:SetAngles( ang )
        end
    end

    ply:SetCollisionGroup( COLLISION_GROUP_PASSABLE_DOOR )

    ply:StripWeapons()

    ply:SetNWBool( "repix_AnimeTown_Arrested", true )
    ply:SetNWFloat( "repix_AnimeTown_ArrestTime", tonumber( time ) )
    ply:SetNWFloat( "repix_AnimeTown_TimeArrested", UnPredictedCurTime() )

    ply.UnarrestIn = SysTime() + tonumber( time )

    ply:EmitSound( "doors/metal_stop1.wav" )

    if ( timer.Exists( "GModRP_UnarrestTimer_" .. ply:SteamID() ) ) then
        timer.Remove( "GModRP_UnarrestTimer_" .. ply:SteamID() )
    end
    timer.Create( "GModRP_UnarrestTimer_" .. ply:SteamID(), tonumber( time ), 1, function()
        if ( IsValid( ply ) ) then
            if ( timer.Exists( "GModRP_UnarrestTimer_" .. ply:SteamID() ) ) then
                timer.Remove( "GModRP_UnarrestTimer_" .. ply:SteamID() )
            end

            if ( isfunction( Unarrest ) ) then
                Unarrest( ply )
            end
        end
    end )
end

function Unarrest( ply )
    if ( !IsValid( ply ) ) then return end

    ply:Spawn()

    ply:SetNWBool( "repix_AnimeTown_Arrested", false )
    ply:SetNWFloat( "repix_AnimeTown_ArrestTime", 0.0 )
    ply:SetNWFloat( "repix_AnimeTown_TimeArrested", 0.0 )

    ply.UnarrestIn = 0.0

    if ( timer.Exists( "GModRP_UnarrestTimer_" .. ply:SteamID() ) ) then
        timer.Remove( "GModRP_UnarrestTimer_" .. ply:SteamID() )
    end
end
