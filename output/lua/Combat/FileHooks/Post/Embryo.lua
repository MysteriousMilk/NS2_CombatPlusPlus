-- local ns2_Embryo_SetGestationData = Embryo.SetGestationData
-- function Embryo:SetGestationData(techIds, previousTechId, healthScalar, armorScalar)

--     ns2_Embryo_SetGestationData(self, techIds, previousTechId, healthScalar, armorScalar)

--     self.gestationTime = kSkulkGestateTime

--     if self.isSpawning then

--         self.gestationTime = kSpawnGestateTime

--     else

--         local newGestateTime = kGestateTime[previousTechId]
--         if newGestateTime then
--             self.gestationTime = newGestateTime
--         end

--     end

--     self.isSpawning = false

-- end

function Embryo:SetGestationData(techIds, previousTechId, healthScalar, armorScalar)

    -- Save upgrades so they can be given when spawned
    self.evolvingUpgrades = {}
    table.copy(techIds, self.evolvingUpgrades)

    self.gestationClass = nil
    
    for i, techId in ipairs(techIds) do
        self.gestationClass = LookupTechData(techId, kTechDataGestateName)
        if self.gestationClass then 
            -- Remove gestation tech id from "upgrades"
            self.gestationTypeTechId = techId
            table.removevalue(self.evolvingUpgrades, self.gestationTypeTechId)
            break
        end
    end
    
    -- Upgrades don't have a gestate name, we want to gestate back into the
    -- current alien type, previousTechId.
    if not self.gestationClass then
        self.gestationTypeTechId = previousTechId
        self.gestationClass = LookupTechData(previousTechId, kTechDataGestateName)
    end
    self.gestationStartTime = Shared.GetTime()

    self.gestationTime = ConditionalValue(self.isSpawning, kSpawnGestateTime, kGestateTime[self.gestationTypeTechId])
    if self.gestationTypeTechId == previousTechId then
        self.gestationTime = kUpgradeGestateTime
    end
    
    self.evolveTime = 0
    
    local maxHealth = LookupTechData(self.gestationTypeTechId, kTechDataMaxHealth) * 0.3 + 100
    maxHealth = math.round(maxHealth * 0.1) * 10

    self:SetMaxHealth(maxHealth)
    self:SetHealth(maxHealth * healthScalar)
    self:SetMaxArmor(0)
    self:SetArmor(0)
    
    -- Use this amount of health when we're done evolving
    self.storedHealthScalar = healthScalar
    self.storedArmorScalar = armorScalar
    
end