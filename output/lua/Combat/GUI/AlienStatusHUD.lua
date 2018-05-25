Script.Load("lua/Globals.lua")
Script.Load("lua/GUIUtility.lua")
Script.Load("lua/Hud/Alien/GUIAlienHUDStyle.lua")
Script.Load("lua/GUIAnimatedScript.lua")

class 'AlienStatusHUD' (GUIAnimatedScript)

AlienStatusHUD.kXpBarBkgTexture = PrecacheAsset("ui/combatui_alien_xpbar_bkg.dds")
AlienStatusHUD.kXpBarOverlayTexture = PrecacheAsset("ui/combatui_alien_xpbar_overlay.dds")

AlienStatusHUD.kXPBarSize = Vector(600, 24, 0)
AlienStatusHUD.kXPBarSizeScaled = Vector(600, 24, 0)
AlienStatusHUD.kXpBarColor = Color(1, 1, 1, 0.6)

AlienStatusHUD.kAnimSpeedDown = 0.2
AlienStatusHUD.kAnimSpeedUp = 0.5

AlienStatusHUD.kXPFontName = Fonts.kArial_13
AlienStatusHUD.kXPTextPosition = Vector(0, -128, 0)

AlienStatusHUD.kRankFontName = Fonts.kStamp_Medium
AlienStatusHUD.kRankTextPosition = Vector(0, -154, 0)

AlienStatusHUD.kUpgradePointIconTexture = PrecacheAsset("ui/alien_HUD_presicon.dds")
AlienStatusHUD.kUpgradePointIconPixelCoords = { 6, 25, 26, 45 }
AlienStatusHUD.kUpgradePointIconSize = Vector(25, 25, 0)
AlienStatusHUD.kUpgradePointIconPos = Vector(-160, -28, 0)

AlienStatusHUD.kUpgradePointFontName = Fonts.kAgencyFB_Small
AlienStatusHUD.kUpgradePointTextPos = Vector(-130, -17, 0)

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

    self.currentRankText = GetGUIManager():CreateTextItem()
    self.currentRankText:SetFontName(AlienStatusHUD.kRankFontName)
    self.currentRankText:SetAnchor(GUIItem.Middle, GUIItem.Bottom)
    self.currentRankText:SetTextAlignmentX(GUIItem.Align_Center)
    self.currentRankText:SetTextAlignmentY(GUIItem.Align_Center)
    self.currentRankText:SetText("Rank 1")
    self.currentRankText:SetIsVisible(true)
    self.currentRankText:SetColor( kAlienFontColor )
    self.background:AddChild(self.currentRankText)

    self.upgradePointIcon = self:CreateAnimatedGraphicItem()
    self.upgradePointIcon:SetAnchor(GUIItem.Right, GUIItem.Top)
    self.upgradePointIcon:SetTexture(AlienStatusHUD.kUpgradePointIconTexture)
    self.upgradePointIcon:SetTexturePixelCoordinates(unpack(AlienStatusHUD.kUpgradePointIconPixelCoords))
    self.xpBarBackground:AddChild(self.upgradePointIcon)

    self.upgradePointText = GetGUIManager():CreateTextItem()
    self.upgradePointText:SetFontName(AlienStatusHUD.kUpgradePointFontName)
    self.upgradePointText:SetAnchor(GUIItem.Right, GUIItem.Top)
    self.upgradePointText:SetTextAlignmentX(GUIItem.Align_Min)
    self.upgradePointText:SetTextAlignmentY(GUIItem.Align_Center)
    self.upgradePointText:SetText("0 Upgrade Points")
    self.upgradePointText:SetIsVisible(true)
    self.upgradePointText:SetColor( kAlienFontColor )
    self.xpBarBackground:AddChild(self.upgradePointText)

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
    self.xpBarBackground:SetPosition( Vector(-xpBarScaledVec.x / 2, -140, 0) )

    self.xpBar:SetUniformScale(self.scale)
    self.xpBar:SetSize( xpBarScaledVec )
    self.xpBar:SetPosition( Vector(-xpBarScaledVec.x / 2, -140, 0) )

    self.currentXPText:SetScale(GetScaledVector())
    self.currentXPText:SetPosition(AlienStatusHUD.kXPTextPosition)
    self.currentXPText:SetFontName(AlienStatusHUD.kXPFontName)
    GUIMakeFontScale(self.currentXPText)

    self.currentRankText:SetScale(GetScaledVector())
    self.currentRankText:SetPosition(AlienStatusHUD.kRankTextPosition)
    self.currentRankText:SetFontName(AlienStatusHUD.kRankFontName)
    GUIMakeFontScale(self.currentRankText)

    self.upgradePointIcon:SetUniformScale(self.scale)
    self.upgradePointIcon:SetPosition(AlienStatusHUD.kUpgradePointIconPos)
    self.upgradePointIcon:SetSize(AlienStatusHUD.kUpgradePointIconSize)

    self.upgradePointText:SetScale(GetScaledVector())
    self.upgradePointText:SetPosition(AlienStatusHUD.kUpgradePointTextPos)
    self.upgradePointText:SetFontName(AlienStatusHUD.kUpgradePointFontName)
    GUIMakeFontScale(self.upgradePointText)

end

function AlienStatusHUD:Uninitialize()

    GUIAnimatedScript.Uninitialize(self)

    GUI.DestroyItem(self.currentXPText)
    self.currentXPText = nil

    GUI.DestroyItem(self.currentRankText)
    self.currentRankText = nil

    GUI.DestroyItem(self.upgradePointText)
    self.upgradePointText = nil

end

function AlienStatusHUD:UpdateVisibility()

    self.xpBarBackground:SetIsVisible(self.visible)
    self.xpBar:SetIsVisible(self.visible)
    self.currentXPText:SetIsVisible(self.visible)
    self.currentRankText:SetIsVisible(self.visible)
    self.upgradePointIcon:SetIsVisible(self.visible)
    self.upgradePointText:SetIsVisible(self.visible)

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
        self.currentRankText:SetText(string.format("Rank %s : %s", currentRank, title))

        -- update upgrade point text
        if player.combatUpgradePoints == 1 then
            self.upgradePointText:SetText(string.format("%s Upgrade Point", player.combatUpgradePoints))
        else
            self.upgradePointText:SetText(string.format("%s Upgrade Points", player.combatUpgradePoints))
        end

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
            self.xpBar:SetColor( Color(1, 1, 1, 1) )

            self.lastXP = currentXP

        end

    end

end
