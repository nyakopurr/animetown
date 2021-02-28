include( "shared.lua" )
include( "sh_jobs.lua" )
include( "cl_intro.lua" )
include( "cl_scoreboard.lua" )
include( "cl_updatelog.lua" )
include( "chat/cl_chat.lua" )
include( "chatcommands/cl_cmd.lua" )
include( "cl_wepsel.lua" )
include( "cl_atmosphere.lua" )
include( "cl_voice.lua" )
include( "profiles/cl_init.lua" )
include( "donate/cl_init.lua" )
include( "cl_context.lua" )
include( "cl_taunts.lua" )
include( "location/sh_location.lua" )
include( "phone/cl_phone.lua" )
include( "cl_f4menu.lua" )
include( "accessories/cl_accessories.lua" )
include( "school/cl_school.lua" )
include( "leveling/cl_leveling.lua" )
include( "police/cl_police.lua" )
include( "administration/cl_admin.lua" )
include( "doorsystem/cl_doorsystem.lua" )
include( "thirdperson/cl_thirdperson.lua" )
include( "drunkenbastard/cl_init.lua" )

local flux = include( "includes/flux.lua" )

surface.CreateFont( "anitown_fonts_roboto13", { font = "Roboto", size = ScreenScale( 13 ) / 3, extended = true } )
surface.CreateFont( "anitown_fonts_roboto13_blur", { font = "Roboto", size = ScreenScale( 13 ) / 3, extended = true, blursize = 4 } )
surface.CreateFont( "anitown_fonts_moneydiff", { font = "Rubik Medium", size = 14, weight = 500, extended = true } )

local versionMat = Material( "repix/animetown/hud/version.png" )
local healthMat = Material( "repix/animetown/hud/healthbar.png" )
local healthFillMat = Material( "repix/animetown/hud/healthbarfill.png" )
local currencyMat = Material( "repix/animetown/hud/currency.png" )
local moneyTestMat = Material( "repix/animetown/hud/money_test.png" )
local timeTestMat = Material( "repix/animetown/hud/time_test.png" )
local classTestMat = Material( "repix/animetown/hud/class_test.png" )
local jobTestMat = Material( "repix/animetown/hud/job_test.png" )
local characterTestMat = Material( "repix/animetown/hud/character_test.png" )
local locationTestMat = Material( "repix/animetown/hud/locations/out_of_bounds.png" )
local crosshairMat = Material( "repix/animetown/crosshair.png" )

local walletZero = Material( "repix/animetown/hud/numbers/wallet/0.png" )
local walletOne = Material( "repix/animetown/hud/numbers/wallet/1.png" )
local walletTwo = Material( "repix/animetown/hud/numbers/wallet/2.png" )
local walletThree = Material( "repix/animetown/hud/numbers/wallet/3.png" )
local walletFour = Material( "repix/animetown/hud/numbers/wallet/4.png" )
local walletFive = Material( "repix/animetown/hud/numbers/wallet/5.png" )
local walletSix = Material( "repix/animetown/hud/numbers/wallet/6.png" )
local walletSeven = Material( "repix/animetown/hud/numbers/wallet/7.png" )
local walletEight = Material( "repix/animetown/hud/numbers/wallet/8.png" )
local walletNine = Material( "repix/animetown/hud/numbers/wallet/9.png" )
local walletDot = Material( "repix/animetown/hud/numbers/wallet/dot.png" )

local clockZero = Material( "repix/animetown/hud/numbers/clock/0.png" )
local clockOne = Material( "repix/animetown/hud/numbers/clock/1.png" )
local clockTwo = Material( "repix/animetown/hud/numbers/clock/2.png" )
local clockThree = Material( "repix/animetown/hud/numbers/clock/3.png" )
local clockFour = Material( "repix/animetown/hud/numbers/clock/4.png" )
local clockFive = Material( "repix/animetown/hud/numbers/clock/5.png" )
local clockSix = Material( "repix/animetown/hud/numbers/clock/6.png" )
local clockSeven = Material( "repix/animetown/hud/numbers/clock/7.png" )
local clockEight = Material( "repix/animetown/hud/numbers/clock/8.png" )
local clockNine = Material( "repix/animetown/hud/numbers/clock/9.png" )
local clockSeparator = Material( "repix/animetown/hud/numbers/clock/separator.png" )

