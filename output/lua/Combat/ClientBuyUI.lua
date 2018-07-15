function BuyUI_GetIsTechUnlocked(techId)

    local player = Client.GetLocalPlayer()
    return player:GetCombatRank() >= LookupUpgradeData(techId, kUpDataRankIndex)

end

function BuyUI_GetHasPrerequisites(techId)

    local player = Client.GetLocalPlayer()
    local hasPrereqs = true

    for _, prereqTechId in ipairs(LookupUpgradeData(techId, kUpDataPrerequisiteIndex)) do

        if not player:GetHasUpgrade(prereqTechId) then
            
            hasPrereqs = false
            break

        end

    end

    return hasPrereqs

end
