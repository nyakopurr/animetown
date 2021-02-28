module( "accessories", package.seeall )

List = {
    ["Hats"] = {
        ["santa"] = {
            Model = "models/captainbigbutt/skeyler/hats/santa.mdl",
            Name = "Santa Hat"
        },
        ["pumpkin"] = {
            Model = "models/captainbigbutt/skeyler/hats/pumpkin.mdl",
            Name = "Pumpkin"
        },
        ["starband"] = {
            Model = "models/captainbigbutt/skeyler/hats/starband.mdl",
            Name = "Starband"
        },
        ["strawhat"] = {
            Model = "models/captainbigbutt/skeyler/hats/strawhat.mdl",
            Name = "Straw Hat"
        },
        ["sunhat"] = {
            Model = "models/captainbigbutt/skeyler/hats/sunhat.mdl",
            Name = "Sun Hat"
        },
        ["fedora"] = {
            Model = "models/captainbigbutt/skeyler/hats/fedora.mdl",
            Name = "Fedora"
        },
        ["frog"] = {
            Model = "models/captainbigbutt/skeyler/hats/frog_hat.mdl",
            Name = "Frog Hat"
        },
        ["cat"] = {
            Model = "models/captainbigbutt/skeyler/hats/cat_hat.mdl",
            Name = "Cat Hat"
        },
        ["bunny_ears"] = {
            Model = "models/captainbigbutt/skeyler/hats/bunny_ears.mdl",
            Name = "Bunny Ears"
        },
        ["cat_ears"] = {
            Model = "models/captainbigbutt/skeyler/hats/cat_ears.mdl",
            Name = "Cat Ears"
        },
        ["cowboy"] = {
            Model = "models/captainbigbutt/skeyler/hats/cowboyhat.mdl",
            Name = "Cowboy Hat"
        },
        ["party"] = {
            Model = "models/gmod_tower/partyhat.mdl",
            Name = "Party Hat"
        },
        ["sombrero"] = {
            Model = "models/gmod_tower/sombrero.mdl",
            Name = "Sombrero"
        },
        ["witch"] = {
            Model = "models/gmod_tower/witchhat.mdl",
            Name = "Witch Hat"
        },
        ["tophat"] = {
            Model = "models/gmod_tower/tophat.mdl",
            Name = "Top Hat"
        },
        ["headphones"] = {
            Model = "models/gmod_tower/headphones.mdl",
            Name = "Headphones"
        }
    },
    ["Glasses"] = {
        ["aviators"] = {
            Model = "models/captainbigbutt/skeyler/accessories/glasses04.mdl",
            Name = "Aviators"
        },
        ["glasses01"] = {
            Model = "models/captainbigbutt/skeyler/accessories/glasses01.mdl",
            Name = "Glasses 01"
        },
        ["glasses03"] = {
            Model = "models/captainbigbutt/skeyler/accessories/glasses03.mdl",
            Name = "Glasses 03"
        }
    },
    ["Scarfs"] = {
        ["red"] = {
            Model = "models/molly/cute/scarf.mdl",
            Name = "Red Scarf"
        }
    },
    ["Playermodels"] = {
        [1] = "models/pacagma/mmd/nanoko_2_urban/nanoko_2_urban_player.mdl",
        [2] = "models/pacagma/vocaloid/chemikarma_sd_miku/chemikarma_sd_miku_player.mdl",
        [3] = "models/pacagma/vocaloid/ia/ia_player.mdl",
        [4] = "models/pacagma/virtual_youtuber/ienaga_mugi/ienaga_mugi_player.mdl",
        [5] = "models/captainbigbutt/vocaloid/chibi_neru_ap.mdl",
        [6] = "models/captainbigbutt/vocaloid/chibi_miku_ap.mdl",
        [7] = "models/captainbigbutt/vocaloid/chibi_haku_ap.mdl",
    }
}

local meta = FindMetaTable( "Player" )

function meta:GetHat()
    return self:GetNWString( "repix_AnimeTown_Accessories.Hat", "no hat" )
end

function meta:GetGlasses()
    return self:GetNWString( "repix_AnimeTown_Accessories.Glasses", "no glasses" )
end

function meta:GetScarf()
    return self:GetNWString( "repix_AnimeTown_Accessories.Scarf", "no scarf" )
end

function meta:GetPremiumPlayerModel()
    return self:GetNWString( "repix_AnimeTown_Accessories.Playermodel", "no pm" )
end

function meta:GetAccessoriesOffset( t )
    local x, y, z, pitch, yaw, roll, scale = 0, 0, 0, 0, 0, 0, 1

    return { x = x, y = y, z = z, pitch = pitch, yaw = yaw, roll = roll, scale = scale }
end
