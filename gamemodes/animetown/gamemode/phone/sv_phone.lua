-- AddCSLuaFile( "cl_phone.lua" )

util.AddNetworkString( "repix_AnimeTown_PhoneCall" )
util.AddNetworkString( "repix_AnimeTown_PhoneMenu" )
util.AddNetworkString( "repix_AnimeTown_ChangeState" )

module( "phone", package.seeall )

function Call( caller, receiver )
    if ( !IsValid( caller ) ) then return end
    if ( !IsValid( receiver ) ) then return end
    if ( caller == receiver ) then return end

    local nwVar = "repix_AnimeTown_Calls_TalkingTo"
    if ( IsValid( caller:GetNWEntity( nwVar ) ) ) then
        return
    end

    if ( IsValid( receiver:GetNWEntity( nwVar ) ) ) then
        caller:ChatPrint( "Абонент недоступен: занято." )
        return
    end

    caller:SetNWEntity( nwVar, receiver )
    caller:SetNWString( "repix_AnimeTown_Calls_Type", "Calling" )

    if ( !caller:IsBot() ) then
        net.Start( "repix_AnimeTown_PhoneMenu" )
            net.WriteString( "Calling" )
        net.Send( caller )
    end

    if ( !IsValid( receiver:GetNWEntity( nwVar ) ) ) then
        receiver:SetNWEntity( nwVar, caller )
        receiver:SetNWString( "repix_AnimeTown_Calls_Type", "Called" )

        net.Start( "repix_AnimeTown_PhoneMenu" )
            net.WriteString( "Called" )
        net.Send( caller )
    end
end

function StopCall( ply )
    if ( !IsValid( ply ) ) then return end

    local ply2 = ply:GetNWEntity( "repix_AnimeTown_Calls_TalkingTo" )
    if ( IsValid( ply2 ) ) then
        ply2:SetNWEntity( "repix_AnimeTown_Calls_TalkingTo", nil )
        ply2:SetNWEntity( "repix_AnimeTown_Calls_Type", "None" )
        ply2:SetNWFloat( "repix_AnimeTown_Calls_CallTime", 0 )
    end

    ply:SetNWEntity( "repix_AnimeTown_Calls_TalkingTo", nil )
    ply:SetNWEntity( "repix_AnimeTown_Calls_Type", "None" )
    ply:SetNWFloat( "repix_AnimeTown_Calls_CallTime", 0 )
end

function AcceptCall( ply )
    if ( !IsValid( ply ) ) then return end

    local ply2 = ply:GetNWEntity( "repix_AnimeTown_Calls_TalkingTo" )
    if ( IsValid( ply2 ) ) then
        ply2:SetNWString( "repix_AnimeTown_Calls_Type", "InCall" )
        ply2:SetNWFloat( "repix_AnimeTown_Calls_CallTime", UnPredictedCurTime() )

        net.Start( "repix_AnimeTown_PhoneMenu" )
            net.WriteString( "InCall" )
        net.Send( ply2 )
    end

    ply:SetNWString( "repix_AnimeTown_Calls_Type", "InCall" )
    ply:SetNWFloat( "repix_AnimeTown_Calls_CallTime", UnPredictedCurTime() )

    net.Start( "repix_AnimeTown_PhoneMenu" )
        net.WriteString( "InCall" )
    net.Send( ply )
end

-- hook.Add( "PlayerButtonDown", "repix_AnimeTown_Phone.Calls", function( ply, btn )
--     if ( !IsValid( ply ) || !ply:IsPlayer() ) then return end
--
--     local callingTo = ply:GetNWEntity( "repix_AnimeTown_Calls_TalkingTo", nil )
--     if ( !IsValid( callingTo ) ) then return end
--
--     local state = ply:GetNWString( "repix_AnimeTown_Calls_Type", "None" )
--     if ( state == "None" ) then return end
--
--     if ( btn == KEY_F10 ) then
--         if ( state == "Called" ) then
--             AcceptCall( ply )
--         end
--     elseif ( btn == KEY_F11 ) then
--         StopCall( ply )
--     end
-- end )

net.Receive( "repix_AnimeTown_ChangeState", function( len, ply )
    if ( !IsValid( ply ) || !ply:IsPlayer() ) then return end

    local state = net.ReadString()
    if ( state == "stop" ) then
        StopCall( ply )
    elseif ( state == "accept" ) then
        AcceptCall( ply )
    end
end )

net.Receive( "repix_AnimeTown_PhoneCall", function( len, ply )
    if ( !IsValid( ply ) || !ply:IsPlayer() ) then return end

    local receiver = net.ReadEntity()
    if ( !IsValid( receiver ) || !receiver:IsPlayer() ) then return end
    Call( ply, receiver )
end )

hook.Add( "PlayerCanHearPlayersVoice", "repix_AnimeTown_Phone.Calls", function( listener, talker )
    if ( listener:GetNWEntity( "repix_AnimeTown_Calls_TalkingTo", nil ) == talker ) then
        return true
    end
end )
