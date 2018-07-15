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

        local cost = LookupUpgradeData(self.currentCreateStructureTechId, kUpDataCostIndex)
        self:SpendUpgradePoints(cost)

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

        -- Player joined before game start or early enough that they do
        -- not qualify for late join xp
        self:MakeIneligibleForLateJoinXp()
        
    end

end

function Player:Buy()

    -- Don't allow display in the ready room, or as phantom
    if self:GetIsLocalPlayer() and not HelpScreen_GetHelpScreen():GetIsBeingDisplayed() then

        -- The Embryo cannot use the buy menu in any case.
        if self:GetTeamNumber() ~= 0 and not self:isa("Embryo") then

            if not self.buyMenu then
                self.buyMenu = GetGUIManager():CreateGUIScript("GUIMarineBuyMenu")
                self:TriggerEffects("marine_buy_menu_open")
            else
                self:CloseMenu()
            end

        end

    end

end

Shared.LinkClassToMap("Player", Player.kMapName, networkVarsEx, true)
