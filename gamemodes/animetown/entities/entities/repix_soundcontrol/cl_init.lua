include( "shared.lua" )

function ENT:Draw()
end

function ENT:PlaySound()
    sound.PlayFile( "sound/" .. self:GetSoundPath(), "3d", function( audio )
        if ( IsValid( audio ) ) then
            audio:SetVolume( 0.2 )
            audio:SetPos( self:GetPos() )
            -- audio:Set3DFadeDistance( 200, 500000 )

            if ( IsValid( self.AmbientSound ) ) then
                self.AmbientSound:Stop()
                self.AmbientSound = nil
            end

            self.AmbientSound = audio
            self.NextPlay = SysTime() + audio:GetLength()
        else
            self.NeverPlay = true
        end
    end )
end

function ENT:Initialize()
    -- self.Sound = CreateSound( self, self:GetSoundPath() )
    -- self.Sound:PlayEx( 0.15, 100 )

    self.AmbientSound = nil
    self.NextPlay = 0
    self.NeverPlay = false
end

function ENT:Think()
    if ( self.NeverPlay ) then return end
    if ( self.NextPlay < SysTime() ) then
        self:PlaySound()
    end
end
