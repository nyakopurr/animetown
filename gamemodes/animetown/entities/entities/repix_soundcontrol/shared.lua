ENT.Base = "base_anim"
ENT.Type = "anim"
ENT.PrintName = "Ambience Controller"
ENT.Author = "repix"

ENT.Model = Model( "models/hunter/blocks/cube025x025x025.mdl" )

function ENT:SetupDataTables()
    self:NetworkVar( "String", 0, "SoundPath" )
end
