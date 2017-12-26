Script.Load("lua/Weapons/Alien/Ability.lua")

class 'MarineDropStructureAbility' (Ability)

MarineDropStructureAbility.kMapName = "marine_drop_structure_ability"

local kAnimationGraph = PrecacheAsset("models/marine/welder/welder_view.animation_graph")

MarineDropStructureAbility.kSupportedStructures = {}

function MarineDropStructureAbility:GetAnimationGraphName()
    return kAnimationGraph
end

function MarineDropStructureAbility:GetActiveStructure()

    if self.activeStructure == nil then
        return nil
    else
        return DropStructureAbility.kSupportedStructures[self.activeStructure]
    end

end

function MarineDropStructureAbility:OnCreate()

    Ability.OnCreate(self)

    self.dropping = false
    self.mouseDown = false
    self.activeStructure = nil

    if Server then
        self.lastCreatedId = Entity.invalidId
    end

    self.lastClickedPosition = nil

end

function MarineDropStructureAbility:GetDeathIconIndex()
    return kDeathMessageIcon.Consumed
end

function MarineDropStructureAbility:SetActiveStructure(structureNum)

    self.activeStructure = structureNum
    self.lastClickedPosition = nil

end

function MarineDropStructureAbility:OnPrimaryAttack(player)

    if Client then

        if self.activeStructure ~= nil
        and not self.dropping
        and not self.mouseDown then

            self.mouseDown = true

            if self:PerformPrimaryAttack(player) then
                self.dropping = true
            end

        end

    end

end

function MarineDropStructureAbility:OnPrimaryAttackEnd(player)

    if not Shared.GetIsRunningPrediction() then

        if Client and self.dropping then
            self:OnSetActive()
        end

        self.dropping = false
        self.mouseDown = false

    end

end

function MarineDropStructureAbility:GetIsDropping()
    return self.dropping
end

function MarineDropStructureAbility:GetEnergyCost(player)
    return 0
end

function MarineDropStructureAbility:GetHUDSlot()
    return kNoWeaponSlot
end
