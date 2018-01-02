--[[
 * Natural Selection 2 - Combat++ Mod
 * Authors:
 *          WhiteWizard
 *
 * Report Combat Kills and Assists.
 *
 * Wrapped Functions:
 *  'ScoringMixin:AddKill' - Added code to add a combat kill.
 *  'ScoringMixin:AddAssistKill' - Added code to add a combat assist kill.
]]

local ns2_ScoringMixin_AddKill = ScoringMixin.AddKill
function ScoringMixin:AddKill()

    ns2_ScoringMixin_AddKill(self)

    if HasMixin(self, "CombatScore") then
        self:AddCombatKill()
    end

end

local ns2_ScoringMixin_AddAssistKill = ScoringMixin.AddAssistKill
function ScoringMixin:AddAssistKill()

    ns2_ScoringMixin_AddAssistKill(self)

    if HasMixin(self, "CombatScore") then
        self:AddCombatAssistKill()
    end

end
