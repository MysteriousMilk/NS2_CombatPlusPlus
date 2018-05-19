--[[
 * Natural Selection 2 - Combat++ Mod
 * Authors:
 *          WhiteWizard
 *
 * New GUI that appears when the aliens attempt to buy something using the 'B' key.
]]

Script.Load("lua/GUIAnimatedScript.lua")
Script.Load("lua/Combat/GUI/AnimatedTechButton.lua")

class 'AlienBuyMenu' (GUIAnimatedScript)

AlienBuyMenu.kBackgroundColor = Color(0.28, 0.17, 0.04, 0.3)
AlienBuyMenu.kBackgroundSize = Vector(1024, 1024, 0)
AlienBuyMenu.kBackgroundTexture = PrecacheAsset("ui/combatui_alienbuy_bkg.dds")

AlienBuyMenu.kBuyMenuTexture = PrecacheAsset("ui/alien_buymenu.dds")
AlienBuyMenu.kBuyMenuMaskTexture = PrecacheAsset("ui/alien_buymenu_mask.dds")
AlienBuyMenu.kBuyHUDTexture = "ui/buildmenu.dds"
AlienBuyMenu.kAbilityIcons = "ui/buildmenu.dds"
AlienBuyMenu.kAlienLogoTexture = PrecacheAsset("ui/logo_alien.dds")

AlienBuyMenu.KCurrentEvoBorderTexture = PrecacheAsset("ui/alien_commander_background.dds")
AlienBuyMenu.kEvolvePanelBkgTexture = PrecacheAsset("ui/combatui_alienbuy_evolvequeuepanel.dds")
AlienBuyMenu.kCloseIconTexture = PrecacheAsset("ui/close_icon.dds")

AlienBuyMenu.kSlotTexture = PrecacheAsset("ui/alien_buyslot.dds")
AlienBuyMenu.kSlotLockedTexture = PrecacheAsset("ui/alien_buyslot_locked.dds")

AlienBuyMenu.kBackgroundTextureCoordinates = { 9, 1, 602, 424 }

AlienBuyMenu.kAlienSelectedBackground = PrecacheAsset("ui/AlienBackground.dds")

AlienBuyMenu.kEvolveButtonNeedResourcesTextureCoordinates = { 87, 429, 396, 511 }
AlienBuyMenu.kEvolveButtonTextureCoordinates = { 396, 428, 706, 511 }
AlienBuyMenu.kEvolveButtonVeinsTextureCoordinates = { 600, 350, 915, 419 }
local kVeinsMargin = GUIScale(4)

AlienBuyMenu.kResourceIconTexture = PrecacheAsset("ui/pres_icon_big.dds")

AlienBuyMenu.kTitleFont = Fonts.kStamp_Large
AlienBuyMenu.kHeaderFont = Fonts.kStamp_Medium
AlienBuyMenu.kHeaderAltFont = Fonts.kAgencyFB_Small
AlienBuyMenu.kSubHeaderFont = Fonts.kArial_Tiny
AlienBuyMenu.kTextColor = Color(kAlienFontColor)

AlienBuyMenu.kCornerPulseTime = 4
AlienBuyMenu.kCornerTextureCoordinates = { TopLeft = { 605, 1, 765, 145 },  BottomLeft = { 605, 145, 765, 290 }, TopRight = { 765, 1, 910, 145 }, BottomRight = { 765, 145, 910, 290 } }
AlienBuyMenu.kCornerWidths = { }
AlienBuyMenu.kCornerHeights = { }

AlienBuyMenu.kMaxNumberOfUpgradeButtons = 8
AlienBuyMenu.kUpgradeButtonTextureSize = 80
AlienBuyMenu.kUpgradeButtonBackgroundTextureCoordinates = { 15, 434, 85, 505 }
AlienBuyMenu.kUpgradeButtonMoveTime = 0.5

AlienBuyMenu.kHealthIconTextureCoordinates = { 854, 318, 887, 351 }
AlienBuyMenu.kArmorIconTextureCoordinates = { 887, 318, 920, 351 }

AlienBuyMenu.kRedHighlight = Color(1, 0.3, 0.3, 1)
AlienBuyMenu.kDisabledColor = Color(0.5, 0.5, 0.5, 0.5)
AlienBuyMenu.kCannotBuyColor = Color(1, 0, 0, 0.5)
AlienBuyMenu.kEnabledColor = Color(1, 1, 1, 1)

local kLargeFont = Fonts.kAgencyFB_Large
local kFont = Fonts.kAgencyFB_Small
local kFontSmall = Fonts.kAgencyFB_Tiny

local function CreateLine(startPoint, endPoint, color)

    local delta = startPoint - endPoint
    local direction = GetNormalizedVector(delta)
    local length = math.sqrt(delta.x ^ 2 + delta.y ^ 2)    
    local rotation = math.atan2(direction.x, direction.y)
    
    if rotation < 0 then
        rotation = rotation + math.pi * 2
    end

    rotation = rotation + math.pi * 0.5
    local rotationVec = Vector(0, 0, rotation)
    
    local line = GetGUIManager():CreateGraphicItem()
    line:SetSize(Vector(length, 2, 0))
    line:SetPosition(startPoint)
    line:SetRotationOffset(Vector(-length, 0, 0))
    line:SetRotation(rotationVec)
    line:SetColor(color)
    line:SetLayer(0) 

    return line

end


local function GetTotalCost(self)

    local totalCost = 0

    -- alien cost
    if self.selectedAlienType ~= AlienBuy_GetCurrentAlien() then
        totalCost = LookupUpgradeData(self.kAlienTypes[self.selectedAlienType].TechId, kUpDataCostIndex)
    end

    -- upgrade costs
    for i, currentButton in ipairs(self.techButtons) do

        local upgradeCost = LookupUpgradeData(currentButton.TechId, kUpDataCostIndex)

        if currentButton.IsSelected then
            totalCost = totalCost + upgradeCost
        end

    end

    return totalCost

end

local function GetNumberOfNewlySelectedUpgrades(self)

    local numSelected = 0
    local player = Client.GetLocalPlayer()

    if player then

        for i, currentButton in ipairs(self.upgradeList) do

            if not GetUpgradeTree():GetIsPurchased(currentButton) then
                numSelected = numSelected + 1
            end

        end

    end

    return numSelected

end

--
-- Checks if the mouse is over the passed in GUIItem and plays a sound if it has just moved over.
--
function AlienBuyMenu:_GetIsMouseOver(overItem)

    local mouseOver = GUIItemContainsPoint(overItem, Client.GetCursorPosScreen())
    if mouseOver and not self.mouseOverStates[overItem] then
        AlienBuy_OnMouseOver()
    end
    self.mouseOverStates[overItem] = mouseOver
    return mouseOver

end

