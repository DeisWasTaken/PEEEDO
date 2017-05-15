

local blur = Material("pp/blurscreen")
function PEDO_DrawBlur(panel)
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


local function PEDO_F1Panel(ply)
  local Frame = vgui.Create( "DFrame" )
  Frame:SetSize( ScrW() * 0.5, ScrH() * 0.3 )
  Frame:SetPos( ScrW() / 2 - Frame:GetWide() / 2, ScrH() / 2 - Frame:GetTall() / 2)
  Frame:SetTitle( "" )
  Frame:SetVisible( true )
  Frame:SetDraggable( false )
  Frame:ShowCloseButton( true )
  Frame:MakePopup()
  Frame.Paint = function(self)
    PEDO_DrawBlur(self)
    draw.RoundedBox(4,0,0,self:GetWide(),self:GetTall(),Color(0,0,0,40))
    draw.RoundedBox(4,0,0,self:GetWide(),self:GetTall(),Color(255,179,0,130))
  end
end
concommand.Add("pnl", PEDO_F1Panel)
