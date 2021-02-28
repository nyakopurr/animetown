local bg1Mat = Material( "repix/animetown/profile/personal/bg_default_01.png" )
local bg2Mat = Material( "repix/animetown/profile/personal/bg_default_02.png" )
local bg3Mat = Material( "repix/animetown/profile/personal/bg_default_03.png" )
local bg4Mat = Material( "repix/animetown/profile/personal/bg_premium_01.png" )
local bg5Mat = Material( "repix/animetown/profile/personal/bg_premium_02.png" )
local bg6Mat = Material( "repix/animetown/profile/personal/bg_premium_03.png" )
local bg7Mat = Material( "repix/animetown/profile/personal/bg_premium_04.png" )
local bg8Mat = Material( "repix/animetown/profile/personal/bg_premium_05.png" )
local bg9Mat = Material( "repix/animetown/profile/personal/bg_premium_06.png" )
local retMat = Material( "repix/animetown/profile/personal/back_btn.png" )
local avatarMat = Material( "repix/animetown/profile/personal/avatar_placeholder.png" )
local levelMat = Material( "repix/animetown/profile/personal/level_base.png" )
local xpMat = Material( "repix/animetown/profile/personal/level_xp.png" )
local premiumMat = Material( "repix/animetown/profile/personal/pin_premium.png" )
local bannedMat = Material( "repix/animetown/profile/personal/banned.png" )
local achievementsMat = Material( "repix/animetown/profile/personal/achievements.png" )
local wallMat = Material( "repix/animetown/profile/personal/wall.png" )
local noAchievementsMat = Material( "repix/animetown/profile/personal/achievements_none.png" )
local commentMat = Material( "repix/animetown/profile/personal/wall_placeholder.png" )
local inputMat = Material( "repix/animetown/profile/personal/wall_noinput.png" )
local bgSelectMat = Material( "repix/animetown/profile/personal/bg_select_base.png" )
local bgSelectPremMat = Material( "repix/animetown/profile/personal/bg_select_premium.png" )
local ruFlagMat = Material( "repix/animetown/profile/personal/flags/ru.png" )

local function CreateShadowFont( name, font, size, weight, extended )
    surface.CreateFont( name, { font = font, size = size, weight = weight, extended = extended } )
    surface.CreateFont( name .. "_Shadow", { font = font, size = size, blursize = 2, weight = weight, extended = extended } )
end
CreateShadowFont( "AT_Profile_BackgroundButton", "Rubik Medium", ScreenScale( 18 ) / 3, 500, true )
CreateShadowFont( "AT_Profile_Username", "Rubik Medium", ScreenScale( 57 ) / 3, 500, true )

surface.CreateFont( "AT_Profile_Status", { font = "Rubik Medium", size = ScreenScale( 28 ) / 3, weight = 500, extended = true } )
surface.CreateFont( "AT_Profile_LastOnline", { font = "Rubik Medium", size = ScreenScale( 21 ) / 3, weight = 500, extended = true } )
surface.CreateFont( "AT_Profile_Level", { font = "Rubik", size = ScreenScale( 20 ) / 3, weight = 700, extended = true } )
surface.CreateFont( "AT_Profile_WallEntry", { font = "Rubik Medium", size = ScreenScale( 16 ) / 3, weight = 500, extended = true } )
surface.CreateFont( "AT_Profile_WallDate", { font = "Rubik Medium", size = ScreenScale( 12 ) / 3, weight = 500, extended = true } )

local backgrounds = {
    [1] = bg1Mat, [3] = bg3Mat, [5] = bg5Mat, [7] = bg7Mat, [9] = bg9Mat,
    [2] = bg2Mat, [4] = bg4Mat, [6] = bg6Mat, [8] = bg8Mat,
}