local function UpdateItemsGUIScale(self)

    AlienBuyMenu.kAlienTypes =
    {
        { LocaleName = Locale.ResolveString("FADE"), Name = "Fade", Width = GUIScaleWidth(188), Height = GUIScaleHeight(220), XPos = 2, Index = 1, TechId = kTechId.Fade },
        { LocaleName = Locale.ResolveString("GORGE"), Name = "Gorge", Width = GUIScaleWidth(200), Height = GUIScaleHeight(167), XPos = 4, Index = 2, TechId = kTechId.Gorge },
        { LocaleName = Locale.ResolveString("LERK"), Name = "Lerk", Width = GUIScaleWidth(284), Height = GUIScaleHeight(253), XPos = 3, Index = 3, TechId = kTechId.Lerk },
        { LocaleName = Locale.ResolveString("ONOS"), Name = "Onos", Width = GUIScaleWidth(304), Height = GUIScaleHeight(326), XPos = 1, Index = 4, TechId = kTechId.Onos },
        { LocaleName = Locale.ResolveString("SKULK"), Name = "Skulk", Width = GUIScaleWidth(240), Height = GUIScaleHeight(170), XPos = 5, Index = 5, TechId = kTechId.Skulk }
    }


    AlienBuyMenu.kLogoSize = Vector(GUIScaleWidth(128), GUIScaleHeight(128), 0)
    AlienBuyMenu.kLogoPos = Vector(GUIScaleWidth(20), GUIScaleHeight(20), 0)
    AlienBuyMenu.kBkgCenteredWidth = GUIScaleWidth(1000)

    -- title offsets
    AlienBuyMenu.kTitleOffset = Vector(GUIScaleWidth(140), GUIScaleHeight(40), 0)
    AlienBuyMenu.kCurrentEvoTitleOffset = Vector(GUIScaleWidth(16), GUIScaleHeight(6), 0)
    AlienBuyMenu.kLifeformsTitleOffset = Vector(GUIScaleWidth(60), GUIScaleHeight(30), 0)
    AlienBuyMenu.kUpgradesTitleOffest = Vector(GUIScaleWidth(60), GUIScaleHeight(580), 0)

    -- header and mouse over info offsets
    AlienBuyMenu.kResIconOffset = Vector(GUIScaleWidth(144), GUIScaleHeight(75), 0)

    AlienBuyMenu.kMouseOverPanelSize = Vector(GUIScaleWidth(262), GUIScaleHeight(222), 0)
    AlienBuyMenu.kMouseOverPanelPos = Vector(GUIScaleWidth(-600), GUIScaleHeight(20), 0)
    AlienBuyMenu.kMouseOverPanelOffset = Vector(GUIScaleWidth(60), GUIScaleHeight(140), 0)
    AlienBuyMenu.kMouseOverTitleOffset = Vector(GUIScaleWidth(16), GUIScaleHeight(6), 0)
    AlienBuyMenu.kMouseOverInfoOffset = Vector(GUIScaleWidth(16), GUIScaleHeight(50), 0)
    AlienBuyMenu.kMouseOverCostOffset = Vector(GUIScaleWidth(-20), GUIScaleHeight(6), 0)
    AlienBuyMenu.kMouseOverInfoResIconOffset = Vector(GUIScaleWidth(-40), GUIScaleHeight(8), 0)
    AlienBuyMenu.kStatsPadding = Vector(GUIScaleWidth(5), GUIScaleHeight(0), 0)
    AlienBuyMenu.kStatsPaddingY = Vector(GUIScaleWidth(0), GUIScaleHeight(2), 0)

    -- current evolution section
    AlienBuyMenu.kCurrentEvoBorderOffset = Vector(GUIScaleWidth(-320), GUIScaleHeight(20), 0)
    AlienBuyMenu.kCurrentEvoBorderSize = Vector(GUIScaleWidth(262), GUIScaleHeight(222), 0)
    AlienBuyMenu.kCurrentEvoAlienIconOffset = Vector(GUIScaleWidth(0), GUIScaleHeight(5), 0)
    AlienBuyMenu.kBiomassIconSize = Vector(GUIScaleWidth(72), GUIScaleHeight(72), 0)
    AlienBuyMenu.kBiomassIconOffset = Vector(-AlienBuyMenu.kBiomassIconSize.x - GUIScaleWidth(20), GUIScaleHeight(45), 0)
    AlienBuyMenu.kCurrentEvoUpgradeOffset = Vector(GUIScaleWidth(16), GUIScaleHeight(130), 0)

    -- alien buttons
    AlienBuyMenu.kAlienButtonOffsetY = GUIScaleHeight(460)
    AlienBuyMenu.kAlienIconSize = Vector(GUIScaleWidth(94), GUIScaleHeight(94), 0)

    -- evolve panel
    AlienBuyMenu.kEvolvePanelSize = Vector(GUIScaleWidth(600), GUIScaleHeight(100), 0)
    AlienBuyMenu.kEvolvePanelOffset = Vector(GUIScaleWidth(60), GUIScaleHeight(-140), 0)
    AlienBuyMenu.kEvolveTitleOffset = Vector(GUIScaleWidth(16), GUIScaleHeight(6), 0)
    AlienBuyMenu.kEvolveIconSize = Vector(GUIScaleWidth(58), GUIScaleHeight(58), 0)
    AlienBuyMenu.kEvolveLifeformIconOffset = Vector(GUIScaleWidth(10), GUIScaleHeight(40), 0)
    AlienBuyMenu.kCloseIconSize = Vector(GUIScaleWidth(16), GUIScaleHeight(16), 0)
    AlienBuyMenu.kEvolveUpgradePadding = GUIScaleWidth(12)

    AlienBuyMenu.kAlienButtonSize = Vector(GUIScaleWidth(180), GUIScaleHeight(180), 0)
    AlienBuyMenu.kPlayersTextSize = GUIScaleHeight(24)
    AlienBuyMenu.kAlienSelectedButtonSize = AlienBuyMenu.kAlienButtonSize * 2

    AlienBuyMenu.kResourceIconWidth = GUIScaleWidth(33)
    AlienBuyMenu.kResourceIconHeight = GUIScaleHeight(33)

    AlienBuyMenu.kResourceIconWidthSm = GUIScaleWidth(20)
    AlienBuyMenu.kResourceIconHeightSm = GUIScaleHeight(20)

    AlienBuyMenu.kEvolveButtonWidth = GUIScaleWidth(250)
    AlienBuyMenu.kEvolveButtonHeight = GUIScaleHeight(80)
    AlienBuyMenu.kEvolveButtonOffset = Vector(GUIScaleWidth(-60), GUIScaleHeight(-40), 0)

    AlienBuyMenu.kHealthIconWidth = GUIScaleWidth(AlienBuyMenu.kHealthIconTextureCoordinates[3] - AlienBuyMenu.kHealthIconTextureCoordinates[1])
    AlienBuyMenu.kHealthIconHeight = GUIScaleHeight(AlienBuyMenu.kHealthIconTextureCoordinates[4] - AlienBuyMenu.kHealthIconTextureCoordinates[2])

    AlienBuyMenu.kArmorIconWidth = GUIScaleWidth(AlienBuyMenu.kArmorIconTextureCoordinates[3] - AlienBuyMenu.kArmorIconTextureCoordinates[1])
    AlienBuyMenu.kArmorIconHeight = GUIScaleHeight(AlienBuyMenu.kArmorIconTextureCoordinates[4] - AlienBuyMenu.kArmorIconTextureCoordinates[2])

    AlienBuyMenu.kUpgradeButtonSize = Vector(GUIScaleWidth(54), GUIScaleHeight(54), 0)
    AlienBuyMenu.kUpgradeParentIconOfffsetY = GUIScaleHeight(600)
    AlienBuyMenu.kUpgradeIconOffsetY = GUIScaleHeight(670)

    for location, texCoords in pairs(AlienBuyMenu.kCornerTextureCoordinates) do
        AlienBuyMenu.kCornerWidths[location] = GUIScale(texCoords[3] - texCoords[1])
        AlienBuyMenu.kCornerHeights[location] = GUIScale(texCoords[4] - texCoords[2])
    end

end

function AlienBuyMenu:Initialize()

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

function AlienBuyMenu:Update(deltaTime)

    PROFILE("AlienBuyMenu:Update")

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

function AlienBuyMenu:Uninitialize()

    GUIAnimatedScript.Uninitialize(self)

    -- GUI.DestroyItem(self.background)
    -- self.background = nil

    self.corners = { }
    self.cornerTweeners = { }

    MouseTracker_SetIsVisible(false)

end

function AlienBuyMenu:OnResolutionChanged(oldX, oldY, newX, newY)

    self:Uninitialize()
    self:Initialize()

end

function AlienBuyMenu:_InitializeBackground()

    self.background = self:CreateAnimatedGraphicItem()
    self.background:SetIsScaling(false)
    self.background:SetSize( Vector(Client.GetScreenWidth(), Client.GetScreenHeight(), 0) )
    self.background:SetAnchor(GUIItem.Left, GUIItem.Top)
    self.background:SetColor(AlienBuyMenu.kBackgroundColor)
    self.background:SetLayer(kGUILayerPlayerHUDForeground4)

    self.backgroundCenteredArea = self:CreateAnimatedGraphicItem()
    self.backgroundCenteredArea:SetIsScaling(false)
    self.backgroundCenteredArea:SetSize(Vector(AlienBuyMenu.kBkgCenteredWidth, Client.GetScreenHeight(), 0))
    self.backgroundCenteredArea:SetAnchor(GUIItem.Middle, GUIItem.Top)
    self.backgroundCenteredArea:SetPosition( Vector(-AlienBuyMenu.kBkgCenteredWidth / 2, 0, 0) )
    self.backgroundCenteredArea:SetTexture(AlienBuyMenu.kBackgroundTexture)
    self.backgroundCenteredArea:SetColor(Color(1.0, 1.0, 1.0, 0.4))
    self.background:AddChild(self.backgroundCenteredArea)

