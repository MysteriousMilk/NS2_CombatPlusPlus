class 'UpgradeTree'

function UpgradeTree:Initialize()

    self.nodeList = {}
    self.techIdList = {}

    self.teamNumber = kTeamReadyRoom

    if Server then
        self.nodesChanged = {}
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

function UpgradeTree:GetIsUnlocked(techId)

    if techId == kTechId.None then
        return true
    else
    
        local node = self:GetNode(techId)
        return node and node:GetIsUnlocked() or false
        
    end

end

