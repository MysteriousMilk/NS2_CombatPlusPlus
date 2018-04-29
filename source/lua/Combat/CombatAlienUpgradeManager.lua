Script.Load("lua/Combat/UpgradeManager.lua")
Script.Load("lua/Combat/UpgradeData.lua")
Script.Load("lua/CPPUtilities.lua")

class 'CombatAlienUpgradeManager' (UpgradeManager)

function CombatAlienUpgradeManager:CreateUpgradeTree()

    -- class upgrades
    self.Upgrades:AddClassNode(kTechId.Skulk, kTechId.None, nil)
    self.Upgrades:AddClassNode(kTechId.Gorge, kTechId.None, nil)
    self.Upgrades:AddClassNode(kTechId.Lerk, kTechId.None, nil)
    self.Upgrades:AddClassNode(kTechId.Fade, kTechId.None, nil)
    self.Upgrades:AddClassNode(kTechId.Onos, kTechId.None, nil)

    -- spur upgrades
    self.Upgrades:AddUpgradeNode(kTechId.Spur, kTechId.None, nil)
    self.Upgrades:AddUpgradeNode(kTechId.Adrenaline, kTechId.Spur, nil)
    self.Upgrades:AddUpgradeNode(kTechId.Celerity, kTechId.Spur, nil)
    self.Upgrades:AddUpgradeNode(kTechId.Silence, kTechId.Spur, nil)

    -- veil upgrades
    self.Upgrades:AddUpgradeNode(kTechId.Veil, kTechId.None, nil)
    self.Upgrades:AddUpgradeNode(kTechId.Aura, kTechId.Veil, nil)
    self.Upgrades:AddUpgradeNode(kTechId.Focus, kTechId.Veil, nil)
    self.Upgrades:AddUpgradeNode(kTechId.Vampirism, kTechId.Veil, nil)

    -- shell upgrades
    self.Upgrades:AddUpgradeNode(kTechId.Shell, kTechId.None, nil)
    self.Upgrades:AddUpgradeNode(kTechId.Regeneration, kTechId.Shell, nil)
    self.Upgrades:AddUpgradeNode(kTechId.Carapace, kTechId.Shell, nil)
    self.Upgrades:AddUpgradeNode(kTechId.Crush, kTechId.Shell, nil)

    -- skulk upgrades
    self.Upgrades:AddUpgradeNode(kTechId.Leap, kTechId.Skulk, nil)
    self.Upgrades:AddUpgradeNode(kTechId.Xenocide, kTechId.Skulk, nil)

    -- gorge upgrades
    self.Upgrades:AddUpgradeNode(kTechId.BileBomb, kTechId.Gorge, nil)

    -- lerk upgrades
    self.Upgrades:AddUpgradeNode(kTechId.Spores, kTechId.Lerk, nil)
    self.Upgrades:AddUpgradeNode(kTechId.Umbra, kTechId.Lerk, nil)

    -- fade upgrades
    self.Upgrades:AddUpgradeNode(kTechId.MetabolizeEnergy, kTechId.Fade, nil)
    self.Upgrades:AddUpgradeNode(kTechId.MetabolizeHealth, kTechId.Fade, nil)
    self.Upgrades:AddUpgradeNode(kTechId.Stab, kTechId.Fade, nil)

    -- onos upgrades
    self.Upgrades:AddUpgradeNode(kTechId.Charge, kTechId.Onos, nil)
    self.Upgrades:AddUpgradeNode(kTechId.BoneShield, kTechId.Onos, nil)
    self.Upgrades:AddUpgradeNode(kTechId.Stomp, kTechId.Onos, nil)

    self.Upgrades:SetIsUnlocked(kTechId.Skulk, true)
    self.Upgrades:SetIsPurchased(kTechId.Skulk, true)

    self.Upgrades:SetIsUnlocked(kTechId.Gorge, true)

end

