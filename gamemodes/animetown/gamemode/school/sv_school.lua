include( "sh_school.lua" )

AddCSLuaFile( "sh_school.lua" )

util.AddNetworkString( "repix_AnimeTown_PrincipalAwardChange" )
util.AddNetworkString( "repix_AnimeTown_ChangeSchedule" )

local MarkAwardsDef = {
    [5] = 250,
    [4] = 150,
    [3] = 100
}

MarkAwards = MarkAwardsDef

function AddMark( ply, m )
    if ( m > 5 ) then return end
    if ( m < 2 ) then return end

    local xp = m * 20
    local money = 0
    if ( m > 2 ) then
        money = MarkAwards[ m ]
    end

    ply:AddXP( xp )
    ply:AddMoney( money )

    ply:ChatPrint( "Вы получили оценку " .. m .. " (+" .. xp .. "xp)" )

    if ( effects && effects.Bubbles ) then
        effects.Bubbles( ply:GetPos() - Vector( 16, 16, 16 ), ply:GetPos() + Vector( 16, 16, 16 ), 45, 150, 0, 0 )
    end

    local ed = EffectData()
    ed:SetOrigin( ply:GetPos() )
    util.Effect( "balloon_pop", ed )

    ply:EmitSound( "garrysmod/content_downloaded.wav" )
end

net.Receive( "repix_AnimeTown_PrincipalAwardChange", function( len, ply )
    if ( !IsValid( ply ) || !ply:IsPlayer() ) then return end
    if ( ply:Team() ~= 2 ) then return end

    local val1 = net.ReadInt( 16 )
    local val2 = net.ReadInt( 16 )
    local val3 = net.ReadInt( 16 )

    local anyGood = false
    if ( isnumber( val1 ) && val1 ~= MarkAwards[5] ) then
        if ( val1 <= 0 ) then return end
        if ( val1 > 750 ) then return end

        MarkAwards[5] = val1
        anyGood = true
    end

    if ( isnumber( val2 ) && val2 ~= MarkAwards[4] ) then
        if ( val2 <= 0 ) then return end
        if ( val2 > 750 ) then return end

        MarkAwards[4] = val2
        anyGood = true
    end

    if ( isnumber( val3 ) && val3 ~= MarkAwards[3] ) then
        if ( val3 <= 0 ) then return end
        if ( val3 > 750 ) then return end

        MarkAwards[3] = val3
        anyGood = true
    end

    if ( !anyGood ) then return end

    ply:ChatPrint( "Награды за получение оценок изменены." )
end )

hook.Add( "PlayerChangedTeam", "repix_AnimeTown_PrincipalAwardChange", function( ply, old, new )
    if ( !IsValid( ply ) || !ply:IsPlayer() ) then return end
	if ( old == 2 ) then
        -- Restore to defaults
        MarkAwards = MarkAwardsDef

        local worldEnt = game.GetWorld()
        for i = 1, 6 do
            worldEnt:SetNWString( "repix_AnimeTown_Lesson" .. i, "-" )
        end
    end
end )

-- hook.Add( "InitPostEntity", "repix_AnimeTown_Schedule.Init", function()
--     timer.Simple( 5, function()
--         if ( !IsValid( game.GetWorld() ) ) then return end
--
--         local worldEnt = game.GetWorld()
--         for i = 1, 6 do
--             worldEnt:SetNWString( "repix_AnimeTown_Lesson" .. i, "-" )
--         end
--     end )
-- end )

net.Receive( "repix_AnimeTown_ChangeSchedule", function( len, ply )
    if ( !IsValid( ply ) || !ply:IsPlayer() ) then return end
    if ( ply:Team() ~= 2 ) then return end -- is principal

    local lesson = net.ReadInt( 8 )
    if ( !isnumber( lesson ) ) then return end
    if ( lesson > 6 || lesson < 1 ) then return end -- out of bounds
    local curLesson = school and school.GetLesson() or 0
    if ( curLesson == lesson ) then
        ply:ChatPrint( "Вы не можете изменить урок, который уже идет." )
        return
    end

    local lessonStr = net.ReadString()
    if ( !table.HasValue( { "math", "pe", "it", "physics", "nativenot", "russian", "-" }, lessonStr ) ) then
        return
    end

    game.GetWorld():SetNWString( "repix_AnimeTown_Lesson" .. lesson, lessonStr )
end )
