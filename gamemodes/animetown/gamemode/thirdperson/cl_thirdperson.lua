module( "Thirdperson", package.seeall )

Enable = false
Distance = 100

hook.Add( "CalcView", "repix_AnimeTown_Thirdperson", function( ply, origin, angles, fov )
	local view = {}
	view.origin = origin
	view.angles	= angles
	view.fov = fov

	if ( !IsValid( ply ) ) then
		return view
	end

	local vehicle = ply:GetVehicle()

	if ( IsValid( vehicle ) ) then
		return hook.Run( "CalcVehicleView", vehicle, ply, view )
	end

	if ( ( !Enable && !ply:IsPlayingTaunt() ) ) then
		return
	end

	local pos = ply:GetPos() + Vector( 0, 0, 75 )
	local dist = math.Clamp( Distance, 35, 200 )
	local maxview = pos + angles:Forward() * -dist

	local tr = util.TraceLine( {
		start = pos,
		endpos = maxview,
		filter = ents.FindByClass( "player" )
	} )

	if ( tr.Fraction < 1 ) then
		dist = dist * tr.Fraction
	end

	view.origin = pos + ( angles:Forward() * -dist * 0.95 )
	view.angles = Angle( angles.p + 2, angles.y, angles.r )

	return view
end )

hook.Add( "ShouldDrawLocalPlayer", "repix_AnimeTown_Thirdperson", function( ply )
	if ( Enable || ply:IsPlayingTaunt() ) then
		return true
	end
end )

concommand.Add( "at_thirdperson", function( ply, cmd, args )
	if ( args[1] && type( tonumber( args[1] ) ) == "number" && tonumber( args[1] ) > 0 && Enable ) then
		Distance = tonumber( args[1] )
		return
	end

	if ( Enable ) then
		Enable = false
	else
		Enable = true
	end
end )
