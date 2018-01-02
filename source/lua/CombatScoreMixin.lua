--[[
 * Natural Selection 2 - Combat++ Mod
 * Authors:
 *          WhiteWizard
 *
 * New mixin to track Combat++ specific values for players.
 *
 * Provides a progression system (xp->rank) and awards skill points when
 * certain criteria is met.
]]


CombatScoreMixin = CreateMixin(CombatScoreMixin)
CombatScoreMixin.type = "CombatScore"

CombatScoreMixin.networkVars =
{
    combatXP = "integer",
    combatRank = "integer",
    combatSkillPoints = "integer"
}

function CombatScoreMixin:__initmixin()

    self:ResetCombatScores()

end

function CombatScoreMixin:GetCombatXP()
    return self.combatXP
end

function CombatScoreMixin:AddXP(xp, source, targetId)

    if Server and xp and xp ~= 0 and not GetGameInfoEntity():GetWarmUpActive() then

        self.combatXP = Clamp(self.combatXP + xp, 0, kMaxCombatXP)
        local currentRank = CombatPlusPlus_GetRankByXP(self.combatXP)

        -- check for rank change, and if so, give skill point
        if self.combatRank < currentRank then
            self:GiveSkillPoint(kSkillPointSourceType.LevelUp)
        end

        -- update current rank
        self.combatRank = currentRank

        -- notify the client so that we can print the xp gain on screen
        Server.SendNetworkMessage(Server.GetOwner(self), "CombatScoreUpdate", { xp = xp, source = source, targetId = targetId }, true)

        if not self.combatXPGainedCurrentLife then
            self.combatXPGainedCurrentLife = 0
        end

        self.combatXPGainedCurrentLife = self.combatXPGainedCurrentLife + xp

    end

end

function CombatScoreMixin:GetCombatRank()
    return self.combatRank
end

function CombatScoreMixin:GetCombatSkillPoints()
    return self.combatSkillPoints
end

function CombatScoreMixin:GiveSkillPoint(source)

    if Server and not GetGameInfoEntity():GetWarmUpActive() then

        self.combatSkillPoints = self.combatSkillPoints + 1

        -- notify the client about the new skill points
        Server.SendNetworkMessage(Server.GetOwner(self), "CombatSkillPointUpdate", { source = source, kills = self.killsGainedCurrentLife, assists = self.assistsGainedCurrentLife }, true)

    end

end

function CombatScoreMixin:SpendSkillPoints(pointsToSpend)

    if Server and not GetGameInfoEntity():GetWarmUpActive() then
        self.combatSkillPoints = self.combatSkillPoints - pointsToSpend
    end

end

if Server then

    function CombatScoreMixin:CopyPlayerDataFrom(player)

        self.combatXP = player.combatXP
        self.combatRank = player.combatRank
        self.combatSkillPoints = player.combatSkillPoints

    end

    function CombatScoreMixin:OnKill()

        self.combatXPGainedCurrentLife = 0
        self.killsGainedCurrentLife = 0
        self.assistsGainedCurrentLife = 0
        self.damageDealtCurrentLife = 0
        self.armorWeldedCurrentLife = 0

    end

end

function CombatScoreMixin:AddCombatKill()

    if GetGameInfoEntity():GetWarmUpActive() then return end

    if not self.combatXP then
        self.combatXP = 0
    end

    if  not self.killsGainedCurrentLife then
        self.killsGainedCurrentLife = 0
    end

    self.killsGainedCurrentLife = self.killsGainedCurrentLife + 1

    if self.killsGainedCurrentLife == kKillsForRampageReward then
        self:GiveSkillPoint(kSkillPointSourceType.KillStreak)
    end

    self:AddXP(kEarnedXPPerKill, kXPSourceType.kill, Entity.invalidId)

end

function CombatScoreMixin:AddCombatAssistKill()

    if GetGameInfoEntity():GetWarmUpActive() then return end

    if not self.combatXP then
        self.combatXP = 0
    end

    if not self.assistsGainedCurrentLife then
        self.assistsGainedCurrentLife = 0
    end

    self.assistsGainedCurrentLife = self.assistsGainedCurrentLife + 1

    if self.assistsGainedCurrentLife == kAssistsForAssistReward then
        self:GiveSkillPoint(kSkillPointSourceType.AssistStreak)
    end

    self:AddXP(kEarnedXPPerAssist, kXPSourceType.assist, Entity.invalidId)

end

function CombatScoreMixin:AddCombatWeldPoints(weldAmount)

    if not self.armorWeldedCurrentLife then
        self.armorWeldedCurrentLife = 0
    end

    self.armorWeldedCurrentLife = self.armorWeldedCurrentLife + weldAmount

end

function CombatScoreMixin:ResetCombatScores()

    self.combatXP = 0
    self.combatRank = 1
    self.combatSkillPoints = kStartPoints
    self.combatXPGainedCurrentLife = 0
    self.killsGainedCurrentLife = 0
    self.assistsGainedCurrentLife = 0
    self.damageDealtCurrentLife = 0
    self.armorWeldedCurrentLife = 0

end
