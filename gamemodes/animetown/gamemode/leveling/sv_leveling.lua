include( "sh_leveling.lua" )

AddCSLuaFile( "cl_leveling.lua" )
AddCSLuaFile( "sh_leveling.lua" )

local meta = FindMetaTable( "Player" )

function meta:SetLevel( val )
    if ( !val || type( val ) ~= "number" || val < 0 ) then
        return
    end

    self:SetNWInt( "repix_AnimeTown_Level", val )

    hook.Call( "OnLevelUp", GAMEMODE, self, val )

    if ( self.SaveLevel ) then
        self:SaveLevel()
    end
end

function meta:AddXP( val )
    if ( !val || type( val ) ~= "number" || val < 0 ) then
        return
    end

    self:SetNWInt( "repix_AnimeTown_XP", self:GetNWInt( "repix_AnimeTown_XP", 0 ) + val )

    hook.Call( "OnNewLevelProgress", GAMEMODE, self, val )

    if ( self.SaveLevel ) then
        self:SaveLevel()
    end

    -- Advance!
    if ( self:XP() >= ( 500 + ( math.floor( self:Level() * 100 ) ) ) ) then
        self:SetXP( 0 )
        self:SetLevel( self:Level() + 1 )
    end
end

function meta:SetXP( val )
    if ( !val || type( val ) ~= "number" || val < 0 ) then
        return
    end

    self:SetNWInt( "repix_AnimeTown_XP", val )

    if ( self.SaveLevel ) then
        self:SaveLevel()
    end

    -- Advance!
    if ( self:XP() >= ( 500 + ( math.floor( self:Level() * 100 ) ) ) ) then
        self:SetXP( 0 )
        self:SetLevel( self:Level() + 1 )
    end
end

function meta:SaveLevel()
    if ( self:IsBot() ) then return end

    sql.Query( "UPDATE repix_at_profiles SET Level = " .. tonumber( self:Level() ) .. ", XP = " .. tonumber( self:XP() ) .. " WHERE SteamID = " .. SQLStr( self:SteamID() ) )
end

-- hook.Add( "PlayerPostThink", "repix_AnimeTown_LevelUpdate", function( ply )
--     if ( IsValid( ply ) ) then
--         if ( ply.XP && ply.Level ) then
--             if ( ply:XP() >= ( 500 + ( math.floor( ply:Level() * 100 ) ) ) ) then
--                 ply:SetXP( 0 )
--                 ply:SetLevel( ply:Level() + 1 )
--             end
--         end
--     end
-- end )
