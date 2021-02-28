local flux = include( "includes/flux.lua" )

surface.CreateFont( "AT_PhoneName", { font = "Rubik", size = 17, weight = 500, extended = true } )

local baseMat = Material( "repix/animetown/phone/base.png" )
local playerMat = Material( "repix/animetown/phone/player_field.png" )

local phoneAnim = { OffsetY = 0 }

function PhoneOn( bool )
    if ( bool ) then
        if ( !ValidPanel( AT_PhoneGUI ) ) then
            Initialize()
        else
            AT_PhoneGUI:SetVisible( true )
        end

        phoneAnim = { OffsetY = 0, alpha = 0 }
        flux.to( phoneAnim, 0.5, { OffsetY = -baseMat:Height() } )
        :after( phoneAnim, 0.25, { alpha = 255 } )
    else
        flux.to( phoneAnim, 0.25, { alpha = 0 } )
        :after( phoneAnim, 0.5, { OffsetY = 0 } )
        :oncomplete( function()
            if ( ValidPanel( AT_PhoneGUI ) ) then
                AT_PhoneGUI:SetVisible( false )
            end
        end )
    end
end

function Initialize()
    if ( ValidPanel( AT_PhoneGUI ) ) then
        AT_PhoneGUI:Remove()
        AT_PhoneGUI = nil
    end

    AT_PhoneGUI = vgui.Create( "EditablePanel" )
    AT_PhoneGUI:SetSize( ScrW(), ScrH() )
    AT_PhoneGUI:SetVisible( false )
    AT_PhoneGUI.CurrentPlayer = 1
    AT_PhoneGUI.PlayerEntity = nil
    AT_PhoneGUI.Paint = function( self, w, h )
        surface.SetDrawColor( 255, 255, 255 )
        surface.SetMaterial( baseMat )
        surface.DrawTexturedRect( 1641, h + phoneAnim.OffsetY, baseMat:Width(), baseMat:Height() )

        flux.update( RealFrameTime() )
    end

    local scroll = vgui.Create( "DScrollPanel", AT_PhoneGUI )
    scroll:SetPos( 1641 + 8, AT_PhoneGUI:GetTall() - baseMat:Height() + 27 )
    scroll:SetSize( 177, 266 )
    scroll.Paint = function() end
    scroll:GetVBar():SetSize( 0, scroll:GetVBar():GetTall() )
    scroll:GetVBar().Paint = function() end

    AT_PhoneGUI.Scroll = scroll

    -- function AT_PhoneGUI:OnKeyCodePressed( key )
    --     if ( key == KEY_UP ) then
    --         scroll:GetVBar():AddScroll( -15 )
    --     elseif ( key == KEY_DOWN ) then
    --         scroll:GetVBar():AddScroll( 15 )
    --     end
    -- end

    local y = 6
    for key, ply in pairs( player.GetAll() ) do
        local field = vgui.Create( "DPanel", scroll )
        field:SetPos( ( 177 - 176 ) / 2, y )
        field:SetSize( 176, 43 )
        field.Paint = function( self, w, h )
            surface.SetDrawColor( 255, 255, 255, phoneAnim.alpha )
            surface.SetMaterial( playerMat )
            surface.DrawTexturedRect( 0, 0, w, h )

            local clr = AT_PhoneGUI.CurrentPlayer == key and Color( 75, 73, 155 ) or Color( 75, 73, 73 )
            local name = string.format( "%s %s %s", "", ply:GetName(), "" )
            if ( AT_PhoneGUI.CurrentPlayer == key ) then
                name = string.format( "%s %s %s", "> ", ply:GetName(), " <" )
                AT_PhoneGUI.PlayerEntity = ply
            end
            draw.SimpleText( name, "AT_PhoneName", w / 2, h / 2, ColorAlpha( clr, phoneAnim.alpha ), 1, 1 )
        end

        y = y + 43 - 6
    end
end
Initialize()

hook.Add( "PlayerButtonDown", "repix_AnimeTown_TestPhone", function( ply, btn )
    if ( !ValidPanel( AT_PhoneGUI ) ) then return end

    if ( btn == KEY_UP ) then
        AT_PhoneGUI.CurrentPlayer = math.Clamp( AT_PhoneGUI.CurrentPlayer - 1, 1, #player.GetAll() )
        AT_PhoneGUI.Scroll:GetVBar():AddScroll( -1 )
        -- if ( AT_PhoneGUI.CurrentPlayer % 7 == 0 ) then
        --     AT_PhoneGUI.Scroll:GetVBar():AddScroll( -7 )
        -- end
    elseif ( btn == KEY_DOWN ) then
        AT_PhoneGUI.CurrentPlayer = math.Clamp( AT_PhoneGUI.CurrentPlayer + 1, 1, #player.GetAll() )
        AT_PhoneGUI.Scroll:GetVBar():AddScroll( 1 )
        -- if ( AT_PhoneGUI.CurrentPlayer % 7 == 0 ) then
        --     AT_PhoneGUI.Scroll:GetVBar():AddScroll( 7 )
        -- end
    elseif ( btn == KEY_ENTER ) then
        net.Start( "repix_AnimeTown_PhoneCall" )
            net.WriteEntity( AT_PhoneGUI.CurrentPlayer )
        net.SendToServer()
    end
end )
