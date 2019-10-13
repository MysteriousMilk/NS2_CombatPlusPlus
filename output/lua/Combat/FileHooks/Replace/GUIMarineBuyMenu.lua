--[[
 * Natural Selection 2 - Combat++ Mod
 * Authors:
 *          WhiteWizard
 *
 * New GUI that appears when the marines attempt to buy something using the 'B' key.
]]

Script.Load("lua/GUIAnimatedScript.lua")
Script.Load("lua/Combat/ClientBuyUI.lua")

class 'GUIMarineBuyMenu' (GUIAnimatedScript)

GUIMarineBuyMenu.kBackgroundColor = Color(0.05, 0.05, 0.1, 0.3)
GUIMarineBuyMenu.kBackgroundCenterColor = Color(0.06, 0.06, 0.12, 0.4)
GUIMarineBuyMenu.kBackgroundSize = Vector(1024, 1024, 0)

GUIMarineBuyMenu.kLogoTexture = PrecacheAsset("ui/logo_marine.dds")
GUIMarineBuyMenu.kSmallButtonTexture = PrecacheAsset("ui/combatui_marine_btn_48x48.dds")
GUIMarineBuyMenu.kButtonTexture = PrecacheAsset("ui/combatui_buymenu_button.dds")
GUIMarineBuyMenu.kButtonLargeTexture = PrecacheAsset("ui/combatui_buymenu_button_large.dds")
GUIMarineBuyMenu.kResIconTexture = PrecacheAsset("ui/pres_icon_big.dds")
GUIMarineBuyMenu.kLevelUpIconTexture = PrecacheAsset("ui/levelup_icon.dds")
GUIMarineBuyMenu.kInfoBackgroundTexture = PrecacheAsset("ui/combatui_marine_info_bkg.dds")
GUIMarineBuyMenu.kCooldownIconTexture = PrecacheAsset("ui/cooldown_icon.dds")
GUIMarineBuyMenu.kInfiniteIconTexture = PrecacheAsset("ui/infinite_icon.dds")
GUIMarineBuyMenu.kRefundTexture = PrecacheAsset("ui/refund_icon.dds")
GUIMarineBuyMenu.kRecycleTexture = PrecacheAsset("ui/recycle_icon.dds")

GUIMarineBuyMenu.kIconTextureCoords = { 0, 0, 256, 256 }
GUIMarineBuyMenu.kUpgradePointIconTexCoords = { 0, 0, 48, 48 }
GUIMarineBuyMenu.kLevelUpIconTexCoords = { 0, 0, 128, 128 }
GUIMarineBuyMenu.kInfoBackgroundTexCoords = { 0, 0, 400, 400 }
GUIMarineBuyMenu.kButtonTexCoords =  { 0, 0, 200, 64 }
GUIMarineBuyMenu.kLargeButtonTexCoords =  { 0, 0, 128, 192 }
GUIMarineBuyMenu.kSmallButtonTexCoords = { 0, 0, 48, 48 }
GUIMarineBuyMenu.kSmallIconTexCoords = { 0, 0, 80, 80 }

GUIMarineBuyMenu.kTitleFont = Fonts.kAgencyFB_Large
GUIMarineBuyMenu.kHeaderFont = Fonts.kAgencyFB_Medium
GUIMarineBuyMenu.kTextColor = Color(kMarineFontColor)

GUIMarineBuyMenu.kBtnColor = Color(1, 1, 1, 0.7)
GUIMarineBuyMenu.kBtnHighlightColor = Color(0.5, 0.5, 1.0, 0.7)

GUIMarineBuyMenu.kGreenHighlight = Color(0.4, 1, 0.4, 1)
GUIMarineBuyMenu.kRedHighlight = Color(1, 0.3, 0.3, 1)
GUIMarineBuyMenu.kGreyHighlight = Color(0.6, 0.6, 0.6, 1)

GUIMarineBuyMenu.kButtonsPerRow = 4

local function GetIsHardCapped(techId, player)

    if CombatPlusPlus_GetIsStructureTechId(techId) then
        return CombatPlusPlus_GetStructureCountForTeam(techId, player:GetTeamNumber()) >= LookupUpgradeData(techId, kUpDataHardCapIndex)
    end

    return false

end

--
-- Checks if the mouse is over the passed in GUIItem and plays a sound if it has just moved over.
--
local function GetIsMouseOver(self, overItem)

    local mouseOver = GUIItemContainsPoint(overItem, Client.GetCursorPosScreen())
    if mouseOver and not self.mouseOverStates[overItem] then
        MarineBuy_OnMouseOver()
    end
    self.mouseOverStates[overItem] = mouseOver
    return mouseOver

end

