include( "sh_doorsystem.lua" )

surface.CreateFont( "AT_DoorOwner", { font = "Roboto", size = 16, extended = true } )
surface.CreateFont( "AT_DoorSystem_Menu", { font = "Roboto", size = 15, extended = true } )

module( "doorsystem", package.seeall )

hook.Add( "HUDPaint", "repix_AnimeTown_Doorsystem", function()
    local ent = LocalPlayer():GetEyeTrace().Entity
    local maxDist = 128^2
    if ( IsValid( ent ) && ( ent:GetClass() == "prop_door_rotating" || ent:GetClass() == "func_door" || ent:GetClass() == "func_door_rotating" ) && ent:GetPos():DistToSqr( LocalPlayer():GetPos() ) < maxDist ) then
        local dist = ent:GetPos():DistToSqr( LocalPlayer():GetPos() )
        local alpha = 255 - ( 255 * ( dist / maxDist ) )
        local own = "нет"
        local property = ent:GetNWString( "repix_AnimeTown_Property", "-" )
        local owner = ent:GetNWString( "repix_AnimeTown_DoorOwner", "-" )
        if ( property ~= "-" ) then
            own = property
        end
        if ( owner ~= "-" ) then
            own = owner
            local ply = player.GetBySteamID( own )
            if ( IsValid( ply ) ) then
                own = ply.RPNick and ply:RPNick() or ply:Nick()
            end
        end
        if ( own ~= "нет" ) then
            draw.SimpleText( "Дверь занята: " .. own, "AT_DoorOwner", ScrW() / 2 + 1, ScrH() / 2 + 1, Color( 0, 0, 0, alpha ), 1, 1 )
            draw.SimpleText( "Дверь занята: " .. own, "AT_DoorOwner", ScrW() / 2, ScrH() / 2, Color( 255, 177, 64, alpha ), 1, 1 )
            if ( LocalPlayer().CanLockUnlockDoor && LocalPlayer():CanLockUnlockDoor( ent ) ) then
                draw.SimpleText( "Нажмите R, чтобы открыть или закрыть её", "AT_DoorOwner", ScrW() / 2 + 1, ScrH() / 2 + 12 + 1, Color( 0, 0, 0, alpha ), 1, nil )
                draw.SimpleText( "Нажмите R, чтобы открыть или закрыть её", "AT_DoorOwner", ScrW() / 2, ScrH() / 2 + 12, Color( 255, 177, 64, alpha ), 1, nil )
            end
        else
            draw.DrawText( "Дверь доступна для покупки\nНажмите F2, чтобы приобрести её", "AT_DoorOwner", ScrW() / 2 + 1, ScrH() / 2 + 1, Color( 0, 0, 0, alpha ), 1, 1 )
            draw.DrawText( "Дверь доступна для покупки\nНажмите F2, чтобы приобрести её", "AT_DoorOwner", ScrW() / 2, ScrH() / 2, Color( 255, 255, 255, alpha ), 1, 1 )
        end
    end
end )

function Open()
    local frame = vgui.Create( "DFrame" )
    frame:SetSize( ScrW(), ScrH() )
    frame:MakePopup()
    frame.Paint = function( self, w, h )
        surface.SetDrawColor( 0, 0, 0, 255 - ( 255 * 0.3 ) )
        surface.DrawRect( 0, 0, w, h )

        -- draw.SimpleText( "Отпустите R, чтобы закрыть это меню", "AT_DoorSystem_Menu", w / 2, h - 480, Color( 255, 255, 255 ), 1, 4 )
    end

    local x = 255
    for i = 1, 2 do
        local btnAct = vgui.Create( "DButton", frame )
        btnAct:SetPos( x, 519 )
        btnAct:SetSize( 196, 42 )
        btnAct:SetText( "" )
        btnAct.Paint = function( self, w, h )
            draw.RoundedBox( 6, 0, 0, w, h, Color( 255, 255, 255, 25 ) )

            draw.SimpleText( i == 1 and "Открыть дверь" or "Закрыть дверь", "AT_DoorSystem_Menu", w / 2, h / 2, Color( 255, 255, 255 ), 1, 1 )
        end
        btnAct.DoClick = function()
            if ( ValidPanel( frame ) ) then
                frame:Remove()
                frame = nil
            end
        end

        x = x + 196 + 15
    end
end