local function GetAndEvaluateEvolveLocation(newLifeFormTechId, player)

    local position = player:GetOrigin()
    local trace = Shared.TraceRay(position, position + Vector(0, -0.5, 0), CollisionRep.Move, PhysicsMask.AllButPCs, EntityFilterOne(player))

    local roomAfter
    local evolveAllowed = false

    if trace.surface ~= "no_evolve" then

        local eggExtents = LookupTechData(kTechId.Embryo, kTechDataMaxExtents)
        local newAlienExtents = LookupTechData(newLifeFormTechId, kTechDataMaxExtents)
        local physicsMask = PhysicsMask.Evolve

        -- Add a bit to the extents when looking for a clear space to spawn.
        local spawnBufferExtents = Vector(0.1, 0.1, 0.1)
        local spawnPoint

        evolveAllowed = player:GetIsOnGround() and GetHasRoomForCapsule(eggExtents + spawnBufferExtents, position + Vector(0, eggExtents.y + Embryo.kEvolveSpawnOffset, 0), CollisionRep.Default, physicsMask, player)

        -- If not on the ground for the buy action, attempt to automatically
        -- put the player on the ground in an area with enough room for the new Alien.
        if not evolveAllowed then

            for index = 1, 100 do

                spawnPoint = GetRandomSpawnForCapsule(eggExtents.y, math.max(eggExtents.x, eggExtents.z), player:GetModelOrigin(), 0.5, 5, EntityFilterOne(player))

                if spawnPoint then
                    player:SetOrigin(spawnPoint)
                    position = spawnPoint
                    break
                end

            end

        end

        if not GetHasRoomForCapsule(newAlienExtents + spawnBufferExtents, player:GetOrigin() + Vector(0, newAlienExtents.y + Embryo.kEvolveSpawnOffset, 0), CollisionRep.Default, PhysicsMask.AllButPCsAndRagdollsAndBabblers, nil, EntityFilterOne(player)) then

            for index = 1, 100 do

                roomAfter = GetRandomSpawnForCapsule(newAlienExtents.y, math.max(newAlienExtents.x, newAlienExtents.z), player:GetModelOrigin(), 0.5, 5, EntityFilterOne(player))

                if roomAfter then
                    evolveAllowed = true
                    break
                end

            end

        else
            roomAfter = position
            evolveAllowed = true
        end

    end

    return { isAllowed = evolveAllowed, pos = roomAfter }

end

local function Gestate(gestateUpgrades, player)

    local success = false

    if table.icount(gestateUpgrades) > 0 then

        local lifeFormTechId = ConditionalValue(LookupTechData(gestateUpgrades[1], kTechDataGestateName), gestateUpgrades[1], player:GetTechId())

        -- all upgrades valid, check for valid spawn location
        local evolveData = GetAndEvaluateEvolveLocation(lifeFormTechId, player)

        if evolveData and evolveData.isAllowed and evolveData.pos ~= nil then

            local newPlayer = player:Replace(Embryo.kMapName)
            local origin = evolveData.pos + Vector(0, Embryo.kEvolveSpawnOffset, 0)
            newPlayer:SetOrigin(origin)

            -- Clear angles, in case we were wall-walking or doing some crazy alien thing
            local angles = Angles(player:GetViewAngles())
            angles.roll = 0.0
            angles.pitch = 0.0
            newPlayer:SetOriginalAngles(angles)
            newPlayer:SetValidSpawnPoint(evolveData.pos)

            -- Eliminate velocity so that we don't slide or jump as an egg
            newPlayer:SetVelocity(Vector(0, 0, 0))
            newPlayer:DropToFloor()

            newPlayer:SetGestationData(gestateUpgrades, player:GetTechId(), player:GetHealthFraction(), player:GetArmorScalar())

            success = true

        end

    end

    return success

end

function CombatAlienUpgradeManager:UpgradeLogic(techIdList, currNode, player, overrideCost)

    local requiresGestation = false
    local success = true

    for k, techId in ipairs(techIdList) do
        if LookupUpgradeData(techId, kUpDataRequiresGestation) then
            requiresGestation = true
            break
        end
    end

    if not requiresGestation then
        success = UpgradeManager.UpgradeLogic(self, techIdList, currNode, player, overrideCost)
    end

    return success

end


-- function CombatAlienUpgradeManager:GiveUpgrades(techIdList, player, overrideCost)

--     assert(type(techIdList) == "table")

--     --Nothing to buy
--     if table.icount(techIdList) == 0 then
--         return true
--     end

--     -- push lifeform techId to top
--     table.sort(techIdList, function(a,b) return LookupTechData(a, kTechDataGestateName) end)
    
