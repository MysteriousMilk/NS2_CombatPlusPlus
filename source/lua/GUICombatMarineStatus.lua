Script.Load("lua/Globals.lua")
Script.Load("lua/GUIUtility.lua")
Script.Load("lua/GUIAnimatedScript.lua")

class 'GUICombatMarineStatus' (GUIAnimatedScript)

GUICombatMarineStatus.kTexture = PrecacheAsset("ui/marine_HUD_status_xp.dds")

GUICombatMarineStatus.kBackgroundCoords = { 0, 0, 300, 121 }
GUICombatMarineStatus.kBackgroundPos = Vector(-330, -160, 0)
GUICombatMarineStatus.kBackgroundSize = Vector(GUICombatMarineStatus.kBackgroundCoords[3], GUICombatMarineStatus.kBackgroundCoords[4], 0)
GUICombatMarineStatus.kStencilCoords = { 0, 140, 300, 140 + 121 }

GUICombatMarineStatus.kXPFontName = Fonts.kAgencyFB_Tiny
GUICombatMarineStatus.kXPTextPosition = Vector(-250, 2, 0)
GUICombatMarineStatus.kRankFontName = Fonts.kAgencyFB_Small
GUICombatMarineStatus.kRankTextPosition = Vector(50, 30, 0)
GUICombatMarineStatus.kSkillPointTextPos = Vector(50, 64, 0)

GUICombatMarineStatus.kXPBarSize = Vector(206, 20, 0)
GUICombatMarineStatus.kXPBarPixelCoords = { 58, 352, 58 + 206, 352 + 20 }
GUICombatMarineStatus.kXPBarPos = Vector(58, 88, 0)

GUICombatMarineStatus.kXPBarGlowSize = Vector(8, 22, 0)
GUICombatMarineStatus.kXPBarGlowPos = Vector(-GUICombatMarineStatus.kXPBarGlowSize.x, 0, 0)

GUICombatMarineStatus.kSkillIconTexture = PrecacheAsset("ui/marine_HUD_presicon.dds")
GUICombatMarineStatus.kSkillIconPixelCoords = { 6, 25, 26, 45 }
GUICombatMarineStatus.kSkillIconSize = Vector(25, 25, 0)
GUICombatMarineStatus.kSkillIconPos = Vector(20, 52, 0)

local kBorderTexture = PrecacheAsset("ui/unitstatus_marine.dds")
local kBorderPixelCoords = { 256, 256, 256 + 512, 256 + 128 }
local kBorderMaskPixelCoords = { 256, 384, 256 + 512, 384 + 512 }
local kBorderMaskCircleRadius = 240

local kXPBorderPos = Vector(-150, 10, 0)
local kXPBorderSize = Vector(350, 50, 0)
local kRotationDuration = 8

GUICombatMarineStatus.kAnimSpeedDown = 0.2
GUICombatMarineStatus.kAnimSpeedUp = 0.5

