local ns2_Player_CopyPlayerDataFrom = Player.CopyPlayerDataFrom
function Player:CopyPlayerDataFrom(player)

    ns2_Player_CopyPlayerDataFrom(self, player)

    self.currentCreateStructureTechId = player.currentCreateStructureTechId

end

-- A table of tech Ids is passed in.
function Player:ProcessBuyAction(techIds)

    ASSERT(type(techIds) == "table")
    ASSERT(table.icount(techIds) > 0)

    local techId = techIds[1]
    local success = false

    if self.UpgradeManager then

        if CombatPlusPlus_GetIsStructureTechId(techId) then
            -- use override cost flag because the cost will be subtracted when the structure is actually placed
            success = self.UpgradeManager:GiveUpgrade(techId, self, true)
        else
            success = self.UpgradeManager:GiveUpgrade(techId, self)
        end

    end

    return success

end

local ns2_Player_Replace = Player.Replace
function Player:Replace(mapName, newTeamNumber, preserveWeapons, atOrigin, extraValues)

    local persistUpgrades = nil
    local upgradeTree = nil
    local oldPlayerActive = self:GetTeamNumber() == kTeam1Index or self:GetTeamNumber() == kTeam2Index

    if self.UpgradeManager then

        -- cache off the upgrade tree and persistent upgrades from the "old" player
        upgradeTree = self.UpgradeManager:GetTree()
        persistUpgrades = upgradeTree:GetPurchasedPersistentUpgrades()

        --Shared.Message(string.format("Number of persist upgrades: %s", #persistUpgrades))

    end

    -- do the normal replace
    local player = ns2_Player_Replace(self, mapName, newTeamNumber, preserveWeapons, atOrigin, extraValues)

    -- active player is one currently playing on Marines or Aliens
    local newPlayerActive = player:GetTeamNumber() == kTeam1Index or player:GetTeamNumber() == kTeam2Index

    if player.UpgradeManager then

        if player:isa("Spectator") and upgradeTree and oldPlayerActive then

            -- When the player is spectating between spawns, copy the tree to the "spectator" player so the
            -- persist items can be given when the player respawns
            player.UpgradeManager:GetTree():CopyFrom(upgradeTree, false)

        elseif newPlayerActive and persistUpgrades then

            player.UpgradeManager:UpdateUnlocks(false)
            player.UpgradeManager:GetTree():SendFullTree(player)

            -- Respawning players get the certain "persistent" upgrades back
            for k, node in ipairs(persistUpgrades) do
                player.UpgradeManager:GiveUpgrade(node:GetTechId(), player, true)
            end

        end

    end

    return player

end
