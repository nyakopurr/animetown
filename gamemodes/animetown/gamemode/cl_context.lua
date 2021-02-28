local context = {
    { "Открыть профиль", function()
        net.Start( "repix_AnimeTown_ShowProfile" )
            net.WriteString( LocalPlayer():SteamID() )
        net.SendToServer()
    end },
    { "Список игроков", function()
        net.Start( "repix_AnimeTown_ShowProfileList" )
        net.SendToServer()
    end },
    { "Установить статус", function()
        Derma_StringRequest( "Изменить статус", "Введите ваш новый статус", "люблю печеньки", function( r )
            -- TODO: Limit string characters
            net.Start( "repix_AnimeTown_ChangeStatus" )
                net.WriteString( r )
            net.SendToServer()
        end )
    end },
    { "Приобрести Премиум", function()
        if ( donate && donate.Open ) then
            donate.Open()
        end
    end },
    { "--divider--" },
    -- { "Открыть дневник" }, -- we've changed the concept
    -- { "Законы города" },
    { "Проиграть звук", function()
        if ( taunts && taunts.Open ) then
            taunts.Open()
        end
    end },
    { "Список анимаций", function()
        gui.OpenURL( "https://steamcommunity.com/workshop/filedetails/?id=1310909460" )
    end },
    { "--divider--" },
    { "Продать все двери", function()
        LocalPlayer():ConCommand( "say /unownalldoors" )
    end },
    { "!Перевести деньги", function( ply )
        if ( !IsValid( ply ) ) then return end

        Derma_StringRequest( "Перевести деньги игроку " .. ply:Nick() .. " (" .. ply:SteamID() .. ")", "Введите сумму", "", function( amount )
            net.Start( "repix_AnimeTown_SendMoney" )
                net.WriteEntity( ply )
                net.WriteInt( amount, 32 )
            net.SendToServer()
        end )
    end },
    { "!Уволить игрока", function( ply )
        if ( !IsValid( ply ) ) then return end

        Derma_StringRequest( "Уволить игрока " .. ply:Nick() .. " (" .. ply:SteamID() .. ")", "Введите причину увольнения", "", function( reason )
            net.Start( "repix_AnimeTown_Demote" )
                net.WriteEntity( ply )
                net.WriteString( reason )
            net.SendToServer()
        end )
    end, "students" },
    { "!Позвонить", function( ply )
        if ( !IsValid( ply ) ) then return end

        net.Start( "repix_AnimeTown_PhoneCall" )
            net.WriteEntity( ply )
        net.SendToServer()
    end },
    { "--divider--", "principal" },
    { "Изменить награды за получение оценок", "principal", function()
        OpenPrincipalAwardMenu()
    end },
    { "Установить расписание звонков", "principal", function()
        OpenPrincipalScheduleMenu()
    end },
    { "--divider--", true },
    { "Изменить цвет ника", true, function()
        local frame = vgui.Create( "DFrame" )
        frame:SetSize( 267, 225 )
        frame:Center()
        frame:MakePopup()
        frame:SetTitle( "Установить цвет ника" )

        local mixer = vgui.Create( "DColorMixer", frame )
        mixer:SetPos( 0, 25 )
        mixer:SetSize( 267, 186 - 25 )
        mixer:SetPalette( true )
        mixer:SetAlphaBar( false )
        mixer:SetWangs( true )
        mixer:SetColor( Color( 146, 146, 146 ) )

        local setBtn = vgui.Create( "DButton", frame )
        setBtn:SetPos( 0, 225 - 25 )
        setBtn:SetSize( 267, 25 )
        setBtn:SetText( "Установить" )
        setBtn.DoClick = function()
            if ( ValidPanel( frame ) ) then
                frame:Remove()
                frame = nil
            end

            net.Start( "repix_AnimeTown_ChangeChatColor" )
                net.WriteColor( mixer:GetColor() )
            net.SendToServer()
        end
    end }
}

local function openContext()
    local hasPremium = LocalPlayer():GetNWBool( "repix_AnimeTown_Profile.Premium", false )
    local mn = DermaMenu( false, g_ContextMenu )
    local y = ScrH() - 16
    for _, j in pairs( context or {} ) do
        if ( isbool( j[2] ) && j[2] && !hasPremium ) then
            continue
        end

        if ( isstring( j[2] ) && j[2] == "principal" ) then
            if ( LocalPlayer():Team() ~= 2 ) then continue end
        end

        if ( j[1] == "--divider--" ) then
            mn:AddSpacer()
            continue
        end

        if ( string.StartWith( j[1], "!" ) ) then
            local sub = mn:AddSubMenu( string.Trim( j[1], "!" ), nil )
            for _, ply in pairs( player.GetAll() ) do
                if ( ply == LocalPlayer() ) then continue end
                if ( j[3] == "students" ) then
                    if ( ply:Team() == 1 ) then
                        continue
                    end
                end

                local name = ply:Nick()
                if ( ply.RPNick && ply:RPNick() ~= "-jiz-time-for-cheese-" ) then
                    name = ply:RPNick()
                end
                sub:AddOption( name, function() j[2]( ply ) end )
            end
            continue
        end

        local func = j[2]
        if ( isbool( j[2] ) || isstring( j[2] ) ) then
            func = j[3]
        end
        mn:AddOption( j[1], func )
        y = y - 30
    end

    mn:Open( 512, y )
    mn:CenterHorizontal()
end
concommand.Add( "at_showcontext", openContext )

hook.Add( "OnContextMenuOpen", "repix_AnimeTown_ContextMenu", function()
    LocalPlayer():ConCommand( "at_showcontext" )
end )