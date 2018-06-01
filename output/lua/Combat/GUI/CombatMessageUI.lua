Script.Load("lua/GUIAnimatedScript.lua")

class 'CombatMessageUI' (GUIAnimatedScript)

CombatMessageUI.kXpDisplayPopTimer = 0.1
CombatMessageUI.kXpDisplayFadeoutTimer = 2
CombatMessageUI.kXpDisplayFontHeight = 100
CombatMessageUI.kXpDisplayMinFontHeight = 80
CombatMessageUI.kMessageTimer = 1.4
CombatMessageUI.kTimeToDisplayFinalAccumulatedValue = 1.25

local kAccumulatingSourceTypes = { [kXPSourceType.Damage] = true, [kXPSourceType.Weld] = true, [kXPSourceType.Heal] = true }

function CombatMessageUI:OnResolutionChanged(oldX, oldY, newX, newY)
    self:Uninitialize()
    self:Initialize()
end

function CombatMessageUI:Initialize()

    GUIAnimatedScript.Initialize(self)

    self.xpDisplayPopupTime = 0
    self.xpDisplayPopdownTime = 0
    self.xpDisplayFadeoutTime = 0
    self.timeInQueue = 0
    self.isAnimating = false
    self.xpSinceReset = 0
    self.visible = true
    self.lastQueueIndex = 0

    self.textColor = ConditionalValue(PlayerUI_GetTeamType() == kAlienTeamType, kAlienFontColor, Color(0.2, 0.71, 0.86, 1))

    self.xpDisplay = GUIManager:CreateTextItem()
    self.xpDisplay:SetFontName(Fonts.kAgencyFB_Medium)
    self.xpDisplay:SetScale(GetScaledVector())
    self.xpDisplay:SetAnchor(GUIItem.Right, GUIItem.Bottom)
    self.xpDisplay:SetPosition(GUIScale(Vector(-425, -480, 0)))
    self.xpDisplay:SetTextAlignmentX(GUIItem.Align_Center)
    self.xpDisplay:SetTextAlignmentY(GUIItem.Align_Min)
    self.xpDisplay:SetColor(self.textColor)
    self.xpDisplay:SetIsVisible(false)

    self.messages = {}
    self.accumulatedValues = {}

    for i = 1, 8 do

        local textItem = GUIManager:CreateTextItem()
        textItem:SetFontName(Fonts.kAgencyFB_Small)
        textItem:SetScale(GetScaledVector())
        GUIMakeFontScale(textItem)
        textItem:SetAnchor(GUIItem.Right, GUIItem.Bottom)
        textItem:SetPosition(GUIScale(Vector(-365, -480 + ((i-1) * 15), 0)))
        textItem:SetTextAlignmentX(GUIItem.Align_Min)
        textItem:SetTextAlignmentY(GUIItem.Align_Min)
        textItem:SetColor(self.textColor)
        textItem:SetScale(Vector(0.7, 0.7, 0.7))
        textItem:SetIsVisible(false)

        self.messages[i] = { TextItem = textItem, Xp = 0, Source = nil }

    end

    -- create a table that stores accumulated values for accumulating xp source types
    self.accumulatedValues[kXPSourceType.Damage] = { Xp = 0, TimeLastAccumulated = 0 }
    self.accumulatedValues[kXPSourceType.Weld] = { Xp = 0, TimeLastAccumulated = 0 }
    self.accumulatedValues[kXPSourceType.Heal] = { Xp = 0, TimeLastAccumulated = 0 }

end

function CombatMessageUI:Uninitialize()

    GUI.DestroyItem(self.xpDisplay)
    self.xpDisplay = nil

    for i = 1, 8 do
        GUI.DestroyItem(self.messages[i].TextItem)
        self.messages[i].TextItem = nil
    end

    GUIAnimatedScript.Uninitialize(self)
    
end

function CombatMessageUI:SetIsVisible(state)
    
    self.visible = state
    self:Update(0)
    
end

function CombatMessageUI:GetIsVisible()
    
    return self.visible
    
