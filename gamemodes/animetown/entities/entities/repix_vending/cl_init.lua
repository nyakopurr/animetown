include( "shared.lua" )

function ENT:PlayHumSound()
    sound.PlayFile( "sound/repix/animetown/ambient/electric_hum.mp3", "3d", function( audio )
        if ( IsValid( audio ) ) then
            audio:SetVolume( 0.1 )
            audio:SetPlaybackRate( 0.65 )
            audio:SetPos( self:GetPos() )
            audio:Set3DEnabled( true )
            audio:Set3DFadeDistance( 150, 250000 )

            if ( IsValid( self.HumSound ) ) then
                self.HumSound:Stop()
                self.HumSound = nil
            end

            self.HumSound = audio
            self.NextPlay = SysTime() + audio:GetLength()
        else
            self.NeverPlay = true
        end
    end )
end

function ENT:Initialize()
    self.HumSound = nil
    self.NextPlay = 0
    self.NeverPlay = false
end

function ENT:Think()
    if ( self.NeverPlay ) then return end
    if ( self.NextPlay < SysTime() ) then
        self:PlayHumSound()
    end
end

function ENT:Draw()
    self:DrawModel()
end

function ENT:UseMessage()
    return "drink"
end
