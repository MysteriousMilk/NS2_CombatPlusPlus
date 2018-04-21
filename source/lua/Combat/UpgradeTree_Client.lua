function UpgradeTree:CreateUpgradeNodeFromNetwork(nodeBaseTable)

    local node = UpgradeNode()
    ParseUpgradeNodeBaseMessage(node, nodeBaseTable)

    self:AddNode(node)

    Shared.Message(string.format("Received Node: %s", GetDisplayNameForTechId(node:GetTechId())))

end

function UpgradeTree:UpdateUpgradeNodeFromNetwork(nodeUpgradeTable)

    local unlockedText = ConditionalValue(nodeUpgradeTable.isUnlocked, "Yes", "No")
    local purchasedText = ConditionalValue(nodeUpgradeTable.isPurchased, "Yes", "No")

    Shared.Message(string.format("Updating Node: [%s, Unlocked: %s, Purchased: %s]", GetDisplayNameForTechId(nodeUpgradeTable.techId), unlockedText, purchasedText))
    
    local techId = nodeUpgradeTable.techId
    local node = self:GetNode(techId)

    if node ~= nil then
        ParseUpgradeNodeUpdateMessage(node, nodeUpgradeTable)
    end

end