end

function AlienBuyMenu:_InitializeCorners()

    self.corners = { }

    local topLeftCorner = GUIManager:CreateGraphicItem()
    topLeftCorner:SetAnchor(GUIItem.Left, GUIItem.Top)
    topLeftCorner:SetSize(Vector(AlienBuyMenu.kCornerWidths.TopLeft, AlienBuyMenu.kCornerHeights.TopLeft, 0))
    topLeftCorner:SetTexture(AlienBuyMenu.kBuyMenuTexture)
    topLeftCorner:SetTexturePixelCoordinates(GUIUnpackCoords(AlienBuyMenu.kCornerTextureCoordinates.TopLeft))
    topLeftCorner:SetShader("shaders/GUIWavyNoMask.surface_shader")
    self.backgroundCenteredArea:AddChild(topLeftCorner)
    self.corners.TopLeft = topLeftCorner

    local bottomLeftCorner = GUIManager:CreateGraphicItem()
    bottomLeftCorner:SetAnchor(GUIItem.Left, GUIItem.Bottom)
    bottomLeftCorner:SetPosition(Vector(0, -AlienBuyMenu.kCornerHeights.BottomLeft, 0))
    bottomLeftCorner:SetSize(Vector(AlienBuyMenu.kCornerWidths.BottomLeft, AlienBuyMenu.kCornerHeights.BottomLeft, 0))
    bottomLeftCorner:SetTexture(AlienBuyMenu.kBuyMenuTexture)
    bottomLeftCorner:SetTexturePixelCoordinates(GUIUnpackCoords(AlienBuyMenu.kCornerTextureCoordinates.BottomLeft))
    bottomLeftCorner:SetShader("shaders/GUIWavyNoMask.surface_shader")
    self.backgroundCenteredArea:AddChild(bottomLeftCorner)
    self.corners.BottomLeft = bottomLeftCorner

    local topRightCorner = GUIManager:CreateGraphicItem()
    topRightCorner:SetAnchor(GUIItem.Right, GUIItem.Top)
    topRightCorner:SetPosition(Vector(-AlienBuyMenu.kCornerWidths.TopRight, 0, 0))
    topRightCorner:SetSize(Vector(AlienBuyMenu.kCornerWidths.TopRight, AlienBuyMenu.kCornerHeights.TopRight, 0))
    topRightCorner:SetTexture(AlienBuyMenu.kBuyMenuTexture)
    topRightCorner:SetTexturePixelCoordinates(GUIUnpackCoords(AlienBuyMenu.kCornerTextureCoordinates.TopRight))
    topRightCorner:SetShader("shaders/GUIWavyNoMask.surface_shader")
    self.backgroundCenteredArea:AddChild(topRightCorner)
    self.corners.TopRight = topRightCorner

    local bottomRightCorner = GUIManager:CreateGraphicItem()
    bottomRightCorner:SetAnchor(GUIItem.Right, GUIItem.Bottom)
    bottomRightCorner:SetPosition(Vector(-AlienBuyMenu.kCornerWidths.BottomRight, -AlienBuyMenu.kCornerHeights.BottomRight, 0))
    bottomRightCorner:SetSize(Vector(AlienBuyMenu.kCornerWidths.BottomRight, AlienBuyMenu.kCornerHeights.BottomRight, 0))
    bottomRightCorner:SetTexture(AlienBuyMenu.kBuyMenuTexture)
    bottomRightCorner:SetTexturePixelCoordinates(GUIUnpackCoords(AlienBuyMenu.kCornerTextureCoordinates.BottomRight))
    bottomRightCorner:SetShader("shaders/GUIWavyNoMask.surface_shader")
    self.backgroundCenteredArea:AddChild(bottomRightCorner)
    self.corners.BottomRight = bottomRightCorner

    self.cornerTweeners = { }
    for cornerName, _ in pairs(self.corners) do
        self.cornerTweeners[cornerName] = Tweener("loopforward")
        self.cornerTweeners[cornerName].add(AlienBuyMenu.kCornerPulseTime, { percent = 1 }, Easing.linear)
        self.cornerTweeners[cornerName].add(AlienBuyMenu.kCornerPulseTime, { percent = 0 }, Easing.linear)
    end

end

function AlienBuyMenu:_InitializeHeader()

    local player = Client.GetLocalPlayer()

    self.logo = GUIManager:CreateGraphicItem()
    self.logo:SetSize(AlienBuyMenu.kLogoSize)
    self.logo:SetAnchor(GUIItem.Left, GUIItem.Top)
    self.logo:SetPosition(AlienBuyMenu.kLogoPos)
    self.logo:SetTexture(AlienBuyMenu.kAlienLogoTexture)
    self.backgroundCenteredArea:AddChild(self.logo)

    local titleShadow = GUIManager:CreateTextItem()
    titleShadow:SetAnchor(GUIItem.Left, GUIItem.Top)
    titleShadow:SetPosition(AlienBuyMenu.kTitleOffset)
    titleShadow:SetFontName(AlienBuyMenu.kTitleFont)
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
    title:SetFontName(AlienBuyMenu.kTitleFont)
    title:SetScale(GetScaledVector())
    GUIMakeFontScale(title)
    title:SetTextAlignmentX(GUIItem.Align_Min)
    title:SetTextAlignmentY(GUIItem.Align_Min)
    title:SetText("Evolution Chamber")
    title:SetColor(ColorIntToColor(kAlienTeamColor))
    titleShadow:AddChild(title)

    local resIcon = GUIManager:CreateGraphicItem()
    resIcon:SetSize(Vector(AlienBuyMenu.kResourceIconWidth, AlienBuyMenu.kResourceIconHeight, 0))
    resIcon:SetAnchor(GUIItem.Left, GUIItem.Top)
    resIcon:SetPosition(AlienBuyMenu.kResIconOffset)
    resIcon:SetTexture(AlienBuyMenu.kResourceIconTexture)
    resIcon:SetColor(ColorIntToColor(kAlienTeamColor))
    self.backgroundCenteredArea:AddChild(resIcon)

    local upgradePointText = GUIManager:CreateTextItem()
    upgradePointText:SetAnchor(GUIItem.Right, GUIItem.Center)
    upgradePointText:SetPosition(Vector(GUIScaleWidth(6), 0, 0))
    upgradePointText:SetFontName(AlienBuyMenu.kHeaderAltFont)
    upgradePointText:SetScale(GetScaledVector())
    GUIMakeFontScale(upgradePointText)
    upgradePointText:SetTextAlignmentX(GUIItem.Align_Min)
    upgradePointText:SetTextAlignmentY(GUIItem.Align_Center)
    upgradePointText:SetColor(ColorIntToColor(kAlienTeamColor))

    -- update upgrade point text
    if player.combatUpgradePoints == 1 then
        upgradePointText:SetText(string.format("%s Upgrade Point", player.combatUpgradePoints))
    else
        upgradePointText:SetText(string.format("%s Upgrade Points", player.combatUpgradePoints))
    end

    resIcon:AddChild(upgradePointText)

end

