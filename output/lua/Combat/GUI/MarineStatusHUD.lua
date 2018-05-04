Script.Load("lua/Globals.lua")
Script.Load("lua/GUIUtility.lua")
Script.Load("lua/GUIAnimatedScript.lua")

class 'MarineStatusHUD' (GUIAnimatedScript)

MarineStatusHUD.kTexture = PrecacheAsset("ui/combatui_marine_status_bkg.dds")
MarineStatusHUD.kXpBarTexture = PrecacheAsset("ui/combatui_xp_bar.dds")

MarineStatusHUD.kBackgroundCoords = { 0, 0, 300, 121 }
MarineStatusHUD.kBackgroundPos = Vector(-400, -140, 0)
MarineStatusHUD.kBackgroundSize = Vector(MarineStatusHUD.kBackgroundCoords[3], MarineStatusHUD.kBackgroundCoords[4], 0)
MarineStatusHUD.kStencilCoords = { 0, 140, 300, 140 + 121 }

MarineStatusHUD.kXPFontName = Fonts.kArial_13
MarineStatusHUD.kXPTextPosition = Vector(0, -61, 0)

MarineStatusHUD.kRankFontName = Fonts.kAgencyFB_Small
MarineStatusHUD.kRankTextPosition = Vector(0, -82, 0)

MarineStatusHUD.kSkillPointTextPos = Vector(70, 64, 0)

MarineStatusHUD.kXPBarSize = Vector(789, 10, 0)
MarineStatusHUD.kXPBarSizeScaled = Vector(789, 10, 0)
MarineStatusHUD.kXPBarPos = Vector(5, 13, 0)
MarineStatusHUD.kXPBarColor = Color(0.26, 0.8, 0.87, 0.75)

MarineStatusHUD.kXPBarGlowSize = Vector(8, 22, 0)
MarineStatusHUD.kXPBarGlowPos = Vector(-MarineStatusHUD.kXPBarGlowSize.x, 0, 0)

MarineStatusHUD.kSkillIconTexture = PrecacheAsset("ui/marine_HUD_presicon.dds")
MarineStatusHUD.kSkillIconPixelCoords = { 6, 25, 26, 45 }
MarineStatusHUD.kSkillIconSize = Vector(25, 25, 0)
MarineStatusHUD.kSkillIconPos = Vector(40, 52, 0)

MarineStatusHUD.kAbilityIconBkgTexture = PrecacheAsset("ui/combatui_ability_buttonbg.dds")
MarineStatusHUD.kAbilityIconSize = Vector(68, 68, 0)

MarineStatusHUD.kAbilityIconTexture = PrecacheAsset("ui/combatui_marine_ability_icons.dds")
MarineStatusHUD.kAbilityBkgColorEnabled = Color(0.23, 0.33, 0.74, 1)
MarineStatusHUD.kAbilityCooldownColor = Color(0.24, 0.64, 1, 0.6)

MarineStatusHUD.kAnimSpeedDown = 0.2
MarineStatusHUD.kAnimSpeedUp = 0.5

local gAbilityIconIndex
local function GetAbilityIconPixelCoordinates(itemTechId)

  if not gAbilityIconIndex then

    gAbilityIconIndex = {}
    gAbilityIconIndex[kTechId.MedPack] = 0
    gAbilityIconIndex[kTechId.AmmoPack] = 1
    gAbilityIconIndex[kTechId.CatPack] = 2
    gAbilityIconIndex[kTechId.Scan] = 3

  end

  local x1 = 0
  local x2 = 64

  local index = gAbilityIconIndex[itemTechId]
  if not index then
      index = 0
  end

  local y1 = index * 64
  local y2 = (index + 1) * 64

  return x1, y1, x2, y2

end

