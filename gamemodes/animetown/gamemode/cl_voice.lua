local PANEL = {}
local PlayerVoicePanels = {}

function PANEL:Init()
	self.Avatar = vgui.Create( "AvatarImage", self )
	self.Avatar:SetPos( 111, 7 )
	self.Avatar:SetSize( 24, 24 )

	self:SetSize( 160, 41 )
	self:DockPadding( 4, 4, 4, 4 )
	self:DockMargin( 2, 2, 2, 2 )
	self:Dock( TOP )
end

local baseOneMat = Material( "repix/animetown/hud/voice/base_01.png" )
local baseTwoMat = Material( "repix/animetown/hud/voice/base_02.png" )
local baseThreeMat = Material( "repix/animetown/hud/voice/base_03.png" )
local voiceMat = { baseOneMat, baseTwoMat, baseThreeMat }
function PANEL:Setup( ply )
	self.ply = ply
	self.Avatar:SetPlayer( ply )
	self.Material = table.Random( voiceMat )

	self:InvalidateLayout()
end

surface.CreateFont( "AT_VoiceHUD", { font = "Rubik Medium", size = 14, weight = 500, extended = true } )
surface.CreateFont( "AT_VoiceHUD_Shadow", { font = "Rubik Medium", size = 14, weight = 500, blursize = 2, extended = true } )
function PANEL:Paint( w, h )
	if ( !IsValid( self.ply ) ) then return end

	local mat = self.Material or baseOneMat
	surface.SetDrawColor( 255, 255, 255 )
	surface.SetMaterial( mat )
	surface.DrawTexturedRect( 0, 0, mat:Width(), mat:Height() )

	local nick = self.ply:Nick()
	if ( self.ply.RPNick ) then
		nick = self.ply:RPNick()
	end

	if ( utf8.len( nick ) > 14 ) then
		nick = utf8.sub( nick, 1, 14 ) .. ".."
	end

	draw.SimpleText( nick, "AT_VoiceHUD", 100, 14, Color( 0, 0, 0, 255 - ( 255 * 0.25 ) ), 2, nil )
	draw.SimpleText( nick, "AT_VoiceHUD", 100, 12, Color( 255, 255, 255 ), 2, nil )
end

function PANEL:Think()
	if ( self.fadeAnim ) then
		self.fadeAnim:Run()
	end
end

function PANEL:FadeOut( anim, delta, data )
	if ( anim.Finished ) then
		if ( IsValid( PlayerVoicePanels[ self.ply ] ) ) then
			PlayerVoicePanels[ self.ply ]:Remove()
			PlayerVoicePanels[ self.ply ] = nil
			return
		end
	return end

	self:SetAlpha( 255 - ( 255 * delta ) )
end

derma.DefineControl( "VoiceNotify", "", PANEL, "DPanel" )

function GM:PlayerStartVoice( ply )
	if ( !IsValid( g_VoicePanelList ) ) then return end

	-- There'd be an exta one if voice_loopback is on, so remove it.
	GAMEMODE:PlayerEndVoice( ply )

	if ( IsValid( PlayerVoicePanels[ ply ] ) ) then
		if ( PlayerVoicePanels[ ply ].fadeAnim ) then
			PlayerVoicePanels[ ply ].fadeAnim:Stop()
			PlayerVoicePanels[ ply ].fadeAnim = nil
		end

		PlayerVoicePanels[ ply ]:SetAlpha( 255 )

		return
	end

	if ( !IsValid( ply ) ) then return end

	local pnl = g_VoicePanelList:Add( "VoiceNotify" )
	pnl:Setup( ply )

	PlayerVoicePanels[ ply ] = pnl
end

local function VoiceClean()
	for k, v in pairs( PlayerVoicePanels ) do
		if ( !IsValid( k ) ) then
			GAMEMODE:PlayerEndVoice( k )
		end
	end
end
timer.Create( "VoiceClean", 10, 0, VoiceClean )

function GM:PlayerEndVoice( ply )
	if ( IsValid( PlayerVoicePanels[ ply ] ) ) then
		if ( PlayerVoicePanels[ ply ].fadeAnim ) then return end

		PlayerVoicePanels[ ply ].fadeAnim = Derma_Anim( "FadeOut", PlayerVoicePanels[ ply ], PlayerVoicePanels[ ply ].FadeOut )
		PlayerVoicePanels[ ply ].fadeAnim:Start( 0.25 )
	end
end

local function CreateVoiceVGUI()
	g_VoicePanelList = vgui.Create( "DPanel" )

	g_VoicePanelList:ParentToHUD()
	g_VoicePanelList:SetPos( ScrW() - 180, 100 )
	g_VoicePanelList:SetSize( 162, ScrH() - 200 )
	g_VoicePanelList:SetPaintBackground( false )
end
hook.Add( "InitPostEntity", "CreateVoiceVGUI", CreateVoiceVGUI )
