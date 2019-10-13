Script.Load("lua/TechTreeConstants.lua")

-- Index used to retrieve the type of upgrade
kUpDataTypeIndex = "type"

-- Index used to retrieve the team the upgrade is tied to
kUpDataTeamIndex = "team"

-- Index used to retrieve the rank required to unlock the upgrade
kUpDataRankIndex = "rank"

-- Index used to retrieve the cost of the upgrade
kUpDataCostIndex = "cost"

-- Index used to retrieve the priority of the upgrade with respect to other upgrades.
-- Mostly used to sort on the buy menu and such.
-- Lower priority = First
kUpDataPriorityIndex = "priority"

-- Index used to retrieve a table of prerequisites for the give techId.
kUpDataPrerequisiteIndex = "prereq"

-- Index used to get the value the upgrade is hardcapped at
kUpDataHardCapIndex = "hardcap"

-- Index used to get the name of the upgrade used in conjunction
-- with the "buy" console command
kUpDataConsoleNameIndex = "consoleName"

-- Index used to get the category of an upgrade
kUpDataCategoryIndex = "category"

-- Index used to get the description of an upgrade
kUpDataDescIndex = "desc"

-- Index used to get a flag that indicates if the upgrade persists after death for the current round
kUpDataPersistIndex = "persist"

-- Index used to get a flag that indicates if the upgrade is passive or not
kUpDataPassiveIndex = "passive"

-- Index used to retrieve a table of tech ids that indicate other upgrades that are
-- mutually exclusive to the upgrade indicated
kUpDataMutuallyExclusiveIndex = "mutuallyExclusive"

-- Index used to retrieve the structure class name for some tech ids
kUpDataStructClassIndex = "class"

-- Index used to retrieve a flag that indicates if the upgrade requires the alien player to gestate
kUpDataRequiresGestation = "gestation"

-- Index used to retrieve the texture used to represent the tech/upgrade on the buy menu
kUpDataIconTextureIndex = "texture"

-- Index used to retrieve the indexed offset within the texture used to represent the tech/upgrade on the buy menu
kUpDataIconTextureOffsetIndex = "texOffset"

-- Index used to retrieve a table that specifies the size of the upgrade icon displayed on the buy menu
kUpDataIconSizeIndex = "iconSize"

-- Index used to retrieve the texture used to represent the tech/upgrade on the buy menu information window
kUpDataLargeIconTextureIndex = "largeTexture"

-- Index used to retrieve the indexed offset within the texture used to represent the tech/upgrade on the buy menu information window
kUpDataLargeIconTextureOffsetIndex = "largeTexOffset"

-- Index used to retrieve a table that specifies the size of the upgrade icon displayed on the buy menu information window
kUpDataLargeIconSizeIndex = "largeIconSize"

-- Index used to retrieve flag that indicates if an ability is tier 1
kUpDataRequiresOneHiveIndex = "onehive"

-- Index used to retrieve flag that indicates if an ability is tier 2
kUpDataRequiresTwoHivesIndex = "twohives"

-- Index used to retrieve flag that indicates if an ability is tier 3
kUpDataRequiresThreeHivesIndex = "threehives"

if Server then
	Script.Load("lua/Combat/UpgradeData_Server.lua")
end

