UpgradableMixin.optionalCallbacks =
{
    OnPreUpgradeToTechId = "Called right before upgrading to a new tech Id.",
    OnGiveUpgrade = "Called to notify that an upgrade was given with the tech Id as the single parameter.",
    SetInitialUpgrades = "Called to set the initial upgrade state for this entity."
}

UpgradableMixin.networkVars =
{
    classTech = "enum kTechId",    -- Ex: Marine, Exo, Skulk, Lerk, etc.
    upgrade1 = "enum kTechId",     -- Ex: Standard upgrades (shotgun, mines, celerity, leap.. etc)
    upgrade2 = "enum kTechId",
    upgrade3 = "enum kTechId",
    upgrade4 = "enum kTechId",
    upgrade5 = "enum kTechId",
    upgrade6 = "enum kTechId",
    specialTech1 = "enum kTechId", -- Ex: Special tech for combat++ (MedPack Resupply, personal ink, etc)
    specialTech2 = "enum kTechId",
    specialTech3 = "enum kTechId",
    specialTech4 = "enum kTechId",
    passiveTech1 = "enum kTechId",    -- Ex: Tech that is normally granted at the team level (weapons/armor upgrades, oneshell, threeveil, etc)
    passiveTech2 = "enum kTechId",
    passiveTech3 = "enum kTechId",
}

function UpgradableMixin:__initmixin()
    
    PROFILE("UpgradableMixin:__initmixin")
    
    self.classTech = kTechId.None
    self.upgrade1 = kTechId.None
    self.upgrade2 = kTechId.None
    self.upgrade3 = kTechId.None
    self.upgrade4 = kTechId.None
    self.upgrade5 = kTechId.None
    self.upgrade6 = kTechId.None
    self.specialTech1 = kTechId.None
    self.specialTech2 = kTechId.None
    self.specialTech3 = kTechId.None
    self.specialTech4 = kTechId.None
    self.passiveTech1 = kTechId.None
    self.passiveTech2 = kTechId.None
    self.passiveTech3 = kTechId.None
    
end

function UpgradableMixin:DebugPrintUpgrades()

    if Server then
        Log("Class Tech:     " .. kTechId[self.classTech])
        Log("Upgrade Slot 1: " .. kTechId[self.upgrade1])
        Log("Upgrade Slot 2: " .. kTechId[self.upgrade2])
        Log("Upgrade Slot 3: " .. kTechId[self.upgrade3])
        Log("Upgrade Slot 4: " .. kTechId[self.upgrade4])
        Log("Upgrade Slot 5: " .. kTechId[self.upgrade5])
        Log("Upgrade Slot 6: " .. kTechId[self.upgrade6])
        Log("Special Slot 1: " .. kTechId[self.specialTech1])
        Log("Special Slot 2: " .. kTechId[self.specialTech2])
        Log("Special Slot 3: " .. kTechId[self.specialTech3])
        Log("Special Slot 4: " .. kTechId[self.specialTech4])
        Log("Passive Slot 1: " .. kTechId[self.passiveTech1])
        Log("Passive Slot 2: " .. kTechId[self.passiveTech2])
        Log("Passive Slot 3: " .. kTechId[self.passiveTech3])
    elseif Client then
        Print("Class Tech:     " .. kTechId[self.classTech])
        Print("Upgrade Slot 1: " .. kTechId[self.upgrade1])
        Print("Upgrade Slot 2: " .. kTechId[self.upgrade2])
        Print("Upgrade Slot 3: " .. kTechId[self.upgrade3])
        Print("Upgrade Slot 4: " .. kTechId[self.upgrade4])
        Print("Upgrade Slot 5: " .. kTechId[self.upgrade5])
        Print("Upgrade Slot 6: " .. kTechId[self.upgrade6])
        Print("Special Slot 1: " .. kTechId[self.specialTech1])
        Print("Special Slot 2: " .. kTechId[self.specialTech2])
        Print("Special Slot 3: " .. kTechId[self.specialTech3])
        Print("Special Slot 4: " .. kTechId[self.specialTech4])
        Print("Passive Slot 1: " .. kTechId[self.passiveTech1])
        Print("Passive Slot 2: " .. kTechId[self.passiveTech2])
        Print("Passive Slot 3: " .. kTechId[self.passiveTech3])
    end

end