function GUICombatMarineStatus:Initialize()

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

    self.combatStatusBkg = self:CreateAnimatedGraphicItem()
    self.combatStatusBkg:SetAnchor(GUIItem.Right, GUIItem.Bottom)
    self.combatStatusBkg:SetTexture(GUICombatMarineStatus.kTexture)
    self.combatStatusBkg:SetTexturePixelCoordinates(unpack(GUICombatMarineStatus.kBackgroundCoords))
    self.combatStatusBkg:AddAsChildTo(self.background)

    self.combatStatusStencil = GetGUIManager():CreateGraphicItem()
    self.combatStatusStencil:SetTexture(GUICombatMarineStatus.kTexture)
    self.combatStatusStencil:SetTexturePixelCoordinates(unpack(GUICombatMarineStatus.kStencilCoords))
    self.combatStatusStencil:SetIsStencil(true)
    self.combatStatusStencil:SetClearsStencilBuffer(false)
    self.combatStatusBkg:AddChild(self.combatStatusStencil)

    self.xpBar = self:CreateAnimatedGraphicItem()
    self.xpBar:SetTexture(GUICombatMarineStatus.kTexture)
    self.xpBar:SetTexturePixelCoordinates(unpack(GUICombatMarineStatus.kXPBarPixelCoords))
    self.xpBar:AddAsChildTo(self.combatStatusBkg)

    self.xpBarGlow = self:CreateAnimatedGraphicItem()
    self.xpBarGlow:SetLayer(kGUILayerPlayerHUDForeground1 + 2)
    self.xpBarGlow:SetAnchor(GUIItem.Right, GUIItem.Top)
    self.xpBarGlow:SetBlendTechnique(GUIItem.Add)
    self.xpBarGlow:SetIsVisible(true)
    self.xpBarGlow:SetStencilFunc(GUIItem.NotEqual)
    self.xpBar:AddChild(self.xpBarGlow)

    self.currentXPText = GetGUIManager():CreateTextItem()
    self.currentXPText:SetFontName(GUICombatMarineStatus.kXPFontName)
    self.currentXPText:SetAnchor(GUIItem.Right, GUIItem.Bottom)
    self.currentXPText:SetTextAlignmentX(GUIItem.Align_Min)
    self.currentXPText:SetTextAlignmentY(GUIItem.Align_Center)
    self.currentXPText:SetText("0 XP of 1000 (Rank 1)")
    self.currentXPText:SetIsVisible(true)
    self.currentXPText:SetColor( Color(0.62, 0.92, 1, 0.8) )
    self.combatStatusBkg:AddChild(self.currentXPText)

    self.currentRankText = GetGUIManager():CreateTextItem()
    self.currentRankText:SetFontName(GUICombatMarineStatus.kRankFontName)
    self.currentRankText:SetAnchor(GUIItem.Left, GUIItem.Top)
    self.currentRankText:SetTextAlignmentX(GUIItem.Align_Min)
    self.currentRankText:SetTextAlignmentY(GUIItem.Align_Center)
    self.currentRankText:SetText("Rank 1 : Private")
    self.currentRankText:SetIsVisible(true)
    self.currentRankText:SetColor( Color(0.62, 0.92, 1, 0.8) )
    self.combatStatusBkg:AddChild(self.currentRankText)

    self.skillPointIcon = self:CreateAnimatedGraphicItem()
    self.skillPointIcon:SetAnchor(GUIItem.Left, GUIItem.Top)
    self.skillPointIcon:SetTexture(GUICombatMarineStatus.kSkillIconTexture)
    self.skillPointIcon:SetTexturePixelCoordinates(unpack(GUICombatMarineStatus.kSkillIconPixelCoords))
    self.skillPointIcon:AddAsChildTo(self.combatStatusBkg)

    self.skillPointText = GetGUIManager():CreateTextItem()
    self.skillPointText:SetFontName(GUICombatMarineStatus.kRankFontName)
    self.skillPointText:SetAnchor(GUIItem.Left, GUIItem.Top)
    self.skillPointText:SetTextAlignmentX(GUIItem.Align_Min)
    self.skillPointText:SetTextAlignmentY(GUIItem.Align_Center)
    self.skillPointText:SetText("0 Skill Points")
    self.skillPointText:SetIsVisible(true)
    self.skillPointText:SetColor( Color(0.62, 0.92, 1, 0.8) )
    self.combatStatusBkg:AddChild(self.skillPointText)

    self.xpBarBorder = self:CreateAnimatedGraphicItem()
    self.xpBarBorder:SetAnchor(GUIItem.Middle, GUIItem.Center)
    self.xpBarBorder:SetTexture(kBorderTexture)
    self.xpBarBorder:SetTexturePixelCoordinates(unpack(kBorderPixelCoords))
    self.xpBarBorder:SetIsStencil(true)

    self.xpBarBorderMask = GetGUIManager():CreateGraphicItem()
    self.xpBarBorderMask:SetTexture(kBorderTexture)
    self.xpBarBorderMask:SetAnchor(GUIItem.Middle, GUIItem.Center)
    self.xpBarBorderMask:SetBlendTechnique(GUIItem.Add)
    self.xpBarBorderMask:SetTexturePixelCoordinates(unpack(kBorderMaskPixelCoords))
    self.xpBarBorderMask:SetStencilFunc(GUIItem.NotEqual)

    --self.xpBarBorder:AddChild(self.xpBarBorderMask)
    self.combatStatusBkg:AddChild(self.xpBarBorder)

    self.visible = true
    self:UpdateVisibility()

    self:Reset(1)

