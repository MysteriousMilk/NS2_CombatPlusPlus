--[[
 * Natural Selection 2 - Combat++ Mod
 * Authors:
 *          WhiteWizard
 *
 * Server-side player logic.
 *
 * Hooked Functions:
 *  'Player:Reset' - Resets player upgrades and clears owned structures.
 *  'Player:CopyPlayerDataFrom' - Copies important information from the old player object to the new player object.
 *
 * Overriden Functions:
 *  'Player:ProcessBuyAction' - Uses the Upgrade Manager to purchase new upgrades.
]]

local ns2_Player_Reset = Player.Reset
function Player:Reset()

    ns2_Player_Reset(self)

    self.isSpawning = false
    self.gotSpawnProtect = nil
    self.activeSpawnProtect = false
    self.deactivateSpawnProtect = nil

    self.ownedStructures = {}

end

local ns2_Player_CopyPlayerDataFrom = Player.CopyPlayerDataFrom
function Player:CopyPlayerDataFrom(player)

    ns2_Player_CopyPlayerDataFrom(self, player)

    self.currentCreateStructureTechId = player.currentCreateStructureTechId
    self.ownedStructures = player.ownedStructures

    self.isSpawning = player.isSpawning
    self.gotSpawnProtect = player.gotSpawnProtect
    self.activeSpawnProtect = player.activeSpawnProtect
    self.deactivateSpawnProtect = player.deactivateSpawnProtect
    
end

-- A table of tech Ids is passed in.
function Player:ProcessBuyAction(techIds)

    ASSERT(type(techIds) == "table")
    ASSERT(table.icount(techIds) > 0)

    local success = false

    if CombatPlusPlus_GetIsStructureTechId(techIds[1]) then
        -- use override cost flag because the cost will be subtracted when the structure is actually placed
        success = self:GetTeam():GetUpgradeHelper():GiveUpgrades(techIds, self, true)
    else
        success = self:GetTeam():GetUpgradeHelper():GiveUpgrades(techIds, self)
    end

    return success

end

--[[
    Call this function to destroy/kill any structures created by the player.
]]
function Player:KillOwnedStructures()

    for _, entId in ipairs(self.ownedStructures) do

        entity = Shared.GetEntity(entId)

        -- kill the entity
        if HasMixin(entity, "Live") and entity:GetIsAlive() and entity:GetCanDie(true) then
            entity:Kill(nil, nil, entity:GetOrigin())
        end

    end

    self.ownedStructures = {}

end

-- function for spawn protect
function Player:SetSpawnProtect()

    self.activeSpawnProtect = true
    self.deactivateSpawnProtect = nil

end

function Player:DeactivateSpawnProtect()

    self:SetHealth( self:GetMaxHealth() )
    self:SetArmor( self:GetMaxArmor() )

    self.activeSpawnProtect = nil
    self.gotSpawnProtect = nil

    -- Deactivate the nano shield by manipulating the time variable.
    self.timeNanoShieldInit = 0

end

function Player:PerformSpawnProtect()

    -- Only make the effects once.
    if not self.gotSpawnProtect then

        -- Fire the effects on a slight delay because something in the NS2 code normally clears it first!
        if not self.spawnProtectActivateTime then

            self.spawnProtectActivateTime = Shared.GetTime() + kCombatSpawnProtectDelay

        elseif Shared.GetTime() >= self.spawnProtectActivateTime then

            if HasMixin(self, "NanoShieldAble") then

                self:ActivateNanoShield()
                if self.nanoShielded then
                    self.gotSpawnProtect = true
                end

            elseif self:isa("Alien") then

                local spawnProtectTimeLeft = self.deactivateSpawnProtect - Shared.GetTime()
                self:SetHasUmbra(true, spawnProtectTimeLeft)
                self.gotSpawnProtect = true

            end

        end

    end

end

local ns2_Player_OnUpdatePlayer = Player.OnUpdatePlayer
function Player:OnUpdatePlayer(deltaTime)

    ns2_Player_OnUpdatePlayer(self, deltaTime)

    -- Spawn Protect
    if self.activeSpawnProtect then

        if self:GetIsAlive() and (self:GetTeamNumber() == 1 or self:GetTeamNumber() == 2) then

            if not self.deactivateSpawnProtect then

                -- set the real spawn protect time here
                local spawnProtectTime = 0
                if self:isa("Alien") then
                    spawnProtectTime = kCombatAlienSpawnProtectTime
                else
                    spawnProtectTime = kCombatMarineSpawnProtectTime
                end

                self.deactivateSpawnProtect = Shared.GetTime() +  kCombatMarineSpawnProtectTime

            end

            if Shared.GetTime() >= self.deactivateSpawnProtect then

                -- end spawn protect
                self:DeactivateSpawnProtect()

            else

                if not self.gotSpawnProtect then
                    self:PerformSpawnProtect()
                end

            end
            
        end

    end

end