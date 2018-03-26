--[[
 * Natural Selection 2 - Combat++ Mod
 * Authors:
 *          WhiteWizard
 *
 * New GUI that appears when the aliens attempt to buy something using the 'B' key.
]]

Script.Load("lua/GUIAnimatedScript.lua")

class 'CPPGUICombatAlienBuyMenu' (GUIAnimatedScript)

CPPGUICombatAlienBuyMenu.kBackgroundColor = Color(0.28, 0.17, 0.04, 0.6)
CPPGUICombatAlienBuyMenu.kBackgroundCenterColor = Color(0.4, 0.1, 0.06, 0.8)
CPPGUICombatAlienBuyMenu.kBackgroundSize = Vector(1024, 1024, 0)
CPPGUICombatAlienBuyMenu.kBackgroundTexture = PrecacheAsset("ui/combatui_alienbuy_bkg.dds")

CPPGUICombatAlienBuyMenu.kBuyMenuTexture = PrecacheAsset("ui/alien_buymenu.dds")
CPPGUICombatAlienBuyMenu.kBuyMenuMaskTexture = PrecacheAsset("ui/alien_buymenu_mask.dds")
CPPGUICombatAlienBuyMenu.kBuyHUDTexture = "ui/buildmenu.dds"
CPPGUICombatAlienBuyMenu.kAbilityIcons = "ui/buildmenu.dds"
CPPGUICombatAlienBuyMenu.kAlienLogoTexture = PrecacheAsset("ui/logo_alien.dds")

CPPGUICombatAlienBuyMenu.KCurrentEvoBorderTexture = PrecacheAsset("ui/alien_commander_background.dds")
CPPGUICombatAlienBuyMenu.kEvolvePanelBkgTexture = PrecacheAsset("ui/combatui_alienbuy_evolvequeuepanel.dds")
CPPGUICombatAlienBuyMenu.kCloseIconTexture = PrecacheAsset("ui/close_icon.dds")

CPPGUICombatAlienBuyMenu.kSlotTexture = PrecacheAsset("ui/alien_buyslot.dds")
CPPGUICombatAlienBuyMenu.kSlotLockedTexture = PrecacheAsset("ui/alien_buyslot_locked.dds")

CPPGUICombatAlienBuyMenu.kBackgroundTextureCoordinates = { 9, 1, 602, 424 }

CPPGUICombatAlienBuyMenu.kAlienSelectedBackground = PrecacheAsset("ui/AlienBackground.dds")

CPPGUICombatAlienBuyMenu.kEvolveButtonNeedResourcesTextureCoordinates = { 87, 429, 396, 511 }
CPPGUICombatAlienBuyMenu.kEvolveButtonTextureCoordinates = { 396, 428, 706, 511 }
CPPGUICombatAlienBuyMenu.kEvolveButtonVeinsTextureCoordinates = { 600, 350, 915, 419 }
local kVeinsMargin = GUIScale(4)

CPPGUICombatAlienBuyMenu.kResourceIconTexture = PrecacheAsset("ui/pres_icon_big.dds")

CPPGUICombatAlienBuyMenu.kButtonTexture = PrecacheAsset("ui/combatui_alien_button.dds")
CPPGUICombatAlienBuyMenu.kButtonHighlightTexture = PrecacheAsset("ui/combatui_alien_button_highlight.dds")
CPPGUICombatAlienBuyMenu.kButtonSize = Vector(128, 128, 0)
CPPGUICombatAlienBuyMenu.kButtonPadding = Vector(60, 20, 0)

CPPGUICombatAlienBuyMenu.kLifeformIconTexture = PrecacheAsset("ui/combatui_alien_lifeforms.dds")

CPPGUICombatAlienBuyMenu.kTitleFont = Fonts.kStamp_Large
CPPGUICombatAlienBuyMenu.kHeaderFont = Fonts.kStamp_Medium
CPPGUICombatAlienBuyMenu.kHeaderAltFont = Fonts.kAgencyFB_Small
CPPGUICombatAlienBuyMenu.kSubHeaderFont = Fonts.kArial_Tiny
CPPGUICombatAlienBuyMenu.kTextColor = Color(kAlienFontColor)

CPPGUICombatAlienBuyMenu.kCornerPulseTime = 4
CPPGUICombatAlienBuyMenu.kCornerTextureCoordinates = { TopLeft = { 605, 1, 765, 145 },  BottomLeft = { 605, 145, 765, 290 }, TopRight = { 765, 1, 910, 145 }, BottomRight = { 765, 145, 910, 290 } }
CPPGUICombatAlienBuyMenu.kCornerWidths = { }
CPPGUICombatAlienBuyMenu.kCornerHeights = { }

CPPGUICombatAlienBuyMenu.kMaxNumberOfUpgradeButtons = 8
CPPGUICombatAlienBuyMenu.kUpgradeButtonTextureSize = 80
CPPGUICombatAlienBuyMenu.kUpgradeButtonBackgroundTextureCoordinates = { 15, 434, 85, 505 }
CPPGUICombatAlienBuyMenu.kUpgradeButtonMoveTime = 0.5

local kTooltipTextWidth = GUIScale(300)

CPPGUICombatAlienBuyMenu.kHealthIconTextureCoordinates = { 854, 318, 887, 351 }
CPPGUICombatAlienBuyMenu.kArmorIconTextureCoordinates = { 887, 318, 920, 351 }

CPPGUICombatAlienBuyMenu.kRedHighlight = Color(1, 0.3, 0.3, 1)
CPPGUICombatAlienBuyMenu.kDisabledColor = Color(0.5, 0.5, 0.5, 0.5)
CPPGUICombatAlienBuyMenu.kCannotBuyColor = Color(1, 0, 0, 0.5)
CPPGUICombatAlienBuyMenu.kEnabledColor = Color(1, 1, 1, 1)

local kLargeFont = Fonts.kAgencyFB_Large
local kFont = Fonts.kAgencyFB_Small
local kFontSmall = Fonts.kAgencyFB_Tiny
local kOffsetToCircleCenter = Vector(-70, 0, 0)

local function GetTotalCost(self)

    local totalCost = 0

    -- alien cost
    if self.selectedAlienType ~= AlienBuy_GetCurrentAlien() then
        totalCost = CombatPlusPlus_GetCostByTechId(self.kAlienTypes[self.selectedAlienType].TechId)
    end

    -- upgrade costs
    for i, currentButton in ipairs(self.upgradeButtons) do

        local upgradeCost = CombatPlusPlus_GetCostByTechId(currentButton.TechId)

        -- Skulks have free upgrades even in Combat++ :)
        if self.kAlienTypes[self.selectedAlienType].TechId == kTechId.Skulk then
            upgradeCost = 0
        end

        local player = Client.GetLocalPlayer()
        if currentButton.Selected and not player:GetHasUpgrade(currentButton.TechId) then
            totalCost = totalCost + upgradeCost
        end

    end

    return totalCost

end

local function GetNumberOfNewlySelectedUpgrades(self)

    local numSelected = 0
    local player = Client.GetLocalPlayer()

    if player then

        for i, currentButton in ipairs(self.upgradeButtons) do

            if currentButton.Selected and not player:GetHasUpgrade(currentButton.TechId) then
                numSelected = numSelected + 1
            end

        end

    end

    return numSelected

end

--
-- Checks if the mouse is over the passed in GUIItem and plays a sound if it has just moved over.
--
function CPPGUICombatAlienBuyMenu:_GetIsMouseOver(overItem)

    local mouseOver = GUIItemContainsPoint(overItem, Client.GetCursorPosScreen())
    if mouseOver and not self.mouseOverStates[overItem] then
        AlienBuy_OnMouseOver()
    end
    self.mouseOverStates[overItem] = mouseOver
    return mouseOver

end

