sql.Query( "CREATE TABLE IF NOT EXISTS repix_at_profiles( SteamID TINYTEXT, Name TINYTEXT, Banned TINYINT, Premium TINYINT, Background TINYINT, Status TINYTEXT, Level TINYINT, XP TINYINT, LastOnline TINYTEXT, Country TINYTEXT, Achievements MEDIUMTEXT, Wall MEDIUMTEXT )" )
sql.Query( "CREATE TABLE IF NOT EXISTS repix_premiums( SteamID TINYTEXT, LastTill INT )" )

util.AddNetworkString( "repix_AnimeTown_OpenProfile" )
util.AddNetworkString( "repix_AnimeTown_ChangeBackground" )
util.AddNetworkString( "repix_AnimeTown_ChangeStatus" )
util.AddNetworkString( "repix_AnimeTown_ShowProfile" )
util.AddNetworkString( "repix_AnimeTown_BuyPremium" )
util.AddNetworkString( "repix_AnimeTown_ShowProfileList" )
util.AddNetworkString( "repix_AnimeTown_AddWallComment" )
util.AddNetworkString( "repix_AnimeTown_RemoveWallComment" )

module( "profile", package.seeall )

-- hook.Add( "PlayerInitialSpawn", "repix_AnimeTown_Profile.Register", function( ply )
--     ply.RepixProfile = {
--         Nick = ply:RPNick(),
--         SteamID = ply:SteamID(),
--         Banned = false,
--         Background = math.random( 1, 3 ),
--         Premium = false,
--         Status = "люблю печеньки",
--         Achievements = "",
--         Level = 0,
--         Accessories = "",
--         LastOnline = os.time(),
--         Country = "ru",
--         Wall = ""
--     }
-- end )

local function GetCountry( ip, callback, failCallback )
	if ( ip == "loopback" || ip == "localhost" ) then
		-- Could not retrieve actual ip: it has to be because
		-- you're running a singleplayer session

		failCallback()
	end

	local ipaddress = string.Explode( ":", ip )[ 1 ]

	http.Fetch( "http://ip-api.com/json/" .. ipaddress,
	function( data )
		if ( string.len( data ) > 5 ) then
			data = util.JSONToTable( data )

			if ( data.countryCode ) then
				callback( data )
			end
		end
	end,
    function()
        failCallback()
    end )
end

local function ProfileExist( steamId )
    local tbl = sql.Query( "SELECT * FROM repix_at_profiles" )
    if ( istable( tbl ) && table.Count( tbl ) > 0 ) then
        for i = 1, table.Count( tbl ) do
			if ( tbl[ i ].SteamID == steamId ) then
				return true
			end
		end
    else
        return false
    end

	return false
end

local function GetNick( steamId )
	-- NOTE: this is not efficient. commented out.
	-- local tbl = sql.Query( "SELECT * FROM repix_at_profiles" )
	-- if ( istable( tbl ) && table.Count( tbl ) > 0 ) then
	-- 	for i = 1, table.Count( tbl ) do
	-- 		if ( tbl[ i ].SteamID == steamId ) then
	-- 			return tbl[ i ].Name
	-- 		end
	-- 	end
	-- else
	-- 	return "Unknown Unknown"
	-- end

	local tbl = sql.Query( "SELECT Name FROM repix_at_profiles WHERE SteamID = " .. SQLStr( steamId ) )
	if ( istable( tbl ) && table.Count( tbl ) > 0 ) then
		return tbl[ 1 ].Name
	end

	return "Unknown Unknown"
end

local function GetData( steamId )
	local tbl = sql.Query( "SELECT * FROM repix_at_profiles" )
	if ( istable( tbl ) && table.Count( tbl ) > 0 ) then
		for i = 1, table.Count( tbl ) do
			if ( tbl[ i ].SteamID == steamId ) then
				return tbl[ i ]
			end
		end
	else
		return {}
	end

	return {}
end

