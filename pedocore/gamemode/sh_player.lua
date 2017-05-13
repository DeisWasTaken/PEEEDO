
local meta = FindMetaTable("Player")
function meta:IsPedo()
  if self:Team() == TEAM_PEDO then return true end
end

function meta:GetStamina()
  return self:GetNWInt("PEDO_Stamina")
end
