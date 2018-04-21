--[[
 * Natural Selection 2 - Combat++ Mod
 * Authors:
 *          WhiteWizard
 *
 * New GUI that appears when the marines attempt to buy something using the 'B' key.
]]

Script.Load("lua/GUIAnimatedScript.lua")

class 'MarineBuyMenu' (GUIAnimatedScript)

MarineBuyMenu.kBackgroundColor = Color(0.05, 0.05, 0.1, 0.6)
MarineBuyMenu.kBackgroundCenterColor = Color(0.06, 0.06, 0.12, 0.8)
MarineBuyMenu.kBackgroundSize = Vector(1024, 1024, 0)

MarineBuyMenu.kLogoTexture = PrecacheAsset("ui/logo_marine.dds")
MarineBuyMenu.kButtonTexture = PrecacheAsset("ui/combatui_buymenu_button.dds")
MarineBuyMenu.kButtonLargeTexture = PrecacheAsset("ui/combatui_buymenu_button_large.dds")
MarineBuyMenu.kWeaponIconTexture = PrecacheAsset("ui/combatui_marine_weapon_icons.dds")
MarineBuyMenu.kStructureIconTexture = PrecacheAsset("ui/combatui_marine_structure_icons_large.dds")
MarineBuyMenu.kTechIconTexture = PrecacheAsset("ui/combatui_marine_tech_icons.dds")
MarineBuyMenu.kConsumableIconTexture = PrecacheAsset("ui/combatui_marine_consumable_icons.dds")
MarineBuyMenu.kUpgradeIconTexture = PrecacheAsset("ui/combatui_marine_upgrade_icons.dds")
MarineBuyMenu.kResIconTexture = PrecacheAsset("ui/pres_icon_big.dds")
MarineBuyMenu.kLevelUpIconTexture = PrecacheAsset("ui/levelup_icon.dds")
MarineBuyMenu.kInfoBackgroundTexture = PrecacheAsset("ui/combatui_marine_info_bkg.dds")
MarineBuyMenu.kBigIconTexture = "ui/marine_buy_bigicons.dds"
MarineBuyMenu.kBigIconTextureEx = PrecacheAsset("ui/combatui_marine_consumables_big.dds")
MarineBuyMenu.kCooldownIconTexture = PrecacheAsset("ui/cooldown_icon.dds")
MarineBuyMenu.kInfiniteIconTexture = PrecacheAsset("ui/infinite_icon.dds")

MarineBuyMenu.kIconTextureCoords = { 0, 0, 256, 256 }
MarineBuyMenu.kSkillPointIconTexCoords = { 0, 0, 48, 48 }
MarineBuyMenu.kLevelUpIconTexCoords = { 0, 0, 128, 128 }
MarineBuyMenu.kInfoBackgroundTexCoords = { 0, 0, 400, 400 }

MarineBuyMenu.kTitleFont = Fonts.kAgencyFB_Large
MarineBuyMenu.kHeaderFont = Fonts.kAgencyFB_Medium
MarineBuyMenu.kTextColor = Color(kMarineFontColor)

MarineBuyMenu.kBtnColor = Color(1, 1, 1, 0.7)
MarineBuyMenu.kBtnHighlightColor = Color(0.5, 0.5, 1.0, 0.7)

MarineBuyMenu.kLightBlueHighlight = Color(0.4, 0.85, 1, 1)
MarineBuyMenu.kBlueHighlight = Color(0.6, 0.6, 1, 1)
MarineBuyMenu.kRedHighlight = Color(1, 0.3, 0.3, 1)
MarineBuyMenu.kGreyHighlight = Color(0.6, 0.6, 0.6, 1)

MarineBuyMenu.kButtonsPerRow = 4

local weaponIconHeight = 64
local weaponIconWidth = 128
local gWeaponIconIndex
local function GetWeaponIcon(itemTechId, enabled)

    local weaponIconHeight = 64
    local weaponIconWidth = 128

    if not gWeaponIconIndex then
        gWeaponIconIndex = {}
        gWeaponIconIndex[kTechId.Pistol] = 0
        gWeaponIconIndex[kTechId.Rifle] = 1
        gWeaponIconIndex[kTechId.Shotgun] = 2
        gWeaponIconIndex[kTechId.Flamethrower] = 3
        gWeaponIconIndex[kTechId.GrenadeLauncher] = 4
        gWeaponIconIndex[kTechId.HeavyMachineGun] = 5
    end

    local x1 = 0
    local x2 = weaponIconWidth

    if not enabled then
        x1 = weaponIconWidth
        x2 = weaponIconWidth * 2
    end

    local index = gWeaponIconIndex[itemTechId]
    if not index then
        index = 0
    end

    local y1 = index * weaponIconHeight
    local y2 = (index + 1) * weaponIconHeight

    return { tex = MarineBuyMenu.kWeaponIconTexture, size = Vector(weaponIconWidth, weaponIconHeight, 0), coords = { x1, y1, x2, y2 } }

end


local gTechIconIndex
local function GetTechIcon(itemTechId, enabled)

    local smallIconHeight = 64
    local smallIconWidth = 64

    if not gTechIconIndex then
        gTechIconIndex = {}
        gTechIconIndex[kTechId.Welder] = 0
        gTechIconIndex[kTechId.LayMines] = 1
        gTechIconIndex[kTechId.ClusterGrenade] = 2
        gTechIconIndex[kTechId.GasGrenade] = 3
        gTechIconIndex[kTechId.PulseGrenade] = 4
        gTechIconIndex[kTechId.Jetpack] = 5
        gTechIconIndex[kTechId.DualMinigunExosuit] = 6
    end

    local x1 = 0
    local x2 = smallIconWidth
    if not enabled then
        x1 = smallIconWidth
        x2 = smallIconWidth * 2
    end

    local index = gTechIconIndex[itemTechId]
    if not index then
        index = 0
    end

    local y1 = index * smallIconHeight
    local y2 = (index + 1) * smallIconHeight

    return { tex = MarineBuyMenu.kTechIconTexture, size = Vector(smallIconWidth, smallIconHeight, 0), coords = { x1, y1, x2, y2 } }

end

local gUpgradeIconIndex
local function GetUpgradeIcon(itemTechId, enabled)

    local smallIconHeight = 64
    local smallIconWidth = 64

    if not gUpgradeIconIndex then
        gUpgradeIconIndex = {}
        gUpgradeIconIndex[kTechId.Armor1] = 0
        gUpgradeIconIndex[kTechId.Armor2] = 1
        gUpgradeIconIndex[kTechId.Armor3] = 2
        gUpgradeIconIndex[kTechId.Weapons1] = 3
        gUpgradeIconIndex[kTechId.Weapons2] = 4
        gUpgradeIconIndex[kTechId.Weapons3] = 5
        gUpgradeIconIndex[kTechId.MedPack] = 6
        gUpgradeIconIndex[kTechId.AmmoPack] = 7
        gUpgradeIconIndex[kTechId.CatPack] = 8
        gUpgradeIconIndex[kTechId.Scan] = 9
    end

    local x1 = 0
    local x2 = smallIconWidth
    if not enabled then
        x1 = smallIconWidth
        x2 = smallIconWidth * 2
    end

    local index = gUpgradeIconIndex[itemTechId]
    if not index then
        index = 0
    end

    local y1 = index * smallIconHeight
    local y2 = (index + 1) * smallIconHeight

    return { tex = MarineBuyMenu.kUpgradeIconTexture, size = Vector(smallIconWidth, smallIconHeight, 0), coords = { x1, y1, x2, y2 } }

