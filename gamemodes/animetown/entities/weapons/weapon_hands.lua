AddCSLuaFile()

SWEP.Base = "weapon_base"
SWEP.PrintName = "Руки"
SWEP.Slot = 1
SWEP.SlotPos = 1
SWEP.HoldType = "normal"
SWEP.DrawAmmo = false
SWEP.UseHands = true

SWEP.Primary.Delay = 0.3
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ""

SWEP.Secondary.Delay = 0.3
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ""

function SWEP:Initialize()
	self:SetHoldType( self.HoldType )
	self:DrawShadow( false )
end

function SWEP:Precache()
end

function SWEP:Deploy()
	if ( CLIENT ) then return end

	if ( IsValid( self.Owner ) ) then
		self.Owner:DrawViewModel( false )
		self.Owner:DrawWorldModel( false )
	end

	return true
end

function SWEP:Holster()
	return true
end

function SWEP:Reload()
	return false
end

function SWEP:PrimaryAttack()
end

function SWEP:SecondaryAttack()
end

function SWEP:CanPrimaryAttack()
	return false
end

function SWEP:CanSecondaryAttack()
	return false
end

function SWEP:PreDrawViewModel()
    return true
end

function SWEP:PreDrawWorldModel()
	return true
end

function SWEP:DrawWorldModel()
end
