AddCSLuaFile()

SWEP.Base = "weapon_base"
SWEP.PrintName = "Таран"
SWEP.Slot = 2
SWEP.SlotPos = 2
SWEP.HoldType = "normal"
SWEP.DrawAmmo = false
SWEP.UseHands = true

SWEP.ViewModelFOV = 62
SWEP.ViewModel = Model( "models/weapons/c_rpg.mdl" )
SWEP.WorldModel = Model( "models/weapons/w_rocket_launcher.mdl" )

SWEP.Sound = Sound( "physics/wood/wood_box_impact_hard3.wav" )

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ""

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ""

function SWEP:Initialize()
	self:SetHoldType( self.HoldType )
end

function SWEP:Precache()
end

function SWEP:Deploy()
	return true
end

function SWEP:Holster()
	return true
end

function SWEP:Reload()
	return false
end

function SWEP:PrimaryAttack()
    if ( CLIENT ) then return end
    if ( ( self.Owner.NextPoliceRam or 0 ) > SysTime() ) then return end

    local tr = self.Owner:GetEyeTraceNoCursor()
    if ( IsValid( tr.Entity ) ) then
        if ( !( tr.Entity:GetClass() == "prop_door_rotating" || tr.Entity:GetClass() == "func_door" || tr.Entity:GetClass() == "func_door_rotating" ) ) then return end
        if ( self.Owner:GetPos():Distance( tr.Entity:GetPos() ) > 92 ) then return end

        if ( tr.Entity:GetInternalVariable( "m_bLocked" ) ) then
            tr.Entity:Fire( "UnLock" )
            tr.Entity:Fire( "Open" )

			tr.Entity:EmitSound( self.Sound )

            self.Owner.NextPoliceRam = SysTime() + 2.5
        end
    end
end

function SWEP:SecondaryAttack()
end

function SWEP:CanPrimaryAttack()
	return false
end

function SWEP:CanSecondaryAttack()
	return false
end
