-- Prop Hunt: Enhanced events that happen randomly


-- Check if we are using Prop Hunt!
if ( engine.ActiveGamemode() != "prop_hunt" ) then print( "[PH:E Events] Error> Not running Prop Hunt." ) return end

-- Print this to signify we have passed PH check
print( "[PH:E Events] Success> Prop Hunt is active." )

-- Create this ConVar to determine if we want events enabled or not
local ph_events_enabled = CreateConVar( "ph_events_enabled", "1", { FCVAR_NOTIFY, FCVAR_ARCHIVE }, "Enable PH:E Events." )

-- Stop if ConVar is false
if ( !ph_events_enabled:GetBool() ) then print( "[PH:E Events] Stopped> ph_events_enabled is false." ) return end

-- Let us do lottery and see if we should enable the event or not
if ( math.random( 1, 10 ) > 2 ) then print( "[PH:E Events] Stopped> Lost lottery." ) return end

-- Print this to signify we won lottery
print( "[PH:E Events] Started> Won lottery." )


-- Create this ConCommand for forced events
concommand.Add( "ph_events_force", function( ply )

	if ( IsValid( ply ) ) then
	
		if ( !PHEEVENTS_BOOLEAN_EventAboutToStart && ply:IsAdmin() ) then
		
			PHEEVENTS_BOOLEAN_EventAboutToStart = true
			BroadcastLua( "chat.AddText( Color( 255, 215, 0 ), \"[Events]\", Color( 255, 255, 255 ), \" An event is starting after this round.\" )" )
		
		end
	
	else
	
		if ( !PHEEVENTS_BOOLEAN_EventAboutToStart ) then
		
			PHEEVENTS_BOOLEAN_EventAboutToStart = true
			BroadcastLua( "chat.AddText( Color( 255, 215, 0 ), \"[Events]\", Color( 255, 255, 255 ), \" An event is starting after this round.\" )" )
		
		end
	
	end

end )


-- Initialize stuff here
function PHEEVENTS_Initialize()

	PHEEVENTS_BOOLEAN_EventRound = false
	PHEEVENTS_BOOLEAN_EventAboutToStart = false
	PHEEVENTS_INT_EventID = 0
	PHEEVENTS_INT_EventRound = math.random( 3, 5 )
	PHEEVENTS_CSOUNDPATCH_Music = nil
	PHEEVENTS_TABLE_TeamPropsPlayers = {}
	PHEEVENTS_TABLE_TeamHuntersPlayers = {}

	-- Warn if we are not in PHE
	if ( !PHE ) then print( "[PH:E Events] Warning> Prop Hunt is not the Enhanced version. This addon will not work!" ) end

end
hook.Add( "Initialize", "PHEEVENTS_Initialize", PHEEVENTS_Initialize )


-- Player spawns
function PHEEVENTS_PlayerSpawn( ply )

	-- Event one
	if ( PHEEVENTS_BOOLEAN_EventRound && ( PHEEVENTS_INT_EventID == 1 ) ) then
	
		-- Hunters
		timer.Simple( 0.1, function()
		
			if ( IsValid( ply ) && ( ply:Team() == TEAM_HUNTERS ) ) then
			
				ply:RemoveAllItems()
				ply:Give( "weapon_crowbar" )
				ply:SetRunSpeed( 300 )
			
			end
		
		end )
	
	end

	-- Event two
	if ( PHEEVENTS_BOOLEAN_EventRound && ( PHEEVENTS_INT_EventID == 2 ) ) then
	
		-- Props
		timer.Simple( 0.1, function()
		
			if ( IsValid( ply ) && ( ply:Team() == TEAM_PROPS ) ) then
			
				ply:RemoveAllItems()
				ply:SetRunSpeed( 500 )
			
			end
		
		end )
	
	end

	-- Event three
	if ( PHEEVENTS_BOOLEAN_EventRound && ( PHEEVENTS_INT_EventID == 3 ) ) then
	
		-- Hunters
		timer.Simple( 0.1, function()
		
			if ( IsValid( ply ) && ( ply:Team() == TEAM_HUNTERS ) ) then
			
				ply:RemoveAllItems()
				ply:SetRunSpeed( 400 )
			
			end
		
		end )
	
	end

	-- Event four
	if ( PHEEVENTS_BOOLEAN_EventRound && ( PHEEVENTS_INT_EventID == 4 ) ) then
	
		-- Hunters
		timer.Simple( 0.1, function()
		
			if ( IsValid( ply ) && ( ply:Team() == TEAM_HUNTERS ) ) then
			
				ply:RemoveAllItems()
				ply:Give( "weapon_crowbar" )
				ply:SetRunSpeed( 400 )
			
			end
		
		end )
	
	end

