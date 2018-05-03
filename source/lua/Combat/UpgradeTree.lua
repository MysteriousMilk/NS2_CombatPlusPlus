class 'UpgradeTree'

if Server then
    Script.Load("lua/Combat/UpgradeTree_Server.lua")
elseif Client then
    Script.Load("lua/Combat/UpgradeTree_Client.lua")
end

function UpgradeTree:Initialize()

    self.nodeList = {}
    self.techIdList = {}

    self.treeChanged = false
    self.complete = false

    if Server then
        self.nodesChanged = {}
        self.player = nil
    end

end

function UpgradeTree:AddNode(node)

    local nodeEntityId = node:GetTechId()

    assert(self.nodeList[nodeEntityId] == nil)

    self.nodeList[nodeEntityId] = node
    self.techIdList[#self.techIdList + 1] = nodeEntityId
    
end

function UpgradeTree:GetNode(techId)
    return self.nodeList[techId]
end

--[[
    Returns a table of tech ids from the current tree that
    are flagged with the given category.
]]
function UpgradeTree:GetUpgradesByCategory(category)

    local upgrades = {}

    for _, nodeTechId in ipairs(self.techIdList) do

        local cat = LookupUpgradeData(nodeTechId, kUpDataCategoryIndex)

        if cat == category then
            table.insert(upgrades, nodeTechId)
        end

    end

    table.sort(upgrades,
        function(a,b)
            local rankA = LookupUpgradeData(a, kUpDataRankIndex)
            local rankB = LookupUpgradeData(b, kUpDataRankIndex)
            return rankA < rankB
        end)

    return upgrades

end

function UpgradeTree:GetUpgradesByPrereq(prereqTechId)

    local upgrades = {}

    for _, nodeTechId in ipairs(self.techIdList) do

        local node = self:GetNode(nodeTechId)

        if node.prereqTechId == prereqTechId then
            table.insert(upgrades, nodeTechId)
        end

    end

    table.sort(upgrades,
        function(a,b)
            local rankA = LookupUpgradeData(a, kUpDataRankIndex)
            local rankB = LookupUpgradeData(b, kUpDataRankIndex)
            return rankA < rankB
        end)

    return upgrades

end

function UpgradeTree:CopyFrom(originalTree, sendToClient)

    local player = nil
    if Server then
         player = self.player
    end

    self:Initialize()

    if Server then
        self:SetPlayer(player)
    end

    for _, nodeTechId in ipairs(originalTree.techIdList) do
        
        local node = originalTree:GetNode(nodeTechId)

        local clone = UpgradeNode()
        clone:Initialize(node.techId, node.type, node.prereqTechId, node.upgradeFunc)
        clone:SetIsUnlocked(node:GetIsUnlocked())
        clone:SetIsPurchased(node:GetIsPurchased())

        self:AddNode(clone)

    end

    self:SetComplete()

    if Server and self.player and sendToClient then
        self:SendFullTree(self.player)
    end

end


function UpgradeTree:GetIsUnlocked(techId)

    if techId == kTechId.None then
        return true
    else
    
        local node = self:GetNode(techId)
        return node and node:GetIsUnlocked() or false
        
    end

end

function UpgradeTree:SetIsUnlocked(techId, isUnlocked)

    local node = self:GetNode(techId)

    if node then
        
        node:SetIsUnlocked(isUnlocked)

        if Server and self.player then
            self:SendNodeUpdate(self.player, node)
        end

    end

end

function UpgradeTree:GetIsPurchased(techId)

    if techId == kTechId.None then
        return true
    else

        local node = self:GetNode(techId)
        return node and node:GetIsPurchased() or false

    end

end

function UpgradeTree:SetIsPurchased(techId, isPurchased)

    local node = self:GetNode(techId)

    if node then

        node:SetIsPurchased(isPurchased)

        if Server and self.player then
            self:SendNodeUpdate(self.player, node)
        end

    end

end

function UpgradeTree:GetHasPrerequisites(techId)

    local hasPrereq = false
    local node = self:GetNode(techId)

    if node then
        hasPrereq = (node.prereqTechId == kTechId.None or self:GetIsPurchased(node.prereqTechId))
    end

    return hasPrereq

end

function UpgradeTree:GetUnlockedUpgrades()

    local unlockedUpgrades = {}

    for _, nodeTechId in ipairs(self.techIdList) do

        local node = self:GetNode(nodeTechId)

        if node:GetIsUnlocked() then
            table.insert(unlockedUpgrades, node)
        end

    end

    return unlockedUpgrades

end

function UpgradeTree:GetPurchasedUpgrades()

    local purchasedUpgrades = {}

    for _, nodeTechId in ipairs(self.techIdList) do

        local node = self:GetNode(nodeTechId)

        if node:GetIsPurchased() then
            table.insert(purchasedUpgrades, node)
        end

    end

    return purchasedUpgrades

end

function UpgradeTree:GetPurchasedPersistentUpgrades()

    local purchasedUpgrades = {}

    for k, node in ipairs(self:GetPurchasedUpgrades()) do

        if LookupUpgradeData(node:GetTechId(), kUpDataPersistIndex) then
            table.insert(purchasedUpgrades, node)
        end

    end

    return purchasedUpgrades

end