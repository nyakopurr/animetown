IncludeCS( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )

util.AddNetworkString( "repix_AnimeTown_Printer_Power" )

function ENT:Initialize()
    self:SetModel( self.Model )
    self:PhysicsInit( SOLID_VPHYSICS )
    self:PhysWake()

    self:SetProgress( 0 )
    self:SetOverheat( false )
    self:SetPrinterHealth( 100 )
    self:SetCurrentPrint( 0 )
    self:SetTotalPrint( 0 )
    self:SetOn( true )

    if ( !self.PrintingSound ) then
        self.PrintingSound = CreateSound( self, self.PrintSound )
        self.PrintingSound:SetSoundLevel( 92 )
        self.PrintingSound:PlayEx( 1, 100 )
    end
end

function ENT:Think()
    if ( self:WaterLevel() > 0 ) then
        self:Explode()
        SafeRemoveEntity( self )
        return
    end

    if ( self:GetOn() ) then
        if ( ( self.NextProgressUpdate or 0 ) < SysTime() ) then
            local curProgress = self:GetProgress() or 0
            local targetProgress = curProgress + 1
            targetProgress = math.Clamp( targetProgress, 0, 100 )
            self:SetProgress( targetProgress )

            if ( !self:GetOverheat() ) then
                local rnd = math.random( 1, 35 )
                if ( rnd == 13 ) then
                    self:TakeDamage( math.random( 1, 5 ), game.GetWorld(), game.GetWorld() )
                end
            end

            self.NextProgressUpdate = SysTime() + 1.5
        end

        if ( ( self.NextSoundPlay or 0 ) < SysTime() ) then
            self.PrintingSound = CreateSound( self, self.PrintSound )
            self.PrintingSound:SetSoundLevel( 52 )
            self.PrintingSound:PlayEx( 1, 100 )

            self.NextSoundPlay = SysTime() + 3
        end

        if ( self:GetProgress() >= 100 ) then
            local add = math.random( 250, 1250 )
            self:SetCurrentPrint( ( self:GetCurrentPrint() or 0 ) + add )
            self:SetTotalPrint( ( self:GetTotalPrint() or 0 ) + add )

            self:EmitSound( self.SuccessSound )

            self:SetProgress( 0 )
        end
    end

    if ( self:GetOverheat() ) then
        if ( !( self.WasIgnited or false ) ) then
            self:Ignite( 15, 32 )
            self.WasIgnited = true
        end
        if ( ( self.NextOverheatPlay or 0 ) < SysTime() ) then
            self.OverheatSound = CreateSound( self, self.WarningSound )
            self.OverheatSound:SetSoundLevel( 52 )
            self.OverheatSound:PlayEx( 1, 100 )

            self.NextOverheatPlay = SysTime() + 8
        end
    else
        if ( self.WasIgnited ) then self.WasIgnited = false end
    end

    -- self:NextThink( CurTime() + 2.5 )
    -- return true
end

function ENT:Use( caller )
    if ( !IsValid( caller ) ) then return end
    if ( !self:GetOn() ) then return end
    if ( ( self:GetCurrentPrint() or 0 ) < 1 ) then return end
    if ( caller:Team() == 5 ) then return end -- is cp

    if ( caller.AddMoney ) then
        caller:AddMoney( ( self:GetCurrentPrint() or 0 ) )
    end

    caller:EmitSound( "common/wpn_denyselect.wav" )

    self:SetCurrentPrint( 0 )
end

function ENT:Explode( fire )
    local pos = self:GetPos()
    SafeRemoveEntity( self )
    local ed = EffectData()
    ed:SetOrigin( pos )
    util.Effect( "GlassImpact", ed )
    util.Effect( "Explosion", ed )
    ed:SetMagnitude( 2 )
    util.Effect( "ElectricSpark", ed )

    if ( fire ) then
        -- fires.CreateFire( pos )
    end
end

function ENT:OnRemove()
    if ( self.OverheatSound ) then
        self.OverheatSound:Stop()
        self.OverheatSound = nil
    end

    if ( self.PrintingSound ) then
        self.PrintingSound:Stop()
        self.PrintingSound = nil
    end
end

function ENT:OnTakeDamage( dmginfo )
	if ( !self.m_bApplyingDamage ) then
		self.m_bApplyingDamage = true
		self:SetPrinterHealth( ( self:GetPrinterHealth() or 100 ) - ( dmginfo:GetDamage() or 1 ) )

        local health = self:GetPrinterHealth() or 100
        if ( health <= 10 ) then
            self:SetOverheat( true )
        end

        if ( health <= 0 ) then
            self:Explode( true )

            -- Police Reward
            local attacker = dmginfo:GetAttacker()
            if ( IsValid( attacker ) && attacker:IsPlayer() && ( attacker:Team() == 5 ) ) then
                if ( attacker.AddMoney ) then attacker:AddMoney( 500 ) end
                attacker:ChatPrint( "Награда 500AT за уничтожение денежного принтера." )
            end
        end
		self.m_bApplyingDamage = false
	end
end

net.Receive( "repix_AnimeTown_Printer_Power", function( len, ply )
    if ( !IsValid( ply ) ) then return end
    if ( !ply:IsPlayer() ) then return end
    local ent = net.ReadEntity()
    if ( !IsValid( ent ) ) then return end
    if ( ent:GetClass() ~= "repix_printer" ) then return end
    if ( ent:GetPos():Distance( ply:GetPos() ) > 128 ) then return end

    local isOn = ent:GetOn()
    if ( isOn ) then
        ent:SetOn( false )
    else
        ent:SetOn( true )
        ent:EmitSound( "buttons/button1.wav" )
    end
end )
