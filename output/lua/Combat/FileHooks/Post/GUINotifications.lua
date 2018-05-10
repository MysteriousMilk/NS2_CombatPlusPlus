--[[
 * Natural Selection 2 - Combat++ Mod
 * Authors:
 *          WhiteWizard
 *
 * Turn off the point display.
]]

local ns2_GUINotifications_Update = GUINotifications.Update
function GUINotifications:Update(deltaTime)

    ns2_GUINotifications_Update(self, deltaTime)
    self.scoreDisplay:SetIsVisible(false)

end
