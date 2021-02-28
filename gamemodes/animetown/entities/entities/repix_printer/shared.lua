ENT.Base = "base_anim"
ENT.Type = "anim"
ENT.PrintName = "Money Printer"
ENT.Author = "repix"

ENT.Model = Model( "models/props_c17/consolebox01a.mdl" )
ENT.WarningSound = Sound( "repix/animetown/printer_overheat.mp3" )
ENT.PrintSound = Sound( "repix/animetown/printer_print.wav" )
ENT.SuccessSound = Sound( "repix/animetown/printer_ok.ogg" )

function ENT:SetupDataTables()
    self:NetworkVar( "Bool", 0, "Overheat" )
    self:NetworkVar( "Bool", 1, "On" )
    self:NetworkVar( "Float", 0, "Progress" )
    self:NetworkVar( "Float", 1, "PrinterHealth" )
    self:NetworkVar( "Float", 2, "TotalPrint" )
    self:NetworkVar( "Float", 3, "CurrentPrint" )
    self:NetworkVar( "Entity", 0, "PrinterOwner" )
end