local function UpdateItemsGUIScale(self)

    CPPGUICombatAlienBuyMenu.kAlienTypes = { { LocaleName = Locale.ResolveString("FADE"), Name = "Fade", Width = GUIScale(188), Height = GUIScale(220), XPos = 2, Index = 1, TechId = kTechId.Fade },
        { LocaleName = Locale.ResolveString("GORGE"), Name = "Gorge", Width = GUIScale(200), Height = GUIScale(167), XPos = 4, Index = 2, TechId = kTechId.Gorge },
        { LocaleName = Locale.ResolveString("LERK"), Name = "Lerk", Width = GUIScale(284), Height = GUIScale(253), XPos = 3, Index = 3, TechId = kTechId.Lerk },
        { LocaleName = Locale.ResolveString("ONOS"), Name = "Onos", Width = GUIScale(304), Height = GUIScale(326), XPos = 1, Index = 4, TechId = kTechId.Onos },
        { LocaleName = Locale.ResolveString("SKULK"), Name = "Skulk", Width = GUIScale(240), Height = GUIScale(170), XPos = 5, Index = 5, TechId = kTechId.Skulk } }


    CPPGUICombatAlienBuyMenu.kLogoSize = GUIScale(128)
    CPPGUICombatAlienBuyMenu.kBackgroundTextureSize = GUIScale(Vector(1000, 1080, 0))

    -- title offsets
    CPPGUICombatAlienBuyMenu.kTitleOffset = GUIScale(Vector(158, 40, 0))
    CPPGUICombatAlienBuyMenu.kCurrentEvoTitleOffset = GUIScale(Vector(16, 6, 0))
    CPPGUICombatAlienBuyMenu.kLifeformsTitleOffset = GUIScale(Vector(60, 248, 0))
    CPPGUICombatAlienBuyMenu.kUpgradesTitleOffest = GUIScale(Vector(60, 620, 0))

    -- header and mouse over info offsets
    CPPGUICombatAlienBuyMenu.kResIconOffset = GUIScale(Vector(158, 75, 0))

    CPPGUICombatAlienBuyMenu.kMouseOverPanelOffset = GUIScale(Vector(60, 140, 0))
    CPPGUICombatAlienBuyMenu.kMouseOverTitleOffset = GUIScale(Vector(16, 6, 0))
    CPPGUICombatAlienBuyMenu.kMouseOverInfoOffset = GUIScale(Vector(16, 50, 0))
    CPPGUICombatAlienBuyMenu.kMouseOverCostOffset = GUIScale(Vector(-20, 6, 0))
    CPPGUICombatAlienBuyMenu.kMouseOverInfoResIconOffset = GUIScale(Vector(-40, 8, 0))
    CPPGUICombatAlienBuyMenu.kStatsPadding = GUIScale(Vector(5, 0, 0))
    CPPGUICombatAlienBuyMenu.kStatsPaddingY = GUIScale(Vector(0, 2,0))

    -- current evolution section
    CPPGUICombatAlienBuyMenu.kCurrentEvoBorderOffset = GUIScale(Vector(-320, 20, 0))
    CPPGUICombatAlienBuyMenu.kCurrentEvoBorderSize = GUIScale(Vector(262, 222, 0))
    CPPGUICombatAlienBuyMenu.kBiomassIconSize = GUIScale(Vector(72, 72, 0))
    CPPGUICombatAlienBuyMenu.kBiomassIconOffset = GUIScale(Vector(-CPPGUICombatAlienBuyMenu.kBiomassIconSize.x - 20, 45, 0))

    -- alien buttons
    CPPGUICombatAlienBuyMenu.kAlienButtonOffsetY = GUIScale(-60)
    CPPGUICombatAlienBuyMenu.kAlienIconSize = GUIScale(120)

    -- evolve panel
    CPPGUICombatAlienBuyMenu.kEvolvePanelSize = GUIScale(Vector(600, 100, 0))
    CPPGUICombatAlienBuyMenu.kEvolvePanelOffset = GUIScale(Vector(60, -140, 0))
    CPPGUICombatAlienBuyMenu.kEvolveTitleOffset = GUIScale(Vector(16, 6, 0))
    CPPGUICombatAlienBuyMenu.kEvolveIconSize = GUIScale(58)
    CPPGUICombatAlienBuyMenu.kEvolveLifeformIconOffset = GUIScale(Vector(10, 40, 0))
    CPPGUICombatAlienBuyMenu.kCloseIconSize = GUIScale(16)
    CPPGUICombatAlienBuyMenu.kEvolveUpgradePadding = GUIScale(12)
    

    CPPGUICombatAlienBuyMenu.kOffsetToCircleCenter = Vector(GUIScale(-70), 0, 0)

    CPPGUICombatAlienBuyMenu.kAlienButtonSize = GUIScale(180)
    CPPGUICombatAlienBuyMenu.kPlayersTextSize = GUIScale(24)
    CPPGUICombatAlienBuyMenu.kAlienSelectedButtonSize = CPPGUICombatAlienBuyMenu.kAlienButtonSize * 2

    CPPGUICombatAlienBuyMenu.kResourceIconWidth = GUIScale(33)
    CPPGUICombatAlienBuyMenu.kResourceIconHeight = GUIScale(33)

    CPPGUICombatAlienBuyMenu.kResourceIconWidthSm = GUIScale(20)
    CPPGUICombatAlienBuyMenu.kResourceIconHeightSm = GUIScale(20)

    CPPGUICombatAlienBuyMenu.kEvolveButtonWidth = GUIScale(250)
    CPPGUICombatAlienBuyMenu.kEvolveButtonHeight = GUIScale(80)
    CPPGUICombatAlienBuyMenu.kEvolveButtonOffset = GUIScale(Vector(-60, -40, 0))
    CPPGUICombatAlienBuyMenu.kEvolveButtonTextSize = GUIScale(22)

    CPPGUICombatAlienBuyMenu.kHealthIconWidth = GUIScale(CPPGUICombatAlienBuyMenu.kHealthIconTextureCoordinates[3] - CPPGUICombatAlienBuyMenu.kHealthIconTextureCoordinates[1])
    CPPGUICombatAlienBuyMenu.kHealthIconHeight = GUIScale(CPPGUICombatAlienBuyMenu.kHealthIconTextureCoordinates[4] - CPPGUICombatAlienBuyMenu.kHealthIconTextureCoordinates[2])

    CPPGUICombatAlienBuyMenu.kArmorIconWidth = GUIScale(CPPGUICombatAlienBuyMenu.kArmorIconTextureCoordinates[3] - CPPGUICombatAlienBuyMenu.kArmorIconTextureCoordinates[1])
    CPPGUICombatAlienBuyMenu.kArmorIconHeight = GUIScale(CPPGUICombatAlienBuyMenu.kArmorIconTextureCoordinates[4] - CPPGUICombatAlienBuyMenu.kArmorIconTextureCoordinates[2])
    
    CPPGUICombatAlienBuyMenu.kMouseOverInfoTextSize = GUIScale(20)

    kTooltipTextWidth = GUIScale(300)

    CPPGUICombatAlienBuyMenu.kUpgradeButtonSize = GUIScale(54)
    CPPGUICombatAlienBuyMenu.kUpgradeButtonDistance = GUIScale(198)
    -- The distance in pixels to move the button inside the embryo when selected.
    CPPGUICombatAlienBuyMenu.kUpgradeButtonDistanceInside = GUIScale(74)

    for location, texCoords in pairs(CPPGUICombatAlienBuyMenu.kCornerTextureCoordinates) do
        CPPGUICombatAlienBuyMenu.kCornerWidths[location] = GUIScale(texCoords[3] - texCoords[1])
        CPPGUICombatAlienBuyMenu.kCornerHeights[location] = GUIScale(texCoords[4] - texCoords[2])
    end

end

function CPPGUICombatAlienBuyMenu:Initialize()

    GUIAnimatedScript.Initialize(self)

    UpdateItemsGUIScale(self)

    self.numSelectedUpgrades = 0
    self.mouseOverStates = { }
    self.upgradeList = {}
    self.abilityIcons = {}
    self.selectedAlienType = AlienBuy_GetCurrentAlien()

    self:_InitializeBackground()
    self:_InitializeCorners()
    self:_InitializeHeader()
    self:_InitializeMouseOverInfo()
    self:_InitializeCurrentEvolutionDisplay()
    self:_InitializeLifeforms()
    self:_InitializeAlienButtons()
    self:_InitializeUpgrades()
    self:_InitializeEvolvePanel()
    self:_InitializeEvolveButton()

    AlienBuy_OnOpen()
    MouseTracker_SetIsVisible(true, "ui/Cursor_MenuDefault.dds", true)

end

function CPPGUICombatAlienBuyMenu:Update(deltaTime)

    PROFILE("CPPGUICombatAlienBuyMenu:Update")

    GUIAnimatedScript.Update(self, deltaTime)
    
    -- Assume there is no mouse over info to start.
    self:_HideMouseOverInfo()

    self:_UpdateCorners(deltaTime)
    self:_UpdateAlienButtons()
    self:_UpdateEvolveButton()
    self:_UpdateAbilities()
    self:_UpdateUpgrades(deltaTime)
    self:_UpdateEvolvePanel()

end

function CPPGUICombatAlienBuyMenu:Uninitialize()

    GUIAnimatedScript.Uninitialize(self)

    GUI.DestroyItem(self.background)
    self.background = nil

    self.corners = { }
    self.cornerTweeners = { }

    MouseTracker_SetIsVisible(false)

end

function CPPGUICombatAlienBuyMenu:OnResolutionChanged(oldX, oldY, newX, newY)

    self:Uninitialize()
    self:Initialize()

end

function CPPGUICombatAlienBuyMenu:_InitializeBackground()

    self.background = GUIManager:CreateGraphicItem()
    self.background:SetSize( Vector(Client.GetScreenWidth(), Client.GetScreenHeight(), 0) )
    self.background:SetAnchor(GUIItem.Left, GUIItem.Top)
    self.background:SetColor(CPPGUICombatAlienBuyMenu.kBackgroundColor)
    self.background:SetLayer(kGUILayerPlayerHUDForeground4)

    self.backgroundCenteredArea = GUIManager:CreateGraphicItem()
    self.backgroundCenteredArea:SetSize( Vector(1000, Client.GetScreenHeight(), 0) )
    self.backgroundCenteredArea:SetAnchor(GUIItem.Middle, GUIItem.Top)
    self.backgroundCenteredArea:SetPosition( Vector(-500, 0, 0) )
    self.backgroundCenteredArea:SetTexture(CPPGUICombatAlienBuyMenu.kBackgroundTexture)
    self.backgroundCenteredArea:SetColor(Color(1.0, 1.0, 1.0, 0.6))
    --self.backgroundCenteredArea:SetColor(CPPGUICombatAlienBuyMenu.kBackgroundCenterColor)
    self.background:AddChild(self.backgroundCenteredArea)

end