function MarineStatusHUD:Initialize()

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

    self.newXpBarBkg = self:CreateAnimatedGraphicItem()
    self.newXpBarBkg:SetAnchor(GUIItem.Middle, GUIItem.Bottom)
    self.newXpBarBkg:SetTexture(MarineStatusHUD.kXpBarTexture)
    self.newXpBarBkg:SetIsVisible(true)
    self.background:AddChild(self.newXpBarBkg)

    self.newXpBar = self:CreateAnimatedGraphicItem()
    self.newXpBar:SetAnchor(GUIItem.Left, GUIItem.Top)
    self.newXpBar:SetIsVisible(true)
    self.newXpBar:SetColor( MarineStatusHUD.kXPBarColor )
    self.newXpBarBkg:AddChild(self.newXpBar)

    self.combatStatusBkg = self:CreateAnimatedGraphicItem()
    self.combatStatusBkg:SetAnchor(GUIItem.Right, GUIItem.Bottom)
    self.combatStatusBkg:SetTexture(MarineStatusHUD.kTexture)
    self.combatStatusBkg:SetTexturePixelCoordinates(unpack(MarineStatusHUD.kBackgroundCoords))
    self.combatStatusBkg:AddAsChildTo(self.background)

    self.currentXPText = GetGUIManager():CreateTextItem()
    self.currentXPText:SetFontName(MarineStatusHUD.kXPFontName)
    self.currentXPText:SetAnchor(GUIItem.Middle, GUIItem.Bottom)
    self.currentXPText:SetTextAlignmentX(GUIItem.Align_Center)
    self.currentXPText:SetTextAlignmentY(GUIItem.Align_Center)
    self.currentXPText:SetText("0 XP of 1000 (Rank 1)")
    self.currentXPText:SetIsVisible(true)
    self.currentXPText:SetColor( Color(1, 1, 1, 1) )
    self.background:AddChild(self.currentXPText)

    self.currentRankText = GetGUIManager():CreateTextItem()
    self.currentRankText:SetFontName(MarineStatusHUD.kRankFontName)
    self.currentRankText:SetAnchor(GUIItem.Middle, GUIItem.Bottom)
    self.currentRankText:SetTextAlignmentX(GUIItem.Align_Center)
    self.currentRankText:SetTextAlignmentY(GUIItem.Align_Center)
    self.currentRankText:SetText("Rank 1 : Private")
    self.currentRankText:SetIsVisible(true)
    self.currentRankText:SetColor( Color(0.62, 0.92, 1, 0.8) )
    self.background:AddChild(self.currentRankText)

    self.skillPointIcon = self:CreateAnimatedGraphicItem()
    self.skillPointIcon:SetAnchor(GUIItem.Left, GUIItem.Top)
    self.skillPointIcon:SetTexture(MarineStatusHUD.kSkillIconTexture)
    self.skillPointIcon:SetTexturePixelCoordinates(unpack(MarineStatusHUD.kSkillIconPixelCoords))
    self.skillPointIcon:AddAsChildTo(self.combatStatusBkg)

    self.skillPointText = GetGUIManager():CreateTextItem()
    self.skillPointText:SetFontName(MarineStatusHUD.kRankFontName)
    self.skillPointText:SetAnchor(GUIItem.Left, GUIItem.Top)
    self.skillPointText:SetTextAlignmentX(GUIItem.Align_Min)
    self.skillPointText:SetTextAlignmentY(GUIItem.Align_Center)
    self.skillPointText:SetText("0 Skill Points")
    self.skillPointText:SetIsVisible(true)
    self.skillPointText:SetColor( Color(0.62, 0.92, 1, 0.8) )
    self.combatStatusBkg:AddChild(self.skillPointText)

    self.medPackIconBackground = self:CreateAnimatedGraphicItem()
    self.medPackIconBackground:SetAnchor(GUIItem.Right, GUIItem.Bottom)
    self.medPackIconBackground:SetTexture(MarineStatusHUD.kAbilityIconBkgTexture)
    self.medPackIconBackground:SetTexturePixelCoordinates(0, 0, MarineStatusHUD.kAbilityIconSize.x, MarineStatusHUD.kAbilityIconSize.y)
    self.background:AddChild(self.medPackIconBackground)

    self.medPackIcon = self:CreateAnimatedGraphicItem()
    self.medPackIcon:SetAnchor(GUIItem.Left, GUIItem.Top)
    self.medPackIcon:SetTexture(MarineStatusHUD.kAbilityIconTexture)
    self.medPackIcon:SetTexturePixelCoordinates(GetAbilityIconPixelCoordinates(kTechId.MedPack))
    self.medPackIcon:SetColor( Color(0.44, 0.58, 0.74, 1) )
    self.medPackIconBackground:AddChild(self.medPackIcon)

    self.medPackCooldownOverlay = self:CreateAnimatedGraphicItem()
    self.medPackCooldownOverlay:SetAnchor(GUIItem.Left, GUIItem.Top)
    self.medPackCooldownOverlay:SetColor( MarineStatusHUD.kAbilityCooldownColor )
    self.medPackIconBackground:AddChild(self.medPackCooldownOverlay)

    self.ammoPackIconBackground = self:CreateAnimatedGraphicItem()
    self.ammoPackIconBackground:SetAnchor(GUIItem.Right, GUIItem.Bottom)
    self.ammoPackIconBackground:SetTexture(MarineStatusHUD.kAbilityIconBkgTexture)
    self.ammoPackIconBackground:SetTexturePixelCoordinates(0, 0, MarineStatusHUD.kAbilityIconSize.x, MarineStatusHUD.kAbilityIconSize.y)
    self.background:AddChild(self.ammoPackIconBackground)

    self.ammoPackIcon = self:CreateAnimatedGraphicItem()
    self.ammoPackIcon:SetAnchor(GUIItem.Left, GUIItem.Top)
    self.ammoPackIcon:SetTexture(MarineStatusHUD.kAbilityIconTexture)
    self.ammoPackIcon:SetTexturePixelCoordinates(GetAbilityIconPixelCoordinates(kTechId.AmmoPack))
    self.ammoPackIcon:SetColor( Color(0.44, 0.58, 0.74, 1) )
    self.ammoPackIconBackground:AddChild(self.ammoPackIcon)

    self.ammoPackCooldownOverlay = self:CreateAnimatedGraphicItem()
    self.ammoPackCooldownOverlay:SetAnchor(GUIItem.Left, GUIItem.Top)
    self.ammoPackCooldownOverlay:SetColor( MarineStatusHUD.kAbilityCooldownColor )
    self.ammoPackIconBackground:AddChild(self.ammoPackCooldownOverlay)

    self.catPackIconBackground = self:CreateAnimatedGraphicItem()
    self.catPackIconBackground:SetAnchor(GUIItem.Right, GUIItem.Bottom)
    self.catPackIconBackground:SetTexture(MarineStatusHUD.kAbilityIconBkgTexture)
    self.catPackIconBackground:SetTexturePixelCoordinates(0, 0, MarineStatusHUD.kAbilityIconSize.x, MarineStatusHUD.kAbilityIconSize.y)
    self.background:AddChild(self.catPackIconBackground)

    self.catPackIcon = self:CreateAnimatedGraphicItem()
    self.catPackIcon:SetAnchor(GUIItem.Left, GUIItem.Top)
    self.catPackIcon:SetTexture(MarineStatusHUD.kAbilityIconTexture)
    self.catPackIcon:SetTexturePixelCoordinates(GetAbilityIconPixelCoordinates(kTechId.CatPack))
    self.catPackIcon:SetColor( Color(0.44, 0.58, 0.74, 1) )
    self.catPackIconBackground:AddChild(self.catPackIcon)

    self.catPackCooldownOverlay = self:CreateAnimatedGraphicItem()
    self.catPackCooldownOverlay:SetAnchor(GUIItem.Left, GUIItem.Top)
    self.catPackCooldownOverlay:SetColor( MarineStatusHUD.kAbilityCooldownColor )
    self.catPackIconBackground:AddChild(self.catPackCooldownOverlay)

    self.scanIconBackground = self:CreateAnimatedGraphicItem()
    self.scanIconBackground:SetAnchor(GUIItem.Right, GUIItem.Bottom)
    self.scanIconBackground:SetTexture(MarineStatusHUD.kAbilityIconBkgTexture)
    self.scanIconBackground:SetTexturePixelCoordinates(0, 0, MarineStatusHUD.kAbilityIconSize.x, MarineStatusHUD.kAbilityIconSize.y)
    self.background:AddChild(self.scanIconBackground)

    self.scanIcon = self:CreateAnimatedGraphicItem()
    self.scanIcon:SetAnchor(GUIItem.Left, GUIItem.Top)
    self.scanIcon:SetTexture(MarineStatusHUD.kAbilityIconTexture)
    self.scanIcon:SetTexturePixelCoordinates(GetAbilityIconPixelCoordinates(kTechId.Scan))
    self.scanIcon:SetColor( Color(0.44, 0.58, 0.74, 1) )
    self.scanIconBackground:AddChild(self.scanIcon)

    self.scanCooldownOverlay = self:CreateAnimatedGraphicItem()
    self.scanCooldownOverlay:SetAnchor(GUIItem.Left, GUIItem.Top)
    self.scanCooldownOverlay:SetColor( MarineStatusHUD.kAbilityCooldownColor )
    self.scanIconBackground:AddChild(self.scanCooldownOverlay)

    self.visible = true
    self:UpdateVisibility()

    self:Reset(1)

