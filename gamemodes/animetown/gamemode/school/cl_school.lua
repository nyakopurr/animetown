include( "sh_school.lua" )

local mathMat = Material( "repix/animetown/school/classrooms/math.png" )
local helpMat = Material( "repix/animetown/school/classrooms/help.png" )
local occultMat = Material( "repix/animetown/school/classrooms/occult.png" )
local historyMat = Material( "repix/animetown/school/classrooms/history.png" )
local physicsMat = Material( "repix/animetown/school/classrooms/physics.png" )
local itMat = Material( "repix/animetown/school/classrooms/it.png" )
local principalMat = Material( "repix/animetown/school/classrooms/principal.png" )
local langsMat = Material( "repix/animetown/school/classrooms/langs.png" )
local libraryMat = Material( "repix/animetown/school/classrooms/library.png" )
local biologyMat = Material( "repix/animetown/school/classrooms/biology.png" )

local positions = {
    [1] = {
        Material = mathMat,
        Pos = Vector( -1252.248535, -1694.088257, 90 ),
        Ang = Angle( 0, -90, 90 )
    },
    [2] = {
        Material = helpMat,
        Pos = Vector( -1252.164185, -760.492432, 90 ),
        Ang = Angle( 0, -90, 90 )
    },
    [3] = {
        Material = occultMat,
        Pos = Vector( -2796.938232, -1983.751099, 90 ),
        Ang = Angle( 0, -180, 90 )
    },
    [4] = {
        Material = historyMat,
        Pos = Vector( -3059.811279, -1615.369751, 90 ),
        Ang = Angle( 0, 90, 90 )
    },
    [5] = {
        Material = physicsMat,
        Pos = Vector( -3059.794922, -1190.324219, 90 ),
        Ang = Angle( 0, 90, 90 )
    },
    [6] = {
        Material = itMat,
        Pos = Vector( -3059.756592, -775.070068, 90 ),
        Ang = Angle( 0, 90, 90 )
    },
    [7] = {
        Material = principalMat,
        Pos = Vector( -2788.294922, -1983.808838, 235.734436 ),
        Ang = Angle( 0, 180, 90 )
    },
    [8] = {
        Material = langsMat,
        Pos = Vector( -1252.248535, -1694.088257, 230.734436 ),
        Ang = Angle( 0, -90, 90 )
    },
    [9] = {
        Material = libraryMat,
        Pos = Vector( -3059.816650, -1192.909790, 235.734436 ),
        Ang = Angle( 0, 90, 90 )
    },
    [10] = {
        Material = biologyMat,
        Pos = Vector( -3059.766357, -768.384033, 235.734436 ),
        Ang = Angle( 0, 90, 90 )
    },
}

local scheduleMat = Material( "repix/animetown/school/schedules.png" )
local schedule = { Pos = Vector( -1387, -1067, 100 ), Ang = Angle( 0, 90, 90 ) }

surface.CreateFont( "AT_ScheduleBoard_Position", { font = "Roboto", size = 21, extended = true } )
surface.CreateFont( "AT_ScheduleBoard_Lesson", { font = "Roboto", size = 21, weight = 500, extended = true } )

hook.Add( "PostDrawTranslucentRenderables", "repix_AnimeTown_SchoolClasses", function( bDepth, bSkybox )
    if ( bDepth || bSkybox ) then return end
    if ( !location ) then return end
    if ( LocalPlayer():Location() ~= "school" ) then return end

    for i = 1, table.Count( positions ) do
        local pos, ang = positions[ i ].Pos, positions[ i ].Ang
        local mat = positions[ i ].Material
        cam.Start3D2D( pos, ang, 0.08 )
            surface.SetDrawColor( 255, 255, 255 )
            surface.SetMaterial( mat )
            surface.DrawTexturedRect( 0, 0, mat:Width(), mat:Height() )
        cam.End3D2D()
    end

    if ( LocalPlayer():GetPos():DistToSqr( schedule.Pos ) > 512^2 ) then return end

    cam.Start3D2D( schedule.Pos, schedule.Ang, 0.15 )
        surface.SetDrawColor( 255, 255, 255 )
        surface.SetMaterial( scheduleMat )
        surface.DrawTexturedRect( 0, 0, scheduleMat:Width(), scheduleMat:Height() )

        local x, y = 44, 224
        for i = 1, 6 do
            draw.RoundedBox( 12, x, y, 41, 41, Color( 0, 117, 255 ) )
            draw.SimpleText( i, "AT_ScheduleBoard_Position", x + 16, y + 10, Color( 255, 255, 255 ) )

            local lsn = game.GetWorld():GetNWString( "repix_AnimeTown_Lesson" .. i, "Нет урока" )
            if ( lsn == "-" ) then lsn = "Нет урока" end
            if ( school && school.TranslateLesson && lsn ~= "-" ) then
                lsn = school.TranslateLesson( lsn )
            end
            draw.SimpleText( lsn, "AT_ScheduleBoard_Lesson", x + 41 + 21, y + 10, Color( 255, 255, 255 ) )

            draw.SimpleText( school and school.Times[ i ] or "--", "AT_ScheduleBoard_Position", scheduleMat:Width() - 45, y + 10, Color( 255, 255, 255 ), 2 )

            y = y + 41 + 7
        end
    cam.End3D2D()
end )

