ScoringMixin.networkVars =
{
    playerSkill = "integer",
    playTime = "private time",
    playerLevel = "integer",
    totalXP = "integer",
    teamAtEntrance = string.format("integer (-1 to %d)", kSpectatorIndex),
    combatXP = "integer",
    combatRank = "integer",
    combatSkillPoints = "integer"
}

local ns2_ScoringMixin_Init = ScoringMixin.__initmixin
function ScoringMixin:__initmixin()

    ns2_ScoringMixin_Init(self)

    self.combatXP = 0
    self.combatRank = 1
    self.combatSkillPoints = 0
    self.combatXPGainedCurrentLife = 0
    self.killsGainedCurrentLife = 0
    self.assistsGainedCurrentLife = 0

end

function ScoringMixin:GetCombatXP()
    return self.combatXP
end

function ScoringMixin:AddXP(xp, source, targetId)

    if Server then

        if xp and xp ~= 0 and not GetGameInfoEntity():GetWarmUpActive() then

            self.combatXP = Clamp(self.combatXP + xp, 0, kMaxCombatXP)
            local currentRank = GetRankByXP(self.combatXP)

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

end

function ScoringMixin:GetCombatRank()
    return self.combatRank
end

function ScoringMixin:GetCombatSkillPoints()
    return self.combatSkillPoints
end

function ScoringMixin:GiveSkillPoint(source)

    if Server then

        if not GetGameInfoEntity():GetWarmUpActive() then

            self.combatSkillPoints = self.combatSkillPoints + 1

            -- notify the client about the new skill points
            Server.SendNetworkMessage(Server.GetOwner(self), "CombatSkillPointUpdate", { source = source, kills = self.killsGainedCurrentLife, assists = self.assistsGainedCurrentLife }, true)

        end

    end

end

function ScoringMixin:SpendSkillPoints(pointsToSpend)

  if Server and not GetGameInfoEntity():GetWarmUpActive() then

    self.combatSkillPoints = self.combatSkillPoints - pointsToSpend

  end

end

if Server then

    local ns2_ScoringMixin_CopyPlayerDataFrom = ScoringMixin.CopyPlayerDataFrom
    function ScoringMixin:CopyPlayerDataFrom(player)

        ns2_ScoringMixin_CopyPlayerDataFrom(self, player)

        self.combatXP = player.combatXP
        self.combatRank = player.combatRank
        self.combatSkillPoints = player.combatSkillPoints

    end

    local ns2_ScoringMixin_OnKill = ScoringMixin.OnKill
    function ScoringMixin:OnKill()

        ns2_ScoringMixin_OnKill(self)
        self.combatXPGainedCurrentLife = 0
        self.killsGainedCurrentLife = 0
        self.assistsGainedCurrentLife = 0

    end

end

local ns2_ScoringMixin_AddKill = ScoringMixin.AddKill
function ScoringMixin:AddKill()

    ns2_ScoringMixin_AddKill(self)

    if GetGameInfoEntity():GetWarmUpActive() then return end

    if not self.combatXP then
        self.combatXP = 0
    end

    if  not self.killsGainedCurrentLife then
        self.killsGainedCurrentLife = 0
    end

    self.killsGainedCurrentLife = self.killsGainedCurrentLife + 1

    self:AddXP(kEarnedXPPerKill, kXPSourceType.kill, Entity.invalidId)

end

local ns2_ScoringMixin_AddAssistKill = ScoringMixin.AddAssistKill
function ScoringMixin:AddAssistKill()

    ns2_ScoringMixin_AddAssistKill(self)

    if GetGameInfoEntity():GetWarmUpActive() then return end

    if not self.combatXP then
        self.combatXP = 0
    end

    self:AddXP(kEarnedXPPerAssist, kXPSourceType.assist, Entity.invalidId)

end

local ns2_ScoringMixin_ResetScores = ScoringMixin.ResetScores
function ScoringMixin:ResetScores()

    ns2_ScoringMixin_ResetScores(self)

    self.combatXP = 0
    self.combatRank = 1
    self.combatSkillPoints = 0

end