end

function MarineStatusHUD:Reset(scale)

    self.scale = scale
    GUIAnimatedScript.Reset(self)

    self.background:SetSize(Vector(Client.GetScreenWidth(), Client.GetScreenHeight(),0))

    local xpBarWidthBkg = GUIScaleWidth(800)
    self.newXpBarBkg:SetUniformScale(self.scale)
    self.newXpBarBkg:SetSize( Vector(xpBarWidthBkg, 32, 0) )
    self.newXpBarBkg:SetPosition( Vector(-1 * xpBarWidthBkg / 2, -80, 0) )

    MarineStatusHUD.kXPBarSizeScaled = Vector(GUIScaleWidth(MarineStatusHUD.kXPBarSizeScaled.x), MarineStatusHUD.kXPBarSizeScaled.y, 0)
    self.newXpBar:SetUniformScale(self.scale)
    self.newXpBar:SetSize( Vector(0, MarineStatusHUD.kXPBarSizeScaled.y, 0) )
    self.newXpBar:SetPosition(MarineStatusHUD.kXPBarPos)

    self.combatStatusBkg:SetUniformScale(self.scale)
    self.combatStatusBkg:SetPosition(MarineStatusHUD.kBackgroundPos)
    self.combatStatusBkg:SetSize(MarineStatusHUD.kBackgroundSize)

    self.skillPointIcon:SetUniformScale(self.scale)
    self.skillPointIcon:SetPosition(MarineStatusHUD.kSkillIconPos)
    self.skillPointIcon:SetSize(MarineStatusHUD.kSkillIconSize)

    self.currentXPText:SetScale(GetScaledVector())
    self.currentXPText:SetPosition(MarineStatusHUD.kXPTextPosition)
    self.currentXPText:SetFontName(MarineStatusHUD.kXPFontName)
    GUIMakeFontScale(self.currentXPText)

    self.currentRankText:SetScale(GetScaledVector())
    self.currentRankText:SetPosition(MarineStatusHUD.kRankTextPosition)
    self.currentRankText:SetFontName(MarineStatusHUD.kRankFontName)
    GUIMakeFontScale(self.currentRankText)

    self.skillPointText:SetScale(GetScaledVector())
    self.skillPointText:SetPosition(MarineStatusHUD.kSkillPointTextPos)
    self.skillPointText:SetFontName(MarineStatusHUD.kRankFontName)
    GUIMakeFontScale(self.skillPointText)

    self.medPackIconBackground:SetUniformScale(self.scale)
    self.medPackIconBackground:SetPosition( Vector(-142, -180, 0) )
    self.medPackIconBackground:SetSize(MarineStatusHUD.kAbilityIconSize)

    self.medPackIcon:SetUniformScale(self.scale)
    self.medPackIcon:SetPosition( Vector(2, 2, 0) )
    self.medPackIcon:SetSize( Vector(64, 64, 0) )

    self.medPackCooldownOverlay:SetUniformScale(self.scale)
    self.medPackCooldownOverlay:SetPosition( Vector(3, 3, 0) )
    self.medPackCooldownOverlay:SetSize( Vector(60, 60, 0) )

    self.ammoPackIconBackground:SetUniformScale(self.scale)
    self.ammoPackIconBackground:SetPosition( Vector(-142, -110, 0) )
    self.ammoPackIconBackground:SetSize(MarineStatusHUD.kAbilityIconSize)

    self.ammoPackIcon:SetUniformScale(self.scale)
    self.ammoPackIcon:SetPosition( Vector(2, 2, 0) )
    self.ammoPackIcon:SetSize( Vector(64, 64, 0) )

    self.ammoPackCooldownOverlay:SetUniformScale(self.scale)
    self.ammoPackCooldownOverlay:SetPosition( Vector(3, 3, 0) )
    self.ammoPackCooldownOverlay:SetSize( Vector(60, 60, 0) )

    self.catPackIconBackground:SetUniformScale(self.scale)
    self.catPackIconBackground:SetPosition( Vector(-72, -180, 0) )
    self.catPackIconBackground:SetSize(MarineStatusHUD.kAbilityIconSize)

    self.catPackIcon:SetUniformScale(self.scale)
    self.catPackIcon:SetPosition( Vector(2, 2, 0) )
    self.catPackIcon:SetSize( Vector(64, 64, 0) )

    self.catPackCooldownOverlay:SetUniformScale(self.scale)
    self.catPackCooldownOverlay:SetPosition( Vector(3, 3, 0) )
    self.catPackCooldownOverlay:SetSize( Vector(60, 60, 0) )

    self.scanIconBackground:SetUniformScale(self.scale)
    self.scanIconBackground:SetPosition( Vector(-72, -110, 0) )
    self.scanIconBackground:SetSize(MarineStatusHUD.kAbilityIconSize)

    self.scanIcon:SetUniformScale(self.scale)
    self.scanIcon:SetPosition( Vector(2, 2, 0) )
    self.scanIcon:SetSize( Vector(64, 64, 0) )

    self.scanCooldownOverlay:SetUniformScale(self.scale)
    self.scanCooldownOverlay:SetPosition( Vector(3, 3, 0) )
    self.scanCooldownOverlay:SetSize( Vector(60, 60, 0) )

    --self.xpBar:SetSize(Vector(0, MarineStatusHUD.kXPBarSize.y, 0))
    --self.xpBar:SetTexturePixelCoordinates(MarineStatusHUD.kXPBarPixelCoords[1], MarineStatusHUD.kXPBarPixelCoords[2], MarineStatusHUD.kXPBarPixelCoords[1], MarineStatusHUD.kXPBarPixelCoords[4])