function AlienBuyMenu:_InitializeMouseOverInfo()

    self.mouseOverPanel = GUIManager:CreateGraphicItem()
    self.mouseOverPanel:SetAnchor(GUIItem.Right, GUIItem.Top)
    self.mouseOverPanel:SetSize(AlienBuyMenu.kMouseOverPanelSize)
    self.mouseOverPanel:SetPosition(AlienBuyMenu.kMouseOverPanelPos)
    self.mouseOverPanel:SetTexture(AlienBuyMenu.KCurrentEvoBorderTexture)
    self.mouseOverPanel:SetTexturePixelCoordinates(474, 348, 736, 570)
    self.mouseOverPanel:SetColor(Color(1.0, 1.0, 1.0, 0.6))
    self.backgroundCenteredArea:AddChild(self.mouseOverPanel)

    self.mouseOverTitleShadow = GUIManager:CreateTextItem()
    self.mouseOverTitleShadow:SetAnchor(GUIItem.Left, GUIItem.Top)
    self.mouseOverTitleShadow:SetPosition(AlienBuyMenu.kMouseOverTitleOffset)
    self.mouseOverTitleShadow:SetFontName(AlienBuyMenu.kHeaderFont)
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
    self.mouseOverTitle:SetFontName(AlienBuyMenu.kHeaderFont)
    self.mouseOverTitle:SetFontIsBold(true)
    self.mouseOverTitle:SetScale(GetScaledVector())
    GUIMakeFontScale(self.mouseOverTitle)
    self.mouseOverTitle:SetTextAlignmentX(GUIItem.Align_Min)
    self.mouseOverTitle:SetTextAlignmentY(GUIItem.Align_Min)
    self.mouseOverTitle:SetColor(AlienBuyMenu.kTextColor)
    self.mouseOverTitleShadow:AddChild(self.mouseOverTitle)

    self.mouseOverInfo = GUIManager:CreateTextItem()
    self.mouseOverInfo:SetAnchor(GUIItem.Left, GUIItem.Top)
    self.mouseOverInfo:SetPosition(AlienBuyMenu.kMouseOverInfoOffset)
    self.mouseOverInfo:SetFontName(kFontSmall)
    self.mouseOverInfo:SetScale(GetScaledVector())
    GUIMakeFontScale(self.mouseOverInfo)
    self.mouseOverInfo:SetTextAlignmentX(GUIItem.Align_Min)
    self.mouseOverInfo:SetTextAlignmentY(GUIItem.Align_Min)
    self.mouseOverInfo:SetColor(ColorIntToColor(kAlienTeamColor))
    self.mouseOverPanel:AddChild(self.mouseOverInfo)

    self.mouseOverInfoResIcon = GUIManager:CreateGraphicItem()
    self.mouseOverInfoResIcon:SetSize(Vector(AlienBuyMenu.kResourceIconWidthSm, AlienBuyMenu.kResourceIconHeightSm, 0))
    self.mouseOverInfoResIcon:SetAnchor(GUIItem.Right, GUIItem.Top)
    self.mouseOverInfoResIcon:SetPosition(AlienBuyMenu.kMouseOverInfoResIconOffset)
    self.mouseOverInfoResIcon:SetTexture(AlienBuyMenu.kResourceIconTexture)
    self.mouseOverInfoResIcon:SetColor(kIconColors[kAlienTeamType])
    self.mouseOverInfoResIcon:SetInheritsParentScaling(false)
    self.mouseOverPanel:AddChild(self.mouseOverInfoResIcon)

    self.costText = GUIManager:CreateTextItem()
    self.costText:SetAnchor(GUIItem.Right, GUIItem.Top)
    self.costText:SetPosition(AlienBuyMenu.kMouseOverCostOffset)
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
    self.mouseOverInfoHealthIcon:SetSize(Vector(AlienBuyMenu.kResourceIconWidthSm, AlienBuyMenu.kResourceIconHeightSm, 0))
    self.mouseOverInfoHealthIcon:SetAnchor(GUIItem.Right, GUIItem.Top)
    self.mouseOverInfoHealthIcon:SetInheritsParentScaling(false)
    self.mouseOverInfoHealthIcon:SetPosition(AlienBuyMenu.kStatsPadding + AlienBuyMenu.kStatsPaddingY)
    self.mouseOverInfoHealthIcon:SetTexture(AlienBuyMenu.kBuyMenuTexture)
    self.mouseOverInfoHealthIcon:SetTexturePixelCoordinates(GUIUnpackCoords(AlienBuyMenu.kHealthIconTextureCoordinates))
    self.mouseOverTitleShadow:AddChild(self.mouseOverInfoHealthIcon)

    self.mouseOverInfoHealthAmount = GUIManager:CreateTextItem()
    self.mouseOverInfoHealthAmount:SetAnchor(GUIItem.Right, GUIItem.Top)
    self.mouseOverInfoHealthAmount:SetFontName(kFont)
    self.mouseOverInfoHealthAmount:SetScale(GetScaledVector())
    GUIMakeFontScale(self.mouseOverInfoHealthAmount)
    self.mouseOverInfoHealthAmount:SetTextAlignmentX(GUIItem.Align_Min)
    self.mouseOverInfoHealthAmount:SetTextAlignmentY(GUIItem.Align_Min)
    self.mouseOverInfoHealthAmount:SetPosition(AlienBuyMenu.kStatsPadding)
    self.mouseOverInfoHealthAmount:SetColor(ColorIntToColor(kAlienTeamColor))
    self.mouseOverInfoHealthIcon:AddChild(self.mouseOverInfoHealthAmount)

    self.mouseOverInfoArmorIcon = GUIManager:CreateGraphicItem()
    self.mouseOverInfoArmorIcon:SetSize(Vector(AlienBuyMenu.kResourceIconWidthSm, AlienBuyMenu.kResourceIconHeightSm, 0))
    self.mouseOverInfoArmorIcon:SetAnchor(GUIItem.Right, GUIItem.Top)
    self.mouseOverInfoArmorIcon:SetPosition(AlienBuyMenu.kStatsPadding)
    self.mouseOverInfoArmorIcon:SetTexture(AlienBuyMenu.kBuyMenuTexture)
    self.mouseOverInfoArmorIcon:SetTexturePixelCoordinates(GUIUnpackCoords(AlienBuyMenu.kArmorIconTextureCoordinates))
    self.mouseOverInfoArmorIcon:SetInheritsParentScaling(false)
    self.mouseOverInfoHealthAmount:AddChild(self.mouseOverInfoArmorIcon)

    self.mouseOverInfoArmorAmount = GUIManager:CreateTextItem()
    self.mouseOverInfoArmorAmount:SetAnchor(GUIItem.Right, GUIItem.Top)
    self.mouseOverInfoArmorAmount:SetFontName(kFont)
    self.mouseOverInfoArmorAmount:SetScale(GetScaledVector())
    GUIMakeFontScale(self.mouseOverInfoArmorAmount)
    self.mouseOverInfoArmorAmount:SetTextAlignmentX(GUIItem.Align_Min)
    self.mouseOverInfoArmorAmount:SetTextAlignmentY(GUIItem.Align_Min)
    self.mouseOverInfoArmorAmount:SetPosition(AlienBuyMenu.kStatsPadding)
    self.mouseOverInfoArmorAmount:SetColor(ColorIntToColor(kAlienTeamColor))
    self.mouseOverInfoArmorIcon:AddChild(self.mouseOverInfoArmorAmount)

end