kCombatUpgradeData =
{
	[kTechId.Marine] =
	{
		[kUpDataTypeIndex] = kCombatUpgradeType.Class,
		[kUpDataPriorityIndex] = 1,
		[kUpDataTeamIndex] = 1,
		[kUpDataRankIndex] = 1,
		[kUpDataCostIndex] = 0,
		[kUpDataHardCapIndex] = 0,
		[kUpDataConsoleNameIndex] = "marine",
		[kUpDataCategoryIndex] = "Class",
		[kUpDataPersistIndex] = true,
		[kUpDataPassiveIndex] = false,
		[kUpDataMutuallyExclusiveIndex] = { kTechId.Jetpack, kTechId.DualMinigunExosuit, kTechId.DualRailgunExosuit  },
		[kUpDataPrerequisiteIndex] = { }
	},

	[kTechId.Jetpack] =
	{
		[kUpDataTypeIndex] = kCombatUpgradeType.Class,
		[kUpDataPriorityIndex] = 1,
		[kUpDataTeamIndex] = 1,
		[kUpDataRankIndex] = 6,
		[kUpDataCostIndex] = 2,
		[kUpDataHardCapIndex] = 0,
		[kUpDataConsoleNameIndex] = "jp",
		[kUpDataCategoryIndex] = "Class",
		[kUpDataPersistIndex] = true,
		[kUpDataPassiveIndex] = false,
		[kUpDataMutuallyExclusiveIndex] = { kTechId.Marine, kTechId.DualMinigunExosuit, kTechId.DualRailgunExosuit },
		[kUpDataPrerequisiteIndex] = { },
		[kUpDataIconTextureIndex] = "ui/combatui_marine_tech_icons.dds",
		[kUpDataIconTextureOffsetIndex] = 5,
		[kUpDataIconSizeIndex] = Vector(64, 64, 0),
		[kUpDataLargeIconTextureIndex] = "ui/marine_buy_bigicons.dds",
		[kUpDataLargeIconTextureOffsetIndex] = 6,
		[kUpDataLargeIconSizeIndex] = Vector(400, 300, 0)
	},

	[kTechId.DualMinigunExosuit] =
	{
		[kUpDataTypeIndex] = kCombatUpgradeType.Class,
		[kUpDataPriorityIndex] = 1,
		[kUpDataTeamIndex] = 1,
		[kUpDataRankIndex] = 7,
		[kUpDataCostIndex] = 2,
		[kUpDataHardCapIndex] = 1/3,
		[kUpDataConsoleNameIndex] = "minigunexo",
		[kUpDataCategoryIndex] = "Class",
		[kUpDataDescIndex] = "An armored exosuit with a minigun equipped to each arm.",
		[kUpDataPersistIndex] = false,
		[kUpDataPassiveIndex] = false,
		[kUpDataMutuallyExclusiveIndex] = { kTechId.Marine, kTechId.DualRailgunExosuit, kTechId.Jetpack },
		[kUpDataPrerequisiteIndex] = { },
		[kUpDataIconTextureIndex] = "ui/combatui_marine_tech_icons.dds",
		[kUpDataIconTextureOffsetIndex] = 6,
		[kUpDataIconSizeIndex] = Vector(64, 64, 0),
		[kUpDataLargeIconTextureIndex] = "ui/marine_buy_bigicons.dds",
		[kUpDataLargeIconTextureOffsetIndex] = 10,
		[kUpDataLargeIconSizeIndex] = Vector(400, 300, 0)
	},

	[kTechId.DualRailgunExosuit] =
	{
		[kUpDataTypeIndex] = kCombatUpgradeType.Class,
		[kUpDataPriorityIndex] = 1,
		[kUpDataTeamIndex] = 1,
		[kUpDataRankIndex] = 7,
		[kUpDataCostIndex] = 2,
		[kUpDataHardCapIndex] = 1/3,
		[kUpDataConsoleNameIndex] = "railgunexo",
		[kUpDataCategoryIndex] = "Class",
		[kUpDataDescIndex] = "An armored exosuit with a railgun equipped to each arm.",
		[kUpDataPersistIndex] = false,
		[kUpDataPassiveIndex] = false,
		[kUpDataMutuallyExclusiveIndex] = { kTechId.Marine, kTechId.DualMinigunExosuit, kTechId.Jetpack },
		[kUpDataPrerequisiteIndex] = { },
		[kUpDataIconTextureIndex] = "ui/combatui_marine_tech_icons.dds",
		[kUpDataIconTextureOffsetIndex] = 7,
		[kUpDataIconSizeIndex] = Vector(64, 64, 0),
		[kUpDataLargeIconTextureIndex] = "ui/marine_buy_bigicons.dds",
		[kUpDataLargeIconTextureOffsetIndex] = 11,
		[kUpDataLargeIconSizeIndex] = Vector(400, 300, 0)
	},

	-- [kTechId.Pistol] =
	-- {
	-- 	[kUpDataTypeIndex] = kCombatUpgradeType.Upgrade,
	-- 	[kUpDataPriorityIndex] = 1,
	-- 	[kUpDataTeamIndex] = 1,
	-- 	[kUpDataRankIndex] = 1,
	-- 	[kUpDataCostIndex] = 0,
	-- 	[kUpDataHardCapIndex] = 0,
	-- 	[kUpDataConsoleNameIndex] = "pistol",
	-- 	[kUpDataCategoryIndex] = "Weapon",
	-- 	[kUpDataPersistIndex] = true,
	-- 	[kUpDataPassiveIndex] = false,
	-- 	[kUpDataMutuallyExclusiveIndex] = { },
	-- 	[kUpDataPrerequisiteIndex] = { },
	-- 	[kUpDataIconTextureIndex] = "ui/combatui_marine_weapon_icons.dds",
	-- 	[kUpDataIconTextureOffsetIndex] = 0,
	-- 	[kUpDataIconSizeIndex] = Vector(128, 64, 0),
	-- 	[kUpDataLargeIconTextureIndex] = "ui/marine_buy_bigicons.dds",
	-- 	[kUpDataLargeIconTextureOffsetIndex] = 1,
	-- 	[kUpDataLargeIconSizeIndex] = Vector(400, 300, 0)
	-- },

	-- [kTechId.Rifle] =
	-- {
	-- 	[kUpDataTypeIndex] = kCombatUpgradeType.Upgrade,
	-- 	[kUpDataPriorityIndex] = 1,
	-- 	[kUpDataTeamIndex] = 1,
	-- 	[kUpDataRankIndex] = 1,
	-- 	[kUpDataCostIndex] = 0,
	-- 	[kUpDataHardCapIndex] = 0,
	-- 	[kUpDataConsoleNameIndex] = "rifle",
	-- 	[kUpDataCategoryIndex] = "Weapon",
	-- 	[kUpDataPersistIndex] = true,
	-- 	[kUpDataPassiveIndex] = false,
	-- 	[kUpDataMutuallyExclusiveIndex] = { kTechId.Shotgun, kTechId.Flamethrower, kTechId.GrenadeLauncher, kTechId.HeavyMachineGun },
	-- 	[kUpDataPrerequisiteIndex] = { },
	-- 	[kUpDataIconTextureIndex] = "ui/combatui_marine_weapon_icons.dds",
	-- 	[kUpDataIconTextureOffsetIndex] = 1,
	-- 	[kUpDataIconSizeIndex] = Vector(128, 64, 0),
	-- 	[kUpDataLargeIconTextureIndex] = "ui/marine_buy_bigicons.dds",
	-- 	[kUpDataLargeIconTextureOffsetIndex] = 2,
	-- 	[kUpDataLargeIconSizeIndex] = Vector(400, 300, 0)
	-- },

	[kTechId.Shotgun] =
	{
		[kUpDataTypeIndex] = kCombatUpgradeType.Upgrade,
		[kUpDataPriorityIndex] = 1,
		[kUpDataTeamIndex] = 1,
		[kUpDataRankIndex] = 3,
		[kUpDataCostIndex] = 1,
		[kUpDataHardCapIndex] = 0,
		[kUpDataConsoleNameIndex] = "shotgun",
		[kUpDataCategoryIndex] = "Weapon",
		[kUpDataPersistIndex] = true,
		[kUpDataPassiveIndex] = false,
		[kUpDataMutuallyExclusiveIndex] = { kTechId.Flamethrower, kTechId.GrenadeLauncher, kTechId.HeavyMachineGun },
		[kUpDataPrerequisiteIndex] = { },
		[kUpDataIconTextureIndex] = "ui/combatui_marine_weapon_icons.dds",
		[kUpDataIconTextureOffsetIndex] = 2,
		[kUpDataIconSizeIndex] = Vector(128, 64, 0),
		[kUpDataLargeIconTextureIndex] = "ui/marine_buy_bigicons.dds",
		[kUpDataLargeIconTextureOffsetIndex] = 3,
		[kUpDataLargeIconSizeIndex] = Vector(400, 300, 0)
	},

	[kTechId.Flamethrower] =
	{
		[kUpDataTypeIndex] = kCombatUpgradeType.Upgrade,
		[kUpDataPriorityIndex] = 1,
		[kUpDataTeamIndex] = 1,
		[kUpDataRankIndex] = 4,
		[kUpDataCostIndex] = 1,
		[kUpDataHardCapIndex] = 1/2,
		[kUpDataConsoleNameIndex] = "flamethrower",
		[kUpDataCategoryIndex] = "Weapon",
		[kUpDataPersistIndex] = true,
		[kUpDataPassiveIndex] = false,
		[kUpDataMutuallyExclusiveIndex] = { kTechId.Shotgun, kTechId.GrenadeLauncher, kTechId.HeavyMachineGun },
		[kUpDataPrerequisiteIndex] = { },
		[kUpDataIconTextureIndex] = "ui/combatui_marine_weapon_icons.dds",
		[kUpDataIconTextureOffsetIndex] = 3,
		[kUpDataIconSizeIndex] = Vector(128, 64, 0),
		[kUpDataLargeIconTextureIndex] = "ui/marine_buy_bigicons.dds",
		[kUpDataLargeIconTextureOffsetIndex] = 5,
		[kUpDataLargeIconSizeIndex] = Vector(400, 300, 0)
	},

	[kTechId.GrenadeLauncher] =
	{
		[kUpDataTypeIndex] = kCombatUpgradeType.Upgrade,
		[kUpDataPriorityIndex] = 1,
		[kUpDataTeamIndex] = 1,
		[kUpDataRankIndex] = 5,
		[kUpDataCostIndex] = 2,
		[kUpDataHardCapIndex] = 1/2,
		[kUpDataConsoleNameIndex] = "gl",
		[kUpDataCategoryIndex] = "Weapon",
		[kUpDataPersistIndex] = true,
		[kUpDataPassiveIndex] = false,
		[kUpDataMutuallyExclusiveIndex] = { kTechId.Shotgun, kTechId.Flamethrower, kTechId.HeavyMachineGun },
		[kUpDataPrerequisiteIndex] = { },
		[kUpDataIconTextureIndex] = "ui/combatui_marine_weapon_icons.dds",
		[kUpDataIconTextureOffsetIndex] = 4,
		[kUpDataIconSizeIndex] = Vector(128, 64, 0),
		[kUpDataLargeIconTextureIndex] = "ui/marine_buy_bigicons.dds",
		[kUpDataLargeIconTextureOffsetIndex] = 4,
		[kUpDataLargeIconSizeIndex] = Vector(400, 300, 0)
	},

	[kTechId.HeavyMachineGun] =
	{
		[kUpDataTypeIndex] = kCombatUpgradeType.Upgrade,
		[kUpDataPriorityIndex] = 1,
		[kUpDataTeamIndex] = 1,
		[kUpDataRankIndex] = 5,
		[kUpDataCostIndex] = 2,
		[kUpDataHardCapIndex] = 1/2,
		[kUpDataConsoleNameIndex] = "hmg",
		[kUpDataCategoryIndex] = "Weapon",
		[kUpDataPersistIndex] = true,
		[kUpDataPassiveIndex] = false,
		[kUpDataMutuallyExclusiveIndex] = { kTechId.Shotgun, kTechId.Flamethrower, kTechId.GrenadeLauncher },
		[kUpDataPrerequisiteIndex] = { },
		[kUpDataIconTextureIndex] = "ui/combatui_marine_weapon_icons.dds",
		[kUpDataIconTextureOffsetIndex] = 5,
		[kUpDataIconSizeIndex] = Vector(128, 64, 0),
		[kUpDataLargeIconTextureIndex] = "ui/marine_buy_bigicons.dds",
		[kUpDataLargeIconTextureOffsetIndex] = 15,
		[kUpDataLargeIconSizeIndex] = Vector(400, 300, 0)
	},

	[kTechId.Welder] =
	{
		[kUpDataTypeIndex] = kCombatUpgradeType.Upgrade,
		[kUpDataPriorityIndex] = 1,
		[kUpDataTeamIndex] = 1,
		[kUpDataRankIndex] = 1,
		[kUpDataCostIndex] = 1,
		[kUpDataHardCapIndex] = 0,
		[kUpDataConsoleNameIndex] = "welder",
		[kUpDataCategoryIndex] = "Tech",
		[kUpDataPersistIndex] = true,
		[kUpDataPassiveIndex] = false,
		[kUpDataMutuallyExclusiveIndex] = { },
		[kUpDataPrerequisiteIndex] = { },
		[kUpDataIconTextureIndex] = "ui/combatui_marine_tech_icons.dds",
		[kUpDataIconTextureOffsetIndex] = 0,
		[kUpDataIconSizeIndex] = Vector(64, 64, 0),
		[kUpDataLargeIconTextureIndex] = "ui/marine_buy_bigicons.dds",
		[kUpDataLargeIconTextureOffsetIndex] = 8,
		[kUpDataLargeIconSizeIndex] = Vector(400, 300, 0)
	},

	[kTechId.LayMines] =
	{
		[kUpDataTypeIndex] = kCombatUpgradeType.Upgrade,
		[kUpDataPriorityIndex] = 1,
		[kUpDataTeamIndex] = 1,
		[kUpDataRankIndex] = 3,
		[kUpDataCostIndex] = 1,
		[kUpDataHardCapIndex] = 0,
		[kUpDataConsoleNameIndex] = "mines",
		[kUpDataCategoryIndex] = "Tech",
		[kUpDataPersistIndex] = true,
		[kUpDataPassiveIndex] = false,
		[kUpDataMutuallyExclusiveIndex] = { },
		[kUpDataPrerequisiteIndex] = { },
		[kUpDataIconTextureIndex] = "ui/combatui_marine_tech_icons.dds",
		[kUpDataIconTextureOffsetIndex] = 1,
		[kUpDataIconSizeIndex] = Vector(64, 64, 0),
		[kUpDataLargeIconTextureIndex] = "ui/marine_buy_bigicons.dds",
		[kUpDataLargeIconTextureOffsetIndex] = 9,
		[kUpDataLargeIconSizeIndex] = Vector(400, 300, 0)
	},

	[kTechId.ClusterGrenade] =
	{
		[kUpDataTypeIndex] = kCombatUpgradeType.Upgrade,
		[kUpDataPriorityIndex] = 1,
		[kUpDataTeamIndex] = 1,
		[kUpDataRankIndex] = 3,
		[kUpDataCostIndex] = 1,
		[kUpDataHardCapIndex] = 0,
		[kUpDataConsoleNameIndex] = "clustergrenade",
		[kUpDataCategoryIndex] = "Tech",
		[kUpDataPersistIndex] = true,
		[kUpDataPassiveIndex] = false,
		[kUpDataMutuallyExclusiveIndex] = { kTechId.GasGrenade, kTechId.PulseGrenade },
		[kUpDataPrerequisiteIndex] = { },
		[kUpDataIconTextureIndex] = "ui/combatui_marine_tech_icons.dds",
		[kUpDataIconTextureOffsetIndex] = 2,
		[kUpDataIconSizeIndex] = Vector(64, 64, 0),
		[kUpDataLargeIconTextureIndex] = "ui/marine_buy_bigicons.dds",
		[kUpDataLargeIconTextureOffsetIndex] = 12,
		[kUpDataLargeIconSizeIndex] = Vector(400, 300, 0)
	},

	[kTechId.GasGrenade] =
	{
		[kUpDataTypeIndex] = kCombatUpgradeType.Upgrade,
		[kUpDataPriorityIndex] = 1,
		[kUpDataTeamIndex] = 1,
		[kUpDataRankIndex] = 3,
		[kUpDataCostIndex] = 1,
		[kUpDataHardCapIndex] = 0,
		[kUpDataConsoleNameIndex] = "gasgrenade",
		[kUpDataCategoryIndex] = "Tech",
		[kUpDataPersistIndex] = true,
		[kUpDataPassiveIndex] = false,
		[kUpDataMutuallyExclusiveIndex] = { kTechId.ClusterGrenade, kTechId.PulseGrenade },
		[kUpDataPrerequisiteIndex] = { },
		[kUpDataIconTextureIndex] = "ui/combatui_marine_tech_icons.dds",
		[kUpDataIconTextureOffsetIndex] = 3,
		[kUpDataIconSizeIndex] = Vector(64, 64, 0),
		[kUpDataLargeIconTextureIndex] = "ui/marine_buy_bigicons.dds",
		[kUpDataLargeIconTextureOffsetIndex] = 13,
		[kUpDataLargeIconSizeIndex] = Vector(400, 300, 0)
	},

	[kTechId.PulseGrenade] =
	{
		[kUpDataTypeIndex] = kCombatUpgradeType.Upgrade,
		[kUpDataPriorityIndex] = 1,
		[kUpDataTeamIndex] = 1,
		[kUpDataRankIndex] = 3,
		[kUpDataCostIndex] = 1,
		[kUpDataHardCapIndex] = 0,
		[kUpDataConsoleNameIndex] = "pulsegrenade",
		[kUpDataCategoryIndex] = "Tech",
		[kUpDataPersistIndex] = true,
		[kUpDataPassiveIndex] = false,
		[kUpDataMutuallyExclusiveIndex] = { kTechId.ClusterGrenade, kTechId.GasGrenade },
		[kUpDataPrerequisiteIndex] = { },
		[kUpDataIconTextureIndex] = "ui/combatui_marine_tech_icons.dds",
		[kUpDataIconTextureOffsetIndex] = 4,
		[kUpDataIconSizeIndex] = Vector(64, 64, 0),
		[kUpDataLargeIconTextureIndex] = "ui/marine_buy_bigicons.dds",
		[kUpDataLargeIconTextureOffsetIndex] = 14,
		[kUpDataLargeIconSizeIndex] = Vector(400, 300, 0)
	},

	[kTechId.Armor1] =
	{
		[kUpDataTypeIndex] = kCombatUpgradeType.Passive,
		[kUpDataPriorityIndex] = 1,
		[kUpDataTeamIndex] = 1,
		[kUpDataRankIndex] = 1,
		[kUpDataCostIndex] = 1,
		[kUpDataHardCapIndex] = 0,
		[kUpDataConsoleNameIndex] = "armor1",
		[kUpDataCategoryIndex] = "Upgrades",
		[kUpDataPersistIndex] = true,
		[kUpDataPassiveIndex] = false,
		[kUpDataMutuallyExclusiveIndex] = { kTechId.Armor2, kTechId.Armor3 },
		[kUpDataPrerequisiteIndex] = { },
		[kUpDataIconTextureIndex] = "ui/combatui_marine_upgrade_icons.dds",
		[kUpDataIconTextureOffsetIndex] = 0,
		[kUpDataIconSizeIndex] = Vector(64, 64, 0),
		[kUpDataLargeIconTextureIndex] = "ui/combatui_marine_icons_big.dds",
		[kUpDataLargeIconTextureOffsetIndex] = 4,
		[kUpDataLargeIconSizeIndex] = Vector(400, 300, 0)
	},

	[kTechId.Armor2] =
	{
		[kUpDataTypeIndex] = kCombatUpgradeType.Passive,
		[kUpDataPriorityIndex] = 1,
		[kUpDataTeamIndex] = 1,
		[kUpDataRankIndex] = 2,
		[kUpDataCostIndex] = 1,
		[kUpDataHardCapIndex] = 0,
		[kUpDataConsoleNameIndex] = "armor2",
		[kUpDataCategoryIndex] = "Upgrades",
		[kUpDataPersistIndex] = true,
		[kUpDataPassiveIndex] = false,
		[kUpDataMutuallyExclusiveIndex] = { kTechId.Armor1, kTechId.Armor3 },
		[kUpDataPrerequisiteIndex] = { kTechId.Armor1 },
		[kUpDataIconTextureIndex] = "ui/combatui_marine_upgrade_icons.dds",
		[kUpDataIconTextureOffsetIndex] = 1,
		[kUpDataIconSizeIndex] = Vector(64, 64, 0),
		[kUpDataLargeIconTextureIndex] = "ui/combatui_marine_icons_big.dds",
		[kUpDataLargeIconTextureOffsetIndex] = 4,
		[kUpDataLargeIconSizeIndex] = Vector(400, 300, 0)
	},

	[kTechId.Armor3] =
	{
		[kUpDataTypeIndex] = kCombatUpgradeType.Passive,
		[kUpDataPriorityIndex] = 1,
		[kUpDataTeamIndex] = 1,
		[kUpDataRankIndex] = 3,
		[kUpDataCostIndex] = 1,
		[kUpDataHardCapIndex] = 0,
		[kUpDataConsoleNameIndex] = "armor3",
		[kUpDataCategoryIndex] = "Upgrades",
		[kUpDataPersistIndex] = true,
		[kUpDataPassiveIndex] = false,
		[kUpDataMutuallyExclusiveIndex] = { kTechId.Armor1, kTechId.Armor2 },
		[kUpDataPrerequisiteIndex] = { kTechId.Armor2 },
		[kUpDataIconTextureIndex] = "ui/combatui_marine_upgrade_icons.dds",
		[kUpDataIconTextureOffsetIndex] = 2,
		[kUpDataIconSizeIndex] = Vector(64, 64, 0),
		[kUpDataLargeIconTextureIndex] = "ui/combatui_marine_icons_big.dds",
		[kUpDataLargeIconTextureOffsetIndex] = 4,
		[kUpDataLargeIconSizeIndex] = Vector(400, 300, 0)
	},

	[kTechId.Weapons1] =
	{
		[kUpDataTypeIndex] = kCombatUpgradeType.Passive,
		[kUpDataPriorityIndex] = 1,
		[kUpDataTeamIndex] = 1,
		[kUpDataRankIndex] = 1,
		[kUpDataCostIndex] = 1,
		[kUpDataHardCapIndex] = 0,
		[kUpDataConsoleNameIndex] = "wpn1",
		[kUpDataCategoryIndex] = "Upgrades",
		[kUpDataPersistIndex] = true,
		[kUpDataPassiveIndex] = false,
		[kUpDataMutuallyExclusiveIndex] = { kTechId.Weapons2, kTechId.Weapons3 },
		[kUpDataPrerequisiteIndex] = { },
		[kUpDataIconTextureIndex] = "ui/combatui_marine_upgrade_icons.dds",
		[kUpDataIconTextureOffsetIndex] = 3,
		[kUpDataIconSizeIndex] = Vector(64, 64, 0),
		[kUpDataLargeIconTextureIndex] = "ui/combatui_marine_icons_big.dds",
		[kUpDataLargeIconTextureOffsetIndex] = 5,
		[kUpDataLargeIconSizeIndex] = Vector(400, 300, 0)
	},

	[kTechId.Weapons2] =
	{
		[kUpDataTypeIndex] = kCombatUpgradeType.Passive,
		[kUpDataPriorityIndex] = 1,
		[kUpDataTeamIndex] = 1,
		[kUpDataRankIndex] = 2,
		[kUpDataCostIndex] = 1,
		[kUpDataHardCapIndex] = 0,
		[kUpDataConsoleNameIndex] = "wpn2",
		[kUpDataCategoryIndex] = "Upgrades",
		[kUpDataPersistIndex] = true,
		[kUpDataPassiveIndex] = false,
		[kUpDataMutuallyExclusiveIndex] = { kTechId.Weapons1, kTechId.Weapons3 },
		[kUpDataPrerequisiteIndex] = { kTechId.Weapons1 },
		[kUpDataIconTextureIndex] = "ui/combatui_marine_upgrade_icons.dds",
		[kUpDataIconTextureOffsetIndex] = 4,
		[kUpDataIconSizeIndex] = Vector(64, 64, 0),
		[kUpDataLargeIconTextureIndex] = "ui/combatui_marine_icons_big.dds",
		[kUpDataLargeIconTextureOffsetIndex] = 5,
		[kUpDataLargeIconSizeIndex] = Vector(400, 300, 0)
	},

	[kTechId.Weapons3] =
	{
		[kUpDataTypeIndex] = kCombatUpgradeType.Passive,
		[kUpDataPriorityIndex] = 1,
		[kUpDataTeamIndex] = 1,
		[kUpDataRankIndex] = 3,
		[kUpDataCostIndex] = 1,
		[kUpDataHardCapIndex] = 0,
		[kUpDataConsoleNameIndex] = "wpn3",
		[kUpDataCategoryIndex] = "Upgrades",
		[kUpDataPersistIndex] = true,
		[kUpDataPassiveIndex] = false,
		[kUpDataMutuallyExclusiveIndex] = { kTechId.Weapons1, kTechId.Weapons2 },
		[kUpDataPrerequisiteIndex] = { kTechId.Weapons2 },
		[kUpDataIconTextureIndex] = "ui/combatui_marine_upgrade_icons.dds",
		[kUpDataIconTextureOffsetIndex] = 5,
		[kUpDataIconSizeIndex] = Vector(64, 64, 0)
	},

	[kTechId.MedPack] =
	{
		[kUpDataTypeIndex] = kCombatUpgradeType.Special,
		[kUpDataPriorityIndex] = 1,
		[kUpDataTeamIndex] = 1,
		[kUpDataRankIndex] = 2,
		[kUpDataCostIndex] = 1,
		[kUpDataHardCapIndex] = 0,
		[kUpDataConsoleNameIndex] = "medpack",
		[kUpDataCategoryIndex] = "Consumable",
		[kUpDataDescIndex] = "A pack that restores 50 player health each use.  Can be reused every time the cooldown expires.",
		[kUpDataPersistIndex] = true,
		[kUpDataPassiveIndex] = false,
		[kUpDataMutuallyExclusiveIndex] = { },
		[kUpDataPrerequisiteIndex] = { },
		[kUpDataIconTextureIndex] = "ui/combatui_marine_upgrade_icons.dds",
		[kUpDataIconTextureOffsetIndex] = 6,
		[kUpDataIconSizeIndex] = Vector(64, 64, 0),
		[kUpDataLargeIconTextureIndex] = "ui/combatui_marine_icons_big.dds",
		[kUpDataLargeIconTextureOffsetIndex] = 0,
		[kUpDataLargeIconSizeIndex] = Vector(400, 300, 0)
	},

	[kTechId.AmmoPack] =
	{
		[kUpDataTypeIndex] = kCombatUpgradeType.Special,
		[kUpDataPriorityIndex] = 1,
		[kUpDataTeamIndex] = 1,
		[kUpDataRankIndex] = 2,
		[kUpDataCostIndex] = 1,
		[kUpDataHardCapIndex] = 0,
		[kUpDataConsoleNameIndex] = "ammopack",
		[kUpDataCategoryIndex] = "Consumable",
		[kUpDataDescIndex] = "A pack that restores ammo for any type of weapon.  Can be reused every time the cooldown expires.",
		[kUpDataPersistIndex] = true,
		[kUpDataPassiveIndex] = false,
		[kUpDataMutuallyExclusiveIndex] = { },
		[kUpDataPrerequisiteIndex] = { },
		[kUpDataIconTextureIndex] = "ui/combatui_marine_upgrade_icons.dds",
		[kUpDataIconTextureOffsetIndex] = 7,
		[kUpDataIconSizeIndex] = Vector(64, 64, 0),
		[kUpDataLargeIconTextureIndex] = "ui/combatui_marine_icons_big.dds",
		[kUpDataLargeIconTextureOffsetIndex] = 1,
		[kUpDataLargeIconSizeIndex] = Vector(400, 300, 0)
	},

	[kTechId.CatPack] =
	{
		[kUpDataTypeIndex] = kCombatUpgradeType.Special,
		[kUpDataPriorityIndex] = 1,
		[kUpDataTeamIndex] = 1,
		[kUpDataRankIndex] = 4,
		[kUpDataCostIndex] = 1,
		[kUpDataHardCapIndex] = 0,
		[kUpDataConsoleNameIndex] = "catpack",
		[kUpDataCategoryIndex] = "Consumable",
		[kUpDataDescIndex] = "A pack that increases Marine movement and speed for a limited time.  Can be reused every time the cooldown expires.",
		[kUpDataPersistIndex] = true,
		[kUpDataPassiveIndex] = false,
		[kUpDataMutuallyExclusiveIndex] = { },
		[kUpDataPrerequisiteIndex] = { },
		[kUpDataIconTextureIndex] = "ui/combatui_marine_upgrade_icons.dds",
		[kUpDataIconTextureOffsetIndex] = 8,
		[kUpDataIconSizeIndex] = Vector(64, 64, 0),
		[kUpDataLargeIconTextureIndex] = "ui/combatui_marine_icons_big.dds",
		[kUpDataLargeIconTextureOffsetIndex] = 2,
		[kUpDataLargeIconSizeIndex] = Vector(400, 300, 0)
	},

	[kTechId.Scan] =
	{
		[kUpDataTypeIndex] = kCombatUpgradeType.Special,
		[kUpDataPriorityIndex] = 1,
		[kUpDataTeamIndex] = 1,
		[kUpDataRankIndex] = 5,
		[kUpDataCostIndex] = 1,
		[kUpDataHardCapIndex] = 0,
		[kUpDataConsoleNameIndex] = "scan",
		[kUpDataCategoryIndex] = "Consumable",
		[kUpDataDescIndex] = "Reveals cloaked units and gives line of sight to the area where triggered.  Can be reused every time the cooldown expires.",
		[kUpDataPersistIndex] = true,
		[kUpDataPassiveIndex] = false,
		[kUpDataMutuallyExclusiveIndex] = { },
		[kUpDataPrerequisiteIndex] = { },
		[kUpDataIconTextureIndex] = "ui/combatui_marine_upgrade_icons.dds",
		[kUpDataIconTextureOffsetIndex] = 9,
		[kUpDataIconSizeIndex] = Vector(64, 64, 0),
		[kUpDataLargeIconTextureIndex] = "ui/combatui_marine_icons_big.dds",
		[kUpDataLargeIconTextureOffsetIndex] = 3,
		[kUpDataLargeIconSizeIndex] = Vector(400, 300, 0)
	},

	[kTechId.Armory] =
	{
		[kUpDataTypeIndex] = kCombatUpgradeType.Structure,
		[kUpDataPriorityIndex] = 1,
		[kUpDataStructClassIndex] = "Armory",
		[kUpDataTeamIndex] = 1,
		[kUpDataRankIndex] = 2,
		[kUpDataCostIndex] = 1,
		[kUpDataHardCapIndex] = 3,
		[kUpDataConsoleNameIndex] = "armory",
		[kUpDataCategoryIndex] = "Structures",
		[kUpDataPersistIndex] = false,
		[kUpDataPassiveIndex] = false,
		[kUpDataMutuallyExclusiveIndex] = { },
		[kUpDataPrerequisiteIndex] = { },
		[kUpDataIconTextureIndex] = "ui/combatui_marine_structure_icons.dds",
		[kUpDataIconTextureOffsetIndex] = 0,
		[kUpDataIconSizeIndex] = Vector(128, 192, 0),
		[kUpDataLargeIconTextureIndex] = "ui/combatui_marine_structure_icons_big.dds",
		[kUpDataLargeIconTextureOffsetIndex] = 0,
		[kUpDataLargeIconSizeIndex] = Vector(400, 300, 0)
	},

	[kTechId.PhaseGate] =
	{
		[kUpDataTypeIndex] = kCombatUpgradeType.Structure,
		[kUpDataPriorityIndex] = 1,
		[kUpDataStructClassIndex] = "PhaseGate",
		[kUpDataTeamIndex] = 1,
		[kUpDataRankIndex] = 3,
		[kUpDataCostIndex] = 1,
		[kUpDataHardCapIndex] = 3,
		[kUpDataConsoleNameIndex] = "phasegate",
		[kUpDataCategoryIndex] = "Structures",
		[kUpDataPersistIndex] = false,
		[kUpDataPassiveIndex] = false,
		[kUpDataMutuallyExclusiveIndex] = { },
		[kUpDataPrerequisiteIndex] = { },
		[kUpDataIconTextureIndex] = "ui/combatui_marine_structure_icons.dds",
		[kUpDataIconTextureOffsetIndex] = 1,
		[kUpDataIconSizeIndex] = Vector(128, 192, 0),
		[kUpDataLargeIconTextureIndex] = "ui/combatui_marine_structure_icons_big.dds",
		[kUpDataLargeIconTextureOffsetIndex] = 1,
		[kUpDataLargeIconSizeIndex] = Vector(400, 300, 0)
	},

	[kTechId.Observatory] =
	{
		[kUpDataTypeIndex] = kCombatUpgradeType.Structure,
		[kUpDataPriorityIndex] = 1,
		[kUpDataStructClassIndex] = "Observatory",
		[kUpDataTeamIndex] = 1,
		[kUpDataRankIndex] = 3,
		[kUpDataCostIndex] = 2,
		[kUpDataHardCapIndex] = 4,
		[kUpDataConsoleNameIndex] = "observatory",
		[kUpDataCategoryIndex] = "Structures",
		[kUpDataPersistIndex] = false,
		[kUpDataPassiveIndex] = false,
		[kUpDataMutuallyExclusiveIndex] = { },
		[kUpDataPrerequisiteIndex] = { },
		[kUpDataIconTextureIndex] = "ui/combatui_marine_structure_icons.dds",
		[kUpDataIconTextureOffsetIndex] = 2,
		[kUpDataIconSizeIndex] = Vector(128, 192, 0),
		[kUpDataLargeIconTextureIndex] = "ui/combatui_marine_structure_icons_big.dds",
		[kUpDataLargeIconTextureOffsetIndex] = 2,
		[kUpDataLargeIconSizeIndex] = Vector(400, 300, 0)
	},

	[kTechId.Sentry] =
	{
		[kUpDataTypeIndex] = kCombatUpgradeType.Structure,
		[kUpDataPriorityIndex] = 1,
		[kUpDataStructClassIndex] = "Sentry",
		[kUpDataTeamIndex] = 1,
		[kUpDataRankIndex] = 4,
		[kUpDataCostIndex] = 1,
		[kUpDataHardCapIndex] = 8,
		[kUpDataConsoleNameIndex] = "sentry",
		[kUpDataCategoryIndex] = "Structures",
		[kUpDataDescIndex] = "An AI torrent that fires on enemy units.  Requires an active power node for the area it is located.",
		[kUpDataPersistIndex] = false,
		[kUpDataPassiveIndex] = false,
		[kUpDataMutuallyExclusiveIndex] = { },
		[kUpDataPrerequisiteIndex] = { },
		[kUpDataIconTextureIndex] = "ui/combatui_marine_structure_icons.dds",
		[kUpDataIconTextureOffsetIndex] = 3,
		[kUpDataIconSizeIndex] = Vector(128, 192, 0),
		[kUpDataLargeIconTextureIndex] = "ui/combatui_marine_structure_icons_big.dds",
		[kUpDataLargeIconTextureOffsetIndex] = 3,
		[kUpDataLargeIconSizeIndex] = Vector(400, 300, 0)
	},

	[kTechId.Skulk] =
	{
		[kUpDataTypeIndex] = kCombatUpgradeType.Class,
		[kUpDataPriorityIndex] = 1,
		[kUpDataTeamIndex] = 2,
		[kUpDataRankIndex] = 1,
		[kUpDataCostIndex] = 1,
		[kUpDataHardCapIndex] = 0,
		[kUpDataConsoleNameIndex] = "skulk",
		[kUpDataCategoryIndex] = "Lifeform",
		[kUpDataPersistIndex] = false,
		[kUpDataPassiveIndex] = false,
		[kUpDataMutuallyExclusiveIndex] = { kTechId.Gorge, kTechId.Lerk, kTechId.Fade, kTechId.Onos },
		[kUpDataPrerequisiteIndex] = { },
		[kUpDataRequiresGestation] = true
	},

	[kTechId.Gorge] =
	{
		[kUpDataTypeIndex] = kCombatUpgradeType.Class,
		[kUpDataPriorityIndex] = 1,
		[kUpDataTeamIndex] = 2,
		[kUpDataRankIndex] = 1,
		[kUpDataCostIndex] = 1,
		[kUpDataHardCapIndex] = 0,
		[kUpDataConsoleNameIndex] = "gorge",
		[kUpDataCategoryIndex] = "Lifeform",
		[kUpDataPersistIndex] = false,
		[kUpDataPassiveIndex] = false,
		[kUpDataMutuallyExclusiveIndex] = { kTechId.Skulk, kTechId.Lerk, kTechId.Fade, kTechId.Onos },
		[kUpDataPrerequisiteIndex] = { },
		[kUpDataRequiresGestation] = true
	},

	[kTechId.Lerk] =
	{
		[kUpDataTypeIndex] = kCombatUpgradeType.Class,
		[kUpDataPriorityIndex] = 1,
		[kUpDataTeamIndex] = 2,
		[kUpDataRankIndex] = 3,
		[kUpDataCostIndex] = 1,
		[kUpDataHardCapIndex] = 0,
		[kUpDataConsoleNameIndex] = "lerk",
		[kUpDataCategoryIndex] = "Lifeform",
		[kUpDataPersistIndex] = false,
		[kUpDataPassiveIndex] = false,
		[kUpDataMutuallyExclusiveIndex] = { kTechId.Skulk, kTechId.Gorge, kTechId.Fade, kTechId.Onos },
		[kUpDataPrerequisiteIndex] = { },
		[kUpDataRequiresGestation] = true
	},

	[kTechId.Fade] =
	{
		[kUpDataTypeIndex] = kCombatUpgradeType.Class,
		[kUpDataPriorityIndex] = 1,
		[kUpDataTeamIndex] = 2,
		[kUpDataRankIndex] = 5,
		[kUpDataCostIndex] = 2,
		[kUpDataHardCapIndex] = 0,
		[kUpDataConsoleNameIndex] = "fade",
		[kUpDataCategoryIndex] = "Lifeform",
		[kUpDataPersistIndex] = false,
		[kUpDataPassiveIndex] = false,
		[kUpDataMutuallyExclusiveIndex] = { kTechId.Skulk, kTechId.Gorge, kTechId.Lerk, kTechId.Onos },
		[kUpDataPrerequisiteIndex] = { },
		[kUpDataRequiresGestation] = true
	},

	[kTechId.Onos] =
	{
		[kUpDataTypeIndex] = kCombatUpgradeType.Class,
		[kUpDataPriorityIndex] = 1,
		[kUpDataTeamIndex] = 2,
		[kUpDataRankIndex] = 6,
		[kUpDataCostIndex] = 2,
		[kUpDataHardCapIndex] = 0,
		[kUpDataConsoleNameIndex] = "onos",
		[kUpDataCategoryIndex] = "Lifeform",
		[kUpDataPersistIndex] = true,
		[kUpDataPassiveIndex] = false,
		[kUpDataMutuallyExclusiveIndex] = { kTechId.Skulk, kTechId.Gorge, kTechId.Lerk, kTechId.Fade },
		[kUpDataPrerequisiteIndex] = { },
		[kUpDataRequiresGestation] = true
	},

	[kTechId.Spur] =
	{
		[kUpDataTypeIndex] = kCombatUpgradeType.Passive,
		[kUpDataPriorityIndex] = 0,
		[kUpDataTeamIndex] = 2,
		[kUpDataRankIndex] = 1,
		[kUpDataCostIndex] = 1,
		[kUpDataHardCapIndex] = 0,
		[kUpDataConsoleNameIndex] = "spur",
		[kUpDataCategoryIndex] = "Shift",
		[kUpDataPersistIndex] = true,
		[kUpDataPassiveIndex] = true,
		[kUpDataMutuallyExclusiveIndex] = { kTechId.TwoSpurs, kTechId.ThreeSpurs },
		[kUpDataPrerequisiteIndex] = { },
		[kUpDataRequiresGestation] = false
	},

	[kTechId.TwoSpurs] =
	{
		[kUpDataTypeIndex] = kCombatUpgradeType.Passive,
		[kUpDataPriorityIndex] = 0,
		[kUpDataTeamIndex] = 2,
		[kUpDataRankIndex] = 1,
		[kUpDataCostIndex] = 1,
		[kUpDataHardCapIndex] = 0,
		[kUpDataConsoleNameIndex] = "twospurs",
		[kUpDataCategoryIndex] = "Shift",
		[kUpDataPersistIndex] = true,
		[kUpDataPassiveIndex] = true,
		[kUpDataMutuallyExclusiveIndex] = { kTechId.Spur, kTechId.ThreeSpurs },
		[kUpDataPrerequisiteIndex] = { kTechId.Spur },
		[kUpDataRequiresGestation] = false
	},

	[kTechId.ThreeSpurs] =
	{
		[kUpDataTypeIndex] = kCombatUpgradeType.Passive,
		[kUpDataPriorityIndex] = 0,
		[kUpDataTeamIndex] = 2,
		[kUpDataRankIndex] = 1,
		[kUpDataCostIndex] = 1,
		[kUpDataHardCapIndex] = 0,
		[kUpDataConsoleNameIndex] = "threespurs",
		[kUpDataCategoryIndex] = "Shift",
		[kUpDataPersistIndex] = true,
		[kUpDataPassiveIndex] = true,
		[kUpDataMutuallyExclusiveIndex] = { kTechId.Spur, kTechId.TwoSpurs },
		[kUpDataPrerequisiteIndex] = { kTechId.TwoSpurs },
		[kUpDataRequiresGestation] = false
	},

	[kTechId.Veil] =
	{
		[kUpDataTypeIndex] = kCombatUpgradeType.Passive,
		[kUpDataPriorityIndex] = 0,
		[kUpDataTeamIndex] = 2,
		[kUpDataRankIndex] = 1,
		[kUpDataCostIndex] = 1,
		[kUpDataHardCapIndex] = 0,
		[kUpDataConsoleNameIndex] = "veil",
		[kUpDataCategoryIndex] = "Shade",
		[kUpDataPersistIndex] = true,
		[kUpDataPassiveIndex] = true,
		[kUpDataMutuallyExclusiveIndex] = { kTechId.TwoVeils, kTechId.ThreeVeils },
		[kUpDataPrerequisiteIndex] = { },
		[kUpDataRequiresGestation] = false
	},

	[kTechId.TwoVeils] =
	{
		[kUpDataTypeIndex] = kCombatUpgradeType.Passive,
		[kUpDataPriorityIndex] = 0,
		[kUpDataTeamIndex] = 2,
		[kUpDataRankIndex] = 1,
		[kUpDataCostIndex] = 1,
		[kUpDataHardCapIndex] = 0,
		[kUpDataConsoleNameIndex] = "twoveils",
		[kUpDataCategoryIndex] = "Shade",
		[kUpDataPersistIndex] = true,
		[kUpDataPassiveIndex] = true,
		[kUpDataMutuallyExclusiveIndex] = { kTechId.Veil, kTechId.ThreeVeils },
		[kUpDataPrerequisiteIndex] = { kTechId.Veil },
		[kUpDataRequiresGestation] = false
	},

	[kTechId.ThreeVeils] =
	{
		[kUpDataTypeIndex] = kCombatUpgradeType.Passive,
		[kUpDataPriorityIndex] = 0,
		[kUpDataTeamIndex] = 2,
		[kUpDataRankIndex] = 1,
		[kUpDataCostIndex] = 1,
		[kUpDataHardCapIndex] = 0,
		[kUpDataConsoleNameIndex] = "threeveils",
		[kUpDataCategoryIndex] = "Shade",
		[kUpDataPersistIndex] = true,
		[kUpDataPassiveIndex] = true,
		[kUpDataMutuallyExclusiveIndex] = { kTechId.Veil, kTechId.TwoVeils },
		[kUpDataPrerequisiteIndex] = { kTechId.TwoVeils },
		[kUpDataRequiresGestation] = false
	},

	[kTechId.Shell] =
	{
		[kUpDataTypeIndex] = kCombatUpgradeType.Passive,
		[kUpDataPriorityIndex] = 0,
		[kUpDataTeamIndex] = 2,
		[kUpDataRankIndex] = 1,
		[kUpDataCostIndex] = 1,
		[kUpDataHardCapIndex] = 0,
		[kUpDataConsoleNameIndex] = "shell",
		[kUpDataCategoryIndex] = "Crag",
		[kUpDataPersistIndex] = true,
		[kUpDataPassiveIndex] = true,
		[kUpDataMutuallyExclusiveIndex] = { kTechId.TwoShells, kTechId.ThreeShells },
		[kUpDataPrerequisiteIndex] = { },
		[kUpDataRequiresGestation] = false
	},

	[kTechId.TwoShells] =
	{
		[kUpDataTypeIndex] = kCombatUpgradeType.Passive,
		[kUpDataPriorityIndex] = 0,
		[kUpDataTeamIndex] = 2,
		[kUpDataRankIndex] = 1,
		[kUpDataCostIndex] = 1,
		[kUpDataHardCapIndex] = 0,
		[kUpDataConsoleNameIndex] = "twoshells",
		[kUpDataCategoryIndex] = "Crag",
		[kUpDataPersistIndex] = true,
		[kUpDataPassiveIndex] = true,
		[kUpDataMutuallyExclusiveIndex] = { kTechId.Shell, kTechId.ThreeShells },
		[kUpDataPrerequisiteIndex] = { kTechId.Shell },
		[kUpDataRequiresGestation] = false
	},

	[kTechId.ThreeShells] =
	{
		[kUpDataTypeIndex] = kCombatUpgradeType.Passive,
		[kUpDataPriorityIndex] = 0,
		[kUpDataTeamIndex] = 2,
		[kUpDataRankIndex] = 1,
		[kUpDataCostIndex] = 1,
		[kUpDataHardCapIndex] = 0,
		[kUpDataConsoleNameIndex] = "threeshells",
		[kUpDataCategoryIndex] = "Crag",
		[kUpDataPersistIndex] = true,
		[kUpDataPassiveIndex] = true,
		[kUpDataMutuallyExclusiveIndex] = { kTechId.Shell, kTechId.TwoShells },
		[kUpDataPrerequisiteIndex] = { kTechId.TwoShells },
		[kUpDataRequiresGestation] = false
	},

	[kTechId.Adrenaline] =
	{
		[kUpDataTypeIndex] = kCombatUpgradeType.Upgrade,
		[kUpDataPriorityIndex] = 1,
		[kUpDataTeamIndex] = 2,
		[kUpDataRankIndex] = 1,
		[kUpDataCostIndex] = 1,
		[kUpDataHardCapIndex] = 0,
		[kUpDataConsoleNameIndex] = "adrenaline",
		[kUpDataCategoryIndex] = "Shift",
		[kUpDataPersistIndex] = true,
		[kUpDataPassiveIndex] = false,
		[kUpDataMutuallyExclusiveIndex] = { kTechId.Celerity, kTechId.Crush },
		[kUpDataPrerequisiteIndex] = { },
		[kUpDataRequiresGestation] = true
	},

	[kTechId.Celerity] =
	{
		[kUpDataTypeIndex] = kCombatUpgradeType.Upgrade,
		[kUpDataPriorityIndex] = 2,
		[kUpDataTeamIndex] = 2,
		[kUpDataRankIndex] = 1,
		[kUpDataCostIndex] = 1,
		[kUpDataHardCapIndex] = 0,
		[kUpDataConsoleNameIndex] = "celerity",
		[kUpDataCategoryIndex] = "Shift",
		[kUpDataPersistIndex] = true,
		[kUpDataPassiveIndex] = false,
		[kUpDataMutuallyExclusiveIndex] = { kTechId.Adrenaline, kTechId.Crush },
		[kUpDataPrerequisiteIndex] = { },
		[kUpDataRequiresGestation] = true
	},

	[kTechId.Crush] =
	{
		[kUpDataTypeIndex] = kCombatUpgradeType.Upgrade,
		[kUpDataPriorityIndex] = 3,
		[kUpDataTeamIndex] = 2,
		[kUpDataRankIndex] = 1,
		[kUpDataCostIndex] = 1,
		[kUpDataHardCapIndex] = 0,
		[kUpDataConsoleNameIndex] = "crush",
		[kUpDataCategoryIndex] = "Shift",
		[kUpDataPersistIndex] = true,
		[kUpDataPassiveIndex] = false,
		[kUpDataMutuallyExclusiveIndex] = { kTechId.Adrenaline, kTechId.Celerity },
		[kUpDataPrerequisiteIndex] = { },
		[kUpDataRequiresGestation] = true
	},

	[kTechId.Camouflage] =
	{
		[kUpDataTypeIndex] = kCombatUpgradeType.Upgrade,
		[kUpDataPriorityIndex] = 1,
		[kUpDataTeamIndex] = 2,
		[kUpDataRankIndex] = 1,
		[kUpDataCostIndex] = 1,
		[kUpDataHardCapIndex] = 0,
		[kUpDataConsoleNameIndex] = "camouflage",
		[kUpDataCategoryIndex] = "Shade",
		[kUpDataPersistIndex] = true,
		[kUpDataPassiveIndex] = false,
		[kUpDataMutuallyExclusiveIndex] = { kTechId.Aura, kTechId.Focus },
		[kUpDataPrerequisiteIndex] = { },
		[kUpDataRequiresGestation] = true
	},

	[kTechId.Focus] =
	{
		[kUpDataTypeIndex] = kCombatUpgradeType.Upgrade,
		[kUpDataPriorityIndex] = 2,
		[kUpDataTeamIndex] = 2,
		[kUpDataRankIndex] = 1,
		[kUpDataCostIndex] = 1,
		[kUpDataHardCapIndex] = 0,
		[kUpDataConsoleNameIndex] = "focus",
		[kUpDataCategoryIndex] = "Shade",
		[kUpDataPersistIndex] = true,
		[kUpDataPassiveIndex] = false,
		[kUpDataMutuallyExclusiveIndex] = { kTechId.Aura, kTechId.Camouflage },
		[kUpDataPrerequisiteIndex] = { },
		[kUpDataRequiresGestation] = true
	},

	[kTechId.Aura] =
	{
		[kUpDataTypeIndex] = kCombatUpgradeType.Upgrade,
		[kUpDataPriorityIndex] = 3,
		[kUpDataTeamIndex] = 2,
		[kUpDataRankIndex] = 1,
		[kUpDataCostIndex] = 1,
		[kUpDataHardCapIndex] = 0,
		[kUpDataConsoleNameIndex] = "aura",
		[kUpDataCategoryIndex] = "Shade",
		[kUpDataPersistIndex] = true,
		[kUpDataPassiveIndex] = false,
		[kUpDataMutuallyExclusiveIndex] = { kTechId.Focus, kTechId.Camouflage },
		[kUpDataPrerequisiteIndex] = { },
		[kUpDataRequiresGestation] = true
	},

	[kTechId.Regeneration] =
	{
		[kUpDataTypeIndex] = kCombatUpgradeType.Upgrade,
		[kUpDataPriorityIndex] = 1,
		[kUpDataTeamIndex] = 2,
		[kUpDataRankIndex] = 1,
		[kUpDataCostIndex] = 1,
		[kUpDataHardCapIndex] = 0,
		[kUpDataConsoleNameIndex] = "regeneration",
		[kUpDataCategoryIndex] = "Crag",
		[kUpDataPersistIndex] = true,
		[kUpDataPassiveIndex] = false,
		[kUpDataMutuallyExclusiveIndex] = { kTechId.Carapace, kTechId.Vampirism },
		[kUpDataPrerequisiteIndex] = { },
		[kUpDataRequiresGestation] = true
	},

	[kTechId.Carapace] =
	{
		[kUpDataTypeIndex] = kCombatUpgradeType.Upgrade,
		[kUpDataPriorityIndex] = 2,
		[kUpDataTeamIndex] = 2,
		[kUpDataRankIndex] = 1,
		[kUpDataCostIndex] = 1,
		[kUpDataHardCapIndex] = 0,
		[kUpDataConsoleNameIndex] = "carapace",
		[kUpDataCategoryIndex] = "Crag",
		[kUpDataPersistIndex] = true,
		[kUpDataPassiveIndex] = false,
		[kUpDataMutuallyExclusiveIndex] = { kTechId.Regeneration, kTechId.Vampirism },
		[kUpDataPrerequisiteIndex] = { },
		[kUpDataRequiresGestation] = true
	},

	[kTechId.Vampirism] =
	{
		[kUpDataTypeIndex] = kCombatUpgradeType.Upgrade,
		[kUpDataPriorityIndex] = 3,
		[kUpDataTeamIndex] = 2,
		[kUpDataRankIndex] = 1,
		[kUpDataCostIndex] = 1,
		[kUpDataHardCapIndex] = 0,
		[kUpDataConsoleNameIndex] = "vampirism",
		[kUpDataCategoryIndex] = "Crag",
		[kUpDataPersistIndex] = true,
		[kUpDataPassiveIndex] = false,
		[kUpDataMutuallyExclusiveIndex] = { kTechId.Regeneration, kTechId.Carapace },
		[kUpDataPrerequisiteIndex] = { },
		[kUpDataRequiresGestation] = true
	},

	[kTechId.BileBomb] =
	{
		[kUpDataTypeIndex] = kCombatUpgradeType.Upgrade,
		[kUpDataPriorityIndex] = 1,
		[kUpDataTeamIndex] = 2,
		[kUpDataRankIndex] = 4,
		[kUpDataCostIndex] = 1,
		[kUpDataHardCapIndex] = 0,
		[kUpDataConsoleNameIndex] = "bilebomb",
		[kUpDataCategoryIndex] = "Ability",
		[kUpDataPersistIndex] = false,
		[kUpDataPassiveIndex] = false,
		[kUpDataMutuallyExclusiveIndex] = { },
		[kUpDataPrerequisiteIndex] = { kTechId.Gorge },
		[kUpDataRequiresGestation] = false,
		[kUpDataRequiresOneHiveIndex] = true,
		[kUpDataRequiresTwoHivesIndex] = false,
		[kUpDataRequiresThreeHivesIndex] = false
	},

	[kTechId.Leap] =
	{
		[kUpDataTypeIndex] = kCombatUpgradeType.Upgrade,
		[kUpDataPriorityIndex] = 1,
		[kUpDataTeamIndex] = 2,
		[kUpDataRankIndex] = 3,
		[kUpDataCostIndex] = 1,
		[kUpDataHardCapIndex] = 0,
		[kUpDataConsoleNameIndex] = "leap",
		[kUpDataCategoryIndex] = "Ability",
		[kUpDataPersistIndex] = true,
		[kUpDataPassiveIndex] = false,
		[kUpDataMutuallyExclusiveIndex] = { },
		[kUpDataPrerequisiteIndex] = { kTechId.Skulk },
		[kUpDataRequiresGestation] = false,
		[kUpDataRequiresOneHiveIndex] = true,
		[kUpDataRequiresTwoHivesIndex] = true,
		[kUpDataRequiresThreeHivesIndex] = false
	},

	[kTechId.Xenocide] =
	{
		[kUpDataTypeIndex] = kCombatUpgradeType.Upgrade,
		[kUpDataPriorityIndex] = 1,
		[kUpDataTeamIndex] = 2,
		[kUpDataRankIndex] = 7,
		[kUpDataCostIndex] = 1,
		[kUpDataHardCapIndex] = 0,
		[kUpDataConsoleNameIndex] = "xenocide",
		[kUpDataCategoryIndex] = "Ability",
		[kUpDataPersistIndex] = true,
		[kUpDataPassiveIndex] = false,
		[kUpDataMutuallyExclusiveIndex] = { },
		[kUpDataPrerequisiteIndex] = { kTechId.Skulk },
		[kUpDataRequiresGestation] = false,
		[kUpDataRequiresOneHiveIndex] = true,
		[kUpDataRequiresTwoHivesIndex] = true,
		[kUpDataRequiresThreeHivesIndex] = true
	},

	[kTechId.Spores] =
	{
		[kUpDataTypeIndex] = kCombatUpgradeType.Upgrade,
		[kUpDataPriorityIndex] = 1,
		[kUpDataTeamIndex] = 2,
		[kUpDataRankIndex] = 3,
		[kUpDataCostIndex] = 1,
		[kUpDataHardCapIndex] = 0,
		[kUpDataConsoleNameIndex] = "spores",
		[kUpDataCategoryIndex] = "Ability",
		[kUpDataPersistIndex] = false,
		[kUpDataPassiveIndex] = false,
		[kUpDataMutuallyExclusiveIndex] = { },
		[kUpDataPrerequisiteIndex] = { kTechId.Lerk },
		[kUpDataRequiresGestation] = false,
		[kUpDataRequiresOneHiveIndex] = true,
		[kUpDataRequiresTwoHivesIndex] = true,
		[kUpDataRequiresThreeHivesIndex] = false
	},

	[kTechId.Umbra] =
	{
		[kUpDataTypeIndex] = kCombatUpgradeType.Upgrade,
		[kUpDataPriorityIndex] = 1,
		[kUpDataTeamIndex] = 2,
		[kUpDataRankIndex] = 5,
		[kUpDataCostIndex] = 1,
		[kUpDataHardCapIndex] = 0,
		[kUpDataConsoleNameIndex] = "umbra",
		[kUpDataCategoryIndex] = "Ability",
		[kUpDataPersistIndex] = false,
		[kUpDataPassiveIndex] = false,
		[kUpDataMutuallyExclusiveIndex] = { },
		[kUpDataPrerequisiteIndex] = { kTechId.Lerk },
		[kUpDataRequiresGestation] = false,
		[kUpDataRequiresOneHiveIndex] = true,
		[kUpDataRequiresTwoHivesIndex] = false,
		[kUpDataRequiresThreeHivesIndex] = false
	},

	[kTechId.MetabolizeEnergy] =
	{
		[kUpDataTypeIndex] = kCombatUpgradeType.Upgrade,
		[kUpDataPriorityIndex] = 1,
		[kUpDataTeamIndex] = 2,
		[kUpDataRankIndex] = 5,
		[kUpDataCostIndex] = 1,
		[kUpDataHardCapIndex] = 0,
		[kUpDataConsoleNameIndex] = "meta",
		[kUpDataCategoryIndex] = "Ability",
		[kUpDataPersistIndex] = false,
		[kUpDataPassiveIndex] = false,
		[kUpDataMutuallyExclusiveIndex] = { },
		[kUpDataPrerequisiteIndex] = { kTechId.Fade },
		[kUpDataRequiresGestation] = false,
		[kUpDataRequiresOneHiveIndex] = true,
		[kUpDataRequiresTwoHivesIndex] = false,
		[kUpDataRequiresThreeHivesIndex] = false
	},

	[kTechId.MetabolizeHealth] =
	{
		[kUpDataTypeIndex] = kCombatUpgradeType.Upgrade,
		[kUpDataPriorityIndex] = 1,
		[kUpDataTeamIndex] = 2,
		[kUpDataRankIndex] = 6,
		[kUpDataCostIndex] = 1,
		[kUpDataHardCapIndex] = 0,
		[kUpDataConsoleNameIndex] = "advmeta",
		[kUpDataCategoryIndex] = "Ability",
		[kUpDataPersistIndex] = false,
		[kUpDataPassiveIndex] = false,
		[kUpDataMutuallyExclusiveIndex] = { },
		[kUpDataPrerequisiteIndex] = { kTechId.Fade, kTechId.MetabolizeEnergy },
		[kUpDataRequiresGestation] = false,
		[kUpDataRequiresOneHiveIndex] = true,
		[kUpDataRequiresTwoHivesIndex] = true,
		[kUpDataRequiresThreeHivesIndex] = false
	},

	[kTechId.Stab] =
	{
		[kUpDataTypeIndex] = kCombatUpgradeType.Upgrade,
		[kUpDataPriorityIndex] = 1,
		[kUpDataTeamIndex] = 2,
		[kUpDataRankIndex] = 7,
		[kUpDataCostIndex] = 1,
		[kUpDataHardCapIndex] = 0,
		[kUpDataConsoleNameIndex] = "advmeta",
		[kUpDataCategoryIndex] = "Ability",
		[kUpDataPersistIndex] = false,
		[kUpDataPassiveIndex] = false,
		[kUpDataMutuallyExclusiveIndex] = { },
		[kUpDataPrerequisiteIndex] = { kTechId.Fade },
		[kUpDataRequiresGestation] = false,
		[kUpDataRequiresOneHiveIndex] = true,
		[kUpDataRequiresTwoHivesIndex] = true,
		[kUpDataRequiresThreeHivesIndex] = false,
		[kUpDataRequiresOneHiveIndex] = true,
		[kUpDataRequiresTwoHivesIndex] = true,
		[kUpDataRequiresThreeHivesIndex] = false
	},

	[kTechId.Charge] =
	{
		[kUpDataTypeIndex] = kCombatUpgradeType.Upgrade,
		[kUpDataPriorityIndex] = 1,
		[kUpDataTeamIndex] = 2,
		[kUpDataRankIndex] = 6,
		[kUpDataCostIndex] = 1,
		[kUpDataHardCapIndex] = 0,
		[kUpDataConsoleNameIndex] = "charge",
		[kUpDataCategoryIndex] = "Ability",
		[kUpDataPersistIndex] = false,
		[kUpDataPassiveIndex] = false,
		[kUpDataMutuallyExclusiveIndex] = { kTechId.Onos },
		[kUpDataPrerequisiteIndex] = { },
		[kUpDataRequiresGestation] = false,
		[kUpDataRequiresOneHiveIndex] = true,
		[kUpDataRequiresTwoHivesIndex] = false,
		[kUpDataRequiresThreeHivesIndex] = false
	},

	[kTechId.BoneShield] =
	{
		[kUpDataTypeIndex] = kCombatUpgradeType.Upgrade,
		[kUpDataPriorityIndex] = 1,
		[kUpDataTeamIndex] = 2,
		[kUpDataRankIndex] = 7,
		[kUpDataCostIndex] = 1,
		[kUpDataHardCapIndex] = 0,
		[kUpDataConsoleNameIndex] = "boneshield",
		[kUpDataCategoryIndex] = "Ability",
		[kUpDataPersistIndex] = false,
		[kUpDataPassiveIndex] = false,
		[kUpDataMutuallyExclusiveIndex] = { },
		[kUpDataPrerequisiteIndex] = { kTechId.Onos },
		[kUpDataRequiresGestation] = false,
		[kUpDataRequiresOneHiveIndex] = true,
		[kUpDataRequiresTwoHivesIndex] = true,
		[kUpDataRequiresThreeHivesIndex] = false
	},

	[kTechId.Stomp] =
	{
		[kUpDataTypeIndex] = kCombatUpgradeType.Upgrade,
		[kUpDataPriorityIndex] = 1,
		[kUpDataTeamIndex] = 2,
		[kUpDataRankIndex] = 8,
		[kUpDataCostIndex] = 1,
		[kUpDataHardCapIndex] = 0,
		[kUpDataConsoleNameIndex] = "stomp",
		[kUpDataCategoryIndex] = "Ability",
		[kUpDataPersistIndex] = false,
		[kUpDataPassiveIndex] = false,
		[kUpDataMutuallyExclusiveIndex] = {  },
		[kUpDataPrerequisiteIndex] = { kTechId.Onos },
		[kUpDataRequiresGestation] = false,
		[kUpDataRequiresOneHiveIndex] = true,
		[kUpDataRequiresTwoHivesIndex] = true,
		[kUpDataRequiresThreeHivesIndex] = true
	},

	[kTechId.EnzymeCloud] =
	{
		[kUpDataTypeIndex] = kCombatUpgradeType.Special,
		[kUpDataPriorityIndex] = 1,
		[kUpDataTeamIndex] = 2,
		[kUpDataRankIndex] = 2,
		[kUpDataCostIndex] = 1,
		[kUpDataHardCapIndex] = 0,
		[kUpDataConsoleNameIndex] = "enzyme",
		[kUpDataCategoryIndex] = "Special",
		[kUpDataPersistIndex] = false,
		[kUpDataPassiveIndex] = false,
		[kUpDataMutuallyExclusiveIndex] = {  },
		[kUpDataPrerequisiteIndex] = { },
		[kUpDataRequiresGestation] = false,
		[kUpDataRequiresOneHiveIndex] = false,
		[kUpDataRequiresTwoHivesIndex] = false,
		[kUpDataRequiresThreeHivesIndex] = false
	},

	[kTechId.ShadeInk] =
	{
		[kUpDataTypeIndex] = kCombatUpgradeType.Special,
		[kUpDataPriorityIndex] = 1,
		[kUpDataTeamIndex] = 2,
		[kUpDataRankIndex] = 2,
		[kUpDataCostIndex] = 1,
		[kUpDataHardCapIndex] = 0,
		[kUpDataConsoleNameIndex] = "ink",
		[kUpDataCategoryIndex] = "Special",
		[kUpDataPersistIndex] = false,
		[kUpDataPassiveIndex] = false,
		[kUpDataMutuallyExclusiveIndex] = {  },
		[kUpDataPrerequisiteIndex] = { },
		[kUpDataRequiresGestation] = false,
		[kUpDataRequiresOneHiveIndex] = false,
		[kUpDataRequiresTwoHivesIndex] = false,
		[kUpDataRequiresThreeHivesIndex] = false
	},

	[kTechId.Hallucinate] =
	{
		[kUpDataTypeIndex] = kCombatUpgradeType.Special,
		[kUpDataPriorityIndex] = 1,
		[kUpDataTeamIndex] = 2,
		[kUpDataRankIndex] = 3,
		[kUpDataCostIndex] = 1,
		[kUpDataHardCapIndex] = 0,
		[kUpDataConsoleNameIndex] = "hallucinate",
		[kUpDataCategoryIndex] = "Special",
		[kUpDataPersistIndex] = false,
		[kUpDataPassiveIndex] = false,
		[kUpDataMutuallyExclusiveIndex] = {  },
		[kUpDataPrerequisiteIndex] = { },
		[kUpDataRequiresGestation] = false,
		[kUpDataRequiresOneHiveIndex] = false,
		[kUpDataRequiresTwoHivesIndex] = false,
		[kUpDataRequiresThreeHivesIndex] = false
	}
}

