include( "shared.lua" )

function ENT:Initialize()
    self.CurrentColor = Color( 255, 255, 255 )
end

function ENT:Draw()
    self:DrawModel()

    -- TODO: Check for nighttime
    local plyPos = LocalPlayer():GetPos()
    if ( plyPos:DistToSqr( self:GetPos() ) < 512^2 ) then
        if ( ( self.NextColorChange or 0 ) < CurTime() ) then
            self.CurrentColor = table.Random( {
                Color( 255, 75, 75 ), Color( 75, 255, 75 ), Color( 75, 75, 255 )
            } )

            self.NextColorChange = CurTime() + 0.8
        end

        local dlight = DynamicLight( self:EntIndex() )
        if ( dlight ) then
            dlight.pos = self:GetPos()
            dlight.r = self.CurrentColor.r or 255
            dlight.g = self.CurrentColor.g or 255
            dlight.b = self.CurrentColor.b or 255
            dlight.brightness = 2
            dlight.Decay = 1000
            dlight.Size = 1024
            dlight.DieTime = CurTime() + 1
        end
    end
end