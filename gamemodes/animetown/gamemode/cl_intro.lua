local flux = include( "includes/flux.lua" )

local repixMat = Material( "repix/animetown/welcome/repix_logo.png" )
local animeTownMat = Material( "repix/animetown/welcome/animetown_logo.png" )
local instructionMat = Material( "repix/animetown/welcome/instructions.png" )

AT_Intro_AudioObject = AT_Intro_AudioObject or nil
AT_Intro_MusicObject = AT_Intro_MusicObject or nil

local introAnim = { repixScale = 3, repixAlpha = 0, animeTownAlpha = 0, instructionAlpha = 0, instructionOffsetY = -32 }
local function runIntro()
    if ( !flux || !flux.to ) then return end

    introAnim = { repixScale = 3, repixAlpha = 0, animeTownAlpha = 0, instructionAlpha = 0, instructionOffsetY = -32 }

    flux.to( introAnim, 0.5, { repixScale = 1, repixAlpha = 1 } )
    :after( introAnim, 0.25, { repixScale = 0.5, repixAlpha = 0 } )
    :delay( 2 )
    :after( introAnim, 0.5, { animeTownAlpha = 1 } )
    :after( introAnim, 1, { instructionAlpha = 1, instructionOffsetY = 0 } )
end

hook.Add( "HUDPaint", "repix_AnimeTown_Intro", function()
    if ( !IsValid( LocalPlayer() ) ) then return end
    if ( !LocalPlayer():GetNWBool( "repix_AnimeTown_Intro", false ) ) then return end

    INTERFACE_SMOOTHING( 1920, 1080, function()
        surface.SetDrawColor( 255, 255, 255, 255 * introAnim.repixAlpha )
        surface.SetMaterial( repixMat )

        render.PushFilterMin( TEXFILTER.ANISOTROPIC )
        render.PushFilterMag( TEXFILTER.ANISOTROPIC )
            surface.DrawTexturedRect( ( ScrW() - ( SX( repixMat:Width() ) * introAnim.repixScale ) ) / 2, ( ScrH() - ( SY( repixMat:Height() ) * introAnim.repixScale ) ) / 2, SX( repixMat:Width() ) * introAnim.repixScale, SY( repixMat:Height() ) * introAnim.repixScale )
        render.PopFilterMin()
        render.PopFilterMag()

        surface.SetDrawColor( 255, 255, 255, 255 * introAnim.animeTownAlpha )
        surface.SetMaterial( animeTownMat )
        surface.DrawTexturedRect( SX( 538 ), SY( 454 ), SX( animeTownMat:Width() ), SY( animeTownMat:Height() ) )

        surface.SetDrawColor( 255, 255, 255, 255 * introAnim.instructionAlpha )
        surface.SetMaterial( instructionMat )
        surface.DrawTexturedRect( SX( 695 ), SY( 636 ) + SY( introAnim.instructionOffsetY ) - SY( 32 ), SX( instructionMat:Width() ), SY( instructionMat:Height() ) )
    end )

    if ( system.HasFocus() ) then
        if ( flux && flux.update ) then
            flux.update( RealFrameTime() )
        end
    end
end )

hook.Add( "CalcView", "repix_AnimeTown_Intro", function( ply, pos, ang, fov )
    if ( !IsValid( ply ) ) then return end
    if ( !ply:GetNWBool( "repix_AnimeTown_Intro", false ) ) then return end

    return {
        origin = Vector( 4375, -423, 185 + math.sin( CurTime() * 1 ) * 4 ),
        angles = Angle( 7, 110, 0 ),
        fov = fov,
        drawviewer = true
    }
end )

net.Receive( "repix_AnimeTown_IntroBegin", function()
    local bool = net.ReadBool()
    if ( bool ) then
        runIntro()

        system.FlashWindow()

        sound.PlayFile( "sound/repix/animetown/ambient/ocean.mp3", "", function( audio )
            if ( IsValid( audio ) ) then
                audio:SetVolume( 0.05 )
                audio:Play()
                audio:SetVolume( 0.05 )

                AT_Intro_AudioObject = audio
            end
        end )

        sound.PlayFile( "sound/repix/animetown/music/ajmw_forthem.mp3", "", function( audio )
            if ( IsValid( audio ) ) then
                audio:SetVolume( 0.125 )
                audio:Play()
                audio:SetVolume( 0.125 )

                AT_Intro_MusicObject = audio
            end
        end )

        render.RedownloadAllLightmaps()
    else
        if ( IsValid( AT_Intro_AudioObject ) ) then AT_Intro_AudioObject:Stop() AT_Intro_AudioObject = nil end
        if ( IsValid( AT_Intro_MusicObject ) ) then AT_Intro_MusicObject:Stop() AT_Intro_MusicObject = nil end

        -- AT_ShowUpdateLog()
        if ( LocalPlayer().RPNick && LocalPlayer():RPNick() == "-jiz-time-for-cheese-" ) then
            if ( rpname && rpname.Open ) then
                rpname.Open()
            end
        end
    end
end )

hook.Add( "InitPostEntity", "repix_AnimeTown_IntroReady", function()
	net.Start( "repix_AnimeTown_IntroReady" )
	net.SendToServer()
end )