local function UpdateItemsGUIScale(self)

    --background
    GUIMarineBuyMenu.kBkgCenteredWidth = GUIScaleWidth(1000)

    -- marine logo
    GUIMarineBuyMenu.kLogoSize = Vector(GUIScaleWidth(90), GUIScaleHeight(90), 0)
    GUIMarineBuyMenu.kLogoPosition = Vector(GUIScaleWidth(60), GUIScaleHeight(20), 0)

    -- main header
    GUIMarineBuyMenu.kTitleTextOffset = Vector(GUIScaleWidth(180), GUIScaleHeight(40), 0)
    GUIMarineBuyMenu.kSubTitleTextOffset = Vector(GUIScaleWidth(180), GUIScaleHeight(80), 0)
    GUIMarineBuyMenu.kUpgradePointTextOffset = Vector(GUIScaleWidth(-60), GUIScaleHeight(55), 0)
    GUIMarineBuyMenu.kUpgradePointIconSize = Vector(GUIScaleWidth(36), GUIScaleHeight(36), 0)
    GUIMarineBuyMenu.kUpgradePointIconPos = Vector(GUIScaleWidth(-100), GUIScaleHeight(36), 0)
    GUIMarineBuyMenu.kHelpTextOffset = Vector(GUIScaleWidth(-60), GUIScaleHeight(85), 0)

    GUIMarineBuyMenu.kCenterColumnGapWidth = GUIScaleWidth(40)

    -- class section
    GUIMarineBuyMenu.kClassHeaderTextOffset = Vector(GUIScaleWidth(60), GUIScaleHeight(192), 0)
    GUIMarineBuyMenu.kClassButtonStartOffset = Vector(GUIScaleWidth(60), GUIScaleHeight(217), 0)

    -- weapons section
    GUIMarineBuyMenu.kWeaponHeaderTextOffset = Vector(GUIScaleWidth(270), GUIScaleHeight(192), 0)
    GUIMarineBuyMenu.kWeaponButtonStartOffset = Vector(GUIScaleWidth(270), GUIScaleHeight(217), 0)

    -- upgrades section
    GUIMarineBuyMenu.kUpgradeHeaderTextOffset = Vector(GUIScaleWidth(730), GUIScaleHeight(192), 0)
    GUIMarineBuyMenu.kUpgradeButtonStartOffset = Vector(GUIScaleWidth(730), GUIScaleHeight(217), 0)

    -- tech section
    GUIMarineBuyMenu.kTechHeaderTextOffset = Vector(GUIScaleWidth(520), GUIScaleHeight(192), 0)
    GUIMarineBuyMenu.kTechButtonStartOffset = Vector(GUIScaleWidth(520), GUIScaleHeight(217), 0)

    -- structure section
    GUIMarineBuyMenu.kStructureHeaderTextOffset = Vector(GUIScaleWidth(60), GUIScaleHeight(644), 0)
    GUIMarineBuyMenu.kStructureButtonStartOffset = Vector(GUIScaleWidth(60), GUIScaleHeight(669), 0)

    -- buttons
    GUIMarineBuyMenu.kButtonSize = Vector(GUIScaleWidth(200), GUIScaleHeight(64), 0)
    GUIMarineBuyMenu.kButtonPadding = Vector(GUIScaleWidth(10), GUIScaleHeight(10), 0)
    GUIMarineBuyMenu.kButtonTextOffset = Vector(GUIScaleWidth(-6), GUIScaleHeight(14), 0)
    GUIMarineBuyMenu.kButtonCostIconSize = Vector(GUIScaleWidth(20), GUIScaleHeight(20), 0)
    GUIMarineBuyMenu.kButtonCostIconPos = Vector(GUIScaleWidth(-36), GUIScaleHeight(-24), 0)
    GUIMarineBuyMenu.kButtonCostTextOffset = Vector(GUIScaleWidth(-8), GUIScaleHeight(-14), 0)
    GUIMarineBuyMenu.kButtonRankIconSize = Vector(GUIScaleWidth(16), GUIScaleHeight(16), 0)
    GUIMarineBuyMenu.kButtonRankIconPos = Vector(GUIScaleWidth(-70), GUIScaleHeight(-24), 0)
    GUIMarineBuyMenu.kButtonRankTextOffset = Vector(GUIScaleWidth(-44), GUIScaleHeight(-14), 0)

    -- large buttons
    GUIMarineBuyMenu.kButtonLargeSize = Vector(GUIScaleWidth(128), GUIScaleHeight(192), 0)
    GUIMarineBuyMenu.kButtonLargePadding = Vector(GUIScaleWidth(10), GUIScaleHeight(10), 0)
    GUIMarineBuyMenu.kButtonLargeTextOffset = Vector(GUIScaleWidth(6), GUIScaleHeight(-14), 0)
    GUIMarineBuyMenu.kButtonLargeCostIconPos = Vector(GUIScaleWidth(-32), GUIScaleHeight(-22), 0)
    GUIMarineBuyMenu.kButtonLargeCostTextOffset = Vector(GUIScaleWidth(-5), GUIScaleHeight(-12), 0)
    GUIMarineBuyMenu.kButtonLargeRankIconPos = Vector(GUIScaleWidth(-32), GUIScaleHeight(-40), 0)
    GUIMarineBuyMenu.kButtonLargeRankTextOffset = Vector(GUIScaleWidth(-5), GUIScaleHeight(-30), 0)
    GUIMarineBuyMenu.kButtonLargeHardcapTextOffset = Vector(GUIScaleWidth(-4), GUIScaleHeight(4), 0)

    -- mouse over info
    GUIMarineBuyMenu.kInfoBackgroundSize = Vector(GUIScaleWidth(394), GUIScaleHeight(394), 0)
    GUIMarineBuyMenu.kInfoBackgroundPos = Vector(GUIScaleWidth(520), GUIScaleHeight(669), 0)
    GUIMarineBuyMenu.kInfoTitleOffset = Vector(GUIScaleWidth(10), GUIScaleHeight(25), 0)
    GUIMarineBuyMenu.kInfoTextOffset = Vector(GUIScaleWidth(10), GUIScaleHeight(50), 0)
    GUIMarineBuyMenu.kInfoIconOffset = Vector(0, GUIScaleHeight(70), 0)
    GUIMarineBuyMenu.kInfoSmallIconSize = Vector(GUIScaleWidth(28), GUIScaleHeight(28), 0)
    GUIMarineBuyMenu.kInfoCostTextOffset = Vector(GUIScaleWidth(-18), GUIScaleHeight(11), 0)
    GUIMarineBuyMenu.kInfoCostIconOffset = Vector(GUIScaleWidth(-48), GUIScaleHeight(10), 0)
    GUIMarineBuyMenu.kInfoRankTextOffset = Vector(GUIScaleWidth(-62), GUIScaleHeight(11), 0)
    GUIMarineBuyMenu.kInfoRankIconOffset = Vector(GUIScaleWidth(-92), GUIScaleHeight(10), 0)
    GUIMarineBuyMenu.kInfoCooldownTextOffset = Vector(GUIScaleWidth(-120), GUIScaleHeight(11), 0)
    GUIMarineBuyMenu.kInfoCooldownIconOffset = Vector(GUIScaleWidth(-150), GUIScaleHeight(10), 0)
    GUIMarineBuyMenu.kInfoPersistIconOffsetMin = Vector(GUIScaleWidth(-122), GUIScaleHeight(10), 0)
    GUIMarineBuyMenu.kInfoPersistIconOffsetMax = Vector(GUIScaleWidth(-180), GUIScaleHeight(10), 0)

    -- recycle/refund buttons
    GUIMarineBuyMenu.kSmallButtonSize = Vector(GUIScaleWidth(48), GUIScaleHeight(48), 0)
    GUIMarineBuyMenu.kSmallButtonIconSize = Vector(GUIScaleWidth(44), GUIScaleHeight(44), 0)

    GUIMarineBuyMenu.kRefundButtonPosition = Vector(GUIScaleWidth(-118), GUIScaleHeight(110), 0)
    GUIMarineBuyMenu.kRecycleButtonPosition = Vector(GUIScaleWidth(-176), GUIScaleHeight(110), 0)

end

function GUIMarineBuyMenu:Initialize()

    GUIAnimatedScript.Initialize(self)

    UpdateItemsGUIScale(self)

    self.mouseOverStates = { }

    self:_InitializeBackground()
    self:_InitializeHeaders()
    self:_InitializeMouseOverInfo()
    self:_InitializeButtons()

    MarineBuy_OnOpen()
    MouseTracker_SetIsVisible(true, "ui/Cursor_MenuDefault.dds", true)

end

function GUIMarineBuyMenu:Update(deltaTime)

    PROFILE("GUIMarineBuyMenu:Update")

    GUIAnimatedScript.Update(self, deltaTime)
    self:_UpdateItemButtons(deltaTime)

end

function GUIMarineBuyMenu:Uninitialize()

    GUIAnimatedScript.Uninitialize(self)

    GUI.DestroyItem(self.background)
    self.background = nil

    MouseTracker_SetIsVisible(false)

end

function GUIMarineBuyMenu:OnResolutionChanged(oldX, oldY, newX, newY)

    self:Uninitialize()
    self:Initialize()

    MarineBuy_OnClose()

end

function GUIMarineBuyMenu:_InitializeBackground()

    self.background = GUIManager:CreateGraphicItem()
    self.background:SetSize( Vector(Client.GetScreenWidth(), Client.GetScreenHeight(), 0) )
    self.background:SetAnchor(GUIItem.Left, GUIItem.Top)
    self.background:SetColor(GUIMarineBuyMenu.kBackgroundColor)
    self.background:SetLayer(kGUILayerPlayerHUDForeground4)

    self.backgroundCenteredArea = GUIManager:CreateGraphicItem()
    self.backgroundCenteredArea:SetSize( Vector(GUIMarineBuyMenu.kBkgCenteredWidth, Client.GetScreenHeight(), 0) )
    self.backgroundCenteredArea:SetAnchor(GUIItem.Middle, GUIItem.Top)
    self.backgroundCenteredArea:SetPosition( Vector(-(GUIMarineBuyMenu.kBkgCenteredWidth / 2), 0, 0) )
    self.backgroundCenteredArea:SetColor(GUIMarineBuyMenu.kBackgroundCenterColor)
    self.background:AddChild(self.backgroundCenteredArea)

end

