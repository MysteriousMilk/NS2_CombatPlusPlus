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

    self.commanderName:DestroyAnimation("COMM_TEXT_WRITE")
	self.commanderName:SetText("COMBAT MODE")
    self.commanderName:SetColor(GUIMarineHUD.kActiveCommanderColor)

    self.resourceDisplay.pResDescription:SetText(ConditionalValue(PlayerUI_GetPersonalResources() == 1, "Upgrade Point", "Upgrade Points"))

end
