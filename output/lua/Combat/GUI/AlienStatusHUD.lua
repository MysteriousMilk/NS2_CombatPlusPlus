Script.Load("lua/Globals.lua")
Script.Load("lua/GUIUtility.lua")
Script.Load("lua/Hud/Alien/GUIAlienHUDStyle.lua")
Script.Load("lua/GUIAnimatedScript.lua")

class 'AlienStatusHUD' (GUIAnimatedScript)

AlienStatusHUD.kXpBarBkgTexture = PrecacheAsset("ui/combatui_alien_xpbar_bkg.dds")
AlienStatusHUD.kXpBarOverlayTexture = PrecacheAsset("ui/combatui_alien_xpbar_overlay.dds")

AlienStatusHUD.kXPBarSize = Vector(800, 32, 0)
AlienStatusHUD.kXPBarSizeScaled = Vector(800, 32, 0)

AlienStatusHUD.kAnimSpeedDown = 0.2
AlienStatusHUD.kAnimSpeedUp = 0.5

AlienStatusHUD.kXPFontName = Fonts.kArial_13
AlienStatusHUD.kXPTextPosition = Vector(0, -123, 0)

AlienStatusHUD.kRankFontName = Fonts.kStamp_Medium
AlienStatusHUD.kRankTextPosition = Vector(0, -154, 0)

AlienStatusHUD.kSkillIconTexture = PrecacheAsset("ui/alien_HUD_presicon.dds")
AlienStatusHUD.kSkillIconPixelCoords = { 6, 25, 26, 45 }
AlienStatusHUD.kSkillIconSize = Vector(25, 25, 0)
AlienStatusHUD.kSkillIconPos = Vector(-160, -28, 0)

AlienStatusHUD.kSkillPointFontName = Fonts.kAgencyFB_Small
AlienStatusHUD.kSkillPointTextPos = Vector(-130, -17, 0)

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
    self.xpBarBackground:SetIsVisible(true)
    self.background:AddChild(self.xpBarBackground)

    self.xpBar = self:CreateAnimatedGraphicItem()
    self.xpBar:SetAnchor(GUIItem.Middle, GUIItem.Bottom)
    self.xpBar:SetTexture(AlienStatusHUD.kXpBarOverlayTexture)
    self.xpBar:SetTexturePixelCoordinates(0, 0, 0, 32)
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

    self.skillPointIcon = self:CreateAnimatedGraphicItem()
    self.skillPointIcon:SetAnchor(GUIItem.Right, GUIItem.Top)
    self.skillPointIcon:SetTexture(AlienStatusHUD.kSkillIconTexture)
    self.skillPointIcon:SetTexturePixelCoordinates(unpack(AlienStatusHUD.kSkillIconPixelCoords))
    self.xpBarBackground:AddChild(self.skillPointIcon)

    self.skillPointText = GetGUIManager():CreateTextItem()
    self.skillPointText:SetFontName(AlienStatusHUD.kSkillPointFontName)
    self.skillPointText:SetAnchor(GUIItem.Right, GUIItem.Top)
    self.skillPointText:SetTextAlignmentX(GUIItem.Align_Min)
    self.skillPointText:SetTextAlignmentY(GUIItem.Align_Center)
    self.skillPointText:SetText("0 Skill Points")
    self.skillPointText:SetIsVisible(true)
    self.skillPointText:SetColor( kAlienFontColor )
    self.xpBarBackground:AddChild(self.skillPointText)

    self.visible = true
    self:UpdateVisibility()

    self:Reset(1)

end

function AlienStatusHUD:Reset(scale)

    self.scale = scale
    GUIAnimatedScript.Reset(self)

    self.background:SetSize(Vector(Client.GetScreenWidth(), Client.GetScreenHeight(),0))

    local xpBarWidthBkg = GUIScaleWidth(AlienStatusHUD.kXPBarSize.x)
    self.xpBarBackground:SetUniformScale(self.scale)
    self.xpBarBackground:SetSize( Vector(xpBarWidthBkg, 32, 0) )
    self.xpBarBackground:SetPosition( Vector(-1 * xpBarWidthBkg / 2, -140, 0) )

    AlienStatusHUD.kXPBarSizeScaled = Vector(GUIScaleWidth(AlienStatusHUD.kXPBarSizeScaled.x), AlienStatusHUD.kXPBarSizeScaled.y, 0)
    self.xpBar:SetUniformScale(self.scale)
    self.xpBar:SetSize( Vector(0, AlienStatusHUD.kXPBarSizeScaled.y, 0) )
    self.xpBar:SetPosition( Vector(-1 * xpBarWidthBkg / 2, -140, 0) )

    self.currentXPText:SetScale(GetScaledVector())
    self.currentXPText:SetPosition(AlienStatusHUD.kXPTextPosition)
    self.currentXPText:SetFontName(AlienStatusHUD.kXPFontName)
    GUIMakeFontScale(self.currentXPText)

    self.currentRankText:SetScale(GetScaledVector())
    self.currentRankText:SetPosition(AlienStatusHUD.kRankTextPosition)
    self.currentRankText:SetFontName(AlienStatusHUD.kRankFontName)
    GUIMakeFontScale(self.currentRankText)

    self.skillPointIcon:SetUniformScale(self.scale)
    self.skillPointIcon:SetPosition(AlienStatusHUD.kSkillIconPos)
    self.skillPointIcon:SetSize(AlienStatusHUD.kSkillIconSize)

    self.skillPointText:SetScale(GetScaledVector())
    self.skillPointText:SetPosition(AlienStatusHUD.kSkillPointTextPos)
    self.skillPointText:SetFontName(AlienStatusHUD.kSkillPointFontName)
    GUIMakeFontScale(self.skillPointText)

end

function AlienStatusHUD:Uninitialize()

    GUIAnimatedScript.Uninitialize(self)

    GUI.DestroyItem(self.currentXPText)
    self.currentXPText = nil

    GUI.DestroyItem(self.currentRankText)
    self.currentRankText = nil

    GUI.DestroyItem(self.skillPointText)
    self.skillPointText = nil

end

function AlienStatusHUD:UpdateVisibility()

    self.xpBarBackground:SetIsVisible(self.visible)
    self.xpBar:SetIsVisible(self.visible)
    self.currentXPText:SetIsVisible(self.visible)
    self.currentRankText:SetIsVisible(self.visible)
    self.skillPointIcon:SetIsVisible(self.visible)
    self.skillPointText:SetIsVisible(self.visible)

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

        -- update skill point text
        if player.combatSkillPoints == 1 then
            self.skillPointText:SetText(string.format("%s Skill Point", player.combatSkillPoints))
        else
            self.skillPointText:SetText(string.format("%s Skill Points", player.combatSkillPoints))
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
            local xpBarSize = Vector(AlienStatusHUD.kXPBarSizeScaled.x * xpFraction, AlienStatusHUD.kXPBarSizeScaled.y, 0)

            self.xpBar:DestroyAnimations()
            self.xpBar:SetSize(xpBarSize, animSpeed)
            self.xpBar:SetTexturePixelCoordinates(0, 0, xpBarSize.x, xpBarSize.y, animSpeed)
            self.xpBar:SetColor( Color(1, 1, 1, 1) )
            --self.xpBar:SetColor( GUICombatMarineStatus.kXPBarColor, 1 )

            self.lastXP = currentXP

        end

    end

end
