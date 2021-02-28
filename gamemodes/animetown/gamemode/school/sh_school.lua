module( "school", package.seeall )

LessonsStart = "7:30"
Times = {
    [1] = "7:30-8:15",
    [2] = "8:30-9:15",
    [3] = "9:30-10:15",
    [4] = "10:30-11:15",
    [5] = "11:30-12:15",
    [6] = "12:30-13:15"
}

function GetLesson()
    if ( !SW || !SW.Time ) then return 0 end

    local time = SW.Time
    if ( ( time > 13.15 && time < 24 ) || ( time > 0 && time < 7.5 ) ) then
        return "done"
    end

    -- That's pretty dumb, slow and everything
    -- I hope I'll do it better sometime later
    if ( time >= 7.5 && time <= 8.25 ) then
        return 1
    elseif ( time >= 8.5 && time <= 9.25 ) then
        return 2
    elseif ( time >= 9.5 && time <= 10.25 ) then
        return 3
    elseif ( time >= 10.5 && time <= 11.25 ) then
        return 4
    elseif ( time >= 11.5 && time <= 12.25 ) then
        return 5
    elseif ( time >= 12.5 && time <= 13.25 ) then
        return 6
    end

    return "break"
end

local Translations = {
    ["break"] = "Перемена", ["math"] = "Математика", ["physics"] = "Физика",
    ["nativenot"] = "Иностранный язык", ["pe"] = "Физическая культура",
    ["it"] = "Информатика", ["russian"] = "Русский язык", ["-"] = "Нет урока",
}
function TranslateLesson( str )
    local translatedStr = str

    if ( isstring( Translations[ str ] ) ) then
        translatedStr = Translations[ str ]
    end

    return translatedStr
end

if ( CLIENT ) then
    local lessonWontMat = Material( "repix/animetown/hud/lessons/done.png" )
    local mathMat = Material( "repix/animetown/hud/lessons/math.png" )
    local breakMat = Material( "repix/animetown/hud/lessons/break.png" )
    local physicsMat = Material( "repix/animetown/hud/lessons/physics.png" )
    local nativeNotMat = Material( "repix/animetown/hud/lessons/nativenot.png" )
    local noneMat = Material( "repix/animetown/hud/lessons/none.png" )
    local peMat = Material( "repix/animetown/hud/lessons/pe.png" )
    local itMat = Material( "repix/animetown/hud/lessons/it.png" )
    local ruMat = Material( "repix/animetown/hud/lessons/russian.png" )
    LessonMaterials = {
        ["done"] = lessonWontMat, ["math"] = mathMat, ["break"] = breakMat,
        ["physics"] = physicsMat, ["nativenot"] = nativeNotMat, ["none"] = noneMat,
        ["pe"] = peMat, ["it"] = itMat, ["russian"] = ruMat,
    }
end