local walletMaterials = {
    ["."] = walletDot, ["2"] = walletTwo, ["5"] = walletFive, ["8"] = walletEight,
    ["0"] = walletZero, ["3"] = walletThree, ["6"] = walletSix, ["9"] = walletNine,
    ["1"] = walletOne, ["4"] = walletFour, ["7"] = walletSeven,
}

local clockMaterials = {
    [":"] = clockSeparator, ["2"] = clockTwo, ["5"] = clockFive, ["8"] = clockEight,
    ["0"] = clockZero, ["3"] = clockThree, ["6"] = clockSix, ["9"] = clockNine,
    ["1"] = clockOne, ["4"] = clockFour, ["7"] = clockSeven,
}

local drinkHelperMat = Material( "repix/animetown/hud/helper/drink.png" )
local helperMaterials = {
    ["drink"] = drinkHelperMat,
}

local hungerMat = Material( "repix/animetown/hud/hungerbar.png" )
local hungerFillMat = Material( "repix/animetown/hud/hungerbarfill.png" )

local hungerAnim = { alpha = 0, x = -32 }
local moneyAnim = { alpha = 0, x = 0, diff = 0, lastMoney = 0 }

local hudData = {
    lastMoney = 0,
    lastHunger = 100,
    animations = {
        locationAlpha = 0, locationOffsetX = -16
    },
    lastLocation = "-"
}

function INTERFACE_SMOOTHING( base_resolution_x, base_resolution_y, func )
    if ( ScrW() ~= base_resolution_x || ScrH() ~= base_resolution_y ) then
        render.PushFilterMin( TEXFILTER.ANISOTROPIC )
        render.PushFilterMag( TEXFILTER.ANISOTROPIC )
            func()
        render.PopFilterMin()
        render.PopFilterMag()
    else
        func()
    end
end

function SX( x )
    if ( !x ) then return 0 end
    if ( ScrW() == 1920 && ScrH() == 1080 ) then
        return x
    end

    return ( ScreenScale( x ) / 3 )
end

function SY( y )
    if ( !y ) then return 0 end
    if ( ScrW() == 1920 && ScrH() == 1080 ) then
        return y
    end

    return ( math.Round( y * math.min( ScrW(), ScrH() ) / 1080 ) )
end

