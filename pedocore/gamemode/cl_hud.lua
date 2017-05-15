
local ROUNDTIME = PEDO.RoundTime
local PRETIME = PEDO.PrepareTime
local Winner = ""
local PedoScreen = false
local PEDO_WantedPersons = 0

local Avatar = {}
local DPanel = {}

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

surface.CreateFont( "Wanted1080", {
	font = "Western Dead", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	size = 40,
	weight = 500,
} )

surface.CreateFont( "WantedSmall1080", {
	font = "Western Dead", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	size = 30,
	weight = 500,
} )

surface.CreateFont( "Wanted720", {
	font = "Western Dead", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	size = 30,
	weight = 500,
} )

surface.CreateFont( "WantedSmall720", {
	font = "Western Dead", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	size = 20,
	weight = 500,
} )

local function PEDO_StartRoundTimer()
	ROUNDTIME = PEDO.RoundTime
  timer.Create("PEDO_RoundCountCL", 1, 0, function()
    ROUNDTIME = ROUNDTIME - 1
  end)
end
hook.Add("PEDO_RoundStart", "PEDO_StartRoundTimer", PEDO_StartRoundTimer)

local function PEDO_EndRoundEvents(WinInt)
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
	PEDO_WantedPersons = 0

	for k,v in pairs(DPanel) do
		v:Remove()
	end
	for k,v in pairs(Avatar) do
		v:Remove()
	end
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
	local lp = LocalPlayer()
	local model = lp:GetModel()
	local campos = Vector(20, 0, 65)
	local lookpos = Vector(0, 0, 66.5)
	if lp:Team() == TEAM_PEDO then
		model = "models/player/pbear/pbear.mdl"
		campos = Vector(40, 0, 100)
	end
	if iconmodel then iconmodel:Remove() end
	iconmodel = vgui.Create("DModelPanel")
	iconmodel:SetModel( model )

	iconmodel:SetPos(0, ScrH()-255)
	iconmodel:SetAnimated(true)
	iconmodel:SetSize(avatarsize,avatarsize)
	iconmodel:SetCamPos( campos)
	iconmodel:SetLookAt( lookpos )

	local move = iconmodel:GetEntity():LookupSequence( "taunt_robot" )
	iconmodel:GetEntity():SetSequence( move )
end)

local blur = Material("pp/blurscreen")
local function PEDO_DrawBlur(panel)
	local x, y = panel:LocalToScreen(0, 0)

	surface.SetDrawColor(255, 255, 255, 200)
	surface.SetMaterial(blur)

	for i = 1, 3 do
		blur:SetFloat("$blur", (i / 5) * 20)
		blur:Recompute()

		render.UpdateScreenEffectTexture()
		surface.DrawTexturedRect(-x, -y, ScrW(), ScrH())
	end
end


local function PEDO_DrawAvatars(id, ply)
	if id == 3 then id = 4 end
	Avatar[id] = vgui.Create( "AvatarImage" )
	Avatar[id]:SetSize( ScrW() * 0.03, ScrH() * 0.05 )
	Avatar[id]:SetPos( ScrW() * 0.095 + id * ScrW() * 0.13, ScrH() * 0.04 )
	Avatar[id]:SetPlayer( ply, 64 )
end

local function PEDO_RemoveAvatars(id)
	if id == 3 then id = 4 end
	if Avatar[id] then Avatar[id]:Remove() end
	PEDO_RemoveAvatars(id)
end

local function PEDO_MostWanted(id, ply)
	if id == 3 then id = 4 end
	if !IsValid(ply) then return end
	local nick = ply:Nick()
	if string.len(nick) >= 7 then
		nick = string.Left(nick, 7).."..."
	end
	DPanel[id] = vgui.Create( "DPanel" )
	DPanel[id]:SetPos( ScrW() * 0.06 + id * ScrW() * 0.13, 0 ) -- Set the position of the panel
	DPanel[id]:SetSize( ScrW() * 0.1, ScrH() * 0.12 ) -- Set the size of the panel
	DPanel[id].Paint = function(self)
		--drawBlur(0,0,self:GetWide(), self:GetTall())
		--PEDO_DrawBlur(self)
		draw.RoundedBox(0, 0, 0, ScrW() * 0.1, ScrH() * 0.12, Color(0,0,0,80))
		if ScrH() > 720 then
			draw.SimpleTextOutlined("Wanted", "Wanted1080", self:GetWide() / 2, 22, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER,1,Color(0,0,0, 100))
			draw.SimpleTextOutlined(nick, "WantedSmall1080", self:GetWide() / 2, self:GetTall() * 0.88, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER,1,Color(0,0,0, 100))
		else
			draw.SimpleTextOutlined("Wanted", "Wanted720", self:GetWide() / 2, 15, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER,1,Color(0,0,0, 100))
			draw.SimpleTextOutlined(nick, "WantedSmall720", self:GetWide() / 2, self:GetTall() * 0.88, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER,1,Color(0,0,0, 100))
		end
	end
	PEDO_DrawAvatars(id, ply)
end

local function PEDO_RemoveMostWanted(id)
	if id == 3 then id = 4 end
	if DPanel[id] then DPanel[id]:Remove() end
end

concommand.Add("DeleteAvatars", function(ply) --debug
	PEDO_RemoveMostWanted(0)
	PEDO_RemoveMostWanted(1)
	PEDO_RemoveMostWanted(2)
	PEDO_RemoveMostWanted(4)
	PEDO_RemoveMostWanted(5)
	PEDO_RemoveMostWanted(6)
end)

concommand.Add("Avatars", function(ply) --debug
	PEDO_MostWanted(0, ply)
	PEDO_MostWanted(1, ply)
	PEDO_MostWanted(2, ply)
	PEDO_MostWanted(4, ply)
	PEDO_MostWanted(5, ply)
	PEDO_MostWanted(6, ply)
end)


local function PEDO_DrawWanted(len, ply)
	for k,v in pairs(team.GetPlayers(TEAM_VICTIM)) do
		if v:Alive() then
			PEDO_WantedPersons = PEDO_WantedPersons + 1
		end
	end

	for k,v in pairs(team.GetPlayers(TEAM_VICTIM)) do
		if PEDO_WantedPersons <= 6 then
			if v:Alive() then
				PEDO_MostWanted(k, v)
			end
		end
	end
end
net.Receive("PEDO_PlayerDied", PEDO_DrawWanted)

local function PEDO_PlayerHUD()
	local lp = LocalPlayer()
  if ROUNDTIME > 0 then
		drawBlur(ScrW() / 2 - 45, -10, 90, 70)
		draw.RoundedBox(8, ScrW() / 2 - 45, -10, 90, 70, Color(0,0,0,80))
    draw.SimpleTextOutlined(string.ToMinutesSeconds(ROUNDTIME), "PEDOFont30", ScrW() / 2, 30, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 100))
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
	LocalPlayer():ChatPrint(tostring(PedoScreen))
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
