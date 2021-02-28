-- serverside module

module( "atmosphere", package.seeall )

IsChristmas = true
EnableSnow = true

if ( IsChristmas ) then
    -- game.ConsoleCommand( "sv_skyname grimmnight\n" )

    if ( SW && SW.SetWeather ) then
        SW.SetWeather( "snow" )
    end
end

local snowProps = {
    { "models/hoth/artic_snow_pile03.mdl", Vector( 2091.732422, -5867.338379, 6.721097 ), Angle( -0.634, 89.017, -1.607 ) },
    { "models/hoth/artic_snow_pile04.mdl", Vector( 2114.447266, -6592.686035, 3.431930 ), Angle( 0.961, -173.022, -0.930 ) },
    { "models/hoth/artic_snow_pile04.mdl", Vector( 2122.539551, -6799.273926, 12.309950 ), Angle( 0.000, -174.471, 0.000 ) },
    { "models/hoth/artic_snow_pile04.mdl", Vector( 1351.419556, -6542.756348, 24.006924 ), Angle( 0.012, -89.982, 0.006 ) },
    { "models/hoth/artic_snow_pile05.mdl", Vector( 1241.903931, -5290.060059, 11.824948 ), Angle( -0.000, -86.550, 0.000 ) },
    { "models/hoth/artic_snow_pile04.mdl", Vector( 1348.007813, -5393.763184, 20.356649 ), Angle( 0.000, 90.027, 0.000 ) },
    { "models/hoth/artic_snow_pile01.mdl", Vector( 1423.063354, -5343.040527, 12.157306 ), Angle( 15.705, -176.188, 0.489 ) },
    -- not really:
    { "models/unconid/xmas/lights_u.mdl", Vector( 1928.040771, -7056.427246, 200.054779 ), Angle( 0.021, 90.008, 0.007 ) },
    { "models/unconid/xmas/lights_u.mdl", Vector( 1798.040771, -7056.427246, 200.054779 ), Angle( 0.021, 90.008, 0.007 ) }
}

local snowmanProps = {
    { 0.5, Vector( 815.067505, -5135.055176, 8.809782 ), Angle( 0.016, 9.633, 0.091 ) },
    { 1, Vector( -1847.018433, -4829.295898, 0.838917 ), Angle( -0.058, 16.085, -0.052 ) },
    { 1, Vector( 1260.718994, -5347.692383, 8.842929 ), Angle( -0.007, 59.396, -0.003 ) }
}

local vendingMachines = {
    { Vector( 2108.913330, -7051.842773, 55.037140 ), Angle( -0.001, 89.961, -0.000 ) },
    { Vector( 2443.793945, -4798.546875, 55.129124 ), Angle( -0.021, -180.000, -0.002 ) },
    { Vector( -991.831421, -1474.830444, 47.047863 ), Angle( 0.014, 0.012, 0.030 ) }
}

hook.Add( "InitPostEntity", "repix_AnimeTown_Atmosphere", function()
    if ( IsChristmas ) then
        local tree = ents.Create( "repix_christmas_tree" )
        tree:SetPos( Vector( 1067.696777, -4886.270020, 8.384322 ) )
        tree:SetAngles( Angle( -0.008, -45.026, 0.001 ) )
        tree:Spawn()

        local countdown = ents.Create( "repix_lobby_screen" ) -- repix_christmas_countdown
        countdown:SetPos( Vector( 1244.569214, -4897.350586, 56.765167 ) )
        countdown:SetAngles( Angle( 90, 0, 180 ) )
        countdown:Spawn()

        for _, snowman in pairs( snowmanProps or {} ) do
            local snowmanEnt = ents.Create( "prop_physics" )
            snowmanEnt:SetModel( "models/unconid/xmas/snowman_u.mdl" )
            snowmanEnt:SetPos( snowman[2] )
            snowmanEnt:SetAngles( snowman[3] )
            snowmanEnt:SetModelScale( snowman[1] )
            snowmanEnt:Spawn()

            if ( IsValid( snowmanEnt ) ) then
                local physObj = snowmanEnt:GetPhysicsObject()
                if ( IsValid( physObj ) ) then
                    -- physObj:Sleep()
                    physObj:EnableMotion( false )
                end
            end
        end

        for _, drift in pairs( snowProps or {} ) do
            local prop = ents.Create( "prop_dynamic" )
            prop:SetModel( drift[1] )
            prop:SetPos( drift[2] )
            prop:SetAngles( drift[3] )
            prop:Spawn()
            prop:DrawShadow( false )
        end

        for _, vending in pairs( vendingMachines or {} ) do
            local vm = ents.Create( "repix_vending" )
            vm:SetPos( vending[1] )
            vm:SetAngles( vending[2] )
            vm:Spawn()
        end

        local piano = ents.Create( "gmt_instrument_piano" )
        piano:SetPos( Vector( 780.720032, -4482.703613, 8.498977 ) )
        piano:SetAngles( Angle( 0.003, -39.760, 0 ) )
        piano:Spawn()

        local physObj = piano:GetPhysicsObject()
        if ( IsValid( physObj ) ) then
            physObj:EnableMotion( false )
        end

        for _, ent in pairs( ents.FindByClass( "ambient_generic" ) ) do
            ent:Remove()
        end

        for _, ent in pairs( ents.FindByClass( "env_soundscape" ) ) do
            ent:Remove()
        end

        -- engine.LightStyle( 0, "b" )
    end
end )