function OpenProfile( steamid, name, country, premium, banned, bg, status, lastOnline, lvl, xp, achi, comments )
    if ( ValidPanel( AT_ProfileGUI ) ) then
        AT_ProfileGUI:Remove()
        AT_ProfileGUI = nil
    end

    AT_ProfileGUI = vgui.Create( "EditablePanel" )
    AT_ProfileGUI:SetSize( ScrW(), ScrH() )
    AT_ProfileGUI:MakePopup()
    AT_ProfileGUI:SetAlpha( 0 )
    AT_ProfileGUI:AlphaTo( 255, 0.15 )
    AT_ProfileGUI.Paint = function()
    end

    local scrollPanel = vgui.Create( "DScrollPanel", AT_ProfileGUI )
    scrollPanel:SetPos( 0, 0 )
    scrollPanel:SetSize( AT_ProfileGUI:GetWide(), AT_ProfileGUI:GetTall() )
    scrollPanel.EntryPanel = nil
    scrollPanel:GetVBar():SetSize( SX( 6 ), scrollPanel:GetVBar():GetTall() )
    scrollPanel:GetVBar().Paint = function( self, w, h )
        surface.SetDrawColor( 40 + 16, 33 + 16, 53 + 16 )
        surface.DrawRect( 0, 0, w, h )
    end
    scrollPanel:GetVBar().btnUp.Paint = function() end
    scrollPanel:GetVBar().btnDown.Paint = function() end
    scrollPanel:GetVBar().btnGrip.Paint = function( self, w, h )
        if ( self:IsHovered() ) then
            draw.RoundedBox( 6, 0, 0, w, h, Color( 248, 7, 89 ) )
            return
        end

        draw.RoundedBox( 6, 0, 0, w, h, Color( 217, 89, 120 ) )
    end

    local bgPnl = vgui.Create( "DPanel", scrollPanel )
    bgPnl:SetPos( 0, 0 )
    bgPnl:SetSize( scrollPanel:GetWide(), SY( 424 ) )
    bgPnl.Paint = function( self, w, h )
        local backgroundMat = bg
        local ply = player.GetBySteamID( steamid )
        if ( IsValid( ply ) ) then
            -- player online, so it is much more updatable than ever
            backgroundMat = ply:GetNWInt( "repix_AnimeTown_Profile.Background", 1 )
        end
        backgroundMat = tonumber( backgroundMat ) or 1

        INTERFACE_SMOOTHING( 1920, 1080, function()
            surface.SetMaterial( backgrounds[ backgroundMat ] )
            surface.SetDrawColor( 255, 255, 255 )
            surface.DrawTexturedRect( 0, 0, w, h )

            surface.SetFont( "AT_Profile_Username" )

            draw.SimpleText( name, "AT_Profile_Username_Shadow", SX( 376 ), h - SY( 17 ) + SY( 2 ), Color( 0, 0, 0, 255 - ( 255 * 0.25 ) ), nil, 4 )
            draw.SimpleText( name, "AT_Profile_Username", SX( 376 ), h - SY( 17 ), Color( 255, 255, 255 ), nil, 4 )

            local flagMat = profile and profile.PersonalFlagMaterials[ string.lower( country ) ] or ruFlagMat
            local x = SX( 376 ) + surface.GetTextSize( name ) + SX( 16 )
            surface.SetMaterial( flagMat )
            surface.SetDrawColor( 255, 255, 255 )
            surface.DrawTexturedRect( x, h - SY( flagMat:Height() ) - SY( 19 ), SX( flagMat:Width() ), SY( flagMat:Height() ) )

            if ( premium ) then
                surface.SetMaterial( premiumMat )
                surface.SetDrawColor( 255, 255, 255 )
                surface.DrawTexturedRect( x + SX( 69 ), h - SY( premiumMat:Height() ) - SY( 17 ), SX( premiumMat:Width() ), SY( premiumMat:Height() ) )
            end
        end )
    end

    local returnBtn = vgui.Create( "DButton", bgPnl )
    returnBtn:SetPos( SX( 35 ), SY( 25 ) )
    returnBtn:SetSize( SX( 38 ), SY( 38 ) )
    returnBtn:SetText( "" )
    returnBtn.Paint = function( self, w, h )
        INTERFACE_SMOOTHING( 1920, 1080, function()
            surface.SetMaterial( retMat )
            surface.SetDrawColor( 255, 255, 255 )
            surface.DrawTexturedRect( 0, 0, w, h )
        end )
    end
    returnBtn.DoClick = function()
        if ( ValidPanel( AT_ProfileGUI ) ) then
            AT_ProfileGUI:Remove()
            AT_ProfileGUI = nil
        end
    end

    if ( steamid == LocalPlayer():SteamID() ) then
        local bgBtn = vgui.Create( "DButton", bgPnl )
        bgBtn:SetPos( bgPnl:GetWide() - SX( 267 ) - SX( 41 ), SY( 32 ) )
        bgBtn:SetSize( SX( 267 ), SY( 41 ) )
        bgBtn:SetText( "" )
        bgBtn.ChildPanel = nil
        bgBtn.Paint = function( self, w, h )
            INTERFACE_SMOOTHING( 1920, 1080, function()
                draw.RoundedBox( 12, 0, 0, w, h, Color( 0, 0, 0, 255 - ( 255 * 0.45 ) ) )

                draw.SimpleText( "Изменить фон", "AT_Profile_BackgroundButton_Shadow", w / 2, h / 2 + SX( 2 ), Color( 0, 0, 0, 255 - ( 255 * 0.25 ) ), 1, 1 )
                draw.SimpleText( "Изменить фон", "AT_Profile_BackgroundButton", w / 2, h / 2, Color( 255, 255, 255 ), 1, 1 )
            end )
        end
        bgBtn.DoClick = function( self )
            if ( ValidPanel( self.ChildPanel ) ) then
                self.ChildPanel:Remove()
                self.ChildPanel = nil
                return
            end

            local selectPnl = vgui.Create( "DPanel", scrollPanel )
            selectPnl:SetPos( bgPnl:GetWide() - SX( 647 ) - SX( 41 ), SY( 85 ) )
            selectPnl:SetSize( SX( 647 ), SY( 232 ) )
            selectPnl.Paint = function( self, w, h )
                INTERFACE_SMOOTHING( 1920, 1080, function()
                    surface.SetMaterial( bgSelectMat )
                    surface.SetDrawColor( 255, 255, 255 )
                    surface.DrawTexturedRect( 0, 0, w, h )
                end )
            end

            local closeBtn = vgui.Create( "DButton", selectPnl )
            closeBtn:SetSize( SX( 24 ), SY( 24 ) )
            closeBtn:SetPos( selectPnl:GetWide() - SX( 24 ) - SX( 21 ), SY( 18 ) )
            closeBtn:SetText( "" )
            closeBtn.Paint = function() end
            closeBtn.DoClick = function()
                if ( ValidPanel( selectPnl ) ) then
                    selectPnl:Remove()
                    selectPnl = nil
                end
            end

            -- first row
            local x, y = SX( 34 ), SY( 18 )
            for _, b in pairs( { 1, 3, 2 } ) do
                local bgselBtn = vgui.Create( "DButton", selectPnl )
                bgselBtn:SetSize( SX( 136 ), SY( 56 ) )
                bgselBtn:SetPos( x, y )
                bgselBtn:SetText( "" )
                bgselBtn.Paint = function() end
                bgselBtn.DoClick = function()
                    -- if ( bg == b ) then return end
                    -- bg = b
                    net.Start( "repix_AnimeTown_ChangeBackground" )
                        net.WriteInt( b, 8 )
                    net.SendToServer()
                end

                x = x + SX( 136 ) + SX( 12 )
            end

            -- second & third row
            x = SX( 34 )
            y = y + SY( 56 ) + SY( 14 )
            for i = 4, 9 do
                local bgselBtn = vgui.Create( "DButton", selectPnl )
                bgselBtn:SetSize( SX( 136 ), SY( 56 ) )
                bgselBtn:SetPos( x, y )
                bgselBtn:SetText( "" )
                bgselBtn.Paint = function( self, w, h )
                    INTERFACE_SMOOTHING( 1920, 1080, function()
                        if ( !premium ) then
                            surface.SetMaterial( bgSelectPremMat )
                            surface.SetDrawColor( 255, 255, 255 )
                            surface.DrawTexturedRect( 0, 0, w, h )
                        end
                    end )
                end
                bgselBtn.DoClick = function()
                    if ( !premium ) then return end
                    -- if ( bg == i ) then return end

                    -- bg = i
                    net.Start( "repix_AnimeTown_ChangeBackground" )
                        net.WriteInt( i, 8 )
                    net.SendToServer()
                end

                if ( i == 7 ) then
                    x = SX( 34 )
                    y = y + SY( 56 ) + SY( 14 )
                    continue
                end

                x = x + SX( 136 ) + SX( 12 )
            end

            self.ChildPanel = selectPnl
        end
    end

    local messages = util.JSONToTable( comments ) or {}

    local infoPnl = vgui.Create( "DPanel", scrollPanel )
    infoPnl:SetPos( 0, SY( 424 ) )
    infoPnl:SetSize( scrollPanel:GetWide(), SY( 950 ) + ( table.Count( messages ) * SY( 128 ) ) )
    infoPnl.Paint = function( self, w, h )
        INTERFACE_SMOOTHING( 1920, 1080, function()
            -- Background
            surface.SetDrawColor( 40, 33, 53 )
            surface.DrawRect( 0, 0, self:GetSize() )

            -- Status & Online
            draw.SimpleText( "| " .. status, "AT_Profile_Status", SX( 376 ), SY( 22 ), Color( 255, 255, 255 ) )
            local lOnline = "сейчас в сети"
            if ( isnumber( lastOnline ) && !IsValid( player.GetBySteamID( steamid ) ) ) then lOnline = "последний раз онлайн: " .. os.date( "%d.%m.%Y %H:%M", lastOnline ) end
            draw.SimpleText( lOnline, "AT_Profile_LastOnline", SX( 376 ), SY( 64 ), Color( 255, 255, 255 ) )

            -- Leveling
            surface.SetMaterial( levelMat )
            surface.SetDrawColor( 255, 255, 255 )
            surface.DrawTexturedRect( SX( 112 ), SY( 113 ), SX( levelMat:Width() ), SY( levelMat:Height() ) )

            surface.SetMaterial( xpMat )
            surface.SetDrawColor( 255, 255, 255 )
            render.SetScissorRect( SX( 116 ), SY( 115 ), SX( 116 ) + ( SX( xpMat:Width() ) * ( xp / ( 500 + ( math.floor( lvl * 100 ) ) ) ) ), h, true )
                surface.DrawTexturedRect( SX( 116 ), SY( 115 ), SX( xpMat:Width() ), SY( xpMat:Height() ) )
            render.SetScissorRect( 0, 0, 0, 0, false )

            draw.SimpleText( "lvl " .. lvl, "AT_Profile_Level", SX( 232 ), SY( 136 ), Color( 255, 255, 255 ), 1 )

            -- Achievements Section
            surface.SetMaterial( achievementsMat )
            surface.SetDrawColor( 255, 255, 255 )
            surface.DrawTexturedRect( 0, SY( 196 ), SX( achievementsMat:Width() ), SY( achievementsMat:Height() ) )

            surface.SetMaterial( noAchievementsMat )
            surface.SetDrawColor( 255, 255, 255 )
            surface.DrawTexturedRect( ( w - SX( noAchievementsMat:Width() ) ) / 2, SY( 275 ), SX( noAchievementsMat:Width() ), SY( noAchievementsMat:Height() ) )

            -- Wall Section
            surface.SetMaterial( wallMat )
            surface.SetDrawColor( 255, 255, 255 )
            surface.DrawTexturedRect( 0, SY( 485 ), SX( wallMat:Width() ), SY( wallMat:Height() ) )

            if ( steamid == LocalPlayer():SteamID() ) then
                surface.SetMaterial( commentMat )
                surface.SetDrawColor( 255, 255, 255 )
                surface.DrawTexturedRect( SX( 646 ), SY( 600 ), SX( commentMat:Width() ), SY( commentMat:Height() ) )

                if ( ValidPanel( scrollPanel.EntryPanel ) && scrollPanel.EntryPanel:GetValue() == "" && !scrollPanel.EntryPanel:IsEditing() ) then
                    surface.SetMaterial( inputMat )
                    surface.SetDrawColor( 255, 255, 255 )
                    surface.DrawTexturedRect( SX( 781 ), SY( 616 ), SX( inputMat:Width() ), SY( inputMat:Height() ) )
                end
            end
        end )
    end

    local avatar = vgui.Create( "AvatarImage", scrollPanel )
    avatar:SetPos( SX( 133 ), SY( 325 ) )
    avatar:SetSize( SX( 198 ), SY( 198 ) )
    avatar:SetSteamID( util.SteamIDTo64( steamid ), 184 )
    avatar:SetPaintedManually( true )

    local avatarPnl = vgui.Create( "DPanel", scrollPanel )
    avatarPnl:SetPos( SX( 133 ), SY( 325 ) )
    avatarPnl:SetSize( SX( 198 ), SY( 198 ) )
    avatarPnl.Paint = function( self, w, h )
        INTERFACE_SMOOTHING( 1920, 1080, function()
            local aw, ah = SX( avatarMat:Width() ), SY( avatarMat:Height() )

            surface.SetMaterial( avatarMat )
            surface.SetDrawColor( 255, 255, 255 )
            surface.DrawTexturedRect( ( w - aw ) / 2, ( h - ah ) / 2, aw, ah )

            render.ClearStencil()
            render.SetStencilEnable( true )
            render.SetStencilWriteMask( 1 )
            render.SetStencilTestMask( 1 )
            render.SetStencilFailOperation( STENCILOPERATION_REPLACE )
            render.SetStencilPassOperation( STENCILOPERATION_ZERO )
            render.SetStencilZFailOperation( STENCILOPERATION_ZERO )
            render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_NEVER )
            render.SetStencilReferenceValue( 1 )
                draw.NoTexture()
                -- draw.RoundedBox( 64, 0, 0, w, h, Color( 255, 255, 255, 255 ) )
                drawRoundedRectangle( 0, 0, SX( 198 ), SY( 198 ), 6, Color( 255, 255, 255 ), Color( 255, 255, 255 ), 0, 0.25, nil )
            render.SetStencilFailOperation( STENCILOPERATION_ZERO )
            render.SetStencilPassOperation( STENCILOPERATION_REPLACE )
            render.SetStencilZFailOperation( STENCILOPERATION_ZERO )
            render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_EQUAL )
            render.SetStencilReferenceValue( 1 )
                avatar:PaintManual()
            render.SetStencilEnable( false )
            render.ClearStencil()
        end )
    end

    if ( banned ) then
        local bannedPnl = vgui.Create( "DPanel", scrollPanel )
        bannedPnl:SetPos( SX( 232 ), SY( 317 ) )
        bannedPnl:SetSize( SX( 115 ), SY( 36 ) )
        -- bannedPnl:SetVisible( false )
        bannedPnl.Paint = function( self, w, h )
            INTERFACE_SMOOTHING( 1920, 1080, function()
                surface.SetMaterial( bannedMat )
                surface.SetDrawColor( 255, 255, 255 )
                surface.DrawTexturedRect( 0, 0, w, h )
            end )
        end
    end

    if ( steamid == LocalPlayer():SteamID() ) then
        local avatar = vgui.Create( "AvatarImage", scrollPanel )
        avatar:SetPos( SX( 649 ), SY( 600 ) + SY( 428 ) )
        avatar:SetSize( SX( 92 ), SY( 92 ) )
        avatar:SetSteamID( util.SteamIDTo64( steamid ), 84 )
        avatar:SetPaintedManually( true )

        local avatarHndl = vgui.Create( "AvatarImage", scrollPanel )
        avatarHndl:SetPos( SX( 649 ), SY( 600 ) + SY( 428 ) )
        avatarHndl:SetSize( SX( 92 ), SY( 92 ) )
        avatarHndl.Paint = function( self, w, h )
            render.ClearStencil()
            render.SetStencilEnable( true )
            render.SetStencilWriteMask( 1 )
            render.SetStencilTestMask( 1 )
            render.SetStencilFailOperation( STENCILOPERATION_REPLACE )
            render.SetStencilPassOperation( STENCILOPERATION_ZERO )
            render.SetStencilZFailOperation( STENCILOPERATION_ZERO )
            render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_NEVER )
            render.SetStencilReferenceValue( 1 )
                draw.NoTexture()
                -- draw.RoundedBox( 64, 0, 0, w, h, Color( 255, 255, 255, 255 ) )
                drawRoundedRectangle( 0, 0, w, h, 6, Color( 255, 255, 255 ), Color( 255, 255, 255 ), 0, 0.25, nil )
            render.SetStencilFailOperation( STENCILOPERATION_ZERO )
            render.SetStencilPassOperation( STENCILOPERATION_REPLACE )
            render.SetStencilZFailOperation( STENCILOPERATION_ZERO )
            render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_EQUAL )
            render.SetStencilReferenceValue( 1 )
                avatar:PaintManual()
            render.SetStencilEnable( false )
            render.ClearStencil()
        end

        local entryPnl = vgui.Create( "DTextEntry", scrollPanel )
        entryPnl:SetPos( SX( 781 ), SY( 1036 ) )
        entryPnl:SetSize( SX( 485 ), SY( 76 ) )
        entryPnl:SetText( "" )
        entryPnl:SetMultiline( false )
        entryPnl:SetDrawLanguageID( false )
        entryPnl:SetFont( "AT_Profile_WallEntry" )
        entryPnl.Paint = function( self, w, h )
            self:DrawTextEntryText( Color( 255, 255, 255 ), Color( 0, 0, 0 ), Color( 255, 255, 255 ) )
        end
        entryPnl.OnChange = function()
            surface.PlaySound( "repix/animetown/chatting/click-short.wav" )
        end
        scrollPanel.EntryPanel = entryPnl

        local wLayoutPnl = vgui.Create( "DIconLayout", scrollPanel )
        wLayoutPnl:SetPos( SX( 670 ), SY( 1130 + 33 + 32 ) )
        wLayoutPnl:SetSize( SX( 603 ), SY( 128 ) )
        wLayoutPnl:SetSpaceX( 0 )
        wLayoutPnl:SetSpaceY( SY( 16 ) )

        for i, msg in pairs( messages or {} ) do
            local text = msg.Text
            local date = tonumber( msg.Date ) or 0

            infoPnl:SetSize( scrollPanel:GetWide(), SY( 950 ) + ( table.Count( messages ) * SY( 128 ) ) )

            local text = markup.Parse( "<font=AT_Profile_WallEntry>" .. text .. "</font>", SX( 603 ) - ( SX( 62 * 2 ) ) )

            local newMsgPnl = vgui.Create( "DPanel", wLayoutPnl )
            newMsgPnl:SetSize( SX( 603 ), text:GetHeight() + SY( 42 ) )
            newMsgPnl.Paint = function( self, w, h )
                draw.RoundedBox( 8, 0, 0, w, h, Color( 85, 75, 105 ) )
                if ( self:IsHovered() && steamid == LocalPlayer():SteamID() ) then
                    draw.RoundedBox( 8, 0, 0, w, h, Color( 255, 0, 0, 50 ) )
                end

                draw.SimpleText( "Опубликовано: " .. os.date( "%d.%m.%Y %H:%M:%S", date ), "AT_Profile_WallDate", w - SX( 8 ), SY( 8 ), Color( 255, 255, 255, 100 ), 2 )

                text:Draw( SX( 62 ), SY( 21 ) )
            end
            newMsgPnl.OnMousePressed = function( self )
                messages[ i ] = nil
                -- infoPnl:SetSize( scrollPanel:GetWide(), 950 + ( table.Count( messages ) * 64 ) )
                self:Remove()
                self = nil
                wLayoutPnl:Layout()

                net.Start( "repix_AnimeTown_RemoveWallComment" )
                    net.WriteInt( i, 16 )
                net.SendToServer()
            end

            wLayoutPnl:SetSize( SX( 603 ), wLayoutPnl:GetTall() + text:GetHeight() + SY( 42 ) + SY( 16 ) )
        end

        local sendBtn = vgui.Create( "DButton", scrollPanel )
        sendBtn:SetPos( SX( 1146 ), SY( 1130 ) )
        sendBtn:SetSize( SX( 131 ), SY( 33 ) )
        sendBtn:SetText( "" )
        sendBtn.Paint = function() end
        sendBtn.DoClick = function()
            local text = entryPnl:GetValue()
            if ( utf8.len( text ) > 256 ) then
                text = utf8.sub( text, 1, 256 ) .. "..."
            end
            local date = os.time()
            local index = table.insert( messages, { Text = entryPnl:GetValue(), Date = date } )

            infoPnl:SetSize( scrollPanel:GetWide(), SY( 950 ) + ( table.Count( messages ) * SY( 128 ) ) )

            local text = markup.Parse( "<font=AT_Profile_WallEntry>" .. text .. "</font>", SX( 603 ) - ( SX( 62 * 2 ) ) )

            local newMsgPnl = vgui.Create( "DPanel", wLayoutPnl )
            newMsgPnl:SetSize( SX( 603 ), text:GetHeight() + SY( 42 ) )
            newMsgPnl.Paint = function( self, w, h )
                draw.RoundedBox( 8, 0, 0, w, h, Color( 85, 75, 105 ) )
                if ( self:IsHovered() && steamid == LocalPlayer():SteamID() ) then
                    draw.RoundedBox( 8, 0, 0, w, h, Color( 255, 0, 0, 50 ) )
                end

                draw.SimpleText( "Опубликовано: " .. os.date( "%d.%m.%Y %H:%M:%S", date ), "AT_Profile_WallDate", w - SX( 8 ), SY( 8 ), Color( 255, 255, 255, 100 ), 2 )

                text:Draw( SX( 62 ), SY( 21 ) )
            end
            newMsgPnl.OnMousePressed = function( self )
                messages[ index ] = nil
                -- infoPnl:SetSize( scrollPanel:GetWide(), 950 + ( table.Count( messages ) * 64 ) )
                self:Remove()
                self = nil
                wLayoutPnl:Layout()

                net.Start( "repix_AnimeTown_RemoveWallComment" )
                    net.WriteInt( index, 16 )
                net.SendToServer()
            end

            net.Start( "repix_AnimeTown_AddWallComment" )
                net.WriteString( entryPnl:GetValue() )
            net.SendToServer()

            entryPnl:SetValue( "" )

            wLayoutPnl:SetSize( SX( 603 ), wLayoutPnl:GetTall() + text:GetHeight() + SY( 42 ) + SY( 16 ) )
        end

        entryPnl.OnEnter = sendBtn.DoClick
    end
end
-- OpenProfile( LocalPlayer():SteamID(), "Reimi Akatsuki", "ru", true, false, 1, "оясуми", 1609113600, 59, 1300, {}, {} )

net.Receive( "repix_AnimeTown_OpenProfile", function()
    local steamId = net.ReadString()
    local name = net.ReadString()
    local country = net.ReadString()
    local premium = net.ReadInt( 4 )
    local banned = net.ReadInt( 4 )
    local bg = net.ReadInt( 8 )
    local status = net.ReadString()
    local lastOnline = net.ReadString()
    local lvl = net.ReadInt( 32 )
    local xp = net.ReadInt( 32 )
    local achi = net.ReadString()
    local wall = net.ReadString()

    OpenProfile( steamId, name, country, tobool( premium ), tobool( banned ), bg, status, tonumber( lastOnline ), lvl, xp, achi, wall )
end )