function AlienBuyMenu:_InitializeCurrentEvolutionDisplay()

    local border = GUIManager:CreateGraphicItem()
    border:SetAnchor(GUIItem.Right, GUIItem.Top)
    border:SetSize(AlienBuyMenu.kCurrentEvoBorderSize)
    border:SetPosition(AlienBuyMenu.kCurrentEvoBorderOffset)
    border:SetTexture(AlienBuyMenu.KCurrentEvoBorderTexture)
    border:SetTexturePixelCoordinates(474, 348, 736, 570)
    border:SetColor(Color(1.0, 1.0, 1.0, 0.6))
    self.backgroundCenteredArea:AddChild(border)

    local headerTextShadow = GUIManager:CreateTextItem()
    headerTextShadow:SetAnchor(GUIItem.Left, GUIItem.Top)
    headerTextShadow:SetPosition(AlienBuyMenu.kCurrentEvoTitleOffset)
    headerTextShadow:SetFontName(AlienBuyMenu.kHeaderFont)
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
    headerText:SetFontName(AlienBuyMenu.kHeaderFont)
    headerText:SetFontIsBold(true)
    headerText:SetScale(GetScaledVector())
    GUIMakeFontScale(headerText)
    headerText:SetTextAlignmentX(GUIItem.Align_Min)
    headerText:SetTextAlignmentY(GUIItem.Align_Min)
    headerText:SetColor(AlienBuyMenu.kTextColor)
    headerText:SetText("Current Evolution")
    headerTextShadow:AddChild(headerText)

    -- The alien icon
    local alienType = AlienBuyMenu.kAlienTypes[self.selectedAlienType]
    local alienGraphicItem = GUIManager:CreateGraphicItem()
    local ARAdjustedHeight = (alienType.Height / alienType.Width) * AlienBuyMenu.kAlienIconSize.y
    alienGraphicItem:SetSize(Vector(AlienBuyMenu.kAlienIconSize.x, ARAdjustedHeight, 0))
    alienGraphicItem:SetAnchor(GUIItem.Left, GUIItem.Bottom)
    alienGraphicItem:SetPosition(AlienBuyMenu.kCurrentEvoAlienIconOffset)
    alienGraphicItem:SetTexture("ui/" .. alienType.Name .. ".dds")
    headerTextShadow:AddChild(alienGraphicItem)

    local biomassIcon = GUIManager:CreateGraphicItem()
    biomassIcon:SetAnchor(GUIItem.Right, GUIItem.Top)
    biomassIcon:SetSize(AlienBuyMenu.kBiomassIconSize)
    biomassIcon:SetPosition(AlienBuyMenu.kBiomassIconOffset)
    biomassIcon:SetTexture(AlienBuyMenu.kBuyHUDTexture)
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

    local categories =
    {
        kTechId.ShiftHive,
        kTechId.ShadeHive,
        kTechId.CragHive
    }

    local offsetFactor = 0

    for i = 1, #categories do

        local upgrades = AlienUI_GetUpgradesForCategory(categories[i])
        
        for upgradeIndex = 1, #upgrades do

            local upgradeTechId = upgrades[upgradeIndex]

            if AlienBuy_GetUpgradePurchased(upgradeTechId) then
            
                -- Every upgrade has an icon.
                local upgradeIcon = GUIManager:CreateGraphicItem()

                local iconX, iconY = GetMaterialXYOffset(upgradeTechId, false)
                iconX = iconX * AlienBuyMenu.kUpgradeButtonTextureSize
                iconY = iconY * AlienBuyMenu.kUpgradeButtonTextureSize

                local offset = Vector((AlienBuyMenu.kUpgradeButtonSize.x + GUIScale(4)) * offsetFactor, 0, 0)

                upgradeIcon:SetAnchor(GUIItem.Left, GUIItem.Top)
                upgradeIcon:SetSize(AlienBuyMenu.kUpgradeButtonSize)
                upgradeIcon:SetPosition(AlienBuyMenu.kCurrentEvoUpgradeOffset + offset)
                upgradeIcon:SetTexture(AlienBuyMenu.kBuyHUDTexture)
                upgradeIcon:SetTexturePixelCoordinates(iconX, iconY, iconX + AlienBuyMenu.kUpgradeButtonTextureSize, iconY + AlienBuyMenu.kUpgradeButtonTextureSize)
                upgradeIcon:SetColor(kIconColors[kAlienTeamType])
                border:AddChild(upgradeIcon)

                offsetFactor = offsetFactor + 1
                break

            end

        end

    end

end

function AlienBuyMenu:_InitializeLifeforms()

    self.lifeformHeaderText = GUIManager:CreateTextItem()
    self.lifeformHeaderText:SetAnchor(GUIItem.Left, GUIItem.Top)
    self.lifeformHeaderText:SetPosition(AlienBuyMenu.kLifeformsTitleOffset)
    self.lifeformHeaderText:SetFontName(AlienBuyMenu.kHeaderFont)
    self.lifeformHeaderText:SetFontIsBold(true)
    self.lifeformHeaderText:SetScale(GetScaledVector())
    GUIMakeFontScale(self.lifeformHeaderText)
    self.lifeformHeaderText:SetTextAlignmentX(GUIItem.Align_Min)
    self.lifeformHeaderText:SetTextAlignmentY(GUIItem.Align_Center)
    self.lifeformHeaderText:SetColor(Color(0, 0, 0, 1))
    self.lifeformHeaderText:SetText("Lifeforms")
    self.backgroundCenteredArea:AddChild(self.lifeformHeaderText)

    local headerText = GUIManager:CreateTextItem()
    headerText:SetAnchor(GUIItem.Left, GUIItem.Top)
    headerText:SetPosition(Vector(-2, -2, 0))
    headerText:SetFontName(AlienBuyMenu.kHeaderFont)
    headerText:SetFontIsBold(true)
    headerText:SetScale(GetScaledVector())
    GUIMakeFontScale(headerText)
    headerText:SetTextAlignmentX(GUIItem.Align_Min)
    headerText:SetTextAlignmentY(GUIItem.Align_Center)
    headerText:SetColor(AlienBuyMenu.kTextColor)
    headerText:SetText("Lifeforms")
    self.lifeformHeaderText:AddChild(headerText)

end

local function CreateAbilityIcon(self, alienGraphicItem, techId)

    local graphicItem = GetGUIManager():CreateGraphicItem()
    graphicItem:SetTexture(AlienBuyMenu.kAbilityIcons)
    graphicItem:SetSize(AlienBuyMenu.kUpgradeButtonSize)
    graphicItem:SetAnchor(GUIItem.Middle, GUIItem.Bottom)
    graphicItem:SetTexturePixelCoordinates(GUIUnpackCoords(GetTextureCoordinatesForIcon(techId, false)))
    graphicItem:SetColor(kIconColors[kAlienTeamType])

    local highLight = GetGUIManager():CreateGraphicItem()
    highLight:SetSize(AlienBuyMenu.kUpgradeButtonSize)
    highLight:SetIsVisible(false)
    highLight:SetTexture(AlienBuyMenu.kBuyMenuTexture)
    highLight:SetTexturePixelCoordinates(GUIUnpackCoords(AlienBuyMenu.kUpgradeButtonBackgroundTextureCoordinates))

    graphicItem:AddChild(highLight)
    alienGraphicItem:AddChild(graphicItem)

    return { Icon = graphicItem, TechId = techId, HighLight = highLight }

end

local function CreateAbilityIcons(self, alienGraphicItem, alienType)

    local lifeFormTechId = IndexToAlienTechId(alienType.Index)
    local abilities = GetUpgradeTree():GetUpgradesByCategoryAndPrereq("Ability", lifeFormTechId)

    local numAbilities = #abilities
    local totalWidth = numAbilities * (AlienBuyMenu.kUpgradeButtonSize.x + 10)

    for i = 1, numAbilities do

        local techId = abilities[numAbilities - i + 1]
        local ability = CreateAbilityIcon(self, alienGraphicItem, techId)
        local xPos = ( ( (i - 1) * AlienBuyMenu.kUpgradeButtonSize.x ) + 10 ) - (totalWidth / 2)
        local yPos = 10

        ability.Icon:SetPosition(Vector(xPos, yPos, 0))
        table.insert(self.abilityIcons, ability)

    end

end

