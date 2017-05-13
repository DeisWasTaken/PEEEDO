
local meta = FindMetaTable("Player")

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
  ply:SetModel("models/player/riot.mdl")
  ply:SetNWInt("PEDO_Stamina", 100)
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

local function PEDO_RestoreStamina(ply)
  timer.Create("PEDO_RestoreStamina", PEDO.StaminaRestoreTime, 0, function()
    if ply:GetStamina() >= 100 then
      timer.Destroy("PEDO_RestoreStamina")
      ply:SetNWInt("PEDO_Stamina", 100)
    end
    ply:SetNWInt("PEDO_Stamina", ply:GetNWInt("PEDO_Stamina") + 1 )
  end)
end

local function PEDO_Stamina(ply, key)
  if key == IN_SPEED then
    if ply:GetStamina() > PEDO.StaminaDeadPoint then
      timer.Create("PEDO_StaminaDrain",PEDO.StaminaDrain,0, function()
          timer.Destroy("PEDO_DelayRestoreStamina")
          ply:SetNWInt("PEDO_Stamina", ply:GetNWInt("PEDO_Stamina") - 1 )
      end)
    end
  end
end
hook.Add( "KeyPress", "PEDO_Stamina", PEDO_Stamina )

local function PEDO_RevokeDrain(ply, key)
  if key == IN_SPEED then
    timer.Destroy("PEDO_StaminaDrain")
    if timer.Exists("PEDO_DelayRestoreStamina") then return end
    timer.Create("PEDO_DelayRestoreStamina", PEDO.DelayRestoreStamina, 1, function()
        PEDO_RestoreStamina(ply)
    end)
  end
end
hook.Add( "KeyRelease", "PEDO_RevokeDrain", PEDO_RevokeDrain )

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

  for k,v in pairs(player.GetAll()) do
    if v:IsPlayer() && v:Alive() then
      if v:GetStamina() < PEDO.StaminaDeadPoint then
        if v:IsPedo() then
          v:SetRunSpeed(PEDO.PedoWalkSpeed)
        else
          v:SetRunSpeed(PEDO.VicWalkSpeed)
        end
      else
        v:SetRunSpeed(PEDO.RunSpeed)
      end
    end
  end
end
hook.Add("Think", "PEDO_NearVictims", PEDO_NearVictims)