surface.CreateFont( "AT_PrincipalAward", { font = "Rubik Medium", size = 32, weight = 500, extended = true } )

local baseMat = Material( "repix/animetown/school/principal_awards.png" )
local closeTextMat = Material( "repix/animetown/school/close_text.png" )
function OpenPrincipalAwardMenu()
    if ( ValidPanel( AT_PrincipalAwardMenuGUI ) ) then
        AT_PrincipalAwardMenuGUI:Remove()
        AT_PrincipalAwardMenuGUI = nil
    end

    local values = {
        [1] = 250,
        [2] = 150,
        [3] = 100
    }

    AT_PrincipalAwardMenuGUI = vgui.Create( "EditablePanel" )
    AT_PrincipalAwardMenuGUI:SetSize( 651, 376 )
    AT_PrincipalAwardMenuGUI:Center()
    AT_PrincipalAwardMenuGUI:MakePopup()
    AT_PrincipalAwardMenuGUI.EverChanged = false
    AT_PrincipalAwardMenuGUI.Paint = function( self, w, h )
        surface.SetDrawColor( 255, 255, 255 )
        surface.SetMaterial( baseMat )
        surface.DrawTexturedRect( 0, 0, w, h )

        if ( self.EverChanged ) then
            surface.SetDrawColor( 255, 255, 255 )
            surface.SetMaterial( closeTextMat )
            surface.DrawTexturedRect( 169, 8, closeTextMat:Width(), closeTextMat:Height() )
        end
    end

    local closeBtn = vgui.Create( "DButton", AT_PrincipalAwardMenuGUI )
    closeBtn:SetPos( AT_PrincipalAwardMenuGUI:GetWide() - 24 - 28, 20 )
    closeBtn:SetSize( 24, 24 )
    closeBtn:SetText( "" )
    closeBtn.Paint = function() end
    closeBtn.DoClick = function()
        if ( ValidPanel( AT_PrincipalAwardMenuGUI ) ) then
            AT_PrincipalAwardMenuGUI:Remove()
            AT_PrincipalAwardMenuGUI = nil
        end

        if ( values[1] ~= 250 || values[2] ~= 150 || values[3] ~= 100 ) then
            net.Start( "repix_AnimeTown_PrincipalAwardChange" )
                net.WriteInt( values[1], 16 )
                net.WriteInt( values[2], 16 )
                net.WriteInt( values[3], 16 )
            net.SendToServer()
        end
    end

    local y = 44
    for i = 1, 3 do
        local entryPnl = vgui.Create( "DTextEntry", AT_PrincipalAwardMenuGUI )
        entryPnl:SetPos( 256 + 8, y )
        entryPnl:SetSize( 213 - 16, 58 )
        entryPnl:SetText( "" )
        entryPnl:SetDrawLanguageID( false )
        entryPnl:SetNumeric( true )
        entryPnl:SetFont( "AT_PrincipalAward" )
        entryPnl.Paint = function( self, w, h )
            self:DrawTextEntryText( Color( 125, 125, 125 ), Color( 0, 0, 0 ), Color( 255, 255, 255 ) )
        end
        entryPnl.OnChange = function( self )
            surface.PlaySound( "repix/animetown/chatting/click-short.wav" )

            if ( !AT_PrincipalAwardMenuGUI.EverChanged ) then
                AT_PrincipalAwardMenuGUI.EverChanged = true
            end

            values[ i ] = tonumber( self:GetValue() )
        end

        y = y + 58 + 43
    end
