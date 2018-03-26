-- Morph into new class or buy upgrade.
function Alien:ProcessBuyAction(techIds)

    ASSERT(type(techIds) == "table")
    Shared.Message(string.format("Items to buy = %s", table.icount(techIds)))

    --Nothing to buy
    if table.icount(techIds) == 0 then
        return true
    end

    local success = false

    if GetGamerules():GetGameStarted() or GetGamerules():GetWarmUpActive() then

        local upgradeIds = {}
        local lifeFormTechId
        for _, techId in ipairs(techIds) do

            if LookupTechData(techId, kTechDataGestateName) then
                lifeFormTechId = techId
            else
                table.insertunique(upgradeIds, techId)
            end

        end

        local upgradesAllowed = true
        local upgradeManager = AlienUpgradeManager()
        upgradeManager:Populate(self)
        -- add this first because it will allow switching existing upgrades
        if lifeFormTechId then
            upgradeManager:AddUpgrade(lifeFormTechId)
        end
        for _, newUpgradeId in ipairs(upgradeIds) do

            if newUpgradeId ~= kTechId.None and not upgradeManager:AddUpgrade(newUpgradeId, true) then
                upgradesAllowed = false
                break
            end

        end

        --check if there has been any change before starting to evolve
        if not upgradesAllowed or not upgradeManager:GetHasChanged() then
            self:TriggerInvalidSound()
            return false
        end

        local position = self:GetOrigin()
        local trace = Shared.TraceRay(position, position + Vector(0, -0.5, 0), CollisionRep.Move, PhysicsMask.AllButPCs, EntityFilterOne(self))

        if trace.surface ~= "no_evolve" then

            -- Check for room
            local eggExtents = LookupTechData(kTechId.Embryo, kTechDataMaxExtents)
            local newLifeFormTechId = upgradeManager:GetLifeFormTechId()
            local newAlienExtents = LookupTechData(newLifeFormTechId, kTechDataMaxExtents)
            local physicsMask = PhysicsMask.Evolve

            -- Add a bit to the extents when looking for a clear space to spawn.
            local spawnBufferExtents = Vector(0.1, 0.1, 0.1)

            local evolveAllowed = self:GetIsOnGround() and GetHasRoomForCapsule(eggExtents + spawnBufferExtents, position + Vector(0, eggExtents.y + Embryo.kEvolveSpawnOffset, 0), CollisionRep.Default, physicsMask, self)

            local roomAfter
            local spawnPoint

            -- If not on the ground for the buy action, attempt to automatically
            -- put the player on the ground in an area with enough room for the new Alien.
            if not evolveAllowed then

                for index = 1, 100 do

                    spawnPoint = GetRandomSpawnForCapsule(eggExtents.y, math.max(eggExtents.x, eggExtents.z), self:GetModelOrigin(), 0.5, 5, EntityFilterOne(self))

                    if spawnPoint then
                        self:SetOrigin(spawnPoint)
                        position = spawnPoint
                        break
                    end

                end


            end

            if not GetHasRoomForCapsule(newAlienExtents + spawnBufferExtents, self:GetOrigin() + Vector(0, newAlienExtents.y + Embryo.kEvolveSpawnOffset, 0), CollisionRep.Default, PhysicsMask.AllButPCsAndRagdollsAndBabblers, nil, EntityFilterOne(self)) then

                for index = 1, 100 do

                    roomAfter = GetRandomSpawnForCapsule(newAlienExtents.y, math.max(newAlienExtents.x, newAlienExtents.z), self:GetModelOrigin(), 0.5, 5, EntityFilterOne(self))

                    if roomAfter then
                        evolveAllowed = true
                        break
                    end

                end

            else
                roomAfter = position
                evolveAllowed = true
            end

            if evolveAllowed and roomAfter ~= nil then

                local oldLifeFormTechId = self:GetTechId()
                local newPlayer = self:Replace(Embryo.kMapName)
                position.y = position.y + Embryo.kEvolveSpawnOffset
                newPlayer:SetOrigin(position)

                -- Clear angles, in case we were wall-walking or doing some crazy alien thing
                local angles = Angles(self:GetViewAngles())
                angles.roll = 0.0
                angles.pitch = 0.0
                newPlayer:SetOriginalAngles(angles)
                newPlayer:SetValidSpawnPoint(roomAfter)

                -- Eliminate velocity so that we don't slide or jump as an egg
                newPlayer:SetVelocity(Vector(0, 0, 0))
                newPlayer:DropToFloor()

                --newPlayer:SetResources(upgradeManager:GetAvailableResources())
                newPlayer:SetCombatSkillPoints(upgradeManager:GetAvailableSkillPoints())
                newPlayer:SetGestationData(upgradeManager:GetUpgrades(), self:GetTechId(), self:GetHealthFraction(), self:GetArmorScalar())

                if oldLifeFormTechId and lifeFormTechId and oldLifeFormTechId ~= lifeFormTechId then
                    newPlayer.oneHive = false
                    newPlayer.twoHives = false
                    newPlayer.threeHives = false
                end

                success = true

            end

        end

    end

    if not success then
        self:TriggerInvalidSound()
    end

    return success

end
