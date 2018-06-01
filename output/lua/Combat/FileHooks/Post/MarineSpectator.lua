local ns2_MarineSpectator_OnCreate = MarineSpectator.OnCreate
function MarineSpectator:OnCreate()

    ns2_MarineSpectator_OnCreate(self)

    if Server then
        self.UpgradeManager = MarineUpgradeManager()
    end

end