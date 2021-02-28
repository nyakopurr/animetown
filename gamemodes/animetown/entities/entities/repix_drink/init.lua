IncludeCS( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )

function ENT:Initialize()
    self:SetModel( self.Model )
    self:PhysicsInit( SOLID_VPHYSICS )
    self:DrawShadow( false )

    local physObj = self:GetPhysicsObject()
    if ( IsValid( physObj ) ) then
        -- physObj:Wake()
    end
end

function ENT:Use( caller )
    if ( !IsValid( caller ) ) then return end

    local hunger = math.Clamp( caller:Hunger() + ( self.Regenerate or 10 ), 0, 100 )
    caller:SetNWInt( "repix_AnimeTown_Hunger", hunger )

    self:EmitSound( "repix/animetown/slurp.wav" )

    -- Add drunken effects
    if ( self.IsAlcohol ) then
        if ( !caller:GetNWBool( "repix_AnimeTown_Alcoholic", false ) ) then
            caller:SetNWBool( "repix_AnimeTown_Alcoholic", true )
            local time = 30
            local hp = 30
            if ( ( self.Regenerate or 10 ) >= 90 ) then
                caller:SetNWInt( "repix_AnimeTown_AlcoholForce", 3 )
                time = 60
                hp = 60
            end

            hp = math.Clamp( caller:Health() + hp, 0, caller:GetMaxHealth() )
            caller:SetHealth( hp )

            caller:SetDSP( 2 )

            if ( effects && effects.Bubbles ) then
                effects.Bubbles( caller:GetPos() - Vector( 16, 16, 16 ), caller:GetPos() + Vector( 16, 16, 16 ), 16, 150, 0, 5 )
            end

            timer.Simple( time, function()
                if ( !IsValid( caller ) ) then return end

                caller:SetNWBool( "repix_AnimeTown_Alcoholic", false )
                caller:SetNWInt( "repix_AnimeTown_AlcoholForce", 1 )

                caller:SetDSP( 0 )

                if ( effects && effects.Bubbles ) then
                    effects.Bubbles( caller:GetPos() - Vector( 16, 16, 16 ), caller:GetPos() + Vector( 16, 16, 16 ), 16, 150, 0, 0 )
                end
            end )
        end
    end

    SafeRemoveEntity( self )
end