--     local lifeFormTechId = ConditionalValue(LookupTechData(techIdList[1], kTechDataGestateName), techIdList[1], player:GetTechId())
--     local success = true

--     -- create two tables, 1 for upgrades that require gestation, and 1 for upgrades that don't
--     local gestateUpgrades = {}
--     local otherUpgrades = {}

--     -- validate all upgrades meet preconditions (cost, prereqs, etc.)
--     for k, techId in ipairs(techIdList) do

--         -- ensure no funny business
--         local teamForTechId = LookupUpgradeData(techId, kUpDataTeamIndex)
--         assert(teamForTechId == player:GetTeamNumber())

--         local node = self.Upgrades:GetNode(techId)
        
--         if node then
            
--             if overrideCost then
--                 success = success and node:GetIsUnlocked() and node:MeetsPreconditions(self.Upgrades)
--             else
--                 success = success and self:PreGiveUpgrade(node, player)
--             end

--             -- determine the proper bucket
--             if LookupUpgradeData(techId, kUpDataRequiresGestation) then
--                 table.insert(gestateUpgrades, techId)
--             else
--                 table.insert(otherUpgrades, techId)
--             end

--         else
--             success = false
--             break
--         end

--     end

--     if success then

--         if table.icount(gestateUpgrades) > 0 then

--             -- all upgrades valid, check for valid spawn location
--             local evolveData = GetAndEvaluateEvolveLocation(lifeFormTechId, player)

--             if evolveData and evolveData.isAllowed and evolveData.pos ~= nil then

--                 -- apply the other upgrades before calling player:Replace
--                 -- they will move through to the embryo and get applied when the player "hatches"
--                 for k, techId in ipairs(otherUpgrades) do
--                     self.Upgrades:SetIsPurchased(techId, true)
--                 end

--                 local newPlayer = player:Replace(Embryo.kMapName)
--                 local origin = evolveData.pos + Vector(0, Embryo.kEvolveSpawnOffset, 0)
--                 newPlayer:SetOrigin(origin)

--                 -- Clear angles, in case we were wall-walking or doing some crazy alien thing
--                 local angles = Angles(player:GetViewAngles())
--                 angles.roll = 0.0
--                 angles.pitch = 0.0
--                 newPlayer:SetOriginalAngles(angles)
--                 newPlayer:SetValidSpawnPoint(evolveData.pos)

--                 -- Eliminate velocity so that we don't slide or jump as an egg
--                 newPlayer:SetVelocity(Vector(0, 0, 0))
--                 newPlayer:DropToFloor()

--                 newPlayer:SetGestationData(gestateUpgrades, player:GetTechId(), player:GetHealthFraction(), player:GetArmorScalar())

--                 for k, techId in ipairs(gestateUpgrades) do

--                     local node = newPlayer.UpgradeManager:GetTree():GetNode(techId)

--                     if node then
--                         newPlayer.UpgradeManager:PostGiveUpgrades(techIdList, player, overrideCost)
--                     end

--                 end

--             else
--                 success = false
--             end

--         else

--             for k, techId in ipairs(otherUpgrades) do

--                 local node = self.Upgrades:GetNode(techId)

--                 if node then

--                     if node.upgradeFunc then
--                         success = success and node.upgradeFunc(techId, player)
--                     end


--                 end

--             end

--         end

--     end

--     return success

-- end

function CombatAlienUpgradeManager:PostGiveUpgrades(techIds, player, cost, overrideCost)

    local gestateUpgrades = {}
    local success = true

    local oldSkillPointAmount = player:GetCombatSkillPoints()

    UpgradeManager.PostGiveUpgrades(self, techIds, player, cost, overrideCost)

    -- build a table of upgrades that require gestation
    for k, techId in ipairs(techIds) do
        if LookupUpgradeData(techId, kUpDataRequiresGestation) then
            table.insert(gestateUpgrades, techId)
        end
    end

    -- push lifeform techId to top
    table.sort(gestateUpgrades, function(a,b) return LookupTechData(a, kTechDataGestateName) end)

    -- if the player should gestate, make them do so
    if table.icount(gestateUpgrades) > 0 then
        success = Gestate(gestateUpgrades, player)
    end

    -- if we could not gestate, refund the skill points
    if not success then
        player:SetCombatSkillPoints(oldSkillPointAmount)
    end

end