hook.Add( "HUDPaint", "repix_AnimeTown_HUD", function()
    if ( !IsValid( LocalPlayer() ) || !LocalPlayer():Alive() ) then return end
    if ( LocalPlayer():GetNWBool( "repix_AnimeTown_Intro", false ) ) then return end
    if ( accessories && ValidPanel( accessories.AT_AccessoriesGUI ) ) then return end

    INTERFACE_SMOOTHING( 1920, 1080, function()
        local ent = LocalPlayer():GetEyeTrace().Entity
        local maxDist = 128^2
        if ( IsValid( ent ) && LocalPlayer():GetPos():DistToSqr( ent:GetPos() ) < maxDist && ent.UseMessage ) then
            local alpha = LocalPlayer():GetPos():DistToSqr( ent:GetPos() ) / maxDist
            surface.SetDrawColor( 255, 255, 255, 255 - ( 255 * alpha ) )
            surface.SetMaterial( helperMaterials[ ent:UseMessage() ] )
            surface.DrawTexturedRect( ( ScrW() - SX( 228 ) ) / 2, ( ScrH() - SY( 44 ) ) / 2, SX( 228 ), SY( 44 ) )
        else
            surface.SetDrawColor( 255, 255, 255 )
            surface.SetMaterial( crosshairMat )
            surface.DrawTexturedRect( ( ScrW() - SX( 6 ) ) / 2, ( ScrH() - SY( 6 ) ) / 2, SX( 6 ), SY( 6 ) )
        end

        surface.SetDrawColor( 255, 255, 255 )
        surface.SetMaterial( versionMat )
        surface.DrawTexturedRect( SX( 16 ), SY( 14 ), SX( versionMat:Width() ), SY( versionMat:Height() ) )

        draw.SimpleText( "Последнее обновление Аниме Города: " .. ( LatestUpdate or "не знаю" ), "anitown_fonts_roboto13", SX( 29 ) + ( SX( versionMat:Width() ) / 2 ) - SX( 16 ) + SX( 2 ), SY( 19 + 2 ), Color( 0, 0, 0, 255 - ( 255 * 0.75 ) ), 1 )
        draw.SimpleText( "Последнее обновление Аниме Города: " .. ( LatestUpdate or "не знаю" ), "anitown_fonts_roboto13", SX( 29 ) + ( SX( versionMat:Width() ) / 2 ) - SX( 16 ), SY( 19 ), Color( 255, 255, 255 ), 1 )

        local chMat = CharacterMaterials[ LocalPlayer():GetModel() ]
        if ( chMat ~= nil ) then
            local m = chMat
            local offx, offy = 0, 0
            if ( istable( chMat ) ) then
                m = chMat[1]
                offx = chMat[2]
                offy = chMat[3]
            end
            if ( !m:IsError() ) then
                surface.SetMaterial( m )
                surface.DrawTexturedRect( 0 + SX( offx ), SY( 837 ) + SY( offy ), SX( m:Width() ), SY( m:Height() ) )
            end
        end

        surface.SetMaterial( healthMat )
        surface.DrawTexturedRect( SX( 265 - 249 ), SY( 1024 ), SX( healthMat:Width() ), SY( healthMat:Height() ) )

        surface.SetMaterial( healthFillMat )
        render.SetScissorRect( SX( healthFillMat:Width() ) + SX( 265 - 249 + 4 ) - ( SX( healthFillMat:Width() ) * ( LocalPlayer():Health() / LocalPlayer():GetMaxHealth() ) ), 0, SX( healthFillMat:Width() + 265 - 249 + 4 ), ScrH(), true )
            surface.DrawTexturedRect( SX( 265 - 249 + 4 ), SY( 1024 ), SX( healthFillMat:Width() ), SY( healthFillMat:Height() ) )
        render.SetScissorRect( 0, 0, 0, 0, false )

        if ( LocalPlayer():Hunger() ~= hudData.lastHunger ) then
            if ( flux && flux.to ) then
                flux.to( hungerAnim, 0.5, { alpha = 1, x = 0 } )
                :after( hungerAnim, 0.5, { alpha = 0, x = -32 } )
                :delay( 4 )
            end

            hudData.lastHunger = LocalPlayer():Hunger()
        end

        if ( hungerAnim.alpha > 0 ) then
            local offsetX = hungerAnim.x
            surface.SetDrawColor( 255, 255, 255, 255 * hungerAnim.alpha )
            surface.SetMaterial( hungerMat )
            surface.DrawTexturedRect( SX( 16 + offsetX ), ScrH() - SY( hungerMat:Height() ) - SY( 73 ), SX( hungerMat:Width() ), SY( hungerMat:Height() ) )

            surface.SetMaterial( hungerFillMat )
            local hungerY = ScrH() - SY( hungerFillMat:Height() ) - SY( 77 )
            render.SetScissorRect( SX( 19 + offsetX ), hungerY + ( SY( hungerFillMat:Height() ) * ( ( 100 - LocalPlayer():Hunger() ) / 100 ) ), ScrW(), hungerY + SY( hungerFillMat:Height() ), true )
                surface.DrawTexturedRect( SX( 19 + offsetX ), ScrH() - SY( hungerFillMat:Height() ) - SY( 76 ), SX( hungerFillMat:Width() ), SY( hungerFillMat:Height() ) )
            render.SetScissorRect( 0, 0, 0, 0, false )
        end

        surface.SetDrawColor( 255, 255, 255 )

        surface.SetMaterial( currencyMat )
        surface.DrawTexturedRect( SX( 273 ), SY( 1042 ), SX( currencyMat:Width() ), SY( currencyMat:Height() ) )

        -- surface.SetMaterial( moneyTestMat )
        -- surface.DrawTexturedRect( 296, 1040 + 3, moneyTestMat:Width(), moneyTestMat:Height() )

        local moneyInt = LocalPlayer().Money and LocalPlayer():Money() or 0
        if ( moneyInt ~= ( hudData.lastMoney or 0 ) ) then
            hudData.lastMoney = math.Approach( hudData.lastMoney, moneyInt, math.ceil( math.abs( ( moneyInt - hudData.lastMoney ) * 0.1 ) ) )
        end

        -- if ( moneyAnim.lastMoney ~= moneyInt ) then
        --     if ( flux && flux.to ) then
        --         flux.to( moneyAnim, 0.5, { alpha = 1, x = -27 - 109 } )
        --         :after( moneyAnim, 0.5, { alpha = 0, x = 0 } )
        --         :delay( 2 )
        --
        --         local diff = moneyInt - moneyAnim.lastMoney
        --         if ( diff < 0 ) then
        --             moneyAnim.diff = "-" .. math.abs( diff )
        --         else
        --             moneyAnim.diff = "+" .. diff
        --         end
        --     end
        --
        --     moneyAnim.lastMoney = moneyInt
        -- end

        -- if ( moneyAnim.alpha > 0 ) then
        --     local mX = ScrW() + moneyAnim.x
        --     surface.SetDrawColor( 0, 0, 0, 225 * moneyAnim.alpha )
        --     surface.DrawRect( mX, 107, 109, 41 )
        --
        --     draw.SimpleText( "Баланс", "anitown_fonts_moneydiff", mX + 109 - 10, 107 + 4, Color( 255, 255, 255, 255 * moneyAnim.alpha ), 2 )
        --     local diffStr = moneyAnim.diff
        --     local clr = Color( 255, 80, 80, 255 * moneyAnim.alpha )
        --     if ( string.StartWith( diffStr, "+" ) ) then
        --         clr = Color( 80, 255, 80, 255 * moneyAnim.alpha )
        --     end
        --     draw.SimpleText( diffStr, "anitown_fonts_moneydiff", mX + 109 - 10, 107 + 21, clr, 2 )
        -- end

        -- surface.SetDrawColor( 255, 255, 255 )

        local wX = SX( 296 )
        local moneyStr = string.Comma( hudData.lastMoney or 0 )
        moneyStr = string.Replace( moneyStr, ",", "." )
        for l in moneyStr:gmatch( "." ) do
            local mat = walletMaterials[ l ]
            if ( mat && !mat:IsError() ) then
                surface.SetMaterial( mat )
                surface.DrawTexturedRect( wX, l == "." and SY( 1040 ) + SY( 3 ) + SY( 10 ) or SY( 1040 + 3 ), SX( mat:Width() ), SY( mat:Height() ) )

                wX = wX + ( l == "." and SX( 4 ) or SX( 10 ) )
            end
        end

        if ( location && istable( location.MaterialList ) ) then
            local curLocation = LocalPlayer().Location and LocalPlayer():Location() or "-"
            if ( hudData.lastLocation ~= curLocation ) then
                if ( curLocation ~= "-" ) then
                    if ( flux && flux.to ) then
                        flux.to( hudData.animations, 0.5, { locationAlpha = 1, locationOffsetX = 0 } )
                        :after( hudData.animations, 0.5, { locationAlpha = 0, locationOffsetX = -16 } )
                        :delay( 2 )
                    end
                end

                hudData.lastLocation = curLocation
            end

            if ( curLocation ~= "-" ) then
                local locMat = location.MaterialList[ curLocation ]
                if ( locMat ~= nil && !locMat:IsError() ) then
                    surface.SetDrawColor( 255, 255, 255, 255 * hudData.animations.locationAlpha )
                    surface.SetMaterial( locMat )
                    surface.DrawTexturedRect( wX + SX( 16 ) + hudData.animations.locationOffsetX, SY( 1040 + 2 ), SX( locMat:Width() ), SY( locMat:Height() ) )
                end
            end
        end

        surface.SetDrawColor( 255, 255, 255 )

        -- local currentTime = os.date( "%H:%M", os.time() )
        if ( SW && SW.Time ) then
            local hr = math.floor( SW.Time )
            local min = math.floor( 60 * ( SW.Time - hr ) )
            local currentTime = ""
            if ( min < 10 ) then
                min = "0" .. min
            end
            currentTime = hr .. ":" .. min
            local tX = ScrW() - SX( 28 ) - ( utf8.len( currentTime ) * SX( 20 ) )
            for l in currentTime:gmatch( "." ) do
                local mat = clockMaterials[ l ]
                if ( mat && !mat:IsError() ) then
                    surface.SetMaterial( mat )
                    surface.DrawTexturedRect( tX, l == ":" and SY( 14 + 8 ) or SY( 14 ), SX( mat:Width() ), SY( mat:Height() ) )

                    tX = tX + ( l == ":" and SX( 10 ) or SX( 20 ) )
                end
            end
        end

        -- surface.SetMaterial( timeTestMat )
        -- surface.DrawTexturedRect( 1793, 14, timeTestMat:Width(), timeTestMat:Height() )

        local curLesson = school and school.GetLesson() or nil
        if ( curLesson ~= nil ) then
            if ( isnumber( curLesson ) ) then
                curLesson = game.GetWorld():GetNWString( "repix_AnimeTown_Lesson" .. curLesson, "-" )
                if ( curLesson == "-" ) then curLesson = "none" end
            end
            local lesMat = school.LessonMaterials[ curLesson or "done" ]
            surface.SetMaterial( lesMat )
            surface.DrawTexturedRect( ScrW() - SX( lesMat:Width() ) - SX( 38 ), SY( 49 ), SX( lesMat:Width() ), SY( lesMat:Height() ) )
        end

        local jobMat = LocalPlayer():GetJob().HUDMaterial
        surface.SetMaterial( jobMat )
        surface.DrawTexturedRect( SX( 177 ) - SX( jobMat:Width() ) + SX( 90 ), SY( 1011 + 4 ), SX( jobMat:Width() ), SY( jobMat:Height() ) )
    end )

    if ( flux && flux.update ) then
        flux.update( RealFrameTime() )
    end
end )

