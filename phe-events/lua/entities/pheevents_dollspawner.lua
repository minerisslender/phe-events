-- Spawner for the dolls

ENT.Base = "base_point"
ENT.Type = "point"


ENT.SpawnDollEntity = nil
ENT.SpawnDollSpawning = true
ENT.SpawnDollTime = 0


-- Entity Think
function ENT:Think()

	-- Check if our doll is valid or not
	if ( !self.SpawnDollSpawning && !IsValid( self.SpawnDollEntity ) ) then
	
		self.SpawnDollTime = CurTime() + 14
		self.SpawnDollSpawning = true
	
	end

	-- Spawn the doll here
	if ( self.SpawnDollSpawning && ( self.SpawnDollTime < CurTime() ) ) then
	
		self.SpawnDollSpawning = false
		self.SpawnDollTime = 0
	
		self.SpawnDollEntity = ents.Create( "pheevents_doll" )
		self.SpawnDollEntity:SetPos( self.Entity:GetPos() )
		self.SpawnDollEntity:Spawn()
		self.SpawnDollEntity:Activate()
	
	end

end