end

function MarineStatusHUD:Uninitialize()

    GUIAnimatedScript.Uninitialize(self)

    GUI.DestroyItem(self.currentXPText)
    self.currentXPText = nil

    GUI.DestroyItem(self.currentRankText)
    self.currentRankText = nil

    GUI.DestroyItem(self.skillPointText)
    self.skillPointText = nil

end

function MarineStatusHUD:UpdateCooldowns(player)

    if HasMixin(player, "MedPackAbility") then

        local visible = player:GetIsMedPackAbilityEnabled()
        local bkgColor = ConditionalValue(visible, MarineStatusHUD.kAbilityBkgColorEnabled, Color(1,1,1,1))

        self.medPackIconBackground:SetColor(bkgColor)
        self.medPackIcon:SetIsVisible(visible)

        local medPackCooldownFraction = player:GetMedPackCooldownFraction()
        self.medPackCooldownOverlay:SetSize( Vector(60, 60 * medPackCooldownFraction, 0) )
        self.medPackCooldownOverlay:SetPosition( Vector(3, 60 - (60 * medPackCooldownFraction) + 3, 0) )
        self.medPackCooldownOverlay:SetIsVisible(visible)

    end

    if HasMixin(player, "AmmoPackAbility") then

        local visible = player:GetIsAmmoPackAbilityEnabled()
        local bkgColor = ConditionalValue(visible, MarineStatusHUD.kAbilityBkgColorEnabled, Color(1,1,1,1))

        self.ammoPackIconBackground:SetColor(bkgColor)
        self.ammoPackIcon:SetIsVisible(visible)

        local ammoPackCooldownFraction = player:GetAmmoPackCooldownFraction()
        self.ammoPackCooldownOverlay:SetSize( Vector(60, 60 * ammoPackCooldownFraction, 0) )
        self.ammoPackCooldownOverlay:SetPosition( Vector(3, 60 - (60 * ammoPackCooldownFraction) + 3, 0) )
        self.ammoPackCooldownOverlay:SetIsVisible(visible)

    end

    if HasMixin(player, "CatPackAbility") then

        local visible = player:GetIsCatPackAbilityEnabled()
        local bkgColor = ConditionalValue(visible, MarineStatusHUD.kAbilityBkgColorEnabled, Color(1,1,1,1))

        self.catPackIconBackground:SetColor(bkgColor)
        self.catPackIcon:SetIsVisible(visible)

        local catPackCooldownFraction = player:GetCatPackCooldownFraction()
        self.catPackCooldownOverlay:SetSize( Vector(60, 60 * catPackCooldownFraction, 0) )
        self.catPackCooldownOverlay:SetPosition( Vector(3, 60 - (60 * catPackCooldownFraction) + 3, 0) )
        self.catPackCooldownOverlay:SetIsVisible(visible)

    end

    if HasMixin(player, "ScanAbility") then

        local visible = player:GetIsScanAbilityEnabled()
        local bkgColor = ConditionalValue(visible, MarineStatusHUD.kAbilityBkgColorEnabled, Color(1,1,1,1))

        self.scanIconBackground:SetColor(bkgColor)
        self.scanIcon:SetIsVisible(visible)

        local scanCooldownFraction = player:GetScanCooldownFraction()
        self.scanCooldownOverlay:SetSize( Vector(60, 60 * scanCooldownFraction, 0) )
        self.scanCooldownOverlay:SetPosition( Vector(3, 60 - (60 * scanCooldownFraction) + 3, 0) )
        self.scanCooldownOverlay:SetIsVisible(visible)

    end

