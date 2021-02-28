include( "shared.lua" )

ENT.RenderGroup = RENDERGROUP_BOTH

function ENT:Draw()
    -- self:DrawModel()
end

local baseMat = Material( "repix/animetown/questiongame/base.png" )
local categoryMat = Material( "repix/animetown/questiongame/category.png" )
local timeMat = Material( "repix/animetown/questiongame/time.png" )
local btnAMat = Material( "repix/animetown/questiongame/btn_a.png" )
local btnBMat = Material( "repix/animetown/questiongame/btn_b.png" )
local btnCMat = Material( "repix/animetown/questiongame/btn_c.png" )
local playerMat = Material( "repix/animetown/questiongame/player.png" )

surface.CreateFont( "AT_QuestionQuest_Question", { font = "Rubik Medium", size = 76, weight = 500, extended = true } )
surface.CreateFont( "AT_QuestionQuest_Category", { font = "Rubik Medium", size = 26, weight = 500, extended = true } )
surface.CreateFont( "AT_QuestionQuest_Answer", { font = "Rubik Medium", size = 38, weight = 500, extended = true } )
surface.CreateFont( "AT_QuestionQuest_Time", { font = "Rubik Medium", size = 28, weight = 500, extended = true } )
surface.CreateFont( "AT_QuestionQuest_Round", { font = "Rubik Medium", size = 19, weight = 500, extended = true } )
surface.CreateFont( "AT_QuestionQuest_PlayerName", { font = "Rubik Medium", size = 21, weight = 500, extended = true } )

function ENT:DrawTranslucent()
    local locPos = LocalPlayer():GetPos()
    if ( locPos:DistToSqr( self:GetPos() ) > 512^2 ) then return end

    cam.Start3D2D( self:LocalToWorld( Vector( -35, -73, 1.55 ) ), self:LocalToWorldAngles( Angle( 0, 90, 0 ) ), 0.1 )
        surface.SetDrawColor( 255, 255, 255 )
        surface.SetMaterial( baseMat )
        surface.DrawTexturedRect( -128, -128, baseMat:Width(), baseMat:Height() )

        if ( self:GetState() == 0 ) then
            draw.DrawText( "Ожидание игроков.\nНажмите E по столу, чтобы начать игру.", "AT_QuestionQuest_Answer", 1755 / 2 - 128, 306 - 128, Color( 255, 255, 255 ), 1 )
        end

        if ( self:GetState() ~= 0 ) then
            local curQuestion = self:GetQuestion()
            if ( curQuestion ~= 0 ) then
                curQuestion = self.Questions[ curQuestion ]
                surface.SetMaterial( categoryMat )
                surface.DrawTexturedRect( -128 + 760, -128 + 223, categoryMat:Width(), categoryMat:Height() )

                surface.SetMaterial( timeMat )
                surface.DrawTexturedRect( -128 + 1540, -128 + 33, timeMat:Width(), timeMat:Height() )

                local y = -128 + 609
                for i = 1, 3 do
                    local btnMat = i == 1 and btnAMat or ( i == 2 and btnBMat or btnCMat )
                    surface.SetMaterial( btnMat )
                    surface.DrawTexturedRect( -128 + 594, y, btnMat:Width(), btnMat:Height() )

                    draw.SimpleText( curQuestion.Answers[ i ][ 1 ], "AT_QuestionQuest_Answer", 702 - 128, y + 26, Color( 255, 255, 255 ) )

                    y = y + btnMat:Height() + 22
                end

                local questionMarkup = markup.Parse( "<font=AT_QuestionQuest_Question>" .. curQuestion.Question ..  "</font>", 1311 )
                questionMarkup:Draw( 1755 / 2 - 128, 306 - 8, 1, 1 )

                draw.SimpleText( curQuestion.Category, "AT_QuestionQuest_Category", 842 - 94, 234 - 128, Color( 255, 255, 255 ), 1 )

                local time = self:GetTimeleft()
                time = time - UnPredictedCurTime()
                time = string.ToMinutesSeconds( time )
                draw.SimpleText( time, "AT_QuestionQuest_Time", 1608 - 128, 49 - 128, Color( 255, 255, 255 ) )
                draw.SimpleText( "Раунд " .. self:GetRound(), "AT_QuestionQuest_Round", 1623 - 96, 112 - 128, Color( 255, 255, 255 ), 1 )
            end
        end

        local x = 508 - 128
        for i = 1, 3 do
            surface.SetMaterial( playerMat )
            surface.DrawTexturedRect( x, 49 - 128, playerMat:Width(), playerMat:Height() )

            local name = "Нет игрока"
            local score = 0
            if ( istable( self.Players ) ) then
                local ply = self.Players[ i ]
                if ( IsValid( ply ) && ply:IsPlayer() ) then
                    name = ply.RPNick and ply:RPNick() or ply:Nick()
                    score = ply:GetNWInt( "repix_AnimeTown_QuestionQuest.Score", 0 )
                end
            end

            draw.SimpleText( name, "AT_QuestionQuest_PlayerName", x + ( playerMat:Width() / 2 ), 59 - 128, Color( 191, 191, 191 ), 1 )
            draw.SimpleText( "Счёт: " .. score, "AT_QuestionQuest_PlayerName", x + ( playerMat:Width() / 2 ), 49 + 35 - 128, Color( 191, 191, 191 ), 1 )

            x = x + playerMat:Width() + 18
        end
    cam.End3D2D()
