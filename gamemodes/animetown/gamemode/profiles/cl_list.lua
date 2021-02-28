local fzy = include( "includes/fzy.lua" )

local baseMat = Material( "repix/animetown/profile/list/base.png" )
local pingMat = Material( "repix/animetown/profile/list/icon_ping.png" )
local onlineMat = Material( "repix/animetown/profile/list/online.png" )
local offlineMat = Material( "repix/animetown/profile/list/offline.png" )
local countryMat = Material( "repix/animetown/profile/3d/countries/ru.png" )
local premiumMat = Material( "repix/animetown/profile/3d/pin_premium.png" )

local function CreateShadowFont( name, font, size, weight, extended )
    surface.CreateFont( name, { font = font, size = size, weight = weight, extended = extended } )
    surface.CreateFont( name .. "_Shadow", { font = font, size = size, blursize = 2, weight = weight, extended = extended } )
end
CreateShadowFont( "AT_ProfileList_Username", "Rubik Medium", ScreenScale( 21 ) / 3, 500, true )
CreateShadowFont( "AT_ProfileList_Ping", "Rubik Medium", ScreenScale( 14 ) / 3, 500, true )

surface.CreateFont( "AT_ProfileList_Search", { font = "Rubik Medium", size = ScreenScale( 16 ) / 3, weight = 500, extended = true } )

local function findMatch( str, tbl )
    local matches = {}
    for i = 1, table.Count( tbl ) do
        local name = tbl[ i ].Name
        if ( fzy.has_match( str, name, false ) ) then
            table.insert( matches, tbl[ i ].SteamID )
        end
    end

    return matches
end