local AlwaysHide = { "CHudHealth", "CHudDamageIndicator", "CHudBattery", "CHudAmmo", "CHudSecondaryAmmo", "CHudCrosshair", "CHudChat" }
hook.Add( "HUDShouldDraw", "GP_HideDefaults", function( elem )
    if ( table.HasValue( AlwaysHide, elem ) ) then return false end
end )

-- HelpBoards
local boardMap = Material( "repix/animetown/boards/christmas20_update.png" )
local limits = {
    Vector( 2085.119629, -7661.848633, -165.290054 ),
    Vector( 1558.519897, -7043.567383, 366.133911 )
}
hook.Add( "PostDrawTranslucentRenderables", "repix_AnimeTown_TestBoard", function()
    local lPos = LocalPlayer():GetPos()
    local bPos = Vector( 1681, -7356, 117 )
    if ( lPos:DistToSqr( bPos ) > 1024^2 ) then return end

    cam.Start3D2D( bPos, Angle( 0, 90, 90 ), 0.2 )
        surface.SetDrawColor( 255, 255, 255 )
        surface.SetMaterial( boardMap )
        surface.DrawTexturedRect( 0, 0, boardMap:Width(), boardMap:Height() )
    cam.End3D2D()

    if ( lPos:WithinAABox( limits[1], limits[2] ) ) then
        local dlight = DynamicLight( 1489 )
        if ( dlight ) then
            dlight.pos = Vector( 1681, -7285, 65 )
            dlight.r = 255
            dlight.g = 255
            dlight.b = 255
            dlight.brightness = 3
            dlight.Decay = 1000
            dlight.Size = 512
            dlight.DieTime = CurTime() + 1
        end
    end
end )

