-- clientside module

module( "atmosphere", package.seeall )

SoundList = {
    ["windyforest"] = { "repix/animetown/ambient/windyforest.mp3", 200.4 },
    ["smallstream"] = { "repix/animetown/ambient/smallstream.mp3", 70.8 },
    ["waterfall"] = { "repix/animetown/ambient/waterfall.mp3" },
    ["evening"] = { "repix/animetown/ambient/evening.mp3" },
    ["afternoon"] = { "repix/animetown/ambient/afternoon.mp3", 202.2 },
    ["cicadas"] = { "repix/animetown/ambient/cicadas.mp3", 202.8 },
}

Locations = {
    -- { "smallstream", Vector( -1890.046021, -5521.359375, -220.403076 ), Vector( -1276.203369, -3877.500732, 436.436584 ) },
    -- { "cicadas", Vector( 4570.721680, -7462.837402, -366.633179 ), Vector( 9505.075195, -3156.031494, 1755.972412 ) },
    -- { "cicadas", Vector( 5790.645996, -3209.586914, -263.772797 ), Vector( 342.637543, -797.197693, 1269.989258 ) },
	-- { "windyforest", Vector( 2079.030518, -7592.595215, -64.673340 ), Vector( 1578.314209, -7090.221191, 458.135010 ) },
	-- { "windyforest", Vector( 780.343933, -7116.437500, -97.613220 ), Vector( 3952.799561, -6533.496094, 621.690247 ) },
	-- { "smallstream", Vector( 2002.319824, -7006.297852, -482.411743 ), Vector( 3520.378418, -5938.854980, -5.103909 ) },
}

for _, loc in pairs( Locations or {} ) do
    OrderVectors( loc[2], loc[3] )
end

Enable = CreateClientConVar( "at_soundscape", "1", true, false )
Volume = CreateClientConVar( "at_soundscape_volume", "20", true, false )

CurID = ""
LastID = ""

IsPlaying = false

CurSoundscape = nil
CurSoundscapeTime = nil
CurSoundscapeEndTime = 0

CurSoundscapeVolume = 20

CurSoundscapeFading = false
CurSoundscapeFadingVolume = 0

BackgroundMusicList = {
    "oku_no_in.mp3", "sayonara_sun.mp3", "forestoflostsouls.mp3",
    "kimono_of_tears.mp3", "shadeofthesunflower.mp3"
}
BackgroundMusicObject = BackgroundMusicObject or nil
NextBackgroundMusicPlay = NextBackgroundMusicPlay or 0

function atmosphere:SetupBGM( id )
    if ( !self.Enable:GetBool() ) then return end

    local scapeData = self:GetSoundscapeData( id )

    self.SoundscapeData = scapeData
	self.CurID = id
	self.CurSoundscape = CreateSound( LocalPlayer(), scapeData[ 1 ] )
	self.CurSoundscapeTime = scapeData[ 2 ]
end

function atmosphere:GetSoundscapeData( id )
	local scapeData = self.SoundList[ id ]

	return scapeData
end

function atmosphere:PlayBGM( volume )
	if ( !self.Enable:GetBool() ) then return end
	if ( !self.CurSoundscape ) then return end

	self.CurSoundscape:Stop()
	self.CurSoundscape:PlayEx( volume or 1, 100 )
	self.CurSoundscapeVolume = volume or 1

	self.IsPlaying = true

	self.CurSoundscapeEndTime = CurTime() + self.SoundscapeData[ 2 ]
end

function atmosphere:ThinkBGM()
	-- if ( !self.CurSoundscape ) then return end

	if ( !self.Enable:GetBool() ) then
		self:StopBGM()
        return
	end

	if ( CurTime() > self.CurSoundscapeEndTime ) then
		self:PlayBGM()
	end

	self:ThinkBGMFade()

    -- Background Music Think
    if ( LocalPlayer():GetNWBool( "repix_AnimeTown_Intro", false ) ) then
        if ( IsValid( self.BackgroundMusicObject ) ) then
            self.BackgroundMusicObject:Stop()
            self.BackgroundMusicObject = nil
        end

        self.NextBackgroundMusicPlay = 0

        return
    end
    if ( self.NextBackgroundMusicPlay < CurTime() ) then
        if ( IsValid( self.BackgroundMusicObject ) ) then
            self.BackgroundMusicObject:Stop()
            self.BackgroundMusicObject = nil
        end

        sound.PlayFile( "sound/repix/animetown/ambient/music/" .. table.Random( self.BackgroundMusicList ), "", function( audio )
            if ( IsValid( audio ) ) then
                audio:SetVolume( 0.007 )

                self.BackgroundMusicObject = audio
            end
        end )

        self.NextBackgroundMusicPlay = CurTime() + math.random( 620, 32000 )
    end
