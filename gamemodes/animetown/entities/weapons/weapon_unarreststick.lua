AddCSLuaFile()

SWEP.Base = "weapon_base"
SWEP.PrintName = "Unarrest Stick"
SWEP.Slot = 1
SWEP.SlotPos = 2
SWEP.HoldType = "normal"
SWEP.DrawAmmo = false
SWEP.UseHands = false

SWEP.AnimPrefix = "stunstick"
SWEP.StickColor = Color( 75, 255, 75 )

SWEP.ViewModel = Model( "models/weapons/v_stunbaton.mdl" )
SWEP.WorldModel = Model( "models/weapons/w_stunbaton.mdl" )

SWEP.Sound = Sound( "weapons/stunstick/stunstick_swing1.wav" )

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ""

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ""

function SWEP:SetupDataTables()
    self:NetworkVar( "Bool", 2, "SeqIdling" )
    self:NetworkVar( "Float", 4, "SeqIdleTime" )
    self:NetworkVar( "Float", 5, "HoldTypeChangeTime" )
end

function SWEP:Initialize()
	self:SetHoldType( self.HoldType )

    if ( SERVER ) then return end

    stunstickMaterials = stunstickMaterials or {}

    local materialName = "darkrp/" .. self:GetClass()
    if ( stunstickMaterials[ materialName ] ) then return end

    CreateMaterial( materialName, "VertexLitGeneric", {
        ["$basetexture"] = "models/debug/debugwhite",
        ["$surfaceprop"] = "metal",
        ["$envmap"] = "env_cubemap",
        ["$envmaptint"] = "[ .5 .5 .5 ]",
        ["$selfillum"] = 0,
        ["$model"] = 1
    } ):SetVector( "$color2", self.StickColor:ToVector() )

    stunstickMaterials[ materialName ] = true
end

function SWEP:Precache()
end

function SWEP:Deploy()
    if ( SERVER ) then
        self:SetMaterial( "!darkrp/" .. self:GetClass() )
    end

    local vm = self:GetOwner():GetViewModel()
    if ( !IsValid( vm ) ) then return true end

    vm:SendViewModelMatchingSequence( vm:LookupSequence( "idle01" ) )

	return true
end

function SWEP:Holster()
    self:ResetStick()
	return true
end

function SWEP:Reload()
end

function SWEP:PrimaryAttack()
    self:SetHoldType( "melee" )
    self:SetHoldTypeChangeTime( CurTime() + 0.3 )

    self:SetNextPrimaryFire( CurTime() + 0.51 )

    local vm = self:GetOwner():GetViewModel()
    if ( IsValid( vm ) ) then
        vm:SendViewModelMatchingSequence( vm:LookupSequence( "idle01" ) )
        self:SetSeqIdling( true )
    end

    if ( CLIENT ) then return end

    local tr = self.Owner:GetEyeTraceNoCursor()
	if ( IsValid( tr.Entity ) ) then
		if ( !tr.Entity:IsPlayer() ) then return end
		if ( self.Owner:GetPos():Distance( tr.Entity:GetPos() ) > 92 ) then return end
        if ( !tr.Entity:GetNWBool( "repix_AnimeTown_Arrested", false ) ) then return end

        if ( police && police.Unarrest ) then
            police.Unarrest( tr.Entity )
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

function SWEP:PreDrawViewModel( vm )
    for i = 9, 15 do
        vm:SetSubMaterial( i, "!darkrp/" .. self:GetClass() )
    end
end

function SWEP:ViewModelDrawn( vm )
    if ( !IsValid( vm ) ) then return end
    vm:SetSubMaterial()
end

function SWEP:ResetStick()
    if ( !IsValid( self:GetOwner() ) ) then return end
    if ( SERVER ) then
        self:SetMaterial()
    end

    self:SetSeqIdling( false )
    self:SetSeqIdleTime( 0 )
    self:SetHoldTypeChangeTime( 0 )
end

function SWEP:Think()
    if ( self:GetSeqIdling() ) then
        self:SetSeqIdling( false )

        if ( !IsValid( self:GetOwner() ) ) then return end
        self:GetOwner():SetAnimation( PLAYER_ATTACK1 )
        self:EmitSound( self.Sound )

        local vm = self:GetOwner():GetViewModel()
        if ( !IsValid( vm ) ) then return end
        vm:SendViewModelMatchingSequence( vm:LookupSequence( "attackch" ) )
        vm:SetPlaybackRate( 1 + 1 / 3 )
        local duration = vm:SequenceDuration() / vm:GetPlaybackRate()
        local time = CurTime() + duration
        self:SetSeqIdleTime( time )
        self:SetNextPrimaryFire( time )
    end
    if ( self:GetSeqIdleTime() ~= 0 && CurTime() >= self:GetSeqIdleTime() ) then
        self:SetSeqIdleTime( 0 )

        if ( !IsValid( self:GetOwner() ) ) then return end
        local vm = self:GetOwner():GetViewModel()
        if ( !IsValid( vm ) ) then return end
        vm:SendViewModelMatchingSequence( vm:LookupSequence( "idle01" ) )
    end
    if ( self:GetHoldTypeChangeTime() ~= 0 && CurTime() >= self:GetHoldTypeChangeTime() ) then
        self:SetHoldTypeChangeTime( 0 )
        self:SetHoldType( "normal" )
    end
end