function AlienBuyMenu:_InitializeAlienButtons()

    self.alienButtons = { }

    for k, alienType in ipairs(AlienBuyMenu.kAlienTypes) do

        -- The alien image.
        local alienGraphicItem = GUIManager:CreateGraphicItem()
        local ARAdjustedHeight = (alienType.Height / alienType.Width) * AlienBuyMenu.kAlienButtonSize.y
        alienGraphicItem:SetSize(Vector(AlienBuyMenu.kAlienButtonSize.x, ARAdjustedHeight, 0))
        alienGraphicItem:SetAnchor(GUIItem.Middle, GUIItem.Center)
        alienGraphicItem:SetPosition(Vector(-AlienBuyMenu.kAlienButtonSize.x / 2, -ARAdjustedHeight / 2, 0))
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
        playersText:SetPosition(Vector(0, -AlienBuyMenu.kPlayersTextSize, 0))
        alienGraphicItem:AddChild(playersText)

        -- Create the selected background item for this alien item.
        local selectedBackground = GUIManager:CreateGraphicItem()
        selectedBackground:SetAnchor(GUIItem.Middle, GUIItem.Top)
        selectedBackground:SetSize(AlienBuyMenu.kAlienSelectedButtonSize)
        selectedBackground:SetTexture(AlienBuyMenu.kAlienSelectedBackground)
        -- Hide the selected background for now.
        selectedBackground:SetColor(Color(1, 1, 1, 0))
        selectedBackground:AddChild(alienGraphicItem)

        table.insert(self.alienButtons, { TypeData = alienType, Button = alienGraphicItem, SelectedBackground = selectedBackground, PlayersText = playersText, ARAdjustedHeight = ARAdjustedHeight })

        CreateAbilityIcons(self, alienGraphicItem, alienType)

        self.backgroundCenteredArea:AddChild(selectedBackground)

    end

    self:_UpdateAlienButtons()

end

local function CreateTechButton(self, techId, position)

    local button = AnimatedTechButton()
    button:Initialize(self, techId, position)
    button:SetColors(kIconColors[kAlienTeamType], Color(1,0,0,1), Color(0.4, 0.7, 0, 1), Color(0.4, 0.7, 0, 1))
    return button

end


function AlienBuyMenu:_InitializeUpgrades()

    local categories = GetUpgradeTree():GetUpgradesByCategory("UpgradeType")
    self.upgradeButtons = { }
    self.techButtons = { }

    local binSize = (self.backgroundCenteredArea:GetSize().x - (AlienBuyMenu.kUpgradesTitleOffest.x * 2)) / #categories

    local headerTextShadow = GUIManager:CreateTextItem()
    headerTextShadow:SetAnchor(GUIItem.Left, GUIItem.Top)
    headerTextShadow:SetPosition(AlienBuyMenu.kUpgradesTitleOffest)
    headerTextShadow:SetFontName(AlienBuyMenu.kHeaderFont)
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
    headerText:SetFontName(AlienBuyMenu.kHeaderFont)
    headerText:SetFontIsBold(true)
    headerText:SetScale(GetScaledVector())
    GUIMakeFontScale(headerText)
    headerText:SetTextAlignmentX(GUIItem.Align_Min)
    headerText:SetTextAlignmentY(GUIItem.Align_Center)
    headerText:SetColor(AlienBuyMenu.kTextColor)
    headerText:SetText("Upgrades")
    headerTextShadow:AddChild(headerText)

    -- upgrade roots/types
    for i = 1, #categories do

        local bin = i - 1
        local posInBin = (binSize / 2) - (AlienBuyMenu.kUpgradeButtonSize.x / 2)
        local parentIconOffsetX = AlienBuyMenu.kUpgradesTitleOffest.x + (bin * binSize) + posInBin
        local parentIconPos = Vector(parentIconOffsetX, AlienBuyMenu.kUpgradeParentIconOfffsetY, 0)

        local upsByCategory = GetUpgradeTree():GetUpgradesByPrereq(categories[i])

        for j = 1, #upsByCategory do

            local smallBinSize = binSize / #upsByCategory
            local iconOffsetX = (bin * binSize) + AlienBuyMenu.kUpgradesTitleOffest.x + ((j - 1) * smallBinSize) + ((smallBinSize / 2) - (AlienBuyMenu.kUpgradeButtonSize.x / 2))
            local iconPos = Vector(iconOffsetX, AlienBuyMenu.kUpgradeIconOffsetY, 0)
            local lineOffset = AlienBuyMenu.kUpgradeButtonSize / 2

            local line = CreateLine(parentIconPos + lineOffset, iconPos + lineOffset, AlienBuyMenu.kTextColor)
            line:SetAnchor(GUIItem.Left, GUIItem.Top)
            self.backgroundCenteredArea:AddChild(line)

            local subTechButton = CreateTechButton(self, upsByCategory[j], iconPos)
            subTechButton:SetToolTip(GetTooltipInfoText(upsByCategory[i]))
            self.backgroundCenteredArea:AddChild(subTechButton.Icon)
            table.insert(self.techButtons, subTechButton)

        end

        local parentTechButton = CreateTechButton(self, categories[i], parentIconPos)
        parentTechButton:SetToolTip(GetTooltipInfoText(categories[i]))
        self.backgroundCenteredArea:AddChild(parentTechButton.Icon)
        table.insert(self.techButtons, parentTechButton)

    end

end

function AlienBuyMenu:_InitializeEvolvePanel()

    self.evolveQueue = { }
    self.evolveQueueIndex = 1

    local panel = GUIManager:CreateGraphicItem()
    panel:SetAnchor(GUIItem.Left, GUIItem.Bottom)
    panel:SetSize(AlienBuyMenu.kEvolvePanelSize)
    panel:SetPosition(AlienBuyMenu.kEvolvePanelOffset)
    panel:SetTexture(AlienBuyMenu.kEvolvePanelBkgTexture)
    panel:SetColor(Color(1.0, 1.0, 1.0, 0.6))
    self.backgroundCenteredArea:AddChild(panel)

    local headerTextShadow = GUIManager:CreateTextItem()
    headerTextShadow:SetAnchor(GUIItem.Left, GUIItem.Top)
    headerTextShadow:SetPosition(AlienBuyMenu.kEvolveTitleOffset)
    headerTextShadow:SetFontName(AlienBuyMenu.kHeaderFont)
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
    headerText:SetFontName(AlienBuyMenu.kHeaderFont)
    headerText:SetFontIsBold(true)
    headerText:SetScale(GetScaledVector())
    GUIMakeFontScale(headerText)
    headerText:SetTextAlignmentX(GUIItem.Align_Min)
    headerText:SetTextAlignmentY(GUIItem.Align_Min)
    headerText:SetColor(AlienBuyMenu.kTextColor)
    headerText:SetText("Evolve To")
    headerTextShadow:AddChild(headerText)

    for i = 1, 8 do

        local upgradeIcon = GUIManager:CreateGraphicItem()
        upgradeIcon:SetAnchor(GUIItem.Left, GUIItem.Top)
        upgradeIcon:SetSize(AlienBuyMenu.kEvolveIconSize)
        upgradeIcon:SetPosition(Vector((AlienBuyMenu.kEvolveUpgradePadding + AlienBuyMenu.kEvolveIconSize.x) * (i - 1), 0, 0) + AlienBuyMenu.kEvolveLifeformIconOffset)
        upgradeIcon:SetColor(Color(kIconColors[kAlienTeamType]))
        panel:AddChild(upgradeIcon)

        local closeBtn = GUIManager:CreateGraphicItem()
        closeBtn:SetAnchor(GUIItem.Right, GUIItem.Top)
        closeBtn:SetSize(AlienBuyMenu.kCloseIconSize)
        closeBtn:SetPosition(Vector(-AlienBuyMenu.kCloseIconSize.x, 0, 0))
        closeBtn:SetTexture(AlienBuyMenu.kCloseIconTexture)
        upgradeIcon:AddChild(closeBtn)

        self.evolveQueue[i] = { TechId = kTechId.None, Cost = 0, Icon = upgradeIcon, CloseButton = closeBtn }

    end

end

