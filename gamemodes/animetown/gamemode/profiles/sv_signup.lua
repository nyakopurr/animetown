util.AddNetworkString( "repix_AnimeTown_CheckAvailability" )
util.AddNetworkString( "repix_AnimeTown_RegisterProfile" )

module( "rpname", package.seeall )

local function NicknameAvailable( nick )
    -- this is kinda the fastest I could do
    local tbl = sql.Query( "SELECT * FROM repix_at_profiles" )
    if ( istable( tbl ) && table.Count( tbl ) > 0 ) then
        for i = 1, table.Count( tbl ) do
            if ( tbl[ i ].Name == nick ) then
                return false
            end
        end
    end

    return true
end

-- I'm really curious if this is fucked up or not
-- I feel like the server's gonna blow up when there'll be alot of people
-- TODO: Make it as unexploitable as possible
net.Receive( "repix_AnimeTown_CheckAvailability", function( len, ply )
    if ( !IsValid( ply ) || !ply:IsPlayer() ) then return end

    local nick = net.ReadString()
    if ( !nick || !isstring( nick ) || nick == "" ) then return end
    local ret = NicknameAvailable( nick )

    net.Start( "repix_AnimeTown_CheckAvailability" )
        net.WriteBool( ret or false )
    net.Send( ply )
end )

net.Receive( "repix_AnimeTown_RegisterProfile", function( len, ply )
    if ( !IsValid( ply ) || !ply:IsPlayer() ) then return end

    local nick = net.ReadString()
    if ( !nick || !isstring( nick ) || nick == "" ) then return end
    if ( utf8.len( nick ) < 7 ) then return end
    if ( utf8.len( nick ) > 20 ) then return end
    -- TODO: Make a lot of checks for nick. Really.

    local avail = NicknameAvailable( nick )
    if ( !avail ) then return end

    ply:SetNWString( "repix_AnimeTown_RoleplayNick", nick )

    if ( profile && profile.New ) then
        profile.New( ply )
    end
end )