--[[
 * Natural Selection 2 - Combat++ Mod
 * Authors:
 *          WhiteWizard
 *
 * Give xp for healing.
 *
 * Wrapped Functions:
 *  'ScoringMixin:AddContinuousScore' - Hooks the AddContinuousScore function to catch when points
 *  are being added for healing.
]]

local ns2_ScoringMixing_AddContinuousScore = ScoringMixin.AddContinuousScore
function ScoringMixin:AddContinuousScore(name, addAmount, amountNeededToScore, pointsGivenOnScore)

    -- easier to hook the healing here
    if Server and name == "HealSpray" and self:isa("Alien") then
        self:AddCombatHealingPoints(addAmount)
    end

    ns2_ScoringMixing_AddContinuousScore(self, name, addAmount, amountNeededToScore, pointsGivenOnScore)

end
