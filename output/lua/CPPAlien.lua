local ns2_Alien_OnCreate = Alien.OnCreate
function Alien:OnCreate()

    if Server then
        self.UpgradeManager = CombatAlienUpgradeManager()
    end

    ns2_Alien_OnCreate(self)

end

local ns2_Alien_SetHatched = Alien.SetHatched
function Alien:SetHatched()

    ns2_Alien_SetHatched(self)

    -- Fix for umbra (spawn protect) not transferring from the egg
    -- to the new lifeform.
    if self.activeSpawnProtect then
        self.gotSpawnProtect = false
        self:PerformSpawnProtect()
    end

end

function Alien:UpdateHealthAmount()

	-- Cap the health level at the max biomass level
    local level = Clamp(self:GetCombatRank() - 1, 0, 12)
    local newMaxHealth = self:GetBaseHealth() + level * self:GetHealthPerBioMass()

    if newMaxHealth ~= self.maxHealth then

        local healthPercent = self.maxHealth > 0 and self.health/self.maxHealth or 0
        self.maxHealth = newMaxHealth
        self:SetHealth(self.maxHealth * healthPercent)
    
    end

end