function CPPGUICombatAlienBuyMenu:_InitializeCorners()

    self.corners = { }

    local topLeftCorner = GUIManager:CreateGraphicItem()
    topLeftCorner:SetAnchor(GUIItem.Left, GUIItem.Top)
    topLeftCorner:SetSize(Vector(CPPGUICombatAlienBuyMenu.kCornerWidths.TopLeft, CPPGUICombatAlienBuyMenu.kCornerHeights.TopLeft, 0))
    topLeftCorner:SetTexture(CPPGUICombatAlienBuyMenu.kBuyMenuTexture)
    topLeftCorner:SetTexturePixelCoordinates(GUIUnpackCoords(CPPGUICombatAlienBuyMenu.kCornerTextureCoordinates.TopLeft))
    topLeftCorner:SetShader("shaders/GUIWavyNoMask.surface_shader")
    self.backgroundCenteredArea:AddChild(topLeftCorner)
    self.corners.TopLeft = topLeftCorner

    local bottomLeftCorner = GUIManager:CreateGraphicItem()
    bottomLeftCorner:SetAnchor(GUIItem.Left, GUIItem.Bottom)
    bottomLeftCorner:SetPosition(Vector(0, -CPPGUICombatAlienBuyMenu.kCornerHeights.BottomLeft, 0))
    bottomLeftCorner:SetSize(Vector(CPPGUICombatAlienBuyMenu.kCornerWidths.BottomLeft, CPPGUICombatAlienBuyMenu.kCornerHeights.BottomLeft, 0))
    bottomLeftCorner:SetTexture(CPPGUICombatAlienBuyMenu.kBuyMenuTexture)
    bottomLeftCorner:SetTexturePixelCoordinates(GUIUnpackCoords(CPPGUICombatAlienBuyMenu.kCornerTextureCoordinates.BottomLeft))
    bottomLeftCorner:SetShader("shaders/GUIWavyNoMask.surface_shader")
    self.backgroundCenteredArea:AddChild(bottomLeftCorner)
    self.corners.BottomLeft = bottomLeftCorner

    local topRightCorner = GUIManager:CreateGraphicItem()
    topRightCorner:SetAnchor(GUIItem.Right, GUIItem.Top)
    topRightCorner:SetPosition(Vector(-CPPGUICombatAlienBuyMenu.kCornerWidths.TopRight, 0, 0))
    topRightCorner:SetSize(Vector(CPPGUICombatAlienBuyMenu.kCornerWidths.TopRight, CPPGUICombatAlienBuyMenu.kCornerHeights.TopRight, 0))
    topRightCorner:SetTexture(CPPGUICombatAlienBuyMenu.kBuyMenuTexture)
    topRightCorner:SetTexturePixelCoordinates(GUIUnpackCoords(CPPGUICombatAlienBuyMenu.kCornerTextureCoordinates.TopRight))
    topRightCorner:SetShader("shaders/GUIWavyNoMask.surface_shader")
    self.backgroundCenteredArea:AddChild(topRightCorner)
    self.corners.TopRight = topRightCorner

    local bottomRightCorner = GUIManager:CreateGraphicItem()
    bottomRightCorner:SetAnchor(GUIItem.Right, GUIItem.Bottom)
    bottomRightCorner:SetPosition(Vector(-CPPGUICombatAlienBuyMenu.kCornerWidths.BottomRight, -CPPGUICombatAlienBuyMenu.kCornerHeights.BottomRight, 0))
    bottomRightCorner:SetSize(Vector(CPPGUICombatAlienBuyMenu.kCornerWidths.BottomRight, CPPGUICombatAlienBuyMenu.kCornerHeights.BottomRight, 0))
    bottomRightCorner:SetTexture(CPPGUICombatAlienBuyMenu.kBuyMenuTexture)
    bottomRightCorner:SetTexturePixelCoordinates(GUIUnpackCoords(CPPGUICombatAlienBuyMenu.kCornerTextureCoordinates.BottomRight))
    bottomRightCorner:SetShader("shaders/GUIWavyNoMask.surface_shader")
    self.backgroundCenteredArea:AddChild(bottomRightCorner)
    self.corners.BottomRight = bottomRightCorner

    self.cornerTweeners = { }
    for cornerName, _ in pairs(self.corners) do
        self.cornerTweeners[cornerName] = Tweener("loopforward")
        self.cornerTweeners[cornerName].add(CPPGUICombatAlienBuyMenu.kCornerPulseTime, { percent = 1 }, Easing.linear)
        self.cornerTweeners[cornerName].add(CPPGUICombatAlienBuyMenu.kCornerPulseTime, { percent = 0 }, Easing.linear)
    end

end

function CPPGUICombatAlienBuyMenu:_InitializeHeader()

    local player = Client.GetLocalPlayer()

    local logo = GUIManager:CreateGraphicItem()
    logo:SetSize(Vector(CPPGUICombatAlienBuyMenu.kLogoSize, CPPGUICombatAlienBuyMenu.kLogoSize, 0))
    logo:SetAnchor(GUIItem.Left, GUIItem.Top)
    logo:SetPosition(Vector(20, 20, 0))
    logo:SetTexture(CPPGUICombatAlienBuyMenu.kAlienLogoTexture)
    self.backgroundCenteredArea:AddChild(logo)

    local titleShadow = GUIManager:CreateTextItem()
    titleShadow:SetAnchor(GUIItem.Left, GUIItem.Top)
    titleShadow:SetPosition(CPPGUICombatAlienBuyMenu.kTitleOffset)
    titleShadow:SetFontName(CPPGUICombatAlienBuyMenu.kTitleFont)
    titleShadow:SetScale(GetScaledVector())
    GUIMakeFontScale(titleShadow)
    titleShadow:SetTextAlignmentX(GUIItem.Align_Min)
    titleShadow:SetTextAlignmentY(GUIItem.Align_Min)
    titleShadow:SetText("Evolution Chamber")
    titleShadow:SetColor(Color(0, 0, 0, 1))
    self.backgroundCenteredArea:AddChild(titleShadow)

    local title = GUIManager:CreateTextItem()
    title:SetAnchor(GUIItem.Left, GUIItem.Top)
    title:SetPosition(Vector(-2, -2, 0))
    title:SetFontName(CPPGUICombatAlienBuyMenu.kTitleFont)
    title:SetScale(GetScaledVector())
    GUIMakeFontScale(title)
    title:SetTextAlignmentX(GUIItem.Align_Min)
    title:SetTextAlignmentY(GUIItem.Align_Min)
    title:SetText("Evolution Chamber")
    title:SetColor(ColorIntToColor(kAlienTeamColor))
    titleShadow:AddChild(title)

    local resIcon = GUIManager:CreateGraphicItem()
    resIcon:SetSize(Vector(CPPGUICombatAlienBuyMenu.kResourceIconWidth, CPPGUICombatAlienBuyMenu.kResourceIconHeight, 0))
    resIcon:SetAnchor(GUIItem.Left, GUIItem.Top)
    resIcon:SetPosition(CPPGUICombatAlienBuyMenu.kResIconOffset)
    resIcon:SetTexture(CPPGUICombatAlienBuyMenu.kResourceIconTexture)
    resIcon:SetColor(ColorIntToColor(kAlienTeamColor))
    self.backgroundCenteredArea:AddChild(resIcon)

    local skillPointText = GUIManager:CreateTextItem()
    skillPointText:SetAnchor(GUIItem.Right, GUIItem.Center)
    skillPointText:SetPosition(Vector(6, 0, 0))
    skillPointText:SetFontName(CPPGUICombatAlienBuyMenu.kHeaderAltFont)
    skillPointText:SetScale(GetScaledVector())
    GUIMakeFontScale(skillPointText)
    skillPointText:SetTextAlignmentX(GUIItem.Align_Min)
    skillPointText:SetTextAlignmentY(GUIItem.Align_Center)
    skillPointText:SetColor(ColorIntToColor(kAlienTeamColor))

    -- update skill point text
    if player.combatSkillPoints == 1 then
        skillPointText:SetText(string.format("%s Skill Point", player.combatSkillPoints))
    else
        skillPointText:SetText(string.format("%s Skill Points", player.combatSkillPoints))
    end

    resIcon:AddChild(skillPointText)

end