function GUIMarineBuyMenu:_InitializeHeaders()

    local player = Client.GetLocalPlayer()

    self.logo = GetGUIManager():CreateGraphicItem()
    self.logo:SetSize( GUIMarineBuyMenu.kLogoSize )
    self.logo:SetAnchor(GUIItem.Left, GUIItem.Top)
    self.logo:SetPosition( GUIMarineBuyMenu.kLogoPosition )
    self.logo:SetTexture(GUIMarineBuyMenu.kLogoTexture)
    self.logo:SetTexturePixelCoordinates(unpack(GUIMarineBuyMenu.kIconTextureCoords))
    self.backgroundCenteredArea:AddChild(self.logo)

    self.titleText = GetGUIManager():CreateTextItem()
    self.titleText:SetFontName(GUIMarineBuyMenu.kTitleFont)
    self.titleText:SetFontIsBold(true)
    self.titleText:SetScale(GetScaledVector())
    GUIMakeFontScale(self.titleText)
    self.titleText:SetAnchor(GUIItem.Left, GUIItem.Top)
    self.titleText:SetPosition( GUIMarineBuyMenu.kTitleTextOffset )
    self.titleText:SetTextAlignmentX(GUIItem.Align_Min)
    self.titleText:SetTextAlignmentY(GUIItem.Align_Center)
    self.titleText:SetColor(GUIMarineBuyMenu.kTextColor)
    self.titleText:SetText("TSE Uplink Established")
    self.titleText:SetIsVisible(true)
    self.backgroundCenteredArea:AddChild(self.titleText)

    self.subTitleText = GetGUIManager():CreateTextItem()
    self.subTitleText:SetFontName(GUIMarineBuyMenu.kHeaderFont)
    self.subTitleText:SetFontIsBold(true)
    self.subTitleText:SetScale(GetScaledVector())
    GUIMakeFontScale(self.subTitleText)
    self.subTitleText:SetAnchor(GUIItem.Left, GUIItem.Top)
    self.subTitleText:SetPosition( GUIMarineBuyMenu.kSubTitleTextOffset )
    self.subTitleText:SetTextAlignmentX(GUIItem.Align_Min)
    self.subTitleText:SetTextAlignmentY(GUIItem.Align_Center)
    self.subTitleText:SetColor(GUIMarineBuyMenu.kTextColor)
    self.subTitleText:SetText(string.format("Logged in as %s", player:GetName()))
    self.subTitleText:SetIsVisible(true)
    self.backgroundCenteredArea:AddChild(self.subTitleText)

    self.upgradePointText = GetGUIManager():CreateTextItem()
    self.upgradePointText:SetFontName(Fonts.kAgencyFB_Small)
    self.upgradePointText:SetFontIsBold(true)
    self.upgradePointText:SetScale(GetScaledVector())
    GUIMakeFontScale(self.upgradePointText)
    self.upgradePointText:SetAnchor(GUIItem.Right, GUIItem.Top)
    self.upgradePointText:SetPosition( GUIMarineBuyMenu.kUpgradePointTextOffset )
    self.upgradePointText:SetTextAlignmentX(GUIItem.Align_Max)
    self.upgradePointText:SetTextAlignmentY(GUIItem.Align_Center)
    self.upgradePointText:SetColor(GUIMarineBuyMenu.kTextColor)
    self.upgradePointText:SetIsVisible(true)
    self.backgroundCenteredArea:AddChild(self.upgradePointText)

    -- update upgrade point text
    local points = player:GetCombatUpgradePoints()
    local pointStr = ConditionalValue(points == 1, string.format("%s Upgrade Point", points), string.format("%s Upgrade Points", points))
    self.upgradePointText:SetText(pointStr)

    local textSize = Fancy_CalculateTextSize(pointStr, Fonts.kAgencyFB_Small)

    self.upgradePointIcon = GetGUIManager():CreateGraphicItem()
    self.upgradePointIcon:SetSize( GUIMarineBuyMenu.kUpgradePointIconSize )
    self.upgradePointIcon:SetAnchor(GUIItem.Right, GUIItem.Top)
    self.upgradePointIcon:SetPosition( Vector(-textSize.x, 0, 0) + GUIMarineBuyMenu.kUpgradePointIconPos )
    self.upgradePointIcon:SetTexture(GUIMarineBuyMenu.kResIconTexture)
    self.upgradePointIcon:SetTexturePixelCoordinates(unpack(GUIMarineBuyMenu.kUpgradePointIconTexCoords))
    self.backgroundCenteredArea:AddChild(self.upgradePointIcon)

    self.helpText = GetGUIManager():CreateTextItem()
    self.helpText:SetFontName(Fonts.kAgencyFB_Tiny)
    self.helpText:SetScale(GetScaledVector())
    GUIMakeFontScale(self.helpText)
    self.helpText:SetAnchor(GUIItem.Right, GUIItem.Top)
    self.helpText:SetTextAlignmentX(GUIItem.Align_Min)
    self.helpText:SetTextAlignmentY(GUIItem.Align_Center)
    self.helpText:SetColor(GUIMarineBuyMenu.kTextColor)
    self.helpText:SetIsVisible(false)
    self.backgroundCenteredArea:AddChild(self.helpText)

    self.classHeaderText = GetGUIManager():CreateTextItem()
    self.classHeaderText:SetFontName(GUIMarineBuyMenu.kHeaderFont)
    self.classHeaderText:SetFontIsBold(true)
    self.classHeaderText:SetScale(GetScaledVector())
    GUIMakeFontScale(self.classHeaderText)
    self.classHeaderText:SetAnchor(GUIItem.Left, GUIItem.Top)
    self.classHeaderText:SetPosition(GUIMarineBuyMenu.kClassHeaderTextOffset)
    self.classHeaderText:SetTextAlignmentX(GUIItem.Align_Min)
    self.classHeaderText:SetTextAlignmentY(GUIItem.Align_Center)
    self.classHeaderText:SetColor(GUIMarineBuyMenu.kTextColor)
    self.classHeaderText:SetText("Class")
    self.classHeaderText:SetIsVisible(true)
    self.backgroundCenteredArea:AddChild(self.classHeaderText)

    self.wpnHeaderText = GetGUIManager():CreateTextItem()
    self.wpnHeaderText:SetFontName(GUIMarineBuyMenu.kHeaderFont)
    self.wpnHeaderText:SetFontIsBold(true)
    self.wpnHeaderText:SetScale(GetScaledVector())
    GUIMakeFontScale(self.wpnHeaderText)
    self.wpnHeaderText:SetAnchor(GUIItem.Left, GUIItem.Top)
    self.wpnHeaderText:SetPosition(GUIMarineBuyMenu.kWeaponHeaderTextOffset)
    self.wpnHeaderText:SetTextAlignmentX(GUIItem.Align_Min)
    self.wpnHeaderText:SetTextAlignmentY(GUIItem.Align_Center)
    self.wpnHeaderText:SetColor(GUIMarineBuyMenu.kTextColor)
    self.wpnHeaderText:SetText("Weapons")
    self.wpnHeaderText:SetIsVisible(true)
    self.backgroundCenteredArea:AddChild(self.wpnHeaderText)

    self.upgradeHeaderText = GetGUIManager():CreateTextItem()
    self.upgradeHeaderText:SetFontName(GUIMarineBuyMenu.kHeaderFont)
    self.upgradeHeaderText:SetFontIsBold(true)
    self.upgradeHeaderText:SetScale(GetScaledVector())
    GUIMakeFontScale(self.upgradeHeaderText)
    self.upgradeHeaderText:SetAnchor(GUIItem.Left, GUIItem.Top)
    self.upgradeHeaderText:SetPosition(GUIMarineBuyMenu.kUpgradeHeaderTextOffset)
    self.upgradeHeaderText:SetTextAlignmentX(GUIItem.Align_Min)
    self.upgradeHeaderText:SetTextAlignmentY(GUIItem.Align_Center)
    self.upgradeHeaderText:SetColor(GUIMarineBuyMenu.kTextColor)
    self.upgradeHeaderText:SetText("Upgrades")
    self.upgradeHeaderText:SetIsVisible(true)
    self.backgroundCenteredArea:AddChild(self.upgradeHeaderText)

    self.techHeaderText = GetGUIManager():CreateTextItem()
    self.techHeaderText:SetFontName(GUIMarineBuyMenu.kHeaderFont)
    self.techHeaderText:SetFontIsBold(true)
    self.techHeaderText:SetScale(GetScaledVector())
    GUIMakeFontScale(self.techHeaderText)
    self.techHeaderText:SetAnchor(GUIItem.Left, GUIItem.Top)
    self.techHeaderText:SetPosition(GUIMarineBuyMenu.kTechHeaderTextOffset)
    self.techHeaderText:SetTextAlignmentX(GUIItem.Align_Min)
    self.techHeaderText:SetTextAlignmentY(GUIItem.Align_Center)
    self.techHeaderText:SetColor(GUIMarineBuyMenu.kTextColor)
    self.techHeaderText:SetText("Tech")
    self.techHeaderText:SetIsVisible(true)
    self.backgroundCenteredArea:AddChild(self.techHeaderText)

    self.structureHeaderText = GetGUIManager():CreateTextItem()
    self.structureHeaderText:SetFontName(GUIMarineBuyMenu.kHeaderFont)
    self.structureHeaderText:SetFontIsBold(true)
    self.structureHeaderText:SetScale(GetScaledVector())
    GUIMakeFontScale(self.structureHeaderText)
    self.structureHeaderText:SetAnchor(GUIItem.Left, GUIItem.Top)
    self.structureHeaderText:SetPosition(GUIMarineBuyMenu.kStructureHeaderTextOffset)
    self.structureHeaderText:SetTextAlignmentX(GUIItem.Align_Min)
    self.structureHeaderText:SetTextAlignmentY(GUIItem.Align_Center)
    self.structureHeaderText:SetColor(GUIMarineBuyMenu.kTextColor)
    self.structureHeaderText:SetText("Structures")
    self.structureHeaderText:SetIsVisible(true)
    self.backgroundCenteredArea:AddChild(self.structureHeaderText)

end