function Open( tbl )
    local frame = vgui.Create( "EditablePanel" )
    frame:SetSize( ScrW(), ScrH() )
    frame:MakePopup()
    frame:SetAlpha( 0 )
    frame:AlphaTo( 255, 0.15 )
    frame.Paint = function( self, w, h )
        INTERFACE_SMOOTHING( 1920, 1080, function()
            surface.SetMaterial( baseMat )
            surface.SetDrawColor( 255, 255, 255 )
            surface.DrawTexturedRect( 0, 0, w, h )
        end )
    end

    local closeBtn = vgui.Create( "DButton", frame )
    closeBtn:SetPos( frame:GetWide() - SX( 36 ) - SX( 35 ), SY( 19 ) )
    closeBtn:SetSize( SX( 36 ), SY( 36 ) )
    closeBtn:SetText( "" )
    closeBtn.Paint = function() end
    closeBtn.DoClick = function()
        if ( ValidPanel( frame ) ) then
            frame:Remove()
            frame = nil
        end
    end

    local scrollPanel = vgui.Create( "DScrollPanel", frame )
    scrollPanel:SetPos( SX( 158 ), SY( 123 ) )
    scrollPanel:SetSize( frame:GetWide() - SX( 158 ), frame:GetTall() - SY( 123 ) )
    scrollPanel.PanelList = {}
    scrollPanel:GetVBar():SetSize( SX( 6 ), scrollPanel:GetVBar():GetTall() )
    scrollPanel:GetVBar().Paint = function( self, w, h )
    end
    scrollPanel:GetVBar().btnUp.Paint = function() end
    scrollPanel:GetVBar().btnDown.Paint = function() end
    scrollPanel:GetVBar().btnGrip.Paint = function( self, w, h )
        if ( self:IsHovered() ) then
            draw.RoundedBox( 6, 0, 0, w, h, Color( 135, 135, 135 ) )
            return
        end

        draw.RoundedBox( 6, 0, 0, w, h, Color( 125, 125, 125 ) )
    end

    local pnlLayout = vgui.Create( "DIconLayout", scrollPanel )
    pnlLayout:Dock( FILL )
    pnlLayout:SetSpaceY( SY( 12 ) )
    pnlLayout:SetSpaceX( SX( 29 ) )
    -- pnlLayout:SetBorder( 32 )

    local nameInput = vgui.Create( "DTextEntry", frame )
    nameInput:SetPos( SX( 46 ) + SX( 17 ) + SX( 8 ), SY( 22 ) )
    nameInput:SetSize( SX( 295 ) - SX( 17 ) - SX( 8 ), SY( 29 ) )
    nameInput:SetText( "" )
    nameInput:SetDrawLanguageID( false )
    nameInput:SetFont( "AT_ProfileList_Search" )
    nameInput.Paint = function( self, w, h )
        self:DrawTextEntryText( Color( 255, 255, 255 ), Color( 0, 0, 0 ), Color( 255, 255, 255 ) )
    end
    nameInput.OnChange = function( self )
        surface.PlaySound( "repix/animetown/chatting/click-short.wav" )

        local match = findMatch( self:GetValue(), tbl )
        local list = scrollPanel.PanelList
        for i = 1, table.Count( list ) do
            if ( !table.HasValue( match, list[ i ].SteamID ) ) then
                scrollPanel.PanelList[ i ].Panel:SetVisible( false )
            else
                scrollPanel.PanelList[ i ].Panel:SetVisible( true )
            end
        end

        pnlLayout:Layout()
    end

    -- local x, y = 158, 0
    local sortedTbl = tbl
    table.sort( sortedTbl, function( a, b )
        local ply1 = player.GetBySteamID( a.SteamID )
        local ply2 = player.GetBySteamID( b.SteamID )
        if ( IsValid( ply1 ) && !IsValid( ply2 ) ) then return a end
    end )
    for i = 1, table.Count( tbl ) do
        local bgPnl = vgui.Create( "DPanel", pnlLayout )
        -- bgPnl:SetPos( x, y )
        bgPnl:SetSize( SX( 382 ), SY( 108 ) )
        bgPnl:SetCursor( "hand" )

        local avatar = vgui.Create( "AvatarImage", bgPnl )
        avatar:SetPos( SX( 27 ), SY( 16 ) )
        avatar:SetSize( SX( 54 ), SY( 54 ) )
        avatar:SetSteamID( util.SteamIDTo64( tbl[ i ].SteamID ), 64 )
        avatar:SetPaintedManually( true )
        avatar:SetCursor( "hand" )

        bgPnl.Paint = function( self, w, h )
            INTERFACE_SMOOTHING( 1920, 1080, function()
                local ply = player.GetBySteamID( tbl[ i ].SteamID )
                local bg = tonumber( tbl[ i ].Background )
                if ( IsValid( ply ) ) then
                    bg = ply:GetNWInt( "repix_AnimeTown_Profile.Background", 1 )
                    bg = tonumber( bg )
                end
                surface.SetMaterial( profile.ListBadges[ bg ] )
                surface.SetDrawColor( 255, 255, 255 )
                surface.DrawTexturedRect( 0, 0, w, h )

                local name = tbl[ i ].Name
                draw.SimpleText( name, "AT_ProfileList_Username_Shadow", SX( 92 ), SY( 25 ), Color( 0, 0, 0, 255 - ( 255 * 0.25 ) ) )
                draw.SimpleText( name, "AT_ProfileList_Username", SX( 92 ), SY( 23 ), Color( 255, 255, 255 ) )

                surface.SetFont( "AT_ProfileList_Username" )

                local flagMat = profile and profile.BadgeFlagMaterials[ string.lower( tbl[ i ].Country ) ] or countryMat
                surface.SetMaterial( flagMat )
                surface.SetDrawColor( 255, 255, 255 )
                surface.DrawTexturedRect( SX( 92 ) + surface.GetTextSize( name ) + SX( 6 ), SY( 22 ), SX( countryMat:Width() ), SY( countryMat:Height() ) )

                if ( IsValid( ply ) ) then -- online
                    surface.SetMaterial( pingMat )
                    surface.SetDrawColor( 255, 255, 255 )
                    surface.DrawTexturedRect( SX( 92 ), SY( 49 ), SX( pingMat:Width() ), SY( pingMat:Height() ) )

                    local ping = "0ms"
                    if ( !ply:IsBot() ) then ping = ply:Ping() .. "ms" end

                    draw.SimpleText( ping, "AT_ProfileList_Ping_Shadow", SX( 108 ), SY( 48 ), Color( 0, 0, 0, 255 - ( 255 * 0.25 ) ) )
                    draw.SimpleText( ping, "AT_ProfileList_Ping", SX( 108 ), SY( 46 ), Color( 255, 255, 255 ) )
                else -- offline
                    local lastOnline = tonumber( tbl[ i ].LastOnline )
                    local lOnline = ""
                    if ( isnumber( lastOnline ) ) then lOnline = "последний онлайн: " .. os.date( "%d.%m.%Y %H:%M", lastOnline ) end
                    draw.SimpleText( lOnline, "AT_ProfileList_Ping_Shadow", SX( 92 ), SY( 48 ), Color( 0, 0, 0, 255 - ( 255 * 0.25 ) ) )
                    draw.SimpleText( lOnline, "AT_ProfileList_Ping", SX( 92 ), SY( 46 ), Color( 255, 255, 255 ) )
                end

                if ( IsValid( ply ) ) then
                    surface.SetMaterial( onlineMat )
                    surface.SetDrawColor( 255, 255, 255 )
                    surface.DrawTexturedRect( ( w - SX( onlineMat:Width() ) ) / 2, SY( 83 ), SX( onlineMat:Width() ), SY( onlineMat:Height() ) )
                else
                    surface.SetMaterial( offlineMat )
                    surface.SetDrawColor( 255, 255, 255 )
                    surface.DrawTexturedRect( ( w - SX( offlineMat:Width() ) ) / 2, SY( 83 ), SX( offlineMat:Width() ), SY( offlineMat:Height() ) )
                end

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
                    drawRoundedRectangle( SX( 26 ), SY( 15 ), SX( 56 ), SY( 56 ), 6, Color( 255, 255, 255 ), Color( 255, 255, 255 ), 0, 0.25, nil )
                render.SetStencilFailOperation( STENCILOPERATION_ZERO )
                render.SetStencilPassOperation( STENCILOPERATION_REPLACE )
                render.SetStencilZFailOperation( STENCILOPERATION_ZERO )
                render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_EQUAL )
                render.SetStencilReferenceValue( 1 )
                    avatar:PaintManual()
                render.SetStencilEnable( false )
                render.ClearStencil()

                local hasPremium = tobool( tbl[ i ].Premium )
                if ( hasPremium ) then
                    surface.SetMaterial( premiumMat )
                    surface.SetDrawColor( 255, 255, 255 )
                    surface.DrawTexturedRect( SX( 14 ), SY( 53 ), SX( premiumMat:Width() ), SY( premiumMat:Height() ) )
                end
            end )
        end
        bgPnl.OnMousePressed = function()
            -- if ( ValidPanel( frame ) ) then
            --     frame:Remove()
            --     frame = nil
            -- end

            net.Start( "repix_AnimeTown_ShowProfile" )
                net.WriteString( tbl[ i ].SteamID )
            net.SendToServer()
        end
        avatar.OnMousePressed = bgPnl.OnMousePressed

        -- if ( x + 382 > scrollPanel:GetWide() - 158 ) then
        --     x = 158
        --     y = y + 108 + 12
        -- else
        --     x = x + 382 + 29
        -- end

        table.insert( scrollPanel.PanelList, { Panel = bgPnl, SteamID = tbl[ i ].SteamID } )
    end
end

net.Receive( "repix_AnimeTown_ShowProfileList", function()
    local len = net.ReadInt( 32 )
    local tbl = net.ReadData( len )
    tbl = util.Decompress( tbl )
    tbl = util.JSONToTable( tbl )
    Open( tbl )
end )