end



local gStructureIconIndex
local function GetStructureIcon(itemTechId, enabled)

    local structureIconHeight = 192
    local structureIconWidth = 128

    if not gStructureIconIndex then
        gStructureIconIndex = {}
        gStructureIconIndex[kTechId.Armory] = 0
        gStructureIconIndex[kTechId.PhaseGate] = 1
        gStructureIconIndex[kTechId.Observatory] = 2
        gStructureIconIndex[kTechId.Sentry] = 3
        gStructureIconIndex[kTechId.RoboticsFactory] = 4
    end

    local index = gStructureIconIndex[itemTechId]
    if not index then
        index = 0
    end

    local x1 = index * structureIconWidth
    local x2 = (index + 1) * structureIconWidth

    local y1 = 0
    local y2 = structureIconHeight

    if not enabled then
        y1 = structureIconHeight
        y2 = structureIconHeight * 2
    end

    return { tex = MarineBuyMenu.kStructureIconTexture, size = Vector(structureIconWidth, structureIconHeight, 0), coords = { x1, y1, x2, y2 } }

end

local gBigIconIndex
local gBigIconIndexEx
local function GetBigIcon(techId, enabled)

    local bigIconWidth = 400
    local bigIconHeight = 300

    if not gBigIconIndex then
        gBigIconIndex = {}
        gBigIconIndex[kTechId.Axe] = 0
        gBigIconIndex[kTechId.Pistol] = 1
        gBigIconIndex[kTechId.Rifle] = 2
        gBigIconIndex[kTechId.Shotgun] = 3
        gBigIconIndex[kTechId.GrenadeLauncher] = 4
        gBigIconIndex[kTechId.Flamethrower] = 5
        gBigIconIndex[kTechId.HeavyMachineGun] = 15
        gBigIconIndex[kTechId.Jetpack] = 6
        gBigIconIndex[kTechId.Exosuit] = 7
        gBigIconIndex[kTechId.Welder] = 8
        gBigIconIndex[kTechId.LayMines] = 9
        gBigIconIndex[kTechId.DualMinigunExosuit] = 10
        gBigIconIndex[kTechId.UpgradeToDualMinigun] = 10
        gBigIconIndex[kTechId.ClawRailgunExosuit] = 11
        gBigIconIndex[kTechId.DualRailgunExosuit] = 11
        gBigIconIndex[kTechId.UpgradeToDualRailgun] = 11
        gBigIconIndex[kTechId.ClusterGrenade] = 12
        gBigIconIndex[kTechId.GasGrenade] = 13
        gBigIconIndex[kTechId.PulseGrenade] = 14
    end

    if not gBigIconIndexEx then
        gBigIconIndexEx = {}
        gBigIconIndexEx[kTechId.MedPack] = 0
        gBigIconIndexEx[kTechId.AmmoPack] = 1
        gBigIconIndexEx[kTechId.CatPack] = 2
        gBigIconIndexEx[kTechId.Scan] = 3
    end

    local index = gBigIconIndex[techId]
    local texture = MarineBuyMenu.kBigIconTexture

    if not index then
        index = gBigIconIndexEx[techId]
        texture = MarineBuyMenu.kBigIconTextureEx
    end

    if not index then
        return nil -- no icon
    end
    
    local x1 = 0
    local x2 = bigIconWidth
    
    if not enabled then
    
        x1 = bigIconWidth
        x2 = bigIconWidth * 2
        
    end
    
    local y1 = index * bigIconHeight
    local y2 = (index + 1) * bigIconHeight

    
    return { tex = texture, size = Vector(bigIconWidth / 2, bigIconHeight / 2, 0), coords = { x1, y1, x2, y2 } }

end

local function GetHasPrerequisite(techId)

    return GetUpgradeTree():GetHasPrerequisites(techId)

end

local function GetIsEquipped(techId)

    local equippedTechIds = MarineBuy_GetEquipped()

    for k, itemTechId in ipairs(equippedTechIds) do

        if techId == itemTechId then
            return true
        end

    end

    if GetUpgradeTree():GetIsPurchased(techId) then
        return true
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

    -- marine logo
    MarineBuyMenu.kLogoSize = GUIScale(Vector(90, 90, 0))
    MarineBuyMenu.kLogoPosition = GUIScale(Vector(60, 20, 0))

    -- main header
    MarineBuyMenu.kTitleTextOffset = GUIScale(Vector(180, 40, 0))
    MarineBuyMenu.kSubTitleTextOffset = GUIScale(Vector(180, 80, 0))
    MarineBuyMenu.kSkillPointTextOffset = GUIScale(Vector(-125, 55, 0))
    MarineBuyMenu.kSkillPointIconSize = GUIScale(36)
    MarineBuyMenu.kSkillPointPos = GUIScale(Vector(-168, 36, 0))
    MarineBuyMenu.kHelpTextOffset = GUIScale(Vector(-100, 85, 0))

    -- weapons section
    MarineBuyMenu.kWeaponHeaderTextOffset = GUIScale(Vector(60, 138, 0))
    MarineBuyMenu.kWeaponButtonStartOffset = GUIScale(Vector(60, 163, 0))

    -- upgrades section
    MarineBuyMenu.kUpgradeHeaderTextOffset = GUIScale(Vector(520, 138, 0))
    MarineBuyMenu.kUpgradeButtonStartOffset = GUIScale(Vector(520, 163, 0))

    -- tech section
    MarineBuyMenu.kTechHeaderTextOffset = GUIScale(Vector(60, 426, 0))
    MarineBuyMenu.kTechButtonStartOffset = GUIScale(Vector(60, 451, 0))

    -- structure section
    MarineBuyMenu.kStructureHeaderTextOffset = GUIScale(Vector(60, 644, 0))
    MarineBuyMenu.kStructureButtonStartOffset = GUIScale(Vector(60, 669, 0))

    -- buttons
    MarineBuyMenu.kButtonSize = GUIScale(Vector(200, 64, 0))
    MarineBuyMenu.kButtonLargeSize = GUIScale(Vector(128, 192, 0))
    MarineBuyMenu.kButtonPadding = GUIScale(Vector(10, 10, 0))
    MarineBuyMenu.kButtonLargePadding = GUIScale(Vector(10, 10, 0))
    MarineBuyMenu.kButtonTextOffset = GUIScale(Vector(-6, 14, 0))
    MarineBuyMenu.kButtonCostIconSize = GUIScale(20)
    MarineBuyMenu.kButtonCostIconPos = GUIScale(Vector(-36, -24, 0))
    MarineBuyMenu.kButtonCostTextOffset = GUIScale(Vector(-8, -14, 0))
    MarineBuyMenu.kButtonRankIconSize = GUIScale(16)
    MarineBuyMenu.kButtonRankIconPos = GUIScale(Vector(-70, -24, 0))
    MarineBuyMenu.kButtonRankTextOffset = GUIScale(Vector(-44, -14, 0))

    -- mouse over info
    MarineBuyMenu.kInfoBackgroundSize = GUIScale(394)
    MarineBuyMenu.kInfoBackgroundPos = GUIScale(Vector(520, 669, 0))
    MarineBuyMenu.kInfoTitleOffset = GUIScale(Vector(10, 25, 0))
    MarineBuyMenu.kInfoTextOffset = GUIScale(Vector(10, 50, 0))
    MarineBuyMenu.kInfoIconOffset = GUIScale(Vector(0, -20, 0))
    MarineBuyMenu.kInfoSmallIconSize = GUIScale(28)
    MarineBuyMenu.kInfoCostTextOffset = GUIScale(Vector(-18, 11, 0))
    MarineBuyMenu.kInfoCostIconOffset = GUIScale(Vector(-48, 10, 0))
    MarineBuyMenu.kInfoRankTextOffset = GUIScale(Vector(-62, 11, 0))
    MarineBuyMenu.kInfoRankIconOffset = GUIScale(Vector(-92, 10, 0))
    MarineBuyMenu.kInfoCooldownTextOffset = GUIScale(Vector(-120, 11, 0))
    MarineBuyMenu.kInfoCooldownIconOffset = GUIScale(Vector(-150, 10, 0))
    MarineBuyMenu.kInfoPersistIconOffsetMin = GUIScale(Vector(-122, 10, 0))
    MarineBuyMenu.kInfoPersistIconOffsetMax = GUIScale(Vector(-180, 10, 0))

