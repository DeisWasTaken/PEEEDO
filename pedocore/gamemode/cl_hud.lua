
local ROUNDTIME = PEDO.RoundTime
local Winner = ""
net.Receive( "PEDO_SendRoundStart", function( len, ply )
  timer.Create("PEDO_RoundCountCL", 1, 0, function()
    ROUNDTIME = ROUNDTIME - 1
  end)
end )

net.Receive( "PEDO_SendRoundWinner", function( len, ply ) -- 1 = VIC, 2 = PEDO
  local WinInt = net.ReadInt()
  if !IsValid(WinInt) then return end
  if WinInt == 1 then
    Winner = table.Random(PEDO.VIC.WinTexts)
  elseif WinInt == 2 then
    Winner = table.Random(PEDO.PEDO.WinTexts)
  elseif WinInt == 3 then
    Winner = ""
  end
  timer.Simple(5, function()
    Winner = ""
    ROUNDTIME = -1

  end) -- Winner auf empty überschreiben
end )

local function PEDO_PlayerHUD()
  if ROUNDTIME > 0 then
    draw.SimpleText(ROUNDTIME, "DermaDefault", 0, 0, Color( 255, 255, 255, 255 ))
  end
end

local function PEDO_EventHUD()
  draw.SimpleText(Winner, "DermaDefault", ScrW() / 2, 120, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

local function PEDO_DrawHUD()
  PEDO_EventHUD()
  if Winner != "" then
    PEDO_EventHUD()
  end
end
hook.Add("HUDPaint", "PEDO_DrawHUD", PEDO_DrawHUD)


local hide = {
	CHudHealth = true,
	CHudBattery = true,
	CHudCrosshair = true,
	CHudAmmo = true,
}

hook.Add( "HUDShouldDraw", "HideHUD", function( name )
	if ( hide[ name ] ) then return false end
end )
