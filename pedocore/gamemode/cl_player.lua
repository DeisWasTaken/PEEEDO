
local function PEDO_GetInitialSpawn(len, ply)
  LocalPlayer().thirdperson = false
end
net.Receive("PEDO_PlayerInitialSpawn", PEDO_GetInitialSpawn)

function PEDO_Thirdperson(ply, pos, angles, fov)
    local firstperson = {}
    local thirdperson = {}

    firstperson.origin = pos
    firstperson.angles = angles
    firstperson.fov = fov


    thirdperson.origin = pos - (angles:Forward()*100) + (angles:Right()*0) + (angles:Up()*10)
    if ply.thirdperson then
      return thirdperson
    else
      return firstperson
    end
end
hook.Add("CalcView", "PEDO_Thirdperson", PEDO_Thirdperson)

local function PEDO_DrawLocalPlayer(ply)
  if ply.thirdperson then
    return true
  end
end
hook.Add("ShouldDrawLocalPlayer", "PEDO_DrawLocalPlayer", PEDO_DrawLocalPlayer)

local function PEDO_ToggleThirdPerson(ply)
  if ply.thirdperson then
    ply.thirdperson = false
  else
    ply.thirdperson = true
  end
end
concommand.Add("PEDO_Thirdperson", PEDO_ToggleThirdPerson)

hook.Add("CreateMove",'F8_Thirsperson', function()
	local ply = LocalPlayer()
	if input.WasKeyPressed(KEY_F8) then
		ply:ConCommand("PEDO_Thirdperson")
	end
end)