end

function MarineBuyMenu:Initialize()

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

function MarineBuyMenu:Update(deltaTime)

    PROFILE("MarineBuyMenu:Update")

    GUIAnimatedScript.Update(self, deltaTime)
    self:_UpdateItemButtons(deltaTime)

end

function MarineBuyMenu:Uninitialize()

    GUIAnimatedScript.Uninitialize(self)

    GUI.DestroyItem(self.background)
    self.background = nil

    MouseTracker_SetIsVisible(false)

end

function MarineBuyMenu:OnResolutionChanged(oldX, oldY, newX, newY)

    self:Uninitialize()
    self:Initialize()

    MarineBuy_OnClose()

end

function MarineBuyMenu:_InitializeBackground()

    self.background = GUIManager:CreateGraphicItem()
    self.background:SetSize( Vector(Client.GetScreenWidth(), Client.GetScreenHeight(), 0) )
    self.background:SetAnchor(GUIItem.Left, GUIItem.Top)
    self.background:SetColor(MarineBuyMenu.kBackgroundColor)
    self.background:SetLayer(kGUILayerPlayerHUDForeground4)

    self.backgroundCenteredArea = GUIManager:CreateGraphicItem()
    self.backgroundCenteredArea:SetSize( Vector(1000, Client.GetScreenHeight(), 0) )
    self.backgroundCenteredArea:SetAnchor(GUIItem.Middle, GUIItem.Top)
    self.backgroundCenteredArea:SetPosition( Vector(-500, 0, 0) )
    self.backgroundCenteredArea:SetColor(MarineBuyMenu.kBackgroundCenterColor)
    self.background:AddChild(self.backgroundCenteredArea)

end

