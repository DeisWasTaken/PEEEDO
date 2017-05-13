
ROUNDS = 0
ROUNDTIME = PEDO.RoundTime
IN_PREP = false
local PEDO_PostRoundCalled = false

local function PEDO_RoundCount()
  timer.Create("PEDO_RoundCount", PEDO.RoundTime, 1 ,function()
      PEDO_PostRound(1)
  end)
end

local function PEDO_RoundStart()
  if !IN_PREP then
    PEDO_RoundCount()
  end
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

local function PEDO_InitPedos(ply)
  ply:SetTeam(TEAM_PEDO)
end

local function PEDO_SetRandomPedo()
  local plyrz = #team.GetPlayers(TEAM_VICTIM)
  plyrz = math.floor(plyrz / PEDO.PedoSpawnRate)

  for i=1,plyrz do
    PEDO_InitPedos(table.Random(team.GetPlayers(TEAM_VICTIM)))
  end
end

local function PEDO_PreRoundStart()
  ROUNDTIME = PEDO.RoundTime
  for k,v in pairs(player.GetAll()) do
    v:SetTeam(TEAM_VICTIM)
    v:StripWeapons()
  end
  PEDO_SetRandomPedo()

  timer.Simple(PEDO.PreRoundTime, function()
    PEDO_RoundStart()
  end)
  hook.Call("PEDO_PreRoundStart")
  BroadcastLua( [[hook.Call( "PEDO_PreRoundStart" )]] )
  PEDO_PostRoundCalled = false
end
concommand.Add("shit", PEDO_PreRoundStart)

local function PEDO_PostRound(winner) -- 1 = VIC, 2 = PEDO
  if PEDO_PostRoundCalled then return end
  PEDO_PostRoundCalled = true
  hook.Call("PEDO_RoundEnd", GAMEMODE, winner)
  BroadcastLua( "hook.Call( [[PEDO_RoundEnd]], nil, " .. winner .. " )" )
  timer.Simple(6, function()
    PEDO_PreRoundStart()
    timer.Destroy("PEDO_RoundCount")
  end)
end

local function PEDO_PrepareTime()
  IN_PREP = true
  PEDO_RoundStart()
  timer.Simple(PEDO.PrepareTime, function()
    PEDO_PostRound("3")
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

    if ROUNDTIME >= 0 then
      PEDO_PostRound("1")
    end
  end)

  if ply:Team() == TEAM_SPEC then return false end
  return false
end
hook.Add("PlayerDeathThink", "PEDO_DeathThink", PEDO_DeathThink )
