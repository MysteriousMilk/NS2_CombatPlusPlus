--[[
 * Natural Selection 2 - Combat++ Mod
 * Authors:
 *          WhiteWizard
 *
 * Some marine spawn code, and initial structure placement.
]]

MarineTeam.kSpawnArmoryMaxRetries = 200
MarineTeam.kArmorySpawnMinDistance = 6
MarineTeam.kArmorySpawnMaxDistance = 60

-- remove no-ip check
function MarineTeam:Update(timePassed)

    PROFILE("MarineTeam:Update")

    PlayingTeam.Update(self, timePassed)

    for index, player in ipairs(GetEntitiesForTeam("Player", self:GetTeamNumber())) do
        if player:isa("Marine") then
            player:UpdateArmorAmount(player:GetArmorLevel())
        end
    end

end

function MarineTeam:SpawnWarmUpStructures()

end

function MarineTeam:SpawnInitialStructures(techPoint)

    self.startTechPoint = techPoint

    local tower, commandStation = PlayingTeam.SpawnInitialStructures(self, techPoint)

    -- Check if there is already an Armory
	if #GetEntitiesForTeam("Armory", self:GetTeamNumber()) == 0 then	

        -- spawn initial Armory for marine team    
        local techPointOrigin = techPoint:GetOrigin() + Vector(0, 2, 0)
        
        for i = 1, MarineTeam.kSpawnArmoryMaxRetries do

            -- Increase the spawn distance on a gradual basis.
            local origin = CalculateRandomSpawn(nil, techPointOrigin, kTechId.Armory, true, MarineTeam.kArmorySpawnMinDistance, (MarineTeam.kArmorySpawnMaxDistance * i / MarineTeam.kSpawnArmoryMaxRetries), nil)

            if origin then

                local armory = CreateEntity(Armory.kMapName, origin - Vector(0, 0.1, 0), self:GetTeamNumber())
                
                SetRandomOrientation(armory)
                armory:SetConstructionComplete()
                break

            end

        end

    end

    return tower, commandStation

end