function AlienBuyMenu:_InitializeEvolveButton()

    self.evolveButtonBackground = GUIManager:CreateGraphicItem()
    self.evolveButtonBackground:SetAnchor(GUIItem.Right, GUIItem.Bottom)
    self.evolveButtonBackground:SetSize(Vector(AlienBuyMenu.kEvolveButtonWidth, AlienBuyMenu.kEvolveButtonHeight, 0))
    self.evolveButtonBackground:SetPosition(Vector(-AlienBuyMenu.kEvolveButtonWidth, -AlienBuyMenu.kEvolveButtonHeight, 0) + AlienBuyMenu.kEvolveButtonOffset)
    self.evolveButtonBackground:SetTexture(AlienBuyMenu.kBuyMenuTexture)
    self.evolveButtonBackground:SetTexturePixelCoordinates(GUIUnpackCoords(AlienBuyMenu.kEvolveButtonTextureCoordinates))
    self.backgroundCenteredArea:AddChild(self.evolveButtonBackground)

    self.evolveButtonVeins = GUIManager:CreateGraphicItem()
    self.evolveButtonVeins:SetSize(Vector(AlienBuyMenu.kEvolveButtonWidth - kVeinsMargin * 2, AlienBuyMenu.kEvolveButtonHeight - kVeinsMargin * 2, 0))
    self.evolveButtonVeins:SetPosition(Vector(kVeinsMargin, kVeinsMargin, 0))
    self.evolveButtonVeins:SetTexture(AlienBuyMenu.kBuyMenuTexture)
    self.evolveButtonVeins:SetTexturePixelCoordinates(GUIUnpackCoords(AlienBuyMenu.kEvolveButtonVeinsTextureCoordinates))
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
    self.evolveResourceIcon:SetSize(Vector(AlienBuyMenu.kResourceIconWidth, AlienBuyMenu.kResourceIconHeight, 0))
    self.evolveResourceIcon:SetAnchor(GUIItem.Middle, GUIItem.Top)
    self.evolveResourceIcon:SetPosition(Vector(0, -AlienBuyMenu.kResourceIconHeight / 2, 0))
    self.evolveResourceIcon:SetTexture(AlienBuyMenu.kResourceIconTexture)
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

function AlienBuyMenu:_UpdateCorners(deltaTime)

    for _, cornerName in ipairs(self.corners) do
        self.cornerTweeners[cornerName].update(deltaTime)
        local percent = self.cornerTweeners[cornerName].getCurrentProperties().percent
        self.corners[cornerName]:SetColor(Color(1, percent, percent, math.abs(percent - 0.5) + 0.5))
    end

end

function AlienBuyMenu:_UpdateEvolvePanel()

    for i = 1, #self.evolveQueue do
        self.evolveQueue[i].Icon:SetIsVisible(false)
    end

    self.evolveQueue[1].TechId = self.kAlienTypes[self.selectedAlienType].TechId
    self.evolveQueue[1].Cost = LookupUpgradeData(self.evolveQueue[1].TechId, kUpDataCostIndex)

    self.evolveQueue[1].Icon:SetTexture(AlienBuyMenu.kBuyHUDTexture)
    self.evolveQueue[1].Icon:SetTexturePixelCoordinates(GUIUnpackCoords(GetTextureCoordinatesForIcon(self.kAlienTypes[self.selectedAlienType].TechId)))
    self.evolveQueue[1].Icon:SetIsVisible(true)

    local index = 2

    for k, upgradeTechId in ipairs(self.upgradeList) do

        self.evolveQueue[index].TechId = upgradeTechId
        self.evolveQueue[index].Cost = LookupUpgradeData(self.evolveQueue[index].TechId, kUpDataCostIndex)

        self.evolveQueue[index].Icon:SetTexture(AlienBuyMenu.kBuyHUDTexture)
        self.evolveQueue[index].Icon:SetTexturePixelCoordinates(GUIUnpackCoords(GetTextureCoordinatesForIcon(upgradeTechId)))
        self.evolveQueue[index].Icon:SetIsVisible(true)

        index = index + 1

    end

end

function AlienBuyMenu:_UpdateAlienButtons()

    local numAlienTypes = 5
    local totalAlienButtonsWidth = AlienBuyMenu.kAlienButtonSize.x * numAlienTypes
    local player = Client.GetLocalPlayer()
    local minY = self.backgroundCenteredArea:GetSize().y

    for k, alienButton in ipairs(self.alienButtons) do

        -- Info needed for the rest of this code.
        local itemTechId = alienButton.TypeData.TechId
        local cost = LookupUpgradeData(itemTechId, kUpDataCostIndex)
        local isCurrentAlien = AlienBuy_GetCurrentAlien() == alienButton.TypeData.Index
        local canAfford = cost <= player.combatUpgradePoints
        local hasRequiredRank = LookupUpgradeData(itemTechId, kUpDataRankIndex) <= player.combatRank

        alienButton.Button:SetIsVisible(true)

        if hasRequiredRank and canAfford and not isCurrentAlien then
            alienButton.Button:SetColor(AlienBuyMenu.kEnabledColor)
        elseif hasRequiredRank and not canAfford then
            alienButton.Button:SetColor(AlienBuyMenu.kCannotBuyColor)
        elseif not hasRequiredRank then
            alienButton.Button:SetColor(AlienBuyMenu.kDisabledColor)
        end

        local mouseOver = self:_GetIsMouseOver(alienButton.Button)

        if mouseOver then

            local classStats = AlienBuy_GetClassStats(AlienBuyMenu.kAlienTypes[alienButton.TypeData.Index].Index)
            local mouseOverName = AlienBuyMenu.kAlienTypes[alienButton.TypeData.Index].LocaleName
            local health = classStats[2]
            local armor = classStats[3]
            self:_ShowMouseOverInfo(mouseOverName, GetTooltipInfoText(IndexToAlienTechId(alienButton.TypeData.Index)), cost, health, armor)

        end

        -- Only show the background if the mouse is over this button.
        alienButton.SelectedBackground:SetColor(Color(1, 1, 1, ((mouseOver and 1) or 0)))

        local offset = Vector(
            (((alienButton.TypeData.XPos - 1) / numAlienTypes) * (AlienBuyMenu.kAlienButtonSize.x * numAlienTypes)) - (totalAlienButtonsWidth / 2),
            AlienBuyMenu.kAlienButtonOffsetY,
            0
        )
        alienButton.SelectedBackground:SetPosition(Vector(-AlienBuyMenu.kAlienButtonSize.x / 2, -AlienBuyMenu.kAlienSelectedButtonSize.y / 2 - alienButton.ARAdjustedHeight / 2, 0) + offset)

        alienButton.PlayersText:SetText("x" .. ToString(ScoreboardUI_GetNumberOfAliensByType(alienButton.TypeData.Name)))

        minY = math.min(minY, alienButton.SelectedBackground:GetPosition().y)

    end

    self.lifeformHeaderText:SetPosition(Vector(0, minY, 0) + AlienBuyMenu.kLifeformsTitleOffset)

end

function AlienBuyMenu:_UpdateEvolveButton()

    local player = Client.GetLocalPlayer()
    local numberOfSelectedUpgrades = GetNumberOfNewlySelectedUpgrades(self)
    local evolveButtonTextureCoords = GUIAlienBuyMenu.kEvolveButtonTextureCoordinates
    local evolveCost = GetTotalCost(self)
    local canAfford = evolveCost <= player.combatUpgradePoints
    local allowedToEvolve = false
    local hasGameStarted = PlayerUI_GetHasGameStarted()
    local evolveText = Locale.ResolveString("ABM_GAME_NOT_STARTED")

    if hasGameStarted then

        evolveText = Locale.ResolveString("ABM_SELECT_UPGRADES")

        -- If the current alien is selected with no upgrades, cannot evolve.
        if self.selectedAlienType == AlienBuy_GetCurrentAlien() and numberOfSelectedUpgrades == 0 then

            evolveButtonTextureCoords = AlienBuyMenu.kEvolveButtonNeedResourcesTextureCoordinates

        elseif not canAfford then

            -- If cannot afford selected alien type and/or upgrades, cannot evolve.
            evolveButtonTextureCoords = AlienBuyMenu.kEvolveButtonNeedResourcesTextureCoordinates
            evolveText = "Need More Upgrade Points"

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

local kDefaultColor = Color(kIconColors[kAlienTeamType])
local kNotAvailableColor = Color(0.0, 0.0, 0.0, 1)
local kNotAllowedColor = Color(1, 0,0,1)
local kPurchasedColor = Color(1, 0.6, 0, 1)

function AlienBuyMenu:_UpdateAbilities()

    local player = Client.GetLocalPlayer()

    for index, abilityItem in ipairs(self.abilityIcons) do

        local cost = LookupUpgradeData(abilityItem.TechId, kUpDataCostIndex)
        local canAfford = cost <= player.combatUpgradePoints
        local hasRequiredRank = LookupUpgradeData(abilityItem.TechId, kUpDataRankIndex) <= player.combatRank

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