function New( ply )
	if ( !IsValid( ply ) || !ply:IsPlayer() ) then return end
    if ( ProfileExist( ply ) ) then return end

    local name = ply:Nick()
    if ( ply.RPNick ) then name = ply:RPNick() end

    local function query( ply, name, countryCode )
		print(ply, name, countryCode)
		sql.Query( "INSERT INTO repix_at_profiles( SteamID, Name, Banned, Premium, Background, Status, Level, XP, LastOnline, Country, Achievements, Wall ) VALUES( "
		.. SQLStr( ply:SteamID() ) .. ", "
		.. SQLStr( name ) .. ", "
		.. 0 .. ", "
		.. 0 .. ", "
		.. math.random( 1, 3 ) .. ", "
		.. SQLStr( "я еще не поменял статус" ) .. ", "
		.. 0 .. ", "
		.. 0 .. ", "
		.. SQLStr( os.time() ) .. ", "
		.. SQLStr( countryCode ) .. ", "
		.. SQLStr( "[]" ) .. ", "
		.. SQLStr( "[]" ) .. " )" )
		-- print(sql.LastError())
    end

    -- NOTE: ply.IPAddress returns localhost in singleplayer;
    -- please register new players only in multiplayer
    GetCountry( ply:IPAddress(), function( data )
        if ( !istable( data ) ) then query( ply, name, "ru" ) return end

        local code = data.countryCode
        if ( isstring( code ) ) then
            query( ply, name, code )
        else
            query( ply, name, "ru" )
        end
    end, function() query( ply, name, "ru" ) end )
end

function Open( ply, steamId )
	if ( !IsValid( ply ) || !ply:IsPlayer() ) then return end
	if ( !ProfileExist( steamId ) ) then return end
	local data = GetData( steamId )

	net.Start( "repix_AnimeTown_OpenProfile" )
		net.WriteString( data.SteamID )
		net.WriteString( data.Name )
		net.WriteString( data.Country )
		net.WriteInt( tonumber( data.Premium ), 4 )
		net.WriteInt( tonumber( data.Banned ), 4 )
		net.WriteInt( tonumber( data.Background ), 8 )
		net.WriteString( data.Status )
		net.WriteString( data.LastOnline )
		net.WriteInt( tonumber( data.Level ), 32 )
		net.WriteInt( tonumber( data.XP ), 32 )
		net.WriteString( "[]" )
		net.WriteString( data.Wall )
	net.Send( ply )
end