-- Overhead HUD
surface.CreateFont( "AT_Profile_Name", { font = "Rubik Medium", size = 21, extended = true } )
surface.CreateFont( "AT_Profile_Name_Shadow", { font = "Rubik Medium", size = 21, blursize = 2, extended = true } )
surface.CreateFont( "AT_Profile_Ping", { font = "Rubik Medium", size = 14, extended = true } )
surface.CreateFont( "AT_Profile_Ping_Shadow", { font = "Rubik Medium", size = 14, blursize = 2, extended = true } )

local badge1Mat = Material( "repix/animetown/profile/3d/profile_base_01.png" )
local badge2Mat = Material( "repix/animetown/profile/3d/profile_base_02.png" )
local badge3Mat = Material( "repix/animetown/profile/3d/profile_base_03.png" )
local badge4Mat = Material( "repix/animetown/profile/3d/profile_base_premium_01.png" )
local badge5Mat = Material( "repix/animetown/profile/3d/profile_base_premium_02.png" )
local badge6Mat = Material( "repix/animetown/profile/3d/profile_base_premium_03.png" )
local badge7Mat = Material( "repix/animetown/profile/3d/profile_base_premium_04.png" )
local badge8Mat = Material( "repix/animetown/profile/3d/profile_base_premium_05.png" )
local badge9Mat = Material( "repix/animetown/profile/3d/profile_base_premium_06.png" )
local badges = {
    [1] = badge1Mat, [3] = badge3Mat, [5] = badge5Mat, [7] = badge7Mat, [9] = badge9Mat,
    [2] = badge2Mat, [4] = badge4Mat, [6] = badge6Mat, [8] = badge8Mat,
}

