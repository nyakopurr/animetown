local closeMat = Material( "repix/animetown/jobrule/icon_close.png" )
local titleMat = Material( "repix/animetown/jobrule/police_title.png" )
local rulesMat = Material( "repix/animetown/jobrule/police_rules.png" )

module( "police", package.seeall )

SeenIt = SeenIt or false

function OpenRules()
    if ( SeenIt ) then return end

    surface.PlaySound( "repix/animetown/clicks/Click_Soft_00.mp3" )

    SeenIt = true

    local frame = vgui.Create( "EditablePanel" )
    frame:SetSize( SX( 756 ), SY( 1000 ) )
    frame:Center()
    frame:MakePopup()
    frame:SetAlpha( 0 )
    frame:AlphaTo( 255, 0.15 )
    frame.Paint = function( self, w, h )
        INTERFACE_SMOOTHING( 1920, 1080, function()
            surface.SetDrawColor( 22, 22, 35 )
            surface.DrawRect( 0, 0, w, h )

            surface.SetMaterial( titleMat )
            surface.SetDrawColor( 255, 255, 255 )
            surface.DrawTexturedRect( SX( 64 ), SY( 54 ), SX( titleMat:Width() ), SY( titleMat:Height() ) )
        end )
    end

    local scrollPnl = vgui.Create( "DScrollPanel", frame )
    scrollPnl:Dock( FILL )
    scrollPnl:GetVBar():SetSize( SX( 6 ), scrollPnl:GetVBar():GetTall() )
    scrollPnl:GetVBar().Paint = function( self, w, h )
        surface.SetDrawColor( 40 + 16, 33 + 16, 53 + 16 )
        surface.DrawRect( 0, 0, w, h )
    end
    scrollPnl:GetVBar().btnUp.Paint = function() end
    scrollPnl:GetVBar().btnDown.Paint = function() end
    scrollPnl:GetVBar().btnGrip.Paint = function( self, w, h )
        if ( self:IsHovered() ) then
            draw.RoundedBox( 6, 0, 0, w, h, Color( 248, 7, 89 ) )
            return
        end

        draw.RoundedBox( 6, 0, 0, w, h, Color( 217, 89, 120 ) )
    end

    local closeBtn = vgui.Create( "DButton", frame )
    closeBtn:SetPos( frame:GetWide() - SX( 24 ) - SX( 41 ), SY( 54 ) )
    closeBtn:SetSize( SX( 24 ), SY( 24 ) )
    closeBtn:SetText( "" )
    closeBtn.Paint = function( self, w, h )
        INTERFACE_SMOOTHING( 1920, 1080, function()
            surface.SetMaterial( closeMat )
            surface.SetDrawColor( 255, 255, 255 )
            surface.DrawTexturedRect( 0, 0, w, h )
        end )
    end
    closeBtn.DoClick = function()
        if ( ValidPanel( frame ) ) then
            frame:Remove()
            frame = nil
        end
    end

    local rulesPnl = vgui.Create( "DPanel", scrollPnl )
    rulesPnl:SetPos( SX( 40 ), SY( 114 ) )
    rulesPnl:SetSize( SX( 677 ), SY( 915 ) )
    rulesPnl.Paint = function( self, w, h )
        INTERFACE_SMOOTHING( 1920, 1080, function()
            surface.SetMaterial( rulesMat )
            surface.SetDrawColor( 255, 255, 255 )
            surface.DrawTexturedRect( 0, 0, w, h )
        end )
    end
end

surface.CreateFont( "AT_Arrested", { font = "Roboto", size = 18, extended = true } )
hook.Add( "HUDPaint", "repix_AnimeTown_Arrest", function()
    local arrested = LocalPlayer():GetNWBool( "repix_AnimeTown_Arrested", false )
    if ( arrested ) then
        local outIn = LocalPlayer():GetNWFloat( "repix_AnimeTown_ArrestTime", 0.0 ) - ( UnPredictedCurTime() - LocalPlayer():GetNWFloat( "repix_AnimeTown_TimeArrested", 0.0 ) )
        if ( outIn > 0 ) then
            draw.SimpleText( "Вы арестованы. До выхода из тюрьмы осталось: " .. string.ToMinutesSeconds( outIn ), "AT_Arrested", ScrW() / 2 + 1, ScrH() - 64 + 1, Color( 0, 0, 0 ), 1, TEXT_ALIGN_BOTTOM )
            draw.SimpleText( "Вы арестованы. До выхода из тюрьмы осталось: " .. string.ToMinutesSeconds( outIn ), "AT_Arrested", ScrW() / 2, ScrH() - 64, Color( 250, 250, 250 ), 1, TEXT_ALIGN_BOTTOM )
        end
    end
end )