end
hook.Add( "PlayerSpawn", "PHEEVENTS_PlayerSpawn", PHEEVENTS_PlayerSpawn )


-- Player death
function PHEEVENTS_PlayerDeath( ply )

	-- Event one
	if ( PHEEVENTS_BOOLEAN_EventRound && ( PHEEVENTS_INT_EventID == 1 ) ) then
	
		-- Hunters
		timer.Simple( 2, function()
		
			if ( PHEEVENTS_BOOLEAN_EventRound && IsValid( ply ) && ( ply:Team() == TEAM_HUNTERS ) ) then
			
				ply:Spawn()
			
			end
		
		end )
	
	end

	-- Event three
	if ( PHEEVENTS_BOOLEAN_EventRound && ( PHEEVENTS_INT_EventID == 3 ) ) then
	
		-- Hunters
		timer.Simple( 2, function()
		
			if ( PHEEVENTS_BOOLEAN_EventRound && IsValid( ply ) && ( ply:Team() == TEAM_HUNTERS ) ) then
			
				ply:Spawn()
			
			end
		
		end )
	
	end

end
hook.Add( "PlayerDeath", "PHEEVENTS_PlayerDeath", PHEEVENTS_PlayerDeath )


-- Event music
function PHEEVENTS_SetMusic( file )

	local filter
	filter = RecipientFilter()
	filter:AddAllPlayers()

	if ( PHEEVENTS_CSOUNDPATCH_Music ) then PHEEVENTS_CSOUNDPATCH_Music:Stop() end

	PHEEVENTS_CSOUNDPATCH_Music = CreateSound( game.GetWorld(), file, filter )
	if ( PHEEVENTS_CSOUNDPATCH_Music ) then
	
		PHEEVENTS_CSOUNDPATCH_Music:SetSoundLevel( 0 )
		PHEEVENTS_CSOUNDPATCH_Music:Play()
	
	end

	return PHEEVENTS_CSOUNDPATCH_Music

end


