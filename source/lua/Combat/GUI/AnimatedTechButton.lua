--[[
 * Natural Selection 2 - Combat++ Mod
 * Authors:
 *          WhiteWizard
 *
 * New GUI that appears when the marines attempt to buy something using the 'B' key.
]]

class 'AnimatedTechButton'

AnimatedTechButton.kTechButtonTextureSize = 80
AnimatedTechButton.kTechTexture = "ui/buildmenu.dds"
AnimatedTechButton.AnimationTime = 1.25
AnimatedTechButton.AnimationWaitTime = 3
AnimatedTechButton.ButtonExpandSize = Vector(20, 20, 0)

function AnimatedTechButton:Initialize(script, techId, position)

    AnimatedTechButton.kTechButtonSize = GUIScale(54)

    self.GUIScript = script
    self.TechId = techId
    self.ToolTip = ""

    self.IsEnabled = false
    self.IsSelected = false
    self.IsPurchased = false
    self.CanAfford = false

    self.EnabledColor = Color(1, 1, 1, 1)
    self.DisabledColor = Color(0, 0, 0, 1)
    self.PurcahsedColor = Color(1, 1, 1, 1)
    self.SelectedColor = Color(1, 1, 1, 1)
    self.RedColor = Color(1, 0, 0, 1)

    -- create the graphic
    local iconX, iconY = GetMaterialXYOffset(techId, false)
    iconX = iconX * AnimatedTechButton.kTechButtonTextureSize
    iconY = iconY * AnimatedTechButton.kTechButtonTextureSize

    self.Icon = self.GUIScript:CreateAnimatedGraphicItem()
    self.Icon:SetAnchor(GUIItem.Left, GUIItem.Top)
    self.Icon:SetSize(Vector(AnimatedTechButton.kTechButtonSize, AnimatedTechButton.kTechButtonSize, 0))
    self.Icon:SetPosition(position)
    self.Icon:SetTexture(AnimatedTechButton.kTechTexture)
    self.Icon:SetTexturePixelCoordinates(iconX, iconY, iconX + AnimatedTechButton.kTechButtonTextureSize, iconY + AnimatedTechButton.kTechButtonTextureSize)

    self.elapsedSinceColorSwap = 0
    self.swapColors = false
    self.unexpandedPosition = position

end

function AnimatedTechButton:SetColors(enabledColor, disabledColor, purchasedColor, selectedColor)

    self.EnabledColor = enabledColor
    self.DisabledColor = disabledColor
    self.PurcahsedColor = purchasedColor
    self.SelectedColor = selectedColor

end

function AnimatedTechButton:SetIsPurchased(isPurchased)

    self.IsPurchased = isPurchased

end

function AnimatedTechButton:SetIsEnabled(isEnabled)

    self.IsEnabled = isEnabled

end

function AnimatedTechButton:SetCanAfford(canAfford)
    
    self.CanAfford = canAfford

end

function AnimatedTechButton:SetIsSelected(isSelected)

    self.IsSelected = isSelected
    
    self.Icon:DestroyAnimations()
    self.elapsedSinceColorSwap = 0

    if isSelected then
        self.Icon:SetSize(self.Icon:GetSize() + AnimatedTechButton.ButtonExpandSize)
        self.Icon:SetPosition(self.unexpandedPosition - AnimatedTechButton.ButtonExpandSize / 2)
        Shared.Message("Selected")
    else
        self.Icon:SetSize(Vector(AnimatedTechButton.kTechButtonSize, AnimatedTechButton.kTechButtonSize, 0))
        self.Icon:SetPosition(self.unexpandedPosition)
        Shared.Message("Deselected")
    end

end

function AnimatedTechButton:SetToolTip(toolTip)
    self.ToolTip = toolTip
end

function AnimatedTechButton:Update(deltaTime)

    if self.IsPurchased then

        self.elapsedSinceColorSwap = 0
        self.Icon:SetColor(self.PurcahsedColor)

    elseif self.IsEnabled and self.IsSelected then

        self.elapsedSinceColorSwap = self.elapsedSinceColorSwap + deltaTime

        if self.elapsedSinceColorSwap >= AnimatedTechButton.AnimationTime then

            self.elapsedSinceColorSwap = 0
            self.swapColors = not self.swapColors
            self.Icon:DestroyAnimations()
            
            self.Icon:SetColor(ConditionalValue(self.swapColors, self.EnabledColor, self.SelectedColor), AnimatedTechButton.AnimationTime)

        end

    elseif self.IsEnabled and not self.IsSelected then

        self.elapsedSinceColorSwap = 0

        if self.CanAfford then
            self.Icon:SetColor(self.EnabledColor)
        else
            self.Icon:SetColor(self.RedColor)
        end

    elseif not self.IsEnabled then

        self.elapsedSinceColorSwap = 0
        self.Icon:SetColor(self.DisabledColor)

    end

end