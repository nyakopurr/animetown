hook.Add( "CalcView", "repix_AnimeTown_Alcoholic", function( ply, pos, ang, fov )
    if ( ply:GetNWBool( "repix_AnimeTown_Alcoholic", false ) ) then
        return {
            origin = pos,
            angles = ang + Angle( math.sin( CurTime() * 2 ) * 2, 0, 0 ),
            fov = fov + ( math.cos( CurTime() * 2 ) * 2 )
        }
    end
end )

hook.Add( "RenderScreenspaceEffects", "repix_AnimeTown_Alcoholic", function()
    if ( LocalPlayer():GetNWBool( "repix_AnimeTown_Alcoholic", false ) ) then
       DrawColorModify( {
           [ "$pp_colour_addr" ] = 0.02,
           [ "$pp_colour_addg" ] = 0.02,
           [ "$pp_colour_addb" ] = 0,
           [ "$pp_colour_brightness" ] = 0,
           [ "$pp_colour_contrast" ] = LocalPlayer():GetNWInt( "repix_AnimeTown_AlcoholForce", 1 ),
           [ "$pp_colour_colour" ] = 3,
           [ "$pp_colour_mulr" ] = 0,
           [ "$pp_colour_mulg" ] = 0.02,
           [ "$pp_colour_mulb" ] = 0
       } )
    end
end )
