--[[
 * Natural Selection 2 - Combat++ Mod
 * Authors:
 *          WhiteWizard
 *
 * Makes ajustments to the alien team.
 *
 * Hooked Functions:
 *  'AlienTeamInfo:Update' - Sets the spur, shell and veil level to 3.
]]

local ns2_AlienTeamInfo_OnUpdate = AlienTeamInfo.OnUpdate
function AlienTeamInfo:OnUpdate(deltaTime)

    ns2_AlienTeamInfo_OnUpdate(self, deltaTime)

    self.veilLevel = 3
    self.spurLevel = 3
    self.shellLevel = 3

end