end

function atmosphere:ThinkBGMFade()
	if ( !self.CurSoundscapeFading ) then return end
	if ( self.CurSoundscapeFadingVolume ~= self.CurSoundscapeVolume ) then
		local volume = self.CurSoundscapeVolume or 0
		local fadeVolume = self.CurSoundscapeFadingVolume or 0

		volume = math.Approach( volume, fadeVolume, .0015 )
		self:SetVolumeBGM( volume )

		if ( volume == 0 ) then
			self.CurSoundscape = nil
		end
	else
		self.CurSoundscapeFading = false
	end
end

function atmosphere:FadeInBGM( volume )
	if ( !self.Enable:GetBool() ) then return end
	if ( !self.CurSoundscape ) then return end

	self:PlayBGM( 0 )

	self.CurSoundscapeFading = true
	self.CurSoundscapeFadingVolume = volume
end

function atmosphere:SetDefaultBGM( id )
	self:SetupBGM( id )
	self:FadeInBGM( self.Volume:GetInt() * .01 )
end

function atmosphere:SetVolumeBGM( volume )
	if ( !self.Enable:GetBool() ) then return end
	if ( !self.CurSoundscape ) then return end

	self.CurSoundscapeVolume = volume
	self.CurSoundscape:ChangeVolume( volume, 0 )
end

function atmosphere:FadeOutBGM()
	if ( !self.Enable:GetBool() ) then return end
	if ( !self.CurSoundscape ) then return end
	if ( !self.CurSoundscape:IsPlaying() ) then return end

	self.CurSoundscape:FadeOut( 1 )
end

function atmosphere:StopBGM()
	if ( !self.CurSoundscape ) then return end

	self.CurSoundscape:Stop()
	self.CurSoundscape = nil
	self.IsPlaying = false
	self.LastID = self.CurID

    if ( IsValid( self.BackgroundMusicObject ) ) then
        self.BackgroundMusicObject:Stop()
        self.BackgroundMusicObject = nil
    end
end

function atmosphere:Location()
	if ( self.Enable:GetBool() ) then
		local pos = LocalPlayer():GetPos()
		local nextScape = ""
		for id, tbl in pairs( self.Locations or {} ) do
			if ( pos:WithinAABox( tbl[2], tbl[3] ) ) then
				nextScape = tbl[1]
			end
		end
		
		if ( self.CurID == nextScape ) then return end

		if ( nextScape ~= "" ) then
			self:SetDefaultBGM( nextScape )
		else
			if ( self.IsPlaying ) then
				self:FadeOutBGM()
			end
		end
	end
end

hook.Add( "Think", "repix_AnimeTown_SoundscapeThink", function()
	atmosphere:Location()
	atmosphere:ThinkBGM()
end )

-- local DynamicLights = {
--     { 1458, Vector( 2161.402832, -5360.152344, 159.361954 ), Color( 255, 75, 75 ) },
--     { 1459, Vector( 1596.988159, -6002.314453, 170.991272 ), Color( 255, 255, 255 ) }
-- }

-- hook.Add( "PostDrawTranslucentRenderables", "repix_AnimeTown_DynamicLights", function()
--     for _, light in pairs( DynamicLights or {} ) do
--         local dlight = DynamicLight( light[1] )
--         if ( dlight ) then
--             dlight.pos = light[2]
--             dlight.r = light[3].r
--             dlight.g = light[3].g
--             dlight.b = light[3].b
--             dlight.brightness = 5
--             dlight.Decay = 1000
--             dlight.Size = 512
--             dlight.DieTime = CurTime() + 1
--         end
--     end
-- end )
