function UpgradeTree:SendFullTree(player)

    local sent = false

    if self.complete then

        Server.SendNetworkMessage(player, "ClearUpgradeTree", {}, true)

        for _, nodeTechId in ipairs(self.techIdList) do

            local node = self:GetNode(nodeTechId)
            Server.SendNetworkMessage(player, "UpgradeNodeBase", BuildUpgradeNodeBaseMessage(node), true)
            sent = true
        
        end

    end

    return sent

end

function UpgradeTree:SendTreeUpdate(player)

    for nodeIndex, node in ipairs(self.nodesChanged) do
        Server.SendNetworkMessage(player, "UpgradeNodeUpdate", BuildUpgradeNodeUpdateMessage(node), true)
    end

    table.clear(self.nodesChanged)

end

function UpgradeTree:SendNodeUpdate(player, node)

    Server.SendNetworkMessage(player, "UpgradeNodeUpdate", BuildUpgradeNodeUpdateMessage(node), true)

end

function UpgradeTree:AddClassNode(techId, prereqId, upgradeFunc)

    local node = UpgradeNode()
    node:Initialize(techId, kCombatUpgradeType.Class, prereqId, upgradeFunc)
    self:AddNode(node)

end

function UpgradeTree:AddUpgradeNode(techId, prereqId, upgradeFunc)

    local node = UpgradeNode()
    node:Initialize(techId, kCombatUpgradeType.Upgrade, prereqId, upgradeFunc)
    self:AddNode(node)

end

function UpgradeTree:UpdateUnlocks(sendNetUpdate)

    if self.player then

        local currentRank = self.player:GetCombatRank()

        for _, nodeTechId in ipairs(self.techIdList) do

            local node = self:GetNode(nodeTechId)
            local rankForTechId = LookupUpgradeData(nodeTechId, kUpDataRankIndex)

            if rankForTechId <= currentRank and not node:GetIsUnlocked() then
                
                if sendNetUpdate then
                    self:SetIsUnlocked(nodeTechId, true)
                else
                    node:SetIsUnlocked(true)
                end

            end

        end

    end

end
        

function UpgradeTree:SetPlayer(player)

    self.player = player

end

function UpgradeTree:SetComplete()

    if not self.complete then

        table.sort(self.techIdList)
        self.complete = true

    end

end