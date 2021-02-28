surface.CreateFont( "AT_WeaponSelection", { font = "Rubik", size = 16, weight = 500, extended = true } )

local function SortWeaponTable( tbl )
    if ( !tbl ) then
        return
    end

    local WeaponListClient = {}

    for _, val in pairs( tbl ) do
        local slot = val:GetSlot()
        if ( slot >= 3 ) then continue end
        if ( !WeaponListClient[ slot ] ) then
            WeaponListClient[ slot ] = {}
        end

        local name = val:GetPrintName()
        table.insert( WeaponListClient[ slot ], { Name = name, Class = val:GetClass() } )
    end

    return WeaponListClient
end

local slot1Mat = Material( "repix/animetown/hud/wepsel/slot1.png" )
local slot2Mat = Material( "repix/animetown/hud/wepsel/slot2.png" )
local slot3Mat = Material( "repix/animetown/hud/wepsel/slot3.png" )
local wepMat = Material( "repix/animetown/hud/wepsel/weapon_idle.png" )
local wepActiveMat = Material( "repix/animetown/hud/wepsel/weapon_active.png" )

local keyToMat = {
    [1] = slot1Mat,
    [2] = slot2Mat,
    [3] = slot3Mat
}

local curWeapon = LocalPlayer().GetActiveWeapon and LocalPlayer():GetActiveWeapon():GetClass() or ""
local curSlot = 0
local curPos = 1
local switcherAlpha = 0
hook.Add( "HUDPaint", "GP_WeaponSwitch", function()
    if ( !IsValid( LocalPlayer() ) ) then return end
    if ( LocalPlayer():GetNWBool( "GP_SpawnView", false ) ) then return end
    if ( switcherAlpha <= 0 ) then
        return
    end

    surface.SetDrawColor( 255, 255, 255, switcherAlpha )

    local sortedWeaponTbl = SortWeaponTable( LocalPlayer():GetWeapons() )
    local x, y = ( ScrW() - ( ( ( 186 ) ) * table.Count( sortedWeaponTbl or {} ) ) ) / 2, 50
    local iter = 1
    for key, weap in SortedPairs( sortedWeaponTbl or {}, false ) do
        surface.SetDrawColor( 255, 255, 255, switcherAlpha )
        surface.SetMaterial( keyToMat[ key + 1 ] )
        surface.DrawTexturedRect( x, 30, slot1Mat:Width(), slot1Mat:Height() )
        for _, weapon in pairs( weap or {} ) do
            surface.SetDrawColor( 255, 255, 255, switcherAlpha )
            surface.SetMaterial( curWeapon == weapon.Class and wepActiveMat or wepMat )
            surface.DrawTexturedRect( x, y, wepMat:Width(), wepMat:Height() )

            local name = language.GetPhrase( weapon.Name )

            render.SetScissorRect( x, y, x + wepMat:Width(), y + 41, true )
                draw.SimpleText( string.upper( name ) or "Scripted Weapon", "AT_WeaponSelection", x + ( wepMat:Width() / 2 ), y + ( 41 / 2 ), Color( 255, 255, 255, switcherAlpha ), 1, 1 )
            render.SetScissorRect( 0, 0, 0, 0, false )

            y = y + 46
            iter = iter + 1
        end

        x = x + 186
        y = 50
        iter = 1
    end

    switcherAlpha = math.Approach( switcherAlpha, 0, FrameTime() * 25 )

    pcall( function()
        curWeapon = sortedWeaponTbl[ curSlot ][ curPos ].Class
    end )
end )

hook.Add( "PlayerBindPress", "GP_WeaponSwitch", function( ply, bind, pressed )
    local tbl = SortWeaponTable( LocalPlayer():GetWeapons() )
    if ( !pressed || ( ply:InVehicle() && !ply:GetAllowWeaponsInVehicle() ) ) then
        return
    end
    local activeWeapon = LocalPlayer().GetActiveWeapon and LocalPlayer():GetActiveWeapon() or nil
    if ( IsValid( activeWeapon ) ) then
        activeWeapon = { true, activeWeapon }
    end

    if ( bind:sub( 1, 4 ) == "slot" ) then
        local n = tonumber( bind:sub( 5, 5 ) or 1 ) or 1
        if ( n < 1 or n > 6 ) then return true end
        n = n - 1
        if ( !tbl[n] ) then return true end

        if ( curSlot == n && tbl[curSlot] ) then
            curPos = curPos + 1
            if ( curPos > #tbl[curSlot] ) then
				curPos = 1
			end
        else
            curSlot = n
            curPos = 1
        end

        switcherAlpha = 300

        return true
    elseif ( bind == "invnext" && istable( activeWeapon ) && activeWeapon[1] && !( activeWeapon[2]:GetClass() == "weapon_physgun" && ply:KeyDown( IN_ATTACK ) ) ) then
        curPos = curPos + 1

        if ( curPos > ( tbl[curSlot] and #tbl[curSlot] or -1 ) ) then
            repeat
				curSlot = curSlot + 1
				if ( curSlot > 5 ) then
					curSlot = 0
				end
			until tbl[curSlot]

			curPos = 1
		end

        switcherAlpha = 300

        return true
    elseif ( bind == "invprev" && istable( activeWeapon ) && activeWeapon[1] && !( activeWeapon[2]:GetClass() == "weapon_physgun" && ply:KeyDown( IN_ATTACK ) ) ) then
        curPos = curPos - 1

		if ( curPos < 1 ) then
			repeat
				curSlot = curSlot - 1
				if ( curSlot < 0 ) then
					curSlot = 5
				end
			until tbl[curSlot]

			curPos = #tbl[curSlot]
		end

        switcherAlpha = 300

        return true
    elseif ( bind == "+attack" && switcherAlpha > 0 ) then
        if ( tbl[curSlot] and tbl[curSlot][curPos] and tbl[curSlot][curPos].Class ) then
            input.SelectWeapon( LocalPlayer():GetWeapon( tbl[curSlot][curPos].Class ) )
        end

        switcherAlpha = 0

        return true
    end
end )
