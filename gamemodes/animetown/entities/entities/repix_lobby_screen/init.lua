IncludeCS( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )

function ENT:Initialize()
    self:SetModel( self.Model )
    self:PhysicsInit( SOLID_VPHYSICS )

    local physObj = self:GetPhysicsObject()
    if ( IsValid( physObj ) ) then
        physObj:Wake()
        -- physObj:Sleep()
        physObj:EnableMotion( false )
    end
end
