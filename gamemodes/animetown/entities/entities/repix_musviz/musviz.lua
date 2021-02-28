-- Realtime music visualizer for Garry's Mod
-- Comes in circular shape only

module( "musviz", package.seeall )

local BackgroundImage = Material( "repix/musviz/background_test.png" )
local CircleImage = Material( "repix/musviz/circle_test.png" )
FFTData = {}
NeverForgetSnd = NeverForgetSnd or nil
local fftMul = 1500
local NumSegment = 2
local FFTSmoothed = {}
local particles = { timeNext = 0, obj = {} }

function Play( snd, pos )
    sound.PlayFile( "sound/repix/musviz/moeshop_notice.mp3", "3d", function( audio )
        if ( IsValid( audio ) ) then
            audio:SetVolume( 0.25 ) -- inb4: 0.08
            audio:SetPos( pos )

            NeverForgetSnd = audio
        end
    end )
end

function Render( x, y, w, h )
    surface.SetDrawColor( 255, 255, 255 )
    surface.SetMaterial( BackgroundImage ) --< this kinda needs blur, needa way to minimize lag when rendering blur
    surface.DrawTexturedRect( x, y, w, h )

    -- TODO: Background Material blur

    local cw, ch = CircleImage:Width(), CircleImage:Height()
    cw, ch = cw * ( w / 1920.0 ), ch * ( h / 1080.0 )
    local cx, cy = x + ( ( w - cw ) / 2 ), y + ( ( h - ch ) / 2 )

    if ( IsValid( NeverForgetSnd ) ) then
        local fft = NeverForgetSnd:FFT( FFTData, FFT_512 )
        for i = 1, fft do
            FFTSmoothed[ i ] = Lerp( 20 * RealFrameTime(), FFTSmoothed[ i ] or 0, FFTData[ i ] )
        end
    end

    local ArrayNum = 360 * ( h / 1080.0 )
    local mul = 250 * ( h / 1080.0 )
    local high = 150 * ( h / 1080.0 )
    for i = 1, ArrayNum do
        local deg = ( math.pi / ArrayNum * i ) * 2
        local x2, y2 = math.cos( deg ), math.sin( deg )
        local fx, fy = x2 * mul, ( y2 + high / mul ) * mul
        local ang = -deg * 180 / math.pi

        surface.SetDrawColor( 255, 255, 255 )
        draw.NoTexture()
        -- surface.DrawRect( cx + fx, cy + fy, 5, 5 )

        local lw = math.Clamp( ( FFTSmoothed[ i % ( ArrayNum / NumSegment ) ] or 0 ) * fftMul, 3, math.huge )

        render.PushFilterMin( TEXFILTER.ANISOTROPIC )
        render.PushFilterMag( TEXFILTER.ANISOTROPIC )
            surface.DrawTexturedRectRotated( cx + fx + mul, cy + fy + ( 100 * ( h / 1080.0 ) ), lw, 3, ang )
        render.PopFilterMin()
        render.PopFilterMag()
    end

    -- Draw snowflakes
    if ( particles && ( particles.timeNext or 0 ) < CurTime() ) then
        table.insert( particles.obj, { x = math.random( x + 6, w - 6 ), y = h, size = math.random( 2, 6 ), alpha = math.random( 0.1, 0.6 ) } )

        particles.timeNext = CurTime() + math.random( 0.01, 0.5 )
    end

    for _, flake in pairs( particles.obj or {} ) do
        if ( flake.y < 0 ) then
            table.RemoveByValue( particles.obj, flake )
            continue
        end

        surface.SetDrawColor( 255, 255, 255, 255 * flake.alpha )
        surface.DrawRect( flake.x, flake.y, flake.size * ( w / 1920.0 ), flake.size * ( h / 1080.0 ) )

        local speed = math.abs( ( FFTSmoothed[ 1 ] or 0 ) - ( flake.size * 4 ) )
        flake.y = flake.y - ( 0.1 * speed )
    end

    surface.SetDrawColor( 255, 255, 255, 255 )
    surface.SetMaterial( CircleImage )
    surface.DrawTexturedRect( cx, cy, cw, ch )
end

-- hook.Add( "HUDPaint", "repix_MusViz_Draw", function()
--     if ( !isfunction( Render ) ) then return end
--
--     Render( 0, 0, ScrW(), ScrH() )
-- end )