function MarineBuyMenu:_InitializeHeaders()

    local player = Client.GetLocalPlayer()

    self.logo = GetGUIManager():CreateGraphicItem()
    self.logo:SetSize( MarineBuyMenu.kLogoSize )
    self.logo:SetAnchor(GUIItem.Left, GUIItem.Top)
    self.logo:SetPosition( MarineBuyMenu.kLogoPosition )
    self.logo:SetTexture(MarineBuyMenu.kLogoTexture)
    self.logo:SetTexturePixelCoordinates(unpack(MarineBuyMenu.kIconTextureCoords))
    self.backgroundCenteredArea:AddChild(self.logo)

    self.titleText = GetGUIManager():CreateTextItem()
    self.titleText:SetFontName(MarineBuyMenu.kTitleFont)
    self.titleText:SetFontIsBold(true)
    self.titleText:SetScale(GetScaledVector())
    GUIMakeFontScale(self.titleText)
    self.titleText:SetAnchor(GUIItem.Left, GUIItem.Top)
    self.titleText:SetPosition( MarineBuyMenu.kTitleTextOffset )
    self.titleText:SetTextAlignmentX(GUIItem.Align_Min)
    self.titleText:SetTextAlignmentY(GUIItem.Align_Center)
    self.titleText:SetColor(MarineBuyMenu.kTextColor)
    self.titleText:SetText("TSE Uplink Established")
    self.titleText:SetIsVisible(true)
    self.backgroundCenteredArea:AddChild(self.titleText)

    self.subTitleText = GetGUIManager():CreateTextItem()
    self.subTitleText:SetFontName(MarineBuyMenu.kHeaderFont)
    self.subTitleText:SetFontIsBold(true)
    self.subTitleText:SetScale(GetScaledVector())
    GUIMakeFontScale(self.subTitleText)
    self.subTitleText:SetAnchor(GUIItem.Left, GUIItem.Top)
    self.subTitleText:SetPosition( MarineBuyMenu.kSubTitleTextOffset )
    self.subTitleText:SetTextAlignmentX(GUIItem.Align_Min)
    self.subTitleText:SetTextAlignmentY(GUIItem.Align_Center)
    self.subTitleText:SetColor(MarineBuyMenu.kTextColor)
    self.subTitleText:SetText(string.format("Logged in as %s", player:GetName()))
    self.subTitleText:SetIsVisible(true)
    self.backgroundCenteredArea:AddChild(self.subTitleText)

    self.skillPointText = GetGUIManager():CreateTextItem()
    self.skillPointText:SetFontName(Fonts.kAgencyFB_Small)
    self.skillPointText:SetFontIsBold(true)
    self.skillPointText:SetScale(GetScaledVector())
    GUIMakeFontScale(self.skillPointText)
    self.skillPointText:SetAnchor(GUIItem.Right, GUIItem.Top)
    self.skillPointText:SetPosition( MarineBuyMenu.kSkillPointTextOffset )
    self.skillPointText:SetTextAlignmentX(GUIItem.Align_Min)
    self.skillPointText:SetTextAlignmentY(GUIItem.Align_Center)
    self.skillPointText:SetColor(MarineBuyMenu.kTextColor)
    self.skillPointText:SetIsVisible(true)
    self.backgroundCenteredArea:AddChild(self.skillPointText)

    -- update skill point text
    if player.combatSkillPoints == 1 then
        self.skillPointText:SetText(string.format("%s Skill Point", player.combatSkillPoints))
    else
        self.skillPointText:SetText(string.format("%s Skill Points", player.combatSkillPoints))
    end

    self.skillPointIcon = GetGUIManager():CreateGraphicItem()
    self.skillPointIcon:SetSize( Vector(MarineBuyMenu.kSkillPointIconSize, MarineBuyMenu.kSkillPointIconSize, 0) )
    self.skillPointIcon:SetAnchor(GUIItem.Right, GUIItem.Top)
    self.skillPointIcon:SetPosition( MarineBuyMenu.kSkillPointPos )
    self.skillPointIcon:SetTexture(MarineBuyMenu.kResIconTexture)
    self.skillPointIcon:SetTexturePixelCoordinates(unpack(MarineBuyMenu.kSkillPointIconTexCoords))
    self.backgroundCenteredArea:AddChild(self.skillPointIcon)

    self.helpText = GetGUIManager():CreateTextItem()
    self.helpText:SetFontName(Fonts.kAgencyFB_Small)
    self.helpText:SetScale(GetScaledVector())
    GUIMakeFontScale(self.helpText)
    self.helpText:SetAnchor(GUIItem.Right, GUIItem.Top)
    --self.helpText:SetPosition(MarineBuyMenu.kHelpTextOffset)
    self.helpText:SetTextAlignmentX(GUIItem.Align_Min)
    self.helpText:SetTextAlignmentY(GUIItem.Align_Center)
    self.helpText:SetColor(MarineBuyMenu.kTextColor)
    self.helpText:SetIsVisible(false)
    self.backgroundCenteredArea:AddChild(self.helpText)

    self.wpnHeaderText = GetGUIManager():CreateTextItem()
    self.wpnHeaderText:SetFontName(MarineBuyMenu.kHeaderFont)
    self.wpnHeaderText:SetFontIsBold(true)
    self.wpnHeaderText:SetScale(GetScaledVector())
    GUIMakeFontScale(self.wpnHeaderText)
    self.wpnHeaderText:SetAnchor(GUIItem.Left, GUIItem.Top)
    self.wpnHeaderText:SetPosition(MarineBuyMenu.kWeaponHeaderTextOffset)
    self.wpnHeaderText:SetTextAlignmentX(GUIItem.Align_Min)
    self.wpnHeaderText:SetTextAlignmentY(GUIItem.Align_Center)
    self.wpnHeaderText:SetColor(MarineBuyMenu.kTextColor)
    self.wpnHeaderText:SetText("Weapons")
    self.wpnHeaderText:SetIsVisible(true)
    self.backgroundCenteredArea:AddChild(self.wpnHeaderText)

    self.upgradeHeaderText = GetGUIManager():CreateTextItem()
    self.upgradeHeaderText:SetFontName(MarineBuyMenu.kHeaderFont)
    self.upgradeHeaderText:SetFontIsBold(true)
    self.upgradeHeaderText:SetScale(GetScaledVector())
    GUIMakeFontScale(self.upgradeHeaderText)
    self.upgradeHeaderText:SetAnchor(GUIItem.Left, GUIItem.Top)
    self.upgradeHeaderText:SetPosition(MarineBuyMenu.kUpgradeHeaderTextOffset)
    self.upgradeHeaderText:SetTextAlignmentX(GUIItem.Align_Min)
    self.upgradeHeaderText:SetTextAlignmentY(GUIItem.Align_Center)
    self.upgradeHeaderText:SetColor(MarineBuyMenu.kTextColor)
    self.upgradeHeaderText:SetText("Upgrades")
    self.upgradeHeaderText:SetIsVisible(true)
    self.backgroundCenteredArea:AddChild(self.upgradeHeaderText)

    self.techHeaderText = GetGUIManager():CreateTextItem()
    self.techHeaderText:SetFontName(MarineBuyMenu.kHeaderFont)
    self.techHeaderText:SetFontIsBold(true)
    self.techHeaderText:SetScale(GetScaledVector())
    GUIMakeFontScale(self.techHeaderText)
    self.techHeaderText:SetAnchor(GUIItem.Left, GUIItem.Top)
    self.techHeaderText:SetPosition(MarineBuyMenu.kTechHeaderTextOffset)
    self.techHeaderText:SetTextAlignmentX(GUIItem.Align_Min)
    self.techHeaderText:SetTextAlignmentY(GUIItem.Align_Center)
    self.techHeaderText:SetColor(MarineBuyMenu.kTextColor)
    self.techHeaderText:SetText("Tech")
    self.techHeaderText:SetIsVisible(true)
    self.backgroundCenteredArea:AddChild(self.techHeaderText)

    self.structureHeaderText = GetGUIManager():CreateTextItem()
    self.structureHeaderText:SetFontName(MarineBuyMenu.kHeaderFont)
    self.structureHeaderText:SetFontIsBold(true)
    self.structureHeaderText:SetScale(GetScaledVector())
    GUIMakeFontScale(self.structureHeaderText)
    self.structureHeaderText:SetAnchor(GUIItem.Left, GUIItem.Top)
    self.structureHeaderText:SetPosition(MarineBuyMenu.kStructureHeaderTextOffset)
    self.structureHeaderText:SetTextAlignmentX(GUIItem.Align_Min)
    self.structureHeaderText:SetTextAlignmentY(GUIItem.Align_Center)
    self.structureHeaderText:SetColor(MarineBuyMenu.kTextColor)
    self.structureHeaderText:SetText("Structures")
    self.structureHeaderText:SetIsVisible(true)
    self.backgroundCenteredArea:AddChild(self.structureHeaderText)

end

