-- Index used to retrieve a pointer to the custom upgrade function to run.
kUpDataUpgradeFuncIndex = "upgradefunc"

-- Index used to retrieve a pointer to the custom remove upgrade function to run.
kUpDataRemoveFuncIndex = "removefunc"

function AddUserDefinedUpgradeFunctions(techId, upgradeFunc, removeFunc)

    assert(techId)

    kCombatUpgradeData[techId][kUpDataUpgradeFuncIndex] = upgradeFunc
    kCombatUpgradeData[techId][kUpDataRemoveFuncIndex] = removeFunc

end