local function CreateRecycleRefundButtons(self)

    self.refundButton = GUIManager:CreateGraphicItem()
    self.refundButton:SetSize( GUIMarineBuyMenu.kSmallButtonSize )
    self.refundButton:SetAnchor(GUIItem.Right, GUIItem.Top)
    self.refundButton:SetPosition( GUIMarineBuyMenu.kRefundButtonPosition )
    self.refundButton:SetTexture(GUIMarineBuyMenu.kSmallButtonTexture)
    self.refundButton:SetTexturePixelCoordinates(unpack(GUIMarineBuyMenu.kSmallButtonTexCoords))
    self.refundButton:SetColor( GUIMarineBuyMenu.kBtnColor )

    local buttonIcon = GUIManager:CreateGraphicItem()
    buttonIcon:SetSize( GUIMarineBuyMenu.kSmallButtonIconSize )
    buttonIcon:SetAnchor(GUIItem.Middle, GUIItem.Center)
    buttonIcon:SetPosition( Vector(-GUIMarineBuyMenu.kSmallButtonIconSize.x / 2, -GUIMarineBuyMenu.kSmallButtonIconSize.y / 2, 0) )
    buttonIcon:SetTexture(GUIMarineBuyMenu.kRefundTexture)
    buttonIcon:SetTexturePixelCoordinates(unpack(GUIMarineBuyMenu.kSmallIconTexCoords))
    buttonIcon:SetColor(GUIMarineBuyMenu.kTextColor)
    self.refundButton:AddChild(buttonIcon)

    self.backgroundCenteredArea:AddChild(self.refundButton)

    self.recycleButton = GUIManager:CreateGraphicItem()
    self.recycleButton:SetSize( GUIMarineBuyMenu.kSmallButtonSize )
    self.recycleButton:SetAnchor(GUIItem.Right, GUIItem.Top)
    self.recycleButton:SetPosition( GUIMarineBuyMenu.kRecycleButtonPosition )
    self.recycleButton:SetTexture(GUIMarineBuyMenu.kSmallButtonTexture)
    self.recycleButton:SetTexturePixelCoordinates(unpack(GUIMarineBuyMenu.kSmallButtonTexCoords))
    self.recycleButton:SetColor( GUIMarineBuyMenu.kBtnColor )

    local buttonIcon2 = GUIManager:CreateGraphicItem()
    buttonIcon2:SetSize( GUIMarineBuyMenu.kSmallButtonIconSize )
    buttonIcon2:SetAnchor(GUIItem.Middle, GUIItem.Center)
    buttonIcon2:SetPosition( Vector(-GUIMarineBuyMenu.kSmallButtonIconSize.x / 2, -GUIMarineBuyMenu.kSmallButtonIconSize.y / 2, 0) )
    buttonIcon2:SetTexture(GUIMarineBuyMenu.kRecycleTexture)
    buttonIcon2:SetTexturePixelCoordinates(unpack(GUIMarineBuyMenu.kSmallIconTexCoords))
    buttonIcon2:SetColor(GUIMarineBuyMenu.kTextColor)
    self.recycleButton:AddChild(buttonIcon2)

    self.backgroundCenteredArea:AddChild(self.recycleButton)

end

local function CreateButton(x, y, iconColor, itemTechId, enabled, canAfford, hasRank)

    local cost = LookupUpgradeData(itemTechId, kUpDataCostIndex)
    local rank = LookupUpgradeData(itemTechId, kUpDataRankIndex)
    local iconTexture = LookupUpgradeData(itemTechId, kUpDataIconTextureIndex)
    local iconSize = LookupUpgradeData(itemTechId, kUpDataIconSizeIndex)
    
    local buttonGraphic = GUIManager:CreateGraphicItem()
    buttonGraphic:SetSize( GUIMarineBuyMenu.kButtonSize )
    buttonGraphic:SetAnchor(GUIItem.Left, GUIItem.Top)
    buttonGraphic:SetPosition( Vector(x, y, 0) )
    buttonGraphic:SetTexture(GUIMarineBuyMenu.kButtonTexture)
    buttonGraphic:SetTexturePixelCoordinates(unpack(GUIMarineBuyMenu.kButtonTexCoords))
    buttonGraphic:SetColor( GUIMarineBuyMenu.kBtnColor )

    if iconTexture and iconSize then

        local buttonIcon = GUIManager:CreateGraphicItem()
        buttonIcon:SetSize( Vector(GUIScaleWidth(iconSize.x), GUIScaleHeight(iconSize.y), 0) )
        buttonIcon:SetAnchor(GUIItem.Left, GUIItem.Top)
        buttonIcon:SetPosition( Vector(0, 0, 0) )
        buttonIcon:SetTexture(iconTexture)
        buttonIcon:SetTexturePixelCoordinates(unpack(CombatUI_GetMarineUpgradeTextureCoords(itemTechId, enabled)))
        buttonIcon:SetColor(iconColor)
        buttonGraphic:AddChild(buttonIcon)

    end

    local buttonText = GUIManager:CreateTextItem()
    buttonText:SetFontName(Fonts.kAgencyFB_Tiny)
    buttonText:SetScale(GetScaledVector())
    GUIMakeFontScale(buttonText)
    buttonText:SetAnchor(GUIItem.Right, GUIItem.Top)
    buttonText:SetPosition(GUIMarineBuyMenu.kButtonTextOffset)
    buttonText:SetTextAlignmentX(GUIItem.Align_Max)
    buttonText:SetTextAlignmentY(GUIItem.Align_Center)
    buttonText:SetColor(GUIMarineBuyMenu.kTextColor)
    buttonText:SetText(GetDisplayNameForTechId(itemTechId))
    buttonGraphic:AddChild(buttonText)

    local rankColor = ConditionalValue(hasRank, GUIMarineBuyMenu.kTextColor, GUIMarineBuyMenu.kRedHighlight)
    local rankIcon = GUIManager:CreateGraphicItem()
    rankIcon:SetSize(GUIMarineBuyMenu.kButtonRankIconSize )
    rankIcon:SetAnchor(GUIItem.Right, GUIItem.Bottom)
    rankIcon:SetPosition(GUIMarineBuyMenu.kButtonRankIconPos)
    rankIcon:SetTexture(GUIMarineBuyMenu.kLevelUpIconTexture)
    rankIcon:SetTexturePixelCoordinates(unpack(GUIMarineBuyMenu.kLevelUpIconTexCoords))
    rankIcon:SetColor(rankColor)
    buttonGraphic:AddChild(rankIcon)

    local rankText = GUIManager:CreateTextItem()
    rankText:SetFontName(Fonts.kAgencyFB_Tiny)
    rankText:SetScale(GetScaledVector())
    GUIMakeFontScale(rankText)
    rankText:SetAnchor(GUIItem.Right, GUIItem.Bottom)
    rankText:SetPosition(GUIMarineBuyMenu.kButtonRankTextOffset)
    rankText:SetTextAlignmentX(GUIItem.Align_Max)
    rankText:SetTextAlignmentY(GUIItem.Align_Center)
    rankText:SetColor(rankColor)
    rankText:SetText(string.format("%s", rank))
    buttonGraphic:AddChild(rankText)

    local costColor = ConditionalValue(canAfford, GUIMarineBuyMenu.kTextColor, GUIMarineBuyMenu.kRedHighlight)
    local costIcon = GUIManager:CreateGraphicItem()
    costIcon:SetSize( GUIMarineBuyMenu.kButtonCostIconSize )
    costIcon:SetAnchor(GUIItem.Right, GUIItem.Bottom)
    costIcon:SetPosition(GUIMarineBuyMenu.kButtonCostIconPos)
    costIcon:SetTexture(GUIMarineBuyMenu.kResIconTexture)
    costIcon:SetTexturePixelCoordinates(unpack(GUIMarineBuyMenu.kUpgradePointIconTexCoords))
    costIcon:SetColor(costColor)
    buttonGraphic:AddChild(costIcon)

    local costText = GUIManager:CreateTextItem()
    costText:SetFontName(Fonts.kAgencyFB_Tiny)
    costText:SetScale(GetScaledVector())
    GUIMakeFontScale(costText)
    costText:SetAnchor(GUIItem.Right, GUIItem.Bottom)
    costText:SetPosition(GUIMarineBuyMenu.kButtonCostTextOffset)
    costText:SetTextAlignmentX(GUIItem.Align_Max)
    costText:SetTextAlignmentY(GUIItem.Align_Center)
    costText:SetColor(costColor)
    costText:SetText(string.format("%s", cost))
    buttonGraphic:AddChild(costText)

    return buttonGraphic

end

