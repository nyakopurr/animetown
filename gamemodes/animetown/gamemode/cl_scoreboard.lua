surface.CreateFont( "AT_Scoreboard_PlayerName", { font = "Rubik", size = 13, weight = 500, extended = true } )
surface.CreateFont( "AT_Scoreboard_PlayerTeam", { font = "Rubik", size = 10, weight = 500, extended = true } )
surface.CreateFont( "AT_Scoreboard_PlayerPing", { font = "Rubik", size = 11, weight = 500, extended = true } )
surface.CreateFont( "AT_Scoreboard_TotalPlayers", { font = "Rubik", size = 13, weight = 500, extended = true } )

module( "scoreboard", package.seeall )

local baseMat = Material( "repix/animetown/scoreboard/base.png" )
local afkMat = Material( "repix/animetown/scoreboard/afk.png" )
local adminMat = Material( "repix/animetown/scoreboard/admin_shield.png" )

function Initialize( hide )
    if ( ValidPanel( AT_Scoreboard ) ) then
        AT_Scoreboard:Remove()
        AT_Scoreboard = nil
    end

    AT_Scoreboard = vgui.Create( "EditablePanel" )
    AT_Scoreboard:SetSize( 957, 612 )
    AT_Scoreboard:Center()
    AT_Scoreboard:SetVisible( hide )
    AT_Scoreboard.Paint = function( self, w, h )
        surface.SetDrawColor( 255, 255, 255 )
        surface.SetMaterial( baseMat )
        surface.DrawTexturedRect( 0, 0, w, h )

        draw.SimpleText( "Онлайн: " .. table.Count( player.GetAll() ), "AT_Scoreboard_TotalPlayers", w - 28, 22, Color( 255, 255, 255 ), 2 )
    end

    local scroller = vgui.Create( "DScrollPanel", AT_Scoreboard )
    scroller:SetPos( 2, 54 )
    scroller:SetSize( AT_Scoreboard:GetWide() - 4, AT_Scoreboard:GetTall() - 54 - 2 )
    scroller.Players = {}
    scroller.NextUpdate = 0
    scroller:GetVBar().Paint = function() end
    scroller:GetVBar().btnUp.Paint = function() end
    scroller:GetVBar().btnDown.Paint = function() end
    scroller:GetVBar().btnGrip.Paint = function( panel, w, h )
        if ( panel.Depressed ) then
            draw.RoundedBox( 4, 2, 1, 6, h - 2, Color( 255, 255, 255, 75 ) )
            return
        end

        if ( panel:IsHovered() ) then
            draw.RoundedBox( 4, 2, 1, 6, h - 2, Color( 255, 255, 255, 50 ) )
            return
        end

        draw.RoundedBox( 4, 2, 1, 6, h - 2, Color( 255, 255, 255, 25 ) )
    end
    scroller.Think = function( self )
        if ( RealTime() > self.NextUpdate ) then
            for ply in pairs( self.Players or {} ) do
                if ( !IsValid( ply ) ) then
                    self:RemovePlayer( ply )
                end
            end

            for c, ply in pairs( player.GetAll() ) do
                if ( self.Players[ ply ] == nil ) then
                    self:AddPlayer( ply, c )
                end
            end

            self:InvalidateLayout()

            self.NextUpdate = RealTime() + 3
        end
    end
    scroller.AddPlayer = function( self, ply, id )
        local clr = Color( 38, 42, 52, 0.45 * 255 )
        local panel = vgui.Create( "DPanel", scroller )
        -- panel:SetPos( 24, y )
        panel:Dock( TOP )
        panel:DockMargin( 0, 0, 0, 0 )
        panel:SetParent( self )
        panel.id = id
        panel:SetVisible( true )
        panel:SetSize( 953, 49 )
        panel.Paint = function( self, w, h )
            surface.SetDrawColor( panel.id % 2 == 0 and Color( 0, 0, 0, 0 ) or clr )
            surface.DrawRect( 2, 0, w, h )

            surface.SetDrawColor( 51, 51, 51 )
            surface.DrawRect( 13, ( h - 33 ) / 2, 33, 33 )

            local name = ply:Nick()
            if ( ply.RPNick && ply:RPNick() ~= "-jiz-time-for-cheese-" ) then
                name = ply:RPNick()
            end

            draw.SimpleText( name, "AT_Scoreboard_PlayerName", 55, 12, Color( 255, 255, 255 ) )
            draw.SimpleText( ply.GetJob and ply:GetJob().Name or team.GetName( ply:Team() ), "AT_Scoreboard_PlayerTeam", 55, 12 + 15, Color( 255, 255, 255 ) )
            draw.SimpleText( ( ply:IsBot() and "BOT" or ( ply:Ping() .. "ms" ) ), "AT_Scoreboard_PlayerPing", 904, h / 2, Color( 255, 255, 255 ), nil, 1 )

            if ( ply:GetNWBool( "AT_AFK", false ) && !afkMat:IsError() ) then
                surface.SetDrawColor( 255, 255, 255 )
                surface.SetMaterial( afkMat )
                surface.DrawTexturedRect( 845, ( h - afkMat:Height() ) / 2, afkMat:Width(), afkMat:Height() )
            end

            if ( ply:IsAdmin() && !adminMat:IsError() ) then
                surface.SetFont( "AT_Scoreboard_PlayerName" )
                surface.SetDrawColor( 255, 255, 255 )
                surface.SetMaterial( adminMat )
                surface.DrawTexturedRect( 55 + surface.GetTextSize( name ) + 2, 12, adminMat:Width(), adminMat:Height() )
            end
        end
        panel.OnMousePressed = function( self )
        end

        local pp = vgui.Create( "AvatarImage", panel )
        pp:SetPos( 13, ( 49 - 33 ) / 2 )
        pp:SetSize( 33, 33 )
        pp:SetCursor( "hand" )
        pp:SetPlayer( ply, 64 )
        pp.PaintOver = function( self, w, h )
            surface.SetDrawColor( 48, 48, 48 )
            surface.DrawOutlinedRect( 0, 0, w, h )

            if ( self:IsHovered() ) then
                surface.SetDrawColor( 0, 0, 0, 150 )
                surface.DrawRect( 0, 0, w, h )
            end
        end
        pp.OnMousePressed = function()
            if ( ply.ShowProfile ) then ply:ShowProfile() end
        end

        self.Players[ ply ] = panel
        self:AddItem( panel )
    end
    scroller.RemovePlayer = function( self, ply )
        if ( ValidPanel( self.Players[ ply ] ) ) then
            self.Players[ ply ]:Remove()
            self.Players[ ply ] = nil
        end
    end
end

function GM:ScoreboardShow()
    if ( !ValidPanel( AT_Scoreboard ) ) then
        Initialize( true )
    else
        AT_Scoreboard:SetVisible( true )
    end

    RestoreCursorPosition()
    gui.EnableScreenClicker( true )
end

function GM:ScoreboardHide()
    if ( !ValidPanel( AT_Scoreboard ) ) then
        Initialize( false )
    else
        AT_Scoreboard:SetVisible( false )
    end

    RememberCursorPosition()
    gui.EnableScreenClicker( false )
end