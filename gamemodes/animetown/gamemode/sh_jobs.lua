local function newJob( data )
    if ( !data ) then return end

    table.insert( RP_Teams, {
        Id = data.Id,
        Name = data.Name,
        Models = data.Models,
        PlayerSpawn = data.PlayerSpawn,
        MaxSlots = data.Slots,
        HUDMaterial = data.HUDMaterial
    } )
end

local meta = FindMetaTable( "Player" )

function meta:GetJob()
    return RP_Teams[ self:Team() ]
end

local StudentModels = {
    "models/pacagma/fate_grand_order/mordred/mordred_player.mdl",
    "models/persona_nk/ryuji/ryuji_p5.mdl",
    "models/persona_nk/makotoqueen/makoto_p5.mdl",
    "models/jazzmcfly/kantai/iona/iona.mdl",
    "models/persona_nk/joker/joker_p5.mdl",
    "models/player/tfa_p5_futaba.mdl",
    "models/persona_nk/yusuke/yusuke_p5.mdl",
    "models/CyanBlue/Persona4/Yu_Narukami/YuNarukami.mdl",
    "models/persona_nk/anne/anne_p5.mdl",
}

local TeacherModels = {
    "models/persona_nk/sadayo/sadayo_p5.mdl",
}

local BarmenModels = {
    "models/player/dewobedil/persona/sojiro_sakura/default_p.mdl",
    "models/player/dewobedil/danganronpa/kaito_momota/default_p.mdl"
}

local IllegalStuffModels = {
    "models/player/dewobedil/persona5/munehisa_iwai/default_p.mdl",
}

local PoliceModels = {
    "models/player/miku_cop_p.mdl",
}

local studentMat = Material( "repix/animetown/hud/jobs/student.png" )
local student2Mat = Material( "repix/animetown/hud/jobs/student2.png" )
local mastermindMat = Material( "repix/animetown/hud/jobs/mastermind.png" )
local bartenderMat = Material( "repix/animetown/hud/jobs/bartender.png" )
local dealerMat = Material( "repix/animetown/hud/jobs/dealer.png" )
local policeMat = Material( "repix/animetown/hud/jobs/police.png" )
local mathMat = Material( "repix/animetown/hud/jobs/teacher_math.png" )
local peMat = Material( "repix/animetown/hud/jobs/teacher_pe.png" )
local itMat = Material( "repix/animetown/hud/jobs/teacher_it.png" )
local ruMat = Material( "repix/animetown/hud/jobs/teacher_russian.png" )
local lMat = Material( "repix/animetown/hud/jobs/teacher_nativenot.png" )
local physMat = Material( "repix/animetown/hud/jobs/teacher_physics.png" )

newJob( { Id = 1, Name = "Школьник", Color = Color( 168, 224, 99 ),
Models = StudentModels, HUDMaterial = studentMat } )

newJob( { Id = 2, Name = "Директор школы", Color = Color( 168, 224, 99 ),
Models = { "models/custom/byakuya_togami.mdl" }, HUDMaterial = mastermindMat, Limit = 1 } )

newJob( { Id = 3, Name = "Бармен", Color = Color( 168, 224, 99 ),
Models = BarmenModels, HUDMaterial = bartenderMat, Limit = 2 } )

newJob( { Id = 4, Name = "Торговец", Color = Color( 168, 224, 99 ),
Models = IllegalStuffModels, HUDMaterial = dealerMat, Limit = 2 } )

newJob( { Id = 5, Name = "Офицер полиции", Color = Color( 168, 224, 99 ),
Models = PoliceModels, HUDMaterial = policeMat } )

newJob( { Id = 6, Name = "Учитель математики", Color = Color( 168, 224, 99 ),
Models = TeacherModels, HUDMaterial = mathMat, Limit = 1 } )

newJob( { Id = 7, Name = "Учитель физкультуры", Color = Color( 168, 224, 99 ),
Models = TeacherModels, HUDMaterial = peMat, Limit = 1 } )

newJob( { Id = 8, Name = "Учитель информатики", Color = Color( 168, 224, 99 ),
Models = TeacherModels, HUDMaterial = itMat, Limit = 1 } )

newJob( { Id = 9, Name = "Учитель русского языка", Color = Color( 168, 224, 99 ),
Models = TeacherModels, HUDMaterial = ruMat, Limit = 1 } )

newJob( { Id = 10, Name = "Учитель иностранного языка", Color = Color( 168, 224, 99 ),
Models = TeacherModels, HUDMaterial = lMat, Limit = 1 } )

