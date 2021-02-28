ENT.Base = "base_anim"
ENT.Type = "anim"
ENT.PrintName = "Blackboard"
ENT.Author = "repix"

ENT.Model = Model( "models/aschool25/doskamain2.mdl" )

function ENT:SetupDataTables()
    self:NetworkVar( "String", 0, "Writing" )
end