local function CreateSmallButton(x, y, iconColor, itemTechId, enabled, canAfford, hasRank, iconFunc)

    local cost = LookupUpgradeData(itemTechId, kUpDataCostIndex)
    local rank = LookupUpgradeData(itemTechId, kUpDataRankIndex)
    local icon = iconFunc(itemTechId, enabled)
    
    local buttonGraphic = GUIManager:CreateGraphicItem()
    buttonGraphic:SetSize( MarineBuyMenu.kButtonSize )
    buttonGraphic:SetAnchor(GUIItem.Left, GUIItem.Top)
    buttonGraphic:SetPosition( Vector(x, y, 0) )
    buttonGraphic:SetTexture(MarineBuyMenu.kButtonTexture)
    buttonGraphic:SetTexturePixelCoordinates(0, 0, MarineBuyMenu.kButtonSize.x, MarineBuyMenu.kButtonSize.y)
    buttonGraphic:SetColor( MarineBuyMenu.kBtnColor )

    local buttonIcon = GUIManager:CreateGraphicItem()
    buttonIcon:SetSize( icon.size )
    buttonIcon:SetAnchor(GUIItem.Left, GUIItem.Top)
    buttonIcon:SetPosition( Vector(0, 0, 0) )
    buttonIcon:SetTexture(icon.tex)
    buttonIcon:SetTexturePixelCoordinates(unpack(icon.coords))
    buttonIcon:SetColor(iconColor)
    buttonGraphic:AddChild(buttonIcon)

    local buttonText = GUIManager:CreateTextItem()
    buttonText:SetFontName(Fonts.kAgencyFB_Tiny)
    buttonText:SetScale(GetScaledVector())
    GUIMakeFontScale(buttonText)
    buttonText:SetAnchor(GUIItem.Right, GUIItem.Top)
    buttonText:SetPosition(MarineBuyMenu.kButtonTextOffset)
    buttonText:SetTextAlignmentX(GUIItem.Align_Max)
    buttonText:SetTextAlignmentY(GUIItem.Align_Center)
    buttonText:SetColor(MarineBuyMenu.kTextColor)
    buttonText:SetText(GetDisplayNameForTechId(itemTechId))
    buttonGraphic:AddChild(buttonText)

    local rankColor = ConditionalValue(hasRank, MarineBuyMenu.kTextColor, MarineBuyMenu.kRedHighlight)
    local rankIcon = GUIManager:CreateGraphicItem()
    rankIcon:SetSize( Vector(MarineBuyMenu.kButtonRankIconSize, MarineBuyMenu.kButtonRankIconSize, 0) )
    rankIcon:SetAnchor(GUIItem.Right, GUIItem.Bottom)
    rankIcon:SetPosition(MarineBuyMenu.kButtonRankIconPos)
    rankIcon:SetTexture(MarineBuyMenu.kLevelUpIconTexture)
    rankIcon:SetTexturePixelCoordinates(unpack(MarineBuyMenu.kLevelUpIconTexCoords))
    rankIcon:SetColor(rankColor)
    buttonGraphic:AddChild(rankIcon)

    local rankText = GUIManager:CreateTextItem()
    rankText:SetFontName(Fonts.kAgencyFB_Tiny)
    rankText:SetScale(GetScaledVector())
    GUIMakeFontScale(rankText)
    rankText:SetAnchor(GUIItem.Right, GUIItem.Bottom)
    rankText:SetPosition(MarineBuyMenu.kButtonRankTextOffset)
    rankText:SetTextAlignmentX(GUIItem.Align_Max)
    rankText:SetTextAlignmentY(GUIItem.Align_Center)
    rankText:SetColor(rankColor)
    rankText:SetText(string.format("%s", rank))
    buttonGraphic:AddChild(rankText)

    local costColor = ConditionalValue(canAfford, MarineBuyMenu.kTextColor, MarineBuyMenu.kRedHighlight)
    local costIcon = GUIManager:CreateGraphicItem()
    costIcon:SetSize( Vector(MarineBuyMenu.kButtonCostIconSize, MarineBuyMenu.kButtonCostIconSize, 0) )
    costIcon:SetAnchor(GUIItem.Right, GUIItem.Bottom)
    costIcon:SetPosition(MarineBuyMenu.kButtonCostIconPos)
    costIcon:SetTexture(MarineBuyMenu.kResIconTexture)
    costIcon:SetTexturePixelCoordinates(unpack(MarineBuyMenu.kSkillPointIconTexCoords))
    costIcon:SetColor(costColor)
    buttonGraphic:AddChild(costIcon)

    local costText = GUIManager:CreateTextItem()
    costText:SetFontName(Fonts.kAgencyFB_Tiny)
    costText:SetScale(GetScaledVector())
    GUIMakeFontScale(costText)
    costText:SetAnchor(GUIItem.Right, GUIItem.Bottom)
    costText:SetPosition(MarineBuyMenu.kButtonCostTextOffset)
    costText:SetTextAlignmentX(GUIItem.Align_Max)
    costText:SetTextAlignmentY(GUIItem.Align_Center)
    costText:SetColor(costColor)
    costText:SetText(string.format("%s", cost))
    buttonGraphic:AddChild(costText)

    return buttonGraphic

end

local function InitWeaponButtons(self, player)

    local columnIndex = 0
    local rowIndex = 0
    local startOffset = MarineBuyMenu.kWeaponButtonStartOffset

    for k, itemTechId in ipairs(GetUpgradeTree():GetUpgradesByCategory("Weapon")) do

        if columnIndex == 2 then

            columnIndex = 0
            rowIndex = rowIndex + 1

        end

        local x = startOffset.x + (columnIndex * (MarineBuyMenu.kButtonSize.x + MarineBuyMenu.kButtonPadding.x))
        local y = startOffset.y + (rowIndex * (MarineBuyMenu.kButtonSize.y + MarineBuyMenu.kButtonPadding.y))

        local cost = LookupUpgradeData(itemTechId, kUpDataCostIndex)
        local rankRequired = LookupUpgradeData(itemTechId, kUpDataRankIndex)
        local equipped = GetIsEquipped(itemTechId)
        local canAfford = cost <= player.combatSkillPoints
        local hasRequiredRank = rankRequired <= player.combatRank

        local enabled = canAfford and hasRequiredRank and not equipped
        local iconColor = Color(1, 1, 1, 1)

        if equipped then
            iconColor = MarineBuyMenu.kBlueHighlight
        elseif hasRequiredRank and not canAfford then
            iconColor = MarineBuyMenu.kRedHighlight
        end

        local buttonGraphic = CreateSmallButton(x, y, iconColor, itemTechId, enabled, canAfford, hasRequiredRank, GetWeaponIcon)
        self.backgroundCenteredArea:AddChild(buttonGraphic)

        columnIndex = columnIndex + 1

        table.insert(self.itemButtons, { Button = buttonGraphic, TechId = itemTechId } )

    end

end

local function InitUpgradeButtons(self, player)

    local columnIndex = 0
    local rowIndex = 0
    local startOffset = MarineBuyMenu.kUpgradeButtonStartOffset

    local armorTechId = CombatPlusPlus_GetTechIdByArmorLevel(player:GetArmorLevel() + 1)
    local wpnTechId = CombatPlusPlus_GetTechIdByWeaponLevel(player:GetWeaponLevel() + 1)

    local upgrades = GetUpgradeTree():GetUpgradesByCategory("Consumable")

    if armorTechId ~= kTechId.None then
        table.insert(upgrades, armorTechId)
    end

    if wpnTechId ~= kTechId.None then
        table.insert(upgrades, wpnTechId)
    end

    for k, itemTechId in ipairs(upgrades) do

        if columnIndex == 2 then

            columnIndex = 0
            rowIndex = rowIndex + 1

        end

        local x = startOffset.x + (columnIndex * (MarineBuyMenu.kButtonSize.x + MarineBuyMenu.kButtonPadding.x))
        local y = startOffset.y + (rowIndex * (MarineBuyMenu.kButtonSize.y + MarineBuyMenu.kButtonPadding.y))

        local cost = LookupUpgradeData(itemTechId, kUpDataCostIndex)
        local rankRequired = LookupUpgradeData(itemTechId, kUpDataRankIndex)
        local equipped = GetIsEquipped(itemTechId)
        local hasPrereq = GetHasPrerequisite(itemTechId)
        local canAfford = cost <= player.combatSkillPoints
        local hasRequiredRank = rankRequired <= player.combatRank

        local enabled = canAfford and hasRequiredRank and hasPrereq and not equipped
        local iconColor = Color(1, 1, 1, 1)

        if itemTechId == armorTechId or itemTechId == wpnTechId then
            iconColor = MarineBuyMenu.kLightBlueHighlight
        end

        if equipped then
            iconColor = MarineBuyMenu.kBlueHighlight
        elseif hasRequiredRank and not canAfford then
            iconColor = MarineBuyMenu.kRedHighlight
        elseif not enabled then
            iconColor = MarineBuyMenu.kGreyHighlight
        end

        local buttonGraphic = CreateSmallButton(x, y, iconColor, itemTechId, enabled, canAfford, hasRequiredRank, GetUpgradeIcon)
        self.backgroundCenteredArea:AddChild(buttonGraphic)

        columnIndex = columnIndex + 1

        table.insert(self.itemButtons, { Button = buttonGraphic, TechId = itemTechId } )

    end

end

