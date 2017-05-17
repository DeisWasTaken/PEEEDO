
include( "shared.lua" )
include( "cl_hud.lua" )
include( "cl_panel.lua" )
include( "sh_player.lua" )
include( "cl_notification.lua" )

surface.CreateFont( "CoreFont26", {
	font = "Open Sans", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	size = 26,
	weight = 500,
} )

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

surface.CreateFont( "PEDOFont40", {
	font = "Candy Shop Black", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	size = 40,
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

local function PEDO_AddPlayer(ply, panel)
  local player = ply
  if player:Alive() then
    player.col = 100
  else
    player.col = 50
  end
  local bg = vgui.Create("DPanel", panel)
  bg:SetSize(panel:GetWide(), 32)
  bg:SetPos(5,5)
  bg.Paint = function(w,h)
    local plyCol = team.GetColor(player:Team()) or Color(255,255,255,255)
    surface.SetDrawColor(plyCol.r,plyCol.g,plyCol.b,player.col)
    surface.DrawRect(0,0,bg:GetWide(),bg:GetTall())
    surface.SetDrawColor(255, 255, 255, 7)
    surface.DrawOutlinedRect(0, 0, panel:GetWide(), panel:GetTall())
  end

  local avatar = vgui.Create("AvatarImage", bg)
  avatar:SetSize(32, 32)
  avatar:SetPos(0, 0)
  avatar:SetPlayer(player, 32)

  local overlay = vgui.Create("DPanel", bg)
  overlay:SetSize(32, 32)
  overlay:SetPos(0, 0)
  overlay.Paint = function(self,w,h)
    if !player:Alive() then
      draw.RoundedBox(0,0,0,w,h,Color(0,0,0,180))
      surface.SetDrawColor( 255, 255, 255 )
      surface.SetMaterial( Material( "core/van_speed_px32.png" ) )
      surface.DrawTexturedRect( 0, 0, 32, 32 )
    end
  end

  local title = vgui.Create("DLabel", bg)
  title:SetText(player:Nick())
  title:SetTextColor(Color(255,255,255,255))
  title:SetPos(40,3)
  title:SetFont("CoreFont26")
  title:SizeToContents()

  local copysteamid = vgui.Create("DButton", bg)
  copysteamid:SetText("")
  copysteamid:SetPos(32+7,3)
  copysteamid.DoClick = function()
    LocalPlayer():ChatPrint("SteamID wurde kopiert")
    SetClipboardText(player:SteamID())
  end
  copysteamid.Paint = function()
  end

  local ping = vgui.Create("DLabel", bg)
  ping:SetText(player:Ping())
  ping:SetPos(bg:GetWide()-100,3)
  ping:SetFont("CoreFont26")
  ping:SizeToContents()
  ping:SetColor(Color(245,245,245,255))

  local kd = vgui.Create("DLabel", bg)
  kd:SetFont("CoreFont26")
  kd:SetText(player:Frags().."/"..player:Deaths())
  kd:SetPos(bg:GetWide()- 210 - kd:GetWide() / 2 ,3)
  kd:SizeToContents()
  kd:SetColor(Color(245,245,245,255))

  if player != LocalPlayer() then
    local MuteButton = vgui.Create("DButton", bg)
    MuteButton:SetPos( bg:GetWide() - 34, 0 )
    MuteButton:SetText( "" )
    MuteButton:SetSize( 32, 32 )
    MuteButton.DoClick = function()
      if player:IsMuted() then
        player:SetMuted(false)
      else
        player:SetMuted(true)
      end
    end
    MuteButton.Paint = function()
      surface.SetDrawColor( 255, 255, 255 )
      if player:IsMuted() then
        surface.SetMaterial( Material( "core/mute1.png" ) )
      else
        surface.SetMaterial( Material( "core/unmute1.png" ) )
      end
      surface.DrawTexturedRect( 0, 0, 32, 32 )
    end
  end
  return bg
end

function PEDO.Scoreboard:Init()
	local Team1 = team.GetPlayers(TEAM_VICTIM)
  local Team2 = team.GetPlayers(TEAM_PEDO)

  local pedos = #Team2
  if pedos > 5 then pedos = 5 end

	table.sort(Team1, function(a, b)
		return(a:Frags() > b:Frags() )
	end)

	self:SetSize(ScrW() * 0.5, ScrH() * 0.8)
	self:Center()

  self.Scroll1 = vgui.Create( "DScrollPanel", self )
  self.Scroll1:SetSize( self:GetWide(), 32 * pedos )
  self.Scroll1:SetPos( 0, 119 )
  self.Scroll1.Paint = function() end
  local sbar = self.Scroll1:GetVBar()
  function sbar:Paint( w, h )  end
  function sbar.btnUp:Paint( w, h ) end
  function sbar.btnDown:Paint( w, h ) end
  function sbar.btnGrip:Paint( w, h ) end

  self.Scroll2 = vgui.Create( "DScrollPanel", self )
  self.Scroll2:SetSize( self:GetWide(), self:GetTall() * 0.77 - self.Scroll1:GetTall())
  self.Scroll2:SetPos( 0, self:GetTall() * 0.19 + self.Scroll1:GetTall() )
  self.Scroll2.Paint = function() end
  local sbar = self.Scroll2:GetVBar()
  function sbar:Paint( w, h )  end
  function sbar.btnUp:Paint( w, h ) end
  function sbar.btnDown:Paint( w, h ) end
  function sbar.btnGrip:Paint( w, h ) end

	self.PanelList = vgui.Create("DIconLayout", self.Scroll1)
	self.PanelList:SetPos(0, 0)
	self.PanelList:SetSize(self:GetWide(), self:GetTall() / 2)
	self.PanelList.Paint = function() end

  self.PanelList2 = vgui.Create("DIconLayout", self.Scroll2)
	self.PanelList2:SetPos(0, 0)
	self.PanelList2:SetSize(self:GetWide(), self:GetTall() / 2)
	self.PanelList2.Paint = function() end

	for k, v in ipairs(Team2) do
    local temp = PEDO_AddPlayer(v, self.PanelList)
    self.PanelList:Add(temp)
	end

  for k, v in ipairs(Team1) do
    local temp = PEDO_AddPlayer(v, self.PanelList2)
    self.PanelList2:Add(temp)
	end
end

function PEDO.Scoreboard:Paint(w,h)
	PEDO_DrawBlur(self)
	surface.SetDrawColor(255,255,255,10)
	surface.DrawRect(0, 0, self:GetWide(), self:GetTall())

	surface.SetDrawColor(0,100,30,255)
	surface.DrawRect(0, 0, self:GetWide(), 50)

	surface.DrawRect(0, self:GetTall() * 0.14 - 1 + self.Scroll1:GetTall(), self:GetWide(), 44)
  draw.SimpleText(PEDO.VIC.Name, "PEDOFont40", self:GetWide()/2, self:GetTall() * 0.14 -1 + self.Scroll1:GetTall() + 20, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

  surface.DrawRect(0, 75, self:GetWide(), 44)
  draw.SimpleText(PEDO.PEDO.Name, "PEDOFont40", self:GetWide()/2, 95, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

	surface.DrawRect(0, self:GetTall() - 32, self:GetWide(), 32)

	draw.SimpleText(GetHostName(), "PEDOFont40", self:GetWide()/2, 5, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_LEFT)

	draw.SimpleText("Name", "CoreFont24", 35, 48, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
	draw.SimpleText("Ping", "CoreFont24", self:GetWide() - 75, 48, Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_LEFT)
	draw.SimpleText("Kills/Deaths", "CoreFont24", self:GetWide() - 170, 48, Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_LEFT)
end
vgui.Register("PEDO_Scoreboard", PEDO.Scoreboard, "DPanel")

function GM.ScoreboardShow()
	if IsValid(ScoreboardPanel) then
		ScoreboardPanel:Remove()
	end
	ScoreboardPanel = vgui.Create("PEDO_Scoreboard")
end

function GM.ScoreboardHide()
	if IsValid(ScoreboardPanel) then
		ScoreboardPanel:Remove()
	end
end

function GM:OnContextMenuOpen()
	gui.EnableScreenClicker(true)
end

function GM:OnContextMenuClose()
	gui.EnableScreenClicker(false)
end