end

function CombatMessageUI:ResetAnimationSequence()

    -- Restart the animation sequence.
    self.xpDisplayPopupTime = CombatMessageUI.kXpDisplayPopTimer
    self.xpDisplay:SetColor(self.textColor)
    self.isAnimating = true
    self.xpDisplayPopdownTime = 0
    self.xpDisplayFadeoutTime = 0

end

function CombatMessageUI:AddMessageToQueue(xp, source)

    if self.lastQueueIndex == 0 then
        self.timeInQueue = 0
    end
    
    self.lastQueueIndex = self.lastQueueIndex + 1
    self.messages[self.lastQueueIndex].Xp = xp
    self.messages[self.lastQueueIndex].Source = source
    self.messages[self.lastQueueIndex].TextItem:SetIsVisible(self.visible)
    self.messages[self.lastQueueIndex].TextItem:SetText(CombatPlusPlus_GetDisplayNameForXpSourceType(source))

end

function CombatMessageUI:UpdateXpDisplay(deltaTime, xp)

    if self.xpDisplayFadeoutTime > 0 then

        self.isAnimating = false
        self.xpDisplayFadeoutTime = math.max(0, self.xpDisplayFadeoutTime - deltaTime)
        local fadeRate = 1 - (self.xpDisplayFadeoutTime / CombatMessageUI.kXpDisplayFadeoutTimer)
        local fadeColor = self.xpDisplay:GetColor()
        fadeColor.a = 1
        fadeColor.a = fadeColor.a - (fadeColor.a * fadeRate)
        self.xpDisplay:SetColor(fadeColor)
        if self.xpDisplayFadeoutTime == 0 then
            self.xpDisplay:SetIsVisible(false)
            self.xpSinceReset = 0
        end

    end

    if self.xpDisplayPopdownTime > 0 then

        self.xpDisplayPopdownTime = math.max(0, self.xpDisplayPopdownTime - deltaTime)
        local popRate = self.xpDisplayPopdownTime / CombatMessageUI.kXpDisplayPopTimer
        local fontSize = CombatMessageUI.kXpDisplayMinFontHeight + ((CombatMessageUI.kXpDisplayFontHeight - CombatMessageUI.kXpDisplayMinFontHeight) * popRate)
        local scale = GUIScale(fontSize / CombatMessageUI.kXpDisplayFontHeight)
        self.xpDisplay:SetScale(Vector(scale, scale, scale))

    end

    if self.xpDisplayPopupTime > 0 then

        self.xpDisplayPopupTime = math.max(0, self.xpDisplayPopupTime - deltaTime)
        local popRate = 1 - (self.xpDisplayPopupTime / CombatMessageUI.kXpDisplayPopTimer)
        local fontSize = CombatMessageUI.kXpDisplayMinFontHeight + ((CombatMessageUI.kXpDisplayFontHeight - CombatMessageUI.kXpDisplayMinFontHeight) * popRate)
        local scale = GUIScale(fontSize / CombatMessageUI.kXpDisplayFontHeight)
        self.xpDisplay:SetScale(Vector(scale, scale, scale))
        if self.xpDisplayPopupTime == 0 then
            self.xpDisplayPopdownTime = CombatMessageUI.kXpDisplayPopTimer
        end

    end

    if self.lastQueueIndex == 0 and self.xpDisplayFadeoutTime == 0 then
        self.xpDisplayFadeoutTime = CombatMessageUI.kXpDisplayFadeoutTimer
    end

    if xp > 0 then

        if not self.isAnimating then
            -- Restart the animation sequence.
            self:ResetAnimationSequence()
        end

        self.xpSinceReset = self.xpSinceReset + xp

        self.xpDisplay:SetText(string.format("+%s XP", self.xpSinceReset))
        self.xpDisplay:SetScale(GUIScale(Vector(0.7, 0.7, 0.7)))
        self.xpDisplay:SetIsVisible(self.visible)

    end

end

