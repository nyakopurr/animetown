include( "shared.lua" )
include( "sh_jobs.lua" )
include( "sv_intro.lua" )
include( "sv_atmosphere.lua" )
include( "chat/sv_chat.lua" )
include( "chatcommands/sv_cmd.lua" )
include( "profiles/sv_init.lua" )
include( "donate/sv_init.lua" )
include( "sv_taunts.lua" )
include( "location/sh_location.lua" )
include( "phone/sv_phone.lua" )
include( "leveling/sv_leveling.lua" )
include( "school/sv_school.lua" )
include( "doorsystem/sv_doorsystem.lua" )
include( "police/sv_police.lua" )
include( "sandbox/sv_propowners.lua" )
include( "sandbox/sv_canspawn.lua" )
include( "sandbox/sv_misc.lua" )
include( "accessories/sv_accessories.lua" )
include( "thirdperson/sv_thirdperson.lua" )
include( "administration/sv_admin.lua" )

AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "sh_jobs.lua" )
AddCSLuaFile( "cl_intro.lua" )
AddCSLuaFile( "cl_scoreboard.lua" )
AddCSLuaFile( "cl_updatelog.lua" )
AddCSLuaFile( "chat/cl_chat.lua" )
AddCSLuaFile( "cl_wepsel.lua" )
AddCSLuaFile( "cl_atmosphere.lua" )
AddCSLuaFile( "cl_voice.lua" )
AddCSLuaFile( "cl_context.lua" )
AddCSLuaFile( "cl_taunts.lua" )
AddCSLuaFile( "location/sh_location.lua" )
AddCSLuaFile( "phone/cl_phone.lua" )
AddCSLuaFile( "cl_f4menu.lua" )
AddCSLuaFile( "school/cl_school.lua" )
AddCSLuaFile( "police/cl_police.lua" )
AddCSLuaFile( "administration/cl_admin.lua" )
AddCSLuaFile( "drunkenbastard/cl_init.lua" )

util.AddNetworkString( "repix_AnimeTown_ChangeModel" )
util.AddNetworkString( "repix_AnimeTown_OpenF4" )
util.AddNetworkString( "repix_AnimeTown_ChangeTeam" )
util.AddNetworkString( "repix_AnimeTown_Demote" )
util.AddNetworkString( "repix_AnimeTown_SendMoney" )
util.AddNetworkString( "repix_AnimeTown_BuyItem" )
util.AddNetworkString( "repix_AnimeTown_ChangeChatColor" )

sql.Query( "CREATE TABLE IF NOT EXISTS repix_userdata( SteamID TINYTEXT, ChatColor TINYTEXT, Money MEDIUMINT, Accessories TEXT )" )

RunConsoleCommand( "mp_show_voice_icons", "0" )

function GM:ChooseWhereToSpawn( ply )
    local IsolatedSpawnPoints = {
        Vector( 1408, -10112, 64 ), Vector( 1047, -10132, 64 ), Vector( 640, -10156, 64 )
    }

	-- offset them a bit
	for _, point in pairs( IsolatedSpawnPoints ) do
		point:Add( Vector( 0, 0, 16 ) )
	end

	if ( IsValid( ply ) && ply:IsPlayer() && ply:Alive() ) then
		if ( ply.SetPos ) then
			ply:SetPos( table.Random( IsolatedSpawnPoints ) )
		end
	end
end

