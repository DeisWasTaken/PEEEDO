


local meta = FindMetaTable("Player")
function meta:Loadout()

end

function meta:IsPedo()
  return self:GetNWBool("PEDO")
end

function meta:GivePedo()
  self:SetNWBool("PEDO", true)
end

function meta:RemovePedo()
  self:SetNWBool("PEDO", false)
end
local function PEDO_SetTeamOnSpawn(ply)
  ply:SetTeam(TEAM_SPEC)

end
hook.Add("PlayerInitialSpawn", "PEDO_SetTeamOnSpawn", PEDO_SetTeamOnSpawn)