function CPPGUICombatAlienBuyMenu:_InitializeMouseOverInfo()

    self.mouseOverPanel = GUIManager:CreateGraphicItem()
    self.mouseOverPanel:SetAnchor(GUIItem.Right, GUIItem.Top)
    self.mouseOverPanel:SetSize(Vector(262, 222, 0))
    self.mouseOverPanel:SetPosition(Vector(-620, 20, 0))
    self.mouseOverPanel:SetTexture(CPPGUICombatAlienBuyMenu.KCurrentEvoBorderTexture)
    self.mouseOverPanel:SetTexturePixelCoordinates(474, 348, 736, 570)
    self.mouseOverPanel:SetColor(Color(1.0, 1.0, 1.0, 0.6))
    self.backgroundCenteredArea:AddChild(self.mouseOverPanel)

    self.mouseOverTitleShadow = GUIManager:CreateTextItem()
    self.mouseOverTitleShadow:SetAnchor(GUIItem.Left, GUIItem.Top)
    self.mouseOverTitleShadow:SetPosition(CPPGUICombatAlienBuyMenu.kMouseOverTitleOffset)
    self.mouseOverTitleShadow:SetFontName(CPPGUICombatAlienBuyMenu.kHeaderFont)
    self.mouseOverTitleShadow:SetFontIsBold(true)
    self.mouseOverTitleShadow:SetScale(GetScaledVector())
    GUIMakeFontScale(self.mouseOverTitleShadow)
    self.mouseOverTitleShadow:SetTextAlignmentX(GUIItem.Align_Min)
    self.mouseOverTitleShadow:SetTextAlignmentY(GUIItem.Align_Min)
    self.mouseOverTitleShadow:SetColor(Color(0, 0, 0, 1))
    self.mouseOverPanel:AddChild(self.mouseOverTitleShadow)

    self.mouseOverTitle = GUIManager:CreateTextItem()
    self.mouseOverTitle:SetAnchor(GUIItem.Left, GUIItem.Top)
    self.mouseOverTitle:SetPosition(Vector(-2, -2, 0))
    self.mouseOverTitle:SetFontName(CPPGUICombatAlienBuyMenu.kHeaderFont)
    self.mouseOverTitle:SetFontIsBold(true)
    self.mouseOverTitle:SetScale(GetScaledVector())
    GUIMakeFontScale(self.mouseOverTitle)
    self.mouseOverTitle:SetTextAlignmentX(GUIItem.Align_Min)
    self.mouseOverTitle:SetTextAlignmentY(GUIItem.Align_Min)
    self.mouseOverTitle:SetColor(CPPGUICombatAlienBuyMenu.kTextColor)
    self.mouseOverTitleShadow:AddChild(self.mouseOverTitle)

    self.mouseOverInfo = GUIManager:CreateTextItem()
    self.mouseOverInfo:SetAnchor(GUIItem.Left, GUIItem.Top)
    self.mouseOverInfo:SetPosition(CPPGUICombatAlienBuyMenu.kMouseOverInfoOffset)
    self.mouseOverInfo:SetFontName(kFontSmall)
    self.mouseOverInfo:SetScale(GetScaledVector())
    GUIMakeFontScale(self.mouseOverInfo)
    self.mouseOverInfo:SetTextAlignmentX(GUIItem.Align_Min)
    self.mouseOverInfo:SetTextAlignmentY(GUIItem.Align_Min)
    self.mouseOverInfo:SetColor(ColorIntToColor(kAlienTeamColor))
    self.mouseOverPanel:AddChild(self.mouseOverInfo)

    self.mouseOverInfoResIcon = GUIManager:CreateGraphicItem()
    self.mouseOverInfoResIcon:SetSize(Vector(CPPGUICombatAlienBuyMenu.kResourceIconWidthSm, CPPGUICombatAlienBuyMenu.kResourceIconHeightSm, 0))
    self.mouseOverInfoResIcon:SetAnchor(GUIItem.Right, GUIItem.Top)
    self.mouseOverInfoResIcon:SetPosition(CPPGUICombatAlienBuyMenu.kMouseOverInfoResIconOffset)
    self.mouseOverInfoResIcon:SetTexture(CPPGUICombatAlienBuyMenu.kResourceIconTexture)
    self.mouseOverInfoResIcon:SetColor(kIconColors[kAlienTeamType])
    self.mouseOverInfoResIcon:SetInheritsParentScaling(false)
    self.mouseOverPanel:AddChild(self.mouseOverInfoResIcon)

    self.costText = GUIManager:CreateTextItem()
    self.costText:SetAnchor(GUIItem.Right, GUIItem.Top)
    self.costText:SetPosition(CPPGUICombatAlienBuyMenu.kMouseOverCostOffset)
    self.costText:SetFontName(kFont)
    self.costText:SetScale(GetScaledVector())
    GUIMakeFontScale(self.costText)
    self.costText:SetTextAlignmentX(GUIItem.Align_Min)
    self.costText:SetTextAlignmentY(GUIItem.Align_Min)
    self.costText:SetColor(ColorIntToColor(kAlienTeamColor))
    self.costText:SetText("1")
    self.mouseOverPanel:AddChild(self.costText)

    -- Create health and armor icons and text
    self.mouseOverInfoHealthIcon = GUIManager:CreateGraphicItem()
    self.mouseOverInfoHealthIcon:SetSize(Vector(CPPGUICombatAlienBuyMenu.kResourceIconWidthSm, CPPGUICombatAlienBuyMenu.kResourceIconHeightSm, 0))
    self.mouseOverInfoHealthIcon:SetAnchor(GUIItem.Right, GUIItem.Top)
    self.mouseOverInfoHealthIcon:SetInheritsParentScaling(false)
    self.mouseOverInfoHealthIcon:SetPosition(CPPGUICombatAlienBuyMenu.kStatsPadding + CPPGUICombatAlienBuyMenu.kStatsPaddingY)
    self.mouseOverInfoHealthIcon:SetTexture(CPPGUICombatAlienBuyMenu.kBuyMenuTexture)
    self.mouseOverInfoHealthIcon:SetTexturePixelCoordinates(GUIUnpackCoords(CPPGUICombatAlienBuyMenu.kHealthIconTextureCoordinates))
    self.mouseOverTitleShadow:AddChild(self.mouseOverInfoHealthIcon)

    self.mouseOverInfoHealthAmount = GUIManager:CreateTextItem()
    self.mouseOverInfoHealthAmount:SetAnchor(GUIItem.Right, GUIItem.Top)
    self.mouseOverInfoHealthAmount:SetFontName(kFont)
    self.mouseOverInfoHealthAmount:SetScale(GetScaledVector())
    GUIMakeFontScale(self.mouseOverInfoHealthAmount)
    self.mouseOverInfoHealthAmount:SetTextAlignmentX(GUIItem.Align_Min)
    self.mouseOverInfoHealthAmount:SetTextAlignmentY(GUIItem.Align_Min)
    self.mouseOverInfoHealthAmount:SetPosition(CPPGUICombatAlienBuyMenu.kStatsPadding)
    self.mouseOverInfoHealthAmount:SetColor(ColorIntToColor(kAlienTeamColor))
    self.mouseOverInfoHealthIcon:AddChild(self.mouseOverInfoHealthAmount)

    self.mouseOverInfoArmorIcon = GUIManager:CreateGraphicItem()
    self.mouseOverInfoArmorIcon:SetSize(Vector(CPPGUICombatAlienBuyMenu.kResourceIconWidthSm, CPPGUICombatAlienBuyMenu.kResourceIconHeightSm, 0))
    self.mouseOverInfoArmorIcon:SetAnchor(GUIItem.Right, GUIItem.Top)
    self.mouseOverInfoArmorIcon:SetPosition(CPPGUICombatAlienBuyMenu.kStatsPadding)
    self.mouseOverInfoArmorIcon:SetTexture(CPPGUICombatAlienBuyMenu.kBuyMenuTexture)
    self.mouseOverInfoArmorIcon:SetTexturePixelCoordinates(GUIUnpackCoords(CPPGUICombatAlienBuyMenu.kArmorIconTextureCoordinates))
    self.mouseOverInfoArmorIcon:SetInheritsParentScaling(false)
    self.mouseOverInfoHealthAmount:AddChild(self.mouseOverInfoArmorIcon)

    self.mouseOverInfoArmorAmount = GUIManager:CreateTextItem()
    self.mouseOverInfoArmorAmount:SetAnchor(GUIItem.Right, GUIItem.Top)
    self.mouseOverInfoArmorAmount:SetFontName(kFont)
    self.mouseOverInfoArmorAmount:SetScale(GetScaledVector())
    GUIMakeFontScale(self.mouseOverInfoArmorAmount)
    self.mouseOverInfoArmorAmount:SetTextAlignmentX(GUIItem.Align_Min)
    self.mouseOverInfoArmorAmount:SetTextAlignmentY(GUIItem.Align_Min)
    self.mouseOverInfoArmorAmount:SetPosition(CPPGUICombatAlienBuyMenu.kStatsPadding)
    self.mouseOverInfoArmorAmount:SetColor(ColorIntToColor(kAlienTeamColor))
    self.mouseOverInfoArmorIcon:AddChild(self.mouseOverInfoArmorAmount)

end

function CPPGUICombatAlienBuyMenu:_InitializeCurrentEvolutionDisplay()

    local border = GUIManager:CreateGraphicItem()
    border:SetAnchor(GUIItem.Right, GUIItem.Top)
    border:SetSize(CPPGUICombatAlienBuyMenu.kCurrentEvoBorderSize)
    border:SetPosition(CPPGUICombatAlienBuyMenu.kCurrentEvoBorderOffset)
    border:SetTexture(CPPGUICombatAlienBuyMenu.KCurrentEvoBorderTexture)
    border:SetTexturePixelCoordinates(474, 348, 736, 570)
    border:SetColor(Color(1.0, 1.0, 1.0, 0.6))
    self.backgroundCenteredArea:AddChild(border)

    local headerTextShadow = GUIManager:CreateTextItem()
    headerTextShadow:SetAnchor(GUIItem.Left, GUIItem.Top)
    headerTextShadow:SetPosition(CPPGUICombatAlienBuyMenu.kCurrentEvoTitleOffset)
    headerTextShadow:SetFontName(CPPGUICombatAlienBuyMenu.kHeaderFont)
    headerTextShadow:SetFontIsBold(true)
    headerTextShadow:SetScale(GetScaledVector())
    GUIMakeFontScale(headerTextShadow)
    headerTextShadow:SetTextAlignmentX(GUIItem.Align_Min)
    headerTextShadow:SetTextAlignmentY(GUIItem.Align_Min)
    headerTextShadow:SetColor(Color(0, 0, 0, 1))
    headerTextShadow:SetText("Current Evolution")
    border:AddChild(headerTextShadow)

    local headerText = GUIManager:CreateTextItem()
    headerText:SetAnchor(GUIItem.Left, GUIItem.Top)
    headerText:SetPosition(Vector(-2, -2, 0))
    headerText:SetFontName(CPPGUICombatAlienBuyMenu.kHeaderFont)
    headerText:SetFontIsBold(true)
    headerText:SetScale(GetScaledVector())
    GUIMakeFontScale(headerText)
    headerText:SetTextAlignmentX(GUIItem.Align_Min)
    headerText:SetTextAlignmentY(GUIItem.Align_Min)
    headerText:SetColor(CPPGUICombatAlienBuyMenu.kTextColor)
    headerText:SetText("Current Evolution")
    headerTextShadow:AddChild(headerText)

    -- The alien icon
    local alienType = CPPGUICombatAlienBuyMenu.kAlienTypes[self.selectedAlienType]
    local alienGraphicItem = GUIManager:CreateGraphicItem()
    local ARAdjustedHeight = (alienType.Height / alienType.Width) * CPPGUICombatAlienBuyMenu.kAlienIconSize
    alienGraphicItem:SetSize(Vector(CPPGUICombatAlienBuyMenu.kAlienIconSize, ARAdjustedHeight, 0))
    alienGraphicItem:SetAnchor(GUIItem.Left, GUIItem.Bottom)
    alienGraphicItem:SetPosition(Vector(0, 0, 0))
    alienGraphicItem:SetTexture("ui/" .. alienType.Name .. ".dds")
    headerTextShadow:AddChild(alienGraphicItem)

    local biomassIcon = GUIManager:CreateGraphicItem()
    biomassIcon:SetAnchor(GUIItem.Right, GUIItem.Top)
    biomassIcon:SetSize(CPPGUICombatAlienBuyMenu.kBiomassIconSize)
    biomassIcon:SetPosition(CPPGUICombatAlienBuyMenu.kBiomassIconOffset)
    biomassIcon:SetTexture(CPPGUICombatAlienBuyMenu.kBuyHUDTexture)
    biomassIcon:SetTexturePixelCoordinates(GUIUnpackCoords(GetTextureCoordinatesForIcon(kTechId.BioMassOne)))
    biomassIcon:SetColor(kIconColors[kAlienTeamType])
    border:AddChild(biomassIcon)

    local biomassLevelTextShadow = GUIManager:CreateTextItem()
    biomassLevelTextShadow:SetAnchor(GUIItem.Middle, GUIItem.Center)
    biomassLevelTextShadow:SetPosition(Vector(-4, -12, 0))
    biomassLevelTextShadow:SetFontName(kFont)
    biomassLevelTextShadow:SetScale(GetScaledVector())
    GUIMakeFontScale(biomassLevelTextShadow)
    biomassLevelTextShadow:SetTextAlignmentX(GUIItem.Align_Min)
    biomassLevelTextShadow:SetTextAlignmentY(GUIItem.Align_Min)
    biomassLevelTextShadow:SetColor(Color(0, 0, 0, 1))
    biomassLevelTextShadow:SetText("1")
    biomassIcon:AddChild(biomassLevelTextShadow)

    local biomassLevelText = GUIManager:CreateTextItem()
    biomassLevelText:SetAnchor(GUIItem.Left, GUIItem.Top)
    biomassLevelText:SetPosition(Vector(-2, -2, 0))
    biomassLevelText:SetFontName(kFont)
    biomassLevelText:SetScale(GetScaledVector())
    GUIMakeFontScale(biomassLevelText)
    biomassLevelText:SetTextAlignmentX(GUIItem.Align_Min)
    biomassLevelText:SetTextAlignmentY(GUIItem.Align_Min)
    biomassLevelText:SetColor(Color(1, 1, 1, 1))
    biomassLevelText:SetText("1")
    biomassLevelTextShadow:AddChild(biomassLevelText)

