
local ROUNDTIME = PEDO.RoundTime
local PRETIME = PEDO.PrepareTime
local Winner = ""

local PedoScreen = false

surface.CreateFont( "PEDOFont120", {
	font = "Candy Shop", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	size = 120,
	weight = 5000,
} )

surface.CreateFont( "PEDOFont30", {
	font = "Candy Shop Black", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	size = 30,
	weight = 5000,
} )

local function PEDO_StartRoundTimer()
  timer.Create("PEDO_RoundCountCL", 1, 0, function()
    ROUNDTIME = ROUNDTIME - 1
  end)
end
hook.Add("PEDO_RoundStart", "PEDO_StartRoundTimer", PEDO_StartRoundTimer)

local function PEDO_EndRoundEvents(WinInt)
  print(WinInt)
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
end
hook.Add("PEDO_RoundEnd", "PEDO_EndRoundEvents", PEDO_EndRoundEvents)

local blur = Material( "pp/blurscreen" )
local function drawBlur( x, y, w, h )
	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.SetMaterial( blur )

	for i = 1, 6 do
		blur:SetFloat( "$blur", ( i / 6 ) * 6 )
		blur:Recompute()

		render.UpdateScreenEffectTexture()
		render.SetScissorRect( x, y, x + w, y + h, true )
			surface.DrawTexturedRect( 0, 0, ScrW(), ScrH() )
		render.SetScissorRect( 0, 0, 0, 0, false )
	end
end


local w, h = 300, 150


--hook.Add("Think", "DrawPlayerModel", function()
concommand.Add("av", function()
	local avatarsize = 175
	if iconmodel then iconmodel:Remove() end
	iconmodel = vgui.Create("DModelPanel")
	iconmodel:SetModel( LocalPlayer():GetModel())

	iconmodel:SetPos(0, ScrH()-255)
	iconmodel:SetAnimated(true)
	iconmodel:SetSize(avatarsize,avatarsize)
	iconmodel:SetCamPos( Vector( 20, 0, 65))
	iconmodel:SetLookAt( Vector( 0, 0, 66.5 ) )

	local move = iconmodel:GetEntity():LookupSequence( "taunt_robot" )
	iconmodel:GetEntity():SetSequence( move )
end)


local function PEDO_PlayerHUD()
	local lp = LocalPlayer()

  if ROUNDTIME > 0 then
    draw.SimpleText(ROUNDTIME, "DermaDefault", 0, 0, Color( 255, 255, 255, 255 ))
  end

	-- Avatar
	drawBlur(0, ScrH()-255, 175, 175)
	draw.RoundedBox(0, 0, ScrH()-255, 175, 175, Color(0,0,0,80))

	--Healthbar
	local hp = lp:Health()
	hp = hp * 3
	drawBlur(0, ScrH() - h + 70, w, 30)
	draw.RoundedBox(0, 0, ScrH() - h + 70, w, 30, Color(30,30,0,150))
	draw.RoundedBox(0, 0, ScrH() - h + 70, hp, 30, Color(255,30,0,150))

	--Staminabar
	local stamina = lp:GetStamina() or 0
	stamina = math.Clamp(stamina,0,100)

	drawBlur(0, ScrH() - h + 102, w, 30)
	draw.RoundedBox(0, 0, ScrH() - h + 102, w, 30, Color(30,30,0,150))
	draw.RoundedBox(0, 0, ScrH() - h + 102, stamina * 3, 30, Color(155,130,0,150))

	--Nickname
	local nick = lp:Nick()
	if string.len(nick) > 6 then
		nick = string.Left(nick,6).."..."
	end
	draw.SimpleText(nick, "PEDOFont30", 190, ScrH() - h + 45, Color( 255, 255, 255, 255 ))

	--debug
	draw.SimpleText(stamina, "PEDOFont30", 500, ScrH() - h + 45, Color( 255, 255, 255, 255 ))
	draw.SimpleText(lp:GetRunSpeed(), "PEDOFont30", 300, ScrH() - h + 45, Color( 255, 255, 255, 255 ))
end

local function PEDO_EventHUD()
  draw.SimpleTextOutlined(Winner, "PEDOFont120", ScrW() / 2, 120, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1,Color(0,0,0,25))
end

local function PEDO_DrawPedoSpawnScreen()
 local scrw, scrh = ScrW(), ScrH()
 draw.RoundedBox(0, 0, 0, scrw ,scrh ,Color(0,0,0))

end

local function PEDO_DrawHUD()
  PEDO_EventHUD()
  PEDO_PlayerHUD()
  if Winner != "" then
    PEDO_EventHUD()
  end
	if LocalPlayer():IsPedo() && PedoScreen then
		PEDO_DrawPedoSpawnScreen()
	end
end
hook.Add("HUDPaint", "PEDO_DrawHUD", PEDO_DrawHUD)

local function PEDO_RoundStartScreen()
	PedoScreen = true
	timer.Simple(PEDO.SpawnTime, function()
		PedoScreen = false
	end)

end
hook.Add("PEDO_RoundStart", "PEDO_RoundStartScreen", PEDO_RoundStartScreen )

local hide = {
	CHudHealth = true,
	CHudBattery = true,
	CHudCrosshair = true,
	CHudAmmo = true,
}

hook.Add( "HUDShouldDraw", "HideHUD", function( name )
	if ( hide[ name ] ) then return false end
end )