end

function GUICombatMarineStatus:Reset(scale)

    self.scale = scale
    GUIAnimatedScript.Reset(self)

    self.background:SetSize(Vector(Client.GetScreenWidth(), Client.GetScreenHeight(),0))

    self.combatStatusBkg:SetUniformScale(self.scale)
    self.combatStatusBkg:SetPosition(GUICombatMarineStatus.kBackgroundPos)
    self.combatStatusBkg:SetSize(GUICombatMarineStatus.kBackgroundSize)

    self.combatStatusStencil:SetSize(GUICombatMarineStatus.kBackgroundSize * self.scale)

    self.xpBar:SetUniformScale(self.scale)
    self.xpBar:SetPosition(GUICombatMarineStatus.kXPBarPos)
    self.xpBar:SetSize(GUICombatMarineStatus.kXPBarSize)

    self.xpBarGlow:SetUniformScale(self.scale)
    self.xpBarGlow:FadeOut(1)
    self.xpBarGlow:SetSize(GUICombatMarineStatus.kXPBarGlowSize)
    self.xpBarGlow:SetPosition(Vector(-GUICombatMarineStatus.kXPBarGlowSize.x / 2, 0, 0))

    self.xpBarBorder:SetUniformScale(self.scale)
    self.xpBarBorder:SetSize(kXPBorderSize)
    self.xpBarBorder:SetPosition(kXPBorderSize)
    self.xpBarBorderMask:SetSize(Vector(kBorderMaskCircleRadius * 2, kBorderMaskCircleRadius * 2, 0) * self.scale)
    self.xpBarBorderMask:SetPosition(Vector(-kBorderMaskCircleRadius, -kBorderMaskCircleRadius, 0) * self.scale)

    self.skillPointIcon:SetUniformScale(self.scale)
    self.skillPointIcon:SetPosition(GUICombatMarineStatus.kSkillIconPos)
    self.skillPointIcon:SetSize(GUICombatMarineStatus.kSkillIconSize)

    self.currentXPText:SetScale(GetScaledVector())
    self.currentXPText:SetPosition(GUICombatMarineStatus.kXPTextPosition)
    self.currentXPText:SetFontName(GUICombatMarineStatus.kXPFontName)
    GUIMakeFontScale(self.currentXPText)

    self.currentRankText:SetScale(GetScaledVector())
    self.currentRankText:SetPosition(GUICombatMarineStatus.kRankTextPosition)
    self.currentRankText:SetFontName(GUICombatMarineStatus.kRankFontName)
    GUIMakeFontScale(self.currentRankText)

    self.skillPointText:SetScale(GetScaledVector())
    self.skillPointText:SetPosition(GUICombatMarineStatus.kSkillPointTextPos)
    self.skillPointText:SetFontName(GUICombatMarineStatus.kRankFontName)
    GUIMakeFontScale(self.skillPointText)

    self.xpBar:SetSize(Vector(0, GUICombatMarineStatus.kXPBarSize.y, 0))
    self.xpBar:SetTexturePixelCoordinates(GUICombatMarineStatus.kXPBarPixelCoords[1], GUICombatMarineStatus.kXPBarPixelCoords[2], GUICombatMarineStatus.kXPBarPixelCoords[1], GUICombatMarineStatus.kXPBarPixelCoords[4])

end

function GUICombatMarineStatus:Uninitialize()

  GUI.DestroyItem(self.combatStatusStencil)
  self.combatStatusStencil = nil

  GUI.DestroyItem(self.currentXPText)
  self.combatStatusStencil = nil

  GUI.DestroyItem(self.currentRankText)
  self.currentRankText = nil

  GUI.DestroyItem(self.xpBarBorderMask)
  self.xpBarBorderMask = nil

  GUI.DestroyItem(self.skillPointText)
  self.skillPointText = nil

