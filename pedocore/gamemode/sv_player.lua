


local meta = FindMetaTable("Player")
function meta:Fuckoff()

end

local function PEDO_SetTeamOnSpawn(ply)
  ply:SetTeam(TEAM_SPEC)

end
hook.Add("PlayerInitialSpawn", "PEDO_SetTeamOnSpawn", PEDO_SetTeamOnSpawn)
