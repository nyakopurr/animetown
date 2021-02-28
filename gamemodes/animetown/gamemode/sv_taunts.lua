util.AddNetworkString( "repix_AnimeTown_PlayTaunt" )

module( "taunts", package.seeall )

local List = {
    [1] = "ba-bakaa.mp3",
    [2] = "muda-muda.mp3",
    [3] = "nyaa.mp3",
    [4] = "tuturuu.mp3",
    [5] = "yare-yare-daze.mp3",
    [6] = "za-warudo.mp3",
    [7] = "yes-yes-yes-yes.mp3",
    [8] = "wow.mp3",
}

net.Receive( "repix_AnimeTown_PlayTaunt", function( len, ply )
    if ( !IsValid( ply ) || !ply:IsPlayer() ) then return end
    if ( ( ply.NextTauntPlay or 0 ) > SysTime() ) then
        ply:ChatPrint( "Подождите, прежде чем проигрывать звук снова." )
        return
    end

    local num = net.ReadInt( 8 )
    if ( !isnumber( num ) ) then return end
    if ( num > table.Count( List ) || num < 1 ) then return end

    local snd = "repix/animetown/chatting/taunts/" .. List[ num ]
    local vol = 1 -- some of them are way too loud, this is needed
    if ( num == 5 ) then vol = 0.25 end
    if ( num == 6 ) then vol = 0.15 end
    if ( num == 4 ) then vol = 0.15 end

    ply:EmitSound( snd, nil, nil, vol )

    ply.NextTauntPlay = SysTime() + 120.0
end )
