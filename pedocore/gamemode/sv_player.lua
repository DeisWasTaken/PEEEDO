


local meta = FindMetaTable("Player")

function meta:IsPedo()
  if self:Team() == TEAM_PEDO then return true end
end

function meta:GivePedo()
  self:SetTeam(TEAM_PEDO)
end

function meta:RemovePedo()
  self:SetTeam(TEAM_VICTIM)
end

function meta:Loadout()
  if self:IsPedo() do
    self:SetWalkSpeed(PEDO.PedoWalkSpeed)
  else
    self:SetWalkSpeed(PEDO.VicWalkSpeed)
  end
end

local function PEDO_SetTeamOnSpawn(ply)
  ply:SetTeam(TEAM_SPEC)

end
hook.Add("PlayerInitialSpawn", "PEDO_SetTeamOnSpawn", PEDO_SetTeamOnSpawn)

local function PEDO_NearVictims()
  for k,v in pairs(team.GetPlayers(TEAM_PEDO)) do
    for _,ply in pairs(ents.FindInSphere(v:GetPos(),PEDO.CatchRadius)) do
      if ply:IsPlayer() then
        ply:Kill()
      end
    end
  end
end
hook.Add("Think", "PEDO_NearVictims", PEDO_NearVictims)
