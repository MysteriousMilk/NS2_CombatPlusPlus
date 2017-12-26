--[[
 * Natural Selection 2 - Combat++ Mod
 * Created by: WhiteWizard
 *
 * Holds a pending XP Update, prior to showing it on screen (ie. +500xp)
]]

local pendingXP = 0
local pendingSource = kXPSourceType.kill
local pendingTargetId = Entity.invalidId

function CombatScoreDisplayUI_GetNewXPAward()

    local tempXP = pendingXP
    local tempSource = pendingSource
    local tempTargetId = pendingTargetId

    pendingXP = 0
    pendingSource = kXPSourceType.kill
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

function CombatScoreDisplayUI_SkillPointEarned(source, kills, assists)

    player = Client.GetLocalPlayer()

    if player and HasMixin(player, "TeamMessage") then

        local msg

        if source == kSkillPointSourceType.LevelUp then
            msg = string.format("Leveled Up : %s Skill Point Earned", kSkillPointTable[source])
        end

        player:SetTeamMessage(string.UTF8Upper(msg))

    end

end