end

function CPPGUICombatAlienBuyMenu:_InitializeLifeforms()

    local headerTextShadow = GUIManager:CreateTextItem()
    headerTextShadow:SetAnchor(GUIItem.Left, GUIItem.Top)
    headerTextShadow:SetPosition(CPPGUICombatAlienBuyMenu.kLifeformsTitleOffset)
    headerTextShadow:SetFontName(CPPGUICombatAlienBuyMenu.kHeaderFont)
    headerTextShadow:SetFontIsBold(true)
    headerTextShadow:SetScale(GetScaledVector())
    GUIMakeFontScale(headerTextShadow)
    headerTextShadow:SetTextAlignmentX(GUIItem.Align_Min)
    headerTextShadow:SetTextAlignmentY(GUIItem.Align_Center)
    headerTextShadow:SetColor(Color(0, 0, 0, 1))
    headerTextShadow:SetText("Lifeforms")
    self.backgroundCenteredArea:AddChild(headerTextShadow)

    local headerText = GUIManager:CreateTextItem()
    headerText:SetAnchor(GUIItem.Left, GUIItem.Top)
    headerText:SetPosition(Vector(-2, -2, 0))
    headerText:SetFontName(CPPGUICombatAlienBuyMenu.kHeaderFont)
    headerText:SetFontIsBold(true)
    headerText:SetScale(GetScaledVector())
    GUIMakeFontScale(headerText)
    headerText:SetTextAlignmentX(GUIItem.Align_Min)
    headerText:SetTextAlignmentY(GUIItem.Align_Center)
    headerText:SetColor(CPPGUICombatAlienBuyMenu.kTextColor)
    headerText:SetText("Lifeforms")
    headerTextShadow:AddChild(headerText)

end

local function CreateAbilityIcon(self, alienGraphicItem, techId)

    local graphicItem = GetGUIManager():CreateGraphicItem()
    graphicItem:SetTexture(CPPGUICombatAlienBuyMenu.kAbilityIcons)
    graphicItem:SetSize(Vector(CPPGUICombatAlienBuyMenu.kUpgradeButtonSize, CPPGUICombatAlienBuyMenu.kUpgradeButtonSize, 0))
    graphicItem:SetAnchor(GUIItem.Middle, GUIItem.Bottom)
    graphicItem:SetTexturePixelCoordinates(GUIUnpackCoords(GetTextureCoordinatesForIcon(techId, false)))
    graphicItem:SetColor(kIconColors[kAlienTeamType])

    local highLight = GetGUIManager():CreateGraphicItem()
    highLight:SetSize(Vector(CPPGUICombatAlienBuyMenu.kUpgradeButtonSize, CPPGUICombatAlienBuyMenu.kUpgradeButtonSize, 0))
    highLight:SetIsVisible(false)
    highLight:SetTexture(CPPGUICombatAlienBuyMenu.kBuyMenuTexture)
    highLight:SetTexturePixelCoordinates(GUIUnpackCoords(CPPGUICombatAlienBuyMenu.kUpgradeButtonBackgroundTextureCoordinates))

    graphicItem:AddChild(highLight)
    alienGraphicItem:AddChild(graphicItem)

    return { Icon = graphicItem, TechId = techId, HighLight = highLight }

end

