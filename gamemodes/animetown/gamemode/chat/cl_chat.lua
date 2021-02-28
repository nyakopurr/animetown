include( "cl_gui.lua" )

module( "chat2", package.seeall )

surface.CreateFont( "repix_AnimeTown_ChatInput", {
    font = "Roboto",
    size = 14,
    extended = true
} )

function InitChatBox( hide )
    GModRP_Chatbox = vgui.Create( "GModRP_Chatbox" )
    GModRP_Chatbox:SetPos( 135, ScrH() - 375 )
    GModRP_Chatbox:SetSize( 525, 299 )

    if ( hide ) then
		GModRP_Chatbox:Hide()
	end
end

function GM:StartChat( team )
	if ( !GModRP_Chatbox ) then InitChatBox( false ) end

	if ( team ) then
		GModRP_Chatbox:Show( "Local" )
    else
		GModRP_Chatbox:Show( "Server" )
	end

	return true
end

function GM:FinishChat()
	if ( !GModRP_Chatbox ) then InitChatBox( true ) end

	GModRP_Chatbox:Hide()
end

function GM:ChatText( pID, pName, Text, InternalType, Type )
	if ( !GModRP_Chatbox ) then InitChatBox( true ) end

	local ply = player.GetByID( pID )

	local type = Type or "Server"
	local color = Color( 255, 255, 255, 255 )
	local teamColor = Color( 255, 255, 255 )
    local name = ply.RPNick and ply:RPNick() or pName

	if ( InternalType == "chat" ) then
		if ( IsValid( ply ) ) then
			teamColor = ply:GetNWString( "repix_AnimeTown_ChatColor", "146 146 146" )
            teamColor = string.Split( teamColor, " " )
            teamColor = Color( teamColor[1], teamColor[2], teamColor[3] )
		end

		GModRP_Chatbox:AddChat( type, name, pID, Text, teamColor )
		chat.PlaySound()
	elseif ( InternalType == "joinleave" ) then
		-- GModRP_Chatbox:AddText( Text, Color( 44, 62, 80 ) )
	else
		GModRP_Chatbox:AddText( Text, color )
	end
end

if ( !chatAddText ) then chatAddText = chat.AddText end
function chat.AddText( ... )
	if ( !GModRP_Chatbox ) then InitChatBox( true ) end

	-- local res = unpack( { ... } )
	-- local text = ""
	-- local col = Color( 255, 255, 255, 255 )
	local text = {}

	for _, obj in pairs( { ... } ) do
		if ( type( obj ) == "table" ) then
			-- col = Color( obj.r, obj.g, obj.b, obj.a or 255 )
			if ( GModRP_Chatbox && GModRP_Chatbox.TextPanel && GModRP_Chatbox.TextPanel.InsertColorChange ) then
				GModRP_Chatbox.TextPanel:InsertColorChange( obj.r, obj.g, obj.b, obj.a or 255 )
			end
			table.insert( text, Color( obj.r, obj.g, obj.b, obj.a or 255 ) )
		elseif ( type( obj ) == "string" ) then
			-- text = tostring( obj )
			if ( GModRP_Chatbox && GModRP_Chatbox.TextPanel && GModRP_Chatbox.TextPanel.InsertMessage ) then
				GModRP_Chatbox.TextPanel:InsertMessage( tostring( obj ) )
			end
			table.insert( text, tostring( obj ) )
		end
	end

	if ( GModRP_Chatbox && GModRP_Chatbox.TextPanel && GModRP_Chatbox.TextPanel.InsertMessage ) then
		GModRP_Chatbox.TextPanel:InsertMessage( "\n" )
	end

	chatAddText( ... )

	return text
end

function GM:OnPlayerChat( ply, strText, bTeamOnly, bPlayerIsDead )
	if ( IsValid( ply ) && ply:IsPlayer() ) then
		local name
		if ( ply.Name ) then
			name = ply.GetRPName and ply:GetRPName() or ply:Name()
		else
			name = "(Unknown Player)"
		end
		self:ChatText( ply:EntIndex(), name, strText, "chat" )
	else
		self:ChatText( 0, "(Unknown Player)", strText, "chat" )
	end

	return true
end

hook.Add( "PlayerBindPress", "OverrideChat", function( ply, bind, pressed )
	if ( !pressed ) then return end

	if ( bind == "messagemode" || bind == "messagemode2" ) then
		GAMEMODE:StartChat( bind == "messagemode2" )
		return true
	end
end )
