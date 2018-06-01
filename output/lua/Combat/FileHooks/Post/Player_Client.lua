function PlayerUI_GetArmorLevel(researched)

    local player = Client.GetLocalPlayer()
    local armorLevel = 0

    if player:isa("Marine") then
        armorLevel = player:GetArmorLevel()
    end

    return armorLevel

end

function PlayerUI_GetWeaponLevel(researched)

    local player = Client.GetLocalPlayer()
    local weaponLevel = 0

    if player:isa("Marine") then
        weaponLevel = player:GetWeaponLevel()
    end

    return weaponLevel

end

function PlayerUI_GetPersonalResources()

    local player = Client.GetLocalPlayer()
    if player then
        return player:GetCombatUpgradePoints()
    end

    return 0

end

function PlayerUI_GetTimeRemaining()

    local timeDigital = "00:00:00"
    
    if CombatSettings["TimeLimit"] then
        
        local exactTimeLeft = CombatSettings["TimeLimit"] - PlayerUI_GetGameLengthTime()
        
        if exactTimeLeft > 0 then
            
			local showMinutes = math.abs(exactTimeLeft) > 0
            local showMilliseconds = exactTimeLeft > 0 and exactTimeLeft < 30
            
            timeDigital = GetTimeDigital(exactTimeLeft, showMinutes, showMilliseconds)
            
        end
        
	end
	
	return timeDigital

end

function PlayerUI_GetIsOvertime()

    if CombatSettings["TimeLimit"] and CombatSettings["TimeLimit"] - PlayerUI_GetGameLengthTime() <= 0 then
        return true
    end

    return false

end