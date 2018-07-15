function CombatPlusPlus_XPRequiredForNextRank(currentXP, rank)

    local xpRequired = 0
    if rank < kMaxCombatRank then
        xpRequired = kXPTable[ rank + 1 ]["XP"]
    end

    return xpRequired

end

function CombatPlusPlus_GetXPThresholdByRank(rank)

    rank = Clamp(rank, 1, kMaxCombatRank)
    return kXPTable[rank]["XP"]

end

function CombatPlusPlus_GetMarineTitleByRank(rank)

    rank = Clamp(rank, 1, kMaxCombatRank)
    return kXPTable[rank]["MarineName"]

end

function CombatPlusPlus_GetAlienTitleByRank(rank)

    rank = Clamp(rank, 1, kMaxCombatRank)
    return kXPTable[rank]["AlienName"]

end

function CombatPlusPlus_GetBaseKillXP(victimRank)

    victimRank = Clamp(victimRank, 1, kMaxCombatRank)
    return kXPTable[victimRank]["BaseXpOnKill"]

end

function CombatPlusPlus_GetRankByXP(xp)

    local rank = 1

    if xp >= kXPTable[kMaxCombatRank]["XP"] then

      rank = kMaxCombatRank

    else

      for i = 1, kMaxCombatRank-1 do

          if xp < kXPTable[ i + 1 ]["XP"] then
              rank = kXPTable[i]["Rank"]
              break
          end

      end

    end

    return rank

end

function CombatPlusPlus_GetSpecialXpAwardAmount(type)

    return kSpecialXpAwardTable[type]

end

function CombatPlusPlus_GetAverageXp(ignorePlayer)
    
    local averageXp = 0
    local totalXp = 0
    local numPlayers = 0
    
    for _, player in ientitylist(Shared.GetEntitiesWithClassname("Player")) do
        
        if player ~= ignorePlayer and (player:GetTeamNumber() == kTeam1Index or player:GetTeamNumber() == kTeam2Index) then
            
            totalXp = totalXp + player:GetCombatXP()
            numPlayers = numPlayers + 1
            
        end
        
    end
    
    if totalXp > 0 and numPlayers > 0 then
        averageXp = math.floor((totalXp / numPlayers) * kAverageXpModifier)
    end
    
    return averageXp
    
end

function CombatPlusPlus_GetTeamAverageXp(teamNumber, ignorePlayer)

    local averageXp = 0
    local totalXp = 0
    local numPlayers = 0
    
    for _, player in ientitylist(Shared.GetEntitiesWithClassname("Player")) do
        
        if player ~= ignorePlayer and player:GetTeamNumber() == teamNumber then
            
            totalXp = totalXp + player:GetCombatXP()
            numPlayers = numPlayers + 1
            
        end
        
    end
    
    if totalXp > 0 and numPlayers > 0 then
        averageXp = math.floor((totalXp / numPlayers) * kAverageXpModifier)
    end
    
    return averageXp

end

function CombatPlusPlus_GetIsScalableXPType(type)

    local scalableXPTypes =
    {
        [kXPSourceType.Kill] = true,
        [kXPSourceType.Assist] = true,
        [kXPSourceType.Nearby] = true
    }

    return scalableXPTypes[type]

end

function CombatPlusPlus_GetDisplayNameForXpSourceType(source)

    local displayStr = ""

    if source == kXPSourceType.Damage then
        displayStr = "Damaged Target"
    elseif source == kXPSourceType.Weld then
        displayStr = "Welded Target"
    elseif source == kXPSourceType.Heal then
        displayStr = "Healed Target"
    elseif source == kXPSourceType.Build then
        displayStr = "Built Structure"
    elseif source == kXPSourceType.Kill then
        displayStr = "Kill"
    elseif source == kXPSourceType.Assist then
        displayStr = "Assist"
    elseif source == kXPSourceType.Nearby then
        displayStr = "Nearby Kill"
    elseif source == kXPSourceType.Balance then
        displayStr = "Team Balance"
    elseif source == kXPSourceType.KillStreak then
        displayStr = "Special Award: Rampage!"
    elseif source == kXPSourceType.AssistStreak then
        displayStr = "Special Award: Got Your Back!"
    elseif source == kXPSourceType.DamageDealer then
        displayStr = "Special Award: Damage Dealer!"
    end

    return displayStr

end

function CombatPlusPlus_GetIsPrimaryWeapon(kMapName)

    local isPrimary = false
    
    if kMapName == Shotgun.kMapName or
       kMapName == Flamethrower.kMapName  or
       kMapName == GrenadeLauncher.kMapName or
       kMapName == HeavyMachineGun.kMapName or
       kMapName == Rifle.kMapName then
        
        isPrimary = true
        
    end
    
    return isPrimary
end

function CombatPlusPlus_GetIsStructureTechId(techId)

    local structureIdTable =
    { 
        [kTechId.Armory] = true,
        [kTechId.PhaseGate] = true,
        [kTechId.Observatory] = true,
        [kTechId.Sentry] = true,
        [kTechId.RoboticsFactory] = true
    }

    return structureIdTable[techId]

end

function GetNextArmorTech(player)

    local nextArmorTech = kTechId.Armor1

    if player:GetHasUpgrade(kTechId.Armor1) then
        nextArmorTech = kTechId.Armor2
    elseif player:GetHasUpgrade(kTechId.Armor2) then
        nextArmorTech = kTechId.Armor3
    elseif player:GetHasUpgrade(kTechId.Armor3) then
        nextArmorTech = kTechId.None
    end

    return nextArmorTech

end

