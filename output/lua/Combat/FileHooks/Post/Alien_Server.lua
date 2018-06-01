-- Morph into new class or buy upgrade.
function Alien:ProcessBuyAction(techIds)

    ASSERT(type(techIds) == "table")
    ASSERT(table.icount(techIds) > 0)

    local success = false

    if self.UpgradeManager then
        success = self.UpgradeManager:GiveUpgrades(techIds, self)
    end

    if not success then
        self:TriggerInvalidSound()
    end

    return success

end

local ns2_Alien_GetCanTakeDamageOverride = Alien.GetCanTakeDamageOverride
function Alien:GetCanTakeDamageOverride()

    return not self.gotSpawnProtect and  ns2_Alien_GetCanTakeDamageOverride(self)

end
