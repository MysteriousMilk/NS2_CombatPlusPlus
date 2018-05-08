--[[
 * Natural Selection 2 - Combat++ Mod
 * Authors:
 *          WhiteWizard
 *
 * Holds a pending XP Update, prior to showing it on screen (ie. +500xp)
]]

local xpMessageQueue = {}

function CombatXpMsgUI_GetMessages()

    local messages = {}

    for _, msg in ipairs(xpMessageQueue) do
        table.insert(messages, msg)
    end

    table.clear(xpMessageQueue)

    return messages

end

function CombatXpMsgUI_AddMessage(msg)
    
    table.insert(xpMessageQueue, msg)

end