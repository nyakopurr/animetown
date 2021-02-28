local PANEL = {}

function PANEL:Init()
    self.TextPanel = vgui.Create( "DHTML", self )
    self.TextPanel.URLs = {}
    self.TextPanel:SetHTML([[
        <html>
            <head>
                <link rel="preconnect" href="https://fonts.gstatic.com">
                <link href="https://fonts.googleapis.com/css2?family=Rubik&display=swap" rel="stylesheet">
                <style type="text/css">
                    ::-webkit-scrollbar {
                        width: 10px;
                    }

                    ::-webkit-scrollbar-track {
                        background: rgba( 0, 0, 0, 0 );
                    }

                    ::-webkit-scrollbar-thumb {
                        background: rgba( 125, 125, 125, 0.5 );
                        border-radius: 6px;
                    }

                    ::-webkit-scrollbar-thumb:hover {
                        background: rgba( 145, 145, 145, 0.5 );
                        border-radius: 6px;
                    }

                    @keyframes messageFade {
                        from {opacity: 1;}
                        to {opacity: 0;}
                    }

                    /* Rule for p must be last! */
                    p {
                        font-size: 13px;
                        font-family: "Rubik", sans-serif;
                        font-weight: 400;
                        word-wrap: break-word;
                        margin-top: 4px;
                        margin-bottom: 4px;
                        animation-name: messageFade;
                        animation-duration: 3s;
                        animation-delay: 6s;
                        animation-fill-mode: forwards;
                        text-shadow: 0px 0px 2px #000000;
                    }
                </style>

                <script type="text/javascript">
                    function visibilityChanged(opacity, overflow) {
                        var func = function() {
                            var messages = document.getElementsByTagName("p");

                            for (var i = 0; i < messages.length; i++) {
                                messages[i].style.animation = "none";
                                messages[i].style.opacity = opacity;
                            }

                            document.body.style.overflow = overflow;
                        }

                        if (document.readyState == "complete") {
                            func();
                        } else {
                            var timer = setInterval(function() {
                                if (document.readyState == "complete") {
                                    func();
                                    clearInterval(timer);
                                }
                            }, 250);
                        }
                    }

                    function insertMessage(msgHTML, fadeOut) {
                        var func = function() {
                            var shouldAutoScroll = document.body.scrollHeight == (document.body.scrollTop + window.innerHeight);
                            var curMsg = document.createElement("P");

                            curMsg.innerHTML = msgHTML;

                            if (!fadeOut) {curMsg.style.animation = "none"};

                            document.body.appendChild(curMsg);

                            if (shouldAutoScroll) {
                                window.scrollTo(0, document.body.scrollHeight);
                            }
                        }

                        if (document.readyState == "complete") {
                            func();
                        } else {
                            var timer = setInterval(function() {
                                if (document.readyState == "complete") {
                                    func();
                                    clearInterval(timer);
                                }
                            }, 250);
                        }
                    }

                    function goToTextEnd() {
                        var func = function() {
                            window.scrollTo(0, document.body.scrollHeight);
                        }

                        if (document.readyState == "complete") {
                            func();
                        } else {
                            var timer = setInterval(function() {
                                if (document.readyState == "complete") {
                                    func();
                                    clearInterval(timer);
                                }
                            }, 250);
                        }
                    }
                </script>
            </head>
            <body>
            </body>
        </html>
    ]])
    function self.TextPanel:VisibilityChanged(open)
		self:QueueJavascript("visibilityChanged(" .. (open and 1 or 0) .. ", " .. (open and "'visible'" or "'hidden'") .. ");")

		-- Adding the scrollbar might shift some of the text, so we jump to the end in either
		self:GotoTextEnd()
	end

	self.TextPanel.OpenColorTag = false
	function self.TextPanel:InsertColorChange(r, g, b, a)
		if self.OpenColorTag then
			self.CurMessage = self.CurMessage .. "</color>"
		end

		self.CurMessage = self.CurMessage .. "<color style='color: rgba(" .. r .. "," .. g .. "," .. b .. "," .. a .. ")'>"
		self.OpenColorTag = true
	end

	self.TextPanel.CurMessage = ""
	function self.TextPanel:InsertMessage(message)
		self.CurMessage = self.CurMessage .. string.JavascriptSafe(message)

		if message[#message] == "\n" then
			if self.OpenColorTag then
				self.CurMessage = self.CurMessage .. "</color>"
			end

			self:QueueJavascript('insertMessage("' .. self.CurMessage .. '", ' .. ("true") .. ');')
			self.CurMessage = ""
			self.OpenColorTag = false
		end
	end

	function self.TextPanel:GotoTextEnd()
		self:QueueJavascript("goToTextEnd();")
	end

    self.TextInput = vgui.Create( "DTextEntry", self )
    self.TextInput:SetFont( "repix_AnimeTown_ChatInput" )
    self.TextInput:SetDrawBorder( false )
    self.TextInput:SetDrawLanguageID( false )
    self.TextInput.m_colText = Color( 255, 255, 255 )
	self.TextInput.m_colCursor = Color( 200, 200, 200 )
	self.TextInput.m_colHighlight = Color( 255, 255, 255, 84 )
    self.TextInput.Paint = function( self, w, h )
		self:DrawTextEntryText( self.m_colText, self.m_colHighlight, self.m_colCursor )
    end
    self.ChatType = ""
    self.TextInput.AutoCompleted = false
    self.TextInput.OnKeyCodeTyped = function( pnl, code )
        local Text = pnl:GetValue()
        if ( code == KEY_ESCAPE ) then
            GAMEMODE:FinishChat()
			self:Hide()
        elseif ( code == KEY_BACKSPACE ) then
            if ( #Text == 0 ) then
                GAMEMODE:FinishChat()
            elseif ( pnl.AutoCompleted ) then
                local oldText = pnl.AutoCompleted[1]
                pnl:SetText( oldText )
                pnl:SetCaretPos( utf8.len( oldText ) )
                pnl.AutoCompleted = false
                return true
            end
        elseif ( code == KEY_TAB ) then
            local newText = GAMEMODE:OnChatTab( Text )
            if ( newText ) then
                pnl:SetText( newText )
                pnl:SetCaretPos( utf8.len( newText ) )
                if ( pnl.AutoCompleted ) then
					pnl.AutoCompleted = { pnl.AutoCompleted[1], newText }
				else
					pnl.AutoCompleted = { Text, newText }
				end
            end
            return true
        elseif ( code == KEY_ENTER ) then
            if ( #Text > 0 ) then
                local cmd = "say"
                if ( self.ChatType == "Local" ) then
                    cmd = "say_team"
                end
                RunConsoleCommand( cmd, Text )

                if ( pnl.AddHistory ) then
                    pnl:AddHistory( Text )
                end
            end

            GAMEMODE:FinishChat()
        elseif ( code == KEY_UP ) then
            if ( pnl.HistoryPos ) then
                pnl.HistoryPos = pnl.HistoryPos - 1
            end
            if ( pnl.UpdateFromHistory ) then
                pnl:UpdateFromHistory()
            end
        elseif ( code == KEY_DOWN ) then
            if ( pnl.HistoryPos ) then
                pnl.HistoryPos = pnl.HistoryPos + 1
            end
            if ( pnl.UpdateFromHistory ) then
                pnl:UpdateFromHistory()
            end
        end
        pnl.AutoCompleted = nil
    end
    self.TextInput.OnChange = function( pnl )
        local Text = pnl:GetValue()
        local len = utf8.len( Text )
        if ( len > 212 ) then
            surface.PlaySound( "common/talk.wav" )
            -- Text = utf8.sub( Text, 0, 212 )
            local pos = pnl:GetCaretPos()
            pnl:SetText( Text )
            pnl:SetCaretPos( pos )
        end

        gamemode.Call( "ChatTextChanged", tostring( Text ) )
    end
end

function PANEL:PerformLayout()
    local w, h = self:GetSize()
    if ( w && h ) then
        self.TextPanel:SetPos( 8, 38 )
        -- self.TextPanel:SetW( w - 8 )
        self.TextPanel:SetWide( w - 8 - 2 )
        self.TextPanel:SetTall( h - 38 - 20 - 20 )
        self.TextPanel:InvalidateLayout()

        self.TextInput:SetPos( self.x + 12, self.y + h - 19 - 10 - 3 )
	    self.TextInput:SetSize( w - 12 - 16 - 13, 25 )
	    self.TextInput:InvalidateLayout()

        -- self.SettingsButton:SetPos( w - 16 - 8, h - 16 - 12 )
        -- self.SettingsButton:SetSize( 16, 16 )
        -- self.SettingsButton:InvalidateLayout()

        -- if ( self.TextPanel.GetVBar ) then
        --     self.TextPanel:GetVBar():SetWide( 8 )
        --     self.TextPanel:GetVBar():InvalidateLayout()
        -- end
    end
end

function PANEL:GetInputPanel()
	return self.TextInput
end

function PANEL:AddText( text, color, type )
	local rf = self.TextPanel.Text

    -- if ( self.TextPanel ) then
    --     self.TextPanel:SetFontInternal( "GModRP_Chat" )
    --     self.TextPanel:InsertColorChange( color.r, color.g, color.b, color.a or 255 )
    --     self.TextPanel:AppendText( text .. "\n" )
    -- end

    self.TextPanel:InsertColorChange(color.r, color.g, color.b, color.a or 255)
	self.TextPanel:InsertMessage( text .. "\n")

    local shortenedTime = os.date( "%H:%M %p", os.time() )

	-- chat.AddText( color, text )
    MsgC( Color( 255, 255, 255 ), "[" .. shortenedTime .. "] ", color, text )
    MsgN()

    -- if ( self.TextPanel && self.TextPanel.GotoTextEnd ) then
    --     self.TextPanel:GotoTextEnd()
    -- end
end

function PANEL:AddChat( type, name, id, text, color )
	local rf = self.TextPanel.Text

    -- self.TextPanel:SetFontInternal( "GModRP_Chat" )

	-- if ( type != "Server" ) then
    --     self.TextPanel:InsertColorChange( 255, 255, 255 )
    --     self.TextPanel:AppendText( "(" .. type .. ") " )
	-- end

	local chatcolor = Color( 255, 255, 255 )

    local shortenedTime = os.date( "%H:%M %p", os.time() )

    -- self.TextPanel:SetFontInternal( "GModRP_Chat" )

    -- self.TextPanel:InsertColorChange( color.r, color.g, color.b, color.a or 255 )
    -- self.TextPanel:AppendText( name .. ":" )
    -- self.TextPanel:InsertColorChange( chatcolor.r, chatcolor.g, chatcolor.b, color.a or 255 )
    -- self.TextPanel:AppendText( ":" )

    -- local nchar = utf8.len( text )
    -- local parsedText = text
	-- local charpos = 0
    -- local buffer = {}

    -- local function addbuffer()

    --     self.TextPanel:InsertColorChange( chatcolor.r, chatcolor.g, chatcolor.b, chatcolor.a or 255 )
	-- 	self.TextPanel:AppendText( table.concat(buffer) )

	-- 	buffer = {}

	-- end

    -- local function IsValidEmote( emote )
    --     if ( !emote ) then
    --         return false
    --     end

    --     for key, _ in pairs( ChatEmotes ) do
    --         if ( key == emote ) then
    --             return true
    --         end
    --     end

    --     return false
    -- end

    -- while charpos < nchar do
    --     local startpos, endpos = parsedText:find( utf8.charpattern )
    --     if not startpos then break end
    --     table.insert( buffer, utf8.sub( parsedText, startpos, endpos ) )
    --     charpos = charpos + endpos
    --     -- parsedText = parsedText:sub( endpos + 1 )
    --     parsedText = utf8.sub( parsedText, endpos + 1 )
    -- end

    -- self.TextPanel:AppendText( " " .. text .. "\n" )
    -- table.insert( buffer, "\n" )
	-- addbuffer()

    self.TextPanel:InsertColorChange(color.r, color.g, color.b, color.a or 255)
    self.TextPanel:InsertMessage( name )

    self.TextPanel:InsertColorChange(255, 255, 255, 255)
    self.TextPanel:InsertMessage( ":" )

    self.TextPanel:InsertColorChange(255, 255, 255, 255)
	self.TextPanel:InsertMessage( " " .. text .. "\n")

	-- chat.AddText( Color( 255, 255, 255 ), "(" .. type .. ") ", color, name, chatcolor, ": " .. text )
    MsgC( Color( 255, 255, 255 ), "(" .. shortenedTime .. ") ", color, name, chatcolor, ": " .. text )
    MsgN()

    -- self.TextPanel:GotoTextEnd()
end

function PANEL:Show( type )
	-- self.TextPanel:SetFade(false)
    self.TextPanel.Fade = false
	self.TextPanel:SetVisible(true)

    self.TextPanel:VisibilityChanged( true )

    -- self.TextPanel.VBar:SetEnabled( true )

    -- self.TextPanel:GotoTextEnd()

	self:SetMouseInputEnabled(true)
	self:SetKeyboardInputEnabled(true)

	self:SetZPos(-30)

	self.TextInput:RequestFocus()
	self.TextInput:SetVisible(true)
	self.TextInput:MakePopup()

    -- self.SettingsButton:SetVisible( true )

	if self.ChatType != type then
		self.ChatType = type
		self:InvalidateLayout()
	end
end

function PANEL:Hide()
	-- self.TextPanel:SetFade(true)
    self.TextPanel.Fade = true

    self.TextPanel:VisibilityChanged( false )

    -- self.TextPanel.VBar:SetEnabled( false )

	self:SetMouseInputEnabled(false)
	self:SetKeyboardInputEnabled(false)

	self.TextInput:SetText("")
	self.TextInput:SetVisible(false)

    -- self.SettingsButton:SetVisible( false )
end

function PANEL:IsMouseOver( x, y, w, h )
	local mx, my = self:CursorPos()

	if ( mx && my ) then
		return ( mx >= x && mx <= ( x + w ) ) && ( my >= y && my <= ( y + h ) )
	else
		return false
	end
end

local chatboxMat = Material( "repix/animetown/chatting/chatbox.png" )
function PANEL:Paint( w, h )
	if ( !self.TextPanel.Fade ) then
		-- surface.SetDrawColor( 33, 35, 36, 250 )
        -- surface.DrawRect( 0, 0, w, 30 )

		surface.SetDrawColor( 255, 255, 255 )
		surface.SetMaterial( chatboxMat )
		surface.DrawTexturedRect( 0, 0, w, h )

        -- draw.RoundedBoxEx( 4, 0, 0, w, h, Color( 51, 51, 51, 255 ), true, true, false, false )

        -- surface.SetDrawColor( 33, 35, 36, 250 - 15 )
        -- surface.DrawRect( 0, 30, w, h - 30 )

        -- draw.RoundedBoxEx( 4, 2, 2, w - 4, h - 4, Color( 35, 40, 44, 255 ), false, false, true, true )
	end
end

function PANEL:Think()
    if ( self:IsMouseOver( 0, 0, self:GetWide(), 30 ) && input.IsMouseDown( MOUSE_FIRST ) ) then
        if ( !self.DraggingBar ) then
            local x, y = self:GetPos()
            self.DragX, self.DragY = ( x - gui.MouseX() ), ( y - gui.MouseY() )

            self.DraggingBar = true
        end
    end

    if ( self.DraggingBar && input.IsMouseDown( MOUSE_FIRST ) ) then
        local x, y = gui.MouseX() + self.DragX, gui.MouseY() + self.DragY
        x = math.Clamp( x, 0, ScrW() - self:GetWide() )
        y = math.Clamp( y, 0, ScrH() - self:GetTall() )
        cookie.Set( "gui_chatx", x )
        cookie.Set( "gui_chaty", y )
        self:SetPos( x, y )
        self.TextInput:SetPos( x + 7, y + self:GetTall() - 19 - 10 )
        -- self:SetCursor("sizeall")
    else
        self.DraggingBar = false
    end
end

vgui.Register( "GModRP_Chatbox", PANEL, "EditablePanel" )

surface.CreateFont( "HUB_ChatBox", {
    font = "Panton SemiBold",
    size = 24,
    extended = true
} )