-- Determine the event to play
function PHEEVENTS_DetermineEvent()

	PHEEVENTS_INT_EventID = math.random( 1, 4 )
	if ( PHE.HUNTER_BLINDLOCK_TIME ) then PHE.HUNTER_BLINDLOCK_TIME = 0 BroadcastLua( "PHE.HUNTER_BLINDLOCK_TIME = "..PHE.HUNTER_BLINDLOCK_TIME ) end

	-- Event choosing
	if ( PHEEVENTS_INT_EventID == 1 ) then
	
		-- Doll Hunt
		for _, ply in pairs( team.GetPlayers( TEAM_PROPS ) ) do
		
			table.insert( PHEEVENTS_TABLE_TeamPropsPlayers, ply )
			ply:SetTeam( TEAM_HUNTERS )
			ply:Spawn()
		
		end
	
		for _, ent in pairs( ents.FindByClass( "prop_physics*" ) ) do
		
			local dollspawner = ents.Create( "pheevents_dollspawner" )
			dollspawner:SetPos( ent:GetPos() )
			dollspawner:Spawn()
			dollspawner:Activate()
		
			ent:Remove()
		
		end
	
		timer.Simple( 0.1, function() GAMEMODE:SetInRound( false ) end )
		timer.Simple( 0.1, function() timer.Adjust( "RoundEndTimer", 90, 0, function() PHEEVENTS_EndEvent() end ) end )
		timer.Simple( 0.1, function() SetGlobalFloat( "RoundEndTime", CurTime() + 90 ) end )
	
		PHEEVENTS_SetMusic( "music/hl2_song14.mp3" )
	
		PHEEVENTS_BOOLEAN_EventRound = true
		BroadcastLua( "chat.AddText( Color( 255, 215, 0 ), \"[Events]\", Color( 255, 255, 255 ), \" Hit the dolls to earn points!\" )" )
		BroadcastLua( "chat.AddText( Color( 255, 215, 0 ), \"[Events]\", Color( 255, 255, 255 ), \" You have 90 seconds.\" )" )
	
	elseif ( PHEEVENTS_INT_EventID == 2 ) then
	
		-- Hot Props
		for _, ply in pairs( team.GetPlayers( TEAM_HUNTERS ) ) do
		
			table.insert( PHEEVENTS_TABLE_TeamHuntersPlayers, ply )
			ply:SetTeam( TEAM_PROPS )
			ply:Spawn()
		
		end
	
		timer.Simple( 0.1, function() GAMEMODE:SetInRound( false ) end )
		timer.Simple( 0.1, function() timer.Adjust( "RoundEndTimer", 60, 0, function() PHEEVENTS_EndEvent() end ) end )
		timer.Simple( 0.1, function() SetGlobalFloat( "RoundEndTime", CurTime() + 60 ) end )
	
		PHEEVENTS_SetMusic( "music/hl2_song31.mp3" )
	
		PHEEVENTS_BOOLEAN_EventRound = true
		BroadcastLua( "chat.AddText( Color( 255, 215, 0 ), \"[Events]\", Color( 255, 255, 255 ), \" It's hot props!\" )" )
		BroadcastLua( "chat.AddText( Color( 255, 215, 0 ), \"[Events]\", Color( 255, 255, 255 ), \" You have 60 seconds.\" )" )
	
		timer.Create( "PHEEVENTS_HotPropChecker", 1, 0, function() PHEEVENTS_HotPropsCheck() end )
	
	elseif ( PHEEVENTS_INT_EventID == 3 ) then
	
		-- Kleiner is missing
		for _, ply in pairs( team.GetPlayers( TEAM_PROPS ) ) do
		
			table.insert( PHEEVENTS_TABLE_TeamPropsPlayers, ply )
			ply:SetTeam( TEAM_HUNTERS )
			ply:Spawn()
		
		end
	
		PHEEVENTS_ENTITY_MissingKleiner_Physics = table.Random( ents.FindByClass( "prop_physics*" ) )
		PHEEVENTS_ENTITY_MissingKleiner = ents.Create( "pheevents_kleiner" )
		PHEEVENTS_ENTITY_MissingKleiner:SetPos( PHEEVENTS_ENTITY_MissingKleiner_Physics:GetPos() )
		PHEEVENTS_ENTITY_MissingKleiner:Spawn()
		PHEEVENTS_ENTITY_MissingKleiner:Activate()
		PHEEVENTS_ENTITY_MissingKleiner_Physics:Remove()
	
		timer.Simple( 0.1, function() GAMEMODE:SetInRound( false ) end )
		timer.Simple( 0.1, function() timer.Adjust( "RoundEndTimer", 30, 0, function() PHEEVENTS_EndEvent() end ) end )
		timer.Simple( 0.1, function() SetGlobalFloat( "RoundEndTime", CurTime() + 30 ) end )
	
		PHEEVENTS_SetMusic( "music/hl2_song31.mp3" )
	
		PHEEVENTS_BOOLEAN_EventRound = true
		BroadcastLua( "chat.AddText( Color( 255, 215, 0 ), \"[Events]\", Color( 255, 255, 255 ), \" Dr. Kleiner has gone missing, find him!\" )" )
		BroadcastLua( "chat.AddText( Color( 255, 215, 0 ), \"[Events]\", Color( 255, 255, 255 ), \" You have 30 seconds.\" )" )
	
	elseif ( PHEEVENTS_INT_EventID == 4 ) then
	
		-- Crowbar frenzy
		timer.Simple( 0.1, function() timer.Adjust( "RoundEndTimer", 60, 0, function() PHEEVENTS_EndEvent() end ) end )
		timer.Simple( 0.1, function() SetGlobalFloat( "RoundEndTime", CurTime() + 60 ) end )
	
		PHEEVENTS_SetMusic( "music/hl2_song29.mp3" )
	
		PHEEVENTS_BOOLEAN_EventRound = true
		BroadcastLua( "chat.AddText( Color( 255, 215, 0 ), \"[Events]\", Color( 255, 255, 255 ), \" Seems like the Hunters forgot their weapons at home.\" )" )
		BroadcastLua( "chat.AddText( Color( 255, 215, 0 ), \"[Events]\", Color( 255, 255, 255 ), \" You have 60 seconds.\" )" )
	
	end

