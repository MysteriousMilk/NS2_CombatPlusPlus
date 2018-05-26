local ns2_Marine_CopyPlayerDataFrom = Marine.CopyPlayerDataFrom
function Marine:CopyPlayerDataFrom(player)

    ns2_Marine_CopyPlayerDataFrom(self, player)

    local playerInRR = player:GetTeamNumber() == kNeutralTeamType

    if not playerInRR and GetGamerules():GetGameStarted() then

        self.armorLevel = player.armorLevel
        self.weaponLevel = player.weaponLevel

    end

end

function Marine:InitWeapons()

    Player.InitWeapons(self)

    self:GiveItem(Rifle.kMapName)
    self:GiveItem(Axe.kMapName)
    self:GiveItem(Builder.kMapName)

    self:SetQuickSwitchTarget(Axe.kMapName)
    self:SetActiveWeapon(Rifle.kMapName)

end

local ns2_Marine_OnKill = Marine.OnKill
function Marine:OnKill(attacker, doer, point, direction)

    -- put builder back into build mode
    builder = self:GetWeapon(Builder.kMapName)
    builder:SetBuilderMode(kBuilderMode.Build)

    self:DestroyWeapons()

    ns2_Marine_OnKill(self, attacker, doer, point, direction)

end
