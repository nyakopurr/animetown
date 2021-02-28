include( "sh_accessories.lua" )

local baseMat = Material( "repix/animetown/accessories/base.png" )
local catJobMat = Material( "repix/animetown/accessories/cat_job.png" )
local catPremiumMat = Material( "repix/animetown/accessories/cat_premium.png" )
local mdlMat = Material( "repix/animetown/accessories/model_default.png" )
local premMdl1Mat = Material( "repix/animetown/accessories/premium/mdl1.png" )
local premMdl2Mat = Material( "repix/animetown/accessories/premium/mdl2.png" )
local premMdl3Mat = Material( "repix/animetown/accessories/premium/mdl3.png" )
local premMdl4Mat = Material( "repix/animetown/accessories/premium/mdl4.png" )
local premMdl5Mat = Material( "repix/animetown/accessories/premium/mdl5.png" )
local premMdl6Mat = Material( "repix/animetown/accessories/premium/mdl6.png" )
local premMdl7Mat = Material( "repix/animetown/accessories/premium/mdl7.png" )
local premMdlLockMat = Material( "repix/animetown/accessories/premium/locked.png" )
local closedMat = Material( "repix/animetown/accessories/accessories_closed.png" )
local gradientMat = Material( "repix/animetown/accessories/accessories_gradient.png" )

module( "accessories", package.seeall )

local PremiumModelMats = {
    [1] = premMdl1Mat, [4] = premMdl4Mat, [7] = premMdl7Mat,
    [2] = premMdl2Mat, [5] = premMdl5Mat,
    [3] = premMdl3Mat, [6] = premMdl6Mat,
}

