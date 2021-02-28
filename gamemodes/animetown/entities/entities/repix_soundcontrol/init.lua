IncludeCS( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )

function ENT:Initialize()
    self:SetModel( self.Model )
    self:DrawShadow( false )

    if ( utf8.len( self:GetSoundPath() ) == 0 ) then
        self:SetSoundPath( "repix/animetown/ambient/wind_chimes.mp3" )
    end
end

local tbl = {
    { Vector( 2202.217529, -5361.745605, 123.316727 ), "repix/animetown/ambient/wind_chimes.mp3" }
}
hook.Add( "InitPostEntity", "repix_AnimeTown_Ambient", function()
    for _, v in pairs( tbl or {} ) do
        local sndCtrl = ents.Create( "repix_soundcontrol" )
        sndCtrl:SetPos( v[1] )
        sndCtrl:SetSoundPath( v[2] )
        sndCtrl:Spawn()
    end
end )
