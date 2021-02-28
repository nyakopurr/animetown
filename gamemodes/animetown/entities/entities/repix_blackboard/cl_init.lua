include( "shared.lua" )

ENT.RenderGroup = RENDERGROUP_BOTH

surface.CreateFont( "AT_Blackboard", { font = "Roboto", size = 64, extended = true } )

function ENT:Draw()
    self:DrawModel()
end

function ENT:DrawTranslucent()
    if ( LocalPlayer():GetPos():DistToSqr( self:GetPos() ) > 512^2 ) then return end

    self.MarkupText = markup.Parse( "<font=AT_Blackboard>" .. self:GetWriting() .. "</font>", 1072 )
    cam.Start3D2D( self:LocalToWorld( Vector( 0.8, 0, 0 ) ), self:LocalToWorldAngles( Angle( 0, -90, 90 ) ), 0.08 )
        self.MarkupText:Draw( 0, -480, 1, 0 )
    cam.End3D2D()
end

net.Receive( "repix_AnimeTown_Blackboard", function()
    local ent = net.ReadEntity()
    if ( !IsValid( ent ) || ent:GetClass() ~= "repix_blackboard" ) then return end

    local frame = vgui.Create( "DFrame" )
    frame:SetSize( 647, 372 )
    frame:Center()
    frame:SetTitle( "Написать на доске" )
    frame:MakePopup()

    local textEntry = vgui.Create( "DTextEntry", frame )
    textEntry:SetPos( 26, 41 )
    textEntry:SetSize( frame:GetWide() - ( 26 * 2 ), frame:GetTall() - 41 - 60 )
    textEntry:SetMultiline( true )
    textEntry:SetText( ent:GetWriting() or "Классная работа" )

    local x = 174
    for i = 1, 2 do
        local btn = vgui.Create( "DButton", frame )
        btn:SetPos( x, frame:GetTall() - 41 - 11 )
        btn:SetSize( 137, 41 )
        btn:SetText( i == 1 and "Написать" or "Отмена" )
        btn.DoClick = function()
            if ( i == 2 ) then
                if ( ValidPanel( frame ) ) then
                    frame:Remove()
                    frame = nil
                end
            else
                net.Start( "repix_AnimeTown_Blackboard" )
                    net.WriteEntity( ent )
                    net.WriteString( textEntry:GetValue() )
                net.SendToServer()
            end
        end

        x = x + 137 + 26
    end
end )