end


-- Hot Props function
function PHEEVENTS_HotPropsCheck()

	if ( PHEEVENTS_STRING_HotProps_Model ) then
	
		for _, ply in pairs( team.GetPlayers( TEAM_PROPS ) ) do
		
			if ( !table.HasValue( PHE.BANNED_PROP_MODELS, PHEEVENTS_STRING_HotProps_Model ) && ply:Alive() && IsValid( ply.ph_prop ) && ( ply.ph_prop:GetModel() != PHEEVENTS_STRING_HotProps_Model ) ) then
			
				ply:Kill()
				ply:SendLua( "chat.AddText( Color( 255, 215, 0 ), \"[Events]\", Color( 255, 255, 255 ), \" Ouch! You're out of the game.\" )" )
			
			elseif ( ply:Alive() ) then
			
				ply:AddFrags( 2 )
				ply:SendLua( "surface.PlaySound( \"buttons/bell1.wav\" )" )
			
			end
		
		end
	
	end

	if ( table.Count( GAMEMODE:GetTeamAliveCounts() ) == 0 ) then
	
		if ( timer.Exists( "RoundEndTimer" ) ) then
		
			timer.Remove( "RoundEndTimer" )
		
		end
	
		BroadcastLua( "chat.AddText( Color( 255, 215, 0 ), \"[Events]\", Color( 255, 255, 255 ), \" Everyone died!\" )" )
	
		PHEEVENTS_EndEvent()
		return
	
	end

	PHEEVENTS_STRING_HotProps_Model = table.Random( ents.FindByClass( "prop_physics*" ) ):GetModel()

	for _, ent in pairs( ents.FindByClass( "prop_physics*" ) ) do
	
		if ( ent:GetModel() == PHEEVENTS_STRING_HotProps_Model ) then
		
			sound.Play( "taunts/props/32.mp3", ent:GetPos(), 120, 100, 1 )
			ent:SetColor( Color( 0, 255, 0, 255 ) )
			timer.Simple( 12, function() if ( IsValid( ent ) ) then ent:SetColor( Color( 255, 255, 255, 255 ) ) end end )
		
		end
	
	end

	BroadcastLua( "chat.AddText( Color( 255, 215, 0 ), \"[Events]\", Color( 255, 255, 255 ), \" Oh no! You need to find this prop in 12 seconds:\" )" )
	BroadcastLua( "chat.AddText( Color( 255, 215, 0 ), \"[Events]\", Color( 255, 255, 255 ), \" "..PHEEVENTS_STRING_HotProps_Model.."\" )" )

	timer.Create( "PHEEVENTS_HotPropChecker", 12, 0, function() PHEEVENTS_HotPropsCheck() end )

end


-- End the event
function PHEEVENTS_EndEvent()

	-- End the event
	PHEEVENTS_BOOLEAN_EventRound = false
	PHEEVENTS_INT_EventID = 0

	-- Reset blindlock
	if ( PHE.HUNTER_BLINDLOCK_TIME && GetConVar( "ph_hunter_blindlock_time" ) ) then PHE.HUNTER_BLINDLOCK_TIME = GetConVar( "ph_hunter_blindlock_time" ):GetFloat() BroadcastLua( "PHE.HUNTER_BLINDLOCK_TIME = "..PHE.HUNTER_BLINDLOCK_TIME ) end

	-- Reset props
	for _, ply in pairs( PHEEVENTS_TABLE_TeamPropsPlayers ) do
	
		if ( IsValid( ply ) ) then
		
			ply:SetTeam( TEAM_PROPS )
		
		end
	
	end
	PHEEVENTS_TABLE_TeamPropsPlayers = {}

	-- Reset hunters
	for _, ply in pairs( PHEEVENTS_TABLE_TeamHuntersPlayers ) do
	
		if ( IsValid( ply ) ) then
		
			ply:SetTeam( TEAM_HUNTERS )
		
		end
	
	end
	PHEEVENTS_TABLE_TeamHuntersPlayers = {}

	if ( timer.Exists( "PHEEVENTS_HotPropChecker" ) ) then
	
		timer.Remove( "PHEEVENTS_HotPropChecker" )
	
	end

	PHEEVENTS_STRING_HotProps_Model = nil

	if ( PHEEVENTS_CSOUNDPATCH_Music ) then PHEEVENTS_CSOUNDPATCH_Music:Stop() end

	GAMEMODE:SetInRound( true )

	-- Kill all players
	for _, ply in pairs( player.GetAll() ) do
	
		if ( ply:Alive() ) then
		
			if ( ply:Team() == TEAM_PROPS ) then
			
				ply:RemoveProp()
				ply:RemoveClientProp()
			
			end
			ply:KillSilent()
		
		end
	
	end

	BroadcastLua( "chat.AddText( Color( 255, 215, 0 ), \"[Events]\", Color( 255, 255, 255 ), \" Thanks for participating in the event! You get to keep your score.\" )" )