function UpgradableMixin:GetHasUpgrade(techId)

    return techId ~= kTechId.None and (techId == self.classTech or 
                                       techId == self.upgrade1 or
                                       techId == self.upgrade2 or
                                       techId == self.upgrade3 or
                                       techId == self.upgrade4 or
                                       techId == self.upgrade5 or
                                       techId == self.upgrade6 or
                                       techId == self.specialTech1 or
                                       techId == self.specialTech2 or
                                       techId == self.specialTech3 or
                                       techId == self.specialTech4 or
                                       techId == self.passiveTech1 or
                                       techId == self.passiveTech2 or
                                       techId == self.passiveTech3)
    
end

function UpgradableMixin:GetUpgrades()

    local upgrades = { }

    if self.classTech ~= kTechId.None then
        table.insert(upgrades, self.classTech)
    end
    if self.upgrade1 ~= kTechId.None then
        table.insert(upgrades, self.upgrade1)
    end
    if self.upgrade2 ~= kTechId.None then
        table.insert(upgrades, self.upgrade2)
    end
    if self.upgrade3 ~= kTechId.None then
        table.insert(upgrades, self.upgrade3)
    end
    if self.upgrade4 ~= kTechId.None then
        table.insert(upgrades, self.upgrade4)
    end
    if self.upgrade5 ~= kTechId.None then
        table.insert(upgrades, self.upgrade5)
    end
    if self.upgrade6 ~= kTechId.None then
        table.insert(upgrades, self.upgrade6)
    end
    if self.specialTech1 ~= kTechId.None then
        table.insert(upgrades, self.specialTech1)
    end
    if self.specialTech2 ~= kTechId.None then
        table.insert(upgrades, self.specialTech2)
    end
    if self.specialTech3 ~= kTechId.None then
        table.insert(upgrades, self.specialTech3)
    end
    if self.specialTech4 ~= kTechId.None then
        table.insert(upgrades, self.specialTech4)
    end
    if self.passiveTech1 ~= kTechId.None then
        table.insert(upgrades, self.passiveTech1)
    end
    if self.passiveTech2 ~= kTechId.None then
        table.insert(upgrades, self.passiveTech2)
    end
    if self.passiveTech3 ~= kTechId.None then
        table.insert(upgrades, self.passiveTech3)
    end
    
    return upgrades
    
end

function UpgradableMixin:GiveUpgrade(techId) 

    local upgradeGiven = false
    local upgradeType = LookupUpgradeData(techId, kUpDataTypeIndex)
    
    if not self:GetHasUpgrade(techId) then

        if upgradeType == kCombatUpgradeType.Class then

            if self.classTech == kTechId.None then

                self.classTech = techId
                upgradeGiven = true

            end

            assert(upgradeGiven, "Entity already has a class upgrade.")

        elseif upgradeType == kCombatUpgradeType.Upgrade then
    
            if self.upgrade1 == kTechId.None then

                self.upgrade1 = techId
                upgradeGiven = true
                
            elseif self.upgrade2 == kTechId.None then

                self.upgrade2 = techId
                upgradeGiven = true
                
            elseif self.upgrade3 == kTechId.None then

                self.upgrade3 = techId
                upgradeGiven = true
                
            elseif self.upgrade4 == kTechId.None then

                self.upgrade4 = techId
                upgradeGiven = true
                
            elseif self.upgrade5 == kTechId.None then

                self.upgrade5 = techId
                upgradeGiven = true
                
            elseif self.upgrade6 == kTechId.None then

                self.upgrade6 = techId
                upgradeGiven = true
                
            end
            
            assert(upgradeGiven, "Entity already has the max number of standard upgrades.")

        elseif upgradeType == kCombatUpgradeType.Special then
    
            if self.specialTech1 == kTechId.None then
            
                self.specialTech1 = techId
                upgradeGiven = true
                
            elseif self.specialTech2 == kTechId.None then
            
                self.specialTech2 = techId
                upgradeGiven = true
                
            elseif self.specialTech3 == kTechId.None then
            
                self.specialTech3 = techId
                upgradeGiven = true
                
            elseif self.specialTech4 == kTechId.None then
            
                self.specialTech4 = techId
                upgradeGiven = true
                
            end
            
            assert(upgradeGiven, "Entity already has the max number of standard upgrades.")

        elseif upgradeType == kCombatUpgradeType.Passive then
    
            if self.passiveTech1 == kTechId.None then
            
                self.passiveTech1 = techId
                upgradeGiven = true
                
            elseif self.passiveTech2 == kTechId.None then
            
                self.passiveTech2 = techId
                upgradeGiven = true
                
            elseif self.passiveTech3 == kTechId.None then
            
                self.passiveTech3 = techId
                upgradeGiven = true
                
            end
            
            assert(upgradeGiven, "Entity already has the max number of standard upgrades.")

        end
        
    end
    
    if upgradeGiven and self.OnGiveUpgrade then
        self:OnGiveUpgrade(techId)
    end
    
    return upgradeGiven
    
