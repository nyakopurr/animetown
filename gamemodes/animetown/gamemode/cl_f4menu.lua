local baseMat = Material( "repix/animetown/f4menu/base.png" )
local jobCatMat = Material( "repix/animetown/f4menu/cat_jobs.png" )
local jobStudentMat = Material( "repix/animetown/f4menu/job_student.png" )
local jobPoliceMat = Material( "repix/animetown/f4menu/job_police.png" )
local jobPrincipalMat = Material( "repix/animetown/f4menu/job_principal.png" )
local jobDealerMat = Material( "repix/animetown/f4menu/job_dealer.png" )
local jobTeacherMat = Material( "repix/animetown/f4menu/job_teacher.png" )
local btnTakeMat = Material( "repix/animetown/f4menu/job_take.png" )
local btnTakenMat = Material( "repix/animetown/f4menu/job_inuse.png" )
local selActiveMat = Material( "repix/animetown/f4menu/selection_active.png" )
local selIdleMat = Material( "repix/animetown/f4menu/selection_idle.png" )
local scrollHelpMat = Material( "repix/animetown/f4menu/scroll_help.png" )
local iconJobMat = Material( "repix/animetown/f4menu/icon_jobs.png" )
local iconAccessoriesMat = Material( "repix/animetown/f4menu/icon_accessories.png" )
local iconShopMat = Material( "repix/animetown/f4menu/icon_shop.png" )
local shopCatMat = Material( "repix/animetown/f4menu/cat_shop.png" )

module( "f4menu", package.seeall )

local jobMaterials = {
    [1] = jobStudentMat, [4] = jobDealerMat,
    [2] = jobTeacherMat, [5] = jobPoliceMat,
    [3] = jobPrincipalMat,
}

local categoryMaterials = {
    [1] = iconJobMat,
    [2] = iconAccessoriesMat,
    [3] = iconShopMat
}

local function teamTaken( i )
    local taken = false
    if ( i == 2 ) then
        local teachJobs = {}
        for t = 6, 11 do table.insert( teachJobs, t ) end
        if ( table.HasValue( teachJobs, LocalPlayer():Team() ) ) then
            taken = true
        end
    elseif ( i == 3 ) then
        if ( LocalPlayer():Team() == 2 ) then taken = true end
    elseif ( i == 4 ) then
        if ( table.HasValue( { 3, 4 }, LocalPlayer():Team() ) ) then taken = true end
    elseif ( i == 5 ) then
        if ( LocalPlayer():Team() == 5 ) then taken = true end
    else
        if ( i == LocalPlayer():Team() ) then taken = true end
    end

    return taken
end

