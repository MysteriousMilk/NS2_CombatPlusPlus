class 'CombatAlienUpgradeManager' (UpgradeManager)

local function CheckHasPrerequisites(techId, lifeformTechId, player)

    local hasPrereqs = true

    for _, prereqTechId in ipairs(LookupUpgradeData(techId, kUpDataPrerequisiteIndex)) do

        if LookupUpgradeData(prereqTechId, kUpDataTypeIndex) == kCombatUpgradeType.Class then

            if prereqTechId ~= lifeformTechId then
                hasPrereqs = false
                break
            end

        else

            if not player:GetHasUpgrade(prereqTechId) then
                hasPrereqs = false
                break
            end

        end

    end

    return hasPrereqs

end

local function CheckIsUnlocked(techId, player)

    return LookupUpgradeData(techId, kUpDataRankIndex) <= player:GetCombatRank()

end

function CombatAlienUpgradeManager:PreGiveUpgrades(techIdList, player, overrideCost)

    local totalCost = 0
    local success = true
    local hasNewLifeformUpgrade = false
    local lifeformTechId = player:GetTechId()

    -- check to see if we have a new lifeform id
    for _, techId in ipairs(techIdList) do
        
        if LookupTechData(techId, kTechDataGestateName) and techId ~= player:GetTechId() then
            lifeformTechId = techId
            hasNewLifeformUpgrade = true
            break
        end

    end

    -- do prechecks for all upgrades and calculate a cost
    for _, techId in ipairs(techIdList) do

        local teamForTechId = LookupUpgradeData(techId, kUpDataTeamIndex)
        assert(teamForTechId == player:GetTeamNumber())

        totalCost = totalCost + LookupUpgradeData(techId, kUpDataCostIndex)

        success = success and CheckIsUnlocked(techId, player) and CheckHasPrerequisites(techId, lifeformTechId, player)

    end

    return success, totalCost

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

            return true, newPlayer

        end

    end

    return false, nil

end

function CombatAlienUpgradeManager:UpgradeLogic(techIdList, classTechId, player)

    local gestateUpgrades = {}
    local requiresGestation = false
    local hasLifeformTechId = false
    local success = true

    for k, techId in ipairs(techIdList) do

        if not LookupTechData(techId, kTechDataGestateName) and LookupUpgradeData(techId, kUpDataRequiresGestation) then
            table.insert(gestateUpgrades, techId)
            requiresGestation = true
        end
        
    end

    if classTechId and classTechId ~= kTechId.None then
        requiresGestation = true
    end

    if requiresGestation then

        if classTechId == nil or classTechId == kTechId.None then
            table.insert(gestateUpgrades, player:GetTechId())
        else
            table.insert(gestateUpgrades, classTechId)
        end

        local newLifeform

        -- push lifeform techId to top
        table.sort(gestateUpgrades, function(a,b) return LookupTechData(a, kTechDataGestateName) end)

        success, newLifeform = Gestate(gestateUpgrades, player)

    else

        -- No gestation, so loop the tech id list and apply each upgrade
        for _, techId in ipairs(techIdList) do
            
            -- run custom upgrade code for this upgrade
            local upgradeFunc = LookupUpgradeData(techId, kUpDataUpgradeFuncIndex)
            if upgradeFunc then
                upgradeFunc(techId, player)
            end

        end

        if player.classTech == kTechId.None then
            player.classTech = player:GetTechId()
        end

        player:TriggerEffects("heal", { isalien = true })
        player:TriggerEffects("upgrade_complete")

    end

end

-- function CombatAlienUpgradeManager:UpgradeLogic(techIdList, currNode, player, overrideCost)

--     local requiresGestation = false
--     local success = true

--     for k, techId in ipairs(techIdList) do
--         if LookupUpgradeData(techId, kUpDataRequiresGestation) then
--             requiresGestation = true
--             break
--         end
--     end

--     if not requiresGestation then
--         success = UpgradeManager.UpgradeLogic(self, techIdList, currNode, player, overrideCost)
--     end

--     return success, nil

-- end

-- function CombatAlienUpgradeManager:PostGiveUpgrades(techIds, player, cost, overrideCost)

--     local gestateUpgrades = {}
--     local success = true
--     local hasLifeformTechId = false

--     local oldUpgradePointAmount = player:GetCombatUpgradePoints()

--     UpgradeManager.PostGiveUpgrades(self, techIds, player, cost, overrideCost)

--     -- build a table of upgrades that require gestation
--     for k, techId in ipairs(techIds) do

--         if LookupUpgradeData(techId, kUpDataRequiresGestation) then
--             table.insert(gestateUpgrades, techId)
--         end

--         if LookupTechData(techId, kTechDataGestateName) then
--             hasLifeformTechId = true
--         end

--     end

--     -- if no new lifeform tech id, insert current lifeform tech id
--     if not hasLifeformTechId then
--         table.insert(gestateUpgrades, player:GetTechId())
--     end

--     -- push lifeform techId to top
--     table.sort(gestateUpgrades, function(a,b) return LookupTechData(a, kTechDataGestateName) end)

--     -- if the player should gestate, make them do so
--     if table.icount(gestateUpgrades) > 0 then
--         success = Gestate(gestateUpgrades, player)
--     end

--     -- if we could not gestate, refund the upgrade points
--     if not success then
--         player:SetCombatUpgradePoints(oldUpgradePointAmount)
--     end

-- end