end

function MarineStatusHUD:UpdateVisibility()

    self.combatStatusBkg:SetIsVisible(self.visible)
    self.currentXPText:SetIsVisible(self.visible)
    self.currentRankText:SetIsVisible(self.visible)
    self.skillPointIcon:SetIsVisible(self.visible)
    self.skillPointText:SetIsVisible(self.visible)
    self.newXpBarBkg:SetIsVisible(self.visible)

    self.medPackIconBackground:SetIsVisible(self.visible)
    self.ammoPackIconBackground:SetIsVisible(self.visible)
    self.catPackIconBackground:SetIsVisible(self.visible)
    self.scanIconBackground:SetIsVisible(self.visible)

end

function MarineStatusHUD:SetIsVisible(isVisible)

    self.visible = isVisible
    self:UpdateVisibility()

end

function MarineStatusHUD:GetIsVisible()

    return self.visible

end

function MarineStatusHUD:OnResolutionChanged(oldX, oldY, newX, newY)

    self:Reset(newY / kBaseScreenHeight)

    self:Uninitialize()
    self:Initialize()

end

function MarineStatusHUD:Update(deltaTime)

    GUIAnimatedScript.Update(self, deltaTime)

    local player = Client.GetLocalPlayer()

    self:UpdateCooldowns(player)

    if player and HasMixin(player, "CombatScore") then

        local currentXP = player.combatXP
        local currentRank = player.combatRank
        local title = CombatPlusPlus_GetMarineTitleByRank(currentRank)
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
                self.newXpBar:DestroyAnimations()
                self.newXpBar:SetSize(Vector(0, 10, 0))
            end

            self.lastRank = currentRank

        end

        if currentXP ~= self.lastXP then

            local animSpeed = ConditionalValue(currentXP < self.lastXP, MarineStatusHUD.kAnimSpeedDown, MarineStatusHUD.kAnimSpeedUp)

            local xpFraction = currentXPNorm / newXPThresholdNorm
            local xpBarSize = Vector(MarineStatusHUD.kXPBarSizeScaled.x * xpFraction, MarineStatusHUD.kXPBarSizeScaled.y, 0)

            self.newXpBar:DestroyAnimations()
            self.newXpBar:SetSize(xpBarSize, animSpeed)
            self.newXpBar:SetColor( Color(1, 1, 1, 1) )
            self.newXpBar:SetColor( MarineStatusHUD.kXPBarColor, 1 )

            self.lastXP = currentXP

        end

    end

end
