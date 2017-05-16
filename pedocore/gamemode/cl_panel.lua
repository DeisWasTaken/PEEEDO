

local blur = Material("pp/blurscreen")
local function PEDO_DrawBlur(panel, pnlty)
	local x, y = panel:LocalToScreen(0, 0)
	surface.SetDrawColor(255, 255, 255, 200)
	surface.SetMaterial(blur)

	for i = 1, 3 do
		blur:SetFloat("$blur", (i / pnlty) * 20)
		blur:Recompute()

		render.UpdateScreenEffectTexture()
		surface.DrawTexturedRect(-x, -y, ScrW(), ScrH())
	end
end


local function PEDO_F1Panel(ply)
	local BG = vgui.Create( "DFrame" )
	BG:SetSize( ScrW(), ScrH() )
  BG:SetPos( 0, 0 )
  BG:SetTitle( "" )
  BG:SetVisible( true )
  BG:SetDraggable( false )
  BG:ShowCloseButton( false )
  BG:MakePopup()
  BG.Paint = function(self)
    PEDO_DrawBlur(self, 25)
    draw.RoundedBox(4,0,0,self:GetWide(),self:GetTall(),Color(0,0,0,80))
  end

  local Frame = vgui.Create( "DFrame", BG )
  Frame:SetSize( ScrW() * 0.5, ScrH() * 0.3 )
  Frame:SetPos( ScrW() / 2 - Frame:GetWide() / 2, ScrH() / 2 - Frame:GetTall() / 2)
  Frame:SetTitle( "" )
  Frame:SetVisible( true )
  Frame:SetDraggable( false )
  Frame:ShowCloseButton( false )
  Frame:MakePopup()
  Frame.Paint = function(self)
    draw.RoundedBox(4,0,0,self:GetWide(),self:GetTall(),Color(0,0,0,40))
  end

	local CloseB = vgui.Create( "DButton", Frame )
	CloseB:SetText( "" )
	CloseB:SetSize( 20, 20 )
	CloseB:SetPos( Frame:GetWide() - CloseB:GetWide() - 3,  3 )
	CloseB.DoClick = function()
		BG:Remove()
	end
	CloseB.Paint = function(self)
		draw.SimpleText("x", "PEDOFont30", 0, -5, Color( 255, 255, 255, 255 ))
	end

	local DermaButton = vgui.Create( "DButton", Frame )
	DermaButton:SetText( "" )
	DermaButton:SetSize( Frame:GetWide() * 0.3, Frame:GetTall() * 0.5 )
	DermaButton:SetPos( Frame:GetWide() / 2 - DermaButton:GetWide() - 30,  Frame:GetTall() / 2 - DermaButton:GetTall() / 2 )
	DermaButton.DoClick = function()
		RunConsoleCommand( "PEDO_Team", "2" )
		BG:Remove()
	end
	DermaButton.Paint = function(self)
		draw.RoundedBox(4, 0, 0, self:GetWide(),self:GetTall(),Color(30,0,30,255))
	end

	local DermaButton1 = vgui.Create( "DButton", Frame )
	DermaButton1:SetText( "" )
	DermaButton1:SetSize( Frame:GetWide() * 0.3, Frame:GetTall() * 0.5 )
	DermaButton1:SetPos( Frame:GetWide() / 2 + 30,  Frame:GetTall() / 2 - DermaButton1:GetTall() / 2 )
	DermaButton1.DoClick = function()
		RunConsoleCommand( "PEDO_Team", "1" )
		BG:Remove()
	end
	DermaButton1.Paint = function(self)
		draw.RoundedBox(4, 0, 0, self:GetWide(),self:GetTall(),Color(0,30,30,255))
	end
end
concommand.Add("pnl", PEDO_F1Panel)
