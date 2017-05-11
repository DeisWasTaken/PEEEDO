
ROUNDS = 0

local function PEDO_PostRound(winner) -- 1 = VIC, 2 = PEDO
  hook.Call("PEDO_RoundEnd", GAMEMODE, winner)
  BroadcastLua( "hook.Call( [[PEDO_RoundEnd]], nil, " .. winner .. " )" )
  timer.Simple(6, function() PEDO_PreRoundStart() end)
end

local function PEDO_RoundCount()
  timer.Create("PEDO_RoundCount", PEDO.RoundTime, 1 ,function()
      PEDO_PostRound(1)
  end)
end

local function PEDO_RoundStart()
  PEDO_RoundCount()
  hook.Call("PEDO_RoundStart")
  BroadcastLua( [[hook.Call( "PEDO_RoundStart" )]] )

end

local function PEDO_PreRoundStart()
  ROUNDTIME = PEDO.RoundTime
  for k,v in pairs(player.GetAll()) do
    v:StripWeapons()
  end
  timer.Simple(5, function()
    PEDO_RoundStart()
  end)
  hook.Call("PEDO_PreRoundStart")
  BroadcastLua( [[hook.Call( "PEDO_PreRoundStart" )]] )
end
concommand.Add("shit",function() PEDO_PreRoundStart() end)

local function PEDO_StopRound()
  if timer.Exists( "PEDO_RoundCount" )
    timer.Destroy("PEDO_RoundCount")
  end

end

local function PEDO_PrepareTime()

end

local function PEDO_DeathThink()

  local VIC_ALIVE = 0

  timer.Simple(0.2, function()
    for k,v in pairs(team.GetPlayers(TEAM_VICTIM)) do
      if v:Alive() then
        VIC_ALIVE = VIC_ALIVE + 1
      end
    end

    if VIC_ALIVE == 0 then
      PEDO_PostRound("2") -- PEDO WIN
      PEDO_StopRound()
    end

    if ROUNDTIME >= 0 then
      PEDO_PostRound("1")
      PEDO_StopRound()
    end
  end)

  if ply:Team() == TEAM_SPEC then return false end

end
hook.Add("PlayerDeathThink", "PEDO_DeathThink", PEDO_DeathThink )