local countryMat = Material( "repix/animetown/profile/3d/countries/ru.png" )
local premiumMat = Material( "repix/animetown/profile/3d/pin_premium.png" )
local typingMat = Material( "repix/animetown/hud/icon_typing.png" )
hook.Add( "PostDrawTranslucentRenderables", "repix_AnimeTown_Overhead", function()
    for _, ply in pairs( player.GetAll() ) do
        if ( !IsValid( ply ) ) then continue end
        if ( ply == LocalPlayer() ) then continue end
        if ( !ply:Alive() ) then continue end
        local dist = LocalPlayer():GetPos():DistToSqr( ply:GetPos() )
        local maxDist = 128^2
        if ( dist > maxDist ) then continue end
        local pos = ply:LocalToWorld( Vector( 0, -11, 52 ) )

        local alpha = 1 - ( 1 * ( dist / maxDist ) )
        if ( alpha > 0 ) then
            if ( !ValidPanel( ply.Profile3DAvatar ) ) then
                ply.Profile3DAvatar = vgui.Create( "AvatarImage" )
                ply.Profile3DAvatar:SetSize( 55, 55 )
                ply.Profile3DAvatar:SetPos( 26, 15 )
                ply.Profile3DAvatar:SetPlayer( ply, 64 )
                ply.Profile3DAvatar:SetPaintedManually( true )
            end

            cam.IgnoreZ( true )
            cam.Start3D2D( pos, Angle( 0, EyeAngles().y - 90, 90 ), 0.08 )
                local badge = ply:GetNWInt( "repix_AnimeTown_Profile.Background", 1 )
                badge = tonumber( badge )
                local hasPremium = ply:GetNWBool( "repix_AnimeTown_Profile.Premium", false )
                local badgeMat = badges[ badge ]
                -- local sx = -badgeMat:Width() / 2
                local sx = 0
                surface.SetDrawColor( 255, 255, 255, 255 * alpha )
                surface.SetMaterial( badgeMat )
                surface.DrawTexturedRect( sx, 0, badgeMat:Width(), badgeMat:Height() )

                local name = ply:Nick()
                if ( ply.RPNick && ply:RPNick() ~= "-jiz-time-for-cheese-" ) then
                    name = ply:RPNick()
                end

                surface.SetFont( "AT_Profile_Name" )

                local plyCountry = ply:GetNWString( "repix_AnimeTown_Profile.Country", "ru" )
                local flagMat = profile and profile.BadgeFlagMaterials[ string.lower( plyCountry ) ] or countryMat
                surface.SetMaterial( flagMat )
                surface.DrawTexturedRect( sx + 92 + surface.GetTextSize( name ) + 8, 22, countryMat:Width(), countryMat:Height() )

                draw.SimpleText( name, "AT_Profile_Name_Shadow", sx + 92, 25, Color( 0, 0, 0, ( 255 - ( 255 * 0.25 ) ) * alpha ) )
                draw.SimpleText( name, "AT_Profile_Name", sx + 92, 23, Color( 255, 255, 255, 255 * alpha ) )

                local ping = "0ms"
                if ( !ply:IsBot() ) then ping = ply:Ping() .. "ms" end
                draw.SimpleText( ping, "AT_Profile_Ping_Shadow", sx + 108, 50, Color( 0, 0, 0, ( 255 - ( 255 * 0.25 ) ) * alpha ) )
                draw.SimpleText( ping, "AT_Profile_Ping", sx + 108, 48, Color( 255, 255, 255, 255 * alpha ) )

                if ( ValidPanel( ply.Profile3DAvatar ) ) then
                    render.ClearStencil()
                    render.SetStencilEnable( true )
                    render.SetStencilWriteMask( 1 )
                    render.SetStencilTestMask( 1 )
                    render.SetStencilFailOperation( STENCILOPERATION_REPLACE )
                    render.SetStencilPassOperation( STENCILOPERATION_ZERO )
                    render.SetStencilZFailOperation( STENCILOPERATION_ZERO )
                    render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_NEVER )
                    render.SetStencilReferenceValue( 1 )
                        draw.NoTexture()
                        drawRoundedRectangle( 26, 15, 55, 55, 6, Color( 255, 255, 255 ), Color( 255, 255, 255 ), 0, 0.25, nil )
                    render.SetStencilFailOperation( STENCILOPERATION_ZERO )
                    render.SetStencilPassOperation( STENCILOPERATION_REPLACE )
                    render.SetStencilZFailOperation( STENCILOPERATION_ZERO )
                    render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_EQUAL )
                    render.SetStencilReferenceValue( 1 )
                        ply.Profile3DAvatar:PaintManual()
                    render.SetStencilEnable( false )
                    render.ClearStencil()

                    ply.Profile3DAvatar:SetAlpha( 255 * alpha )
                end

                if ( hasPremium ) then
                    surface.SetMaterial( premiumMat )
                    surface.DrawTexturedRect( sx + 19, 53, premiumMat:Width(), premiumMat:Height() )
                end
            cam.End3D2D()
            cam.IgnoreZ( false )

            if ( ply:IsTyping() ) then
                cam.Start3D2D( ply:LocalToWorld( Vector( 0, 0, 74 ) ), Angle( 0, EyeAngles().y - 90, 90 ), 0.03 )
                    surface.SetDrawColor( 255, 255, 255, 255 * alpha )
                    surface.SetMaterial( typingMat )
                    surface.DrawTexturedRect( 0, 0, typingMat:Width(), typingMat:Height() )
                cam.End3D2D()
            end
        end
    end
