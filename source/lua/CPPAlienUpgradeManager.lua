local ns2_AlienUpgradeManager_Populate = AlienUpgradeManager.Populate
function AlienUpgradeManager:Populate(player)

    ns2_AlienUpgradeManager_Populate(self, player)

    self.combatRank = player:GetCombatRank()
    self.availableSkillPoints = player:GetCombatSkillPoints()

end

local function GetHasCategory(currentUpgrades, categoryId)

    if not categoryId then
        return false
    end

    for _, currentUpgradeId in ipairs(currentUpgrades) do

        local currentCategory = LookupTechData(currentUpgradeId, kTechDataCategory)
        if currentCategory and currentCategory == categoryId then
            return true
        end

    end

    return false

end

local function RemoveCategoryUpgrades(self, categoryId)

    local oldUpgrades = {}
    table.copy(self.upgrades, oldUpgrades)
    for _, oldUpgradeId in ipairs(oldUpgrades) do

        local oldCategoryId = LookupTechData(oldUpgradeId, kTechDataCategory)
        if oldCategoryId == categoryId then
            self:RemoveUpgrade(oldUpgradeId)
        end

    end

end

local function GetCostRecuperationFor(self, upgradeId)

    local costRecuperation = 0
    local categoryId = LookupTechData(upgradeId, kTechDataCategory)

    if LookupTechData(upgradeId, kTechDataGestateName) and not table.icontains(self.initialUpgrades, self.lifeFormTechId) then
        costRecuperation = CombatPlusPlus_GetCostByTechId(self.lifeFormTechId)
    elseif categoryId then

        for _, currentUpgradeId in ipairs(self.upgrades) do

            if LookupTechData(currentUpgradeId, kTechDataCategory) == categoryId and not table.icontains(self.initialUpgrades, currentUpgradeId) then
                costRecuperation = costRecuperation + CombatPlusPlus_GetCostByTechId(currentUpgradeId)
            end

        end

    end

    return costRecuperation

end

local function GetCostForUpgrade(self, upgradeId)

    local cost

    if table.icontains(self.initialUpgrades, upgradeId) and self.initialLifeFormTechId == self.lifeFormTechId then
        cost = 0
    elseif self.lifeFormTechId == kTechId.Skulk and upgradeId ~= kTechId.Skulk then
        cost = 0
    else
        cost = CombatPlusPlus_GetCostByTechId(upgradeId)
    end

    return cost

end

function AlienUpgradeManager:GetCanAffordUpgrade(upgradeId)

    local availableSkillPoints = self.availableSkillPoints + GetCostRecuperationFor(self, upgradeId)
    return GetCostForUpgrade(self, upgradeId) <= availableSkillPoints

end

function AlienUpgradeManager:GetIsUpgradeAllowed(upgradeId, override)

     if not self.upgrades then
         self.upgrades = {}
     end

     return CombatPlusPlus_GetRequiredRankByTechId(upgradeId) <= self.combatRank

end

local function RemoveAbilities(self)

    local oldUpgrades = { }
    table.copy(self.upgrades, oldUpgrades)

    for _, upgradeId in ipairs(oldUpgrades) do

        if LookupTechData(upgradeId, kTechDataAbilityType) then
            self:RemoveUpgrade(upgradeId)
        end

    end

end

local function RestoreAbilities(self)

    for _, initialUpgradeId in ipairs(self.initialUpgrades) do

        if LookupTechData(initialUpgradeId, kTechDataAbilityType) then
            table.insertunique(self.upgrades, initialUpgradeId)
        end

    end

end

local function RestoreUpgrades(self)

    for _, initialUpgradeId in ipairs(self.initialUpgrades) do

        if not LookupTechData(initialUpgradeId, kTechDataAbilityType) and not LookupTechData(initialUpgradeId, kTechDataGestateName) then
            table.insertunique(self.upgrades, initialUpgradeId)
        end

    end

end

local function RemoveUpgrades(self)

    local oldUpgrades = self.upgrades
    self.upgrades = { }

    for _, upgradeId in ipairs(oldUpgrades) do

        if LookupTechData(upgradeId, kTechDataAbilityType) or LookupTechData(upgradeId, kTechDataGestateName) then
            table.insertunique(self.upgrades, upgradeId)
        end

    end

end

function AlienUpgradeManager:AddUpgrade(upgradeId, override)

     if not upgradeId or upgradeId == kTechId.None then
         return false
     end

     local categoryId = LookupTechData(upgradeId, kTechDataCategory)
     if override or not GetHasCategory(self.initialUpgrades, categoryId) or self.initialLifeFormTechId ~= self.lifeFormTechId then

         -- simple remove overlapping upgrades first
         if categoryId then
             RemoveCategoryUpgrades(self, categoryId)
         end

     end

     local allowed = self:GetIsUpgradeAllowed(upgradeId, override)
     local canAfford = self:GetCanAffordUpgrade(upgradeId)

     if allowed and canAfford then

         local cost = GetCostForUpgrade(self, upgradeId)

         if LookupTechData(upgradeId, kTechDataGestateName) then

             self:RemoveUpgrade(self.lifeFormTechId)
             RemoveAbilities(self)
             RemoveUpgrades(self)

             if table.icontains(self.initialUpgrades, upgradeId) then
                 RestoreAbilities(self)
                 RestoreUpgrades(self)
             end

             self.lifeFormTechId = upgradeId

         end

         table.insert(self.upgrades, upgradeId)
         --self.availableResources = self.availableResources - cost
         self.availableSkillPoints = self.availableSkillPoints - cost

         Shared.Message(string.format("Adding Upgrade for %s.", cost))

         return true

     end

     --Shared.Message(string.format("Cannot add upgrade for %s.", GetDisplayNameForTechId(upgradeId)))

     return false

end

function AlienUpgradeManager:GetAvailableSkillPoints()
    return self.availableSkillPoints
end