end

function PlaySchoolBellSound()
    if ( LocalPlayer():Location() ~= "school" ) then return end

    sound.Play( "repix/animetown/ambient/school_bell.mp3", LocalPlayer():GetPos() + Vector( 0, 0, 128 ), 50, 100, 1 )
end

SchoolBell_LastLesson = SchoolBell_LastLesson or 0
timer.Create( "repix_AnimeTown_SchoolBell", 1, 0, function()
    if ( school && school.GetLesson ) then
        local lesson = school.GetLesson()
        if ( lesson ~= SchoolBell_LastLesson ) then
            PlaySchoolBellSound()

            SchoolBell_LastLesson = lesson
        end
    end
end )

local scheduleMat = Material( "repix/animetown/school/principal_schedule.png" )
local partMat = Material( "repix/animetown/school/principal_schedule_pt.png" )

surface.CreateFont( "AT_PrincipalSchedule", { font = "Rubik Medium", size = 17, weight = 500, extended = true } )

function OpenPrincipalScheduleMenu()
    if ( ValidPanel( AT_PrincipalScheduleMenuGUI ) ) then
        AT_PrincipalScheduleMenuGUI:Remove()
        AT_PrincipalScheduleMenuGUI = nil
    end

    AT_PrincipalScheduleMenuGUI = vgui.Create( "EditablePanel" )
    AT_PrincipalScheduleMenuGUI:SetSize( 646, 495 )
    AT_PrincipalScheduleMenuGUI:Center()
    AT_PrincipalScheduleMenuGUI:MakePopup()
    AT_PrincipalScheduleMenuGUI.Paint = function( self, w, h )
        surface.SetDrawColor( 255, 255, 255 )
        surface.SetMaterial( scheduleMat )
        surface.DrawTexturedRect( 0, 0, w, h )
    end

    local closeBtn = vgui.Create( "DButton", AT_PrincipalScheduleMenuGUI )
    closeBtn:SetPos( AT_PrincipalScheduleMenuGUI:GetWide() - 24 - 36, 37 )
    closeBtn:SetSize( 24, 24 )
    closeBtn:SetText( "" )
    closeBtn.Paint = function() end
    closeBtn.DoClick = function()
        if ( ValidPanel( AT_PrincipalScheduleMenuGUI ) ) then
            AT_PrincipalScheduleMenuGUI:Remove()
            AT_PrincipalScheduleMenuGUI = nil
        end
    end

    local y = 84
    for i = 1, 6 do
        local lesBtn = vgui.Create( "DButton", AT_PrincipalScheduleMenuGUI )
        lesBtn:SetPos( 39, y )
        lesBtn:SetSize( 572, 45 )
        lesBtn:SetText( "" )
        lesBtn.Paint = function( self, w, h )
            surface.SetDrawColor( 255, 255, 255 )
            surface.SetMaterial( partMat )
            surface.DrawTexturedRect( 0, 0, w, h )

            draw.SimpleText( i, "AT_PrincipalSchedule", 20, 13, Color( 255, 255, 255 ) )

            local lessonName = "Нет урока"
            local lessonToBeTranslated = game.GetWorld():GetNWString( "repix_AnimeTown_Lesson" .. i, "-" )
            if ( school && school.TranslateLesson && lessonToBeTranslated ~= "-" ) then
                lessonName = school.TranslateLesson( lessonToBeTranslated )
            end

            if ( school && school.GetLesson ) then
                local lesson = school.GetLesson()
                if ( isnumber( lesson ) && lesson == i ) then
                    lessonName = lessonName .. " (сейчас)"
                end
            end
            draw.SimpleText( lessonName, "AT_PrincipalSchedule", 70, 13, Color( 175, 178, 183 ) )
        end
        lesBtn.DoClick = function()
            local dMenu = DermaMenu()

            dMenu:AddOption( "Урок " .. i )
            dMenu:AddSpacer()

            for _, opt in pairs( { "math", "physics", "nativenot", "russian", "pe", "it", "-" } ) do
                dMenu:AddOption( school.TranslateLesson( opt ), function()
                    net.Start( "repix_AnimeTown_ChangeSchedule" )
                        net.WriteInt( i, 8 )
                        net.WriteString( opt )
                    net.SendToServer()
                end )
            end

            dMenu:Open()
        end

        y = y + 45 + 8
    end
end
