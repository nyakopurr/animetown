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

    self:DrawShadow( false )
end

function ENT:Use( caller )
    if ( !IsValid( caller ) ) then return end
    if ( !IsValid( self.ScreenController ) ) then return end

    self.ScreenController:Enter( caller )
end
