
local function PEDO_Spectator_Death( pl, wep, killer )
	if pl == killer then
		pl.SpecType = 6
	else
		pl.SpecID = 1
		pl.SpecType = 5
		pl:Spectate( OBS_MODE_CHASE )
		pl:SpectateEntity( killer )
	end
end
hook.Add("PlayerDeath", "PEDO_Spectator_Death", PEDO_Spectator_Death)

function PEDO_Spectator_Deaththink( pl )
	local players = {}
	table.Add( players, team.GetPlayers( TEAM_VICTIM ) )
	table.Add( players, team.GetPlayers( TEAM_PEDO ) )
	if !pl.SpecType then return end
	local alive = 0

	for k,v in pairs(players) do
		if v:Alive() then
			alive = alive + 1
		end
	end

	if alive == 0 then return end

	if pl:KeyPressed( IN_JUMP ) then
		pl.SpecType = pl.SpecType + 1
		if pl.SpecType > 6 then pl.SpecType = 4 end
		pl:Spectate( pl.SpecType )
	elseif pl:KeyPressed( IN_ATTACK ) then
		if !pl.SpecID then pl.SpecID = 1 end
		if pl.SpecID > #players then pl.SpecID = 1 end
		pl.SpecID = pl.SpecID + 1
		if players[ pl.SpecID ]:Alive() then
			pl:SpectateEntity( players[ pl.SpecID ] )
		end

	elseif pl:KeyPressed( IN_ATTACK2 ) then
		if !pl.SpedID then pl.SpedID = 1 end
		pl.SpecID = pl.SpecID - 1
		if pl.SpecID <= 0 then pl.SpecID = #players end
		if players[ pl.SpecID ]:Alive() then
			pl:SpectateEntity( players[ pl.SpecID ] )
		end
	end
	return false; -- prevent spawning
end
hook.Add("PlayerDeathThink", "PEDO_Spectator_Deaththink", PEDO_Spectator_Deaththink)
