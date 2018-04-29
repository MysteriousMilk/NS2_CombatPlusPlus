--[[
 * Natural Selection 2 - Combat++ Mod
 * Authors:
 *          WhiteWizard
 *
 * Base Upgrade Manager for Combat++.
]]

Script.Load("lua/Combat/UpgradeTree.lua")

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
    player has enough skill points for the purchase and that
    they have the required rank.  Also checks to see if the 
    upgrade node has all prereqs met.

    Can be extended in subclasses to provided additional pre-checks.
]]
function UpgradeManager:PreGiveUpgrade(node, player)

    local techId = node:GetTechId()
    local cost = LookupUpgradeData(techId, kUpDataCostIndex)

    local canAfford = (cost <= player:GetCombatSkillPoints())

    if not canAfford then
        Server.PlayPrivateSound(player, player:GetNotEnoughResourcesSound(), player, 1.0, Vector(0, 0, 0))
    end

    return canAfford and node:GetIsUnlocked() and node:MeetsPreconditions(self.Upgrades)

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

    -- do prechecks for all upgrades and calculate a cost
    for k, techId in ipairs(techIdList) do

        local teamForTechId = LookupUpgradeData(techId, kUpDataTeamIndex)
        assert(teamForTechId == player:GetTeamNumber())

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

    if success then

        -- cost check
        if (totalCost <= player:GetCombatSkillPoints()) or overrideCost then

            for k, techId in ipairs(techIdList) do

                local node = self.Upgrades:GetNode(techId)

                -- apply the upgreade
                success = success and self:UpgradeLogic(techIdList, node, player, overrideCost)

            end

            if success then
                -- update the tree and spend the points
                self:PostGiveUpgrades(techIdList, player, totalCost, overrideCost)
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
    the player from spending the skill points.
]]
function UpgradeManager:UpgradeLogic(techIdList, currNode, player, overrideCost)

    local success = true

    -- run the upgrade func for the node
    if currNode.upgradeFunc then
        success = currNode.upgradeFunc(currNode:GetTechId(), player)
    end

    return success

end

--[[
    Called after all checks are complete and the purchase is successful.
]]
function UpgradeManager:PostGiveUpgrades(techIds, player, cost, overrideCost)

    for k, techId in ipairs(techIds) do

        local node = self.Upgrades:GetNode(techId)

        node:SetIsUnlocked(true)
        self.Upgrades:SetIsPurchased(node:GetTechId(), true)

        -- unpurchase an mutually exclusive upgrades for this upgrade
        for _, mutuallyExculsiveTechId in ipairs(LookupUpgradeData(techId, kUpDataMutuallyExclusiveIndex)) do
            self.Upgrades:SetIsPurchased(mutuallyExculsiveTechId, false)
        end

        if not overrideCost then
            local cost = LookupUpgradeData(node:GetTechId(), kUpDataCostIndex)
            player:SpendSkillPoints(cost)
        end

    end

end

--[[
    Called every time the player spawns.
]]
function UpgradeManager:SpawnUpgrades(player)

    -- set everything back to 'not purchased' at spawn except persist items
    for k, node in ipairs(self.Upgrades:GetPurchasedUpgrades()) do

        if not LookupUpgradeData(node:GetTechId(), kUpDataPersistIndex) then
            self.Upgrades:SetIsPurchased(node:GetTechId(), false)
        end

    end

    local upgradeIds = {}
    for k, node in ipairs(self.Upgrades:GetPurchasedPersistentUpgrades()) do
        table.insert(upgradeIds, node:GetTechId())
    end

    self:GiveUpgrades(upgradeIds, player, true)

end
