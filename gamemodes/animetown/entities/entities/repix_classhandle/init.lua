IncludeCS( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )

function ENT:Initialize()
    self:SetModel( self.Model )
    self:DrawShadow( false )
    self:SetNoDraw( true )

    self.Blackboard = ents.Create( "repix_blackboard" )
    self.Blackboard:SetPos( self:LocalToWorld( Vector( -391.014221, 103.796616, 60.564781 ) ) )
    self.Blackboard:SetAngles( self:LocalToWorldAngles( Angle( 0.023, -179.982, -0.212 ) ) )
    self.Blackboard:Spawn()

    local begPos = self:LocalToWorld( Vector( -82.286743, 140.422638, 24.018213 ) )
    for c = 1, 2 do
        for i = 1, 4 do
            local deskEnt = ents.Create( "prop_physics" )
            deskEnt:SetPos( begPos )
            deskEnt:SetAngles( self:LocalToWorldAngles( Angle( 0, 0, 0 ) ) )
            deskEnt:SetModel( "models/oldbill/desk.mdl" )
            deskEnt:Spawn()
            deskEnt:DrawShadow( false )

            local phys = deskEnt:GetPhysicsObject()
            if ( IsValid( phys ) ) then
                phys:EnableMotion( false )
            end

            local chairEnt = ents.Create( "prop_physics" )
            chairEnt:SetPos( deskEnt:LocalToWorld( Vector( 33.661415, -1.513210, 0 ) ) )
            chairEnt:SetAngles( deskEnt:LocalToWorldAngles( Angle( 0.090, 1.563, 0 ) ) )
            chairEnt:SetModel( "models/oldbill/chair.mdl" )
            chairEnt:Spawn()
            chairEnt:DrawShadow( false )

            phys = chairEnt:GetPhysicsObject()
            if ( IsValid( phys ) ) then
                phys:EnableMotion( false )
            end

            begPos = begPos + Vector( 0, 72, 0 )
        end

        begPos = self:LocalToWorld( Vector( -82.286743, 140.422638 - 72, 24.018213 ) )
    end
end

local tbl = {
    { Vector( -1229.643188, -1889.708130, 6.268483 ), Angle( 0.017, -89.978, -0.023 ) },
    { Vector( -3293.599121, -1794.708862, 6.268483 ), Angle( -0.003, -89.978, 0.336 ) },
    { Vector( -3293.730713, -961.704224, 6.268483 ), Angle( -0.003, -89.978, 0.336 ) },
    { Vector( -3293.663330, -1377.691772, 6.268483 ), Angle( -0.003, -89.978, 0.336 ) },
    { Vector( -1229.702637, -1889.585693, 142.251511 ), Angle( 0.017, -89.978, -0.023 ) },
}
hook.Add( "InitPostEntity", "repix_AnimeTown_ClassHandler", function()
    for _, v in pairs( tbl or {} ) do
        local clHndl = ents.Create( "repix_classhandle" )
        clHndl:SetPos( v[1] )
        clHndl:SetAngles( v[2] )
        clHndl:Spawn()
    end
end )