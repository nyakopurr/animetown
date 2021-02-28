module( "chatcommands", package.seeall )

net.Receive( "repix_AnimeTown_Advert", function()
    local name = net.ReadString()
    local msg = net.ReadString()
    chat.AddText( Color( 255, 75, 75 ), "[Объявление] " .. tostring( name ) .. ": ", Color( 253, 200, 48 ), tostring( msg ) )
end )

net.Receive( "repix_AnimeTown_OOC", function()
    local name = net.ReadString()
    local msg = net.ReadString()
    chat.AddText( Color( 146, 146, 146 ), tostring( name ), Color( 124, 198, 66 ), " -> Всем", Color( 255, 255, 255 ), ": " .. tostring( msg ) )

    surface.PlaySound( "repix/animetown/chatting/pop.ogg" )
end )

net.Receive( "repix_AnimeTown_DiceRoll", function()
    local name = net.ReadString()
    local result = net.ReadString()

    chat.AddText( Color( 255, 255, 255 ), "[AnimeTown Roll-a-Dice] ", Color( 255, 84, 99 ), tostring( name ) .. " выпало " .. result )
end )

net.Receive( "repix_AnimeTown_PM", function()
    local name = net.ReadString()
    local msg = net.ReadString()

    chat.AddText( Color( 173, 209, 0 ), "[ЛС] " .. tostring( name ) .. ": ", Color( 250, 250, 250 ), tostring( msg ) )
end )
