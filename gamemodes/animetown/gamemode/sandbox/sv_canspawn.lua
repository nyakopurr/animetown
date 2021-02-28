hook.Add( "PlayerSpawnProp", "PropsCanSpawn", function( ply, mdl )
    if ( ply:GetNWBool( "repix_AnimeTown_Arrested", false ) ) then
        return false
    end

    if ( table.HasValue( BlockedProps, mdl ) ) then
        return false
    end
end )

hook.Add( "PlayerSpawnSWEP", "AdminOnlySpawn", function( ply )
    if ( !ply:IsAdmin() ) then
        return false
    end
end )

hook.Add( "PlayerGiveSWEP", "AdminOnlySpawn", function( ply )
    if ( !ply:IsAdmin() ) then
        return false
    end
end )

hook.Add( "PlayerSpawnSENT", "AdminOnlySpawn", function( ply )
    if ( !ply:IsAdmin() ) then
        return false
    end
end )

hook.Add( "PlayerSpawnVehicle", "AdminOnlySpawn", function( ply )
    if ( !ply:IsAdmin() ) then
        return false
    end
end )

hook.Add( "PlayerSpawnNPC", "AdminOnlySpawn", function( ply )
    if ( !ply:IsAdmin() ) then
        return false
    end
end )

hook.Add( "PlayerSpawnEffect", "AdminOnlySpawn", function( ply )
    if ( !ply:IsSuperAdmin() ) then
        return false
    end
end )

hook.Add( "PlayerSpawnRagdoll", "AdminOnlySpawn", function( ply )
    if ( !ply:IsAdmin() ) then
        return false
    end
end )

hook.Add( "CanTool", "RestrictTools", function( ply, tr, tool )
    if ( tool == "remover" && IsValid( tr.Entity ) && tr.Entity:GetClass() == "prop_door_rotating" ) then
        return false
    end

    if ( tool == "remover" && !ply:IsAdmin() ) then
        local ent = tr.Entity
        if ( IsValid( ent ) ) then
            local owner = ent:GetNWString( "GModRP_Prop_Owner", "STEAM_0:0:0" )
            owner = player.GetBySteamID( owner )
            if ( IsValid( owner ) && owner == ply ) then return true else return false end
        else
            return false
        end
    end

    if ( tool == "duplicator" ) then return false end
    if ( tool == "rope" ) then return false end
    if ( tool == "balloon" ) then
        local ent = tr.Entity
        if ( IsValid( ent ) ) then
            local owner = ent:GetNWString( "GModRP_Prop_Owner", "STEAM_0:0:0" )
            owner = player.GetBySteamID( owner )
            if ( IsValid( owner ) && owner == ply ) then return true else return false end
        else
            return false
        end
    end
    if ( tool == "thruster" ) then return false end
    if ( tool == "physprop" ) then return false end
    if ( tool == "hoverball" ) then return false end
    if ( tool == "nocollide" ) then return false end
    if ( tool == "wheel" ) then return false end
    if ( tool == "emitter" ) then return false end
    if ( tool == "dynamite" ) then return false end
    if ( tool == "inflator" ) then return false end
    if ( tool == "eyeposer" ) then return false end
    if ( tool == "faceposer" ) then return false end
    if ( tool == "finger" ) then return false end
    if ( tool == "paint" ) then return false end
    if ( tool == "trails" ) then return false end

    if ( Debug ) then
        print( "Player", ply:GetName(), "used tool", tool )
    end
end )

hook.Add( "PhysgunPickup", "AllowPlayerPickup", function( ply, ent )
	if ( ply:IsAdmin() ) then
		return true
	end

    if ( IsValid( ent ) ) then
        local owner = ent:GetNWString( "GModRP_Prop_Owner", "STEAM_0:0:0" )
        owner = player.GetBySteamID( owner )
        if ( IsValid( owner ) && owner == ply ) then return true else return false end
    else
        return false
    end
end )

hook.Add( "PlayerNoClip", "AllowPlayerNoclip", function( ply, state )
	if ( state == false ) then
		return true
	elseif ( ply:IsAdmin() ) then
		return true
	end
end )

