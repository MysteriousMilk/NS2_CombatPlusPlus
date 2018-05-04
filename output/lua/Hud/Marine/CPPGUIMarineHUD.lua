--[[
 * Natural Selection 2 - Combat++ Mod
 * Authors:
 *          WhiteWizard
 *
 * Wrapped Functions:
 *  'GUIMarineHUD:Update' - Fix to make sure weapon and armor level icons don't go red on the HUD
 *  when there is no arms lab.
]]

local ns2_GUIMarineHUD_Update = GUIMarineHUD.Update
function GUIMarineHUD:Update(deltaTime)

    ns2_GUIMarineHUD_Update(self, deltaTime)

    local useColor = kIconColors[kMarineTeamType]
    self.weaponLevel:SetColor(useColor)
    self.armorLevel:SetColor(useColor)

end
