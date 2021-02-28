module( "location", package.seeall )

List = {
    [1] = {
        Name = "basketball",
        Min = Vector( 2215.465576, -2937.541992, -14.777996 ),
        Max = Vector( 1178.377197, -1870.761841, 438.470245 )
    },
    [2] = {
        Name = "restaurant",
        Min = Vector( 5707.859863, -5495.941406, -230.723602 ),
        Max = Vector( 4904.005859, -4234.602051, 546.942810 )
    },
    [3] = {
        Name = "school",
        Min = Vector( 330.698090, -2233.888428, -1028.428345 ),
        Max = Vector( -3906.249023, 997.281433, 1357.694702 )
    },
    [4] = {
        Name = "underground",
        Min = Vector( 1928.032227, -5394.321289, -1193.632080 ),
        Max = Vector( 97.989471, -7635.253418, -119.708954 )
    },
}

for i = 1, table.Count( List or {} ) do
    OrderVectors( List[ i ].Min, List[ i ].Max )
end

local meta = FindMetaTable( "Player" )

function meta:Location()
    -- return self:GetNWString( "repix_AnimeTown_CurLocation", "-" )
    for i = 1, table.Count( List or {} ) do
        if ( self:GetPos():WithinAABox( List[ i ].Min, List[ i ].Max ) ) then
            return List[ i ].Name
        end
    end

    return "-"
end

if ( CLIENT ) then
    local basketballLocMat = Material( "repix/animetown/hud/locations/basketball.png" )
    local restaurantLocMat = Material( "repix/animetown/hud/locations/restaurant.png" )
    local schoolLocMat = Material( "repix/animetown/hud/locations/school.png" )
    local undergroundLocMat = Material( "repix/animetown/hud/locations/underground.png" )
    MaterialList = {
        ["basketball"] = basketballLocMat,
        ["restaurant"] = restaurantLocMat,
        ["school"] = schoolLocMat,
        ["underground"] = undergroundLocMat,
    }
end
