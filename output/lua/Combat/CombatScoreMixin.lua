--[[
 * Natural Selection 2 - Combat++ Mod
 * Authors:
 *          WhiteWizard
 *
 * New mixin to track Combat++ specific values for players.
 *
 * Provides a progression system (xp->rank) and awards upgrade points when
 * certain criteria is met.
]]

Script.Load("lua/Combat/Globals.lua")

CombatScoreMixin = CreateMixin(CombatScoreMixin)
CombatScoreMixin.type = "CombatScore"

CombatScoreMixin.optionalCallbacks =
{
    OnLevelUp = "Called when the player receives a new level/rank."
}

CombatScoreMixin.networkVars =
{
    combatXP = "integer",
    combatRank = "integer",
    combatUpgradePoints = "integer"
}

function CombatScoreMixin:__initmixin()

    self:ResetCombatScores()

end

function CombatScoreMixin:GetCombatXP()
    return self.combatXP
end

function CombatScoreMixin:AddXP(xp, source, targetId)

    if Server and xp and xp ~= 0 and not GetGameInfoEntity():GetWarmUpActive() then

        -- Check to see if xp should be scaled
        if CombatPlusPlus_GetIsScalableXPType(source) then
            xp = ScaleXPByDistance(self, xp)
        end

        self.combatXP = Clamp(self.combatXP + xp, 0, kMaxCombatXP)
        local currentRank = CombatPlusPlus_GetRankByXP(self.combatXP)

        -- check for rank change
        local numberOfRanksEarned = currentRank - self.combatRank
        
        -- update current rank
        self.combatRank = currentRank

        if numberOfRanksEarned > 0 then

            --give upgrade points for number of ranks earned
            self:GiveCombatUpgradePoints(kUpgradePointSourceType.LevelUp, numberOfRanksEarned)

            if self.OnLevelUp then
                self:OnLevelUp()
            end
            
        end

        -- notify the client so that we can print the xp gain on screen
        Server.SendNetworkMessage(Server.GetOwner(self), "CombatScoreUpdate", { xp = xp, source = source, targetId = targetId }, true)

        if not self.combatXPGainedCurrentLife then
            self.combatXPGainedCurrentLife = 0
        end

        self.combatXPGainedCurrentLife = self.combatXPGainedCurrentLife + xp

    end

end

function CombatScoreMixin:BalanceXp(averageXp)
    
    local xpDiff = averageXp - self:GetCombatXP()
    
    if xpDiff > 0 then
        self:AddXP(xpDiff, kXPSourceType.Balance, Entity.invalidId)
    end
    
end    

function CombatScoreMixin:GetCombatRank()
    return self.combatRank
end

function CombatScoreMixin:GiveCombatRank(rank)

    local rankToGive = Clamp(rank, 1, kMaxCombatRank)
    local xpToGive = CombatPlusPlus_GetXPThresholdByRank(rankToGive) - self.combatXP

    self:AddXP(xpToGive, kXPSourceType.Console, Entity.invalidId)

end

function CombatScoreMixin:GetCombatUpgradePoints()
    return self.combatUpgradePoints
end

function CombatScoreMixin:SetCombatUpgradePoints(upgradePoints)
    self.combatUpgradePoints = Clamp(upgradePoints, 0, kMaxCombatUpgradePoints)
end

function CombatScoreMixin:GiveCombatUpgradePoints(source, points, notify)

    if Server and not GetGameInfoEntity():GetWarmUpActive() then

        if points == nil then
            points = 1
        end

        self.combatUpgradePoints = Clamp(self.combatUpgradePoints + points, 0, kMaxCombatUpgradePoints)

        if notify then
            -- notify the client about the new upgrade points
            Server.SendNetworkMessage(Server.GetOwner(self), "CombatUpgradePointUpdate", { source = source, points = points }, true)
        end

    end

end

function CombatScoreMixin:SpendUpgradePoints(pointsToSpend)

    if Server and not GetGameInfoEntity():GetWarmUpActive() then

        if (self.combatUpgradePoints - pointsToSpend) < 0 then
            Shared.Message("Warning: Upgrade points spent that were not available.")
        end

        self.combatUpgradePoints = Clamp(self.combatUpgradePoints - pointsToSpend, 0, kMaxCombatUpgradePoints)

    end

end

function CombatScoreMixin:Refund(techId, notify)

    local cost = LookupUpgradeData(techId, kUpDataCostIndex)
    self:GiveCombatUpgradePoints(kUpgradePointSourceType.Refund, cost, notify)

end

if Server then

    function CombatScoreMixin:CopyPlayerDataFrom(player)

        self.combatXP = player.combatXP
        self.combatRank = player.combatRank
        self.combatUpgradePoints = player.combatUpgradePoints

    end

    function CombatScoreMixin:OnKill()

        self.combatXPGainedCurrentLife = 0
        self.killsGainedCurrentLife = 0
        self.assistsGainedCurrentLife = 0
        self.damageDealtCurrentLife = 0
        self.damageDealerAwardReceived = false
        self.armorWeledSinceLastXPAward = 0
        self.healingAmountSinceLastXPAward = 0
        self.damageSinceLastXPAward = 0

    end

end

