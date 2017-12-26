class 'GUIDamageXPNotifier'

GUIDamageXPNotifier.kDamageXPDisplayFontName = Fonts.kAgencyFB_Small
GUIDamageXPNotifier.kDamageXPDisplayTextColor = Color(0.75, 0.75, 0.1, 1)

GUIDamageXPNotifier.kDamageXPDisplayFontHeight = 60
GUIDamageXPNotifier.kDamageXPDisplayMinFontHeight = 40

GUIDamageXPNotifier.kDamageXPDisplayPopTimer = 0.15
GUIDamageXPNotifier.kDamageXPDisplayFadeoutTimer = 2

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
    self.dmgXPDisplay:SetAnchor(GUIItem.Left, GUIItem.Top)
    self.dmgXPDisplay:SetTextAlignmentX(GUIItem.Align_Center)
    self.dmgXPDisplay:SetTextAlignmentY(GUIItem.Align_Center)
    self.dmgXPDisplay:SetColor(GUIDamageXPNotifier.kDamageXPDisplayTextColor)
    self.dmgXPDisplay:SetIsVisible(false)

    self.dmgXPDisplayPopupTime = 0
    self.dmgXPDisplayPopdownTime = 0
    self.dmgXPDisplayFadeoutTime = 0
    self.isAvailable = true
    self.xp = 0

    self.visible = true

end

function GUIDamageXPNotifier:Uninitialize()

    GUI.DestroyItem(self.dmgXPDisplay)
    self.dmgXPDisplay = nil

end

function GUIDamageXPNotifier:SetIsVisible(state)
    self.visible = state
end

function GUIDamageXPNotifier:SetDisplayXP(xp, pos)

    self.dmgXPDisplay:SetText(string.format("+%s XP", xp))
    self.dmgXPDisplay:SetPosition(pos)

    -- reset animation
    self.dmgXPDisplayPopupTime = GUIDamageXPNotifier.kDamageXPDisplayPopTimer
    self.dmgXPDisplayPopdownTime = 0
    self.dmgXPDisplayFadeoutTime = 0

    self.isAvailable = false

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
            self.isAvailable = true
        end

    end

    if self.dmgXPDisplayPopdownTime > 0 then
        self.dmgXPDisplayPopdownTime = math.max(0, self.dmgXPDisplayPopdownTime - deltaTime)
        local popRate = self.dmgXPDisplayPopdownTime / GUIDamageXPNotifier.kScoreDisplayPopTimer
        local fontSize = GUIDamageXPNotifier.kDamageXPDisplayMinFontHeight + ((GUIDamageXPNotifier.kDamageXPDisplayFontHeight - GUIDamageXPNotifier.kDamageDisplayMinFontHeight) * popRate)
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
