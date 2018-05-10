local ns2_AlienSpectator_OnCreate = AlienSpectator.OnCreate
function AlienSpectator:OnCreate()

    ns2_AlienSpectator_OnCreate(self)

    if Server then
        self.UpgradeManager = CombatAlienUpgradeManager()
    end

end