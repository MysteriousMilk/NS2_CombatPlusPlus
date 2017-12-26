--[[
 * Natural Selection 2 - Combat++ Mod
 * Created by: WhiteWizard
 *
 * Adds additional functionality to the PointGiverMixin to handle Combat XP.
]]

local ns2_PointGiverMixin_Init = PointGiverMixin.__initmixin
function PointGiverMixin:__initmixin()

    ns2_PointGiverMixin_Init(self)

    if Server then
        self.pointsSinceLastXPAward = {}
    end

end

if Server then

    local ns2_PointGiverMixin_OnEntityChange = PointGiverMixin.OnEntityChange
    function PointGiverMixin:OnEntityChange(oldId, newId)

        ns2_PointGiverMixin_OnEntityChange(self, oldId, newId)

        if self.pointsSinceLastXPAward[oldId] then
            if newId and newId ~= Entity.invalidId then
                self.pointsSinceLastXPAward[newId] = self.pointsSinceLastXPAward[oldId]
            end
            self.pointsSinceLastXPAward[oldId] = nil
        end

    end

    local ns2_PointGiverMixin_OnTakeDamage = PointGiverMixin.OnTakeDamage
    function PointGiverMixin:OnTakeDamage(damage, attacker, doer, point, direction, damageType, preventAlert)

        ns2_PointGiverMixin_OnTakeDamage(self, damage, attacker, doer, point, direction, damageType, preventAlert)

        if attacker and attacker:isa("Player") and GetAreEnemies(self, attacker) then

            local attackerId = attacker:GetId()

            if not self.pointsSinceLastXPAward[attackerId] then
                self.pointsSinceLastXPAward[attackerId] = 0
            end

            -- store the damage the current attacker is dealing
            self.pointsSinceLastXPAward[attackerId] = self.pointsSinceLastXPAward[attackerId] + damage

            -- if the current attacker crosses the threshold required, reward a little xp
            if self.pointsSinceLastXPAward[attackerId] >= kDamageRequiredXPReward then

                -- make sure not to let the remaining xp "leak"
                self.pointsSinceLastXPAward[attackerId] = self.pointsSinceLastXPAward[attackerId] - kDamageRequiredXPReward

                if HasMixin(attacker, "Scoring") then
                    attacker:AddXP(kDamageRequiredXPReward * kDamageXPModifier, kXPSourceType.damage, self:GetId())
                end

            end

        end

    end

end
