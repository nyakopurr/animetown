do return end

local flux = include( "includes/flux.lua" )

local baseMat = Material( "repix/animetown/updatelog/base.png" )
local buttonMat = Material( "repix/animetown/updatelog/button_ok.png" )

local updBanner = Material( "repix/animetown/updatelog/updates/christmas20_banner.png" )
local updTitle = Material( "repix/animetown/updatelog/updates/christmas20_title.png" )
local updDate = Material( "repix/animetown/updatelog/updates/christmas20_date.png" )
local updText = Material( "repix/animetown/updatelog/updates/christmas20_testtext.png" )

local menuAnim = { alpha = 0, scale = 1.05 }
function AT_ShowUpdateLog()
    if ( !flux || !flux.to ) then return end

    menuAnim = { alpha = 0, scale = 1.05 }

    flux.to( menuAnim, 0.25, { alpha = 1, scale = 1 } )
    :ease( "linear" )

    local AT_UpdateLog_VGUI = vgui.Create( "EditablePanel" )
    AT_UpdateLog_VGUI:SetSize( ScrW(), ScrH() )
    AT_UpdateLog_VGUI:MakePopup()
    AT_UpdateLog_VGUI.Paint = function( self, w, h )
        surface.SetDrawColor( 255, 255, 255, 255 * menuAnim.alpha )
        surface.SetMaterial( baseMat )

        render.PushFilterMin( TEXFILTER.ANISOTROPIC )
        render.PushFilterMag( TEXFILTER.ANISOTROPIC )
            surface.DrawTexturedRect( ( w - ( baseMat:Width() * menuAnim.scale ) ) / 2, ( h - ( baseMat:Height() * menuAnim.scale ) ) / 2, baseMat:Width() * menuAnim.scale, baseMat:Height() * menuAnim.scale )
        render.PopFilterMin()
        render.PopFilterMag()

        surface.SetMaterial( updBanner )
        surface.DrawTexturedRect( 662, 270, updBanner:Width(), updBanner:Height() )

        surface.SetMaterial( updTitle )
        surface.DrawTexturedRect( 662, 205, updTitle:Width(), updTitle:Height() )

        surface.SetMaterial( updDate )
        surface.DrawTexturedRect( 662, 236, updDate:Width(), updDate:Height() )

        surface.SetMaterial( updText )
        surface.DrawTexturedRect( 662, 430, updText:Width(), updText:Height() )

        if ( flux && flux.update ) then
            flux.update( RealFrameTime() )
        end
    end

    local closeBtn = vgui.Create( "DButton", AT_UpdateLog_VGUI )
    closeBtn:SetText( "" )
    closeBtn:SetSize( buttonMat:Width(), buttonMat:Height() )
    closeBtn:SetPos( 806, 858 )
    closeBtn.Paint = function( self, w, h )
        surface.SetDrawColor( 255, 255, 255, 255 * menuAnim.alpha )
        surface.SetMaterial( buttonMat )
        surface.DrawTexturedRect( 0, 0, w, h )
    end
    closeBtn.DoClick = function()
        flux.to( menuAnim, 0.2, { alpha = 0, scale = 0.25 } )
        :ease( "backin" )
        :oncomplete( function()
            if ( ValidPanel( AT_UpdateLog_VGUI ) ) then
                AT_UpdateLog_VGUI:Remove()
                AT_UpdateLog_VGUI = nil
            end
        end )

        surface.PlaySound( "repix/animetown/clicks/switch.wav" )
    end
end
