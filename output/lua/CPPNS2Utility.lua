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

        if forAlien.UpgradeManager then

            -- iterate the unlocked abilities
            for _, node in ipairs(forAlien.UpgradeManager:GetTree():GetUnlockedUpgradesByCategory("Ability")) do

                -- only unlock abilities for the current alien lifeform
                if node.prereqTechId == forAlien:GetTechId() then

                    if node:GetIsPurchased() then

                        -- unlock the ability and set the proper "onehive, twohives, threehives" status
                        UnlockAbility(forAlien, node:GetTechId())
                        forAlien.oneHive = forAlien.oneHive or LookupUpgradeData(node:GetTechId(), kUpDataRequiresOneHiveIndex)
                        forAlien.twoHives = forAlien.twoHives or LookupUpgradeData(node:GetTechId(), kUpDataRequiresTwoHivesIndex)
                        forAlien.threeHives = forAlien.threeHives or LookupUpgradeData(node:GetTechId(), kUpDataRequiresThreeHivesIndex)

                    else

                        -- not purchased, so lock it
                        LockAbility(forAlien, node:GetTechId())

                    end

                else

                    -- not for the current lifefrom, so lock it
                    LockAbility(forAlien, node:GetTechId())

                end

            end

        end

    end

end