local function InitTechButtons(self, player)

    local columnIndex = 0
    local rowIndex = 0
    local startOffset = MarineBuyMenu.kTechButtonStartOffset

    for k, itemTechId in ipairs(GetUpgradeTree():GetUpgradesByCategory("Tech")) do

        if columnIndex == MarineBuyMenu.kButtonsPerRow then

            columnIndex = 0
            rowIndex = rowIndex + 1

        end

        local x = startOffset.x + (columnIndex * (MarineBuyMenu.kButtonSize.x + MarineBuyMenu.kButtonPadding.x))
        local y = startOffset.y + (rowIndex * (MarineBuyMenu.kButtonSize.y + MarineBuyMenu.kButtonPadding.y))

        -- add a gap between column 2 and 3
        if columnIndex >= 2 then
            x = x + 40
        end

        local cost = LookupUpgradeData(itemTechId, kUpDataCostIndex)
        local rankRequired = LookupUpgradeData(itemTechId, kUpDataRankIndex)
        local equipped = GetIsEquipped(itemTechId)
        local canAfford = cost <= player.combatSkillPoints
        local hasRequiredRank = rankRequired <= player.combatRank

        local enabled = canAfford and hasRequiredRank and not equipped
        local iconColor = Color(1, 1, 1, 1)

        if equipped then
            iconColor = MarineBuyMenu.kBlueHighlight
        elseif hasRequiredRank and not canAfford then
            iconColor = MarineBuyMenu.kRedHighlight
        end

        local buttonGraphic = CreateSmallButton(x, y, iconColor, itemTechId, enabled, canAfford, hasRequiredRank, GetTechIcon)
        self.backgroundCenteredArea:AddChild(buttonGraphic)

        columnIndex = columnIndex + 1

        table.insert(self.itemButtons, { Button = buttonGraphic, TechId = itemTechId } )

    end

end

local function InitStructureButtons(self, player)

    local columnIndex = 0
    local rowIndex = 0
    local startOffset = MarineBuyMenu.kStructureButtonStartOffset

    for k, itemTechId in ipairs(GetUpgradeTree():GetUpgradesByCategory("Structures")) do

        if columnIndex == 3 then

            columnIndex = 0
            rowIndex = rowIndex + 1

        end

        local x = startOffset.x + (columnIndex * (MarineBuyMenu.kButtonLargeSize.x + MarineBuyMenu.kButtonLargePadding.x))
        local y = startOffset.y + (rowIndex * (MarineBuyMenu.kButtonLargeSize.y + MarineBuyMenu.kButtonLargePadding.y))

        local buttonGraphic = GUIManager:CreateGraphicItem()
        buttonGraphic:SetSize( MarineBuyMenu.kButtonLargeSize )
        buttonGraphic:SetAnchor(GUIItem.Left, GUIItem.Top)
        buttonGraphic:SetPosition( Vector(x, y, 0) )
        buttonGraphic:SetTexture(MarineBuyMenu.kButtonLargeTexture)
        buttonGraphic:SetTexturePixelCoordinates(0, 0, MarineBuyMenu.kButtonLargeSize.x, MarineBuyMenu.kButtonLargeSize.y)
        buttonGraphic:SetColor( MarineBuyMenu.kBtnColor )
        self.backgroundCenteredArea:AddChild(buttonGraphic)

        local cost = LookupUpgradeData(itemTechId, kUpDataCostIndex)
        local rankRequired = LookupUpgradeData(itemTechId, kUpDataRankIndex)
        local canAfford = cost <= player.combatSkillPoints
        local hasRequiredRank = rankRequired <= player.combatRank

        local enabled = canAfford and hasRequiredRank
        local iconColor = Color(1, 1, 1, 1)

        if hasRequiredRank and not canAfford then
            iconColor = MarineBuyMenu.kRedHighlight
        end

        local icon = GetStructureIcon(itemTechId, enabled)

        local buttonIcon = GUIManager:CreateGraphicItem()
        buttonIcon:SetSize(icon.size)
        buttonIcon:SetAnchor(GUIItem.Left, GUIItem.Top)
        buttonIcon:SetPosition( Vector(x, y, 0) )
        buttonIcon:SetTexture(icon.tex)
        buttonIcon:SetTexturePixelCoordinates(unpack(icon.coords))
        buttonIcon:SetColor(iconColor)
        self.backgroundCenteredArea:AddChild(buttonIcon)

        local buttonText = GUIManager:CreateTextItem()
        buttonText:SetFontName(Fonts.kAgencyFB_Tiny)
        buttonText:SetScale(GetScaledVector())
        GUIMakeFontScale(buttonText)
        buttonText:SetAnchor(GUIItem.Left, GUIItem.Bottom)
        buttonText:SetPosition( Vector(6, -14, 0) )
        buttonText:SetTextAlignmentX(GUIItem.Align_Min)
        buttonText:SetTextAlignmentY(GUIItem.Align_Center)
        buttonText:SetColor(MarineBuyMenu.kTextColor)
        buttonText:SetText(GetDisplayNameForTechId(itemTechId))
        buttonGraphic:AddChild(buttonText)

        local resColor = MarineBuyMenu.kTextColor
        if not canAfford or not hasRequiredRank then
            resColor = MarineBuyMenu.kRedHighlight
        end

        local resIcon = GUIManager:CreateGraphicItem()
        resIcon:SetSize( Vector(48, 48, 0) )
        resIcon:SetScale( Vector(0.4, 0.4, 0) )
        resIcon:SetAnchor(GUIItem.Right, GUIItem.Bottom)
        resIcon:SetPosition( Vector(-50, -38, 0))
        resIcon:SetTexture(MarineBuyMenu.kResIconTexture)
        resIcon:SetTexturePixelCoordinates( 0, 0, 48, 48 )
        resIcon:SetColor( resColor )
        buttonGraphic:AddChild(resIcon)

        local resText = GUIManager:CreateTextItem()
        resText:SetFontName(Fonts.kAgencyFB_Tiny)
        resText:SetScale(GetScaledVector())
        GUIMakeFontScale(resText)
        resText:SetAnchor(GUIItem.Right, GUIItem.Bottom)
        resText:SetPosition( Vector(-8, -14, 0) )
        resText:SetTextAlignmentX(GUIItem.Align_Max)
        resText:SetTextAlignmentY(GUIItem.Align_Center)
        resText:SetColor(resColor)
        resText:SetText(string.format("%s", cost))
        buttonGraphic:AddChild(resText)

        columnIndex = columnIndex + 1

        table.insert(self.itemButtons, { Button = buttonGraphic, TechId = itemTechId } )

    end

end

function MarineBuyMenu:_InitializeButtons()

    local player = Client.GetLocalPlayer()

    self.itemButtons = { }

    InitWeaponButtons(self, player)
    InitUpgradeButtons(self, player)
    InitTechButtons(self, player)
    --InitConsumableButtons(self, player)
    InitStructureButtons(self, player)

    -- to prevent wrong display before the first update
    self:_UpdateItemButtons(0)

end

