GUIPlayerResource.kPersonalTextPos = Vector(74,0,0)
GUIPlayerResource.kPresDescriptionPos = Vector(84,0,0)
GUIPlayerResource.kFontSizePresDescription = 12
GUIPlayerResource.kFontSizePersonal = 12
GUIPlayerResource.kFontSizePersonalBig = 12

-- Hide the TEAM RES
local oldUpdate = GUIPlayerResource.Update
function GUIPlayerResource:Update(...)

    oldUpdate(self, ...)

	self.teamText:SetText("")

end

-- Upgrade Points instead of RESOURCES
local oldInitialize = GUIPlayerResource.Initialize
function GUIPlayerResource:Initialize(...)

    oldInitialize(self, ...)

    self.pResDescription:SetText("Upgrade Points")

end

local ns2_GUIPlayerResource_Reset = GUIPlayerResource.Reset
function GUIPlayerResource:Reset(scale)

    ns2_GUIPlayerResource_Reset(self, scale)

    local player = Client.GetLocalPlayer()
    if player:GetTeamNumber() == kTeam1Index then
        self.background:SetUniformScale(self.scale)
        self.background:SetPosition(Vector(-380, -100, 0))
        self.background:SetSize(GUIPlayerResource.kBackgroundSize)
    end

end