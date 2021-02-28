local flux = include( "includes/flux.lua" )

local logoMat = Material( "repix/animetown/donate/logo.png" )
local closeMat = Material( "repix/animetown/donate/icon_close.png" )
local posterMat = Material( "repix/animetown/donate/poster.png" )
local timesMat = Material( "repix/animetown/donate/times.png" )
local holdTimeMat = Material( "repix/animetown/donate/times_selected.png" )
local purchaseBtnMat = Material( "repix/animetown/donate/btn_purchase_base.png" )
local purchaseIconMat = Material( "repix/animetown/donate/btn_purchase_icon.png" )
local gettableMat = Material( "repix/animetown/donate/gettable.png" )
local waveMat = Material( "repix/animetown/donate/bottom_wave.png" )
local heartMat = Material( "repix/animetown/donate/icon_heart.png" )

surface.CreateFont( "AT_Donate_Price", { font = "Rubik Medium", size = ScreenScale( 21 ) / 3, weight = 500, extended = true } )
surface.CreateFont( "AT_Donate_Thanks_Big", { font = "Rubik Medium", size = ScreenScale( 43 ) / 3, weight = 500, extended = true } )
surface.CreateFont( "AT_Donate_Thanks_Small", { font = "Rubik Medium", size = ScreenScale( 21 ) / 3, weight = 500, extended = true } )
surface.CreateFont( "AT_Donate_Thanks2_Small", { font = "Rubik", size = ScreenScale( 21 ) / 3, weight = 400, extended = true } )

module( "donate", package.seeall )

local CurrentTime = 1
local Pricing = {
    [1] = 350,
    [2] = 800,
    [3] = 1500,
    [4] = 2800
}

