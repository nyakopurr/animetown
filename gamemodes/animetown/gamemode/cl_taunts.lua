local baseMat = Material( "repix/animetown/taunts/base.png" )

surface.CreateFont( "AT_Taunts_Delay", { font = "Rubik Medium", size = 15, weight = 500, extended = true } )

module( "taunts", package.seeall )

NextTaunt = NextTaunt or 0

function Open()
    local frame = vgui.Create( "EditablePanel" )
    frame:SetSize( 410, 437 )
    frame:Center()
    frame:MakePopup()
    frame.Paint = function( self, w, h )
        surface.SetMaterial( baseMat )
        surface.SetDrawColor( 255, 255, 255 )
        surface.DrawTexturedRect( 0, 0, w, h )

        local text = "Готово к использованию"
        if ( NextTaunt > CurTime() ) then
            local time = NextTaunt - CurTime()
            time = string.ToMinutesSeconds( time )
            text = "Можно проиграть снова через: " .. time
        end
        draw.SimpleText( text, "AT_Taunts_Delay", w / 2, h - 24, Color( 255, 255, 255 ), 1, 4 )
    end

    local closeBtn = vgui.Create( "DButton", frame )
    closeBtn:SetPos( frame:GetWide() - 24 - 36, 31 )
    closeBtn:SetSize( 24, 24 )
    closeBtn:SetText( "" )
    closeBtn.Paint = function() end
    closeBtn.DoClick = function()
        if ( ValidPanel( frame ) ) then
            frame:Remove()
            frame = nil
        end
    end

    local x, y = 26, 82
    for i = 1, 8 do
        local tauntBtn = vgui.Create( "DButton", frame )
        tauntBtn:SetPos( x, y )
        tauntBtn:SetSize( 172, 65 )
        tauntBtn:SetText( "" )
        tauntBtn.Paint = function() end
        tauntBtn.DoClick = function()
            if ( ValidPanel( frame ) ) then
                frame:Remove()
                frame = nil
            end

            net.Start( "repix_AnimeTown_PlayTaunt" )
                net.WriteInt( i, 8 )
            net.SendToServer()

            NextTaunt = CurTime() + 120.0
        end

        if ( i % 2 == 0 ) then
            x = 26
            y = y + 65 + 14
        else
            x = x + 172 + 14
        end
    end
end