function LookupUpgradeData(techId, index)

	assert(techId)
	assert(index)

	return kCombatUpgradeData[techId][index]

end

function LookupUpgradesByType(type, teamNumber)

	local upsByType = { }

	for techId, upgrade in pairs(kCombatUpgradeData) do

		if (upgrade[kUpDataTypeIndex] and
			upgrade[kUpDataTeamIndex] and
			upgrade[kUpDataTypeIndex] == type and
			upgrade[kUpDataTeamIndex] == teamNumber) then

				table.insert(upsByType, techId)

		end

	end

	table.sort(upsByType,
        function(a,b)
            local rankA = LookupUpgradeData(a, kUpDataRankIndex)
            local rankB = LookupUpgradeData(b, kUpDataRankIndex)
            return rankA < rankB
        end)

	return upsByType

end

function LookupUpgradesByCategory(category, teamNumber)

	local upsByCategory = { }

	for techId, upgrade in pairs(kCombatUpgradeData) do

		if (upgrade[kUpDataCategoryIndex] and
			upgrade[kUpDataTeamIndex] and
			upgrade[kUpDataCategoryIndex] == category and
			upgrade[kUpDataTeamIndex] == teamNumber) then

				table.insert(upsByCategory, techId)

		end

	end

	table.sort(upsByCategory,
        function(a,b)
            local rankA = LookupUpgradeData(a, kUpDataRankIndex)
            local rankB = LookupUpgradeData(b, kUpDataRankIndex)
            return rankA < rankB
        end)

	return upsByCategory

