IncludeCS( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )

--[[
    States:
    0 - wait
    1 - playing
    2 - results
    3 - end
]]

util.AddNetworkString( "repix_AnimeTown_QuestionQuest.Players" )
util.AddNetworkString( "repix_AnimeTown_QuestionQuest.Menu" )
util.AddNetworkString( "repix_AnimeTown_QuestionQuest.Leave" )

function ENT:Initialize()
    self:SetModel( self.Model )
    self:PhysicsInit( SOLID_VPHYSICS )

    local physObj = self:GetPhysicsObject()
    if ( IsValid( physObj ) ) then
        physObj:Wake()
        -- physObj:Sleep()
        physObj:EnableMotion( false )
    end

    self:DrawShadow( false )

    self:SetState( 0 )
    self:SetQuestion( 0 )
    self:SetRound( 0 )
    self:SetTimeleft( 0 )

    self.Players = {}
    self.GameQuestions = {}
end

function ENT:BeginGame()
    -- Add questions to the game the way they can't repeat
    local questionTable = self.Questions
    for i = 1, 10 do
        local q = i
        if ( !table.HasValue( self.GameQuestions, q ) ) then
            table.insert( self.GameQuestions, q )
        end
    end

    self:SetQuestion( self.GameQuestions[ 1 ] )
    self:SetState( 1 )
    self:SetRound( 1 )
    self:SetTimeleft( UnPredictedCurTime() + 30 )

    timer.Remove( "repix_AnimeTown_QuestionQuest.RoundTimer" )
    timer.Create( "repix_AnimeTown_QuestionQuest.RoundTimer", 30, 1, function()
        if ( !IsValid( self ) ) then return end

        self:MoveNextRound()
    end )

    for _, ply in pairs( self.Players or {} ) do
        if ( !IsValid( ply ) ) then continue end

        net.Start( "repix_AnimeTown_QuestionQuest.Menu" )
        net.Send( ply )
    end
end

function ENT:EndGame()
    self:SetState( 0 )
    self:SetQuestion( 0 )
    self:SetRound( 0 )
    self:SetTimeleft( 0 )

    self.Players = {}
    self.GameQuestions = {}

    net.Start( "repix_AnimeTown_QuestionQuest.Players" )
        net.WriteEntity( self )
        net.WriteTable( self.Players )
    net.Broadcast()
end

function ENT:Leave( ply )
    if ( !table.HasValue( self.Players, ply ) ) then return end

    table.RemoveByValue( self.Players, ply )

    ply:SetNWBool( "repix_AnimeTown_QuestionQuest.Playing", false )
    ply:SetNWInt( "repix_AnimeTown_QuestionQuest.Score", 0 )
    ply:SetNWEntity( "repix_AnimeTown_QuestionQuest.Entity", nil )

    if ( #self.Players < 1 ) then
        self:EndGame()
    end

    net.Start( "repix_AnimeTown_QuestionQuest.Players" )
        net.WriteEntity( self )
        net.WriteTable( self.Players )
    net.Broadcast()
end

function ENT:Enter( ply )
    if ( table.HasValue( self.Players, ply ) ) then return end
    if ( #self.Players >= 3 ) then return end
    if ( self:GetState() ~= 0 ) then return end

    table.insert( self.Players, ply )

    ply:SetNWBool( "repix_AnimeTown_QuestionQuest.Playing", true )
    ply:SetNWInt( "repix_AnimeTown_QuestionQuest.Score", 0 )
    ply:SetNWEntity( "repix_AnimeTown_QuestionQuest.Entity", self )

    if ( #self.Players > 0 ) then
        self:BeginGame()
    end

    net.Start( "repix_AnimeTown_QuestionQuest.Players" )
        net.WriteEntity( self )
        net.WriteTable( self.Players )
    net.Broadcast()
end

function ENT:MoveNextRound()
    if ( self:GetRound() >= 10 ) then
        self:SetState( 3 )

        for _, ply in pairs( self.Players or {} ) do
            if ( IsValid( ply ) ) then
                ply:SetNWBool( "repix_AnimeTown_QuestionQuest.Playing", false )
                ply:SetNWInt( "repix_AnimeTown_QuestionQuest.Score", 0 )
                ply:SetNWEntity( "repix_AnimeTown_QuestionQuest.Entity", nil )
            end

            table.RemoveByValue( self.Players, ply )
        end

        timer.Simple( 5, function()
            if ( !IsValid( self ) ) then return end
            self:EndGame()
        end )

        return
    end

    self:SetRound( self:GetRound() + 1 )
    self:SetQuestion( self.GameQuestions[ self:GetRound() ] )
    self:SetState( 1 )
    self:SetTimeleft( UnPredictedCurTime() + 30 )

    timer.Remove( "repix_AnimeTown_QuestionQuest.RoundTimer" )
    timer.Create( "repix_AnimeTown_QuestionQuest.RoundTimer", 30, 1, function()
        if ( !IsValid( self ) ) then return end

        self:MoveNextRound()
    end )
end

net.Receive( "repix_AnimeTown_QuestionQuest.Leave", function( len, ply )
    if ( !IsValid( ply ) || !ply:IsPlayer() ) then return end

    local ent = ply:GetNWEntity( "repix_AnimeTown_QuestionQuest.Entity", nil )
    if ( !IsValid( ent ) ) then return end

    ent:Leave( ply )
end )

local pos = {
    [1] = { Vector( -3186.606201, -1417.889771, 207.549927 ), Angle( 90, -180, -90 ) }, -- screen
    [2] = { Vector( -3182.723877, -1579.272949, 136.714890 ), Angle( 0, -90, 0 ) } -- table
}
hook.Add( "InitPostEntity", "repix_AnimeTown_QuestionQuest", function()
    local screenEnt = ents.Create( "repix_questiongame" )
    screenEnt:SetPos( pos[1][1] )
    screenEnt:SetAngles( pos[1][2] )
    screenEnt:Spawn()

    local tableEnt = ents.Create( "repix_questiongame_table" )
    tableEnt:SetPos( pos[2][1] )
    tableEnt:SetAngles( pos[2][2] )
    tableEnt:Spawn()
    tableEnt.ScreenController = screenEnt
end )