function GetNextWeaponTech(player)

    local nextWpnTech = kTechId.Weapons1

    if player:GetHasUpgrade(kTechId.Weapons1) then
        nextWpnTech = kTechId.Weapons2
    elseif player:GetHasUpgrade(kTechId.Weapons2) then
        nextWpnTech = kTechId.Weapons3
    elseif player:GetHasUpgrade(kTechId.Weapons3) then
        nextWpnTech = kTechId.None
    end

    return nextWpnTech

end

function CombatPlusPlus_GetTimeString(duration)

    local minutes = math.floor(duration / 60)
    local seconds = duration % 60

    return ConditionalValue(seconds < 10, string.format("%s:0%s", minutes, seconds), string.format("%s:%s", minutes, seconds))

end

function CombatPlusPlus_AlienPurchase(purchaseTable)

    ASSERT(type(purchaseTable) == "table")

    local purchaseTechIds = { }

    for _, purchase in ipairs(purchaseTable) do

        if purchase.Type == "Alien" then
            table.insert(purchaseTechIds, IndexToAlienTechId(purchase.Alien))
        elseif purchase.Type == "Upgrade" then
            table.insert(purchaseTechIds, purchase.TechId)
        end

    end

    if #purchaseTechIds > 0 then
        Print("Sending buy message.")
        Client.SendNetworkMessage("Buy", BuildBuyMessage(purchaseTechIds), true)
    end

end

function GetDistanceBetweenTechPoints()

    local marineTechPointOrigin = GetGamerules():GetTeam1():GetInitialTechPoint():GetOrigin()
    local alienTechPointOrigin = GetGamerules():GetTeam2():GetInitialTechPoint():GetOrigin()

    return math.abs((marineTechPointOrigin - alienTechPointOrigin):GetLength())

end

function ScaleXPByDistance(player, baseXp)

    local enemyTechPointOrigin = nil
    local scaledXp = baseXp

    if player:GetTeamNumber() == kTeam1Index then
        enemyTechPointOrigin = GetGamerules():GetTeam2():GetInitialTechPoint():GetOrigin()
    elseif player:GetTeamNumber() == kTeam2Index then
        enemyTechPointOrigin = GetGamerules():GetTeam1():GetInitialTechPoint():GetOrigin()
    end

    if enemyTechPointOrigin ~= nil then

        local distance = math.abs((enemyTechPointOrigin - player:GetOrigin()):GetLength())
        local percentage = 1 - distance / GetDistanceBetweenTechPoints()
        local modifier = LerpNumber(1, kDistanceXPModifierMaxUpperBound, percentage)
        scaledXp = math.ceil(baseXp * modifier)

    end

    return scaledXp

end

function CombatPlusPlus_GetStructureCountForTeam(techId, teamNumber)

    local className = LookupUpgradeData(techId, kUpDataStructClassIndex)

    if className then
        local structList = GetEntitiesForTeam(className, teamNumber)
        return #structList
    end

    return 0

end

function GetIsPlayingTeam(teamNumber)

    return teamNumber == kTeam1Index or teamNumber == kTeam2Index

end

function GetTimeDigital(timeInSeconds, showMinutes, showMilliseconds)

    local timeLeftText = ""
    timeNumericSeconds = tonumber(timeInSeconds)
    
	if (timeNumericSeconds < 0) then 
		timeLeftText = "- "
    end
    
	timeNumericSeconds = math.abs(tonumber(timeInSeconds))
	
    if showMinutes then
        
        local timeLeftMinutes = math.floor(timeNumericSeconds/60)
        
		if (timeLeftMinutes < 10) then
			timeLeftText = timeLeftText .. "0" .. timeLeftMinutes
		else
			timeLeftText = timeLeftText .. timeLeftMinutes
		end
	
        timeLeftText = timeLeftText .. ":"
        
	end
	
    timeLeftSeconds = math.floor(timeNumericSeconds % 60)
    
	if (timeLeftSeconds < 10) then
		timeLeftText = timeLeftText .. "0" .. timeLeftSeconds
	else
		timeLeftText = timeLeftText .. timeLeftSeconds
	end
	
	-- Disable milliseconds by default. They are *really* annoying.
    if showMilliseconds then
        
		timeLeftText = timeLeftText .. ":"
	
        local timeLeftMilliseconds = math.ceil((timeNumericSeconds * 100) % 100)
        
		if (timeLeftMilliseconds < 10) then
			timeLeftText = timeLeftText .. "0" .. timeLeftMilliseconds
		else
			timeLeftText = timeLeftText .. timeLeftMilliseconds
        end
        
	end
	
	return timeLeftText

end

function GetIsOvertime()

    if Server then
        return GetGamerules():GetIsOvertime()
    elseif Client then
        return PlayerUI_GetIsOvertime()
    else
        return false -- Predict
    end

end

function SortByPriority(techId1, techId2)

    return LookupUpgradeData(techId1, kUpDataPriorityIndex) <  LookupUpgradeData(techId2, kUpDataPriorityIndex)
    
end

-- function CreateTechEntity( techPoint, techId, rightOffset, forwardOffset, teamType )

--     local origin = techPoint:GetOrigin() + Vector(0, 2, 0)
--     local right = techPoint:GetCoords().xAxis
--     local forward = techPoint:GetCoords().zAxis
--     local position = origin + right * rightOffset + forward * forwardOffset

--     local trace = Shared.TraceRay(position, position - Vector(0, 10, 0), CollisionRep.Move, PhysicsMask.All)
--     if trace.fraction < 1 then
--         position = trace.endPoint
--     end

--     local newEnt = CreateEntityForTeam(techId, position, teamType, nil)
--     if HasMixin( newEnt, "Construct" ) then
--         SetRandomOrientation( newEnt )
--         newEnt:SetConstructionComplete()
--     end

--     if HasMixin( newEnt, "Live" ) then
--         newEnt:SetIsAlive(true)
--     end

--     return newEnt

-- end
