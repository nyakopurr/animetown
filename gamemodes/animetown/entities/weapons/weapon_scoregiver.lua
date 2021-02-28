AddCSLuaFile()

SWEP.Base = "weapon_base"
SWEP.PrintName = "Поставить оценку"
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

function SWEP:SetupDataTables()
    self:NetworkVar( "Int", 0, "Score" )
end

function SWEP:Initialize()
	self:SetHoldType( self.HoldType )
	self:DrawShadow( false )

	if ( CLIENT ) then return end

	self:SetScore( 5 )
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
	self:SetNextPrimaryFire( CurTime() + 0.5 )

	if ( CLIENT ) then return end

	local tr = self.Owner:GetEyeTraceNoCursor()
	if ( IsValid( tr.Entity ) ) then
		if ( !tr.Entity:IsPlayer() ) then return end
		if ( self.Owner:GetPos():Distance( tr.Entity:GetPos() ) > 128 ) then return end
		if ( tr.Entity:GetNWBool( "repix_AnimeTown_Arrested", false ) ) then return end
		if ( tr.Entity:Location() ~= "school" ) then return end
		if ( self.Owner:Location() ~= "school" ) then return end
		if ( ( tr.Entity.NextMarkCanGet or 0 ) > SysTime() ) then
			self.Owner:ChatPrint( "Этот игрок уже недавно получал оценку." )
			return
		end
        if ( self:GetScore() > 5 || self:GetScore() < 2 ) then return end

		AddMark( tr.Entity, self:GetScore() )

		tr.Entity.NextMarkCanGet = SysTime() + 120.0
	end
end

function SWEP:SecondaryAttack()
    if ( CLIENT ) then return end

    local newScore = self:GetScore()
    if ( newScore < 5 ) then
        newScore = newScore + 1
    else
        newScore = 2
    end
    self:SetScore( newScore )
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

if ( SERVER ) then return end

surface.CreateFont( "AT_ScoreGiver", { font = "Roboto", size = 24, extended = true } )
surface.CreateFont( "AT_ScoreGiver2", { font = "Roboto", size = 16, extended = true } )

function SWEP:DrawHUD() end
function SWEP:DrawHUDBackground()
    draw.SimpleText( "Выбрана оценка: " .. ( self:GetScore() or 5 ), "AT_ScoreGiver", ScrW() / 2, 16, Color( 255, 255, 255 ), 1 )
    draw.SimpleText( "Нажмите ПКМ, чтобы изменить её.", "AT_ScoreGiver2", ScrW() / 2, 42, Color( 255, 255, 255 ), 1 )
end