local function InitClassButtons(self, player)

    local columnIndex = 0
    local rowIndex = 0
    local startOffset = GUIMarineBuyMenu.kClassButtonStartOffset

    for k, itemTechId in ipairs(LookupUpgradesByType(kCombatUpgradeType.Class, player:GetTeamNumber())) do

        if itemTechId ~= kTechId.Marine then
            
            local x = startOffset.x + (columnIndex * (GUIMarineBuyMenu.kButtonSize.x + GUIMarineBuyMenu.kButtonPadding.x))
            local y = startOffset.y + (rowIndex * (GUIMarineBuyMenu.kButtonSize.y + GUIMarineBuyMenu.kButtonPadding.y))

            local cost = LookupUpgradeData(itemTechId, kUpDataCostIndex)
            local rankRequired = LookupUpgradeData(itemTechId, kUpDataRankIndex)
            local equipped = player:GetHasUpgrade(itemTechId)
            local canAfford = cost <= player.combatUpgradePoints
            local hasRequiredRank = rankRequired <= player.combatRank

            local enabled = canAfford and hasRequiredRank and not equipped
            local iconColor = Color(1, 1, 1, 1)

            if equipped then
                iconColor = GUIMarineBuyMenu.kGreenHighlight
            elseif hasRequiredRank and not canAfford then
                iconColor = GUIMarineBuyMenu.kRedHighlight
            end

            local buttonGraphic = CreateButton(x, y, iconColor, itemTechId, enabled, canAfford, hasRequiredRank)
            self.backgroundCenteredArea:AddChild(buttonGraphic)

            rowIndex = rowIndex + 1

            table.insert(self.itemButtons, { Button = buttonGraphic, TechId = itemTechId } )

        end

    end

end

local function InitWeaponButtons(self, player)

    local columnIndex = 0
    local rowIndex = 0
    local startOffset = GUIMarineBuyMenu.kWeaponButtonStartOffset

    for k, itemTechId in ipairs(LookupUpgradesByCategory("Weapon", player:GetTeamNumber())) do

        local x = startOffset.x + (columnIndex * (GUIMarineBuyMenu.kButtonSize.x + GUIMarineBuyMenu.kButtonPadding.x))
        local y = startOffset.y + (rowIndex * (GUIMarineBuyMenu.kButtonSize.y + GUIMarineBuyMenu.kButtonPadding.y))

        local cost = LookupUpgradeData(itemTechId, kUpDataCostIndex)
        local rankRequired = LookupUpgradeData(itemTechId, kUpDataRankIndex)
        local equipped = player:GetHasUpgrade(itemTechId)
        local canAfford = cost <= player.combatUpgradePoints
        local hasRequiredRank = rankRequired <= player.combatRank

        local enabled = canAfford and hasRequiredRank and not equipped
        local iconColor = Color(1, 1, 1, 1)

        if equipped then
            iconColor = GUIMarineBuyMenu.kGreenHighlight
        elseif hasRequiredRank and not canAfford then
            iconColor = GUIMarineBuyMenu.kRedHighlight
        end

        local buttonGraphic = CreateButton(x, y, iconColor, itemTechId, enabled, canAfford, hasRequiredRank)
        self.backgroundCenteredArea:AddChild(buttonGraphic)

        rowIndex = rowIndex + 1

        table.insert(self.itemButtons, { Button = buttonGraphic, TechId = itemTechId } )

    end

end

local function InitUpgradeButtons(self, player)

    local columnIndex = 0
    local rowIndex = 0
    local startOffset = GUIMarineBuyMenu.kUpgradeButtonStartOffset

    local armorTechId = GetNextArmorTech(player)
    local wpnTechId = GetNextWeaponTech(player)

    local upgrades = LookupUpgradesByCategory("Consumable", player:GetTeamNumber())

    if armorTechId ~= kTechId.None then
        table.insert(upgrades, armorTechId)
    end

    if wpnTechId ~= kTechId.None then
        table.insert(upgrades, wpnTechId)
    end

    for k, itemTechId in ipairs(upgrades) do

        local x = startOffset.x + (columnIndex * (GUIMarineBuyMenu.kButtonSize.x + GUIMarineBuyMenu.kButtonPadding.x))
        local y = startOffset.y + (rowIndex * (GUIMarineBuyMenu.kButtonSize.y + GUIMarineBuyMenu.kButtonPadding.y))

        local cost = LookupUpgradeData(itemTechId, kUpDataCostIndex)
        local rankRequired = LookupUpgradeData(itemTechId, kUpDataRankIndex)
        local equipped = player:GetHasUpgrade(itemTechId)
        local hasPrereq = BuyUI_GetHasPrerequisites(itemTechId)
        local canAfford = cost <= player.combatUpgradePoints
        local hasRequiredRank = rankRequired <= player.combatRank

        local enabled = canAfford and hasRequiredRank and hasPrereq and not equipped
        local iconColor = Color(1, 1, 1, 1)

        if equipped then
            iconColor = GUIMarineBuyMenu.kGreenHighlight
        elseif hasRequiredRank and not canAfford then
            iconColor = GUIMarineBuyMenu.kRedHighlight
        elseif not enabled then
            iconColor = GUIMarineBuyMenu.kGreyHighlight
        end

        local buttonGraphic = CreateButton(x, y, iconColor, itemTechId, enabled, canAfford, hasRequiredRank)
        self.backgroundCenteredArea:AddChild(buttonGraphic)

        rowIndex = rowIndex + 1

        table.insert(self.itemButtons, { Button = buttonGraphic, TechId = itemTechId } )

    end

end

local function InitTechButtons(self, player)

    local columnIndex = 0
    local rowIndex = 0
    local startOffset = GUIMarineBuyMenu.kTechButtonStartOffset

    for k, itemTechId in ipairs(LookupUpgradesByCategory("Tech", player:GetTeamNumber())) do

        local x = startOffset.x + (columnIndex * (GUIMarineBuyMenu.kButtonSize.x + GUIMarineBuyMenu.kButtonPadding.x))
        local y = startOffset.y + (rowIndex * (GUIMarineBuyMenu.kButtonSize.y + GUIMarineBuyMenu.kButtonPadding.y))

        -- add a gap between column 2 and 3
        if columnIndex >= 2 then
            x = x + GUIMarineBuyMenu.kCenterColumnGapWidth
        end

        local cost = LookupUpgradeData(itemTechId, kUpDataCostIndex)
        local rankRequired = LookupUpgradeData(itemTechId, kUpDataRankIndex)
        local equipped = player:GetHasUpgrade(itemTechId)
        local canAfford = cost <= player.combatUpgradePoints
        local hasRequiredRank = rankRequired <= player.combatRank

        local enabled = canAfford and hasRequiredRank and not equipped
        local iconColor = Color(1, 1, 1, 1)

        if equipped then
            iconColor = GUIMarineBuyMenu.kGreenHighlight
        elseif hasRequiredRank and not canAfford then
            iconColor = GUIMarineBuyMenu.kRedHighlight
        end

        local buttonGraphic = CreateButton(x, y, iconColor, itemTechId, enabled, canAfford, hasRequiredRank)
        self.backgroundCenteredArea:AddChild(buttonGraphic)

        rowIndex = rowIndex + 1

        table.insert(self.itemButtons, { Button = buttonGraphic, TechId = itemTechId } )

    end

end