function Open( t )
    if ( ValidPanel( AT_AccessoriesGUI ) ) then
        AT_AccessoriesGUI:Remove()
        AT_AccessoriesGUI = nil
    end

    AT_AccessoriesGUI = vgui.Create( "EditablePanel" )
    AT_AccessoriesGUI:SetSize( ScrW(), ScrH() )
    AT_AccessoriesGUI:MakePopup()
    AT_AccessoriesGUI:SetAlpha( 0 )
    AT_AccessoriesGUI:AlphaTo( 255, 0.15 )
    AT_AccessoriesGUI.Paint = function( self, w, h )
        INTERFACE_SMOOTHING( 1920, 1080, function()
            surface.SetDrawColor( 0, 0, 0, 180 )
            surface.DrawRect( 0, 0, w, h )

            surface.SetMaterial( baseMat )
            surface.SetDrawColor( 255, 255, 255 )
            surface.DrawTexturedRect( 0, 0, w, h )

            if ( t == "model_tab" ) then
                surface.SetMaterial( catJobMat )
                surface.SetDrawColor( 255, 255, 255 )
                surface.DrawTexturedRect( SX( 63 ), SY( 127 ), SX( catJobMat:Width() ), SY( catJobMat:Height() ) )
            end

            if ( t == "accessories_tab" ) then
                surface.SetMaterial( closedMat )
                surface.SetDrawColor( 255, 255, 255 )
                surface.DrawTexturedRect( ( ( w - SX( 728 ) ) - SX( closedMat:Width() ) ) / 2, SY( 127 ), SX( closedMat:Width() ), SY( closedMat:Height() ) )

                surface.SetMaterial( gradientMat )
                surface.SetDrawColor( 255, 255, 255 )
                surface.DrawTexturedRect( 0, h - SY( gradientMat:Height() ), SX( gradientMat:Width() ), SY( gradientMat:Height() ) )
            end
        end )
    end

    local closeBtn = vgui.Create( "DButton", AT_AccessoriesGUI )
    closeBtn:SetPos( AT_AccessoriesGUI:GetWide() - SX( 34 ) - SX( 34 ), SY( 25 ) )
    closeBtn:SetSize( SX( 34 ), SY( 34 ) )
    closeBtn:SetText( "" )
    closeBtn.Paint = function() end
    closeBtn.DoClick = function()
        if ( ValidPanel( AT_AccessoriesGUI ) ) then
            AT_AccessoriesGUI:Remove()
            AT_AccessoriesGUI = nil
        end
    end

    local tx = 42
    for i = 1, 2 do
        local tabBtn = vgui.Create( "DButton", AT_AccessoriesGUI )
        tabBtn:SetPos( SX( tx ), SY( 20 ) )
        tabBtn:SetSize( SX( 156 ), SY( 37 ) )
        tabBtn:SetText( "" )
        tabBtn.Paint = function() end
        tabBtn.DoClick = function()
            Open( i == 1 and "model_tab" or "accessories_tab" )
        end

        tx = tx + 156 + 12
    end

    local modelPnl = vgui.Create( "DModelPanel", AT_AccessoriesGUI )
    modelPnl:SetPos( AT_AccessoriesGUI:GetWide() - SX( 728 ), SY( 165 ) )
    modelPnl:SetSize( SX( 728 ), SY( 915 ) )
    modelPnl:SetModel( LocalPlayer():GetModel() )

    local mn, mx = modelPnl.Entity:GetRenderBounds()
    local size = 0
    size = math.max( size, math.abs( mn.x ) + math.abs( mx.x ) )
    size = math.max( size, math.abs( mn.y ) + math.abs( mx.y ) )
    size = math.max( size, math.abs( mn.z ) + math.abs( mx.z ) )

    modelPnl:SetFOV( 30 )
    modelPnl:SetCamPos( Vector( size, size, size ) )
    modelPnl:SetLookAt( ( mn + mx ) * 0.5 )

    modelPnl.LayoutEntity = function() return end
    modelPnl.Think = function( self )
        if ( self:GetModel() ~= LocalPlayer():GetModel() ) then
            self:SetModel( LocalPlayer():GetModel() )
        end
    end

    local scrollPanel = vgui.Create( "DScrollPanel", AT_AccessoriesGUI )
    scrollPanel:SetPos( 0, SY( 76 ) )
    scrollPanel:SetSize( AT_AccessoriesGUI:GetWide() - SX( 728 ), AT_AccessoriesGUI:GetTall() - SY( 76 ) )
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

    if ( t == "accessories_tab" ) then return end

    local mdl = LocalPlayer():GetJob().Models
    local x, y = SX( 65 ), SY( 100 )
    for i = 1, table.Count( mdl ) do
        local mdlPnl = vgui.Create( "DPanel", scrollPanel )
        mdlPnl:SetPos( x, y )
        mdlPnl:SetSize( SX( 68 ), SY( 68 ) )
        mdlPnl.Paint = function( self, w, h )
            INTERFACE_SMOOTHING( 1920, 1080, function()
                surface.SetMaterial( mdlMat )
                surface.SetDrawColor( 255, 255, 255 )
                surface.DrawTexturedRect( 0, 0, w, h )
            end )
        end

        local preview = vgui.Create( "SpawnIcon", mdlPnl )
        preview:SetPos( 0, 0 )
        preview:SetSize( SX( 64 ), SY( 64 ) )
        preview:SetModel( mdl[ i ] )
        preview:SetTooltip( nil )
        preview.PaintOver = function() end
        preview.OnMousePressed = function()
            -- if ( ValidPanel( frame ) ) then
            --     frame:Remove()
            --     frame = nil
            -- end

            net.Start( "repix_AnimeTown_ChangeModel" )
                net.WriteString( mdl[ i ] )
            net.SendToServer()
        end

        if ( x + SX( 68 ) + SX( 65 ) > scrollPanel:GetWide() ) then
            x = SX( 65 )
            y = y + SY( 68 ) + SY( 9 )
        else
            x = x + SX( 68 ) + SX( 9 )
        end
    end

    local premiumImg = vgui.Create( "DPanel", scrollPanel )
    premiumImg:SetPos( SX( 63 ), y + SY( 86 ) )
    premiumImg:SetSize( SX( 204 ), SY( 31 ) )
    premiumImg.Paint = function( self, w, h )
        INTERFACE_SMOOTHING( 1920, 1080, function()
            surface.SetMaterial( catPremiumMat )
            surface.SetDrawColor( 255, 255, 255 )
            surface.DrawTexturedRect( 0, 0, w, h )
        end )
    end

    local pX, pY = SX( 65 ), y + SY( 86 ) + SY( 48 )
    for i = 1, 7 do
        local premiumMdl = vgui.Create( "DPanel", scrollPanel )
        premiumMdl:SetPos( pX, pY )
        premiumMdl:SetSize( SX( 341 ), SY( 116 ) )
        premiumMdl:SetCursor( "hand" )
        premiumMdl.Paint = function( self, w, h )
            INTERFACE_SMOOTHING( 1920, 1080, function()
                surface.SetMaterial( PremiumModelMats[ i ] )
                surface.SetDrawColor( 255, 255, 255 )
                surface.DrawTexturedRect( 0, 0, w, h )

                local hasPremium = LocalPlayer():GetNWBool( "repix_AnimeTown_Profile.Premium", false )
                if ( !hasPremium ) then
                    surface.SetMaterial( premMdlLockMat )
                    surface.SetDrawColor( 255, 255, 255 )
                    surface.DrawTexturedRect( ( w - SX( premMdlLockMat:Width() ) ) / 2, SY( 16 ), SX( premMdlLockMat:Width() ), SY( premMdlLockMat:Height() ) )
                end
            end )
        end
        premiumMdl.OnMousePressed = function()
            local hasPremium = LocalPlayer():GetNWBool( "repix_AnimeTown_Profile.Premium", false )
            if ( !hasPremium ) then return end

            net.Start( "repix_AnimeTown_ChangeModel" )
                net.WriteString( accessories.List["Playermodels"][i] )
            net.SendToServer()
        end

        if ( pX + SX( 341 ) + SX( 65 ) > scrollPanel:GetWide() ) then
            pX = SX( 65 )
            pY = pY + SY( 116 ) + SY( 9 )
        else
            pX = pX + SX( 341 ) + SX( 26 )
        end
    end
