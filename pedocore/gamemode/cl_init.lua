
include( "shared.lua" )
include( "cl_hud.lua" )
include( "cl_panel.lua" )
include( "sh_player.lua" )
include( "cl_notification.lua" )
include( "cl_player.lua" )
include( "cl_scoreboard.lua" )

surface.CreateFont( "CoreFont24", {
	font = "Open Sans", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	size = 24,
	weight = 500,
} )

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

local blur = Material( "pp/blurscreen" )
function PEDO_DrawBlur( x, y, w, h )
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

function PEDO_DrawPanelBlur(panel)
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