local function InitStructureButtons(self, player)

    local columnIndex = 0
    local rowIndex = 0
    local startOffset = GUIMarineBuyMenu.kStructureButtonStartOffset

    for k, itemTechId in ipairs(LookupUpgradesByCategory("Structures", player:GetTeamNumber())) do

        if columnIndex == 3 then

            columnIndex = 0
            rowIndex = rowIndex + 1

        end

        local x = startOffset.x + (columnIndex * (GUIMarineBuyMenu.kButtonLargeSize.x + GUIMarineBuyMenu.kButtonLargePadding.x))
        local y = startOffset.y + (rowIndex * (GUIMarineBuyMenu.kButtonLargeSize.y + GUIMarineBuyMenu.kButtonLargePadding.y))

        local buttonGraphic = GUIManager:CreateGraphicItem()
        buttonGraphic:SetSize( GUIMarineBuyMenu.kButtonLargeSize )
        buttonGraphic:SetAnchor(GUIItem.Left, GUIItem.Top)
        buttonGraphic:SetPosition( Vector(x, y, 0) )
        buttonGraphic:SetTexture(GUIMarineBuyMenu.kButtonLargeTexture)
        buttonGraphic:SetTexturePixelCoordinates(unpack(GUIMarineBuyMenu.kLargeButtonTexCoords))
        buttonGraphic:SetColor( GUIMarineBuyMenu.kBtnColor )
        self.backgroundCenteredArea:AddChild(buttonGraphic)

        local cost = LookupUpgradeData(itemTechId, kUpDataCostIndex)
        local rankRequired = LookupUpgradeData(itemTechId, kUpDataRankIndex)
        local canAfford = cost <= player.combatUpgradePoints
        local hasRequiredRank = rankRequired <= player.combatRank
        local isHardcapped = GetIsHardCapped(itemTechId, player)

        local enabled = canAfford and hasRequiredRank
        local iconColor = Color(1, 1, 1, 1)

        if (hasRequiredRank and not canAfford) or isHardcapped then
            iconColor = GUIMarineBuyMenu.kRedHighlight
        end

        local iconTexture = LookupUpgradeData(itemTechId, kUpDataIconTextureIndex)
        local iconSize = LookupUpgradeData(itemTechId, kUpDataIconSizeIndex)

        if iconTexture and iconSize then

            local buttonIcon = GUIManager:CreateGraphicItem()
            buttonIcon:SetSize(Vector(GUIScaleWidth(iconSize.x), GUIScaleHeight(iconSize.y), 0))
            buttonIcon:SetAnchor(GUIItem.Left, GUIItem.Top)
            buttonIcon:SetPosition( Vector(0, 0, 0) )
            buttonIcon:SetTexture(iconTexture)
            buttonIcon:SetTexturePixelCoordinates(unpack(CombatUI_GetMarineUpgradeTextureCoords(itemTechId, enabled)))
            buttonIcon:SetColor(iconColor)
            buttonGraphic:AddChild(buttonIcon)

        end

        local buttonText = GUIManager:CreateTextItem()
        buttonText:SetFontName(Fonts.kAgencyFB_Tiny)
        buttonText:SetScale(GetScaledVector())
        GUIMakeFontScale(buttonText)
        buttonText:SetAnchor(GUIItem.Left, GUIItem.Bottom)
        buttonText:SetPosition(GUIMarineBuyMenu.kButtonLargeTextOffset)
        buttonText:SetTextAlignmentX(GUIItem.Align_Min)
        buttonText:SetTextAlignmentY(GUIItem.Align_Center)
        buttonText:SetColor(GUIMarineBuyMenu.kTextColor)
        buttonText:SetText(GetDisplayNameForTechId(itemTechId))
        buttonGraphic:AddChild(buttonText)

        local costColor = GUIMarineBuyMenu.kTextColor
        if not canAfford or not hasRequiredRank then
            costColor = GUIMarineBuyMenu.kRedHighlight
        end

        local costIcon = GUIManager:CreateGraphicItem()
        costIcon:SetSize(GUIMarineBuyMenu.kButtonCostIconSize)
        costIcon:SetAnchor(GUIItem.Right, GUIItem.Bottom)
        costIcon:SetPosition(GUIMarineBuyMenu.kButtonLargeCostIconPos)
        costIcon:SetTexture(GUIMarineBuyMenu.kResIconTexture)
        costIcon:SetTexturePixelCoordinates(unpack(GUIMarineBuyMenu.kUpgradePointIconTexCoords))
        costIcon:SetColor(costColor)
        buttonGraphic:AddChild(costIcon)

        local costText = GUIManager:CreateTextItem()
        costText:SetFontName(Fonts.kAgencyFB_Tiny)
        costText:SetScale(GetScaledVector())
        GUIMakeFontScale(costText)
        costText:SetAnchor(GUIItem.Right, GUIItem.Bottom)
        costText:SetPosition(GUIMarineBuyMenu.kButtonLargeCostTextOffset)
        costText:SetTextAlignmentX(GUIItem.Align_Max)
        costText:SetTextAlignmentY(GUIItem.Align_Center)
        costText:SetColor(costColor)
        costText:SetText(string.format("%s", cost))
        buttonGraphic:AddChild(costText)

        local rankColor = GUIMarineBuyMenu.kTextColor
        if not canAfford or not hasRequiredRank then
            rankColor = GUIMarineBuyMenu.kRedHighlight
        end

        local rankIcon = GUIManager:CreateGraphicItem()
        rankIcon:SetSize(GUIMarineBuyMenu.kButtonRankIconSize)
        rankIcon:SetAnchor(GUIItem.Right, GUIItem.Bottom)
        rankIcon:SetPosition(GUIMarineBuyMenu.kButtonLargeRankIconPos)
        rankIcon:SetTexture(GUIMarineBuyMenu.kLevelUpIconTexture)
        rankIcon:SetTexturePixelCoordinates(unpack(GUIMarineBuyMenu.kLevelUpIconTexCoords))
        rankIcon:SetColor(rankColor)
        buttonGraphic:AddChild(rankIcon)

        local rankText = GUIManager:CreateTextItem()
        rankText:SetFontName(Fonts.kAgencyFB_Tiny)
        rankText:SetScale(GetScaledVector())
        GUIMakeFontScale(rankText)
        rankText:SetAnchor(GUIItem.Right, GUIItem.Bottom)
        rankText:SetPosition(GUIMarineBuyMenu.kButtonLargeRankTextOffset)
        rankText:SetTextAlignmentX(GUIItem.Align_Max)
        rankText:SetTextAlignmentY(GUIItem.Align_Center)
        rankText:SetColor(rankColor)
        rankText:SetText(string.format("%s", rankRequired))
        buttonGraphic:AddChild(rankText)

        local hardCapColor = GUIMarineBuyMenu.kTextColor
        if isHardcapped then
            hardCapColor = GUIMarineBuyMenu.kRedHighlight
        end

        local hardCapText = GUIManager:CreateTextItem()
        hardCapText:SetFontName(Fonts.kAgencyFB_Tiny)
        hardCapText:SetScale(GetScaledVector())
        GUIMakeFontScale(hardCapText)
        hardCapText:SetAnchor(GUIItem.Right, GUIItem.Top)
        hardCapText:SetPosition(GUIMarineBuyMenu.kButtonLargeHardcapTextOffset)
        hardCapText:SetTextAlignmentX(GUIItem.Align_Max)
        hardCapText:SetTextAlignmentY(GUIItem.Align_Min)
        hardCapText:SetColor(hardCapColor)
        hardCapText:SetText(string.format("%s/%s", CombatPlusPlus_GetStructureCountForTeam(itemTechId, player:GetTeamNumber()), LookupUpgradeData(itemTechId, kUpDataHardCapIndex)))
        buttonGraphic:AddChild(hardCapText)

        columnIndex = columnIndex + 1

        table.insert(self.itemButtons, { Button = buttonGraphic, TechId = itemTechId } )

    end

end

function GUIMarineBuyMenu:_InitializeButtons()

    local player = Client.GetLocalPlayer()

    self.itemButtons = { }

    CreateRecycleRefundButtons(self)
    InitClassButtons(self, player)
    InitWeaponButtons(self, player)
    InitUpgradeButtons(self, player)
    InitTechButtons(self, player)
    InitStructureButtons(self, player)

    -- to prevent wrong display before the first update
    self:_UpdateItemButtons(0)

end

