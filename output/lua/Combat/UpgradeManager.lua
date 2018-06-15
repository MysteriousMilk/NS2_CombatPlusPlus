--[[
 * Natural Selection 2 - Combat++ Mod
 * Authors:
 *          WhiteWizard
 *
 * Base Upgrade Manager for Combat++.
]]

class 'UpgradeManager'

function UpgradeManager:Initialize()

    if self.Upgrades == nil then
        self.Upgrades = UpgradeTree()
    end
    
    self.Upgrades:Initialize()
    self:CreateUpgradeTree()
    self.Upgrades:SetComplete()

end

--[[
    Does a reset on the UpgradeManager and UpgradeTree while
    preserving the player pointer.
]]
function UpgradeManager:Reset()

    local player = self.Upgrades.player
    self:Initialize()
    self:SetPlayer(player)

end

function UpgradeManager:SetPlayer(player)

    self.Upgrades:SetPlayer(player)

end

--[[
    Should be overriden by team specific sub class.
]]
function UpgradeManager:CreateUpgradeTree()

end

--[[
    Returns the upgrade tree.
]]
function UpgradeManager:GetTree()

    return self.Upgrades

end

--[[
    Checks the players current rank and unlocks all items in the ugprade tree
    at the current player rank or lower.
]]
function UpgradeManager:UpdateUnlocks(sendNetUpdate)

    self.Upgrades:UpdateUnlocks(sendNetUpdate)

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

        local node = self.Upgrades:GetNode(techId)
        local cost = LookupUpgradeData(techId, kUpDataCostIndex)

        totalCost = totalCost + cost

        if node then
            -- node must be unlocked and meet all prereqs
            success = success and node:GetIsUnlocked() and node:MeetsPreconditions(self.Upgrades)
        else
            success = false
            break
        end

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

            local newPlayerClass = nil
            success, newPlayerClass = self:UpgradeLogic(techIdList, node, player, overrideCost)

            if success then
                -- update the tree and spend the points
                if newPlayerClass then
                    newPlayerClass.UpgradeManager:PostGiveUpgrades(techIdList, newPlayerClass, totalCost, overrideCost)
                    newPlayerClass.UpgradeManager:ApplyAllUpgrades(newPlayerClass)
                else
                    self:PostGiveUpgrades(techIdList, player, totalCost, overrideCost)
                end
            end

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

    Returning FALSE will still abort the upgrade and prevent
    the player from spending the upgrade points.
]]
function UpgradeManager:UpgradeLogic(techIdList, currNode, player, overrideCost)

    local success = true
    local newPlayerClass = nil

    for k, techId in ipairs(techIdList) do

        local node = self.Upgrades:GetNode(techId)
        local logicSuccess = true

        -- run the upgrade func for the node
        if node.upgradeFunc then
            logicSuccess, newPlayerClass = node.upgradeFunc(techId, player)
        end

        success = success and logicSuccess

        if newPlayerClass then
            break
        end

    end

    return success, newPlayerClass

end

--[[
    Called after all checks are complete and the purchase is successful.
]]
function UpgradeManager:PostGiveUpgrades(techIds, player, cost, overrideCost)

    for k, techId in ipairs(techIds) do

        local node = self.Upgrades:GetNode(techId)

        node:SetIsUnlocked(true)
        self.Upgrades:SetIsPurchased(techId, true)

        local refundAmount = 0

        -- unpurchase any mutually exclusive upgrades for this upgrade
        for _, mutuallyExculsiveTechId in ipairs(LookupUpgradeData(techId, kUpDataMutuallyExclusiveIndex)) do

            if self.Upgrades:GetIsPurchased(mutuallyExculsiveTechId) then

                -- unpurchase mutually exclusive upgrade
                self.Upgrades:SetIsPurchased(mutuallyExculsiveTechId, false)

                -- calculate refund amount
                refundAmount = LookupUpgradeData(mutuallyExculsiveTechId, kUpDataCostIndex) + refundAmount
                refundAmount = Clamp(refundAmount, 0, kMaxCombatRank + CombatSettings["UpgradePointsAtStart"])

            end

        end

        if refundAmount > 0 then
            player:GiveCombatUpgradePoints(kUpgradePointSourceType.Refund, refundAmount, true)
        end

        if not overrideCost then
            local cost = LookupUpgradeData(node:GetTechId(), kUpDataCostIndex)
            player:SpendUpgradePoints(cost)
        end

    end

end

--[[
    Applies all purchased, persistent upgrades to the player and refunds any purchased
    upgrades that are not persistent.
]]
function UpgradeManager:ApplyAllUpgrades(player)

    -- set everything back to 'not purchased' at spawn except persist items
    for k, node in ipairs(self.Upgrades:GetPurchasedUpgrades()) do

        if player:GetTechId() ~= kTechId.Exo and
           node:GetTechId() ~= player:GetTechId() and not
           LookupUpgradeData(node:GetTechId(), kUpDataPersistIndex) then

            -- unpurchase
            self.Upgrades:SetIsPurchased(node:GetTechId(), false)

            -- refund
            player:Refund(node:GetTechId(), false)

        end

    end

    local classTechId = kTechId.None
    local upgradeIds = {}

    for k, node in ipairs(self.Upgrades:GetPurchasedPersistentUpgrades()) do

        local techId = node:GetTechId()
        
        if techId ~= player:GetTechId() then

            if node:GetType() == kCombatUpgradeType.Class then
                assert(classTechId == kTechId.None)
                classTechId = techId
            else
                table.insert(upgradeIds, techId)
            end

        end

    end

    if classTechId ~= kTechId.None then
        table.insert(upgradeIds, 1, classTechId)
    end

    self:GiveUpgrades(upgradeIds, player, true)

end
