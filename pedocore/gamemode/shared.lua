GM.Name = "Pedobear"
GM.Author = "N/A"
GM.Email = "N/A"
GM.Website = "N/A"

PEDO = {}

PEDO.RoundTime = 300
PEDO.PrepareTime = 30
PEDO.CatchRadius = 40

PEDO.VIC = {}
PEDO.VIC.Color = Color(255,0,0,255)
PEDO.VIC.Name = "Kind"
PEDO.VIC.Models = { // Just take 4 Models or Break the Gamemode
  ["RIOT"] = "models/player/riot.mdl",
	["GASMASK"] = "models/player/gasmask.mdl",
	["URBAN"] = "models/player/urban.mdl",
	["SWAT"] = "models/player/swat.mdl"
}

PEDO.VIC.WinTexts = {
  "Die Kinder waren zu schnell!",
  "Die Eltern haben die Kinder gerettet!"
}

PEDO.PEDO = {}
PEDO.PEDO.Color = Color(0,255,0,255)
PEDO.PEDO.Name = "Pedobär"
PEDO.PEDO.Models = { // Just take 4 Models or Break the Gamemode
  ["PHOENIX"] = "models/player/phoenix.mdl",
	["ARCTIC"] = "models/player/arctic.mdl",
	["GUERILLA"] = "models/player/guerilla.mdl",
	["LEET"] = "models/player/leet.mdl"
}

PEDO.PEDO.WinTexts = {
  "Der Pedobär hat es genossen!",
  "Der Pedobär will mehr!",
  "Leider ist kein Kind mehr übrig.."
}

PEDO.SPEC = {}
PEDO.SPEC.Name = "Zuschauer"
PEDO.SPEC.Color = Color(0,70,70,255)

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
