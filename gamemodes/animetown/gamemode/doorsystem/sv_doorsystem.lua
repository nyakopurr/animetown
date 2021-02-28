include( "sh_doorsystem.lua" )

AddCSLuaFile( "sh_doorsystem.lua" )
AddCSLuaFile( "cl_doorsystem.lua" )

local school = {
    Vector( -4004.910400, -2626.044189, -602.695435 ), Vector( -676.003113, 1351.330322, 1853.399048 )
}

local police = {
    Vector( 3887.575195, -3956.474609, -154.781174 ), Vector( 4558.771484, -5397.467285, 617.051086 )
}

hook.Add( "InitPostEntity", "repix_AnimeTown_Doorsystem", function()
    for _, ent in pairs( ents.FindInBox( police[1], police[2] ) ) do
        if ( ent:GetClass() == "prop_door_rotating" || ent:GetClass() == "func_door" ) then
            ent:SetNWString( "repix_AnimeTown_Property", "Полицейский участок" )
        end
    end

    for _, ent in pairs( ents.FindInBox( school[1], school[2] ) ) do
        if ( ent:GetClass() == "func_door_rotating" ) then
            ent:SetNWString( "repix_AnimeTown_Property", "Школа" )
        end
    end
end )

hook.Add( "PlayerButtonDown", "repix_AnimeTown_DoorSystem", function( ply, btn )
    if ( !IsValid( ply ) || !ply:IsPlayer() ) then return end
    local ent = ply:GetEyeTrace().Entity
    if ( IsValid( ent ) && ( ent:GetClass() == "prop_door_rotating" || ent:GetClass() == "func_door" || ent:GetClass() == "func_door_rotating" ) && ent:GetPos():DistToSqr( ply:GetPos() ) < 128^2 ) then
        local owner = ent:GetNWString( "repix_AnimeTown_DoorOwner", "-" )
        if ( owner == "-" || !IsValid( player.GetBySteamID( owner ) ) ) then
            if ( ent:GetNWString( "repix_AnimeTown_Property", "-" ) == "-" ) then
                if ( btn == KEY_F2 ) then
                    if ( ply:Afford( 50 ) ) then
                        ent:SetNWString( "repix_AnimeTown_DoorOwner", ply:SteamID() )

                        ply:AddMoney( -50 )
                    else
                        ply:ChatPrint( "Недостаточно средств, чтобы приобрести дверь." )
                    end
                end
            end
        end
        if ( owner == ply:SteamID() || ( ent:GetNWString( "repix_AnimeTown_Property", "-" ) == "Полицейский участок" && ply:Team() == 5 ) || ( ent:GetNWString( "repix_AnimeTown_Property", "-" ) == "Школа" && ply:Team() == 2 ) ) then
            if ( btn == KEY_F2 ) then
                ent:SetNWString( "repix_AnimeTown_DoorOwner", "-" )

                ply:AddMoney( 35 )
            elseif ( btn == KEY_R ) then
                if ( ent:GetInternalVariable( "m_bLocked" ) ) then
                    ent:Fire( "UnLock" )
                    ent:EmitSound( "npc/metropolice/gear" .. math.random( 3, 4 ) .. ".wav", 100, math.random( 90, 110 ) )
                else
                    ent:Fire( "Lock" )
                    ent:EmitSound( "npc/metropolice/gear" .. math.random( 1, 2 ) .. ".wav", 100, math.random( 90, 110 ) )
                end
            end
        end
    end
end )
