sql.Query( "CREATE TABLE IF NOT EXISTS repix_bans( SteamID TINYTEXT, Reason TINYTEXT, UnbanDate INT )" )

module( "administration", package.seeall )

BanMessage = [[У вас нет доступа к серверу.
Дата разблокировки: %s
Причина бана: %s
Искать нас здесь: discord.gg/zZhEtegke8]]

function Ban( steamId, reason, unbanDate )
    if ( !reason ) then
        reason = "причина не указана"
    end

    local banTime = unbanDate * 60
    if ( banTime <= 0 ) then
        unbanDate = 0
    else
        unbanDate = os.time() + banTime
    end

    local ply = player.GetBySteamID( steamId )
    if ( IsValid( ply ) ) then
        ply:Kick( string.format( BanMessage, unbanDate == 0 and "никогда" or os.date( "%c", unbanDate ), reason ) )
    end

    sql.Query( "INSERT INTO repix_bans( SteamID, Reason, UnbanDate ) VALUES( " .. SQLStr( steamId ) .. ", " .. SQLStr( reason ) .. ", " .. tonumber( unbanDate ) .. " )" )

    sql.Query( "UPDATE repix_at_profiles SET Banned = " .. tonumber( 1 ) .. " WHERE SteamID = " .. SQLStr( steamId ) )
end

function Unban( steamId )
    sql.Query( "DELETE FROM repix_bans WHERE SteamID = " .. SQLStr( steamId ) )

    sql.Query( "UPDATE repix_at_profiles SET Banned = " .. tonumber( 0 ) .. " WHERE SteamID = " .. SQLStr( steamId ) )
end

timer.Create( "repix_AnimeTown_CheckBans", 60, 0, function()
    local bans = sql.Query( "SELECT * FROM repix_bans" )
    if ( istable( bans ) && #bans > 0 ) then
        for i = 1, table.Count( bans ) do
            if ( tonumber( bans[ i ].UnbanDate ) <= os.time() ) then
                Unban( bans[ i ].SteamID )
            end
        end
    end
end )

local function banData( steamId )
    local ban = sql.Query( "SELECT * FROM repix_bans WHERE SteamID = " .. SQLStr( steamId ) )
    if ( istable( ban ) && #ban > 0 ) then
        return {
            Reason = ban[ 1 ].Reason,
            Unban = ban[ 1 ].UnbanDate
        }
    end

    return false
end

hook.Add( "CheckPassword", "repix_AnimeTown_Bans", function( sid64 )
    local data = banData( util.SteamIDFrom64( sid64 ) )
    if ( !isbool( data ) ) then
        return false, string.format( BanMessage, data.Unban, data.Reason )
    end
end )

-- Logs
if ( !file.Exists( "repix_chatlog.txt", "DATA" ) ) then
    file.Write( "repix_chatlog.txt", "" )
end
hook.Add( "PlayerSay", "repix_AnimeTown_Logs.Chat", function( ply, msg, t )
    if ( !IsValid( ply ) || !ply:IsPlayer() ) then return end

    file.Append( "repix_chatlog.txt", ( t and "[TEAM]" or "" ) .. ply:SteamID() .. " (" .. ply:RPNick() .. "): " .. msg .. "\n" )
end )
