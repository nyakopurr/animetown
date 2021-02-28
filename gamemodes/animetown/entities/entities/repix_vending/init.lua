IncludeCS( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )

function ENT:Initialize()
    self:SetModel( self.Model )
    self:PhysicsInit( SOLID_VPHYSICS )

    self:SetUseType( SIMPLE_USE )

    local physObj = self:GetPhysicsObject()
    if ( IsValid( physObj ) ) then
        physObj:Wake()
        -- physObj:Sleep()
        physObj:EnableMotion( false )
    end
end

function ENT:Use( caller )
    if ( !IsValid( caller ) ) then return end
    if ( ( caller.NextVendingDrink or 0 ) > SysTime() ) then return end

    if ( caller:Afford( 15 ) ) then
        caller:AddMoney( -15 )
    else
        return
    end

    self:ThrowDrink()

    self:EmitSound( "buttons/lightswitch2.wav" )

    caller.NextVendingDrink = SysTime() + 1
end

function ENT:ThrowDrink()
    local pos = self:LocalToWorld( Vector( 8, 0, -28 ) )
    local can = ents.Create( "repix_drink" )
    can:SetPos( pos )
    can:Spawn()

    local phys = can:GetPhysicsObject()
    if ( IsValid( phys ) ) then
        phys:AddVelocity( self:GetForward() * 100 )
    end

    SafeRemoveEntityDelayed( can, 3 )
end
