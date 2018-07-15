--[[
 * Natural Selection 2 - Combat++ Mod
 * Authors:
 *          WhiteWizard
 *
 * NS2 Utility Functions
 *
 * Overridden Functions:
 *  'GetIsCloseToMenuStructure' - Always return true so that the marine buy menu doesnt close (not used from the armory anymore)
]]

--
-- Returns the spawn point on success, nil on failure.
--
local function ValidateSpawnPoint(spawnPoint, capsuleHeight, capsuleRadius, filter, origin)

    local center = Vector(0, capsuleHeight * 0.5 + capsuleRadius, 0)
    local spawnPointCenter = spawnPoint + center
    
    -- Make sure capsule isn't interpenetrating something.
    local spawnPointBlocked = Shared.CollideCapsule(spawnPointCenter, capsuleRadius, capsuleHeight, CollisionRep.Default, PhysicsMask.AllButPCs, nil)
    if not spawnPointBlocked then

        -- Trace capsule to ground, making sure we're not on something like a player or structure
        local trace = Shared.TraceCapsule(spawnPointCenter, spawnPoint - Vector(0, 10, 0), capsuleRadius, capsuleHeight, CollisionRep.Move, PhysicsMask.AllButPCs)            
        if trace.fraction < 1 and (trace.entity == nil or not trace.entity:isa("ScriptActor")) then
        
            VectorCopy(trace.endPoint, spawnPoint)
            
            local endPoint = trace.endPoint + Vector(0, capsuleHeight / 2, 0)
            -- Trace in both directions to make sure no walls are being ignored.
            trace = Shared.TraceRay(endPoint, origin, CollisionRep.Move, PhysicsMask.AllButPCs, filter)
            local traceOriginToEnd = Shared.TraceRay(origin, endPoint, CollisionRep.Move, PhysicsMask.AllButPCs, filter)
            
            if trace.fraction == 1 and traceOriginToEnd.fraction == 1 then
                return spawnPoint - Vector(0, capsuleHeight / 2, 0)
            end
            
        end
        
    end
    
    return nil
    
end

-- Find place for player to spawn, within range of origin. Makes sure that a line can be traced between the two points
-- without hitting anything, to make sure you don't spawn on the other side of a wall. Returns nil if it can't find a
-- spawn point after a few tries.
function GetRandomSpawnForCapsule(capsuleHeight, capsuleRadius, origin, minRange, maxRange, filter, validationFunc)

    ASSERT(capsuleHeight > 0)
    ASSERT(capsuleRadius > 0)
    ASSERT(origin ~= nil)
    ASSERT(type(minRange) == "number")
    ASSERT(type(maxRange) == "number")
    ASSERT(maxRange > minRange)
    ASSERT(minRange > 0)
    ASSERT(maxRange > 0)
    
    for i = 0, kSpawnMaxRetries do
    
        local spawnPoint
        local points = GetRandomPointsWithinRadius(origin, minRange, minRange*2 + ((maxRange-minRange*2) * i / kSpawnMaxRetries), kSpawnMaxVertical, 1, 1, nil, validationFunc)
        if #points == 1 then
            spawnPoint = points[1]
        elseif Server then
            Print("GetRandomPointsWithinRadius() failed inside of GetRandomSpawnForCapsule()")
        end
        
        if spawnPoint then
        
            -- The spawn point returned by GetRandomPointsWithinRadius() may be too close to the ground.
            -- Move it up a bit so there is some "wiggle" room. ValidateSpawnPoint() traces down anyway.
            spawnPoint = spawnPoint + Vector(0, 0.5, 0)
            local validSpawnPoint = ValidateSpawnPoint(spawnPoint, capsuleHeight, capsuleRadius, filter, origin)
            if validSpawnPoint then
                return validSpawnPoint
            end
            
        end
        
    end
    
    return nil
    
end

function GetIsCloseToMenuStructure(player)
    return true
end

local function UnlockAbility(forAlien, techId)

    local mapName = LookupTechData(techId, kTechDataMapName)

    if mapName and forAlien:GetIsAlive() then
    
        local activeWeapon = forAlien:GetActiveWeapon()

        local tierWeapon = forAlien:GetWeapon(mapName)
        local hasWeapon = false
        
		if tierWeapon then
			local hasWeapon = true
		end
		
        if not tierWeapon then
        
            forAlien:GiveItem(mapName)
            
            if activeWeapon then
                forAlien:SetActiveWeapon(activeWeapon:GetMapName())
            end
            
        end
    
    end

end

local function LockAbility(forAlien, techId)

    local mapName = LookupTechData(techId, kTechDataMapName)

    if mapName and forAlien:GetIsAlive() then
    
        local tierWeapon = forAlien:GetWeapon(mapName)
        local activeWeapon = forAlien:GetActiveWeapon()
        local activeWeaponMapName = nil
        
        if activeWeapon ~= nil then
            activeWeaponMapName = activeWeapon:GetMapName()
        end
        
        if tierWeapon then
            forAlien:RemoveWeapon(tierWeapon)
        end
        
        if activeWeaponMapName == mapName then
            forAlien:SwitchWeapon(1)
        end
        
    end    
    
end

function UpdateAbilityAvailability(forAlien, tierOneTechId, tierTwoTechId, tierThreeTechId)

    local time = Shared.GetTime()

    if forAlien.timeOfLastNumHivesUpdate == nil or (time > forAlien.timeOfLastNumHivesUpdate + 0.5) then

        forAlien.oneHive = false
        forAlien.twoHives = false
        forAlien.threeHives = false

        -- iterate the unlocked abilities
        for _, abilityTechId in ipairs(LookupUpgradesByCategoryAndPrereq("Ability", forAlien:GetTechId(), forAlien:GetTeamNumber())) do

            local hasRequiredRank = LookupUpgradeData(abilityTechId, kUpDataRankIndex) <= forAlien:GetCombatRank()

            if forAlien:GetHasUpgrade(abilityTechId) and hasRequiredRank then

                -- unlock the ability and set the proper "onehive, twohives, threehives" status
                UnlockAbility(forAlien, abilityTechId)
                forAlien.oneHive = forAlien.oneHive or LookupUpgradeData(abilityTechId, kUpDataRequiresOneHiveIndex)
                forAlien.twoHives = forAlien.twoHives or LookupUpgradeData(abilityTechId, kUpDataRequiresTwoHivesIndex)
                forAlien.threeHives = forAlien.threeHives or LookupUpgradeData(abilityTechId, kUpDataRequiresThreeHivesIndex)

            else

                -- not purchased, so lock it
                LockAbility(forAlien, abilityTechId)

            end

        end

    end

end