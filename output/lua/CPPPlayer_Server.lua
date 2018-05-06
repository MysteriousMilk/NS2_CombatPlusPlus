--[[
 * Natural Selection 2 - Combat++ Mod
 * Authors:
 *          WhiteWizard
 *
 * Server-side player logic.
 *
 * Hooked Functions:
 *  'Player:Reset' - Resets player upgrades and clears owned structures.
 *  'Player:CopyPlayerDataFrom' - Copies important information from the old player object to the new player object.
 *
 * Overriden Functions:
 *  'Player:ProcessBuyAction' - Uses the Upgrade Manager to purchase new upgrades.
]]

local ns2_Player_Reset = Player.Reset
function Player:Reset()

    ns2_Player_Reset(self)

    if self.UpgradeManager then
        self.UpgradeManager:Reset()
        self.UpgradeManager:UpdateUnlocks(true)
    end

    self.ownedStructures = {}

end

local ns2_Player_CopyPlayerDataFrom = Player.CopyPlayerDataFrom
function Player:CopyPlayerDataFrom(player)

    ns2_Player_CopyPlayerDataFrom(self, player)

    self.currentCreateStructureTechId = player.currentCreateStructureTechId
    self.ownedStructures = player.ownedStructures

    if self.UpgradeManager and player.UpgradeManager then
        self.UpgradeManager:GetTree():CopyFrom(player.UpgradeManager:GetTree(), false)
    end

end

-- A table of tech Ids is passed in.
function Player:ProcessBuyAction(techIds)

    ASSERT(type(techIds) == "table")
    ASSERT(table.icount(techIds) > 0)

    local success = false

    if self.UpgradeManager then

        if CombatPlusPlus_GetIsStructureTechId(techIds[1]) then
            -- use override cost flag because the cost will be subtracted when the structure is actually placed
            success = self.UpgradeManager:GiveUpgrades(techIds, self, true)
        else
            success = self.UpgradeManager:GiveUpgrades(techIds, self)
        end

    end

    return success

end

--[[
    Call this function to destroy/kill any structures created by the player.
]]
function Player:KillOwnedStructures()

    for _, entId in ipairs(self.ownedStructures) do

        entity = Shared.GetEntity(entId)

        -- kill the entity
        if HasMixin(entity, "Live") and entity:GetIsAlive() and entity:GetCanDie(true) then
            entity:Kill()
        end

    end

    self.ownedStructures = {}

end
