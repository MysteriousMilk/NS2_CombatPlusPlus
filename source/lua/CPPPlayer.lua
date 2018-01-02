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

    self:SpendSkillPoints(CombatPlusPlus_GetCostByTechId(self.currentCreateStructureTechId))
    self.currentCreateStructureTechId = kTechId.None

end

Shared.LinkClassToMap("Player", Player.kMapName, networkVarsEx, true)