local function CreateAbilityIcons(self, alienGraphicItem, alienType)

    local lifeFormTechId = IndexToAlienTechId(alienType.Index)
    local availableAbilities = {}

    local excludeTechIds =
    {
        [kTechId.Web] = true,
        [kTechId.Babbler] = true,
        [kTechId.GorgeTunnel] = true
    }

    for k, abilityTechId in ipairs(GetTechForCategory(lifeFormTechId)) do

        if not excludeTechIds[abilityTechId] then
            table.insert(availableAbilities, abilityTechId)
        end

    end

    local numAbilities = #availableAbilities
    local totalWidth = numAbilities * (CPPGUICombatAlienBuyMenu.kUpgradeButtonSize + 10)

    for i = 1, numAbilities do

        local techId = availableAbilities[#availableAbilities - i + 1]
        local ability = CreateAbilityIcon(self, alienGraphicItem, techId)
        local xPos = ( ( (i - 1) * CPPGUICombatAlienBuyMenu.kUpgradeButtonSize ) + 10 ) - (totalWidth / 2)
        local yPos = 10

        ability.Icon:SetPosition(Vector(xPos, yPos, 0))
        table.insert(self.abilityIcons, ability)

    end

end

function CPPGUICombatAlienBuyMenu:_InitializeAlienButtons()

    self.alienButtons = { }

    for k, alienType in ipairs(CPPGUICombatAlienBuyMenu.kAlienTypes) do

        -- The alien image.
        local alienGraphicItem = GUIManager:CreateGraphicItem()
        local ARAdjustedHeight = (alienType.Height / alienType.Width) * CPPGUICombatAlienBuyMenu.kAlienButtonSize
        alienGraphicItem:SetSize(Vector(CPPGUICombatAlienBuyMenu.kAlienButtonSize, ARAdjustedHeight, 0))
        alienGraphicItem:SetAnchor(GUIItem.Middle, GUIItem.Center)
        alienGraphicItem:SetPosition(Vector(-CPPGUICombatAlienBuyMenu.kAlienButtonSize / 2, -ARAdjustedHeight / 2, 0))
        alienGraphicItem:SetTexture("ui/" .. alienType.Name .. ".dds")

        -- Create the text that indicates how many players are playing as a specific alien type.
        local playersText = GUIManager:CreateTextItem()
        playersText:SetAnchor(GUIItem.Right, GUIItem.Bottom)
        playersText:SetFontName(kFont)
        playersText:SetScale(GetScaledVector())
        GUIMakeFontScale(playersText)
        playersText:SetTextAlignmentX(GUIItem.Align_Max)
        playersText:SetTextAlignmentY(GUIItem.Align_Min)
        playersText:SetText("x" .. ToString(ScoreboardUI_GetNumberOfAliensByType(alienType.Name)))
        playersText:SetColor(ColorIntToColor(kAlienTeamColor))
        playersText:SetPosition(Vector(0, -CPPGUICombatAlienBuyMenu.kPlayersTextSize, 0))
        alienGraphicItem:AddChild(playersText)

        -- Create the selected background item for this alien item.
        local selectedBackground = GUIManager:CreateGraphicItem()
        selectedBackground:SetAnchor(GUIItem.Middle, GUIItem.Center)
        selectedBackground:SetSize(Vector(CPPGUICombatAlienBuyMenu.kAlienSelectedButtonSize, CPPGUICombatAlienBuyMenu.kAlienSelectedButtonSize, 0))
        selectedBackground:SetTexture(CPPGUICombatAlienBuyMenu.kAlienSelectedBackground)
        -- Hide the selected background for now.
        selectedBackground:SetColor(Color(1, 1, 1, 0))
        selectedBackground:AddChild(alienGraphicItem)

        table.insert(self.alienButtons, { TypeData = alienType, Button = alienGraphicItem, SelectedBackground = selectedBackground, PlayersText = playersText, ARAdjustedHeight = ARAdjustedHeight })

        CreateAbilityIcons(self, alienGraphicItem, alienType)

        self.backgroundCenteredArea:AddChild(selectedBackground)

    end

    self:_UpdateAlienButtons()

end

function CPPGUICombatAlienBuyMenu:_InitializeUpgrades()

    local categories =
    {
        kTechId.ShiftHive,
        kTechId.ShadeHive,
        kTechId.CragHive
    }

    self.upgradeButtons = { }

    local binSize = (self.backgroundCenteredArea:GetSize().x - (CPPGUICombatAlienBuyMenu.kUpgradesTitleOffest.x * 2)) / #categories

    local headerTextShadow = GUIManager:CreateTextItem()
    headerTextShadow:SetAnchor(GUIItem.Left, GUIItem.Top)
    headerTextShadow:SetPosition(CPPGUICombatAlienBuyMenu.kUpgradesTitleOffest)
    headerTextShadow:SetFontName(CPPGUICombatAlienBuyMenu.kHeaderFont)
    headerTextShadow:SetFontIsBold(true)
    headerTextShadow:SetScale(GetScaledVector())
    GUIMakeFontScale(headerTextShadow)
    headerTextShadow:SetTextAlignmentX(GUIItem.Align_Min)
    headerTextShadow:SetTextAlignmentY(GUIItem.Align_Center)
    headerTextShadow:SetColor(Color(0, 0, 0, 1))
    headerTextShadow:SetText("Upgrades")
    self.backgroundCenteredArea:AddChild(headerTextShadow)

    local headerText = GUIManager:CreateTextItem()
    headerText:SetAnchor(GUIItem.Left, GUIItem.Top)
    headerText:SetPosition(Vector(-2, -2, 0))
    headerText:SetFontName(CPPGUICombatAlienBuyMenu.kHeaderFont)
    headerText:SetFontIsBold(true)
    headerText:SetScale(GetScaledVector())
    GUIMakeFontScale(headerText)
    headerText:SetTextAlignmentX(GUIItem.Align_Min)
    headerText:SetTextAlignmentY(GUIItem.Align_Center)
    headerText:SetColor(CPPGUICombatAlienBuyMenu.kTextColor)
    headerText:SetText("Upgrades")
    headerTextShadow:AddChild(headerText)

    for i = 1, #categories do

        local upgrades = AlienUI_GetUpgradesForCategory(categories[i])
        local xOffsetText = (i - 1) * binSize

        local categoryText = GUIManager:CreateTextItem()
        categoryText:SetAnchor(GUIItem.Left, GUIItem.Top)
        categoryText:SetPosition(Vector(xOffsetText + (binSize / 2), 100, 0))
        categoryText:SetFontName(CPPGUICombatAlienBuyMenu.kSubHeaderFont)
        categoryText:SetFontIsBold(true)
        categoryText:SetScale(GetScaledVector())
        GUIMakeFontScale(categoryText)
        categoryText:SetTextAlignmentX(GUIItem.Align_Center)
        categoryText:SetTextAlignmentY(GUIItem.Align_Center)
        categoryText:SetColor(CPPGUICombatAlienBuyMenu.kTextColor)
        categoryText:SetText(GetDisplayNameForTechId(categories[i]))
        headerTextShadow:AddChild(categoryText)

        local totalWidth = #upgrades * (CPPGUICombatAlienBuyMenu.kUpgradeButtonSize + 20)

        for upgradeIndex = 1, #upgrades do

            local techId = upgrades[upgradeIndex]
            
            -- Every upgrade has an icon.
            local buttonIcon = GUIManager:CreateGraphicItem()

            local iconX, iconY = GetMaterialXYOffset(techId, false)
            iconX = iconX * CPPGUICombatAlienBuyMenu.kUpgradeButtonTextureSize
            iconY = iconY * CPPGUICombatAlienBuyMenu.kUpgradeButtonTextureSize

            local xPos = ((upgradeIndex - 1) * (CPPGUICombatAlienBuyMenu.kUpgradeButtonSize + 20 )) - (totalWidth / 2) - 20
            local yPos = -80

            buttonIcon:SetAnchor(GUIItem.Middle, GUIItem.Center)
            buttonIcon:SetSize(Vector(CPPGUICombatAlienBuyMenu.kUpgradeButtonSize, CPPGUICombatAlienBuyMenu.kUpgradeButtonSize, 0))
            buttonIcon:SetPosition(Vector(xPos, yPos, 0))
            buttonIcon:SetTexture(CPPGUICombatAlienBuyMenu.kBuyHUDTexture)
            buttonIcon:SetTexturePixelCoordinates(iconX, iconY, iconX + CPPGUICombatAlienBuyMenu.kUpgradeButtonTextureSize, iconY + CPPGUICombatAlienBuyMenu.kUpgradeButtonTextureSize)
            categoryText:AddChild(buttonIcon)

            local purchased = AlienBuy_GetUpgradePurchased(techId)

            table.insert(self.upgradeButtons, { Background = nil, Icon = buttonIcon, TechId = techId, Category = categories[i],
                Selected = purchased, SelectedMovePercent = 0, Cost = 0, Purchased = purchased, Index = nil })

        end

    end

end

function CPPGUICombatAlienBuyMenu:_InitializeEvolvePanel()

    self.evolveQueue = { }
    self.evolveQueueIndex = 1

    local panel = GUIManager:CreateGraphicItem()
    panel:SetAnchor(GUIItem.Left, GUIItem.Bottom)
    panel:SetSize(CPPGUICombatAlienBuyMenu.kEvolvePanelSize)
    panel:SetPosition(CPPGUICombatAlienBuyMenu.kEvolvePanelOffset)
    panel:SetTexture(CPPGUICombatAlienBuyMenu.kEvolvePanelBkgTexture)
    panel:SetColor(Color(1.0, 1.0, 1.0, 0.6))
    self.backgroundCenteredArea:AddChild(panel)

    local headerTextShadow = GUIManager:CreateTextItem()
    headerTextShadow:SetAnchor(GUIItem.Left, GUIItem.Top)
    headerTextShadow:SetPosition(CPPGUICombatAlienBuyMenu.kEvolveTitleOffset)
    headerTextShadow:SetFontName(CPPGUICombatAlienBuyMenu.kHeaderFont)
    headerTextShadow:SetFontIsBold(true)
    headerTextShadow:SetScale(GetScaledVector())
    GUIMakeFontScale(headerTextShadow)
    headerTextShadow:SetTextAlignmentX(GUIItem.Align_Min)
    headerTextShadow:SetTextAlignmentY(GUIItem.Align_Min)
    headerTextShadow:SetColor(Color(0, 0, 0, 1))
    headerTextShadow:SetText("Evolve To")
    panel:AddChild(headerTextShadow)

    local headerText = GUIManager:CreateTextItem()
    headerText:SetAnchor(GUIItem.Left, GUIItem.Top)
    headerText:SetPosition(Vector(-2, -2, 0))
    headerText:SetFontName(CPPGUICombatAlienBuyMenu.kHeaderFont)
    headerText:SetFontIsBold(true)
    headerText:SetScale(GetScaledVector())
    GUIMakeFontScale(headerText)
    headerText:SetTextAlignmentX(GUIItem.Align_Min)
    headerText:SetTextAlignmentY(GUIItem.Align_Min)
    headerText:SetColor(CPPGUICombatAlienBuyMenu.kTextColor)
    headerText:SetText("Evolve To")
    headerTextShadow:AddChild(headerText)

    for i = 1, 8 do

        local upgradeIcon = GUIManager:CreateGraphicItem()
        upgradeIcon:SetAnchor(GUIItem.Left, GUIItem.Top)
        upgradeIcon:SetSize(Vector(CPPGUICombatAlienBuyMenu.kEvolveIconSize, CPPGUICombatAlienBuyMenu.kEvolveIconSize, 0))
        upgradeIcon:SetPosition(Vector((CPPGUICombatAlienBuyMenu.kEvolveUpgradePadding + CPPGUICombatAlienBuyMenu.kEvolveIconSize) * (i - 1), 0, 0) + CPPGUICombatAlienBuyMenu.kEvolveLifeformIconOffset)
        upgradeIcon:SetColor(Color(kIconColors[kAlienTeamType]))
        panel:AddChild(upgradeIcon)

        local closeBtn = GUIManager:CreateGraphicItem()
        closeBtn:SetAnchor(GUIItem.Right, GUIItem.Top)
        closeBtn:SetSize(Vector(CPPGUICombatAlienBuyMenu.kCloseIconSize, CPPGUICombatAlienBuyMenu.kCloseIconSize, 0))
        closeBtn:SetPosition(Vector(-CPPGUICombatAlienBuyMenu.kCloseIconSize, 0, 0))
        closeBtn:SetTexture(CPPGUICombatAlienBuyMenu.kCloseIconTexture)
        upgradeIcon:AddChild(closeBtn)

        self.evolveQueue[i] = { TechId = kTechId.None, Cost = 0, Icon = upgradeIcon, CloseButton = closeBtn }

    end

end

function CPPGUICombatAlienBuyMenu:_InitializeEvolveButton()

    self.evolveButtonBackground = GUIManager:CreateGraphicItem()
    self.evolveButtonBackground:SetAnchor(GUIItem.Right, GUIItem.Bottom)
    self.evolveButtonBackground:SetSize(Vector(CPPGUICombatAlienBuyMenu.kEvolveButtonWidth, CPPGUICombatAlienBuyMenu.kEvolveButtonHeight, 0))
    self.evolveButtonBackground:SetPosition(Vector(-CPPGUICombatAlienBuyMenu.kEvolveButtonWidth, -CPPGUICombatAlienBuyMenu.kEvolveButtonHeight, 0) + CPPGUICombatAlienBuyMenu.kEvolveButtonOffset)
    self.evolveButtonBackground:SetTexture(CPPGUICombatAlienBuyMenu.kBuyMenuTexture)
    self.evolveButtonBackground:SetTexturePixelCoordinates(GUIUnpackCoords(CPPGUICombatAlienBuyMenu.kEvolveButtonTextureCoordinates))
    self.backgroundCenteredArea:AddChild(self.evolveButtonBackground)

    self.evolveButtonVeins = GUIManager:CreateGraphicItem()
    self.evolveButtonVeins:SetSize(Vector(CPPGUICombatAlienBuyMenu.kEvolveButtonWidth - kVeinsMargin * 2, CPPGUICombatAlienBuyMenu.kEvolveButtonHeight - kVeinsMargin * 2, 0))
    self.evolveButtonVeins:SetPosition(Vector(kVeinsMargin, kVeinsMargin, 0))
    self.evolveButtonVeins:SetTexture(CPPGUICombatAlienBuyMenu.kBuyMenuTexture)
    self.evolveButtonVeins:SetTexturePixelCoordinates(GUIUnpackCoords(CPPGUICombatAlienBuyMenu.kEvolveButtonVeinsTextureCoordinates))
    self.evolveButtonVeins:SetColor(Color(1, 1, 1, 0))
    self.evolveButtonBackground:AddChild(self.evolveButtonVeins)

    self.evolveButtonText = GUIManager:CreateTextItem()
    self.evolveButtonText:SetAnchor(GUIItem.Middle, GUIItem.Center)
    self.evolveButtonText:SetFontName(kFont)
    self.evolveButtonText:SetScale(GetScaledVector())
    GUIMakeFontScale(self.evolveButtonText)
    self.evolveButtonText:SetTextAlignmentX(GUIItem.Align_Center)
    self.evolveButtonText:SetTextAlignmentY(GUIItem.Align_Center)
    self.evolveButtonText:SetText(Locale.ResolveString("ABM_EVOLVE_FOR"))
    self.evolveButtonText:SetColor(Color(0, 0, 0, 1))
    self.evolveButtonText:SetPosition(Vector(0, 0, 0))
    self.evolveButtonVeins:AddChild(self.evolveButtonText)

    self.evolveResourceIcon = GUIManager:CreateGraphicItem()
    self.evolveResourceIcon:SetSize(Vector(CPPGUICombatAlienBuyMenu.kResourceIconWidth, CPPGUICombatAlienBuyMenu.kResourceIconHeight, 0))
    self.evolveResourceIcon:SetAnchor(GUIItem.Middle, GUIItem.Top)
    self.evolveResourceIcon:SetPosition(Vector(0, -CPPGUICombatAlienBuyMenu.kResourceIconHeight / 2, 0))
    self.evolveResourceIcon:SetTexture(CPPGUICombatAlienBuyMenu.kResourceIconTexture)
    self.evolveResourceIcon:SetColor(Color(0, 0, 0, 1))
    self.evolveResourceIcon:SetIsVisible(false)
    self.evolveResourceIcon:SetInheritsParentScaling(false)
    self.evolveButtonText:AddChild(self.evolveResourceIcon)

    self.evolveButtonResAmount = GUIManager:CreateTextItem()
    self.evolveButtonResAmount:SetAnchor(GUIItem.Right, GUIItem.Center)
    self.evolveButtonResAmount:SetPosition(Vector(0, 0, 0))
    self.evolveButtonResAmount:SetFontName(kFont)
    self.evolveButtonResAmount:SetScale(GetScaledVector())
    GUIMakeFontScale(self.evolveButtonResAmount)
    self.evolveButtonResAmount:SetTextAlignmentX(GUIItem.Align_Min)
    self.evolveButtonResAmount:SetTextAlignmentY(GUIItem.Align_Center)
    self.evolveButtonResAmount:SetColor(Color(0, 0, 0, 1))
    self.evolveButtonResAmount:SetInheritsParentScaling(false)
    self.evolveResourceIcon:AddChild(self.evolveButtonResAmount)

end

function CPPGUICombatAlienBuyMenu:_UpdateCorners(deltaTime)

    for _, cornerName in ipairs(self.corners) do
        self.cornerTweeners[cornerName].update(deltaTime)
        local percent = self.cornerTweeners[cornerName].getCurrentProperties().percent
        self.corners[cornerName]:SetColor(Color(1, percent, percent, math.abs(percent - 0.5) + 0.5))
    end

end

function CPPGUICombatAlienBuyMenu:_UpdateEvolvePanel()

    for i = 1, #self.evolveQueue do
        self.evolveQueue[i].Icon:SetIsVisible(false)
    end

    self.evolveQueue[1].TechId = self.kAlienTypes[self.selectedAlienType].TechId
    self.evolveQueue[1].Cost = CombatPlusPlus_GetCostByTechId(self.evolveQueue[1].TechId)

    self.evolveQueue[1].Icon:SetTexture(CPPGUICombatAlienBuyMenu.kBuyHUDTexture)
    self.evolveQueue[1].Icon:SetTexturePixelCoordinates(GUIUnpackCoords(GetTextureCoordinatesForIcon(self.kAlienTypes[self.selectedAlienType].TechId)))
    self.evolveQueue[1].Icon:SetIsVisible(true)

    local index = 2

    for k, upgradeTechId in ipairs(self.upgradeList) do

        self.evolveQueue[index].TechId = upgradeTechId
        self.evolveQueue[index].Cost = CombatPlusPlus_GetCostByTechId(upgradeTechId)

        self.evolveQueue[index].Icon:SetTexture(CPPGUICombatAlienBuyMenu.kBuyHUDTexture)
        self.evolveQueue[index].Icon:SetTexturePixelCoordinates(GUIUnpackCoords(GetTextureCoordinatesForIcon(upgradeTechId)))
        self.evolveQueue[index].Icon:SetIsVisible(true)

        index = index + 1

    end

end

function CPPGUICombatAlienBuyMenu:_UpdateAlienButtons()

    local numAlienTypes = 5
    local totalAlienButtonsWidth = CPPGUICombatAlienBuyMenu.kAlienButtonSize * numAlienTypes
    local player = Client.GetLocalPlayer()

    for k, alienButton in ipairs(self.alienButtons) do

        -- Info needed for the rest of this code.
        local itemTechId = alienButton.TypeData.TechId
        local cost = CombatPlusPlus_GetCostByTechId(itemTechId)
        local isCurrentAlien = AlienBuy_GetCurrentAlien() == alienButton.TypeData.Index
        local canAfford = cost <= player.combatSkillPoints
        local hasRequiredRank = CombatPlusPlus_GetRequiredRankByTechId(itemTechId) <= player.combatRank

        alienButton.Button:SetIsVisible(true)

        if hasRequiredRank and canAfford and not isCurrentAlien then
            alienButton.Button:SetColor(CPPGUICombatAlienBuyMenu.kEnabledColor)
        elseif hasRequiredRank and not canAfford then
            alienButton.Button:SetColor(CPPGUICombatAlienBuyMenu.kCannotBuyColor)
        elseif not hasRequiredRank then
            alienButton.Button:SetColor(CPPGUICombatAlienBuyMenu.kDisabledColor)
        end

        local mouseOver = self:_GetIsMouseOver(alienButton.Button)

        if mouseOver then

            local classStats = AlienBuy_GetClassStats(CPPGUICombatAlienBuyMenu.kAlienTypes[alienButton.TypeData.Index].Index)
            local mouseOverName = CPPGUICombatAlienBuyMenu.kAlienTypes[alienButton.TypeData.Index].LocaleName
            local health = classStats[2]
            local armor = classStats[3]
            self:_ShowMouseOverInfo(mouseOverName, GetTooltipInfoText(IndexToAlienTechId(alienButton.TypeData.Index)), cost, health, armor)

        end

        -- Only show the background if the mouse is over this button.
        alienButton.SelectedBackground:SetColor(Color(1, 1, 1, ((mouseOver and 1) or 0)))

        local offset = Vector(
            (((alienButton.TypeData.XPos - 1) / numAlienTypes) * (CPPGUICombatAlienBuyMenu.kAlienButtonSize * numAlienTypes)) - (totalAlienButtonsWidth / 2),
            CPPGUICombatAlienBuyMenu.kAlienButtonOffsetY,
            0
        )
        alienButton.SelectedBackground:SetPosition(Vector(-CPPGUICombatAlienBuyMenu.kAlienButtonSize / 2, -CPPGUICombatAlienBuyMenu.kAlienSelectedButtonSize / 2 - alienButton.ARAdjustedHeight / 2, 0) + offset)

        alienButton.PlayersText:SetText("x" .. ToString(ScoreboardUI_GetNumberOfAliensByType(alienButton.TypeData.Name)))

    end

end

function CPPGUICombatAlienBuyMenu:_UpdateEvolveButton()

    local player = Client.GetLocalPlayer()
    local numberOfSelectedUpgrades = GetNumberOfNewlySelectedUpgrades(self)
    local evolveButtonTextureCoords = GUIAlienBuyMenu.kEvolveButtonTextureCoordinates
    local evolveCost = GetTotalCost(self)
    local canAfford = evolveCost <= player.combatSkillPoints
    local allowedToEvolve = false
    local hasGameStarted = PlayerUI_GetHasGameStarted()
    local evolveText = Locale.ResolveString("ABM_GAME_NOT_STARTED")

    if hasGameStarted then

        evolveText = Locale.ResolveString("ABM_SELECT_UPGRADES")

        -- If the current alien is selected with no upgrades, cannot evolve.
        if self.selectedAlienType == AlienBuy_GetCurrentAlien() and numberOfSelectedUpgrades == 0 then

            evolveButtonTextureCoords = CPPGUICombatAlienBuyMenu.kEvolveButtonNeedResourcesTextureCoordinates

        elseif not canAfford then

            -- If cannot afford selected alien type and/or upgrades, cannot evolve.
            evolveButtonTextureCoords = CPPGUICombatAlienBuyMenu.kEvolveButtonNeedResourcesTextureCoordinates
            evolveText = "Need More Skill Points"

        else

            evolveText = Locale.ResolveString("ABM_EVOLVE_FOR")
            allowedToEvolve = true

        end

    end

    self.evolveButtonBackground:SetTexturePixelCoordinates(GUIUnpackCoords(evolveButtonTextureCoords))
    self.evolveButtonText:SetText(evolveText)
    self.evolveResourceIcon:SetIsVisible(evolveCost ~= nil)
    local totalEvolveButtonTextWidth = 0

    if evolveCost ~= nil then

        local evolveCostText = ToString(evolveCost)
        self.evolveButtonResAmount:SetText(evolveCostText)
        totalEvolveButtonTextWidth = totalEvolveButtonTextWidth + self.evolveResourceIcon:GetScaledSize().x + GUIScale(self.evolveButtonResAmount:GetTextWidth(evolveCostText))

    end

    self.evolveButtonText:SetPosition(Vector(-totalEvolveButtonTextWidth / 2, 0, 0))

    local veinsAlpha = 0
    self.evolveButtonBackground:SetScale(Vector(1, 1, 0))

    if allowedToEvolve then

        if self:_GetIsMouseOver(self.evolveButtonBackground) then

            veinsAlpha = 1
            self.evolveButtonBackground:SetScale(Vector(1.1, 1.1, 0))

        else
            veinsAlpha = (math.sin(Shared.GetTime() * 4) + 1) / 2
        end

    end

    self.evolveButtonVeins:SetColor(Color(1, 1, 1, veinsAlpha))

end

local function GetHasAnyCategoryUpgrade(category, player)

    local upgrades = AlienUI_GetUpgradesForCategory(category)

    for i = 1, #upgrades do

        if CombatPlusPlus_GetRequiredRankByTechId(upgrades[i]) <= player.combatRank then
            return true
        end
    end

    return false

end

local kDefaultColor = Color(kIconColors[kAlienTeamType])
local kNotAvailableColor = Color(0.0, 0.0, 0.0, 1)
local kNotAllowedColor = Color(1, 0,0,1)
local kPurchasedColor = Color(1, 0.6, 0, 1)

function CPPGUICombatAlienBuyMenu:_UpdateAbilities()

    local player = Client.GetLocalPlayer()

    for index, abilityItem in ipairs(self.abilityIcons) do

        local cost = CombatPlusPlus_GetCostByTechId(abilityItem.TechId)
        local canAfford = cost <= player.combatSkillPoints
        local hasRequiredRank = CombatPlusPlus_GetRequiredRankByTechId(abilityItem.TechId) <= player.combatRank

        if not hasRequiredRank then
            abilityItem.Icon:SetColor(kNotAvailableColor)
        elseif not canAfford then
            abilityItem.Icon:SetColor(kNotAllowedColor)
        else
            abilityItem.Icon:SetColor(kDefaultColor)
        end

        local mouseOver = self:_GetIsMouseOver(abilityItem.Icon)

        if mouseOver then

            local abilityInfoText = Locale.ResolveString(LookupTechData(abilityItem.TechId, kTechDataDisplayName, ""))
            local tooltip = Locale.ResolveString(LookupTechData(abilityItem.TechId, kTechDataTooltipInfo, ""))

            self:_ShowMouseOverInfo(abilityInfoText, tooltip, cost)

        end

    end

end

function CPPGUICombatAlienBuyMenu:_UpdateUpgrades(deltaTime)

    local categoryHasSelected = {}
    local player = Client.GetLocalPlayer()

    for i, currentButton in ipairs(self.upgradeButtons) do

        local cost = CombatPlusPlus_GetCostByTechId(currentButton.TechId)
        local canAfford = cost <= player.combatSkillPoints
        local hasRequiredRank = CombatPlusPlus_GetRequiredRankByTechId(currentButton.TechId) <= player.combatRank

        local useColor = kDefaultColor

        if currentButton.Purchased then

            useColor = kPurchasedColor

        elseif not hasRequiredRank then

            useColor = kNotAvailableColor

            -- unselect button if tech becomes unavailable
            if currentButton.Selected then
                currentButton.Selected = false
            end

        end

        currentButton.Icon:SetColor(useColor)

        if currentButton.Selected then
            categoryHasSelected[ currentButton.Category ] = true
        end

        if self:_GetIsMouseOver(currentButton.Icon) then
        
            local currentUpgradeInfoText = GetDisplayNameForTechId(currentButton.TechId)
            local tooltipText = GetTooltipInfoText(currentButton.TechId)
            local cost = CombatPlusPlus_GetCostByTechId(currentButton.TechId)
        
            self:_ShowMouseOverInfo(currentUpgradeInfoText, tooltipText, cost)
        
        end

    end

end

function CPPGUICombatAlienBuyMenu:_ShowMouseOverInfo(lifeformText, infoText, costAmount, health, armor)

    -- show the panel
    self.mouseOverPanel:SetIsVisible(true)

    self.mouseOverTitleShadow:SetText(lifeformText)
    self.mouseOverTitle:SetText(lifeformText)

    self.mouseOverInfo:SetText(infoText)
    self.mouseOverInfo:SetTextClipped(true, self.mouseOverPanel:GetSize().x - CPPGUICombatAlienBuyMenu.kMouseOverInfoOffset.x, self.mouseOverPanel:GetSize().y - CPPGUICombatAlienBuyMenu.kMouseOverInfoOffset.y)

    self.mouseOverInfoResIcon:SetIsVisible(costAmount ~= nil)

    self.mouseOverInfoHealthIcon:SetIsVisible(health ~= nil)
    self.mouseOverInfoArmorIcon:SetIsVisible(health ~= nil)

    self.mouseOverInfoHealthAmount:SetIsVisible(armor ~= nil)
    self.mouseOverInfoArmorAmount:SetIsVisible(armor ~= nil)

    if costAmount then
        self.costText:SetText(ToString(costAmount))
    end

    if health then
        self.mouseOverInfoHealthAmount:SetText(ToString(health))
    end

    if armor then
        self.mouseOverInfoArmorAmount:SetText(ToString(armor))
    end

end

function CPPGUICombatAlienBuyMenu:_HideMouseOverInfo()

    self.mouseOverPanel:SetIsVisible(false)

end

local function MarkAlreadyPurchased( self )
    local isAlreadySelectedAlien = self.selectedAlienType ~= AlienBuy_GetCurrentAlien()
    for i, currentButton in ipairs(self.upgradeButtons) do
        currentButton.Purchased = isAlreadySelectedAlien and AlienBuy_GetUpgradePurchased( currentButton.TechId )
    end
end

local function SelectButton( self, button )
    if not button.Selected then
        button.Selected = true
        table.insertunique(self.upgradeList, button.TechId)
    end
end

local function DeselectButton( self, button )
    if button.Selected then
        button.Selected = false
        table.removevalue( self.upgradeList, button.TechId )
    end
end

local function ToggleButton( self,  button )
    if button.Selected then
        DeselectButton( self, button )
    else
        SelectButton( self, button )
    end
end

function CPPGUICombatAlienBuyMenu:SetPurchasedSelected()

    for i, button in ipairs(self.upgradeButtons) do
        if button.Purchased then
            SelectButton( self, button )
        else
            DeselectButton( self, button )
        end
    end

end

function CPPGUICombatAlienBuyMenu:SendKeyEvent(key, down)

    local closeMenu = false
    local inputHandled = false

    if key == InputKey.MouseButton0 and self.mousePressed ~= down then

        self.mousePressed = down

        local mouseX, mouseY = Client.GetCursorPosScreen()
        local player = Client.GetLocalPlayer()

        if down then

            local numberOfSelectedUpgrades = GetNumberOfNewlySelectedUpgrades(self)
            local evolveCost = GetTotalCost(self)
            local canAfford = evolveCost <= player.combatSkillPoints

            local allowedToEvolve = canAfford and (self.selectedAlienType ~= AlienBuy_GetCurrentAlien() or  numberOfSelectedUpgrades > 0)
            if allowedToEvolve and self:_GetIsMouseOver(self.evolveButtonBackground) then

                local purchases = { }
                -- Buy the selected alien if we have a different one selected.
                if self.selectedAlienType ~= AlienBuy_GetCurrentAlien() then
                    table.insert(purchases, { Type = "Alien", Alien = self.selectedAlienType })
                end

                -- Buy all selected upgrades.
                for i, currentButton in ipairs(self.upgradeButtons) do

                    if currentButton.Selected then
                        table.insert(purchases, { Type = "Upgrade", Alien = self.selectedAlienType, UpgradeIndex = currentButton.Index, TechId = currentButton.TechId })
                    end

                end

                closeMenu = true
                inputHandled = true

                if #purchases > 0 then
                    Shared.Message(string.format("Purchase Count: %s", #purchases))
                    CombatPlusPlus_AlienPurchase(purchases)
                end

                AlienBuy_OnPurchase()

            end

            inputHandled = self:_HandleUpgradeClicked(mouseX, mouseY) or inputHandled

            if not inputHandled then

                -- Check if an alien was selected.
                for k, buttonItem in ipairs(self.alienButtons) do

                    local itemTechId = buttonItem.TypeData.TechId
                    local cost = CombatPlusPlus_GetCostByTechId(itemTechId)
                    local canAfford = cost <= player.combatSkillPoints
                    local hasRequiredRank = CombatPlusPlus_GetRequiredRankByTechId(itemTechId) <= player.combatRank

                    if canAfford and hasRequiredRank and self:_GetIsMouseOver(buttonItem.Button) then

                        -- Deselect all upgrades when a different alien type is selected.
                        if self.selectedAlienType ~= buttonItem.TypeData.Index then

                            AlienBuy_OnSelectAlien(CPPGUICombatAlienBuyMenu.kAlienTypes[buttonItem.TypeData.Index].Name)

                        end

                        self.selectedAlienType = buttonItem.TypeData.Index
                        MarkAlreadyPurchased( self )
                        self:SetPurchasedSelected()

                        inputHandled = true
                        break

                    end

                end

            end

        end

    end

    -- No matter what, this menu consumes MouseButton0/1 down.
    if down and (key == InputKey.MouseButton0 or key == InputKey.MouseButton1) then
        inputHandled = true
    end

    if InputKey.Escape == key and not down then

        closeMenu = true
        inputHandled = true
        AlienBuy_OnClose()

    end

    if closeMenu then

        self.closingMenu = true
        AlienBuy_OnClose()

    end

    return inputHandled

end

function CPPGUICombatAlienBuyMenu:GetCanSelect(upgradeButton, player)

    local hasRequiredRank = CombatPlusPlus_GetRequiredRankByTechId(upgradeButton.TechId) <= player.combatRank

    -- since you've already purchased it, it should be selectable
    return upgradeButton.Purchased or hasRequiredRank

end


function CPPGUICombatAlienBuyMenu:_HandleUpgradeClicked(mouseX, mouseY)

    local inputHandled = false
    local player = Client.GetLocalPlayer()

    for i, currentButton in ipairs(self.upgradeButtons) do
        -- Can't select if it has been purchased already.

        local allowedToUnselect = currentButton.Selected
        local allowedToPuchase = not currentButton.Selected and self:GetCanSelect(currentButton, player)

        if (allowedToUnselect or allowedToPuchase) and self:_GetIsMouseOver(currentButton.Icon) then

            -- Deselect or Select current button
            ToggleButton( self, currentButton )

            if currentButton.Selected then

                local hiveTypeCurrent = GetHiveTypeForUpgrade( currentButton.TechId )

                for j, otherButton in ipairs(self.upgradeButtons) do

                    if currentButton ~= otherButton and otherButton.Selected then

                        local hiveTypeOther = GetHiveTypeForUpgrade( otherButton.TechId )
                        if hiveTypeCurrent == hiveTypeOther then
                            DeselectButton( self, otherButton )
                        end

                    end

                end

                AlienBuy_OnUpgradeSelected()

            else

                AlienBuy_OnUpgradeDeselected()

            end

            inputHandled = true
            break

        end
    end

    return inputHandled

end