BlockedProps = {
    "models/props_c17/gravestone_statue001a.mdl", "models/props_c17/oildrum001_explosive.mdl",
    "models/props_canal/canal_bridge04.mdl", "models/Cranes/crane_frame.mdl",
    "models/props_combine/combine_bridge_b.mdl", "models/props_combine/combine_window001.mdl",
    "models/props_combine/combine_fence01b.mdl", "models/props_combine/combine_fence01a.mdl",
    "models/props_combine/weaponstripper.mdl", "models/props_junk/TrashDumpster02.mdl",
    "models/props_wasteland/medbridge_strut01.mdl", "models/props_wasteland/medbridge_base01.mdl",
    "models/props_wasteland/horizontalcoolingtank04.mdl", "models/props_wasteland/cranemagnet01a.mdl",
    "models/props_wasteland/coolingtank02.mdl", "models/props_wasteland/cargo_container01b.mdl",
    "models/props_wasteland/cargo_container01c.mdl", "models/props_wasteland/cargo_container01.mdl",
    "models/props_interiors/VendingMachineSoda01a.mdl", "models/props_interiors/VendingMachineSoda01a_door.mdl",
    "models/props_junk/sawblade001a.mdl", "models/Gibs/helicopter_brokenpiece_04_cockpit.mdl",
    "models/Gibs/helicopter_brokenpiece_05_tailfan.mdl", "models/Gibs/helicopter_brokenpiece_06_body.mdl",
    "models/Gibs/helicopter_brokenpiece_03.mdl", "models/Gibs/helicopter_brokenpiece_02.mdl",
    "models/Gibs/helicopter_brokenpiece_01.mdl", "models/props_c17/consolebox01a.mdl",
    "models/props_c17/playgroundslide01.mdl", "models/props_c17/statue_horse.mdl",
    "models/props_c17/playground_carousel01.mdl", "models/props_c17/playground_jungle_gym01a.mdl",
    "models/props_c17/playground_jungle_gym01b.mdl", "models/props_c17/playground_swingset01.mdl",
    "models/props_combine/breenbust.mdl", "models/props_phx/construct/plastic/plastic_panel8x8.mdl",
    "models/props_phx/construct/plastic/plastic_panel4x8.mdl", "models/hunter/blocks/cube8x8x8.mdl",
    "models/hunter/blocks/cube8x8x4.mdl", "models/hunter/blocks/cube8x8x2.mdl",
    "models/hunter/blocks/cube8x8x1.mdl", "models/hunter/blocks/cube8x8x05.mdl",
    "models/hunter/blocks/cube8x8x025.mdl", "models/hunter/blocks/cube6x8x2.mdl",
    "models/hunter/blocks/cube6x8x1.mdl", "models/hunter/blocks/cube6x8x05.mdl",
    "models/hunter/blocks/cube6x6x6.mdl", "models/hunter/blocks/cube6x6x2.mdl",
    "models/hunter/blocks/cube6x6x1.mdl", "models/hunter/blocks/cube6x6x05.mdl",
    "models/hunter/blocks/cube6x6x025.mdl", "models/hunter/blocks/cube4x8x1.mdl",
    "models/hunter/blocks/cube4x8x05.mdl", "models/hunter/blocks/cube4x8x025.mdl",
    "models/hunter/plates/plate32x32.mdl", "models/hunter/plates/plate24x32.mdl",
    "models/xqm/coastertrack/bank_start_right_1.mdl", "models/xqm/coastertrack/bank_start_right_2.mdl",
    "models/xqm/coastertrack/bank_start_right_3.mdl", "models/xqm/coastertrack/bank_start_right_4.mdl",
    "models/xqm/coastertrack/bank_turn_180_1.mdl", "models/xqm/coastertrack/bank_turn_180_2.mdl",
    "models/xqm/coastertrack/bank_turn_180_3.mdl", "models/xqm/coastertrack/bank_turn_180_4.mdl",
    "models/xqm/coastertrack/bank_turn_45_1.mdl", "models/xqm/coastertrack/bank_turn_45_2.mdl",
    "models/xqm/coastertrack/bank_turn_45_3.mdl", "models/xqm/coastertrack/bank_turn_45_4.mdl",
    "models/xqm/coastertrack/bank_turn_90_1.mdl", "models/xqm/coastertrack/bank_turn_90_2.mdl",
    "models/xqm/coastertrack/bank_turn_90_3.mdl", "models/xqm/coastertrack/bank_turn_90_4.mdl",
    "models/xqm/coastertrack/slope_225_1.mdl", "models/xqm/coastertrack/slope_225_2.mdl",
    "models/xqm/coastertrack/slope_225_3.mdl", "models/xqm/coastertrack/slope_225_4.mdl",
    "models/props/de_train/biohazardtank.mdl", "models/props_buildings/building_002a.mdl",
    "models/props_buildings/collapsedbuilding01a.mdl", "models/props_buildings/project_building01.mdl",
    "models/props_canal/canal_bridge01.mdl", "models/props_canal/canal_bridge02.mdl",
    "models/props_canal/canal_bridge03a.mdl", "models/props_canal/canal_bridge03b.mdl",
    "models/props_combine/combine_citadel001.mdl", "models/props_combine/combinetrain01.mdl",
    "models/props_combine/combinetrain02a.mdl", "models/props_combine/combinetrain02b.mdl",
    "models/props_combine/prison01.mdl", "models/props_combine/prison01c.mdl",
    "models/props_industrial/bridge.mdl", "models/props_phx/amraam.mdl",
    "models/props_phx/ball.mdl", "models/props_phx/cannonball.mdl",
    "models/props_phx/huge/evildisc_corp.mdl", "models/props_wasteland/cargo_container01c.mdl",
    "models/props_wasteland/depot.mdl", "models/xqm/coastertrack/special_full_corkscrew_left_4.mdl",
    "models/props_wasteland/wheel03a.mdl", "models/props_trainstation/train001.mdl",
    "models/props_trainstation/train002.mdl", "models/props_trainstation/train005.mdl",
    "models/props_trainstation/train003.mdl", "models/props_combine/combinetrain01a.mdl",
    "models/props_combine/combine_train02b.mdl", "models/props_combine/combine_train02a.mdl",
    "models/props/de_nuke/ibeams_warehouseroof.mdl", "models/props/de_nuke/pipesa_bombsite.mdl",
    "models/props/de_nuke/pipesb_bombsite.mdl", "models/props_wasteland/medbridge_base01.mdl",
    "models/props_phx/misc/flakshell_big.mdl", "models/props_buildings/collapsedbuilding02c.mdl",
    "models/props_buildings/collapsedbuilding01awall.mdl", "models/props_buildings/collapsedbuilding02a.mdl",
    "models/props_buildings/collapsedbuilding02b.mdl", "models/props_buildings/factory_skybox001a.mdl",
    "models/props_buildings/project_building02.mdl", "models/props_buildings/project_building03.mdl",
    "models/props_buildings/project_building02_skybox.mdl", "models/props_buildings/row_church_fullscale.mdl",
    "models/props_buildings/row_corner_1_fullscale.mdl", "models/props_buildings/row_res_1_fullscale.mdl",
    "models/props_buildings/row_res_2_ascend_fullscale.mdl", "models/props_buildings/row_res_2_fullscale.mdl",
    "models/props_canal/canal_bridge01b.mdl", "models/props_canal/refinery_03.mdl",
    "models/props_canal/refinery_04.mdl", "models/props_canal/canal_bridge03c.mdl",
    "models/props_canal/refinery_05.mdl", "models/props_combine/cell_array_02.mdl",
    "models/props_combine/cell_array_01.mdl", "models/props_combine/cell_array_01_extended.mdl",
    "models/props_combine/cell_array_03.mdl", "models/props_junk/watermelon01.mdl",
    "models/props_combine/combineinnerwallcluster1024_003a.mdl", "models/props_combine/combineinnerwallcluster1024_002a.mdl",
    "models/props_combine/combineinnerwallcluster1024_001a.mdl", "models/props_combine/combineinnerwall001a.mdl",
    "models/props_combine/pipes03_single02c.mdl", "models/props_combine/pipes03_single03c.mdl",
    "models/props_combine/pipes03_single03b.mdl", "models/props_combine/pipes03_single03a.mdl",
    "models/props_combine/pipes03_single02b.mdl", "models/props_combine/pipes03_single02a.mdl",
    "models/props_combine/pipes03_single01c.mdl", "models/props_combine/pipes01_single02b.mdl",
    "models/props_combine/pipes01_single02c.mdl", "models/props_combine/pipes02_single01a.mdl",
    "models/props_combine/pipes02_single01b.mdl", "models/props_combine/pipes03_single01b.mdl",
    "models/props_combine/pipes01_single01a.mdl", "models/props_combine/pipes01_single01b.mdl",
    "models/props_combine/pipes01_single01c.mdl", "models/props_combine/pipes01_single02a.mdl",
    "models/props_combine/pipes01_cluster02c.mdl", "models/props_combine/pipes01_cluster02b.mdl",
    "models/props_combine/pipes01_cluster02a.mdl", "models/props_combine/pipes02_single01c.mdl",
    "models/props_combine/pipes03_single01a.mdl", "models/props_combine/prison01b.mdl",
    "models/props_combine/strut_array_01.mdl", "models/props_foliage/tree_deciduous_card_01.mdl",
    "models/props_rooftop/rooftop_set01b.mdl", "models/props_rooftop/rooftopcluser09a.mdl",
    "models/props_rooftop/rooftopcluser06a.mdl", "models/props_trainstation/train004.mdl",
    "models/props_trainstation/traintrack006b.mdl", "models/props_trainstation/traintrack001c.mdl",
    "models/props_wasteland/antlionhill.mdl", "models/props_wasteland/tugtop002.mdl",
    "models/props_wasteland/tugtop001.mdl", "models/props_wasteland/rockcliff_cluster02c.mdl",
    "models/props_wasteland/rockcliff_cluster03b.mdl", "models/props_wasteland/rockcliff_cluster03c.mdl",
    "models/props_wasteland/rockgranite04b.mdl", "models/props_wasteland/rockgranite04a.mdl",
    "models/props_wasteland/rockgranite04c.mdl", "models/props_wasteland/rockcliff_cluster02b.mdl",
    "models/props_wasteland/rockcliff_cluster02a.mdl", "models/props_wasteland/rockcliff_cluster01b.mdl",
    "models/props_wasteland/rockcliff06i.mdl", "models/props_wasteland/rockcliff05f.mdl",
    "models/props_wasteland/rockcliff05e.mdl", "models/props_wasteland/rockcliff05b.mdl",
    "models/props_wasteland/rockcliff05a.mdl", "models/props/de_port/tankoil02.mdl",
    "models/props/de_prodigy/prodtracks.mdl", "models/props_wasteland/rockcliff_cluster01a.mdl",
    "models/props_wasteland/rockcliff_cluster03a.mdl", "models/props_c17/column02a.mdl",
    "models/props_wasteland/wheel02b.mdl", "models/props_wasteland/wheel03b.mdl",
    "models/Combine_Helicopter.mdl", "models/Combine_dropship.mdl",
    "models/combine_apc.mdl", "models/buggy.mdl", "models/airboat.mdl",
    "models/props_canal/boat001a.mdl", "models/props_canal/boat001b.mdl",
    "models/props_canal/boat002b.mdl", "models/props_combine/combine_train02a.mdl",
    "models/props_combine/combine_train02b.mdl", "models/props_combine/CombineTrain01a.mdl",
    "models/props_trainstation/train005.mdl", "models/props_trainstation/train003.mdl",
    "models/props_trainstation/train002.mdl", "models/props_trainstation/train001.mdl",
    "models/props_vehicles/car002a_physics.mdl", "models/props_vehicles/car001b_phy.mdl",
    "models/props_vehicles/car001b_hatchback.mdl", "models/props_vehicles/car001a_phy.mdl",
    "models/props_vehicles/car001a_hatchback.mdl", "models/props_vehicles/apc001.mdl",
    "models/props_vehicles/car003a_physics.mdl", "models/props_vehicles/car004a_physics.mdl",
    "models/props_vehicles/car005a_physics.mdl", "models/props_vehicles/car005b_physics.mdl",
    "models/props_vehicles/tanker001a.mdl", "models/props_vehicles/generatortrailer01.mdl",
    "models/props_vehicles/trailer001a.mdl", "models/props_vehicles/trailer002a.mdl",
    "models/props_vehicles/truck001a.mdl", "models/props_vehicles/truck002a_cab.mdl",
    "models/props_vehicles/truck003a.mdl", "models/props_vehicles/van001a_physics.mdl",
    "models/props_vehicles/wagon001a_phy.mdl", "models/props_phx/misc/big_ramp.mdl",
    "models/props_phx/misc/small_ramp.mdl", "models/props_phx/playfield.mdl",
    "models/props_phx/misc/bunker01.mdl", "models/hunter/misc/cone4x2mirrored.mdl",
    "models/hunter/misc/lift2x2.mdl", "models/hunter/misc/roundthing1.mdl",
    "models/hunter/misc/roundthing4.mdl", "models/hunter/misc/roundthing3.mdl",
    "models/hunter/misc/sphere375x375.mdl", "models/props_phx/games/chess/board.mdl",
    "models/props_phx/misc/smallcannonball.mdl", "models/props_foliage/oak_tree01.mdl",
    "models/props_foliage/tree_cliff_01a.mdl", "models/props_foliage/tree_cliff_02a.mdl",
    "models/props_foliage/tree_deciduous_01a-lod.mdl", "models/props_foliage/tree_deciduous_01a.mdl",
    "models/props_foliage/tree_deciduous_02a.mdl", "models/props_foliage/tree_deciduous_03a.mdl",
    "models/props_foliage/tree_deciduous_03b.mdl", "models/props_foliage/tree_poplar_01.mdl",
    "models/props/cs_assault/ACUnit01.mdl", "models/props/CS_militia/boxes_garage.mdl",
    "models/props/CS_militia/van.mdl", "models/props/de_nuke/car_nuke.mdl",
    "models/props/de_nuke/CoolingTower.mdl", "models/props/de_nuke/coolingtank.mdl",
    "models/props_phx/trains/fsd-overrun2.mdl", "models/props_c17/bench01a.mdl",
}