newJob( { Id = 11, Name = "Учитель физики", Color = Color( 168, 224, 99 ),
Models = TeacherModels, HUDMaterial = physMat, Limit = 1 } )

local tvMat = Material( "repix/animetown/f4menu/items/tv.png" )
local mpMat = Material( "repix/animetown/f4menu/items/money_printer.png" )
local bubbleTeaMat = Material( "repix/animetown/f4menu/items/bubbletea.png" )
local bubbleGunMat = Material( "repix/animetown/f4menu/items/bubblegun.png" )
local vapeMat = Material( "repix/animetown/f4menu/items/vape.png" )
local wineMat = Material( "repix/animetown/f4menu/items/wine_bottle.png" )
local wineGlassMat = Material( "repix/animetown/f4menu/items/wine_glass.png" )

RP_Buyables = {
    [1] = {
        Name = "Bubble Tea",
        Price = 250,
        Material = bubbleTeaMat,
        OnBought = function( ply )
            local pos = ply:GetShootPos() + ( ply:GetForward() * 100 )

            local drinkEnt = ents.Create( "repix_drink" )
            drinkEnt.Model = Model( "models/prop/bubble_tea_large.mdl" )
            drinkEnt.Regenerate = 50
            drinkEnt:SetSkin( math.random( 0, 4 ) )
            drinkEnt:SetPos( pos )
            drinkEnt:Spawn()

            local phys = drinkEnt:GetPhysicsObject()
            if ( IsValid( phys ) ) then
                phys:AddVelocity( drinkEnt:GetUp() * 2 )
            end
        end,
        CanSee = { 3 }
    },
    [2] = {
        Name = "Bubble Gun",
        Price = 750,
        Material = bubbleGunMat,
        OnBought = function( ply )
            ply:Give( "repix_bubblegun" )
        end,
        CanSee = { 4 }
    },
    [3] = {
        Name = "Vape",
        Price = 1500,
        Material = vapeMat,
        OnBought = function( ply )
            ply:Give( "weapon_vape" )
        end,
        CanSee = { 4 }
    },
    [4] = {
        Name = "Wine Bottle",
        Price = 800,
        Material = wineMat,
        OnBought = function( ply )
            local pos = ply:GetShootPos() + ( ply:GetForward() * 100 )

            local drinkEnt = ents.Create( "repix_drink" )
            drinkEnt.Model = Model( "models/alaxe/tf2/props/expiration_date/expiration_date/spy_appartment/wine_bottle.mdl" )
            drinkEnt.Regenerate = 100
            drinkEnt.IsAlcohol = true
            drinkEnt:SetPos( pos )
            drinkEnt:Spawn()

            local phys = drinkEnt:GetPhysicsObject()
            if ( IsValid( phys ) ) then
                phys:AddVelocity( drinkEnt:GetUp() * 2 )
            end
        end,
        CanSee = { 3 }
    },
    [5] = {
        Name = "Wine Glass",
        Price = 300,
        Material = wineGlassMat,
        OnBought = function( ply )
            local pos = ply:GetShootPos() + ( ply:GetForward() * 100 )

            local drinkEnt = ents.Create( "repix_drink" )
            drinkEnt.Model = Model( "models/alaxe/tf2/props/expiration_date/expiration_date/spy_appartment/wine_glass.mdl" )
            drinkEnt.Regenerate = 70
            drinkEnt.IsAlcohol = true
            drinkEnt:SetPos( pos )
            drinkEnt:Spawn()

            local phys = drinkEnt:GetPhysicsObject()
            if ( IsValid( phys ) ) then
                phys:AddVelocity( drinkEnt:GetUp() * 2 )
            end
        end,
        CanSee = { 3 }
    },
    -- [6] = {
    --     Name = "TV",
    --     Price = 5000,
    --     Material = tvMat,
    --     OnBought = function()
    --         -- TODO
    --     end,
    --     CanSee = "all"
    -- },
    [6] = {
        Name = "Money Printer",
        Price = 3000,
        Material = mpMat,
        OnBought = function( ply )
            local pos = ply:GetShootPos() + ( ply:GetForward() * 100 )

            local printEnt = ents.Create( "repix_printer" )
            printEnt:SetPos( pos )
            printEnt:Spawn()
            printEnt:SetNWString( "GModRP_Prop_Owner", ply:SteamID() )
            printEnt:SetPrinterOwner( ply )

            local phys = printEnt:GetPhysicsObject()
            if ( IsValid( phys ) ) then
                phys:AddVelocity( printEnt:GetUp() * 2 )
            end
        end,
        CanSee = "all!police"
    },
}
