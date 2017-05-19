GM.Name = "Pedobear"
GM.Author = "Habobababo"
GM.Email = "mail@core-community.de"
GM.Website = "core-community.de"
--[[
        |||||||||||||||||||||||||||||||||
        ||  JUST EDIT THE MARKED LINES ||
        ||       DO NOT EDIT THIS      ||
        |||||||||||||||||||||||||||||||||
]]--

PEDO = {}
PEDO.Scoreboard = {}

PEDO.PEDO = {}
PEDO.SPEC = {}
PEDO.VIC = {}

--[[
        |||||||||||||||||||||
        || EDIT BELOW HERE ||
        |||||||||||||||||||||
]]--

PEDO.Spawntext = { -- text in the spawntime of the Pedobear
  "Van wird getankt",
  "Süssichkeiten werden abgepackt",
  "Fell wird gereinigt",
  "Lächeln wird aufgesetzt",
  "Luftdruck wird geprueft"
}

PEDO.HUDAvatarAnimations = { -- animations of the avatar @ hud
  "taunt_cheer",
  "taunt_dance",
  "taunt_laugh",
  "taunt_muscle",
  "taunt_robot",
  "taunt_persistence"
}

PEDO.RoundTime = 300 -- x minutes roundtime is legit
PEDO.PreRoundTime = 5 -- the x seconds before the round starts
PEDO.PrepareTime = 30 -- the first round right after mapchange
PEDO.SpawnTime = 15 -- Pedobear has another x seconds to spawn

PEDO.NotificationTime = 7 -- the time of the notification

PEDO.CatchRadius = 40 -- if a victim comes below that range, he will die.

PEDO.PedoWalkSpeed = 250 --default walkspeed of the pedobear
PEDO.VicWalkSpeed = 220 -- --||-------------------- victim
PEDO.RunSpeed = 300 -- press SHIFT <IN_SPEED> and run!, thats the speed

PEDO.PedoSpawnRate = 6 -- 1 pedobears on 6 players. --> with 12 players you got 2 pedobears

PEDO.StaminaDrain = 0.01 -- How fast the stamina drains to zero. 1 is faster, 0.01 is slow
PEDO.StaminaRestoreTime = 0.1  -- restoretime. Same as above
PEDO.DelayRestoreStamina = 4 -- x seconds after release the key, the stamina starts restoring
PEDO.StaminaDeadPoint = 10 -- if stamina is below x, you can't run anymore

PEDO.VIC.Color = Color(255,0,0,255) -- color of team victim
PEDO.VIC.Name = "Kinder" -- name of team victim
PEDO.VIC.Models = { -- NOT IN USE YET --
  ["RIOT"] = "models/player/riot.mdl",
	["GASMASK"] = "models/player/gasmask.mdl",
	["URBAN"] = "models/player/urban.mdl",
	["SWAT"] = "models/player/swat.mdl"
}

PEDO.VIC.WinTexts = { -- eventtext on endround if team victim wins
  "Die Kinder waren zu schnell!",
  "Die Eltern haben die Kinder gerettet!"
}


PEDO.PEDO.Color = Color(0,255,0,255) -- color of team victim
PEDO.PEDO.Name = "Pedobär" -- name of team victim
PEDO.PEDO.Models = { -- NOT IN USE YET --
  ["PHOENIX"] = "models/player/phoenix.mdl",
	["ARCTIC"] = "models/player/arctic.mdl",
	["GUERILLA"] = "models/player/guerilla.mdl",
	["LEET"] = "models/player/leet.mdl"
}

PEDO.PEDO.WinTexts = { -- eventtext on endround if team pedo wins
  "Der Pedobär hat es genossen!",
  "Der Pedobär will mehr!",
  "Leider ist kein Kind mehr übrig.."
}

PEDO.SPEC.Name = "Zuschauer" -- spectator name, -- NOT IN USE --
PEDO.SPEC.Color = Color(0,70,70,255) -- ...

--[[
        |||||||||||||||||||||||
        || STOP EDITING HERE ||
        |||||||||||||||||||||||
]]--


function GM:Initialize()
	hook.Call("PEDO_Initialize")
end

function GM:CreateTeams()
	if PEDO.VIC.Color == nil && PEDO.PEDO.Color == nil && PEDO.SPEC.Color == nil then
		PEDO.VIC.Color, PEDO.PEDO.Color, PEDO.SPEC.Color  = Color(0,0,0), Color(0,0,0), Color(0,0,0)
	end

	TEAM_PEDO = 3
	team.SetUp( TEAM_PEDO, PEDO.PEDO.Name, PEDO.PEDO.Color )
	team.SetSpawnPoint( TEAM_PEDO, "info_player_counterterrorist" )

	TEAM_VICTIM = 2
	team.SetUp( TEAM_VICTIM, PEDO.VIC.Name, PEDO.VIC.Color)
	team.SetSpawnPoint( TEAM_VICTIM, "info_player_terrorist" )

	TEAM_SPEC = 1
	team.SetUp( TEAM_SPEC, PEDO.SPEC.Name, PEDO.SPEC.Color )
	team.SetSpawnPoint( TEAM_SPEC, "info_player_terrorist" )

end
