GM.Name = "DarkRP"
GM.Author = "repix"
GM.Website = "N/A"
GM.FolderName = "animetown"

DeriveGamemode( "sandbox" )

RP_Teams = {}
LatestUpdate = "13.01.21"

local meta = FindMetaTable( "Player" )

function meta:RPNick()
    return self:GetNWString( "repix_AnimeTown_RoleplayNick", "-jiz-time-for-cheese-" )
end

function meta:Money()
    return self:GetNWInt( "repix_AnimeTown_Money", 0 )
end

function meta:Afford( amount )
    return self:Money() >= amount
end

function meta:Hunger()
    return self:GetNWInt( "repix_AnimeTown_Hunger", 100 )
end

if ( CLIENT ) then
    local mordredMat = Material( "repix/animetown/hud/jobs/characters/fate_mordred.png" )
    local ienagaMat = Material( "repix/animetown/hud/jobs/characters/ienaga_mugi.png" )
    local nurakamiMat = Material( "repix/animetown/hud/jobs/characters/yu_nurakami.png" )
    local jokerMat = Material( "repix/animetown/hud/jobs/characters/joker.png" )
    local makotoMat = Material( "repix/animetown/hud/jobs/characters/makoto_niijima.png" )
    local sakamotoMat = Material( "repix/animetown/hud/jobs/characters/ryuji_sakamoto.png" )
    local ionaMat = Material( "repix/animetown/hud/jobs/characters/iona2.png" )
    local futabaMat = Material( "repix/animetown/hud/jobs/characters/futaba_sakura.png" )
    local yusukeMat = Material( "repix/animetown/hud/jobs/characters/kitagawa_yusuke.png" )
    local takamakiMat = Material( "repix/animetown/hud/jobs/characters/ann_takamaki.png" )
    local togamiMat = Material( "repix/animetown/hud/jobs/characters/togami_byakuya.png" )
    local kawakamiMat = Material( "repix/animetown/hud/jobs/characters/sadayo_kawakami.png" )
    local iaMat = Material( "repix/animetown/hud/jobs/characters/ia.png" )
    local kaitoMat = Material( "repix/animetown/hud/jobs/characters/kaito_momota.png" )
    local sojiroMat = Material( "repix/animetown/hud/jobs/characters/sojiro_sakura.png" )
    local iwaiMat = Material( "repix/animetown/hud/jobs/characters/munehisa_iwai.png" )
    local mikuPoliceMat = Material( "repix/animetown/hud/jobs/characters/miku_police.png" )
    CharacterMaterials = {
        ["models/pacagma/fate_grand_order/mordred/mordred_player.mdl"] = mordredMat,
        ["models/pacagma/virtual_youtuber/ienaga_mugi/ienaga_mugi_player.mdl"] = ienagaMat,
        ["models/cyanblue/persona4/yu_narukami/yunarukami.mdl"] = nurakamiMat,
        ["models/persona_nk/joker/joker_p5.mdl"] = jokerMat,
        ["models/persona_nk/makotoqueen/makoto_p5.mdl"] = { makotoMat, 0, 65 },
        ["models/persona_nk/ryuji/ryuji_p5.mdl"] = { sakamotoMat, 0, 65 },
        ["models/jazzmcfly/kantai/iona/iona.mdl"] = { ionaMat, 0, -25 },
        ["models/player/tfa_p5_futaba.mdl"] = { futabaMat, 0, 25 },
        ["models/persona_nk/yusuke/yusuke_p5.mdl"] = { yusukeMat, 0, 25 },
        ["models/persona_nk/anne/anne_p5.mdl"] = { takamakiMat, 0, 25 },
        ["models/custom/byakuya_togami.mdl"] = { togamiMat, 0, 35 },
        ["models/persona_nk/sadayo/sadayo_p5.mdl"] = { kawakamiMat, 0, 35 },
        ["models/pacagma/vocaloid/ia/ia_player.mdl"] = { iaMat, 0, 20 },
        ["models/player/dewobedil/danganronpa/kaito_momota/default_p.mdl"] = { kaitoMat, 0, -35 },
        ["models/player/dewobedil/persona/sojiro_sakura/default_p.mdl"] = { sojiroMat, 0, 35 },
        ["models/player/dewobedil/persona5/munehisa_iwai/default_p.mdl"] = { iwaiMat, 0, 40 },
        ["models/player/miku_cop_p.mdl"] = { mikuPoliceMat, 0, -30 },
    }
end
