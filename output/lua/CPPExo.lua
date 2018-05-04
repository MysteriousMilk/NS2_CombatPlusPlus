local ns2_Exo_OnCreate = Exo.OnCreate
function Exo:OnCreate()

    if Server then
        self.UpgradeManager = MarineUpgradeManager()
    end

    ns2_Exo_OnCreate(self)

end

function Exo:GetCanEject()
    return false
end
