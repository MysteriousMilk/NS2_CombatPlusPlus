Script.Load("lua/CPPUtilities.lua")
Script.Load("lua/CombatScoreMixin.lua")

local networkVarsEx =
{
    currentCreateStructureTechId = "enum kTechId"
}

AddMixinNetworkVars(CombatScoreMixin, networkVarsEx)

local ns2_Player_OnCreate = Player.OnCreate
function Player:OnCreate()

    InitMixin(self, CombatScoreMixin)

    ns2_Player_OnCreate(self)

    self.currentCreateStructureTechId = kTechId.None

end

function Player:GetCreateStructureTechId()

    return self.currentCreateStructureTechId

end

function Player:SetCreateStructureTechId(techId)

    self.currentCreateStructureTechId = techId

end

function Player:OnStructureCreated()

    if self.UpgradeManager then

        local cost = LookupUpgradeData(self.currentCreateStructureTechId, kUpDataCostIndex)
        self:SpendSkillPoints(cost)

    end

    self.currentCreateStructureTechId = kTechId.None

end

local ns2_Player_OnJoinTeam = Player.OnJoinTeam
function Player:OnJoinTeam()

    ns2_Player_OnJoinTeam(self)

    if Server and self.UpgradeManager then
        self.UpgradeManager:GetTree():SendFullTree(self)
    end

end

Shared.LinkClassToMap("Player", Player.kMapName, networkVarsEx, true)
