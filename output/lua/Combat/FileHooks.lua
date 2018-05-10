--[[
 * Natural Selection 2 - Combat++ Mod
 * Authors:
 *          WhiteWizard
 *
 * Hooks the base game files with the new Combat++ files.
]]

kCombatVersion = 0.4

-- Setup Filehooks based on the folder structure inside the FileHooks folder
-- Warning: Paths are case sensitive at Linux
local function SetupFilehookFolder(folderPath, modPath, hookType)

	local files = {}
    local path = string.format("%s*.lua", folderPath)
    
	Shared.GetMatchingFileNames(path, true, files)

	--Log("Loading %s Filehooks: %s", hookType, files)

	for i = 1, #files do
		local filePath = files[i]
		local vanillaFilePath = string.gsub(filePath, modPath, "")
		ModLoader.SetupFileHook(vanillaFilePath, filePath, hookType)
	end

end

local function SetupFilehookFolders(modPath)

    local folders = { "Halt", "Post", "Pre", "Replace" }
    
	for i = 1, #folders do
		local hookType = folders[i]
		local modPath = string.format("%s/%s/", modPath, hookType)
		local folderPath = string.format("lua/%s", modPath)
		SetupFilehookFolder(folderPath, modPath, string.lower(hookType))
    end
    
end

SetupFilehookFolders("Combat/FileHooks")
