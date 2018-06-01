Script.Load("lua/Globals.lua")
Script.Load("lua/GUIUtility.lua")
Script.Load("lua/Hud/Alien/GUIAlienHUDStyle.lua")
Script.Load("lua/GUIAnimatedScript.lua")

class 'AlienStatusHUD' (GUIAnimatedScript)

AlienStatusHUD.kXpBarBkgTexture = PrecacheAsset("ui/combatui_alien_xpbar_bkg.dds")
AlienStatusHUD.kXpBarOverlayTexture = PrecacheAsset("ui/combatui_alien_xpbar_overlay.dds")

AlienStatusHUD.kXPBarSize = Vector(600, 20, 0)
AlienStatusHUD.kXPBarSizeScaled = Vector(600, 20, 0)
AlienStatusHUD.kXpBarColor = Color(1, 1, 1, 0.6)

AlienStatusHUD.kAnimSpeedDown = 0.2
AlienStatusHUD.kAnimSpeedUp = 0.5

AlienStatusHUD.kXPFontName = Fonts.kArial_13
AlienStatusHUD.kXPTextPosition = Vector(0, -120, 0)

AlienStatusHUD.kRankFontName = Fonts.kStamp_Medium
AlienStatusHUD.kRankTextPosition = Vector(0, -146, 0)

function AlienStatusHUD:Initialize()

    GUIAnimatedScript.Initialize(self)

    self.scale = 1

    self.lastXP = 0
    self.lastRank = 1

    self.background = self:CreateAnimatedGraphicItem()
    self.background:SetPosition( Vector(0, 0, 0) )
    self.background:SetIsScaling(false)
    self.background:SetSize(Vector(Client.GetScreenWidth(), Client.GetScreenHeight(),0))
    self.background:SetIsVisible(true)
    self.background:SetLayer(kGUILayerPlayerHUDForeground1)
    self.background:SetColor( Color(1, 1, 1, 0) )

    self.xpBarBackground = self:CreateAnimatedGraphicItem()
    self.xpBarBackground:SetAnchor(GUIItem.Middle, GUIItem.Bottom)
    self.xpBarBackground:SetTexture(AlienStatusHUD.kXpBarBkgTexture)
    self.xpBarBackground:SetTexturePixelCoordinates(0, 0, 600, 32)
    self.xpBarBackground:SetColor(AlienStatusHUD.kXpBarColor)
    self.xpBarBackground:SetIsVisible(true)
    self.background:AddChild(self.xpBarBackground)

    self.xpBar = self:CreateAnimatedGraphicItem()
    self.xpBar:SetAnchor(GUIItem.Middle, GUIItem.Bottom)
    self.xpBar:SetTexture(AlienStatusHUD.kXpBarOverlayTexture)
    self.xpBar:SetTexturePixelCoordinates(0, 0, 0, 32)
    self.xpBar:SetColor(AlienStatusHUD.kXpBarColor)
    self.xpBar:SetIsVisible(true)
    self.background:AddChild(self.xpBar)

    self.currentXPText = GetGUIManager():CreateTextItem()
    self.currentXPText:SetFontName(AlienStatusHUD.kXPFontName)
    self.currentXPText:SetAnchor(GUIItem.Middle, GUIItem.Bottom)
    self.currentXPText:SetTextAlignmentX(GUIItem.Align_Center)
    self.currentXPText:SetTextAlignmentY(GUIItem.Align_Center)
    self.currentXPText:SetText("0 XP of 1000 (Rank 1)")
    self.currentXPText:SetIsVisible(true)
    self.currentXPText:SetColor( Color(0, 0, 0, 1) )
    self.background:AddChild(self.currentXPText)

    self.currentRankTextShadow = GetGUIManager():CreateTextItem()
    self.currentRankTextShadow:SetFontName(AlienStatusHUD.kRankFontName)
    self.currentRankTextShadow:SetAnchor(GUIItem.Middle, GUIItem.Bottom)
    self.currentRankTextShadow:SetTextAlignmentX(GUIItem.Align_Center)
    self.currentRankTextShadow:SetTextAlignmentY(GUIItem.Align_Center)
    self.currentRankTextShadow:SetText("Rank 1")
    self.currentRankTextShadow:SetIsVisible(true)
    self.currentRankTextShadow:SetColor( Color(0,0,0,1) )
    self.background:AddChild(self.currentRankTextShadow)

    self.currentRankText = GetGUIManager():CreateTextItem()
    self.currentRankText:SetFontName(AlienStatusHUD.kRankFontName)
    self.currentRankText:SetAnchor(GUIItem.Left, GUIItem.Top)
    self.currentRankText:SetTextAlignmentX(GUIItem.Align_Center)
    self.currentRankText:SetTextAlignmentY(GUIItem.Align_Center)
    self.currentRankText:SetText("Rank 1")
    self.currentRankText:SetIsVisible(true)
    self.currentRankText:SetColor( kAlienFontColor )
    self.currentRankText:SetPosition(Vector(-2, -2, 0))
    self.currentRankTextShadow:AddChild(self.currentRankText)

    self.visible = true
    self:UpdateVisibility()

    self:Reset(1)

end

