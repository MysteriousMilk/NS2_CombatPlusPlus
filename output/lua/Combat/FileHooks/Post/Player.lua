--[[
 * Natural Selection 2 - Combat++ Mod
 * Authors:
 *          WhiteWizard
 *
 * Adds additional functionality to the player (UpgradeManager, ability to place structures..)
]]

Script.Load("lua/Combat/CombatScoreMixin.lua")
Script.Load("lua/Combat/CombatDataMixin.lua")

local networkVarsEx =
{
    currentCreateStructureTechId = "enum kTechId"
}

AddMixinNetworkVars(CombatScoreMixin, networkVarsEx)

local ns2_Player_OnCreate = Player.OnCreate
function Player:OnCreate()

    InitMixin(self, CombatScoreMixin)
    InitMixin(self, CombatDataMixin)

    ns2_Player_OnCreate(self)

    if Server then

        if not self.UpgradeManager then
            self.UpgradeManager = UpgradeManager()
        end

        self.isSpawning = false
        self.gotSpawnProtect = nil
        self.activeSpawnProtect = false
        self.deactivateSpawnProtect = nil

    end

    self.currentCreateStructureTechId = kTechId.None

end

local ns2_Player_OnInitialized = Player.OnInitialized
function Player:OnInitialized()

    ns2_Player_OnInitialized(self)

    if Server then

        if self.UpgradeManager then
            self.UpgradeManager:Initialize()
            self.UpgradeManager:SetPlayer(self)
        end

        self.ownedStructures = {}

    end

end

function Player:GetCreateStructureTechId()

    return self.currentCreateStructureTechId

end

function Player:SetCreateStructureTechId(techId)

    self.currentCreateStructureTechId = techId

end

function Player:OnStructureCreated(structure)

    if Server then

        if self.UpgradeManager then

            local cost = LookupUpgradeData(self.currentCreateStructureTechId, kUpDataCostIndex)
            self:SpendUpgradePoints(cost)

        end

        -- put builder back into build mode
        builder = self:GetWeapon(Builder.kMapName)
        builder:SetBuilderMode(kBuilderMode.Build)

        -- track the entity id's of the structures that player places
        table.insert(self.ownedStructures, structure:GetId())

    end

    self.currentCreateStructureTechId = kTechId.None

end

local ns2_Player_OnInitialSpawn = Player.OnInitialSpawn
function Player:OnInitialSpawn(techPointOrigin)

    ns2_Player_OnInitialSpawn(self, techPointOrigin)

    if GetIsPlayingTeam(self:GetTeamNumber()) then
        self:MakeIneligibleForLateJoinXp()
    end

end

Shared.LinkClassToMap("Player", Player.kMapName, networkVarsEx, true)