function Open( t )
    if ( ValidPanel( AT_F4Menu ) ) then
        AT_F4Menu:Remove()
        AT_F4Menu = nil
    end

    gui.EnableScreenClicker( true )

    if ( !t ) then t = 1 end

    AT_F4Menu = vgui.Create( "EditablePanel" )
    AT_F4Menu:SetSize( SX( 1456 ), SY( 763 ) )
    AT_F4Menu:Center()
    -- AT_F4Menu:MakePopup()
    AT_F4Menu.Paint = function( self, w, h )
        INTERFACE_SMOOTHING( 1920, 1080, function()
            surface.SetDrawColor( 255, 255, 255 )
            surface.SetMaterial( baseMat )
            surface.DrawTexturedRect( 0, 0, w, h )

            if ( t == 1 ) then
                surface.SetDrawColor( 255, 255, 255 )
                surface.SetMaterial( jobCatMat )
                surface.DrawTexturedRect( SX( 128 ), SY( 33 ), SX( jobCatMat:Width() ), SY( jobCatMat:Height() ) )
            elseif ( t == 3 ) then
                surface.SetDrawColor( 255, 255, 255 )
                surface.SetMaterial( shopCatMat )
                surface.DrawTexturedRect( SX( 128 ), SY( 33 ), SX( shopCatMat:Width() ), SY( shopCatMat:Height() ) )
            end

            surface.SetDrawColor( 255, 255, 255 )
            surface.SetMaterial( selIdleMat )
            surface.DrawTexturedRect( SX( 18 ), SY( 49 ), SX( selIdleMat:Width() ), SY( selIdleMat:Height() ) )

            surface.SetDrawColor( 255, 255, 255 )
            surface.SetMaterial( selIdleMat )
            surface.DrawTexturedRect( SX( 18 ), SY( 103 ), SX( selIdleMat:Width() ), SY( selIdleMat:Height() ) )

            surface.SetDrawColor( 255, 255, 255 )
            surface.SetMaterial( selIdleMat )
            surface.DrawTexturedRect( SX( 18 ), SY( 103 + 53 ), SX( selIdleMat:Width() ), SY( selIdleMat:Height() ) )
        end )
    end

    local closeBtn = vgui.Create( "DButton", AT_F4Menu )
    closeBtn:SetPos( AT_F4Menu:GetWide() - SX( 24 ) - SX( 37 ), SY( 35 ) )
    closeBtn:SetSize( SX( 24 ), SY( 24 ) )
    closeBtn:SetText( "" )
    closeBtn.Paint = function() end
    closeBtn.DoClick = function()
        if ( ValidPanel( AT_F4Menu ) ) then
            AT_F4Menu:Remove()
            AT_F4Menu = nil

            gui.EnableScreenClicker( false )
        end
    end

    local discordBtn = vgui.Create( "DButton", AT_F4Menu )
    discordBtn:SetPos( SX( 25 ), AT_F4Menu:GetTall() - SY( 24 ) - SY( 19 ) )
    discordBtn:SetSize( SX( 24 ), SY( 24 ) )
    discordBtn:SetText( "" )
    discordBtn:SetTooltip( "Наш Discord" )
    discordBtn.Paint = function() end
    discordBtn.DoClick = function()
        gui.OpenURL( "https://discord.gg/zZhEtegke8" )
        SetClipboardText( "discord.gg/zZhEtegke8" )
    end

    if ( t == 1 ) then
        local slider = vgui.Create( "DHorizontalScroller", AT_F4Menu )
        slider:SetPos( SX( 128 ), SY( 109 ) )
        slider:SetSize( AT_F4Menu:GetWide() - SX( 128 ), SY( 611 ) )
        slider:SetOverlap( -SX( 30 ) )
        slider.ShowHelp = false
        slider.PaintOver = function( self, w, h )
            if ( !self.ShowHelp ) then return end

            local offsetX = math.sin( CurTime() * 6 ) * 2
            surface.SetDrawColor( 255, 255, 255 )
            surface.SetMaterial( scrollHelpMat )
            surface.DrawTexturedRect( w - scrollHelpMat:Width() - 16 + offsetX, 236, scrollHelpMat:Width(), scrollHelpMat:Height() )
        end
        slider.btnLeft.Paint = function( self, w, h )
        end
        slider.btnRight.Paint = function( self, w, h )
        end
        slider.OnDragModified = function( self )
            if ( self.ShowHelp ) then
                self.ShowHelp = false
            end
        end

        for i = 1, 6 do
            -- Add spacing at the end
            if ( i == 6 ) then
                local spacePnl = vgui.Create( "DPanel", slider )
                spacePnl:SetSize( SX( 53 ), SY( 611 ) )
                spacePnl.Paint = function() end

                slider:AddPanel( spacePnl )

                continue
            end

            local jobPnl = vgui.Create( "DPanel", slider )
            jobPnl:SetSize( SX( 309 ), SY( 611 ) )
            jobPnl.Paint = function( self, w, h )
                INTERFACE_SMOOTHING( 1920, 1080, function()
                    surface.SetDrawColor( 255, 255, 255 )
                    surface.SetMaterial( jobMaterials[ i ] )
                    surface.DrawTexturedRect( 0, 0, w, h )
                end )
            end

            local setBtn = vgui.Create( "DButton", jobPnl )
            setBtn:SetPos( ( jobPnl:GetWide() - SX( 233 ) ) / 2, jobPnl:GetTall() - SY( 46 ) - SY( 11 ) )
            setBtn:SetSize( SX( 233 ), SY( 46 ) )
            setBtn:SetText( "" )
            setBtn.Paint = function( self, w, h )
                local taken = teamTaken( i )
                INTERFACE_SMOOTHING( 1920, 1080, function()
                    surface.SetDrawColor( 255, 255, 255 )
                    surface.SetMaterial( taken and btnTakenMat or btnTakeMat )
                    surface.DrawTexturedRect( 0, 0, w, h )
                end )
            end
            setBtn.DoClick = function()
                local taken = teamTaken( i )
                if ( taken ) then return end
                local finJob = 1
                if ( i == 3 ) then finJob = 2 end
                if ( i == 5 ) then finJob = 5 end
                if ( i == 4 || i == 2 ) then
                    local dMenu = DermaMenu()
                    local from, to = 3, 4
                    if ( i == 2 ) then
                        from, to = 6, 11
                    end
                    for j = from, to do
                        dMenu:AddOption( RP_Teams[ j ].Name, function()
                            net.Start( "repix_AnimeTown_ChangeTeam" )
                                net.WriteInt( j, 16 )
                            net.SendToServer()

                            if ( ValidPanel( AT_F4Menu ) ) then
                                AT_F4Menu:Remove()
                                AT_F4Menu = nil

                                gui.EnableScreenClicker( false )
                            end
                        end )
                    end

                    dMenu:Open()

                    return
                end

                net.Start( "repix_AnimeTown_ChangeTeam" )
                    net.WriteInt( finJob, 16 )
                net.SendToServer()

                if ( ValidPanel( AT_F4Menu ) ) then
                    AT_F4Menu:Remove()
                    AT_F4Menu = nil

                    gui.EnableScreenClicker( false )
                end
            end

            slider:AddPanel( jobPnl )
        end
    elseif ( t == 3 ) then
        local scrollPanel = vgui.Create( "DScrollPanel", AT_F4Menu )
        scrollPanel:SetPos( SX( 75 ), SY( 64 ) )
        scrollPanel:SetSize( AT_F4Menu:GetWide() - SX( 75 ), AT_F4Menu:GetTall() - SY( 64 ) )
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
        pnlLayout:SetSpaceY( SY( 39 ) )
        pnlLayout:SetSpaceX( SX( 72 ) )
        pnlLayout:SetBorder( SY( 32 ) )

        for k, b in pairs( RP_Buyables or {} ) do
            if ( istable( b.CanSee ) && !table.HasValue( b.CanSee, LocalPlayer():Team() ) ) then continue end
            if ( LocalPlayer():Team() == 5 && b.CanSee == "all!police" ) then continue end
            local buyPnl = vgui.Create( "DPanel", pnlLayout )
            buyPnl:SetSize( SX( 516 ), SY( 180 ) )
            buyPnl.Paint = function( self, w, h )
                INTERFACE_SMOOTHING( 1920, 1080, function()
                    surface.SetMaterial( b.Material )
                    surface.SetDrawColor( 255, 255, 255 )
                    surface.DrawTexturedRect( 0, 0, w, h )
                end )
            end

            local buyBtn = vgui.Create( "DButton", buyPnl )
            buyBtn:SetSize( SX( 41 ), SY( 41 ) )
            buyBtn:SetPos( buyPnl:GetWide() - SX( 41 ) - SX( 22 ), SY( 127 ) )
            buyBtn:SetText( "" )
            buyBtn.Paint = function() end
            buyBtn.DoClick = function()
                if ( ValidPanel( AT_F4Menu ) ) then
                    AT_F4Menu:Remove()
                    AT_F4Menu = nil

                    gui.EnableScreenClicker( false )
                end

                net.Start( "repix_AnimeTown_BuyItem" )
                    net.WriteInt( k, 16 )
                net.SendToServer()
            end
        end
    end

    local y = 49
    for i = 1, 3 do
        local catBtn = vgui.Create( "DButton", AT_F4Menu )
        catBtn:SetPos( SX( 18 ), SY( y ) )
        catBtn:SetSize( SX( 38 ), SY( 38 ) )
        catBtn:SetText( "" )
        catBtn.Paint = function( self, w, h )
            local mat = categoryMaterials[ i ]
            INTERFACE_SMOOTHING( 1920, 1080, function()
                surface.SetDrawColor( t == i and Color( 255, 255, 255 ) or Color( 115, 115, 115 ) )
                surface.SetMaterial( mat )
                surface.DrawTexturedRect( ( w - SX( mat:Width() ) ) / 2, ( h - SY( mat:Height() ) ) / 2, SX( mat:Width() ), SY( mat:Height() ) )
            end )
        end
        catBtn.DoClick = function()
            if ( i == 2 ) then
                if ( accessories && accessories.Open ) then
                    accessories.Open( "model_tab" )

                    if ( ValidPanel( AT_F4Menu ) ) then
                        AT_F4Menu:Remove()
                        AT_F4Menu = nil

                        gui.EnableScreenClicker( false )
                    end
                end

                return
            end

            Open( i )
        end

        y = y + 38 + 16
    end
end

net.Receive( "repix_AnimeTown_OpenF4", function()
    if ( ValidPanel( AT_F4Menu ) ) then
        AT_F4Menu:Remove()
        AT_F4Menu = nil

        gui.EnableScreenClicker( false )

        return
    end

    Open()
end )