end

-- hook.Add( "PostPlayerDraw", "repix_AnimeTown_Accessories.Hat" , function( ply )
-- 	if ( !IsValid( ply ) || !ply:Alive() ) then return end
--     if ( ply.GetHat && ply:GetHat() == "no hat" ) then return end
--
-- 	local attach_id = ply:LookupAttachment( "eyes" )
-- 	if ( !attach_id ) then return end
--
-- 	local attach = ply:GetAttachment( attach_id )
--
-- 	if not attach then return end
--
--     if ( !IsValid( ply.Accessories_HatModel ) ) then
--         ply.Accessories_HatModel = ClientsideModel( ply:GetHat() )
--         ply.Accessories_HatModel:SetNoDraw( true )
--
--         return
--     end
--
-- 	local pos = attach.Pos
-- 	local ang = attach.Ang
--
-- 	ply.Accessories_HatModel:SetModelScale(1)
-- 	pos = pos + (ang:Forward() * 2.5)
-- 	ang:RotateAroundAxis(ang:Right(), 20)
--
-- 	ply.Accessories_HatModel:SetPos(pos)
-- 	ply.Accessories_HatModel:SetAngles(ang)
--
-- 	ply.Accessories_HatModel:SetRenderOrigin(pos)
-- 	ply.Accessories_HatModel:SetRenderAngles(ang)
-- 	ply.Accessories_HatModel:SetupBones()
-- 	ply.Accessories_HatModel:DrawModel()
-- 	ply.Accessories_HatModel:SetRenderOrigin()
-- 	ply.Accessories_HatModel:SetRenderAngles()
-- end )