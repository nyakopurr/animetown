include( "shared.lua" )

ENT.RenderGroup = RENDERGROUP_BOTH

function ENT:Draw()
    self:DrawModel()
end

surface.CreateFont( "AT_Countdown", { font = "ZCOOL QingKe HuangYou", size = 96, extended = true } )

local bgMat = Material( "repix/animetown/christmas/countdown_bg.png" )
local christmasDate = 1609459200

function ENT:DrawTranslucent()
    local locPos = LocalPlayer():GetPos()
    if ( locPos:DistToSqr( self:GetPos() ) > 2056^2 ) then return end

    cam.Start3D2D( self:LocalToWorld( Vector( -30, -70, 1.55 ) ), self:LocalToWorldAngles( Angle( 0, 90, 0 ) ), 0.2 )
        surface.SetDrawColor( 0, 0, 0 )
        surface.DrawRect( -8, -8, bgMat:Width() + 16, bgMat:Height() + 16 )

        surface.SetDrawColor( 255, 255, 255 )
        surface.SetMaterial( bgMat )
        surface.DrawTexturedRect( 0, 0, bgMat:Width(), bgMat:Height() )

        local time = os.difftime( christmasDate, os.time() )
        time = os.date( "%d:%H:%M:%S", time )
        if ( os.time() > christmasDate ) then
            time = "00:00:00"
        end

        draw.SimpleText( time, "AT_Countdown", bgMat:Width() / 2, 208 - 96 - 24, Color( 255, 255, 255 ), 1 )
    cam.End3D2D()
end