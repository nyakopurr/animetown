local baseMat = Material( "repix/animetown/profile/signup/base.png" )
local infoMat = Material( "repix/animetown/profile/signup/txt_info.png" )
local availableMat = Material( "repix/animetown/profile/signup/txt_available.png" )
local takenMat = Material( "repix/animetown/profile/signup/txt_taken.png" )

surface.CreateFont( "AT_Profile_SignUp", { font = "Rubik Medium", size = ScreenScale( 24 ) / 3, weight = 500, extended = true } )

module( "rpname", package.seeall )

NicknameAvailable = false

function Open()
    if ( ValidPanel( AT_SignupForm ) ) then
        AT_SignupForm:Remove()
        AT_SignupForm = nil
    end

    AT_SignupForm = vgui.Create( "EditablePanel" )
    AT_SignupForm:SetSize( SX( 493 ), SY( 538 ) )
    AT_SignupForm:Center()
    AT_SignupForm:MakePopup()
    AT_SignupForm.NameInput = nil
    AT_SignupForm.LastNameInput = nil
    AT_SignupForm.Paint = function( self, w, h )
        INTERFACE_SMOOTHING( 1920, 1080, function()
            surface.SetMaterial( baseMat )
            surface.SetDrawColor( 255, 255, 255 )
            surface.DrawTexturedRect( 0, 0, w, h )

            if ( self.NameInput:GetValue() ~= "" && self.LastNameInput:GetValue() ~= "" ) then
                if ( NicknameAvailable ) then
                    surface.SetMaterial( availableMat )
                    surface.DrawTexturedRect( SX( 125 ), SY( 282 ), SX( availableMat:Width() ), SY( availableMat:Height() ) )
                else
                    surface.SetMaterial( takenMat )
                    surface.DrawTexturedRect( SX( 135 ), SY( 282 ), SX( takenMat:Width() ), SY( takenMat:Height() ) )
                end
            else
                surface.SetMaterial( infoMat )
                surface.DrawTexturedRect( SX( 110 ), SY( 282 ), SX( infoMat:Width() ), SY( infoMat:Height() ) )
            end
        end )
    end

    local nameInput = vgui.Create( "DTextEntry", AT_SignupForm )
    nameInput:SetPos( SX( 125 ), SY( 129 ) )
    nameInput:SetSize( SX( 223 ), SY( 27 ) )
    nameInput:SetText( "" )
    nameInput:SetDrawLanguageID( false )
    nameInput:SetAllowNonAsciiCharacters( false )
    nameInput:SetFont( "AT_Profile_SignUp" )
    nameInput.Paint = function( self, w, h )
        self:DrawTextEntryText( Color( 255, 255, 255 ), Color( 0, 0, 0 ), Color( 255, 255, 255 ) )
    end
    nameInput.OnChange = function()
        surface.PlaySound( "repix/animetown/chatting/click-short.wav" )

        local nameResult = string.Trim( AT_SignupForm.NameInput:GetValue() ) .. " " .. string.Trim( AT_SignupForm.LastNameInput:GetValue() )
        net.Start( "repix_AnimeTown_CheckAvailability" )
            net.WriteString( nameResult )
        net.SendToServer()
    end

    local lastNameInput = vgui.Create( "DTextEntry", AT_SignupForm )
    lastNameInput:SetPos( SX( 125 ), SY( 231 ) )
    lastNameInput:SetSize( SX( 223 ), SY( 27 ) )
    lastNameInput:SetText( "" )
    lastNameInput:SetDrawLanguageID( false )
    lastNameInput:SetAllowNonAsciiCharacters( false )
    lastNameInput:SetFont( "AT_Profile_SignUp" )
    lastNameInput.Paint = function( self, w, h )
        self:DrawTextEntryText( Color( 255, 255, 255 ), Color( 0, 0, 0 ), Color( 255, 255, 255 ) )
    end
    lastNameInput.OnChange = function()
        surface.PlaySound( "repix/animetown/chatting/click-short.wav" )

        local nameResult = string.Trim( AT_SignupForm.NameInput:GetValue() ) .. " " .. string.Trim( AT_SignupForm.LastNameInput:GetValue() )
        net.Start( "repix_AnimeTown_CheckAvailability" )
            net.WriteString( nameResult )
        net.SendToServer()
    end
    AT_SignupForm.NameInput = nameInput
    AT_SignupForm.LastNameInput = lastNameInput

    local beginBtn = vgui.Create( "DButton", AT_SignupForm )
    beginBtn:SetPos( SX( 114 ), SY( 438 ) )
    beginBtn:SetSize( SX( 246 ), SY( 48 ) )
    beginBtn:SetText( "" )
    beginBtn.Paint = function() end
    beginBtn.DoClick = function()
        if ( NicknameAvailable ) then
            local nameResult = string.Trim( AT_SignupForm.NameInput:GetValue() ) .. " " .. string.Trim( AT_SignupForm.LastNameInput:GetValue() )
            net.Start( "repix_AnimeTown_RegisterProfile" )
                net.WriteString( nameResult )
            net.SendToServer()

            if ( ValidPanel( AT_SignupForm ) ) then
                AT_SignupForm:Remove()
                AT_SignupForm = nil
            end

            surface.PlaySound( "repix/animetown/chatting/check-on.mp3" )
        end
    end
end

net.Receive( "repix_AnimeTown_CheckAvailability", function()
    NicknameAvailable = net.ReadBool()
end )