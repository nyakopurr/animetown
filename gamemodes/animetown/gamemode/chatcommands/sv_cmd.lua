AddCSLuaFile( "cl_cmd.lua" )

util.AddNetworkString( "repix_AnimeTown_Advert" )
util.AddNetworkString( "repix_AnimeTown_OOC" )
util.AddNetworkString( "repix_AnimeTown_PM" )
util.AddNetworkString( "repix_AnimeTown_DiceRoll" )

module( "chatcommands", package.seeall )

List = {}

function New( id, cmd, action )
    List[ id ] = {
        Command = cmd,
        Act = action
    }
end

New( 1, { "ad", "advert" }, function( caller, arg )
    if ( ( caller.NextAdvertMessage or 0 ) < SysTime() ) then
        arg = table.concat( arg, " ", 2 )
        net.Start( "repix_AnimeTown_Advert" )
            net.WriteString( caller.RPNick and caller:RPNick() or caller:Nick() )
            net.WriteString( arg )
        net.Send( player.GetHumans() )

        caller.NextAdvertMessage = SysTime() + 120
    else
        caller:ChatPrint( "Вы недавно писали объявление. Подождите пару минут." )
    end
end )

New( 2, { "me" }, function( caller, arg )
    if ( ( caller.NextChatCmdAction or 0 ) < SysTime() ) then
        arg = table.concat( arg, " ", 2 )
        for _, ply in pairs( ents.FindInSphere( caller:GetPos(), 512 ) ) do
            if ( ply:IsPlayer() ) then
                ply:ChatPrint( ( caller.RPNick and caller:RPNick() or caller:Nick() ) .. " " .. arg )
            end
        end

        caller.NextChatCmdAction = SysTime() + 1
    else
        caller:ChatPrint( "Полегче..." )
    end
end )

New( 3, { "ooc", "/", "global", "everyone" }, function( caller, arg )
    local hasPremium = profile and profile.HasPremium( caller ) or false
    local delay = hasPremium and 2.5 or 5
    if ( ( caller.NextGlobalMessage or 0 ) < SysTime() ) then
        arg = table.concat( arg, " ", 2 )
        net.Start( "repix_AnimeTown_OOC" )
            net.WriteString( caller.RPNick and caller:RPNick() or caller:Nick() )
            net.WriteString( arg )
        net.Send( player.GetHumans() )

        caller.NextGlobalMessage = SysTime() + ( delay )
    else
        caller:ChatPrint( "Вы недавно писали в общий чат. Подождите " .. ( delay ) .. " секунд и отправьте сообщение снова." )
    end
end )

New( 4, { "pm", "ls", "message", "msg", "send", "call", "say" }, function( caller, arg )
    if ( ( caller.NextChatCmdAction or 0 ) < SysTime() ) then
        local receiver = nil
        if ( string.StartWith( arg[2], "STEAM_" ) ) then
            receiver = player.GetBySteamID( arg[2] )
        elseif ( isnumber( tonumber( arg[2] ) ) ) then
            receiver = Entity( tonumber( arg[2] ) )
        else
            for _, ply in pairs( player.GetHumans() ) do
                local name = ply.RPNick and ply:RPNick() or ply:Nick()
                if ( string.StartWith( string.lower( name ), string.lower( arg[2] ) ) ) then
                    receiver = ply
                    break
                end
            end
        end
        if ( IsValid( receiver ) ) then
            local msg = table.concat( arg, " ", 3 )
            net.Start( "repix_AnimeTown_PM" )
                net.WriteString( caller.RPNick and caller:RPNick() or caller:Nick() )
                net.WriteString( msg )
            net.Send( receiver )
        end

        caller.NextChatCmdAction = SysTime() + 1
    else
        caller:ChatPrint( "Это слишком..." )
    end
end )

New( 5, { "drop", "dropweapon", "throw", "throwweapon", "dropwep" }, function( caller, arg )
    if ( caller.GetActiveWeapon && IsValid( caller:GetActiveWeapon() ) ) then
        local forbiddenClasses = { "gmrp_hands", "weapon_physgun", "weapon_physcannon", "gmod_camera", "gmod_tool", "gmrp_handcuffs", "gmrp_zeus", "weapon_extinguisher" }

        local activeWeapon = caller:GetActiveWeapon()
        if ( table.HasValue( forbiddenClasses, activeWeapon:GetClass() ) ) then return end
        caller:DropWeapon( activeWeapon )
    end
end )