end )

-- Death HUD
local bgMat = Material( "repix/animetown/death/background.png" )
local textMat = Material( "repix/animetown/death/pseudohelper.png" )

local function sineBetween( min, max, t )
    local halfRange = ( max - min ) / 2
    return min + halfRange + math.sin( t ) * halfRange
end

hook.Add( "HUDPaint", "repix_AnimeTown_DeathScreen", function()
    if ( !IsValid( LocalPlayer() ) ) then return end
    if ( LocalPlayer():Alive() ) then return end

    INTERFACE_SMOOTHING( 1920, 1080, function()
        surface.SetDrawColor( 255, 255, 255 )
        surface.SetMaterial( bgMat )
        surface.DrawTexturedRect( 0, 0, ScrW(), ScrH() )

        surface.SetMaterial( textMat )
        surface.DrawTexturedRect( SX( 154 ), SY( 482 ) + sineBetween( -SY( 8 ), SY( 8 ), CurTime() * 2 ), SX( 880 ), SY( 115 ) )
    end )
end )

-- Connection Error
-- local errorMat = Material( "repix/animetown/connection/error.png" )
-- hook.Add( "HUDPaint", "repix_AnimeTown_ServerDied", function()
--     local timeOut = GetTimeoutInfo()
--     if ( timeOut ) then
--         surface.SetDrawColor( 255, 255, 255 )
--         surface.SetMaterial( errorMat )
--         surface.DrawTexturedRect( 17, 52, errorMat:Width(), errorMat:Height() )
--     end
-- end )

surface.CreateFont( "AT_PropOwner", { font = "Roboto", size = 16, extended = true } )

hook.Add( "HUDPaint", "repix_AnimeTown_DrawPropOwner", function()
    local trace = LocalPlayer():GetEyeTraceNoCursor()
    if ( IsValid( trace.Entity ) ) then
        local ent = trace.Entity
        local owner = trace.Entity:GetNWString( "GModRP_Prop_Owner", "" )
        local name = "(NULL Entity)"

        if ( ( owner == nil || owner == "" ) || ( !IsValid( player.GetBySteamID( owner ) ) ) ) then
            -- name = "World"
            return
        end

        local ply = player.GetBySteamID( owner )
        if ( IsValid( ply ) ) then
            name = ply.RPNick and ply:RPNick() or ply:Nick()
        end

        local color = Color( 255, 255, 255 )
        if ( ply == LocalPlayer() ) then
            color = Color( 75, 255, 75 )
        end

        surface.SetFont( "AT_PropOwner" )
        local w, h = surface.GetTextSize( tostring( name ) ) + 16, 25
        local x, y = ScrW() - w, ( ScrH() - 25 ) / 2
        draw.RoundedBox( 0, x, y, w, h, Color( 0, 0, 0, 150 ) )
        draw.SimpleText( tostring( name ), "AT_PropOwner", x + w - 8, ScrH() / 2, color, TEXT_ALIGN_RIGHT, 1 )
    end
end )

function GM:DrawDeathNotice()
end

function GM:HUDDrawTargetID()
end

hook.Remove( "HUDPaint", "SW.DrawClock" )

timer.Create( "repix_AnimeTown_RemoveDecals", 120, 0, function()
    RunConsoleCommand( "r_cleardecals" )
end )