
local NOTIFICATION_COUNT = 0
local Frame = {}

local function PEDO_FadeAlpha(panel)
	timer.Simple(4, function()
		hook.Add("Think", "PEDO_FadeNotification", function()
			if !panel then return end
			if !panel.alpha then return end
			panel.alpha = panel.alpha - 2
			if panel.alpha <= 0 then
				hook.Remove("Think", "PEDO_FadeNotification")
				panel:Remove()
				if NOTIFICATION_COUNT >= 0 then NOTIFICATION_COUNT = 0 end
				NOTIFICATION_COUNT = NOTIFICATION_COUNT - 1
			end
		end)
	end)
end

function PEDO_DrawNotification(text)
	NOTIFICATION_COUNT = NOTIFICATION_COUNT + 1
	Frame = vgui.Create( "DFrame" )
	Frame.alpha = 255
	Frame:SetPos( ScrW() - 400, ScrH() / 2 - 200 + (NOTIFICATION_COUNT * 35 ))
	Frame:SetSize( 400, 30 )
	Frame:SetTitle( "" )
	Frame:SetDraggable( false )
	Frame:ShowCloseButton( false )
	Frame.Paint = function(self)
		PEDO_FadeAlpha(self)
		if self.alpha > 230 then
			PEDO_DrawPanelBlur(self)
		end
		draw.RoundedBox(0,0,0,self:GetWide(),self:GetTall(),Color(80,80,80, self.alpha - 200))
		draw.SimpleText(text, "PEDOFont30", self:GetWide() / 2, 15, Color(255,255,2555, self.alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
	timer.Simple(PEDO.NotificationTime, function()
		if Frame then
			Frame:Remove()
		if NOTIFICATION_COUNT <= 0 then NOTIFICATION_COUNT = 0 end
		NOTIFICATION_COUNT = NOTIFICATION_COUNT - 1
		end
	end)
end

local function PEDO_GetNotification(len, ply)
	local msg = net.ReadString()
	PEDO_DrawNotification(msg)
end
net.Receive( "PEDO_Notification", PEDO_GetNotification)
