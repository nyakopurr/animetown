include( "shared.lua" )

ENT.RenderGroup = RENDERGROUP_BOTH

function ENT:Draw()
    self:DrawModel()
end

function ENT:Initialize()
    self.CurrentSlide = 1
    self.NextSlide = CurTime() + 10
end

local slide1Mat = Material( "repix/animetown/lobby/slide01.png" )
local slide2Mat = Material( "repix/animetown/lobby/slide02.png" )

function ENT:DrawTranslucent()
    local locPos = LocalPlayer():GetPos()
    if ( locPos:DistToSqr( self:GetPos() ) > 2056^2 ) then return end
    if ( ( self.NextSlide or 0 ) < CurTime() ) then
        self.CurrentSlide = self.CurrentSlide == 1 and 2 or 1

        self.NextSlide = CurTime() + 10
    end

    cam.Start3D2D( self:LocalToWorld( Vector( -35, -73, 1.55 ) ), self:LocalToWorldAngles( Angle( 0, 90, 0 ) ), 0.2 )
        local mat = self.CurrentSlide == 1 and slide1Mat or slide2Mat
        surface.SetDrawColor( 255, 255, 255 )
        surface.SetMaterial( mat )
        surface.DrawTexturedRect( 0, 0, mat:Width(), mat:Height() )
    cam.End3D2D()
end
