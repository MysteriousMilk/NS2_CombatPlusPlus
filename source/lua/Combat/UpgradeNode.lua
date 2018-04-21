Script.Load("lua/CPPGlobals.lua")

class 'UpgradeNode'

function UpgradeNode:Initialize(techId, upType, prereq, upgradeFunc)

	self.techId = techId
	self.type = upType
	self.prereqTechId = prereq
	self.upgradeFunc = upgradeFunc
	self.isUnlocked = false
	self.isPurchased = false

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

function UpgradeNode:GetIsPurchased()

	return self.isPurchased

end

function UpgradeNode:SetIsPurchased(purchased)

	self.isPurchased = purchased

end

function UpgradeNode:MeetsPreconditions(upgradeTree)

	local meetsPreConditions = false

	if self.prereqTechId == nil or self.prereqTechId == kTechId.None or upgradeTree:GetIsPurchased(self.prereqTechId) then
		meetsPreConditions = true
	end

	return meetsPreConditions

end

function UpgradeNode:GetIsMutuallyExclusiveTo(techId)

	local isMutuallyExclusive = false

	return isMutuallyExclusive

end