-- Kleiner entity

AddCSLuaFile()

ENT.Base = "base_anim"
ENT.Type = "anim"


-- Initialize this entity
function ENT:Initialize()

	self:SetModel( "models/player/kleiner.mdl" )

	self.PlaySound = CurTime()

	if ( SERVER ) then
	
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_NONE )
		self:CollisionRulesChanged()
	
	end

end


-- Entity Think
function ENT:Think()

	-- Play sounds randomly
	if ( SERVER ) then
	
		if ( self.PlaySound < CurTime() ) then
		
			self.PlaySound = CurTime() + 5
		
			self.Entity:EmitSound( "k_lab.kl_fiddlesticks" )
		
		end
	
	end

end


if ( SERVER ) then

	-- Transmit state
	function ENT:UpdateTransmitState()
	
		return TRANSMIT_ALWAYS
	
	end

	-- Entity used
	function ENT:Use( activator )
	
		if ( PHEEVENTS_BOOLEAN_EventRound && activator:IsPlayer() && ( activator:Team() == TEAM_HUNTERS ) ) then
		
			if ( timer.Exists( "RoundEndTimer" ) ) then
			
				timer.Remove( "RoundEndTimer" )
			
			end
		
			BroadcastLua( "chat.AddText( Color( 255, 215, 0 ), \"[Events]\", Color( 255, 255, 255 ), \" "..activator:Name().." found Dr. Kleiner!\" )" )
		
			PHEEVENTS_EndEvent()
		
			activator:AddFrags( 20 )
			activator:EmitSound( "k_lab.kl_mygoodness02_cc" )
			self:Remove()
		
		end
	
	end

end