end

function LookupUpgradesByPrereq(prereqTechId, teamNumber)

	local upgrades = { }

	for techId, upgrade in pairs(kCombatUpgradeData) do

		if (upgrade[kUpDataTeamIndex] and
			upgrade[kUpDataTeamIndex] == teamNumber and
			upgrade[kUpDataPrerequisiteIndex]) then

				for _, prereqId in ipairs(upgrade[kUpDataPrerequisiteIndex]) do
					if prereqId == prereqTechId then
						table.insert(upgrades, techId)
						break
					end
				end

		end

	end

	table.sort(upgrades,
        function(a,b)
            local rankA = LookupUpgradeData(a, kUpDataRankIndex)
            local rankB = LookupUpgradeData(b, kUpDataRankIndex)
            return rankA < rankB
		end)
		
	return upgrades

end

function LookupUpgradesByCategoryAndPrereq(category, prereqTechId, teamNumber)

	local upsByCategory = { }

	for techId, upgrade in pairs(kCombatUpgradeData) do

		if (upgrade[kUpDataCategoryIndex] and
			upgrade[kUpDataTeamIndex] and
			upgrade[kUpDataCategoryIndex] == category and
			upgrade[kUpDataTeamIndex] == teamNumber and
			upgrade[kUpDataPrerequisiteIndex]) then

				for _, prereqId in ipairs(upgrade[kUpDataPrerequisiteIndex]) do
					if prereqId == prereqTechId then
						table.insert(upsByCategory, techId)
						break
					end
				end

		end

	end

	table.sort(upsByCategory,
        function(a,b)
            local rankA = LookupUpgradeData(a, kUpDataRankIndex)
            local rankB = LookupUpgradeData(b, kUpDataRankIndex)
            return rankA < rankB
        end)

	return upsByCategory

end

function GetUpgradeTechIdByConsoleName(consoleName)

	local upgradeTechId = kTechId.None

	for techId, upgradeData in pairs(kCombatUpgradeData) do

		if upgradeData[kUpDataConsoleNameIndex] and upgradeData[kUpDataConsoleNameIndex] == consoleName then
			
			upgradeTechId = techId
			break

		end

	end

	return upgradeTechId

end

function GetFirstUpgradeByPrereq(prereqTechId, teamNumber)

	local firstTechId = kTechId.None

	for techId, upgrade in pairs(kCombatUpgradeData) do

		if (upgrade[kUpDataTeamIndex] and
			upgrade[kUpDataTeamIndex] == teamNumber and
			upgrade[kUpDataPrerequisiteIndex]) then

				for _, prereqId in ipairs(upgrade[kUpDataPrerequisiteIndex]) do
					if prereqId == prereqTechId then
						firstTechId = techId
						break
					end
				end

		end

	end

	return firstTechId

end

if Client then

	function PrecacheUpgradeTextures()

		for techId, values in pairs(kCombatUpgradeData) do

			if values[kUpDataIconTextureIndex] then
				PrecacheAsset(values[kUpDataIconTextureIndex])
			end

		end

	end

end