function CombatMessageUI:UpdateMessageDisplay(deltaTime)

    -- update the timer
    self.timeInQueue = self.timeInQueue + deltaTime
    
    -- check to see if the timer has expired
    if self.timeInQueue > CombatMessageUI.kMessageTimer then
        
        -- shift the messages
        if self.lastQueueIndex == 1 then

            self.messages[self.lastQueueIndex].Xp = 0
            self.messages[self.lastQueueIndex].Source = nil
            self.messages[self.lastQueueIndex].TextItem:SetIsVisible(false)
            self.xpDisplayFadeoutTime = CombatMessageUI.kXpDisplayFadeoutTimer

            self.lastQueueIndex = self.lastQueueIndex - 1
            self.timeInQueue = 0

        elseif self.lastQueueIndex > 1 then

            -- shift message up
            self.messages[self.lastQueueIndex - 1].Xp = self.messages[self.lastQueueIndex].Xp
            self.messages[self.lastQueueIndex - 1].Source = self.messages[self.lastQueueIndex].Source
            self.messages[self.lastQueueIndex - 1].TextItem:SetText(self.messages[self.lastQueueIndex].TextItem:GetText())

            -- reset messages thats no longer used
            self.messages[self.lastQueueIndex].Xp = 0
            self.messages[self.lastQueueIndex].Source = nil
            self.messages[self.lastQueueIndex].TextItem:SetIsVisible(false)

            self.lastQueueIndex = self.lastQueueIndex - 1
            self.timeInQueue = 0

        end

    end

end

function CombatMessageUI:UpdateAccumulatedValues(deltaTime)

    local timeLastDamage = self.accumulatedValues[kXPSourceType.Damage].TimeLastAccumulated
    local timeLastWeld = self.accumulatedValues[kXPSourceType.Weld].TimeLastAccumulated
    local timeLastHeal = self.accumulatedValues[kXPSourceType.Heal].TimeLastAccumulated

    if timeLastDamage ~= 0 and (Shared.GetTime() - timeLastDamage) >= CombatMessageUI.kTimeToDisplayFinalAccumulatedValue then
        self:AddMessageToQueue(self.accumulatedValues[kXPSourceType.Damage].Xp, kXPSourceType.Damage)
        self.accumulatedValues[kXPSourceType.Damage].TimeLastAccumulated = 0
    end

    if timeLastWeld ~= 0 and (Shared.GetTime() - timeLastWeld) >= CombatMessageUI.kTimeToDisplayFinalAccumulatedValue then
        self:AddMessageToQueue(self.accumulatedValues[kXPSourceType.Weld].Xp, kXPSourceType.Weld)
        self.accumulatedValues[kXPSourceType.Weld].TimeLastAccumulated = 0
    end

    if timeLastHeal ~= 0 and (Shared.GetTime() - timeLastHeal) >= CombatMessageUI.kTimeToDisplayFinalAccumulatedValue then
        self:AddMessageToQueue(self.accumulatedValues[kXPSourceType.Heal].Xp, kXPSourceType.Heal)
        self.accumulatedValues[kXPSourceType.Heal].TimeLastAccumulated = 0
    end

end

function CombatMessageUI:Update(deltaTime)

    PROFILE("CombatMessageUI:Update")
    
    GUIAnimatedScript.Update(self, deltaTime)

    self:UpdateMessageDisplay(deltaTime)

    local queuedMessages = CombatXpMsgUI_GetMessages()
    local xp = 0

    for _, msg in ipairs(queuedMessages) do

        xp = xp + msg.xp

        if kAccumulatingSourceTypes[msg.source] then

            self.accumulatedValues[msg.source].Xp = self.accumulatedValues[msg.source].Xp + msg.xp
            self.accumulatedValues[msg.source].TimeLastAccumulated = Shared.GetTime()

        else

            self:AddMessageToQueue(msg.xp, msg.source)

        end

    end

    self:UpdateXpDisplay(deltaTime, xp)
    self:UpdateAccumulatedValues(deltaTime)

end