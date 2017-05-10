
local ROUNDTIME = PEDO.RoundTime

net.Receive( "PEDO_SendRoundStart", function( len, ply )
  timer.Create("PEDO_RoundCountCL", 1, 0, function()
    ROUNDTIME = ROUNDTIME - 1
  end)
end )

local function PEDO_DrawHUD()
  draw.SimpleText(ROUNDTIME, "DermaDefault", 0, 0, Color( 255, 255, 255, 255 ))
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
