local networkVarsEx =
{
    purchasedPistol = "boolean",
    purchasedWelder = "boolean"
}

local ns2_Marine_OnInitialized = Marine.OnInitialized
function Marine:OnInitialized()

    ns2_Marine_OnInitialized(self)

    self.purchasedPistol = false
    self.purchasedWelder = false

end

Shared.LinkClassToMap("Marine", Marine.kMapName, networkVarsEx, true)
