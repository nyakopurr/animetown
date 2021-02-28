local baseMat = Material( "repix/animetown/phone/call_base.png" )
local incomingCallMat = Material( "repix/animetown/phone/incoming_call.png" )
local outgoingCallMat = Material( "repix/animetown/phone/outgoing_call.png" )
local callDeclineMat = Material( "repix/animetown/phone/call_decline.png" )
local callAcceptMat = Material( "repix/animetown/phone/call_accept.png" )

surface.CreateFont( "AT_Phone_Caller", { font = "Rubik Medium", size = 14, weight = 500, extended = true } )

module( "phone", package.seeall )

function Open( state )
    if ( state == "None" ) then return end

    if ( ValidPanel( AT_PhoneGUI ) ) then
        AT_PhoneGUI:Remove()
        AT_PhoneGUI = nil
    end

    local typeOfCall = "incoming"
    if ( state == "InCall" ) then
        typeOfCall = "in"
    elseif ( state == "Called" ) then
        typeOfCall = "outgoing"
    else
        typeOfCall = "incoming"
    end

    AT_PhoneGUI = vgui.Create( "EditablePanel" )
    AT_PhoneGUI:SetPos( 50, 486 )
    AT_PhoneGUI:SetSize( 206, 126 )
    AT_PhoneGUI.Paint = function( self, w, h )
        surface.SetMaterial( baseMat )
        surface.SetDrawColor( 255, 255, 255 )
        surface.DrawTexturedRect( 0, 0, w, h )

        if ( typeOfCall == "outgoing" ) then
            surface.SetMaterial( outgoingCallMat )
            surface.SetDrawColor( 255, 255, 255 )
            surface.DrawTexturedRect( ( w - outgoingCallMat:Width() ) / 2, 12, outgoingCallMat:Width(), outgoingCallMat:Height() )
        elseif ( typeOfCall == "incoming" ) then
            surface.SetMaterial( incomingCallMat )
            surface.SetDrawColor( 255, 255, 255 )
            surface.DrawTexturedRect( ( w - incomingCallMat:Width() ) / 2, 12, incomingCallMat:Width(), incomingCallMat:Height() )
        else -- in call
            local time = LocalPlayer():GetNWFloat( "repix_AnimeTown_Calls_CallTime", 0 ) - UnPredictedCurTime()
            local text = "На связи (" .. string.ToMinutesSeconds( math.abs( time ) ) .. ")"
            draw.SimpleText( text, "AT_Phone_Caller", w / 2, 12, Color( 255, 255, 255 ), 1 )
        end

        local callerPly = LocalPlayer():GetNWEntity( "repix_AnimeTown_Calls_TalkingTo", nil )
        local name = "Unknown Unknown"
        if ( IsValid( callerPly ) ) then
            local name = callerPly:Nick()
            if ( callerPly.RPNick && callerPly:RPNick() ~= "-jiz-time-for-cheese-" ) then
                name = callerPly:RPNick()
            end
        end

        draw.SimpleText( name, "AT_Phone_Caller", w / 2, 47, Color( 255, 255, 255 ), 1 )
    end

    if ( typeOfCall == "outgoing" || typeOfCall == "in" ) then
        local replyBtn = vgui.Create( "DButton", AT_PhoneGUI )
        replyBtn:SetPos( ( AT_PhoneGUI:GetWide() - 39 ) / 2, 73 )
        replyBtn:SetSize( 39, 39 )
        replyBtn:SetText( "" )
        replyBtn.Paint = function( self, w, h )
            surface.SetMaterial( callDeclineMat )
            surface.SetDrawColor( 255, 255, 255 )
            surface.DrawTexturedRect( 0, 0, w, h )
        end
        replyBtn.DoClick = function()
            if ( ValidPanel( AT_PhoneGUI ) ) then
                AT_PhoneGUI:Remove()
                AT_PhoneGUI = nil
            end

            net.Start( "repix_AnimeTown_ChangeState" )
                net.WriteString( "stop" )
            net.SendToServer()
        end
    else
        local x = 53
        for i = 1, 2 do
            local replyBtn = vgui.Create( "DButton", AT_PhoneGUI )
            replyBtn:SetPos( x, 73 )
            replyBtn:SetSize( 39, 39 )
            replyBtn:SetText( "" )
            replyBtn.Paint = function( self, w, h )
                surface.SetMaterial( i == 1 and callAcceptMat or callDeclineMat )
                surface.SetDrawColor( 255, 255, 255 )
                surface.DrawTexturedRect( 0, 0, w, h )
            end
            replyBtn.DoClick = function()
                if ( ValidPanel( AT_PhoneGUI ) ) then
                    AT_PhoneGUI:Remove()
                    AT_PhoneGUI = nil
                end

                net.Start( "repix_AnimeTown_ChangeState" )
                    net.WriteString( i == 1 and "accept" or "stop" )
                net.SendToServer()
            end

            x = x + 39 + 20
        end
    end
end

net.Receive( "repix_AnimeTown_PhoneMenu", function()
    local state = net.ReadString()
    Open( state )
end )