function MarineBuyMenu:_InitializeMouseOverInfo()

    self.infoBorder = GUIManager:CreateGraphicItem()
    self.infoBorder:SetAnchor(GUIItem.Left, GUIItem.Top)
    self.infoBorder:SetSize(Vector(MarineBuyMenu.kInfoBackgroundSize, MarineBuyMenu.kInfoBackgroundSize, 0))
    self.infoBorder:SetPosition(MarineBuyMenu.kInfoBackgroundPos)
    self.infoBorder:SetTexture(MarineBuyMenu.kInfoBackgroundTexture)
    self.infoBorder:SetTexturePixelCoordinates(unpack(MarineBuyMenu.kInfoBackgroundTexCoords))
    self.infoBorder:SetColor(MarineBuyMenu.kBtnHighlightColor)
    self.infoBorder:SetIsVisible(false)
    self.backgroundCenteredArea:AddChild(self.infoBorder)

    self.mouseOverTitleShadow = GUIManager:CreateTextItem()
    self.mouseOverTitleShadow:SetFontName(Fonts.kAgencyFB_Medium)
    self.mouseOverTitleShadow:SetScale(GetScaledVector())
    GUIMakeFontScale(self.mouseOverTitleShadow)
    self.mouseOverTitleShadow:SetAnchor(GUIItem.Left, GUIItem.Top)
    self.mouseOverTitleShadow:SetPosition(MarineBuyMenu.kInfoTitleOffset)
    self.mouseOverTitleShadow:SetTextAlignmentX(GUIItem.Align_Min)
    self.mouseOverTitleShadow:SetTextAlignmentY(GUIItem.Align_Center)
    self.mouseOverTitleShadow:SetColor(MarineBuyMenu.kBtnHighlightColor)
    self.infoBorder:AddChild(self.mouseOverTitleShadow)

    self.mouseOverTitleText = GUIManager:CreateTextItem()
    self.mouseOverTitleText:SetFontName(Fonts.kAgencyFB_Medium)
    self.mouseOverTitleText:SetScale(GetScaledVector())
    GUIMakeFontScale(self.mouseOverTitleText)
    self.mouseOverTitleText:SetAnchor(GUIItem.Left, GUIItem.Top)
    self.mouseOverTitleText:SetPosition(Vector(-1, -1, 0))
    self.mouseOverTitleText:SetTextAlignmentX(GUIItem.Align_Min)
    self.mouseOverTitleText:SetTextAlignmentY(GUIItem.Align_Center)
    self.mouseOverTitleText:SetColor(MarineBuyMenu.kTextColor)
    self.mouseOverTitleShadow:AddChild(self.mouseOverTitleText)

    self.mouseOverInfoText = GUIManager:CreateTextItem()
    self.mouseOverInfoText:SetFontName(Fonts.kAgencyFB_Small)
    self.mouseOverInfoText:SetScale(GetScaledVector())
    GUIMakeFontScale(self.mouseOverInfoText)
    self.mouseOverInfoText:SetAnchor(GUIItem.Left, GUIItem.Top)
    self.mouseOverInfoText:SetPosition(MarineBuyMenu.kInfoTextOffset)
    self.mouseOverInfoText:SetTextAlignmentX(GUIItem.Align_Min)
    self.mouseOverInfoText:SetTextAlignmentY(GUIItem.Align_Min)
    self.mouseOverInfoText:SetColor(MarineBuyMenu.kTextColor)
    self.infoBorder:AddChild(self.mouseOverInfoText)

    self.mouseOverInfoIcon = GUIManager:CreateGraphicItem()
    self.mouseOverInfoIcon:SetAnchor(GUIItem.Middle, GUIItem.Center)
    self.mouseOverInfoIcon:SetPosition(MarineBuyMenu.kInfoIconOffset)
    self.infoBorder:AddChild(self.mouseOverInfoIcon)

    self.mouseOverInfoCostText = GUIManager:CreateTextItem()
    self.mouseOverInfoCostText:SetFontName(Fonts.kAgencyFB_Small)
    self.mouseOverInfoCostText:SetScale(GetScaledVector())
    GUIMakeFontScale(self.mouseOverInfoCostText)
    self.mouseOverInfoCostText:SetAnchor(GUIItem.Right, GUIItem.Top)
    self.mouseOverInfoCostText:SetPosition(MarineBuyMenu.kInfoCostTextOffset)
    self.mouseOverInfoCostText:SetTextAlignmentX(GUIItem.Align_Min)
    self.mouseOverInfoCostText:SetTextAlignmentY(GUIItem.Align_Min)
    self.mouseOverInfoCostText:SetColor(MarineBuyMenu.kTextColor)
    self.infoBorder:AddChild(self.mouseOverInfoCostText)

    local costIcon = GUIManager:CreateGraphicItem()
    costIcon:SetSize(Vector(MarineBuyMenu.kInfoSmallIconSize, MarineBuyMenu.kInfoSmallIconSize, 0))
    costIcon:SetAnchor(GUIItem.Right, GUIItem.Top)
    costIcon:SetPosition(MarineBuyMenu.kInfoCostIconOffset)
    costIcon:SetTexture(MarineBuyMenu.kResIconTexture)
    costIcon:SetTexturePixelCoordinates(unpack(MarineBuyMenu.kSkillPointIconTexCoords))
    costIcon:SetColor(MarineBuyMenu.kTextColor)
    self.infoBorder:AddChild(costIcon)

    self.mouseOverInfoRankText = GUIManager:CreateTextItem()
    self.mouseOverInfoRankText:SetFontName(Fonts.kAgencyFB_Small)
    self.mouseOverInfoRankText:SetScale(GetScaledVector())
    GUIMakeFontScale(self.mouseOverInfoRankText)
    self.mouseOverInfoRankText:SetAnchor(GUIItem.Right, GUIItem.Top)
    self.mouseOverInfoRankText:SetPosition(MarineBuyMenu.kInfoRankTextOffset)
    self.mouseOverInfoRankText:SetTextAlignmentX(GUIItem.Align_Min)
    self.mouseOverInfoRankText:SetTextAlignmentY(GUIItem.Align_Min)
    self.mouseOverInfoRankText:SetColor(MarineBuyMenu.kTextColor)
    self.infoBorder:AddChild(self.mouseOverInfoRankText)

    local rankIcon = GUIManager:CreateGraphicItem()
    rankIcon:SetSize(Vector(MarineBuyMenu.kInfoSmallIconSize-4, MarineBuyMenu.kInfoSmallIconSize-4, 0))
    rankIcon:SetAnchor(GUIItem.Right, GUIItem.Top)
    rankIcon:SetPosition(MarineBuyMenu.kInfoRankIconOffset)
    rankIcon:SetTexture(MarineBuyMenu.kLevelUpIconTexture)
    rankIcon:SetTexturePixelCoordinates(unpack(MarineBuyMenu.kLevelUpIconTexCoords))
    rankIcon:SetColor(MarineBuyMenu.kTextColor)
    self.infoBorder:AddChild(rankIcon)

    self.mouseOverInfoCooldownText = GUIManager:CreateTextItem()
    self.mouseOverInfoCooldownText:SetFontName(Fonts.kAgencyFB_Small)
    self.mouseOverInfoCooldownText:SetScale(GetScaledVector())
    GUIMakeFontScale(self.mouseOverInfoCooldownText)
    self.mouseOverInfoCooldownText:SetAnchor(GUIItem.Right, GUIItem.Top)
    self.mouseOverInfoCooldownText:SetPosition(MarineBuyMenu.kInfoCooldownTextOffset)
    self.mouseOverInfoCooldownText:SetTextAlignmentX(GUIItem.Align_Min)
    self.mouseOverInfoCooldownText:SetTextAlignmentY(GUIItem.Align_Min)
    self.mouseOverInfoCooldownText:SetColor(MarineBuyMenu.kTextColor)
    self.infoBorder:AddChild(self.mouseOverInfoCooldownText)

    self.mouseOverInfoCooldownIcon = GUIManager:CreateGraphicItem()
    self.mouseOverInfoCooldownIcon:SetSize(Vector(MarineBuyMenu.kInfoSmallIconSize, MarineBuyMenu.kInfoSmallIconSize, 0))
    self.mouseOverInfoCooldownIcon:SetAnchor(GUIItem.Right, GUIItem.Top)
    self.mouseOverInfoCooldownIcon:SetPosition(MarineBuyMenu.kInfoCooldownIconOffset)
    self.mouseOverInfoCooldownIcon:SetTexture(MarineBuyMenu.kCooldownIconTexture)
    self.mouseOverInfoCooldownIcon:SetTexturePixelCoordinates(unpack(MarineBuyMenu.kSkillPointIconTexCoords))
    self.mouseOverInfoCooldownIcon:SetColor(MarineBuyMenu.kTextColor)
    self.infoBorder:AddChild(self.mouseOverInfoCooldownIcon)

    self.mouseOverInfoPersistIcon = GUIManager:CreateGraphicItem()
    self.mouseOverInfoPersistIcon:SetSize(Vector(MarineBuyMenu.kInfoSmallIconSize, MarineBuyMenu.kInfoSmallIconSize, 0))
    self.mouseOverInfoPersistIcon:SetAnchor(GUIItem.Right, GUIItem.Top)
    self.mouseOverInfoPersistIcon:SetTexture(MarineBuyMenu.kInfiniteIconTexture)
    self.mouseOverInfoPersistIcon:SetTexturePixelCoordinates(unpack(MarineBuyMenu.kSkillPointIconTexCoords))
    self.mouseOverInfoPersistIcon:SetColor(MarineBuyMenu.kTextColor)
    self.infoBorder:AddChild(self.mouseOverInfoPersistIcon)

