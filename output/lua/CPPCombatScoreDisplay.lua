--[[
 * Natural Selection 2 - Combat++ Mod
 * Authors:
 *          WhiteWizard
 *
 * Holds a pending XP Update, prior to showing it on screen (ie. +500xp)
]]

local pendingXP = 0
local pendingSource = kXPSourceType.Kill
local pendingTargetId = Entity.invalidId

function CombatScoreDisplayUI_GetNewXPAward()

    local tempXP = pendingXP
    local tempSource = pendingSource
    local tempTargetId = pendingTargetId

    pendingXP = 0
    pendingSource = kXPSourceType.Kill
    pendingTargetId = Entity.invalidId

    return tempXP, tempSource, tempTargetId

end

function CombatScoreDisplayUI_SetNewXPAward(xp, source, targetId)

    if Client.GetOptionInteger("hudmode", kHUDMode.Full) == kHUDMode.Full then

        pendingXP = xp
        pendingSource = source
        pendingTargetId = targetId

    end

end

function CombatScoreDisplayUI_UpgradePointEarned(source, kills, assists)

    player = Client.GetLocalPlayer()

    if player and HasMixin(player, "TeamMessage") then

        local msg

        if source == kUpgradePointSourceType.LevelUp then
            msg = string.format("Leveled Up! : %s Upgrade Point Earned", kUpgradePointTable[source])
        elseif source == kUpgradePointSourceType.KillStreak then
            msg = string.format("Rampage! : %s Upgrade Point Earned", kUpgradePointTable[source])
        elseif source == kUpgradePointSourceType.AssistStreak then
            msg = string.format("Got Your Back! : %s Upgrade Point Earned", kUpgradePointTable[source])
        elseif source == kUpgradePointSourceType.DamageDealer then
            msg = string.format("Damage Dealer! : %s Upgrade Point Earned", kUpgradePointTable[source])
        elseif source == kUpgradePointSourceType.Refund then
            msg = string.format("Refunded Some Upgrade Points")
        end

        player:SetTeamMessage(string.UTF8Upper(msg))

    end

end