New( 6, { "selldoors", "sellalldoors", "unownalldoors", "unowndoors" }, function( caller, arg )
    local doors = 0
    for _, door in pairs( ents.GetAll() ) do
        if ( !( door:GetClass() == "prop_door_rotating" || door:GetClass() == "func_door" || door:GetClass() == "func_door_rotating" ) ) then continue end
        if ( door:GetNWString( "repix_AnimeTown_DoorOwner", "-" ) ~= caller:SteamID() ) then continue end
        door:SetNWString( "repix_AnimeTown_DoorOwner", "-" )

        doors = doors + 1
    end

    if ( caller.AddMoney ) then caller:AddMoney( math.floor( doors * 25 ) ) end

    caller:ChatPrint( "Продано " .. doors .. " дверей за " .. math.floor( doors * 25 ) .. "AT!" )
end )

New( 7, { "content", "workshop", "error", "errors", "collection" }, function( caller, arg )
    caller:ChatPrint( "[Steam Workshop Collection] https://steamcommunity.com/sharedfiles/filedetails/?id=878693050" )
end )

New( 8, { "rpname", "name", "roleplayname", "changename", "namechange" }, function( caller, arg )
    caller:ChatPrint( "[AnimeTown Profiles] Вы не можете изменить ролевое имя." )
end )

New( 9, { "discord", "dis", "discordserver", "discordgroup", "group", "steam", "vk", "vkontakte" }, function( caller, arg )
    caller:ChatPrint( "[AnimeTown Discord] Ищите нас здесь: https://discord.gg/zZhEtegke8/" )
end )

New( 10, { "it" }, function( caller, arg )
    if ( ( caller.NextChatCmdAction or 0 ) < SysTime() ) then
        arg = table.concat( arg, " ", 2 )
        for _, ply in pairs( ents.FindInSphere( caller:GetPos(), 512 ) ) do
            if ( ply:IsPlayer() ) then
                ply:ChatPrint( arg )
            end
        end

        caller.NextChatCmdAction = SysTime() + 1
    else
        caller:ChatPrint( "Попей колесики..." )
    end
end )

New( 11, { "roll", "dice", "rolladice", "rolldice", "diceroll", "r" }, function( caller, arg )
    if ( ( caller.NextChatCmdAction or 0 ) < SysTime() ) then
        arg = table.concat( arg, " ", 2 )
        local result = math.random( 0, 100 )
        for _, ply in pairs( ents.FindInSphere( caller:GetPos(), 512 ) ) do
            if ( ply:IsPlayer() ) then
                net.Start( "repix_AnimeTown_DiceRoll" )
                    net.WriteString( ply.RPNick and ply:RPNick() or ply:Nick() )
                    net.WriteString( result or 0 )
                net.Send( ply )
            end
        end

        caller.NextChatCmdAction = SysTime() + 1
    else
        caller:ChatPrint( "Остынь..." )
    end
end )

New( 12, { "stuck", "doorstuck", "stucked", "istuck", "застрял", "помогите" }, function( caller, arg )
    caller:ChatPrint( "[AnimeTown Helper] Застряли? Введите в консоли kill" )
end )

New( 13, { "@", "//", "$", "admins", "adm", "admin" }, function( caller, arg )
    arg = table.concat( arg, " ", 2 )
    for _, ply in pairs( player.GetHumans() ) do
        if ( caller == ply ) then continue end
        if ( ply:IsAdmin() ) then
            ply:ChatPrint( "[Админ Чат] " .. ( caller.RPNick and caller:RPNick() or caller:Nick() ) .. ": " .. arg )
        end
    end

    caller:ChatPrint( "[Админ Чат] " .. ( caller.RPNick and caller:RPNick() or caller:Nick() ) .. ": " .. arg )
end )

local function findCommand( cmd )
    if ( !cmd ) then return end

    for _, command in pairs( List or {} ) do
        if ( table.HasValue( command.Command, cmd ) ) then
            return command
        end
    end

    return nil
end

hook.Add( "PlayerSay", "RoleplayChatCommands", function( ply, msg )
    if ( !IsValid( ply ) ) then return end

    if ( string.StartWith( msg, "/" ) || string.StartWith( msg, "!" ) ) then
        local args = string.Explode( " ", msg )
        local cmd = findCommand( string.sub( args[1], 2 ) )
        if ( cmd ~= nil ) then
            if ( cmd.Act ) then cmd.Act( ply, args ) end

            return ""
        end
    end
end )
