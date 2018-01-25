Script.Load("lua/CPPGUIDamageXPNotifier.lua")

GUINotifications.kScoreDisplayFontNameLarge = Fonts.kAgencyFB_Large
GUINotifications.kScoreDisplayPrimaryTextColor = Color(0.2, 0.71, 0.86, 1)
GUINotifications.kScoreDisplayBuildTextColor = Color(0, 1, 0, 1)
GUINotifications.kScoreDisplayWeldTextColor = Color(0.73, 0.22, 0.84, 1)
GUINotifications.kScoreDisplayHealTextColor = Color(0.84, 0.18, 0.49, 1)
GUINotifications.kScoreDisplayFontHeight = 100
GUINotifications.kScoreDisplayMinFontHeight = 80
GUINotifications.kScoreDisplayPopTimer = 0.35
GUINotifications.kScoreDisplayFadeoutTimer = 3

GUINotifications.kScoreDisplayFontHeightDmg = 60
GUINotifications.kScoreDisplayMinFontHeightDmg = 40

GUINotifications.kTimeToDisplayFinalAccumulatedValue = 2

local kResetSourceTypes = { [kXPSourceType.Kill] = true, [kXPSourceType.Assist] = true, [kXPSourceType.Build] = true }
local kAccumulatingSourceTypes = { [kXPSourceType.Weld] = true, [kXPSourceType.Heal] = true }

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
    self.lastSourceType = kXPSourceType.Kill
    self.timeLastAccumulated = 0

    ns2_GUINotifications_Initialize(self)

end

local ns2_GUINotifications_Uninitialize = GUINotifications.Uninitialize
function GUINotifications:Uninitialize()

    for index, value in pairs(self.damageXPNotifiers) do
        value:Uninitialize()
    end

    ns2_GUINotifications_Uninitialize(self)

end

function GUINotifications:GetAvailableDmgXPNotifier()

    local dmgXPNotifier = nil

    for index, value in ipairs(self.damageXPNotifiers) do

        if dmgXPNotifier == nil then
            dmgXPNotifier = value
        elseif value.timeLastUsed <  dmgXPNotifier.timeLastUsed then
            dmgXPNotifier = value
        end

    end

    return dmgXPNotifier

end

function GUINotifications:UpdateCombatScoreDisplay(deltaTime)

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

        if source == kXPSourceType.Damage then

            self:GetAvailableDmgXPNotifier():SetDisplayXP(xp)

        else

            if self.isAnimating ~= true then
                -- Restart the animation sequence.
                self:ResetAnimationSequence()
            end

            -- We want to see the the exact xp for certain source types (not accumulated)
            if kResetSourceTypes[source] or kResetSourceTypes[self.lastSourceType] then
                self:ResetAnimationSequence()
            end

            if kAccumulatingSourceTypes[source] then

                self.xpSinceReset = self.xpSinceReset + xp

                self.timeLastAccumulated = Shared.GetTime()

                -- earned more xp while numbers are on screen.. keep them there
                if self.scoreDisplayPopupTime == 0 then
                    self.scoreDisplayPopdownTime = GUINotifications.kScoreDisplayPopTimer
                end

            else

                self.xpSinceReset = xp

            end

            self.scoreDisplay:SetColor(GUINotifications.kScoreDisplayPrimaryTextColor)
            self.scoreDisplay:SetText(string.format("+%s XP", self.xpSinceReset))

            if source == kXPSourceType.Damage then
                self.scoreDisplay:SetColor(GUINotifications.kScoreDisplayTextColor)
                self.scoreDisplay:SetText(string.format("+%s XP", self.xpSinceReset))
            elseif source == kXPSourceType.Weld then
                self.scoreDisplay:SetColor(GUINotifications.kScoreDisplayWeldTextColor)
                self.scoreDisplay:SetText(string.format("+%s XP", self.xpSinceReset))
            elseif source == kXPSourceType.Heal then
                self.scoreDisplay:SetColor(GUINotifications.kScoreDisplayHealTextColor)
                self.scoreDisplay:SetText(string.format("+%s XP", self.xpSinceReset))
            elseif source == kXPSourceType.Build then
                self.scoreDisplay:SetColor(GUINotifications.kScoreDisplayBuildTextColor)
                self.scoreDisplay:SetText(string.format("Built Structure +%s XP", self.xpSinceReset))
            elseif source == kXPSourceType.Kill then
                self.scoreDisplay:SetColor(GUINotifications.kScoreDisplayPrimaryTextColor)
                self.scoreDisplay:SetText(string.format("Kill +%s XP", self.xpSinceReset))
            elseif source == kXPSourceType.Assist then
                self.scoreDisplay:SetColor(GUINotifications.kScoreDisplayPrimaryTextColor)
                self.scoreDisplay:SetText(string.format("Assist +%s XP", self.xpSinceReset))
            end

            self.scoreDisplay:SetScale(GUIScale(Vector(0.7, 0.7, 0.7)))
            self.scoreDisplay:SetIsVisible(self.visible)

            self.lastSourceType = source

        end

    elseif kAccumulatingSourceTypes[self.lastSourceType] and self.timeLastAccumulated ~= 0 and (Shared.GetTime() - self.timeLastAccumulated) >= GUINotifications.kTimeToDisplayFinalAccumulatedValue then

        local totalXp = self.xpSinceReset

        self:ResetAnimationSequence()

        if self.lastSourceType == kXPSourceType.Weld then
            self.scoreDisplay:SetColor(GUINotifications.kScoreDisplayPrimaryTextColor)
            self.scoreDisplay:SetText(string.format("Welded Target +%s XP", totalXp))
        elseif self.lastSourceType == kXPSourceType.Heal then
            self.scoreDisplay:SetColor(GUINotifications.kScoreDisplayPrimaryTextColor)
            self.scoreDisplay:SetText(string.format("Healed Target +%s XP", totalXp))
        end

        self.scoreDisplay:SetScale(GUIScale(Vector(0.7, 0.7, 0.7)))
        self.scoreDisplay:SetIsVisible(self.visible)

        self.timeLastAccumulated = 0

    end

end

function GUINotifications:ResetAnimationSequence()

    -- Restart the animation sequence.
    self.scoreDisplayPopupTime = GUINotifications.kScoreDisplayPopTimer
    self.isAnimating = true
    self.scoreDisplayPopdownTime = 0
    self.scoreDisplayFadeoutTime = 0
    self.xpSinceReset = 0

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

    self:UpdateCombatScoreDisplay(deltaTime)

    for index, value in ipairs(self.damageXPNotifiers) do
        value:Update(deltaTime)
    end

end
