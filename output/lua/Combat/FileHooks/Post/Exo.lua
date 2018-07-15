Script.Load("lua/Combat/Abilities/ScanAbilityMixin.lua")

local networkVarsEx = {}

AddMixinNetworkVars(ScanAbilityMixin, networkVarsEx)

local ns2_Exo_OnCreate = Exo.OnCreate
function Exo:OnCreate()

    InitMixin(self, ScanAbilityMixin)

    ns2_Exo_OnCreate(self)

end

-- function Exo:GetCanEject()
--     return false
-- end

if Server then

    -- Had to copy because the new marine player is local
    function Exo:PerformEject()
    
        if self:GetIsAlive() then
        
            -- pickupable version
            local exosuit = CreateEntity(Exosuit.kMapName, self:GetOrigin(), self:GetTeamNumber())
            exosuit:SetLayout(self.layout)
            exosuit:SetCoords(self:GetCoords())
            exosuit:SetMaxArmor(self:GetMaxArmor())
            exosuit:SetArmor(self:GetArmor())
            exosuit:SetExoVariant(self:GetExoVariant())
            exosuit:SetFlashlightOn(self:GetFlashlightOn())
            exosuit:TransferParasite(self)
            
        
            -- Player always reverts to a marine from an exo because class
            -- upgrades are mutually exclusive. (Ex. Jetpack Marine gives up their jp
            -- to become an Exo)
            local marine = self:Replace(Marine.kMapName, self:GetTeamNumber(), false, self:GetOrigin() + Vector(0, 0.2, 0), { preventWeapons = false })
            marine:SetHealth(self.prevPlayerHealth or kMarineHealth)
            marine:SetMaxArmor(self.prevPlayerMaxArmor or kMarineArmor)
            marine:SetArmor(self.prevPlayerArmor or kMarineArmor)
            
            exosuit:SetOwner(marine)
            
            marine.onGround = false
            local initialVelocity = self:GetViewCoords().zAxis
            initialVelocity:Scale(4)
            initialVelocity.y = math.max(0,initialVelocity.y) + 9
            marine:SetVelocity(initialVelocity)

            -- Give the marine their upgrades back
            marine:GetTeam():GetUpgradeHelper():ApplyAllUpgrades(marine, true)

            marine:SetHUDSlotActive(1)
        
        end
    
        return false
    
    end

    local ns2_Exo_CopyPlayerDataFrom = Exo.CopyPlayerDataFrom
    function Exo:CopyPlayerDataFrom(player)

        ns2_Exo_CopyPlayerDataFrom(self, player)

        -- Player always reverts to a marine from an exo because class
        -- upgrades are mutually exclusive. (Ex. Jetpack Marine gives up their jp
        -- to become an Exo)
        if player:isa("Marine") then
            self.prevPlayerMapName = Marine.kMapName
        end

    end

end

Shared.LinkClassToMap("Exo", Exo.kMapName, networkVarsEx, true)
