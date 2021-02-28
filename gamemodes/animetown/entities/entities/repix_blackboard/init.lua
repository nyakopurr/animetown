IncludeCS( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )

util.AddNetworkString( "repix_AnimeTown_Blackboard" )

function ENT:Initialize()
    self:SetModel( self.Model )
    self:PhysicsInit( SOLID_VPHYSICS )

    self:DrawShadow( false )

    self:SetUseType( SIMPLE_USE )

    self:SetWriting( "Классная работа" )

    local physObj = self:GetPhysicsObject()
    if ( IsValid( physObj ) ) then
        physObj:Wake()
        -- physObj:Sleep()
        physObj:EnableMotion( false )
    end
end

function ENT:Use( caller )
    if ( !IsValid( caller ) ) then return end
    if ( caller:GetPos():DistToSqr( self:GetPos() ) > 256^2 ) then return end

    net.Start( "repix_AnimeTown_Blackboard" )
        net.WriteEntity( self )
    net.Send( caller )
end

net.Receive( "repix_AnimeTown_Blackboard", function( len, ply )
    if ( !IsValid( ply ) || !ply:IsPlayer() ) then return end
    if ( ply:Location() ~= "school" ) then return end

    local ent = net.ReadEntity()
    if ( !IsValid( ent ) || ent:GetClass() ~= "repix_blackboard" ) then return end
    if ( ent:GetPos():DistToSqr( ply:GetPos() ) > 256^2 ) then return end

    if ( ent.SetWriting ) then
        local str = net.ReadString()
        if ( utf8.len( str ) > 256 ) then return end -- that's a lot of characters
        local l = string.Split( str, "\n" )
        if ( #l > 15 ) then return end
        ent:SetWriting( str )
    end
end )