function GUIMarineBuyMenu:_InitializeMouseOverInfo()

    self.infoBorder = GUIManager:CreateGraphicItem()
    self.infoBorder:SetAnchor(GUIItem.Left, GUIItem.Top)
    self.infoBorder:SetSize(GUIMarineBuyMenu.kInfoBackgroundSize)
    self.infoBorder:SetPosition(GUIMarineBuyMenu.kInfoBackgroundPos)
    self.infoBorder:SetTexture(GUIMarineBuyMenu.kInfoBackgroundTexture)
    self.infoBorder:SetTexturePixelCoordinates(unpack(GUIMarineBuyMenu.kInfoBackgroundTexCoords))
    self.infoBorder:SetColor(GUIMarineBuyMenu.kBtnHighlightColor)
    self.infoBorder:SetIsVisible(false)
    self.backgroundCenteredArea:AddChild(self.infoBorder)

    self.mouseOverTitleShadow = GUIManager:CreateTextItem()
    self.mouseOverTitleShadow:SetFontName(Fonts.kAgencyFB_Medium)
    self.mouseOverTitleShadow:SetScale(GetScaledVector())
    GUIMakeFontScale(self.mouseOverTitleShadow)
    self.mouseOverTitleShadow:SetAnchor(GUIItem.Left, GUIItem.Top)
    self.mouseOverTitleShadow:SetPosition(GUIMarineBuyMenu.kInfoTitleOffset)
    self.mouseOverTitleShadow:SetTextAlignmentX(GUIItem.Align_Min)
    self.mouseOverTitleShadow:SetTextAlignmentY(GUIItem.Align_Center)
    self.mouseOverTitleShadow:SetColor(GUIMarineBuyMenu.kBtnHighlightColor)
    self.infoBorder:AddChild(self.mouseOverTitleShadow)

    self.mouseOverTitleText = GUIManager:CreateTextItem()
    self.mouseOverTitleText:SetFontName(Fonts.kAgencyFB_Medium)
    self.mouseOverTitleText:SetScale(GetScaledVector())
    GUIMakeFontScale(self.mouseOverTitleText)
    self.mouseOverTitleText:SetAnchor(GUIItem.Left, GUIItem.Top)
    self.mouseOverTitleText:SetPosition(Vector(-1, -1, 0))
    self.mouseOverTitleText:SetTextAlignmentX(GUIItem.Align_Min)
    self.mouseOverTitleText:SetTextAlignmentY(GUIItem.Align_Center)
    self.mouseOverTitleText:SetColor(GUIMarineBuyMenu.kTextColor)
    self.mouseOverTitleShadow:AddChild(self.mouseOverTitleText)

    self.mouseOverInfoText = GUIManager:CreateTextItem()
    self.mouseOverInfoText:SetFontName(Fonts.kAgencyFB_Tiny)
    self.mouseOverInfoText:SetScale(GetScaledVector())
    GUIMakeFontScale(self.mouseOverInfoText)
    self.mouseOverInfoText:SetAnchor(GUIItem.Left, GUIItem.Top)
    self.mouseOverInfoText:SetPosition(GUIMarineBuyMenu.kInfoTextOffset)
    self.mouseOverInfoText:SetTextAlignmentX(GUIItem.Align_Min)
    self.mouseOverInfoText:SetTextAlignmentY(GUIItem.Align_Min)
    self.mouseOverInfoText:SetColor(GUIMarineBuyMenu.kTextColor)
    self.infoBorder:AddChild(self.mouseOverInfoText)

    self.mouseOverInfoIcon = GUIManager:CreateGraphicItem()
    self.mouseOverInfoIcon:SetAnchor(GUIItem.Left, GUIItem.Top)
    self.mouseOverInfoIcon:SetPosition(GUIMarineBuyMenu.kInfoIconOffset)
    self.infoBorder:AddChild(self.mouseOverInfoIcon)

    self.mouseOverInfoCostText = GUIManager:CreateTextItem()
    self.mouseOverInfoCostText:SetFontName(Fonts.kAgencyFB_Small)
    self.mouseOverInfoCostText:SetScale(GetScaledVector())
    GUIMakeFontScale(self.mouseOverInfoCostText)
    self.mouseOverInfoCostText:SetAnchor(GUIItem.Right, GUIItem.Top)
    self.mouseOverInfoCostText:SetPosition(GUIMarineBuyMenu.kInfoCostTextOffset)
    self.mouseOverInfoCostText:SetTextAlignmentX(GUIItem.Align_Min)
    self.mouseOverInfoCostText:SetTextAlignmentY(GUIItem.Align_Min)
    self.mouseOverInfoCostText:SetColor(GUIMarineBuyMenu.kTextColor)
    self.infoBorder:AddChild(self.mouseOverInfoCostText)

    local costIcon = GUIManager:CreateGraphicItem()
    costIcon:SetSize(GUIMarineBuyMenu.kInfoSmallIconSize)
    costIcon:SetAnchor(GUIItem.Right, GUIItem.Top)
    costIcon:SetPosition(GUIMarineBuyMenu.kInfoCostIconOffset)
    costIcon:SetTexture(GUIMarineBuyMenu.kResIconTexture)
    costIcon:SetTexturePixelCoordinates(unpack(GUIMarineBuyMenu.kUpgradePointIconTexCoords))
    costIcon:SetColor(GUIMarineBuyMenu.kTextColor)
    self.infoBorder:AddChild(costIcon)

    self.mouseOverInfoRankText = GUIManager:CreateTextItem()
    self.mouseOverInfoRankText:SetFontName(Fonts.kAgencyFB_Small)
    self.mouseOverInfoRankText:SetScale(GetScaledVector())
    GUIMakeFontScale(self.mouseOverInfoRankText)
    self.mouseOverInfoRankText:SetAnchor(GUIItem.Right, GUIItem.Top)
    self.mouseOverInfoRankText:SetPosition(GUIMarineBuyMenu.kInfoRankTextOffset)
    self.mouseOverInfoRankText:SetTextAlignmentX(GUIItem.Align_Min)
    self.mouseOverInfoRankText:SetTextAlignmentY(GUIItem.Align_Min)
    self.mouseOverInfoRankText:SetColor(GUIMarineBuyMenu.kTextColor)
    self.infoBorder:AddChild(self.mouseOverInfoRankText)

    local rankIcon = GUIManager:CreateGraphicItem()
    rankIcon:SetSize(Vector(GUIMarineBuyMenu.kInfoSmallIconSize.x - GUIScaleWidth(4), GUIMarineBuyMenu.kInfoSmallIconSize.y - GUIScaleHeight(4), 0))
    rankIcon:SetAnchor(GUIItem.Right, GUIItem.Top)
    rankIcon:SetPosition(GUIMarineBuyMenu.kInfoRankIconOffset)
    rankIcon:SetTexture(GUIMarineBuyMenu.kLevelUpIconTexture)
    rankIcon:SetTexturePixelCoordinates(unpack(GUIMarineBuyMenu.kLevelUpIconTexCoords))
    rankIcon:SetColor(GUIMarineBuyMenu.kTextColor)
    self.infoBorder:AddChild(rankIcon)

    self.mouseOverInfoCooldownText = GUIManager:CreateTextItem()
    self.mouseOverInfoCooldownText:SetFontName(Fonts.kAgencyFB_Small)
    self.mouseOverInfoCooldownText:SetScale(GetScaledVector())
    GUIMakeFontScale(self.mouseOverInfoCooldownText)
    self.mouseOverInfoCooldownText:SetAnchor(GUIItem.Right, GUIItem.Top)
    self.mouseOverInfoCooldownText:SetPosition(GUIMarineBuyMenu.kInfoCooldownTextOffset)
    self.mouseOverInfoCooldownText:SetTextAlignmentX(GUIItem.Align_Min)
    self.mouseOverInfoCooldownText:SetTextAlignmentY(GUIItem.Align_Min)
    self.mouseOverInfoCooldownText:SetColor(GUIMarineBuyMenu.kTextColor)
    self.infoBorder:AddChild(self.mouseOverInfoCooldownText)

    self.mouseOverInfoCooldownIcon = GUIManager:CreateGraphicItem()
    self.mouseOverInfoCooldownIcon:SetSize(GUIMarineBuyMenu.kInfoSmallIconSize)
    self.mouseOverInfoCooldownIcon:SetAnchor(GUIItem.Right, GUIItem.Top)
    self.mouseOverInfoCooldownIcon:SetPosition(GUIMarineBuyMenu.kInfoCooldownIconOffset)
    self.mouseOverInfoCooldownIcon:SetTexture(GUIMarineBuyMenu.kCooldownIconTexture)
    self.mouseOverInfoCooldownIcon:SetTexturePixelCoordinates(unpack(GUIMarineBuyMenu.kUpgradePointIconTexCoords))
    self.mouseOverInfoCooldownIcon:SetColor(GUIMarineBuyMenu.kTextColor)
    self.infoBorder:AddChild(self.mouseOverInfoCooldownIcon)

end