end

hook.Add( "CalcView", "repix_AnimeTown_QuestionQuest", function( ply, pos, ang, fov )
    if ( !IsValid( ply ) ) then return end
    if ( !ply:GetNWBool( "repix_AnimeTown_QuestionQuest.Playing", false ) ) then return end
    local controllerEnt = ply:GetNWEntity( "repix_AnimeTown_QuestionQuest.Entity", nil )
    if ( !IsValid( controllerEnt ) ) then return end
    if ( controllerEnt:GetState() == 0 ) then return end

    return {
        origin = Vector( -3184.116699, -1580.908813, 206.473801 ),
        angles = Angle( 0, 90, 0 )
    }
end )

net.Receive( "repix_AnimeTown_QuestionQuest.Players", function()
    local controllerEnt = net.ReadEntity()
    if ( !IsValid( controllerEnt ) ) then return end
    local players = net.ReadTable()

    controllerEnt.Players = players
end )

local pos = { Vector( -3185.148926, -1814.591309, 235.503967 ), Angle( 0, 180, 90 ) }
local helperMat = Material( "repix/animetown/questiongame/helper.png" )
hook.Add( "PostDrawTranslucentRenderables", "repix_AnimeTown_QuestionQuest", function()
    local locPos = LocalPlayer():GetPos()
    if ( locPos:DistToSqr( pos[1] ) > 512^2 ) then return end

    cam.Start3D2D( pos[1], pos[2], 0.08 )
        surface.SetDrawColor( 255, 255, 255 )
        surface.SetMaterial( helperMat )
        surface.DrawTexturedRect( -helperMat:Width() / 2, 0, helperMat:Width(), helperMat:Height() )
    cam.End3D2D()
end )

surface.CreateFont( "AT_QuestionQuest_GUI_Button", { font = "Rubik Medium", size = 28, weight = 500, extended = true } )
surface.CreateFont( "AT_QuestionQuest_GUI_Close", { font = "Rubik Medium", size = 17, weight = 500, extended = true } )

function OpenQuestionQuestMenu()
    if ( ValidPanel( AT_QuestionQuest_GUI ) ) then
        AT_QuestionQuest_GUI:Remove()
        AT_QuestionQuest_GUI = nil
    end

    AT_QuestionQuest_GUI = vgui.Create( "EditablePanel" )
    AT_QuestionQuest_GUI:SetPos( ( ScrW() - 226 ) / 2, 0 )
    AT_QuestionQuest_GUI:SetSize( 226, 106 )
    AT_QuestionQuest_GUI:MakePopup()
    AT_QuestionQuest_GUI.Paint = function( self )
        surface.SetDrawColor( 27, 24, 40 )
        surface.DrawRect( 0, 0, self:GetSize() )
    end

    local x = 25
    for i = 1, 3 do
        local answerBtn = vgui.Create( "DButton", AT_QuestionQuest_GUI )
        answerBtn:SetPos( x, 17 )
        answerBtn:SetSize( 47, 47 )
        answerBtn:SetText( "" )
        answerBtn.Paint = function( self, w, h )
            surface.SetDrawColor( i == 1 and Color( 42, 210, 136 ) or ( i == 2 and Color( 44, 135, 245 ) or Color( 242, 119, 30 ) ) )
            surface.DrawRect( 0, 0, w, h )

            draw.SimpleText( i == 1 and "A" or ( i == 2 and "B" or "C" ), "AT_QuestionQuest_GUI_Button", w / 2, h / 2, Color( 255, 255, 255 ), 1, 1 )
        end
        answerBtn.DoClick = function()
            net.Start( "repix_AnimeTown_QuestionQuest.Answer" )
                net.WriteInt( i, 8 )
            net.SendToServer()
        end

        x = x + 47 + 17
    end

    local closeBtn = vgui.Create( "DButton", AT_QuestionQuest_GUI )
    closeBtn:SetPos( 25, 77 )
    closeBtn:SetSize( 175, 21 )
    closeBtn:SetText( "" )
    closeBtn.Paint = function( self, w, h )
        surface.SetDrawColor( 208, 66, 66 )
        surface.DrawRect( 0, 0, w, h )

        draw.SimpleText( "Выйти из игры", "AT_QuestionQuest_GUI_Close", w / 2, h / 2, Color( 255, 255, 255 ), 1, 1 )
    end
    closeBtn.DoClick = function()
        if ( ValidPanel( AT_QuestionQuest_GUI ) ) then
            AT_QuestionQuest_GUI:Remove()
            AT_QuestionQuest_GUI = nil
        end

        net.Start( "repix_AnimeTown_QuestionQuest.Leave" )
        net.SendToServer()
    end
end

net.Receive( "repix_AnimeTown_QuestionQuest.Menu", function()
    OpenQuestionQuestMenu()
end )
