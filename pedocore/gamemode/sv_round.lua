

util.AddNetworkString( "PEDO_SendRoundStart" )
util.AddNetworkString( "PEDO_SendRoundWinner" )


ROUNDS = 0


local function PEDO_PostRound(winner) -- 1 = VIC, 2 = PEDO
  if winner == "2" then
    net.Start( "PEDO_SendRoundWinner" )
      net.WriteInt(2)
    net.Broadcast()
  elseif winner == "1" then
    net.Start( "PEDO_SendRoundWinner" )
      net.WriteInt(1)
    net.Broadcast()
  else
    net.Start( "PEDO_SendRoundWinner" )
      net.WriteInt(3)
    net.Broadcast()
  end
  timer.Simple(6, function() PEDO_PreRoundStart() end)
end

local function PEDO_RoundCount()
  timer.Create("PEDO_RoundCount", PEDO.RoundTime, 1 ,function()
      PEDO_PostRound(1)
  end)
end

local function PEDO_RoundStart()
  PEDO_RoundCount()
  net.Start( "PEDO_SendRoundStart" )
  net.Broadcast()
end

local function PEDO_PreRoundStart()
  ROUNDTIME = PEDO.RoundTime
  timer.Simple(5, function()
    PEDO_RoundStart()
    print("lets go")
  end)
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
