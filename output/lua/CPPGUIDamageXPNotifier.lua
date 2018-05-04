--[[
 * Natural Selection 2 - Combat++ Mod
 * Authors:
 *          WhiteWizard
 *
 * Pop up XP gain when the user is damaging an object.
]]

class 'GUIDamageXPNotifier'

GUIDamageXPNotifier.kDamageXPDisplayFontName = Fonts.kAgencyFB_Small
GUIDamageXPNotifier.kDamageXPDisplayTextColor = Color(0.75, 0.75, 0.1, 1)

GUIDamageXPNotifier.kDamageXPDisplayFontHeight = 60
GUIDamageXPNotifier.kDamageXPDisplayMinFontHeight = 40

GUIDamageXPNotifier.kDamageXPDisplayPopTimer = 0.15
GUIDamageXPNotifier.kDamageXPDisplayFadeoutTimer = 2

GUIDamageXPNotifier.kStartingPosition = GUIScale(Vector(0, GUINotifications.kScoreDisplayYOffset, 0))

function CreateDamageXPNotifier()

    local dmgXPNotifier = GUIDamageXPNotifier()
    dmgXPNotifier:Initialize()

    return dmgXPNotifier

end

function GUIDamageXPNotifier:OnResolutionChanged(oldX, oldY, newX, newY)
    self:Uninitialize()
    self:Initialize()
end

function GUIDamageXPNotifier:Initialize()

    self.dmgXPDisplay = GUIManager:CreateTextItem()
    self.dmgXPDisplay:SetFontName(GUIDamageXPNotifier.kDamageXPDisplayFontName)
    self.dmgXPDisplay:SetScale(GetScaledVector())
    self.dmgXPDisplay:SetAnchor(GUIItem.Middle, GUIItem.Center)
    self.dmgXPDisplay:SetTextAlignmentX(GUIItem.Align_Center)
    self.dmgXPDisplay:SetTextAlignmentY(GUIItem.Align_Center)
    self.dmgXPDisplay:SetColor(GUIDamageXPNotifier.kDamageXPDisplayTextColor)
    self.dmgXPDisplay:SetIsVisible(false)

    self.dmgXPDisplayPopupTime = 0
    self.dmgXPDisplayPopdownTime = 0
    self.dmgXPDisplayFadeoutTime = 0
    self.xp = 0

    self.timeLastUsed = 0

    self.visible = true

end

function GUIDamageXPNotifier:Uninitialize()

    GUI.DestroyItem(self.dmgXPDisplay)
    self.dmgXPDisplay = nil

end

function GUIDamageXPNotifier:SetIsVisible(state)
    self.visible = state
    self.dmgXPDisplay:SetIsVisible(state)
    self:Update(0)
end

local function GetRandomDamageNotificationOffset()

    local theta = math.random() * (2 * math.pi)
    local x = GUIDamageXPNotifier.kStartingPosition.x + kDamageXPIndicatorOffset * math.cos(theta)
    local y = GUIDamageXPNotifier.kStartingPosition.y + kDamageXPIndicatorOffset * math.sin(theta)

    return Vector(x, y, 0)

end

function GUIDamageXPNotifier:SetDisplayXP(xp)

    self.dmgXPDisplay:SetText(string.format("+%s XP", xp))
    self.dmgXPDisplay:SetPosition(GetRandomDamageNotificationOffset())
    self.dmgXPDisplay:SetIsVisible(self.visible)

    -- reset animation
    self.dmgXPDisplayPopupTime = GUIDamageXPNotifier.kDamageXPDisplayPopTimer
    self.dmgXPDisplayPopdownTime = 0
    self.dmgXPDisplayFadeoutTime = 0

    self.timeLastUsed = Shared.GetTime()

end

function GUIDamageXPNotifier:Update(deltaTime)

    PROFILE("GUIDamageXPNotifier:Update")
    self.updateInterval = kUpdateIntervalFull

    if self.dmgXPDisplayFadeoutTime > 0 then
        self.dmgXPDisplayFadeoutTime = math.max(0, self.dmgXPDisplayFadeoutTime - deltaTime)
        local fadeRate = 1 - (self.dmgXPDisplayFadeoutTime / GUIDamageXPNotifier.kDamageXPDisplayFadeoutTimer)
        local fadeColor = self.dmgXPDisplay:GetColor()
        fadeColor.a = 1
        fadeColor.a = fadeColor.a - (fadeColor.a * fadeRate)
        self.dmgXPDisplay:SetColor(fadeColor)
        if self.dmgXPDisplayFadeoutTime == 0 then
            self.dmgXPDisplay:SetIsVisible(false)
        end

    end

    if self.dmgXPDisplayPopdownTime > 0 then
        self.dmgXPDisplayPopdownTime = math.max(0, self.dmgXPDisplayPopdownTime - deltaTime)
        local popRate = self.dmgXPDisplayPopdownTime / GUIDamageXPNotifier.kDamageXPDisplayPopTimer
        local fontSize = GUIDamageXPNotifier.kDamageXPDisplayMinFontHeight + ((GUIDamageXPNotifier.kDamageXPDisplayFontHeight - GUIDamageXPNotifier.kDamageXPDisplayMinFontHeight) * popRate)
        local scale = GUIScale(fontSize / GUIDamageXPNotifier.kDamageXPDisplayFontHeight)
        self.dmgXPDisplay:SetScale(Vector(scale, scale, scale))
        if self.dmgXPDisplayPopdownTime == 0 then
            self.dmgXPDisplayFadeoutTime = GUIDamageXPNotifier.kDamageXPDisplayFadeoutTimer
        end

    end

    if self.dmgXPDisplayPopupTime > 0 then
        self.dmgXPDisplayPopupTime = math.max(0, self.dmgXPDisplayPopupTime - deltaTime)
        local popRate = 1 - (self.dmgXPDisplayPopupTime / GUIDamageXPNotifier.kDamageXPDisplayPopTimer)
        local fontSize = GUIDamageXPNotifier.kDamageXPDisplayMinFontHeight + ((GUIDamageXPNotifier.kDamageXPDisplayFontHeight - GUIDamageXPNotifier.kDamageXPDisplayMinFontHeight) * popRate)
        local scale = GUIScale(fontSize / GUIDamageXPNotifier.kDamageXPDisplayFontHeight)
        self.dmgXPDisplay:SetScale(Vector(scale, scale, scale))
        if self.dmgXPDisplayPopupTime == 0 then
            self.dmgXPDisplayPopdownTime = GUIDamageXPNotifier.kDamageXPDisplayPopTimer
        end

    end

end