end


-- Use the OnPreRoundStart function to determine when we should do this stuff
function PHEEVENTS_OnPreRoundStart()

	if ( PHEEVENTS_BOOLEAN_EventAboutToStart ) then
	
		PHEEVENTS_BOOLEAN_EventAboutToStart = false
		PHEEVENTS_DetermineEvent()
	
	end

	if ( ( #ents.FindByClass( "prop_physics*" ) >= 32 ) && !PHEEVENTS_BOOLEAN_EventAboutToStart && ( GetGlobalInt( "RoundNumber" ) == PHEEVENTS_INT_EventRound ) ) then
	
		PHEEVENTS_BOOLEAN_EventAboutToStart = true
		BroadcastLua( "chat.AddText( Color( 255, 215, 0 ), \"[Events]\", Color( 255, 255, 255 ), \" An event is starting after this round.\" )" )
	
	end

end
hook.Add( "PH_OnPreRoundStart", "PHEEVENTS_OnPreRoundStart", PHEEVENTS_OnPreRoundStart )


-- Edit team selection function
function PHEEVENTS_PlayerRequestTeam( ply, teamid )

	if ( PHEEVENTS_BOOLEAN_EventRound && ( PHEEVENTS_INT_EventID == 1 ) && ( teamid == TEAM_PROPS ) ) then
	
		if ( ply:Team() != TEAM_HUNTERS ) then gamemode.Call( "PlayerJoinTeam", ply, TEAM_HUNTERS ) ply:Spawn() end
		return false
	
	end

	if ( PHEEVENTS_BOOLEAN_EventRound && ( PHEEVENTS_INT_EventID == 2 ) && ( teamid == TEAM_HUNTERS ) ) then
	
		if ( ply:Team() != TEAM_PROPS ) then gamemode.Call( "PlayerJoinTeam", ply, TEAM_PROPS ) end
		return false
	
	end

	if ( PHEEVENTS_BOOLEAN_EventRound && ( PHEEVENTS_INT_EventID == 3 ) && ( teamid == TEAM_PROPS ) ) then
	
		if ( ply:Team() != TEAM_HUNTERS ) then gamemode.Call( "PlayerJoinTeam", ply, TEAM_HUNTERS ) ply:Spawn() end
		return false
	
	end

end
hook.Add( "PlayerRequestTeam", "PHEEVENTS_PlayerRequestTeam", PHEEVENTS_PlayerRequestTeam )


-- Round ends
function PHEEVENTS_RoundEnd()

	if ( PHEEVENTS_BOOLEAN_EventRound && ( PHEEVENTS_INT_EventID == 4 ) ) then
	
		-- End the event
		PHEEVENTS_BOOLEAN_EventRound = false
		PHEEVENTS_INT_EventID = 0
	
		-- Reset blindlock
		if ( PHE.HUNTER_BLINDLOCK_TIME && GetConVar( "ph_hunter_blindlock_time" ) ) then PHE.HUNTER_BLINDLOCK_TIME = GetConVar( "ph_hunter_blindlock_time" ):GetFloat() BroadcastLua( "PHE.HUNTER_BLINDLOCK_TIME = "..PHE.HUNTER_BLINDLOCK_TIME ) end
	
		if ( PHEEVENTS_CSOUNDPATCH_Music ) then PHEEVENTS_CSOUNDPATCH_Music:Stop() end
	
		BroadcastLua( "chat.AddText( Color( 255, 215, 0 ), \"[Events]\", Color( 255, 255, 255 ), \" Thanks for participating in the event! You get to keep your score.\" )" )
	
	end

end
hook.Add( "PH_RoundEnd", "PHEEVENTS_RoundEnd", PHEEVENTS_RoundEnd )
