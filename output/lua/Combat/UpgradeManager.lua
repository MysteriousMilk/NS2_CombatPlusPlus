--[[
 * Natural Selection 2 - Combat++ Mod
 * Authors:
 *          WhiteWizard
 *
 * Base Upgrade Manager for Combat++.
]]

class 'UpgradeManager'

function UpgradeManager:Initialize()

end

local function CheckHasPrerequisites(techId, player)

    local hasPrereqs = true

    for _, prereqTechId in ipairs(LookupUpgradeData(techId, kUpDataPrerequisiteIndex)) do

        if not player:GetHasUpgrade(prereqTechId) then
            
            hasPrereqs = false
            break

        end

    end

    return hasPrereqs

end

local function CheckIsUnlocked(techId, player)

    return LookupUpgradeData(techId, kUpDataRankIndex) <= player:GetCombatRank()

end


--[[
    Called before giving an upgraded.  Checks to see if the
    player has enough upgrade points for the purchase and that
    they have the required rank.  Also checks to see if the 
    upgrade node has all prereqs met.

    Can be extended in subclasses to provided additional pre-checks.
]]
function UpgradeManager:PreGiveUpgrades(techIdList, player, overrideCost)

    local totalCost = 0
    local success = true

    -- do prechecks for all upgrades and calculate a cost
    for k, techId in ipairs(techIdList) do

        local teamForTechId = LookupUpgradeData(techId, kUpDataTeamIndex)
        assert(teamForTechId == player:GetTeamNumber(), "TechId " .. kTechId[techId] .. " does not belong to the current team.")

        local cost = LookupUpgradeData(techId, kUpDataCostIndex)

        totalCost = totalCost + cost

        success = success and CheckIsUnlocked(techId, player) and CheckHasPrerequisites(techId, player)

    end

    return success, totalCost

end

--[[
    Gives the player all upgrades provided in the upgrade list.
]]
function UpgradeManager:GiveUpgrades(techIdList, player, overrideCost)

    assert(type(techIdList) == "table")

    --Nothing to buy
    if table.icount(techIdList) == 0 then
        return true
    end

    local success = true
    local totalCost = 0

    success, totalCost = self:PreGiveUpgrades(techIdList, player, overrideCost)

    if success then

        -- cost check
        if (totalCost <= player:GetCombatUpgradePoints()) or overrideCost then

            local refundAmount = 0
            local classTechId = nil
            local currentClassTech = ConditionalValue(player.classTech ~= kTechId.None, player.classTech, player:GetTechId())

            for _, techId in ipairs(techIdList) do

                -- track amount refunded and also run remove code for mutually exclusive upgrades
                local refund = self:RefundMutuallyExclusiveUpgrades(techId, player)

                -- passive upgrades replace their mutually exclusive upgrades but do not refund (Ex: Armor1 -> Armor2)
                if LookupUpgradeData(techId, kUpDataTypeIndex) ~= kCombatUpgradeType.Passive then
                    refundAmount = refundAmount + refund
                end

                -- "give" the player this upgrade by storing the tech id
                player:GiveUpgrade(techId)

                -- store the class tech id if there is one
                if LookupUpgradeData(techId, kUpDataTypeIndex) == kCombatUpgradeType.Class then

                    assert(classTechId == nil, "ERROR: Attempt to upgrade to multiple class types.")

                    -- new class to upgrade to
                    classTechId = techId

                    -- refund any upgrades associated with old class
                    refundAmount = refundAmount + self:RefundUpgradesByClass(currentClassTech, player)

                end

            end

            totalCost = totalCost - refundAmount

            -- deduct the upgrade points
            Clamp(totalCost, 0, kMaxCombatRank + CombatSettings["UpgradePointsAtStart"])

            if not overrideCost then
                player:SpendUpgradePoints(totalCost)
            end

            -- run custom, team-specific logic to "apply" the upgrade
            self:UpgradeLogic(techIdList, classTechId, player)

        else
            success = false
            Server.PlayPrivateSound(player, player:GetNotEnoughResourcesSound(), player, 1.0, Vector(0, 0, 0))
        end

    end

    return success

end

--[[
    Called during the 'GiveUpgrades' process after the precheck.  This may
    be extended in the subclass to provide additonal upgrade logic or 
    team specific logic.
]]
function UpgradeManager:UpgradeLogic(techIdList, classTechId, player)

end

--[[
    Applies all purchased, persistent upgrades to the player and refunds any purchased
    upgrades that are not persistent.
]]
function UpgradeManager:ApplyAllUpgrades(player, ignoreClassTech)

    local techIdList = {}
    local allUpgrades = player:GetUpgrades()
    local classTechId = ConditionalValue(player.classTech == kTechId.None or ignoreClassTech, nil, player.classTech)

    player:DebugPrintUpgrades()

    for _, techId in ipairs(allUpgrades) do
        
        if LookupUpgradeData(techId, kUpDataTypeIndex) ~= kCombatUpgradeType.Class then
            table.insert(techIdList, techId)
        end

    end

    self:UpgradeLogic(techIdList, classTechId, player)
    
end

function UpgradeManager:RefundMutuallyExclusiveUpgrades(techId, player)

    -- Unpurchase any mutually exclusive upgrades for this upgrade and
    -- deduct that value from the overall purchase cost.
    local refundAmount = 0
    for _, mutuallyExclusiveTechId in ipairs(LookupUpgradeData(techId, kUpDataMutuallyExclusiveIndex)) do

        if player:GetHasUpgrade(mutuallyExclusiveTechId) then

            -- Stop tracking this upgrade on the player
            player:RemoveUpgrade(mutuallyExclusiveTechId)

            -- run custom remove code for given upgrade
            local removeFunc = LookupUpgradeData(mutuallyExclusiveTechId, kUpDataRemoveFuncIndex)
            if removeFunc then
                removeFunc(mutuallyExclusiveTechId, player)
            end

            -- calculate refund amount
            refundAmount = LookupUpgradeData(mutuallyExclusiveTechId, kUpDataCostIndex) + refundAmount

        end

    end

    return refundAmount

end

function UpgradeManager:RefundUpgradesByClass(classTechId, player)

    local refundAmount = 0

    for _, upgradeTechId in ipairs(player:GetUpgrades()) do

        for a, prereqTechId in ipairs(LookupUpgradeData(upgradeTechId, kUpDataPrerequisiteIndex)) do

            if prereqTechId == classTechId then

                -- Stop tracking this upgrade on the player
                player:RemoveUpgrade(upgradeTechId)

                -- run custom remove code for given upgrade
                local removeFunc = LookupUpgradeData(upgradeTechId, kUpDataRemoveFuncIndex)
                if removeFunc then
                    removeFunc(upgradeTechId, player)
                end

                -- calculate refund amount
                refundAmount = LookupUpgradeData(upgradeTechId, kUpDataCostIndex) + refundAmount

                break

            end

        end

    end

    return refundAmount

end
