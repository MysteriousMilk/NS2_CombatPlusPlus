kCombatUpgradeType = enum( 
{ 
	"Class", 
	"Upgrade" 
}) 

class 'UpgradeNode'

function UpgradeNode:OnCreate()

	self.techId = kTechId.None
	self.type = kCombatUpgradeType.Class
	self.isUnlocked = false
	self.prerequisites = {}
	self.upgradeFunc = nil

end

function UpgradeNode:InitNode(techId, upType, prereqs, upgradeFunc)

	self.techId = techId
	self.type = upType
	self.prerequisites = prereqs
	self.upgradeFunc = upgradeFunc

end

function UpgradeNode:GetTechId()

	return self.techId

end

function UpgradeNode:GetIsUnlocked()

	return self.isUnlocked

end

function UpgradeNode:SetIsUnlocked(unlocked)

	self.isUnlocked = unlocked

end

function UpgradeNode:MeetsPreconditions(upgradeTree)

	local meetsPreConditions = false

	for i = 1, #prerequisites do

		local found = false

		for k, node in ipairs(upgradeTree:GetUnlockedUpgrades()) do

			if prerequisites[i] == node.GetTechId() then
				found = true
				break
			end

		end

		meetsPreConditions = meetsPreConditions and found

	end

	return meetsPreConditions

end

function UpgradeNode:GetIsMutuallyExclusiveTo(techId)

	local isMutuallyExclusive = false

	if mutuallyExclusiveUpgrades[techId] ~= nil then
		isMutuallyExclusive = true
	end

	return isMutuallyExclusive

end