function GetPremiumLastTill( steamId )
	if ( !isstring( steamId ) ) then return end

	local lastTill = sql.Query( "SELECT LastTill FROM repix_premiums WHERE SteamID = " .. SQLStr( steamId ) )
	if ( istable( lastTill ) && #lastTill > 0 ) then
		return tonumber( lastTill[ 1 ].LastTill )
	end

	return 0
end

hook.Add( "PlayerInitialSpawn", "repix_AnimeTown_Profile.SetRPName", function( ply )
	-- this needs fixes
	timer.Simple( 1, function()
		if ( !IsValid( ply ) ) then return end

		local steamId = ply:SteamID()
		if ( ProfileExist( steamId ) ) then
			ply:SetNWString( "repix_AnimeTown_RoleplayNick", GetNick( steamId ) )

			local data = GetData( steamId )
			ply:SetNWString( "repix_AnimeTown_Profile.Country", data.Contry or "ru" )
			ply:SetNWInt( "repix_AnimeTown_Profile.Background", data.Background or 1 )
			ply:SetNWString( "repix_AnimeTown_Profile.Status", data.Status or "я еще не поменял статус" )
			ply:SetNWBool( "repix_AnimeTown_Profile.Premium", tobool( data.Premium ) or false )

			if ( tobool( data.Premium ) ) then
				local lastTill = GetPremiumLastTill( ply:SteamID() )
				ply:SetNWInt( "repix_AnimeTown_Profile.PremiumDies", lastTill )
			end

			sql.Query( "UPDATE repix_at_profiles SET LastOnline = " .. SQLStr( os.time() ) .. " WHERE SteamID = " .. SQLStr( steamId ) )
		end
	end )
end )

net.Receive( "repix_AnimeTown_ChangeBackground", function( len, ply )
	if ( !IsValid( ply ) || !ply:IsPlayer() ) then return end

	local bg = net.ReadInt( 8 )
	if ( !isnumber( bg ) ) then return end
	if ( bg <= 0 || bg > 9 ) then return end -- out of bounds
	if ( bg > 3 && bg <= 9 ) then -- premium backgrounds
		local data = GetData( ply:SteamID() )
		if ( istable( data ) ) then
			if ( !tobool( data.Premium ) ) then return end
		end
	end

	ply:SetNWInt( "repix_AnimeTown_Profile.Background", bg or 1 )

	sql.Query( "UPDATE repix_at_profiles SET Background = " .. tonumber( bg ) .. " WHERE SteamID = " .. SQLStr( ply:SteamID() ) )
end )

net.Receive( "repix_AnimeTown_ChangeStatus", function( len, ply )
	if ( !IsValid( ply ) || !ply:IsPlayer() ) then return end

	local status = net.ReadString()
	if ( !isstring( status ) ) then return end
	-- Limit string characters
	if ( utf8.len( status ) > 111 ) then
		status = utf8.sub( status, 1, 111 ) .. "..."
	end

	ply:SetNWInt( "repix_AnimeTown_Profile.Status", status or "я еще не поменял статус" )

	sql.Query( "UPDATE repix_at_profiles SET Status = " .. SQLStr( status ) .. " WHERE SteamID = " .. SQLStr( ply:SteamID() ) )
end )

net.Receive( "repix_AnimeTown_ShowProfile", function( len, ply )
	if ( !IsValid( ply ) || !ply:IsPlayer() ) then return end

	local steamid = net.ReadString()
	Open( ply, steamid )
end )

local times = {
	[1] = 2628000,
	[2] = 7884000,
	[3] = 15768000,
	[4] = 31536000
}
function BuyPremium( ply, time )
    if ( !IsValid( ply ) || !ply:IsPlayer() ) then return end
    if ( ply:GetNWBool( "repix_AnimeTown_Profile.Premium", false ) ) then return end

    if ( !times[ time ] ) then return end
    time = times[ time ]

    local itDies = tonumber( os.time() + time )

    ply:SetNWBool( "repix_AnimeTown_Profile.Premium", true )
    ply:SetNWInt( "repix_AnimeTown_Profile.PremiumDies", itDies )

    sql.Query( "UPDATE repix_at_profiles SET Premium = " .. tonumber( 1 ) .. " WHERE SteamID = " .. SQLStr( ply:SteamID() ) )
    sql.Query( "INSERT INTO repix_premiums( SteamID, LastTill ) VALUES( " .. SQLStr( ply:SteamID() ) .. ", " .. itDies .. " )" )

    local name = ply:Nick()
    if ( ply.RPNick ) then
        name = ply:RPNick()
    end

    for _, ply in pairs( player.GetHumans() ) do
        ply:ChatPrint( ">> " .. name .. " присоединился к дружной семье Премиум пользователей. <<" )
    end
end

-- net.Receive( "repix_AnimeTown_BuyPremium", function( len, ply )
-- 	local time = net.ReadInt( 8 )
-- 	BuyPremium( ply, time )
-- end )

function RemovePremium( steamId )
	local ply = player.GetBySteamID( steamId )
	if ( IsValid( ply ) ) then
		ply:SetNWBool( "repix_AnimeTown_Profile.Premium", false )
		ply:SetNWInt( "repix_AnimeTown_Profile.Background", 1 )
		ply:SetNWString( "repix_AnimeTown_ChatColor", "146 146 146" )
	end

	-- if player had a premium background on then reset it
	local data = GetData( steamId )
	if ( istable( data ) ) then
		if ( tonumber( data.Background ) > 3 && tonumber( data.Background ) <= 9 ) then
			sql.Query( "UPDATE repix_at_profiles SET Background = " .. tonumber( 1 ) .. " WHERE SteamID = " .. SQLStr( steamId ) )
		end
	end

	sql.Query( "UPDATE repix_at_profiles SET Premium = " .. tonumber( 0 ) .. " WHERE SteamID = " .. SQLStr( steamId ) )
	sql.Query( "DELETE FROM repix_premiums WHERE SteamID = " .. SQLStr( steamId ) )

	-- Remove Chat Color
	sql.Query( "UPDATE repix_userdata SET ChatColor = " .. SQLStr( "146 146 146" ) .. " WHERE SteamID = " .. SQLStr( steamId ) )

	-- TODO: Remove Accessories
end

timer.Create( "repix_AnimeTown_CheckPremiums", 900, 0, function()
    local premiums = sql.Query( "SELECT * FROM repix_premiums" )
    if ( istable( premiums ) && #premiums > 0 ) then
        for i = 1, table.Count( premiums ) do
            if ( tonumber( premiums[ i ].LastTill ) <= os.time() ) then
                RemovePremium( premiums[ i ].SteamID )
            end
        end
    end
end )

function HasPremium( ply )
	-- local data = GetData( ply:SteamID() )
	-- if ( istable( data ) ) then
	-- 	return tobool( data.Premium )
	-- end
	--
	-- return false

	return ply:GetNWBool( "repix_AnimeTown_Profile.Premium", false )
end

function OpenProfileList( ply )
	local data = sql.Query( "SELECT * FROM repix_at_profiles" ) or {}

	data = util.TableToJSON( data )
	data = util.Compress( data )

	local len = data:len()
	net.Start( "repix_AnimeTown_ShowProfileList" )
		net.WriteInt( len, 32 )
		net.WriteData( data, len )
	net.Send( ply )
end

net.Receive( "repix_AnimeTown_ShowProfileList", function( len, ply )
	if ( !IsValid( ply ) || !ply:IsPlayer() ) then return end

	OpenProfileList( ply )
end )

net.Receive( "repix_AnimeTown_AddWallComment", function( len, ply )
	if ( !IsValid( ply ) || !ply:IsPlayer() ) then return end

	local str = net.ReadString()
	if ( !isstring( str ) ) then return end
	if ( utf8.len( str ) > 256 ) then
		str = utf8.sub( str, 1, 256 ) .. "..."
	end

	local wallComments = {}
	wallComments = sql.Query( "SELECT Wall FROM repix_at_profiles WHERE SteamID = " .. SQLStr( ply:SteamID() ) )
	if ( istable( wallComments ) ) then
		wallComments = wallComments[ 1 ].Wall
		wallComments = util.JSONToTable( wallComments )
	end

	local hasPremium = ply:GetNWBool( "repix_AnimeTown_Profile.Premium", false )
	if ( table.Count( wallComments or {} ) > ( hasPremium and 20 or 10 ) ) then return end

	table.insert( wallComments, { Text = str, Date = os.time() } )

	wallComments = util.TableToJSON( wallComments )

	sql.Query( "UPDATE repix_at_profiles SET Wall = " .. SQLStr( wallComments ) .. " WHERE SteamID = " .. SQLStr( ply:SteamID() ) )
end )

net.Receive( "repix_AnimeTown_RemoveWallComment", function( len, ply )
	if ( !IsValid( ply ) || !ply:IsPlayer() ) then return end

	local id = net.ReadInt( 16 )
	if ( !isnumber( id ) ) then return end

	local wallComments = {}
	wallComments = sql.Query( "SELECT Wall FROM repix_at_profiles WHERE SteamID = " .. SQLStr( ply:SteamID() ) )
	if ( istable( wallComments ) ) then
		wallComments = wallComments[ 1 ].Wall
		wallComments = util.JSONToTable( wallComments )
	end

	if ( wallComments[ id ] ) then
		table.remove( wallComments, id )
	end

	wallComments = util.TableToJSON( wallComments )

	sql.Query( "UPDATE repix_at_profiles SET Wall = " .. SQLStr( wallComments ) .. " WHERE SteamID = " .. SQLStr( ply:SteamID() ) )
end )

gameevent.Listen( "player_disconnect" )
hook.Add( "player_disconnect", "repix_AnimeTown_ProfileOnlineUpdate", function( data )
	sql.Query( "UPDATE repix_at_profiles SET LastOnline = " .. SQLStr( os.time() ) .. " WHERE SteamID = " .. SQLStr( data.networkid ) )
end )