end

function UpgradableMixin:RemoveUpgrade(techId)

    local removed = false
    local upgradeType = LookupUpgradeData(techId, kUpDataTypeIndex)
    
    if self:GetHasUpgrade(techId) then

        if upgradeType == kCombatUpgradeType.Class then

            if self.classTech == techId then

                self.classTech = kTechId.None
                removed = true

            end

        elseif upgradeType == kCombatUpgradeType.Upgrade then
        
            if self.upgrade1 == techId then
            
                self.upgrade1 = kTechId.None
                removed = true
                
            elseif self.upgrade2 == techId then
            
                self.upgrade2 = kTechId.None
                removed = true
                
            elseif self.upgrade3 == techId then
            
                self.upgrade3 = kTechId.None
                removed = true
                
            elseif self.upgrade4 == techId then
            
                self.upgrade4 = kTechId.None
                removed = true
                
            elseif self.upgrade5 == techId then
            
                self.upgrade5 = kTechId.None
                removed = true
                
            elseif self.upgrade6 == techId then
            
                self.upgrade6 = kTechId.None
                removed = true
                
            end

        elseif upgradeType == kCombatUpgradeType.Special then

            if self.specialTech1 == techId then
            
                self.specialTech1 = kTechId.None
                removed = true
                
            elseif self.specialTech2 == techId then
            
                self.specialTech2 = kTechId.None
                removed = true
                
            elseif self.specialTech3 == techId then
            
                self.specialTech3 = kTechId.None
                removed = true
                
            elseif self.specialTech4 == techId then
            
                self.specialTech4 = kTechId.None
                removed = true
                
            end

        elseif upgradeType == kCombatUpgradeType.Passive then

            if self.passiveTech1 == techId then
            
                self.passiveTech1 = kTechId.None
                removed = true
                
            elseif self.passiveTech2 == techId then
            
                self.passiveTech2 = kTechId.None
                removed = true
                
            elseif self.passiveTech3 == techId then
            
                self.passiveTech3 = kTechId.None
                removed = true
                
            end

        end
        
    end
    
    return removed
    
end

function UpgradableMixin:Reset()

    self:ClearUpgrades()
    
end

function UpgradableMixin:OnKill()
    --self:ClearUpgrades()
end

function UpgradableMixin:ClearUpgrades()

    Shared.Message("Clearing upgrades.")

    self.classTech = kTechId.None
    self.upgrade1 = kTechId.None
    self.upgrade2 = kTechId.None
    self.upgrade3 = kTechId.None
    self.upgrade4 = kTechId.None
    self.upgrade5 = kTechId.None
    self.upgrade6 = kTechId.None
    self.specialTech1 = kTechId.None
    self.specialTech2 = kTechId.None
    self.specialTech3 = kTechId.None
    self.specialTech4 = kTechId.None
    self.passiveTech1 = kTechId.None
    self.passiveTech2 = kTechId.None
    self.passiveTech3 = kTechId.None

    if self:isa("Marine") then
        self.classTech = kTechId.Marine
        Shared.Message("Marine Defaults Upgrades set.")
    elseif self:isa("Alien") then
        self.classTech = kTechId.Skulk
        self.passiveTech1 = kTechId.Spur
        self.passiveTech2 = kTechId.Veil
        self.passiveTech3 = kTechId.Shell
        Shared.Message("Alien Defaults Upgrades set.")
    end

end

if Server then

    function UpgradableMixin:CopyPlayerDataFrom(player)

        self.classTech = player.classTech
        self.upgrade1 = player.upgrade1
        self.upgrade2 = player.upgrade2
        self.upgrade3 = player.upgrade3
        self.upgrade4 = player.upgrade4
        self.upgrade5 = player.upgrade5
        self.upgrade6 = player.upgrade6
        self.specialTech1 = player.specialTech1
        self.specialTech2 = player.specialTech2
        self.specialTech3 = player.specialTech3
        self.specialTech4 = player.specialTech4
        self.passiveTech1 = player.passiveTech1
        self.passiveTech2 = player.passiveTech2
        self.passiveTech3 = player.passiveTech3

    end

end