include( "cl_profile.lua" )
include( "cl_signup.lua" )
include( "cl_list.lua" )

local listBadge1Mat = Material( "repix/animetown/profile/list/bg_base_01.png" )
local listBadge2Mat = Material( "repix/animetown/profile/list/bg_base_02.png" )
local listBadge3Mat = Material( "repix/animetown/profile/list/bg_base_03.png" )
local listBadge4Mat = Material( "repix/animetown/profile/list/bg_base_premium_01.png" )
local listBadge5Mat = Material( "repix/animetown/profile/list/bg_base_premium_02.png" )
local listBadge6Mat = Material( "repix/animetown/profile/list/bg_base_premium_03.png" )
local listBadge7Mat = Material( "repix/animetown/profile/list/bg_base_premium_04.png" )
local listBadge8Mat = Material( "repix/animetown/profile/list/bg_base_premium_05.png" )
local listBadge9Mat = Material( "repix/animetown/profile/list/bg_base_premium_06.png" )

local personalRuFlag = Material( "repix/animetown/profile/personal/flags/ru.png" )
local personalKzFlag = Material( "repix/animetown/profile/personal/flags/kz.png" )
local personalUaFlag = Material( "repix/animetown/profile/personal/flags/ua.png" )
local personalByFlag = Material( "repix/animetown/profile/personal/flags/by.png" )

local badgeRuFlag = Material( "repix/animetown/profile/3d/countries/ru.png" )
local badgeKzFlag = Material( "repix/animetown/profile/3d/countries/kz.png" )
local badgeUaFlag = Material( "repix/animetown/profile/3d/countries/ua.png" )
local badgeByFlag = Material( "repix/animetown/profile/3d/countries/by.png" )
local badgePlFlag = Material( "repix/animetown/profile/3d/countries/pl.png" )

local TWOPI = math.pi * 2
local HALFPI = math.pi * 0.5
local PI32 = math.pi + ( math.pi / 2 )

local function extend( t1, t2 )
    for _, v in ipairs( t2 ) do
        t1[ #t1 + 1 ] = v
    end
end

local function arc_coords( x, y, radius, start, stop, step )
    step = step or ( TWOPI * 0.01 )
    if ( start > stop ) then
        step = -step
    end

    local coords = {}
    for angle = start, stop, step do
        coords[ #coords + 1 ] = { x = x + math.cos( angle ) * radius, y = y + math.sin( angle ) * radius }
    end

    return coords
end

function drawRoundedRectangle( x, y, w, h, radius, color, bgcolor, linewidth, aa, step )
    radius = radius or 0
    linewidth = linewidth or 1
    local hlw = linewidth * 0.5
    local x1 = x + radius + hlw
    local y1 = y + radius + hlw
    local x2 = x + w - radius - hlw
    local y2 = y + h - radius - hlw

    if ( radius > 0 ) then
        coords = arc_coords( x1, y1, radius, math.pi, PI32, step )
        extend( coords, arc_coords( x2, y1, radius, PI32, TWOPI, step ) )
        extend( coords, arc_coords( x2, y2, radius, 0, HALFPI, step ) )
        extend( coords, arc_coords( x1, y2, radius, HALFPI, math.pi, step ) )
    else
        coords = { x1, hlw, x2, hlw, w - hlw, y2, x1, h - hlw }
    end

    surface.SetDrawColor( color )
    surface.DrawPoly( coords )
end


module( "profile", package.seeall )

ListBadges = {
    [1] = listBadge1Mat, [3] = listBadge3Mat, [5] = listBadge5Mat, [7] = listBadge7Mat, [9] = listBadge9Mat,
    [2] = listBadge2Mat, [4] = listBadge4Mat, [6] = listBadge6Mat, [8] = listBadge8Mat,
}

PersonalFlagMaterials = {
    ["ru"] = personalRuFlag,
    ["by"] = personalByFlag,
    ["ua"] = personalUaFlag,
    ["kz"] = personalKzFlag,
}

BadgeFlagMaterials = {
    ["ru"] = badgeRuFlag,
    ["by"] = badgeByFlag,
    ["ua"] = badgeUaFlag,
    ["kz"] = badgeKzFlag,
    ["pl"] = badgePlFlag,
}