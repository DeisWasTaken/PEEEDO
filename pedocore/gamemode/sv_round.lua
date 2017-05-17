
ROUNDS = 0
ROUNDTIME = PEDO.RoundTime
IN_PREP = false
local PEDO_PostRoundCalled = false

local function PEDO_RoundCount()
  timer.Create("PEDO_RoundCount", PEDO.RoundTime, 1 ,function()
      PEDO_PostRound(1)
  end)
end

local function PEDO_InitPedos(ply)
  ply:SetTeam(TEAM_PEDO)
  ply:ChatPrint("DU BIST PEDOOO")
end

local function PEDO_SetRandomPedo()
  local plyrz = #team.GetPlayers(TEAM_VICTIM)
  plyrz = math.floor(plyrz / PEDO.PedoSpawnRate)
  if #team.GetPlayers(TEAM_VICTIM) == 0 then return end
  if plyrz > 1 then plyrz = 1 end
  for i=0,plyrz do
    PEDO_InitPedos(table.Random(team.GetPlayers(TEAM_VICTIM)))
  end
end

local function PEDO_RoundStart()
  ROUNDTIME = PEDO.RoundTime
  for k,v in pairs(player.GetAll()) do
    v:SetTeam(TEAM_VICTIM)
    v:StripWeapons()
  end
  PEDO_SetRandomPedo()
  PEDO_RoundCount()
  PEDO_PostRoundCalled = false
  hook.Call("PEDO_RoundStart")
  BroadcastLua( [[hook.Call( "PEDO_RoundStart" )]] )

  for k,v in pairs(team.GetPlayers(TEAM_VICTIM)) do
    v:Loadout()
    v:Spawn()
  end

  timer.Simple(PEDO.SpawnTime, function()
    for k,v in pairs(team.GetPlayers(TEAM_PEDO)) do
      v:Loadout()
      v:Spawn()
    end
  end)
end

local function PEDO_PostRound(winner) -- 1 = VIC, 2 = PEDO
  if PEDO_PostRoundCalled then return end
  PEDO_PostRoundCalled = true
  hook.Call("PEDO_RoundEnd", GAMEMODE, winner)
  BroadcastLua( "hook.Call( [[PEDO_RoundEnd]], nil, " .. winner .. " )" )
  timer.Simple(6, function()
    PEDO_RoundStart()
    timer.Destroy("PEDO_RoundCount")
  end)
end

local function PEDO_PrepareTime()
  IN_PREP = true
  ROUNDTIME = PEDO.PrepareTime
  PEDO_RoundStart()
  timer.Simple(PEDO.PrepareTime, function()
    PEDO_PostRound("3")
    IN_PREP = false
  end)
end
hook.Add("PEDO_Initialize", "PEDO_PrepareTime", PEDO_PrepareTime )

local function PEDO_DeathThink(ply)
  local VIC_ALIVE = 0

  timer.Simple(0.2, function()
    for k,v in pairs(team.GetPlayers(TEAM_VICTIM)) do
      if v:Alive() then
        VIC_ALIVE = VIC_ALIVE + 1
      end
    end

    if VIC_ALIVE == 0 then
      PEDO_PostRound("2") -- PEDO WIN
    end

    if ROUNDTIME <= 0 then
      PEDO_PostRound("1")
    end
  end)

  if ply:Team() == TEAM_SPEC then return false end
  if IN_PREP then
    return true
  else
    return false
  end
end
hook.Add("PlayerDeathThink", "PEDO_DeathThink", PEDO_DeathThink )
