include( "shared.lua" )
include( "musviz.lua" )

ENT.RenderGroup = RENDERGROUP_BOTH

function ENT:Draw()
    self:DrawModel()
end

function ENT:DrawTranslucent()
    if ( !musviz || !musviz.Render ) then return end

    local locPos = LocalPlayer():GetPos()
    if ( locPos:DistToSqr( self:GetPos() ) > 2056^2 ) then return end

    cam.Start3D2D( self:LocalToWorld( Vector( -30, -70, 1.55 ) ), self:LocalToWorldAngles( Angle( 0, 90, 0 ) ), 0.2 )
        musviz.Render( 0, 0, 1920 / 3, 1080 / 3 )
    cam.End3D2D()
end