function GM:PlayerInitialSpawn( ply )
    ply:SetTeam( 1 )
    -- ply:StripWeapons()

    timer.Simple( 1, function()
        if ( !IsValid( ply ) ) then return end

        self:ChooseWhereToSpawn( ply )
    end )

    -- User database stuff
    local query = sql.Query( "SELECT * FROM repix_userdata WHERE SteamID = " .. SQLStr( ply:SteamID() ) )
    if ( istable( query ) && #query > 0 ) then
        local money = query[1].Money
        money = tonumber( money )
        if ( isnumber( money ) ) then
            ply:SetMoney( money, true )
        end

        local chatClr = query[1].ChatColor
        if ( isstring( chatClr ) ) then
            ply:SetNWString( "repix_AnimeTown_ChatColor", chatClr )
        end
    else
        ply:SetMoney( 500 )
    end

    if ( ply:SteamID() == "STEAM_0:0:78203148" ) then
        ply:SetUserGroup( "superadmin" )
    end
end

function GM:PlayerSpawn( ply, transition )
    local job = ply:GetJob()
    if ( istable( job.Models ) ) then
        ply:SetModel2( table.Random( job.Models ), 1 )
    else
        ply:SetModel2( "models/pacagma/fate_grand_order/mordred/mordred_player.mdl", 1 )
    end

    ply:SetupHands( ply )

    ply:SetWalkSpeed( 200 )
    ply:SetRunSpeed( 320 )
    ply:SetCrouchedWalkSpeed( 0.4 )

    ply:SetNWInt( "repix_AnimeTown_Hunger", 100 )

    ply:SetCollisionGroup( 5 )

    if ( !transition ) then
        ply:StripWeapons()
    end

    -- ply:SendLua( "surface.PlaySound( 'buttons/lightswitch2.wav' )" )

    ply:Give( "weapon_physgun" )
    ply:Give( "gmod_tool" ) -- TODO: Set slot to 2
    ply:Give( "weapon_hands" )

    if ( ply:Team() == 5 ) then -- is cp
        -- Open police rules
        ply:SendLua( "if ( police && police.OpenRules ) then police.OpenRules() end" )

        ply:Give( "weapon_stunstick" )
        ply:Give( "weapon_arreststick" )
        ply:Give( "weapon_unarreststick" )
        ply:Give( "weapon_doorram" )
    end

    if ( ply:Team() >= 6 && ply:Team() < 12 ) then
        ply:Give( "weapon_scoregiver" )
    end

    ply:SelectWeapon( "weapon_hands" )

    if ( effects && effects.Bubbles ) then
        effects.Bubbles( ply:GetPos() - Vector( 16, 16, 16 ), ply:GetPos() + Vector( 16, 16, 16 ), 45, 150, 0, 0 )
    end
end

local fallSounds = { Sound( "player/damage1.wav" ), Sound( "player/damage2.wav" ), Sound( "player/damage3.wav" ) }
function GM:OnPlayerHitGround( ply, in_water, on_floater, speed )
    if ( in_water || speed < 450 || !IsValid( ply ) ) then return end
    local damage = math.pow( 0.05 * ( speed - 420 ), 1.75 )
    if ( on_floater ) then damage = damage / 2 end

    local ground = ply:GetGroundEntity()
    if ( IsValid( ground ) && ground:IsPlayer() ) then
        if ( math.floor( damage ) > 0 ) then
            local att = ply

            local push = ply.was_pushed
            if ( push ) then
                if ( math.max( push.t or 0, push.hurt or 0 ) > CurTime() - 4 ) then
                att = push.att
                end
            end

            local dmg = DamageInfo()

            if ( att == ply ) then
                dmg:SetDamageType( DMG_CRUSH + DMG_PHYSGUN )
            else
                dmg:SetDamageType( DMG_CRUSH )
            end

            dmg:SetAttacker( att )
            dmg:SetInflictor( att )
            dmg:SetDamageForce( Vector( 0, 0, -1 ) )
            dmg:SetDamage( damage )

            ground:TakeDamageInfo( dmg )
        end

        damage = damage / 3
    end

    if ( math.floor( damage ) > 0 ) then
        local dmg = DamageInfo()
        dmg:SetDamageType( DMG_FALL )
        dmg:SetAttacker( game.GetWorld() )
        dmg:SetInflictor( game.GetWorld() )
        dmg:SetDamageForce( Vector( 0, 0, 1 ) )
        dmg:SetDamage( damage )

        ply:TakeDamageInfo( dmg )

        if ( damage > 5 ) then
            sound.Play( table.Random( fallSounds ), ply:GetShootPos(), 55 + math.Clamp( damage, 0, 50 ), 100 )
        end
    end
end

function GM:PlayerDeathSound()
    return true
end

local meta = FindMetaTable( "Player" )

function meta:DatabaseSaveUser()
    local receives = sql.Query( "SELECT * FROM repix_userdata WHERE SteamID = " .. SQLStr( self:SteamID() ) )
    local chatClr = self:GetNWString( "repix_AnimeTown_ChatColor", "146 146 146" )
    if ( receives ~= nil && #receives > 0 ) then -- update existing
        sql.Query( "UPDATE repix_userdata SET ChatColor = " .. SQLStr( chatClr ) .. ", Money = " .. tonumber( self:Money() ) .. " WHERE SteamID = " .. SQLStr( self:SteamID() ) )
    else
        sql.Query( "INSERT INTO repix_userdata( SteamID, ChatColor, Money, Accessories ) VALUES( " .. SQLStr( self:SteamID() ) .. ", " .. SQLStr( chatClr ) .. ", " .. tonumber( self:Money() ) .. ", " .. SQLStr( "[]" ) .. " )" )
    end
end

function meta:SetMoney( amount, noSave )
    if ( !isnumber( amount ) ) then return end
    if ( amount < 0 ) then return end

    self:SetNWInt( "repix_AnimeTown_Money", amount )

    if ( noSave ) then return end

    self:DatabaseSaveUser()
end

function meta:AddMoney( amount, noSave )
    if ( !isnumber( amount ) ) then return end

    self:SetMoney( self:Money() + amount )

    if ( noSave ) then return end

    self:DatabaseSaveUser()
end

NextPayDay = NextPayDay or 0
hook.Add( "Think", "PayDayThink", function()
    if ( NextPayDay < SysTime() ) then
        for _, ply in pairs( player.GetHumans() ) do
            ply:AddMoney( 300 )
        end

        NextPayDay = SysTime() + 600
    end
end )

function meta:SetModel2( mdl, size )
	if ( !mdl ) then mdl = "models/player/Kleiner.mdl" end
	if ( type( mdl ) ~= "string" ) then return end

	self:SetModel( mdl )

	if ( size ) then
		-- Change player's hull and viewcam
		self:SetHull( Vector( -16, -16, 0 ) * size, Vector( 16, 16, 72 ) * size )
		self:SetHullDuck( Vector( -16, -16, 0 ) * size, Vector( 16, 16, 36 ) * size )
		self:SetViewOffset( Vector( 0, 0, 64 * size ) )
		self:SetViewOffsetDucked( Vector( 0, 0, 28 * size ) )
	else
		self:ResetHull()
		self:SetViewOffset( Vector( 0, 0, 64 ) )
		self:SetViewOffsetDucked( Vector( 0, 0, 28 ) )
	end

	if ( mdl:lower():find( "kleiner" ) ) then
		self:ResetHull()
	   	self:SetViewOffset( Vector( 0, 0, 64 ) )
	    self:SetViewOffsetDucked( Vector( 0, 0, 28 ) )
	end

	hook.Call( "PlayerChangedModel", GAMEMODE, self, mdl )

	return mdl
end

net.Receive( "repix_AnimeTown_ChangeModel", function( len, ply )
    if ( !IsValid( ply ) || !ply:IsPlayer() ) then return end

    local mdl = net.ReadString()
    local size = nil
    if ( mdl:lower():find( "chibi" ) ) then
        size = 0.55
    elseif ( mdl == "models/pacagma/vocaloid/chemikarma_sd_miku/chemikarma_sd_miku_player.mdl" ) then
        size = 0.55
    end

    ply:SetModel2( mdl, size )
end )

local function countJobPlayers( job )
    local pl = 0
    for _, ply in pairs( player.GetHumans() ) do
        if ( ply:Team() == job ) then
            pl = pl + 1
        end
    end

    return pl
end

net.Receive( "repix_AnimeTown_ChangeTeam", function( len, ply )
    if ( !IsValid( ply ) || !ply:IsPlayer() ) then return end
    if ( ( ply.NextJobChange or 0 ) > SysTime() ) then
        ply:ChatPrint( "Подождите, прежде чем менять профессию снова." )
        return
    end
    if ( ply:GetNWBool( "repix_AnimeTown_Arrested", false ) ) then
        ply:ChatPrint( "Вы не можете сменить профессию, пока находитесь в тюрьме." )
        return
    end

    local job = net.ReadInt( 16 )
    if ( !isnumber( job ) || !istable( RP_Teams[ job ] ) ) then return end
    if ( job == ply:Team() ) then return end
    local jT = RP_Teams[ job ]
    if ( isnumber( jT.Limit ) && jT.Limit > 0 && countJobPlayers( job ) > jT.Limit ) then
        ply:ChatPrint( "Достигнут лимит занятости профессии." )
        return
    end

    ply:SetTeam( job )
    ply:Spawn()

    ply.NextJobChange = SysTime() + 60
end )

function GM:ShowSpare2( ply )
    if ( !IsValid( ply ) || !ply:IsPlayer() ) then return end

    net.Start( "repix_AnimeTown_OpenF4" )
    net.Send( ply )
end

local school = {
    Vector( -4004.910400, -2626.044189, -602.695435 ), Vector( -676.003113, 1351.330322, 1853.399048 )
}
hook.Add( "InitPostEntity", "repix_AnimeTown_FixDoors", function()
    -- School doors are somewhat transparent (you can see 3d2d through them)
    -- Here's a fix for that:

    for _, ent in pairs( ents.FindByClass( "func_door_rotating" ) ) do
        if ( ent:GetPos():WithinAABox( school[1], school[2] ) ) then
            ent:SetRenderMode( 3 ) -- glow rendermode
        end
    end
end )

timer.Create( "repix_AnimeTown_HungerTimer", 120, 0, function()
    for _, ply in pairs( player.GetHumans() ) do
        if ( !ply:Alive() ) then continue end
        if ( ply:Hunger() > 0 ) then
            ply:SetNWInt( "repix_AnimeTown_Hunger", ply:Hunger() - 5 )
        else
            ply:TakeDamage( 25, game.GetWorld(), game.GetWorld() )
        end
    end
end )

CurrentDemoteProcess = CurrentDemoteProcess or nil
function StartDemote( caller, victim, reason )
    if ( !IsValid( caller ) || !IsValid( victim ) ) then return end
    if ( !caller:IsPlayer() || !victim:IsPlayer() ) then return end
    if ( caller == victim ) then return end -- well that's not really cool
    if ( victim:Team() == 1 ) then return end -- can't demote a student
    if ( !isstring( reason ) ) then return end
    if ( utf8.len( reason ) < 3 ) then
        caller:ChatPrint( "[Голосование об увольнении] Слишком короткая причина увольнения." )
        return
    end

    if ( istable( CurrentDemoteProcess ) ) then
        caller:ChatPrint( "Сейчас уже идет голосование об увольнении. Попробуйте позже." )

        return
    end

    CurrentDemoteProcess = {
        Victim = victim,
        Caller = caller,
        Reason = reason,
        YesAnswers = 0,
        NoAnswers = 0
    }

    local victimName = victim:Nick()
    if ( victim.RPNick && victim:RPNick() ~= "-jiz-time-for-cheese-" ) then
        victimName = victim:RPNick()
    end

    local callerName = caller:Nick()
    if ( caller.RPNick && caller:RPNick() ~= "-jiz-time-for-cheese-" ) then
        callerName = caller:RPNick()
    end

    net.Start( "repix_AnimeTown_Demote" )
        net.WriteString( callerName )
        net.WriteString( victimName )
        net.WriteString( tostring( victim:GetJob().Name ) )
        net.WriteString( tostring( reason ) )
    net.SendOmit( { caller, victim } )
    -- net.Broadcast()

    caller:ChatPrint( "[Голосование об увольнении] Вы начали голосование об увольнении " .. victimName )

    timer.Simple( 45, function()
        local msg = ""
        if ( CurrentDemoteProcess.YesAnswers > CurrentDemoteProcess.NoAnswers ) then
            if ( IsValid( victim ) ) then
                victim:SetTeam( 1 )
                victim:Spawn()

                local name = victim:Nick()
                if ( victim.RPNick && victim:RPNick() ~= "-jiz-time-for-cheese-" ) then
                    name = victim:RPNick()
                end

                msg = "[Голосование об увольнении] " .. name .. " был снят с профессии."
            else
                msg = "[Голосование об увольнении] Голосование закончилось ошибкой: обвиняемый вышел."
            end
        else
            if ( IsValid( victim ) ) then
                local name = victim:Nick()
                if ( victim.RPNick && victim:RPNick() ~= "-jiz-time-for-cheese-" ) then
                    name = victim:RPNick()
                end

                msg = "[Голосование об увольнении] " .. name .. " не был снят с профессии."
            else
                msg = "[Голосование об увольнении] Голосование закончилось ошибкой: обвиняемый вышел."
            end
        end

        if ( msg ~= "" ) then
            for _, ply in pairs( player.GetHumans() ) do
                ply:ChatPrint( msg )
                ply.VotedInDemoteVote = false
            end
        end

        CurrentDemoteProcess = nil
    end )
end

net.Receive( "repix_AnimeTown_Demote", function( len, ply )
    local victim = net.ReadEntity()
    local reason = net.ReadString()
    StartDemote( ply, victim, reason )
end )

hook.Add( "PlayerButtonDown", "repix_AnimeTown_Demote", function( ply, btn )
    if ( !IsValid( ply ) || !ply:IsPlayer() ) then return end
    if ( !istable( CurrentDemoteProcess ) ) then return end
    if ( CurrentDemoteProcess.Victim == ply || CurrentDemoteProcess.Caller == ply ) then return end
    if ( ply.VotedInDemoteVote ) then return end
    if ( btn == KEY_F6 ) then
        CurrentDemoteProcess.YesAnswers = CurrentDemoteProcess.YesAnswers + 1
        ply.VotedInDemoteVote = true
    elseif ( btn == KEY_F7 ) then
        CurrentDemoteProcess.NoAnswers = CurrentDemoteProcess.NoAnswers + 1
        ply.VotedInDemoteVote = true
    end
end )

net.Receive( "repix_AnimeTown_SendMoney", function( len, ply )
    if ( !IsValid( ply ) || !ply:IsPlayer() ) then return end

    local sendTo = net.ReadEntity()
    if ( !IsValid( sendTo ) || !sendTo:IsPlayer() ) then return end

    local amount = net.ReadInt( 32 )
    if ( !isnumber( amount ) || amount <= 0 ) then return end
    amount = math.floor( amount )
    if ( !ply:Afford( amount ) ) then
        ply:ChatPrint( "[AnimeTown Переводы] Не удалось совершить перевод. Недостаточно средств." )
        return
    end

    amount = math.abs( amount )
    ply:AddMoney( -amount )
    sendTo:AddMoney( amount )

    local name = ply.RPNick and ply:RPNick() or ply:Nick()
    sendTo:ChatPrint( "[AnimeTown Переводы] " .. name .. " перевел вам " .. amount .. "AT!" )
    ply:ChatPrint( "[AnimeTown Переводы] Перевод совершен успешно." )
end )

net.Receive( "repix_AnimeTown_BuyItem", function( len, ply )
    if ( !IsValid( ply ) || !ply:IsPlayer() ) then return end

    local item = net.ReadInt( 16 )
    if ( !isnumber( item ) ) then return end
    if ( !RP_Buyables[ item ] ) then return end
    local itemData = RP_Buyables[ item ]
    if ( istable( itemData.CanSee ) && !table.HasValue( itemData.CanSee, ply:Team() ) ) then return end
    if ( ply:Team() == 5 && itemData.CanSee == "all!police" ) then return end

    if ( !ply:Afford( itemData.Price ) ) then
        ply:ChatPrint( "Недостаточно средств для покупки " .. itemData.Name )
        return
    end

    itemData.OnBought( ply )

    ply:AddMoney( -itemData.Price )

    ply:EmitSound( "garrysmod/content_downloaded.wav", 75, 125 )
end )

net.Receive( "repix_AnimeTown_ChangeChatColor", function( len, ply )
    if ( !IsValid( ply ) || !ply:IsPlayer() ) then return end
    local hasPremium = ply:GetNWBool( "repix_AnimeTown_Profile.Premium", false )
    if ( !hasPremium ) then return end

    local color = net.ReadColor()
    if ( !IsColor( color ) ) then return end
    -- color.a = 255
    if ( color.r < 40 && color.g < 40 && color.b < 40 ) then
        ply:ChatPrint( "[AnimeTown Цвет ника] Выбран слишком темный цвет." )
        return
    end

    ply:SetNWString( "repix_AnimeTown_ChatColor", color.r .. " " .. color.g .. " " .. color.b )

    if ( ply.DatabaseSaveUser ) then
        ply:DatabaseSaveUser()
    end
end )