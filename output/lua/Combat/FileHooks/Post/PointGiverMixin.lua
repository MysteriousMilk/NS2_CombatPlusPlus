--[[
 * Natural Selection 2 - Combat++ Mod
 * Authors:
 *          WhiteWizard
 *
 * Adds additional functionality to the PointGiverMixin to handle Combat XP.
 *
 * Wrapped Functions:
 *  'PointGiverMixin:OnConstructionComplete' - Give xp for building a structure.
 *  'PointGiverMixin:OnTakeDamage' - Keep track of the damage being done.  Everytime the player hits the
 *  damage threshold, award some xp.
]]

if Server then

    local ns2_PointGiverMixin_OnConstructionComplete = PointGiverMixin.OnConstructionComplete
    function PointGiverMixin:OnConstructionComplete()

        if self.constructer then

            for _, builderId in ipairs(self.constructer) do

                local builder = Shared.GetEntity(builderId)
                if builder and builder:isa("Player") and HasMixin(builder, "CombatScore") then

                    local constructionFraction = self.constructPoints[builderId]
                    local xp = math.max(math.floor(kCombatBuildRewardBase * Clamp(constructionFraction, 0, 1)))

                    if builder:isa("Gorge") then
                        xp = xp * kGorgeBuildRewardModifier
                    end

                    builder:AddXP(xp, kXPSourceType.Build, self:GetId())

                end

            end

        end

        ns2_PointGiverMixin_OnConstructionComplete(self)

    end

    local ns2_PointGiverMixin_OnTakeDamage = PointGiverMixin.OnTakeDamage
    function PointGiverMixin:OnTakeDamage(damage, attacker, doer, point, direction, damageType, preventAlert)

        ns2_PointGiverMixin_OnTakeDamage(self, damage, attacker, doer, point, direction, damageType, preventAlert)

        if attacker and attacker:isa("Player") and GetAreEnemies(self, attacker) and HasMixin(attacker, "CombatScore") then
            attacker:AddCombatDamage(damage)
        end

    end

    function PointGiverMixin:PreOnKill(attacker, doer, point, direction)

        if self.isHallucination then
            return
        end

        local totalDamageDone = self:GetMaxHealth() + self:GetMaxArmor() * 2
        local points = self:GetPointValue()
        local resReward = self:isa("Player") and kPersonalResPerKill or 0

        -- award partial res and score to players who assisted
        for _, attackerId in ipairs(self.damagePoints.attackers) do

            local currentAttacker = Shared.GetEntity(attackerId)
            if currentAttacker and HasMixin(currentAttacker, "Scoring") then

                local damageDone = self.damagePoints[attackerId]
                local damageFraction = Clamp(damageDone / totalDamageDone, 0, 1)
                local scoreReward = points >= 1 and math.max(1, math.round(points * damageFraction)) or 0

                currentAttacker:AddScore(scoreReward, resReward * damageFraction, attacker == currentAttacker)

                if self:isa("Player") and currentAttacker ~= attacker then

                    currentAttacker:AddAssistKill()

                    if HasMixin(self, "CombatScore") and HasMixin(currentAttacker, "CombatScore") then
                        currentAttacker:AddCombatAssistKill(self:GetCombatRank())
                    end

                end

            end

        end

        if self:isa("Player") and attacker and GetAreEnemies(self, attacker) then

            if attacker:isa("Player") then

                attacker:AddKill()

                if HasMixin(self, "CombatScore") and HasMixin(attacker, "CombatScore") then
                    attacker:AddCombatKill(self:GetCombatRank())
                end

            end

            local playersNearby = GetEntitiesForTeamWithinRange("Player", attacker:GetTeamNumber(), self:GetOrigin(), kNearbyKillXPDistance)

            for _, player in ipairs(playersNearby) do

                local assistedInKill = false

                for _, attackerId in ipairs(self.damagePoints.attackers) do
                    
                    if attackerId == player:GetId() then
                        assistedInKill = true
                    end

                end

                if player:GetIsAlive() and player ~= attacker and not assistedInKill then
                    player:AddCombatNearbyKill(self:GetCombatRank())
                end

            end

            self:GetTeam():AddTeamResources(kKillTeamReward)

        end

    end

end
