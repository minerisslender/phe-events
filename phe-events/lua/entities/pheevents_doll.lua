-- Doll entity

AddCSLuaFile()

ENT.Base = "base_anim"
ENT.Type = "anim"

ENT.SpawningTime = 1


-- Initialize this entity
function ENT:Initialize()

	self:DrawShadow( false )
	self:SetModel( "models/maxofs2d/companion_doll.mdl" )
	self.Entity:SetModelScale( 0.0001 )
	self.Entity:SetModelScale( 1, self.SpawningTime )
	self.Entity:SetAngles( Angle( 0, math.random( 0, 359 ), 0 ) )

	self.SpawnTime = CurTime() + self.SpawningTime

	if ( SERVER ) then
	
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_NONE )
		self:CollisionRulesChanged()
	
	end

end


if ( SERVER ) then

	-- Transmit state
	function ENT:UpdateTransmitState()
	
		return TRANSMIT_ALWAYS
	
	end

	-- Entity taken damage
	function ENT:OnTakeDamage( info )
	
		if ( ( self.SpawnTime < CurTime() ) && IsValid( info:GetAttacker() ) && info:GetAttacker():IsPlayer() && ( info:GetAttacker():Team() == TEAM_HUNTERS ) ) then
		
			info:GetAttacker():AddFrags( 1 )
			info:GetAttacker():SendLua( "surface.PlaySound( \"buttons/blip1.wav\" )" )
			sound.Play( "ambient/creatures/teddy.wav", self.Entity:GetPos(), 90, 100, 1 )
			self:Remove()
		
		end
	
	end

end
