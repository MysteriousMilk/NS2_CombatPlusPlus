Script.Load("lua/CPPGUIDamageXPNotifier.lua")

GUINotifications.kScoreDisplayFontNameLarge = Fonts.kAgencyFB_Large
GUINotifications.kScoreDisplayKillTextColor = Color(52/255, 180/255, 219/255, 1)
GUINotifications.kScoreDisplayFontHeight = 80
GUINotifications.kScoreDisplayMinFontHeight = 60
GUINotifications.kScoreDisplayFadeoutTimer = 3

GUINotifications.kScoreDisplayFontHeightDmg = 60
GUINotifications.kScoreDisplayMinFontHeightDmg = 40

local ns2_GUINotifications_Initialize = GUINotifications.Initialize
function GUINotifications:Initialize()

    self.damageXPNotifiers =
    {
        CreateDamageXPNotifier(),
        CreateDamageXPNotifier(),
        CreateDamageXPNotifier(),
        CreateDamageXPNotifier(),
        CreateDamageXPNotifier(),
        CreateDamageXPNotifier()
    }

    self.isAnimating = false
    self.xpSinceReset = 0

    ns2_GUINotifications_Initialize(self)

end

local ns2_GUINotifications_Uninitialize = GUINotifications.Uninitialize
function GUINotifications:Uninitialize()

    for index, value in pairs(self.damageXPNotifiers) do
        value:Uninitialize()
    end

    ns2_GUINotifications_Uninitialize(self)

end

local function GetAvailableDmgXPNotifier(self)

    local dmgXPNotifier = nil

    for index, value in pairs(self.damageXPNotifiers) do

        if value.isAvailable then
            dmgXPNotifier = value
            break
        end

    end

end

local function GetRandomDamageNotificationOffset(location)

    local theta = math.random() * (2 * math.pi)
    local x = location.x + kDamageXPIndicatorOffset * math.cos(theta)
    local y = location.y + kDamageXPIndicatorOffset * math.sin(theta)

    return Vector(x, y, 0)

end

local function UpdateCombatScoreDisplay(self, deltaTime)

    PROFILE("GUINotifications:UpdateScoreDisplay")
    self.updateInterval = kUpdateIntervalFull

    if self.scoreDisplayFadeoutTime > 0 then
        self.scoreDisplayFadeoutTime = math.max(0, self.scoreDisplayFadeoutTime - deltaTime)
        local fadeRate = 1 - (self.scoreDisplayFadeoutTime / GUINotifications.kScoreDisplayFadeoutTimer)
        local fadeColor = self.scoreDisplay:GetColor()
        fadeColor.a = 1
        fadeColor.a = fadeColor.a - (fadeColor.a * fadeRate)
        self.scoreDisplay:SetColor(fadeColor)
        if self.scoreDisplayFadeoutTime == 0 then
            self.scoreDisplay:SetIsVisible(false)
            self.isAnimating = false
        end

    end

    if self.scoreDisplayPopdownTime > 0 then
        self.scoreDisplayPopdownTime = math.max(0, self.scoreDisplayPopdownTime - deltaTime)
        local popRate = self.scoreDisplayPopdownTime / GUINotifications.kScoreDisplayPopTimer
        local fontSize = GUINotifications.kScoreDisplayMinFontHeight + ((GUINotifications.kScoreDisplayFontHeight - GUINotifications.kScoreDisplayMinFontHeight) * popRate)
        local scale = GUIScale(fontSize / GUINotifications.kScoreDisplayFontHeight)
        self.scoreDisplay:SetScale(Vector(scale, scale, scale))
        if self.scoreDisplayPopdownTime == 0 then
            self.scoreDisplayFadeoutTime = GUINotifications.kScoreDisplayFadeoutTimer
        end

    end

    if self.scoreDisplayPopupTime > 0 then
        self.scoreDisplayPopupTime = math.max(0, self.scoreDisplayPopupTime - deltaTime)
        local popRate = 1 - (self.scoreDisplayPopupTime / GUINotifications.kScoreDisplayPopTimer)
        local fontSize = GUINotifications.kScoreDisplayMinFontHeight + ((GUINotifications.kScoreDisplayFontHeight - GUINotifications.kScoreDisplayMinFontHeight) * popRate)
        local scale = GUIScale(fontSize / GUINotifications.kScoreDisplayFontHeight)
        self.scoreDisplay:SetScale(Vector(scale, scale, scale))
        if self.scoreDisplayPopupTime == 0 then
            self.scoreDisplayPopdownTime = GUINotifications.kScoreDisplayPopTimer
        end

    end

    local xp, source, targetId = CombatScoreDisplayUI_GetNewXPAward()

    if xp > 0 then

        if self.isAnimating ~= true then

            -- Restart the animation sequence.
            self.scoreDisplayPopupTime = GUINotifications.kScoreDisplayPopTimer
            self.isAnimating = true
            self.scoreDisplayPopdownTime = 0
            self.scoreDisplayFadeoutTime = 0
            self.xpSinceReset = 0

        end

        self.xpSinceReset = self.xpSinceReset + xp

        -- earned more xp while numbers are on screen.. keep them there
        if self.scoreDisplayPopupTime == 0 then
            self.scoreDisplayPopdownTime = GUINotifications.kScoreDisplayPopTimer
        end

        if source == kXPSourceType.damage then
            self.scoreDisplay:SetColor(GUINotifications.kScoreDisplayTextColor)
        else
            self.scoreDisplay:SetColor(GUINotifications.kScoreDisplayKillTextColor)
        end

        self.scoreDisplay:SetText(string.format("+%s XP", self.xpSinceReset))
        self.scoreDisplay:SetScale(GUIScale(Vector(0.5, 0.5, 0.5)))
        self.scoreDisplay:SetIsVisible(self.visible)

    end

end

function GUINotifications:Update(deltaTime)

    PROFILE("GUINotifications:Update")

    GUIAnimatedScript.Update(self, deltaTime)

    -- The commander has their own location text.
    if PlayerUI_IsACommander() or PlayerUI_IsOnMarineTeam() then
        self.locationText:SetIsVisible(false)
    else
        self.locationText:SetIsVisible(self.visible)
        self.locationText:SetText(PlayerUI_GetLocationName())
    end

    UpdateCombatScoreDisplay(self, deltaTime)

    for index, value in pairs(self.damageXPNotifiers) do
        value:Update(deltaTime)
    end

end
