


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
  if self:IsPedo() then
    self:SetWalkSpeed(PEDO.PedoWalkSpeed)
  else
    self:SetWalkSpeed(PEDO.VicWalkSpeed)
  end
end

local function PEDO_SetTeamOnSpawn(ply)
  ply:SetTeam(TEAM_VICTIM)
end
hook.Add("PlayerInitialSpawn", "PEDO_SetTeamOnSpawn", PEDO_SetTeamOnSpawn)

local function debug_toggleteam(ply)
  if ply:IsPedo() then
    ply:RemovePedo()
    ply:ChatPrint("nopedo")
  else
    ply:GivePedo()
    ply:ChatPrint("pedo")
  end
end
concommand.Add("tt", debug_toggleteam)

local function PEDO_NearVictims()
  local damageinfo = DamageInfo()  //Victim can't hold the pressure and commits suicide.
  for k,v in pairs(team.GetPlayers(TEAM_PEDO)) do
    for _,ply in pairs(ents.FindInSphere(v:GetPos(),PEDO.CatchRadius)) do
      if ply:IsPlayer() then
        if !ply:IsPedo() then
          if ply:Alive() then
            damageinfo:SetAttacker( v )
            damageinfo:SetDamage( ply:Health() * ply:GetMaxHealth() )
            damageinfo:SetDamageType( DMG_DISSOLVE )
            ply:TakeDamageInfo( damageinfo )
          end
        end
      end
    end
  end
end
hook.Add("Think", "PEDO_NearVictims", PEDO_NearVictims)