function Open()
    if ( ValidPanel( AT_Donate_VGUI ) ) then
        AT_Donate_VGUI:Remove()
        AT_Donate_VGUI = nil
    end

    local hasPremium = LocalPlayer():GetNWBool( "repix_AnimeTown_Profile.Premium", false )

    AT_Donate_VGUI = vgui.Create( "EditablePanel" )
    AT_Donate_VGUI:SetSize( ScrW(), ScrH() )
    AT_Donate_VGUI:MakePopup()
    AT_Donate_VGUI:SetAlpha( 0 )
    AT_Donate_VGUI:AlphaTo( 255, 0.15 )
    AT_Donate_VGUI.Paint = function()
        -- if ( input.IsKeyDown( KEY_ESCAPE ) ) then
        --     frame:Remove()
        --     frame = nil
        -- end

        if ( flux && flux.update ) then
            flux.update( RealFrameTime() )
        end
    end

    local scrollPanel = vgui.Create( "DScrollPanel", AT_Donate_VGUI )
    scrollPanel:SetPos( 0, 0 )
    scrollPanel:SetSize( AT_Donate_VGUI:GetWide(), AT_Donate_VGUI:GetTall() )
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
    bgPnl:SetSize( scrollPanel:GetWide(), SY( 1991 ) )
    bgPnl.Paint = function( self, w, h )
        INTERFACE_SMOOTHING( 1920, 1080, function()
            surface.SetDrawColor( 23, 24, 25 )
            surface.DrawRect( 0, 0, w, h )

            surface.SetMaterial( logoMat )
            surface.SetDrawColor( 255, 255, 255 )
            surface.DrawTexturedRect( SX( 107 ), SY( 47 ), SX( logoMat:Width() ), SY( logoMat:Height() ) )

            surface.SetMaterial( posterMat )
            surface.SetDrawColor( 255, 255, 255 )
            surface.DrawTexturedRect( 0, SY( 132 ), SX( posterMat:Width() ), SY( posterMat:Height() ) )

            if ( !hasPremium ) then
                surface.SetMaterial( timesMat )
                surface.SetDrawColor( 255, 255, 255 )
                surface.DrawTexturedRect( ( w - SX( timesMat:Width() ) ) / 2, SY( 537 ), SX( timesMat:Width() ), SY( timesMat:Height() ) )

                draw.SimpleText( "К оплате: " .. string.Comma( Pricing[ CurrentTime or 1 ] or 300 ) .. "₽", "AT_Donate_Price", w / 2, SY( 576 + 50 + 67 + 16 ), Color( 255, 255, 255 ), 1 )
            else
                surface.SetMaterial( heartMat )
                surface.SetDrawColor( 255, 255, 255 )
                surface.DrawTexturedRect( SX( 609 ), SY( 476 ), SX( heartMat:Width() ), SY( heartMat:Height() ) )

                draw.SimpleText( "Спасибо!", "AT_Donate_Thanks_Big", SX( 751 ), SY( 489 ), Color( 255, 255, 255 ) )
                draw.SimpleText( "Вы оказали нереальную поддержку. Это очень важно для нас.", "AT_Donate_Thanks_Small", SX( 751 ), SY( 540 ), Color( 255, 255, 255 ) )

                local lastTill = LocalPlayer():GetNWInt( "repix_AnimeTown_Profile.PremiumDies", 0 )
                draw.SimpleText( "Ваш Премиум статус будет активен до: " .. os.date( "%d.%m.%Y %H:%M", lastTill ), "AT_Donate_Thanks2_Small", SX( 751 ), SY( 540 + 21 + 4 ), Color( 255, 255, 255 ) )
            end

            surface.SetMaterial( gettableMat )
            surface.SetDrawColor( 255, 255, 255 )
            surface.DrawTexturedRect( 0, SY( 769 ), SX( gettableMat:Width() ), SY( gettableMat:Height() ) )

            surface.SetMaterial( waveMat )
            surface.SetDrawColor( 255, 255, 255 )
            surface.DrawTexturedRect( 0, h - SY( waveMat:Height() ), SX( waveMat:Width() ), SY( waveMat:Height() ) )
        end )
    end

    local closeBtn = vgui.Create( "DButton", bgPnl )
    closeBtn:SetPos( bgPnl:GetWide() - SX( 24 ) - SX( 36 ), SY( 49 ) )
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
        if ( ValidPanel( AT_Donate_VGUI ) ) then
            AT_Donate_VGUI:Remove()
            AT_Donate_VGUI = nil
        end
    end

    if ( !hasPremium ) then
        local buyBtn = vgui.Create( "DButton", bgPnl )
        buyBtn:SetPos( ( bgPnl:GetWide() - SX( 339 ) ) / 2, SY( 576 + 50 ) )
        buyBtn:SetSize( SX( 339 ), SY( 67 ) )
        buyBtn:SetText( "" )
        buyBtn.IconAnim = { nextanim = 0, rot = 0, y = 0, objRot = 25 }
        buyBtn.Paint = function( self, w, h )
            INTERFACE_SMOOTHING( 1920, 1080, function()
                surface.SetMaterial( purchaseBtnMat )
                surface.SetDrawColor( 255, 255, 255 )
                surface.DrawTexturedRect( 0, 0, w, h )

                surface.SetMaterial( purchaseIconMat )
                surface.SetDrawColor( 255, 255, 255 )
                -- surface.DrawTexturedRectRotated( 57, 16 + self.IconAnim.y, 32, 32, self.IconAnim.rot )

                -- Add some cute animations
                if ( self:IsHovered() ) then
                    if ( self.IconAnim.nextanim < CurTime() ) then
                        if ( flux && flux.to ) then
                            flux.to( self.IconAnim, 0.25, { y = 4 } )
                            :after( self.IconAnim, 0.25, { y = 0, rot = self.IconAnim.objRot } )
                        end

                        self.IconAnim.objRot = self.IconAnim.objRot == 25 and -25 or 25
                        self.IconAnim.nextanim = CurTime() + 0.5
                    end

                    render.PushFilterMin( TEXFILTER.ANISOTROPIC )
                    render.PushFilterMag( TEXFILTER.ANISOTROPIC )
                        surface.DrawTexturedRectRotated( SX( 57 ) + SX( 16 ), SY( 16 ) + SY( 14 ) + SY( self.IconAnim.y ), SX( 32 ), SY( 32 ), self.IconAnim.rot )
                    render.PopFilterMin()
                    render.PopFilterMag()
                else
                    surface.DrawTexturedRect( SX( 57 ), SY( 16 ), SX( 32 ), SY( 32 ) )
                end
            end )
        end
        buyBtn.DoClick = function()
            if ( ValidPanel( AT_Donate_VGUI ) ) then
                AT_Donate_VGUI:Remove()
                AT_Donate_VGUI = nil
            end

            IGS.UI()

            -- net.Start( "repix_AnimeTown_BuyPremium" )
            --     net.WriteInt( CurrentTime or 1, 8 )
            -- net.SendToServer()
        end

        local x = SX( 537 )
        for i = 1, 4 do
            local timeBtn = vgui.Create( "DButton", bgPnl )
            timeBtn:SetPos( x, SY( 537 ) )
            timeBtn:SetSize( SX( 198 ), SY( 55 ) )
            timeBtn:SetText( "" )
            timeBtn.Paint = function( self, w, h )
                INTERFACE_SMOOTHING( 1920, 1080, function()
                    if ( CurrentTime == i ) then
                        surface.SetMaterial( holdTimeMat )
                        surface.SetDrawColor( 255, 255, 255 )
                        surface.DrawTexturedRect( 0, 0, w, h )
                    end
                end )
            end
            timeBtn.DoClick = function()
                if ( CurrentTime == i ) then return end

                CurrentTime = i
            end

            x = x + SX( 198 ) + SX( 18 )
        end
    end
end