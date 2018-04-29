local ns2_Alien_OnCreate = Alien.OnCreate
function Alien:OnCreate()

    if Server then
        self.UpgradeManager = CombatAlienUpgradeManager()
    end

    ns2_Alien_OnCreate(self)

end