end

function GUICombatMarineStatus:UpdateVisibility()

    self.combatStatusBkg:SetIsVisible(self.visible)
    self.combatStatusStencil:SetIsVisible(self.visible)
    self.currentXPText:SetIsVisible(self.visible)
    self.currentRankText:SetIsVisible(self.visible)
    self.skillPointIcon:SetIsVisible(self.visible)
    self.skillPointText:SetIsVisible(self.visible)
    self.xpBarBorder:SetIsVisible(self.visible)

end

function GUICombatMarineStatus:SetIsVisible(isVisible)

    self.visible = isVisible
    self:UpdateVisibility()

end

function GUICombatMarineStatus:GetIsVisible()

    return self.visible

end

function GUICombatMarineStatus:OnResolutionChanged(oldX, oldY, newX, newY)

    self:Reset(newY / kBaseScreenHeight)

end

function GUICombatMarineStatus:Update(deltaTime)

    GUIAnimatedScript.Update(self, deltaTime)

    local player = Client.GetLocalPlayer()

    if player and HasMixin(player, "Scoring") then

        local currentXP = player.combatXP
        local currentRank = player.combatRank
        local title = GetMarineTitleByRank(currentRank)
        local oldXPThreshold = GetLevelThresholdByRank(currentRank)
        local newXPThreshold = 0

        if currentRank < kMaxRank then
            newXPThreshold = GetLevelThresholdByRank(currentRank + 1)
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
        local pixelCoords = GUICombatMarineStatus.kXPBarPixelCoords

        if currentRank ~= self.lastRank then

            if currentRank > self.lastRank then
                self.xpBar:DestroyAnimations()
                self.xpBar:SetSize(Vector(0, GUICombatMarineStatus.kXPBarSize.y, 0))
                self.xpBar:SetTexturePixelCoordinates(pixelCoords[1], pixelCoords[2], pixelCoords[1], pixelCoords[4])
            end

            self.lastRank = currentRank

        end

        if currentXP ~= self.lastXP then

            --if not GetGameInfoEntity():GetWarmUpActive() then
            --    Shared.Message(string.format("Rank: %s", currentRank))
            --    Shared.Message(string.format("Old XP Threshold: %s", oldXPThreshold))
            --    Shared.Message(string.format("New XP Threshold: %s", newXPThreshold))
            --    Shared.Message(string.format("XP Threshold Normalized: %s", newXPThresholdNorm))
            --end

            self.xpBar:DestroyAnimations()

            local animSpeed = ConditionalValue(currentXP < self.lastXP, GUICombatMarineStatus.kAnimSpeedDown, GUICombatMarineStatus.kAnimSpeedUp)

            local xpFraction = currentXPNorm / newXPThresholdNorm
            local xpBarSize = Vector(GUICombatMarineStatus.kXPBarSize.x * xpFraction, GUICombatMarineStatus.kXPBarSize.y, 0)

            pixelCoords[3] = GUICombatMarineStatus.kXPBarSize.x * xpFraction + pixelCoords[1]

            self.xpBar:SetSize(xpBarSize, animSpeed)
            self.xpBar:SetTexturePixelCoordinates(pixelCoords[1], pixelCoords[2], pixelCoords[3], pixelCoords[4])

            self.xpBarGlow:DestroyAnimations()
            self.xpBarGlow:SetColor( Color(1,1,1,1) )
            self.xpBarGlow:FadeOut(1, nil, AnimateLinear)

            self.lastXP = currentXP

        end

    end

    -- update border animation
    local baseRotationPercentage = (Shared.GetTime() % kRotationDuration) / kRotationDuration
    local color = Color(1, 1, 1,  math.sin(Shared.GetTime() * 0.5 ) * 0.5)
    self.xpBarBorderMask:SetRotation(Vector(0, 0, -2 * math.pi * (baseRotationPercentage + math.pi)))
    self.xpBarBorderMask:SetColor(color)

end