local function HasMutualExclusivity(self, techId)

    -- check purchased upgrades for mutual exclusivity
    -- for k, node in ipairs(GetUpgradeTree():GetPurchasedUpgrades()) do

    --     if node:IsMutuallyExclusiveTo(techId) then
    --         return true
    --     end

    -- end

    -- check queued 'potential' upgrades for mutual exclusivity
    for j, upgradeTechId in ipairs(self.upgradeList) do
        
        for _, mutualExclusiveTechId in ipairs(LookupUpgradeData(upgradeTechId, kUpDataMutuallyExclusiveIndex)) do

            if techId == mutualExclusiveTechId then
                return true
            end

        end

    end

    return false
    
end

local function IsPurchasedOrPurchasing(self, techId)

    local node = GetUpgradeTree():GetNode(techId)

    if node:GetIsPurchased() then
        return true
    end

    for j, upgradeTechId in ipairs(self.upgradeList) do

        if techId == upgradeTechId then
            return true
        end

    end

    return false

end

function AlienBuyMenu:_UpdateUpgrades(deltaTime)

    local player = Client.GetLocalPlayer()

    for _, button in ipairs(self.techButtons) do

        button:SetIsUnlocked(GetUpgradeTree():GetIsUnlocked(button.TechId))
        button:SetIsPurchased(GetUpgradeTree():GetNode(button.TechId):GetIsPurchased())

        local canAfford = (player:GetCombatUpgradePoints() - GetTotalCost(self)) > 0
        button:SetIsEnabled(IsPurchasedOrPurchasing(self, button.TechId) or (canAfford and not HasMutualExclusivity(self, button.TechId)))

        button:Update(deltaTime)

        if self:_GetIsMouseOver(button.Icon) then

            local currentUpgradeInfoText = GetDisplayNameForTechId(button.TechId)
            local cost = LookupUpgradeData(button.TechId, kUpDataCostIndex)

            self:_ShowMouseOverInfo(currentUpgradeInfoText, button.ToolTip, cost)

        end

    end

end

function AlienBuyMenu:_ShowMouseOverInfo(lifeformText, infoText, costAmount, health, armor)

    -- show the panel
    self.mouseOverPanel:SetIsVisible(true)

    self.mouseOverTitleShadow:SetText(lifeformText)
    self.mouseOverTitle:SetText(lifeformText)

    self.mouseOverInfo:SetText(infoText)
    self.mouseOverInfo:SetTextClipped(true, self.mouseOverPanel:GetSize().x - AlienBuyMenu.kMouseOverInfoOffset.x, self.mouseOverPanel:GetSize().y - AlienBuyMenu.kMouseOverInfoOffset.y)

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

function AlienBuyMenu:_HideMouseOverInfo()

    self.mouseOverPanel:SetIsVisible(false)

end

local function MarkAlreadyPurchased( self )
    local isAlreadySelectedAlien = self.selectedAlienType ~= AlienBuy_GetCurrentAlien()
    for i, currentButton in ipairs(self.upgradeButtons) do
        currentButton.Purchased = isAlreadySelectedAlien and AlienBuy_GetUpgradePurchased( currentButton.TechId )
    end
end

local function SelectButton( self, button )
    if not button.IsSelected then
        button:SetIsSelected(true)
        table.insertunique(self.upgradeList, button.TechId)
    end
end

local function DeselectButton( self, button )
    if button.IsSelected then
        button:SetIsSelected(false)
        table.removevalue( self.upgradeList, button.TechId )
    end
end

local function ToggleButton( self,  button )
    if button.IsSelected then
        DeselectButton( self, button )
    else
        SelectButton( self, button )
    end
end

function AlienBuyMenu:SetPurchasedSelected()

    for i, button in ipairs(self.upgradeButtons) do
        if button.Purchased then
            SelectButton( self, button )
        else
            DeselectButton( self, button )
        end
    end

end

function AlienBuyMenu:SendKeyEvent(key, down)

    local closeMenu = false
    local inputHandled = false

    if key == InputKey.MouseButton0 and self.mousePressed ~= down then

        self.mousePressed = down

        local mouseX, mouseY = Client.GetCursorPosScreen()
        local player = Client.GetLocalPlayer()

        if down then

            local numberOfSelectedUpgrades = GetNumberOfNewlySelectedUpgrades(self)
            local evolveCost = GetTotalCost(self)
            local canAfford = evolveCost <= player.combatUpgradePoints

            local allowedToEvolve = canAfford and (self.selectedAlienType ~= AlienBuy_GetCurrentAlien() or  numberOfSelectedUpgrades > 0)
            if allowedToEvolve and self:_GetIsMouseOver(self.evolveButtonBackground) then

                local purchases = { }
                -- Buy the selected alien if we have a different one selected.
                if self.selectedAlienType ~= AlienBuy_GetCurrentAlien() then
                    table.insert(purchases, { Type = "Alien", Alien = self.selectedAlienType })
                end

                -- Buy all selected upgrades.
                for i, currentButton in ipairs(self.techButtons) do

                    if currentButton.IsSelected then
                        table.insert(purchases, { Type = "Upgrade", Alien = self.selectedAlienType, TechId = currentButton.TechId })
                    end

                end

                closeMenu = true
                inputHandled = true

                if #purchases > 0 then
                    CombatPlusPlus_AlienPurchase(purchases)
                end

                AlienBuy_OnPurchase()

            end

            inputHandled = self:_HandleUpgradeClicked(mouseX, mouseY) or inputHandled

            if not inputHandled then

                -- Check if an alien was selected.
                for k, buttonItem in ipairs(self.alienButtons) do

                    local itemTechId = buttonItem.TypeData.TechId
                    local cost = LookupUpgradeData(itemTechId, kUpDataCostIndex)
                    local canAfford = cost <= player.combatUpgradePoints
                    local hasRequiredRank = LookupUpgradeData(itemTechId, kUpDataRankIndex) <= player.combatRank

                    if canAfford and hasRequiredRank and self:_GetIsMouseOver(buttonItem.Button) then

                        -- Deselect all upgrades when a different alien type is selected.
                        if self.selectedAlienType ~= buttonItem.TypeData.Index then

                            AlienBuy_OnSelectAlien(AlienBuyMenu.kAlienTypes[buttonItem.TypeData.Index].Name)

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

function AlienBuyMenu:GetCanSelect(upgradeButton, player)

    local isPassive = LookupUpgradeData(upgradeButton.TechId, kUpDataPassiveIndex)
    local unlocked = GetUpgradeTree():GetIsUnlocked(upgradeButton.TechId)
    local purchased = GetUpgradeTree():GetIsPurchased(upgradeButton.TechId)

    -- since you've already purchased it, it should be selectable
    return upgradeButton.IsEnabled and unlocked and not purchased and not isPassive

end


function AlienBuyMenu:_HandleUpgradeClicked(mouseX, mouseY)

    local inputHandled = false
    local player = Client.GetLocalPlayer()

    for i, currentButton in ipairs(self.techButtons) do
        -- Can't select if it has been purchased already.

        local allowedToUnselect = currentButton.IsSelected
        local allowedToPuchase = not currentButton.IsSelected and self:GetCanSelect(currentButton, player)

        if (allowedToUnselect or allowedToPuchase) and self:_GetIsMouseOver(currentButton.Icon) then

            -- Deselect or Select current button
            ToggleButton( self, currentButton )

            if currentButton.IsSelected then

                --local hiveTypeCurrent = GetHiveTypeForUpgrade( currentButton.TechId )

                -- for j, otherButton in ipairs(self.upgradeButtons) do

                --     if currentButton ~= otherButton and otherButton.Selected then

                --         local hiveTypeOther = GetHiveTypeForUpgrade( otherButton.TechId )
                --         if hiveTypeCurrent == hiveTypeOther then
                --             DeselectButton( self, otherButton )
                --         end

                --     end

                -- end

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
