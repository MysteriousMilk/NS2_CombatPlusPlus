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
    end

    return displayStr

end

function CombatPlusPlus_GetIsMarineClassTechId(techId)

    local marineClassIdTable =
    {
        [kTechId.Marine] = true,
        [kTechId.Jetpack] = true,
        [kTechId.DualMinigunExosuit] = true,
        [kTechId.DualRailgunExosuit] = true
    }

    return marineClassIdTable[techId]

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

function CombatPlusPlus_GetIsMarineCooldownAbility(techId)

    local abilityIdTable =
    {
        [kTechId.MedPack] = true,
        [kTechId.AmmoPack] = true,
        [kTechId.CatPack] = true,
        [kTechId.Scan] = true
    }

    return abilityIdTable[techId]

end

function CombatPlusPlus_GetIsMarineArmorUpgrade(techId)

    local armorIdTable =
    {
        [kTechId.Armor1] = true,
        [kTechId.Armor2] = true,
        [kTechId.Armor3] = true
    }

    return armorIdTable[techId]

end

function CombatPlusPlus_GetIsMarineWeaponUpgrade(techId)

    local wpnIdTable =
    {
        [kTechId.Weapons1] = true,
        [kTechId.Weapons2] = true,
        [kTechId.Weapons3] = true
    }

    return wpnIdTable[techId]

end

function CombatPlusPlus_GetTechIdByArmorLevel(level)

    local techId = kTechId.None

    if level == 1 then
        techId = kTechId.Armor1
    elseif level == 2 then
        techId = kTechId.Armor2
    elseif level == 3 then
        techId = kTechId.Armor3
    end

    return techId
    
end

function CombatPlusPlus_GetTechIdByWeaponLevel(level)

    local techId = kTechId.None

    if level == 1 then
        techId = kTechId.Weapons1
    elseif level == 2 then
        techId = kTechId.Weapons2
    elseif level == 3 then
        techId = kTechId.Weapons3
    end

    return techId
    
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

    local marineTechPointOrigin = GetGameMaster():GetMarineTechPoint():GetOrigin()
    local alienTechPointOrigin = GetGameMaster():GetAlienTechPoint():GetOrigin()

    return math.abs((marineTechPointOrigin - alienTechPointOrigin):GetLength())

end

function ScaleXPByDistance(player, baseXp)

    local enemyTechPointOrigin = nil
    local scaledXp = baseXp

    if player:GetTeamNumber() == kTeam1Index then
        enemyTechPointOrigin = GetGameMaster():GetAlienTechPoint():GetOrigin()
    elseif player:GetTeamNumber() == kTeam2Index then
        enemyTechPointOrigin = GetGameMaster():GetMarineTechPoint():GetOrigin()
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

    local className = LookupUpgradeData(techId, kUpDataClassIndex)

    if className then
        local structList = GetEntitiesForTeam(className, teamNumber)
        return #structList
    end

    return 0

end

function CreateTechEntity( techPoint, techId, rightOffset, forwardOffset, teamType )

    local origin = techPoint:GetOrigin() + Vector(0, 2, 0)
    local right = techPoint:GetCoords().xAxis
    local forward = techPoint:GetCoords().zAxis
    local position = origin + right * rightOffset + forward * forwardOffset

    local trace = Shared.TraceRay(position, position - Vector(0, 10, 0), CollisionRep.Move, PhysicsMask.All)
    if trace.fraction < 1 then
        position = trace.endPoint
    end

    local newEnt = CreateEntityForTeam(techId, position, teamType, nil)
    if HasMixin( newEnt, "Construct" ) then
        SetRandomOrientation( newEnt )
        newEnt:SetConstructionComplete()
    end

    if HasMixin( newEnt, "Live" ) then
        newEnt:SetIsAlive(true)
    end

    return newEnt

end
