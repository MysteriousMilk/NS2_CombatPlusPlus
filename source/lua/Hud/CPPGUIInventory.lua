Script.Load("lua/Hud/GUIInventory.lua")

local function UpdateItemsGUIScale()
    GUIInventory.kBackgroundYOffset = GUIScale(-100)
end

ReplaceLocals(GUIInventory.Initialize, {UpdateItemsGUIScale = UpdateItemsGUIScale})
ReplaceLocals(GUIInventory.Reset, {UpdateItemsGUIScale = UpdateItemsGUIScale})
