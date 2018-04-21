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

function UpgradeManager:SetPlayer(player)

    self.Upgrades:SetPlayer(player)

end

--[[
    Should be overriden by team specific sub class.
]]
function UpgradeManager:CreateUpgradeTree()

end

function UpgradeManager:GetTree()

    return self.Upgrades

end

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

function UpgradeManager:GiveUpgrade(techId, player, overrideCost)

    local teamForTechId = LookupUpgradeData(techId, kUpDataTeamIndex)
    assert(teamForTechId == self.Upgrades:GetTeamNumber())

    local node = self.Upgrades:GetNode(techId)
    local success = true

    if overrideCost then
        success = node:GetIsUnlocked() and node:MeetsPreconditions(self.Upgrades)
    else
        success = self:PreGiveUpgrade(node, player)
    end

    if success then

        if node.upgradeFunc then
            success = node.upgradeFunc(techId, player)
        end

        success = success and self:TeamSpecificLogic(node, player, overrideCost)

        if success then
            self:PostGiveUpgrade(node, player, overrideCost)
        end

    end

    return success

end

--[[
    Called during the 'GiveUpgrade' process after the precheck,
    and node specific upgrade function is ran.  This should be
    extended in subclasses to provide team specific logic.

    Returning FALSE will still abort the upgrade and prevent
    the player from spending the skill points.
]]
function UpgradeManager:TeamSpecificLogic(node, player, overrideCost)

    return true

end

--[[
    Called after all checks are complete and the purchase is successful.
]]
function UpgradeManager:PostGiveUpgrade(node, player, overrideCost)

    node:SetIsUnlocked(true)
    self.Upgrades:SetIsPurchased(node:GetTechId(), true)

    if not overrideCost then
        local cost = LookupUpgradeData(node:GetTechId(), kUpDataCostIndex)
        player:SpendSkillPoints(cost)
    end

end
