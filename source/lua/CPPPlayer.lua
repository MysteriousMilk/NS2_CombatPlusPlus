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

local ns2_Player_Replace = Player.Replace
function Player:Replace(mapName, newTeamNumber, preserveWeapons, atOrigin, extraValues)

    player = ns2_Player_Replace(self, mapName, newTeamNumber, preserveWeapons, atOrigin, extraValues)

    -- give the player their pistol or welder back if they already purchased it
    if player:isa("Marine") and self:isa("Marine") then

        player.purchasedPistol = self.purchasedPistol
        player.purchasedWelder = self.purchasedWelder

        if player.purchasedPistol then
            player:GiveItem(Pistol.kMapName)
            player:SetQuickSwitchTarget(Pistol.kMapName)
        end

        if player.purchasedWelder then
            player:GiveItem(Welder.kMapName)
            player:SetQuickSwitchTarget(Welder.kMapName)
        end

    end

    return player

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