function GUIMarineBuyMenu:ShowMouseOverInfo(techId)

    self.infoBorder:SetIsVisible(true)

    local nameString = GetDisplayNameForTechId(techId)
    self.mouseOverTitleText:SetText(nameString)
    self.mouseOverTitleShadow:SetText(nameString)

    local infoString = LookupUpgradeData(techId, kUpDataDescIndex)

    if infoString == nil or infoString == "" then

        infoString = MarineBuy_GetWeaponDescription(techId)

        if infoString == nil or infoString == "" then
            infoString = GetTooltipInfoText(techId)
        end

    end

    self.mouseOverInfoText:SetText(infoString)
    self.mouseOverInfoText:SetTextClipped(true, GUIMarineBuyMenu.kInfoBackgroundSize.x - GUIMarineBuyMenu.kInfoTextOffset.x, GUIMarineBuyMenu.kInfoBackgroundSize.y - GUIMarineBuyMenu.kInfoTextOffset.y)

    local player = Client.GetLocalPlayer()
    local cost = LookupUpgradeData(techId, kUpDataCostIndex)
    local rankRequired = LookupUpgradeData(techId, kUpDataRankIndex)
    local hasPrereq = BuyUI_GetHasPrerequisites(techId)
    local canAfford = cost <= player.combatUpgradePoints
    local hasRequiredRank = rankRequired <= player.combatRank
    local enabled = hasPrereq and canAfford and hasRequiredRank

    self.mouseOverInfoCostText:SetText(string.format("%s", cost))
    self.mouseOverInfoCostText:SetIsVisible(true)

    self.mouseOverInfoRankText:SetText(string.format("%s", rankRequired))
    self.mouseOverInfoRankText:SetIsVisible(true)

    local hasCooldown = true
    if techId == kTechId.MedPack then
        self.mouseOverInfoCooldownText:SetText(CombatPlusPlus_GetTimeString(kMedPackAbilityCooldown))
        self.mouseOverInfoCooldownText:SetIsVisible(true)
        self.mouseOverInfoCooldownIcon:SetIsVisible(true)
    elseif techId == kTechId.AmmoPack then
        self.mouseOverInfoCooldownText:SetText(CombatPlusPlus_GetTimeString(kAmmoPackAbilityCooldown))
        self.mouseOverInfoCooldownText:SetIsVisible(true)
        self.mouseOverInfoCooldownIcon:SetIsVisible(true)
    elseif techId == kTechId.CatPack then
        self.mouseOverInfoCooldownText:SetText(CombatPlusPlus_GetTimeString(kCatPackAbilityCooldown))
        self.mouseOverInfoCooldownText:SetIsVisible(true)
        self.mouseOverInfoCooldownIcon:SetIsVisible(true)
    elseif techId == kTechId.Scan then
        self.mouseOverInfoCooldownText:SetText(CombatPlusPlus_GetTimeString(kScanAbilityCooldown))
        self.mouseOverInfoCooldownText:SetIsVisible(true)
        self.mouseOverInfoCooldownIcon:SetIsVisible(true)
    else
        self.mouseOverInfoCooldownText:SetIsVisible(false)
        self.mouseOverInfoCooldownIcon:SetIsVisible(false)
        hasCooldown = false
    end

    local iconTexture = LookupUpgradeData(techId, kUpDataLargeIconTextureIndex)
    local iconSize = LookupUpgradeData(techId, kUpDataLargeIconSizeIndex)

    if iconTexture and iconSize then
        local iconSizeScaled = Vector(GUIScaleWidth(iconSize.x / 2), GUIScaleHeight(iconSize.y / 2), 0)
        local pos = ((GUIMarineBuyMenu.kInfoBackgroundSize / 2) - (iconSizeScaled / 2)) + GUIMarineBuyMenu.kInfoIconOffset
        self.mouseOverInfoIcon:SetSize(iconSizeScaled)
        self.mouseOverInfoIcon:SetTexture(iconTexture)
        self.mouseOverInfoIcon:SetTexturePixelCoordinates(unpack(CombatUI_GetMarineUpgradeLargeTextureCoords(techId, enabled)))
        self.mouseOverInfoIcon:SetPosition(pos)
        self.mouseOverInfoIcon:SetIsVisible(true)
    else
        self.mouseOverInfoIcon:SetIsVisible(false)
    end

end

function GUIMarineBuyMenu:ShowHelp(techId, button)

    local helpString = ""

    if button == self.refundButton then

        helpString = "Refund all current upgrades (excluding structures)."
        self.helpText:SetColor(GUIMarineBuyMenu.kTextColor)

    elseif button == self.recycleButton then

        helpString = "Recycle all owned structures, refunding upgrade points."
        self.helpText:SetColor(GUIMarineBuyMenu.kTextColor)

    else

        local player = Client.GetLocalPlayer()
        local cost = LookupUpgradeData(techId, kUpDataCostIndex)
        local rankRequired = LookupUpgradeData(techId, kUpDataRankIndex)
        local equipped = player:GetHasUpgrade(techId) and not CombatPlusPlus_GetIsStructureTechId(techId)
        local hasPrereq = BuyUI_GetHasPrerequisites(techId)
        local canAfford = cost <= player.combatUpgradePoints
        local hasRequiredRank = rankRequired <= player.combatRank
        local isHardcapped = GetIsHardCapped(techId, player)

        if equipped then

            helpString = "Cannot purchase. Item already equipped."
            self.helpText:SetColor(GUIMarineBuyMenu.kRedHighlight)

        elseif not hasRequiredRank then

            helpString = "Cannot purchase. Required rank not met."
            self.helpText:SetColor(GUIMarineBuyMenu.kRedHighlight)
            button:SetColor(GUIMarineBuyMenu.kRedHighlight)

        elseif not hasPrereq then

            helpString = "Cannot purchase. Required prerequisite not met."
            self.helpText:SetColor(GUIMarineBuyMenu.kRedHighlight)
            button:SetColor(GUIMarineBuyMenu.kRedHighlight)

        elseif not canAfford then

            helpString = "Cannot purchase. Not enough upgrade points."
            self.helpText:SetColor(GUIMarineBuyMenu.kRedHighlight)
            button:SetColor(GUIMarineBuyMenu.kRedHighlight)

        elseif isHardcapped then

            if CombatPlusPlus_GetIsStructureTechId(techId) then
                helpString = "Cannot purchase.  Too many of this structure type are already built."
            else
                helpString = "Cannot purchase.  Too many players already have this upgrade."
            end

            self.helpText:SetColor(GUIMarineBuyMenu.kRedHighlight)
            item.Button:SetColor(GUIMarineBuyMenu.kRedHighlight)

        else
            if cost == 1 then
                helpString = string.format("Purchase %s for %s upgrade point.", GetDisplayNameForTechId(techId), cost)
            else
                helpString = string.format("Purchase %s for %s upgrade points.", GetDisplayNameForTechId(techId), cost)
            end

            self.helpText:SetColor(GUIMarineBuyMenu.kTextColor)
        end

    end

    textSize = Fancy_CalculateTextSize(helpString, Fonts.kAgencyFB_Tiny)
    self.helpText:SetPosition( Vector(-textSize.x, 0, 0) + GUIMarineBuyMenu.kHelpTextOffset )
    self.helpText:SetText(helpString)
    self.helpText:SetIsVisible(true)

end


function GUIMarineBuyMenu:_UpdateItemButtons(deltaTime)

    self.helpText:SetText("")
    self.helpText:SetIsVisible(false)

    self.infoBorder:SetIsVisible(false)

    self.refundButton:SetColor( GUIMarineBuyMenu.kBtnColor )
    self.recycleButton:SetColor( GUIMarineBuyMenu.kBtnColor )

    if self.itemButtons then

        for i, item in ipairs(self.itemButtons) do

            if GetIsMouseOver(self, item.Button) then

                item.Button:SetColor( GUIMarineBuyMenu.kBtnHighlightColor )
                self:ShowHelp(item.TechId, item.Button)
                self:ShowMouseOverInfo(item.TechId)

            else

                item.Button:SetColor( GUIMarineBuyMenu.kBtnColor )

            end

        end

    end

    if GetIsMouseOver(self, self.refundButton) then

        self.refundButton:SetColor( GUIMarineBuyMenu.kBtnHighlightColor )
        self:ShowHelp(kTechId.None, self.refundButton)

    end

    if GetIsMouseOver(self, self.recycleButton) then

        self.recycleButton:SetColor( GUIMarineBuyMenu.kBtnHighlightColor )
        self:ShowHelp(kTechId.None, self.recycleButton)

    end

end

local function HandleItemClicked(self, mouseX, mouseY)

    if self.itemButtons then

        for i = 1, #self.itemButtons do

            local item = self.itemButtons[i]
            if GetIsMouseOver(self, item.Button) then

                local player = Client.GetLocalPlayer()
                local cost = LookupUpgradeData(item.TechId, kUpDataCostIndex)
                local rankRequired = LookupUpgradeData(item.TechId, kUpDataRankIndex)
                local equipped = player:GetHasUpgrade(item.TechId) and not CombatPlusPlus_GetIsStructureTechId(item.TechId)
                local hasPrereq = BuyUI_GetHasPrerequisites(item.TechId)
                local canAfford = cost <= player.combatUpgradePoints
                local hasRequiredRank = rankRequired <= player.combatRank
                local isHardcapped = GetIsHardCapped(item.TechId, player)

                if hasRequiredRank and canAfford and hasPrereq and not equipped and not isHardcapped then

                    MarineBuy_PurchaseItem(item.TechId)
                    MarineBuy_OnClose()

                    return true, true

                end

            end

        end

    end

    if GetIsMouseOver(self, self.refundButton) then
        BuyUI_RefundAll()
        return true, false
    end

    if GetIsMouseOver(self, self.recycleButton) then
        BuyUI_RecycleAll()
        return true, false
    end

    return false, false

end

function GUIMarineBuyMenu:SendKeyEvent(key, down)

    local closeMenu = false
    local inputHandled = false

    if key == InputKey.MouseButton0 and self.mousePressed ~= down then

        self.mousePressed = down

        local mouseX, mouseY = Client.GetCursorPosScreen()
        if down then

            inputHandled, closeMenu = HandleItemClicked(self, mouseX, mouseY)

        end

    end

    -- No matter what, this menu consumes MouseButton0/1.
    if key == InputKey.MouseButton0 or key == InputKey.MouseButton1 then
        inputHandled = true
    end

    if InputKey.Escape == key and not down then

        closeMenu = true
        inputHandled = true
        MarineBuy_OnClose()

    end

    if closeMenu then

        self.closingMenu = true
        MarineBuy_Close()

    end

    return inputHandled

end