function CombatScoreMixin:AddCombatKill(victimRank)

    if GetGameInfoEntity():GetWarmUpActive() then return end

    if not self.combatXP then
        self.combatXP = 0
    end

    if  not self.killsGainedCurrentLife then
        self.killsGainedCurrentLife = 0
    end

    self.killsGainedCurrentLife = self.killsGainedCurrentLife + 1

    self:AddXP(CombatPlusPlus_GetBaseKillXP(victimRank), kXPSourceType.Kill, Entity.invalidId)

    if self.killsGainedCurrentLife == kKillsForRampageReward then
        self:AddXP(CombatPlusPlus_GetSpecialXpAwardAmount(kXPSourceType.KillStreak), kXPSourceType.KillStreak)
    end

end

function CombatScoreMixin:AddCombatAssistKill(victimRank)

    if GetGameInfoEntity():GetWarmUpActive() then return end

    if not self.combatXP then
        self.combatXP = 0
    end

    if not self.assistsGainedCurrentLife then
        self.assistsGainedCurrentLife = 0
    end

    self.assistsGainedCurrentLife = self.assistsGainedCurrentLife + 1

    local xp = CombatPlusPlus_GetBaseKillXP(victimRank) * kXPAssistModifier
    self:AddXP(xp, kXPSourceType.Assist, Entity.invalidId)

    if self.assistsGainedCurrentLife == kAssistsForAssistReward then
        self:AddXP(CombatPlusPlus_GetSpecialXpAwardAmount(kXPSourceType.AssistStreak), kXPSourceType.AssistStreak)
    end

end

function CombatScoreMixin:AddCombatNearbyKill(victimRank)

    if GetGameInfoEntity():GetWarmUpActive() then return end

    if not self.combatXP then
        self.combatXP = 0
    end

    local xp = CombatPlusPlus_GetBaseKillXP(victimRank) * kNearbyKillXPModifier
    self:AddXP(xp, kXPSourceType.Nearby, Entity.invalidId)

end

function CombatScoreMixin:AddCombatDamage(damage)

    if GetGameInfoEntity():GetWarmUpActive() then return end

    if not self.combatXP then
        self.combatXP = 0
    end

    if not self.damageDealtCurrentLife then
        self.damageDealtCurrentLife = 0
    end

    self.damageDealtCurrentLife = self.damageDealtCurrentLife + damage
    self.damageSinceLastXPAward = self.damageSinceLastXPAward + damage

    -- if the current damage amount crosses the threshold required, reward a little xp
    if self.damageSinceLastXPAward >= kDamageRequiredXPReward then

        -- make sure not to let the remaining damage points "leak"
        self.damageSinceLastXPAward = self.damageSinceLastXPAward - kDamageRequiredXPReward

        -- add the xp
        self:AddXP(kDamageRequiredXPReward * kDamageXPModifier, kXPSourceType.Damage)

    end

    if not self.damageDealerAwardReceived and self.damageDealtCurrentLife >= kDamageForDamageDealerAward then
        self:AddXP(CombatPlusPlus_GetSpecialXpAwardAmount(kXPSourceType.DamageDealer), kXPSourceType.DamageDealer)
        self.damageDealerAwardReceived = true
    end

end

function CombatScoreMixin:AddCombatWeldPoints(weldAmount)

    if GetGameInfoEntity():GetWarmUpActive() then return end

    if not self.combatXP then
        self.combatXP = 0
    end

    if not self.armorWeledSinceLastXPAward then
        self.armorWeledSinceLastXPAward = 0
    end

    self.armorWeledSinceLastXPAward = self.armorWeledSinceLastXPAward + weldAmount

    -- if the current weld amount crosses the threshold required, reward a little xp
    if self.armorWeledSinceLastXPAward >= kWeldingRequiredXPReward then

        -- make sure not to let the remaining weld points "leak"
        self.armorWeledSinceLastXPAward = self.armorWeledSinceLastXPAward - kWeldingRequiredXPReward

        -- add the xp
        self:AddXP(kWeldingRequiredXPReward * kWeldingXPModifier, kXPSourceType.Weld)

    end

end

function CombatScoreMixin:AddCombatHealingPoints(healingAmount)

    if GetGameInfoEntity():GetWarmUpActive() then return end

    if not self.combatXP then
        self.combatXP = 0
    end

    if not self.healingAmountSinceLastXPAward then
        self.healingAmountSinceLastXPAward = 0
    end

    self.healingAmountSinceLastXPAward = self.healingAmountSinceLastXPAward + healingAmount

    -- if the current healing amount crosses the threshold required, reward a little xp
    if self.healingAmountSinceLastXPAward >= kHealingRequiredXPReward then

        -- make sure not to let the remaining healing points "leak"
        self.healingAmountSinceLastXPAward = self.healingAmountSinceLastXPAward - kHealingRequiredXPReward

        -- add the xp
        self:AddXP(kHealingRequiredXPReward * kHealingXPModifier, kXPSourceType.Heal)

    end

end

function CombatScoreMixin:ResetCombatScores()

    self.combatXP = 0
    self.combatRank = 1
    self.combatUpgradePoints = CombatSettings["UpgradePointsAtStart"]
    self.combatXPGainedCurrentLife = 0
    self.killsGainedCurrentLife = 0
    self.assistsGainedCurrentLife = 0
    self.damageDealtCurrentLife = 0
    self.damageDealerAwardReceived = false
    self.armorWeledSinceLastXPAward = 0
    self.healingAmountSinceLastXPAward = 0
    self.damageSinceLastXPAward = 0

end