end

function MarineBuyMenu:ShowMouseOverInfo(techId)

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
    self.mouseOverInfoText:SetTextClipped(true, MarineBuyMenu.kInfoBackgroundSize - MarineBuyMenu.kInfoTextOffset.x, MarineBuyMenu.kInfoBackgroundSize - MarineBuyMenu.kInfoTextOffset.y)

    local player = Client.GetLocalPlayer()
    local cost = LookupUpgradeData(techId, kUpDataCostIndex)
    local rankRequired = LookupUpgradeData(techId, kUpDataRankIndex)
    local hasPrereq = GetHasPrerequisite(techId)
    local canAfford = cost <= player.combatSkillPoints
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

    if LookupUpgradeData(techId, kUpDataPersistIndex) then
        self.mouseOverInfoPersistIcon:SetIsVisible(true)
        self.mouseOverInfoPersistIcon:SetPosition(ConditionalValue(hasCooldown, MarineBuyMenu.kInfoPersistIconOffsetMax, MarineBuyMenu.kInfoPersistIconOffsetMin))
    else
        self.mouseOverInfoPersistIcon:SetIsVisible(false)
    end

    local icon = GetBigIcon(techId, enabled)
    local scaleVec = Vector(1, 1, 1)

    if not icon then
        icon = GetStructureIcon(techId, enabled)
        scaleVec = Vector(1.2, 1.2, 1)
    end

    if icon then
        self.mouseOverInfoIcon:SetSize(icon.size * scaleVec)
        self.mouseOverInfoIcon:SetTexture(icon.tex)
        self.mouseOverInfoIcon:SetTexturePixelCoordinates(unpack(icon.coords))
        self.mouseOverInfoIcon:SetPosition(MarineBuyMenu.kInfoIconOffset - Vector(self.mouseOverInfoIcon:GetSize().x / 2, 0, 0))
        self.mouseOverInfoIcon:SetIsVisible(true)
    else
        self.mouseOverInfoIcon:SetIsVisible(false)
    end

end

function MarineBuyMenu:_UpdateItemButtons(deltaTime)

    self.helpText:SetText("")
    self.helpText:SetIsVisible(false)

    self.infoBorder:SetIsVisible(false)

    if self.itemButtons then

        for i, item in ipairs(self.itemButtons) do

            if GetIsMouseOver(self, item.Button) then

                item.Button:SetColor( MarineBuyMenu.kBtnHighlightColor )

                local player = Client.GetLocalPlayer()
                local cost = LookupUpgradeData(item.TechId, kUpDataCostIndex)
                local rankRequired = LookupUpgradeData(item.TechId, kUpDataRankIndex)
                local equipped = GetIsEquipped(item.TechId)
                local hasPrereq = GetHasPrerequisite(item.TechId)
                local canAfford = cost <= player.combatSkillPoints
                local hasRequiredRank = rankRequired <= player.combatRank
                local helpString = ""

                if equipped then

                    helpString = "Cannot purchase. Item already equipped."
                    self.helpText:SetColor(MarineBuyMenu.kRedHighlight)

                elseif not hasRequiredRank then

                    helpString = "Cannot purchase. Required rank not met."
                    self.helpText:SetColor(MarineBuyMenu.kRedHighlight)
                    item.Button:SetColor(MarineBuyMenu.kRedHighlight)

                elseif not hasPrereq then

                    helpString = "Cannot purchase. Required prerequisite not met."
                    self.helpText:SetColor(MarineBuyMenu.kRedHighlight)
                    item.Button:SetColor(MarineBuyMenu.kRedHighlight)

                elseif not canAfford then

                    helpString = "Cannot purchase. Not enough skill points."
                    self.helpText:SetColor(MarineBuyMenu.kRedHighlight)
                    item.Button:SetColor(MarineBuyMenu.kRedHighlight)

                else
                    if cost == 1 then
                        helpString = string.format("Purchase %s for %s skill point.", GetDisplayNameForTechId(item.TechId), cost)
                    else
                        helpString = string.format("Purchase %s for %s skill points.", GetDisplayNameForTechId(item.TechId), cost)
                    end

                    self.helpText:SetColor(MarineBuyMenu.kTextColor)
                end

                textSize = Fancy_CalculateTextSize(helpString, Fonts.kAgencyFB_Small)
                self.helpText:SetPosition( Vector((textSize.x * -1) - GUIScale(40), GUIScale(85), 0) )
                self.helpText:SetText(helpString)
                self.helpText:SetIsVisible(true)

                self:ShowMouseOverInfo(item.TechId)

            else

                item.Button:SetColor( MarineBuyMenu.kBtnColor )

            end

        end

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
                local equipped = GetIsEquipped(item.TechId)
                local hasPrereq = GetHasPrerequisite(item.TechId)
                local canAfford = cost <= player.combatSkillPoints
                local hasRequiredRank = rankRequired <= player.combatRank

                if hasRequiredRank and canAfford and hasPrereq and not equipped then

                    MarineBuy_PurchaseItem(item.TechId)
                    MarineBuy_OnClose()

                    return true, true

                end

            end

        end

    end

    return false, false

end

function MarineBuyMenu:SendKeyEvent(key, down)

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