function AlienStatusHUD:Reset(scale)

    self.scale = scale
    GUIAnimatedScript.Reset(self)

    self.background:SetSize(Vector(Client.GetScreenWidth(), Client.GetScreenHeight(),0))

    local xpBarScaledVec = Vector(GUIScaleWidth(AlienStatusHUD.kXPBarSize.x), AlienStatusHUD.kXPBarSize.y, 0)
    self.xpBarBackground:SetUniformScale(self.scale)
    self.xpBarBackground:SetSize(xpBarScaledVec)
    self.xpBarBackground:SetPosition( Vector(-xpBarScaledVec.x / 2, -132, 0) )

    self.xpBar:SetUniformScale(self.scale)
    self.xpBar:SetSize( xpBarScaledVec )
    self.xpBar:SetPosition( Vector(-xpBarScaledVec.x / 2, -132, 0) )

    self.currentXPText:SetScale(GetScaledVector())
    self.currentXPText:SetPosition(AlienStatusHUD.kXPTextPosition)
    self.currentXPText:SetFontName(AlienStatusHUD.kXPFontName)
    GUIMakeFontScale(self.currentXPText)

    self.currentRankTextShadow:SetScale(GetScaledVector())
    self.currentRankTextShadow:SetPosition(AlienStatusHUD.kRankTextPosition)
    self.currentRankTextShadow:SetFontName(AlienStatusHUD.kRankFontName)
    GUIMakeFontScale(self.currentRankTextShadow)

    self.currentRankText:SetScale(GetScaledVector())
    self.currentRankText:SetFontName(AlienStatusHUD.kRankFontName)
    GUIMakeFontScale(self.currentRankText)

end

function AlienStatusHUD:Uninitialize()

    GUIAnimatedScript.Uninitialize(self)

    GUI.DestroyItem(self.currentXPText)
    self.currentXPText = nil

    GUI.DestroyItem(self.currentRankTextShadow)
    self.currentRankTextShadow = nil

    GUI.DestroyItem(self.currentRankText)
    self.currentRankText = nil

end

function AlienStatusHUD:UpdateVisibility()

    self.xpBarBackground:SetIsVisible(self.visible)
    self.xpBar:SetIsVisible(self.visible)
    self.currentXPText:SetIsVisible(self.visible)
    self.currentRankTextShadow:SetIsVisible(self.visible)
    self.currentRankText:SetIsVisible(self.visible)

end

function AlienStatusHUD:SetIsVisible(isVisible)

    self.visible = isVisible
    self:UpdateVisibility()

end

function AlienStatusHUD:GetIsVisible()

    return self.visible

end

function AlienStatusHUD:OnResolutionChanged(oldX, oldY, newX, newY)

    self:Reset(newY / kBaseScreenHeight)

    self:Uninitialize()
    self:Initialize()

end

function AlienStatusHUD:Update(deltaTime)

    GUIAnimatedScript.Update(self, deltaTime)

    local player = Client.GetLocalPlayer()

    if player and HasMixin(player, "CombatScore") then

        local currentXP = player.combatXP
        local currentRank = player.combatRank
        local title = CombatPlusPlus_GetAlienTitleByRank(currentRank)
        local oldXPThreshold = CombatPlusPlus_GetXPThresholdByRank(currentRank)
        local newXPThreshold = 0

        if currentRank < kMaxCombatRank then
            newXPThreshold = CombatPlusPlus_GetXPThresholdByRank(currentRank + 1)
        end

        -- update rank text
        local rankText = string.format("Rank %s : %s", currentRank, title)
        self.currentRankTextShadow:SetText(rankText)
        self.currentRankText:SetText(rankText)

        -- update xp text
        if newXPThreshold == 0 then
            self.currentXPText:SetText(string.format("%s XP", currentXP))
        else
            self.currentXPText:SetText(string.format("%s XP : %s XP to Next Rank", currentXP, newXPThreshold - currentXP))
        end

        -- normalize the current xp scale
        local currentXPNorm = currentXP - oldXPThreshold
        local newXPThresholdNorm = newXPThreshold - oldXPThreshold

        if currentRank ~= self.lastRank then

            if currentRank > self.lastRank then
                self.xpBar:DestroyAnimations()
                self.xpBar:SetSize(Vector(0, AlienStatusHUD.kXPBarSizeScaled.y, 0))
                self.xpBar:SetTexturePixelCoordinates(0, 0, 0, AlienStatusHUD.kXPBarSizeScaled.y)
            end

            self.lastRank = currentRank

        end

        if currentXP ~= self.lastXP then

            local animSpeed = ConditionalValue(currentXP < self.lastXP, AlienStatusHUD.kAnimSpeedDown, AlienStatusHUD.kAnimSpeedUp)

            local xpFraction = currentXPNorm / newXPThresholdNorm
            local xpBarScaledVec = Vector(GUIScaleWidth(AlienStatusHUD.kXPBarSize.x), AlienStatusHUD.kXPBarSize.y, 0)
            local xpBarSize = Vector(xpBarScaledVec.x * xpFraction, xpBarScaledVec.y, 0)

            self.xpBar:DestroyAnimations()
            self.xpBar:SetSize(xpBarSize, animSpeed)
            self.xpBar:SetTexturePixelCoordinates(0, 0, xpBarSize.x, 32, animSpeed)

            self.lastXP = currentXP

        end

    end

end
