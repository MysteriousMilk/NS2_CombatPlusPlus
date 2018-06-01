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

function CombatAlienUpgradeManager:PreGiveUpgrades(techIdList, player, overrideCost)

    local totalCost = 0
    local success = true
    local hasNewLifeformUpgrade = false
    local lifeformTechId = kTechId.None

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

        local node = self.Upgrades:GetNode(techId)
        local cost = LookupUpgradeData(techId, kUpDataCostIndex)

        totalCost = totalCost + cost
            
        if node then

            -- If we have a lifeform upgrade, check prereqs against the new lifeform.
            if hasNewLifeformUpgrade and LookupUpgradeData(techId, kUpDataCategoryIndex) == "Ability" then
                success = success and node:GetIsUnlocked() and node.prereqTechId == lifeformTechId
            else
                -- node must be unlocked and meet all prereqs
                success = success and node:GetIsUnlocked() and node:MeetsPreconditions(self.Upgrades)
            end

        else
            
            success = false
            break

        end

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

    return success, nil

end

function CombatAlienUpgradeManager:PostGiveUpgrades(techIds, player, cost, overrideCost)

    local gestateUpgrades = {}
    local success = true
    local hasLifeformTechId = false

    local oldUpgradePointAmount = player:GetCombatUpgradePoints()

    UpgradeManager.PostGiveUpgrades(self, techIds, player, cost, overrideCost)

    -- build a table of upgrades that require gestation
    for k, techId in ipairs(techIds) do

        if LookupUpgradeData(techId, kUpDataRequiresGestation) then
            table.insert(gestateUpgrades, techId)
        end

        if LookupTechData(techId, kTechDataGestateName) then
            hasLifeformTechId = true
        end

    end

    -- if no new lifeform tech id, insert current lifeform tech id
    if not hasLifeformTechId then
        table.insert(gestateUpgrades, player:GetTechId())
    end

    -- push lifeform techId to top
    table.sort(gestateUpgrades, function(a,b) return LookupTechData(a, kTechDataGestateName) end)

    -- if the player should gestate, make them do so
    if table.icount(gestateUpgrades) > 0 then
        success = Gestate(gestateUpgrades, player)
    end

    -- if we could not gestate, refund the upgrade points
    if not success then
        player:SetCombatUpgradePoints(oldUpgradePointAmount)
    end

end