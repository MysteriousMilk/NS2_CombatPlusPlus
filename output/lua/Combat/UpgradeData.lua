Script.Load("lua/TechTreeConstants.lua")

-- Index used to retrieve the class name for some tech ids
kUpDataClassIndex = "class"

-- Index used to retrieve the team the upgrade is tied to
kUpDataTeamIndex = "team"

-- Index used to retrieve the rank required to unlock the upgrade
kUpDataRankIndex = "rank"

-- Index used to retrieve the cost of the upgrade
kUpDataCostIndex = "cost"

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

kCombatUpgradeData =
{
	[kTechId.Marine] =
	{
		[kUpDataTeamIndex] = 1,
		[kUpDataRankIndex] = 1,
		[kUpDataCostIndex] = 0,
		[kUpDataHardCapIndex] = 0,
		[kUpDataConsoleNameIndex] = "marine",
		[kUpDataCategoryIndex] = "Root",
		[kUpDataPersistIndex] = false,
		[kUpDataPassiveIndex] = false,
		[kUpDataMutuallyExclusiveIndex] = { }
	},

	[kTechId.Jetpack] =
	{
		[kUpDataTeamIndex] = 1,
		[kUpDataRankIndex] = 7,
		[kUpDataCostIndex] = 2,
		[kUpDataHardCapIndex] = 0,
		[kUpDataConsoleNameIndex] = "jp",
		[kUpDataCategoryIndex] = "Tech",
		[kUpDataPersistIndex] = false,
		[kUpDataPassiveIndex] = false,
		[kUpDataMutuallyExclusiveIndex] = { },
		[kUpDataIconTextureIndex] = "ui/combatui_marine_tech_icons.dds",
		[kUpDataIconTextureOffsetIndex] = 5,
		[kUpDataIconSizeIndex] = Vector(64, 64, 0),
		[kUpDataLargeIconTextureIndex] = "ui/marine_buy_bigicons.dds",
		[kUpDataLargeIconTextureOffsetIndex] = 6,
		[kUpDataLargeIconSizeIndex] = Vector(400, 300, 0)
	},

	[kTechId.DualMinigunExosuit] =
	{
		[kUpDataTeamIndex] = 1,
		[kUpDataRankIndex] = 8,
		[kUpDataCostIndex] = 2,
		[kUpDataHardCapIndex] = 1/3,
		[kUpDataConsoleNameIndex] = "minigunexo",
		[kUpDataCategoryIndex] = "Tech",
		[kUpDataDescIndex] = "An armored exosuit with a minigun equipped to each arm.",
		[kUpDataPersistIndex] = false,
		[kUpDataPassiveIndex] = false,
		[kUpDataMutuallyExclusiveIndex] = { kTechId.DualRailgunExosuit },
		[kUpDataIconTextureIndex] = "ui/combatui_marine_tech_icons.dds",
		[kUpDataIconTextureOffsetIndex] = 6,
		[kUpDataIconSizeIndex] = Vector(64, 64, 0),
		[kUpDataLargeIconTextureIndex] = "ui/marine_buy_bigicons.dds",
		[kUpDataLargeIconTextureOffsetIndex] = 10,
		[kUpDataLargeIconSizeIndex] = Vector(400, 300, 0)
	},

	[kTechId.DualRailgunExosuit] =
	{
		[kUpDataTeamIndex] = 1,
		[kUpDataRankIndex] = 8,
		[kUpDataCostIndex] = 2,
		[kUpDataHardCapIndex] = 1/3,
		[kUpDataConsoleNameIndex] = "railgunexo",
		[kUpDataCategoryIndex] = "Tech",
		[kUpDataDescIndex] = "An armored exosuit with a railgun equipped to each arm.",
		[kUpDataPersistIndex] = false,
		[kUpDataPassiveIndex] = false,
		[kUpDataMutuallyExclusiveIndex] = { kTechId.DualMinigunExosuit },
		[kUpDataIconTextureIndex] = "ui/combatui_marine_tech_icons.dds",
		[kUpDataIconTextureOffsetIndex] = 7,
		[kUpDataIconSizeIndex] = Vector(64, 64, 0),
		[kUpDataLargeIconTextureIndex] = "ui/marine_buy_bigicons.dds",
		[kUpDataLargeIconTextureOffsetIndex] = 11,
		[kUpDataLargeIconSizeIndex] = Vector(400, 300, 0)
	},

	[kTechId.Pistol] =
	{
		[kUpDataTeamIndex] = 1,
		[kUpDataRankIndex] = 1,
		[kUpDataCostIndex] = 1,
		[kUpDataHardCapIndex] = 0,
		[kUpDataConsoleNameIndex] = "pistol",
		[kUpDataCategoryIndex] = "Weapon",
		[kUpDataPersistIndex] = true,
		[kUpDataPassiveIndex] = false,
		[kUpDataMutuallyExclusiveIndex] = { },
		[kUpDataIconTextureIndex] = "ui/combatui_marine_weapon_icons.dds",
		[kUpDataIconTextureOffsetIndex] = 0,
		[kUpDataIconSizeIndex] = Vector(128, 64, 0),
		[kUpDataLargeIconTextureIndex] = "ui/marine_buy_bigicons.dds",
		[kUpDataLargeIconTextureOffsetIndex] = 1,
		[kUpDataLargeIconSizeIndex] = Vector(400, 300, 0)
	},

	[kTechId.Rifle] =
	{
		[kUpDataTeamIndex] = 1,
		[kUpDataRankIndex] = 1,
		[kUpDataCostIndex] = 1,
		[kUpDataHardCapIndex] = 0,
		[kUpDataConsoleNameIndex] = "rifle",
		[kUpDataCategoryIndex] = "Weapon",
		[kUpDataPersistIndex] = false,
		[kUpDataPassiveIndex] = false,
		[kUpDataMutuallyExclusiveIndex] = { kTechId.Shotgun, kTechId.Flamethrower, kTechId.GrenadeLauncher, kTechId.HeavyMachineGun },
		[kUpDataIconTextureIndex] = "ui/combatui_marine_weapon_icons.dds",
		[kUpDataIconTextureOffsetIndex] = 1,
		[kUpDataIconSizeIndex] = Vector(128, 64, 0),
		[kUpDataLargeIconTextureIndex] = "ui/marine_buy_bigicons.dds",
		[kUpDataLargeIconTextureOffsetIndex] = 2,
		[kUpDataLargeIconSizeIndex] = Vector(400, 300, 0)
	},

	[kTechId.Shotgun] =
	{
		[kUpDataTeamIndex] = 1,
		[kUpDataRankIndex] = 3,
		[kUpDataCostIndex] = 1,
		[kUpDataHardCapIndex] = 0,
		[kUpDataConsoleNameIndex] = "shotgun",
		[kUpDataCategoryIndex] = "Weapon",
		[kUpDataPersistIndex] = false,
		[kUpDataPassiveIndex] = false,
		[kUpDataMutuallyExclusiveIndex] = { kTechId.Rifle, kTechId.Flamethrower, kTechId.GrenadeLauncher, kTechId.HeavyMachineGun },
		[kUpDataIconTextureIndex] = "ui/combatui_marine_weapon_icons.dds",
		[kUpDataIconTextureOffsetIndex] = 2,
		[kUpDataIconSizeIndex] = Vector(128, 64, 0),
		[kUpDataLargeIconTextureIndex] = "ui/marine_buy_bigicons.dds",
		[kUpDataLargeIconTextureOffsetIndex] = 3,
		[kUpDataLargeIconSizeIndex] = Vector(400, 300, 0)
	},

	[kTechId.Flamethrower] =
	{
		[kUpDataTeamIndex] = 1,
		[kUpDataRankIndex] = 5,
		[kUpDataCostIndex] = 1,
		[kUpDataHardCapIndex] = 1/2,
		[kUpDataConsoleNameIndex] = "flamethrower",
		[kUpDataCategoryIndex] = "Weapon",
		[kUpDataPersistIndex] = false,
		[kUpDataPassiveIndex] = false,
		[kUpDataMutuallyExclusiveIndex] = { kTechId.Rifle, kTechId.Shotgun, kTechId.GrenadeLauncher, kTechId.HeavyMachineGun },
		[kUpDataIconTextureIndex] = "ui/combatui_marine_weapon_icons.dds",
		[kUpDataIconTextureOffsetIndex] = 3,
		[kUpDataIconSizeIndex] = Vector(128, 64, 0),
		[kUpDataLargeIconTextureIndex] = "ui/marine_buy_bigicons.dds",
		[kUpDataLargeIconTextureOffsetIndex] = 5,
		[kUpDataLargeIconSizeIndex] = Vector(400, 300, 0)
	},

	[kTechId.GrenadeLauncher] =
	{
		[kUpDataTeamIndex] = 1,
		[kUpDataRankIndex] = 6,
		[kUpDataCostIndex] = 2,
		[kUpDataHardCapIndex] = 1/2,
		[kUpDataConsoleNameIndex] = "gl",
		[kUpDataCategoryIndex] = "Weapon",
		[kUpDataPersistIndex] = false,
		[kUpDataPassiveIndex] = false,
		[kUpDataMutuallyExclusiveIndex] = { kTechId.Rifle, kTechId.Shotgun, kTechId.Flamethrower, kTechId.HeavyMachineGun },
		[kUpDataIconTextureIndex] = "ui/combatui_marine_weapon_icons.dds",
		[kUpDataIconTextureOffsetIndex] = 4,
		[kUpDataIconSizeIndex] = Vector(128, 64, 0),
		[kUpDataLargeIconTextureIndex] = "ui/marine_buy_bigicons.dds",
		[kUpDataLargeIconTextureOffsetIndex] = 4,
		[kUpDataLargeIconSizeIndex] = Vector(400, 300, 0)
	},

	[kTechId.HeavyMachineGun] =
	{
		[kUpDataTeamIndex] = 1,
		[kUpDataRankIndex] = 6,
		[kUpDataCostIndex] = 2,
		[kUpDataHardCapIndex] = 1/2,
		[kUpDataConsoleNameIndex] = "hmg",
		[kUpDataCategoryIndex] = "Weapon",
		[kUpDataPersistIndex] = false,
		[kUpDataPassiveIndex] = false,
		[kUpDataMutuallyExclusiveIndex] = { kTechId.Rifle, kTechId.Shotgun, kTechId.Flamethrower, kTechId.GrenadeLauncher },
		[kUpDataIconTextureIndex] = "ui/combatui_marine_weapon_icons.dds",
		[kUpDataIconTextureOffsetIndex] = 5,
		[kUpDataIconSizeIndex] = Vector(128, 64, 0),
		[kUpDataLargeIconTextureIndex] = "ui/marine_buy_bigicons.dds",
		[kUpDataLargeIconTextureOffsetIndex] = 15,
		[kUpDataLargeIconSizeIndex] = Vector(400, 300, 0)
	},

	[kTechId.Welder] =
	{
		[kUpDataTeamIndex] = 1,
		[kUpDataRankIndex] = 1,
		[kUpDataCostIndex] = 1,
		[kUpDataHardCapIndex] = 0,
		[kUpDataConsoleNameIndex] = "welder",
		[kUpDataCategoryIndex] = "Tech",
		[kUpDataPersistIndex] = true,
		[kUpDataPassiveIndex] = false,
		[kUpDataMutuallyExclusiveIndex] = { },
		[kUpDataIconTextureIndex] = "ui/combatui_marine_tech_icons.dds",
		[kUpDataIconTextureOffsetIndex] = 0,
		[kUpDataIconSizeIndex] = Vector(64, 64, 0),
		[kUpDataLargeIconTextureIndex] = "ui/marine_buy_bigicons.dds",
		[kUpDataLargeIconTextureOffsetIndex] = 8,
		[kUpDataLargeIconSizeIndex] = Vector(400, 300, 0)
	},

	[kTechId.LayMines] =
	{
		[kUpDataTeamIndex] = 1,
		[kUpDataRankIndex] = 4,
		[kUpDataCostIndex] = 1,
		[kUpDataHardCapIndex] = 0,
		[kUpDataConsoleNameIndex] = "mines",
		[kUpDataCategoryIndex] = "Tech",
		[kUpDataPersistIndex] = false,
		[kUpDataPassiveIndex] = false,
		[kUpDataMutuallyExclusiveIndex] = { },
		[kUpDataIconTextureIndex] = "ui/combatui_marine_tech_icons.dds",
		[kUpDataIconTextureOffsetIndex] = 1,
		[kUpDataIconSizeIndex] = Vector(64, 64, 0),
		[kUpDataLargeIconTextureIndex] = "ui/marine_buy_bigicons.dds",
		[kUpDataLargeIconTextureOffsetIndex] = 9,
		[kUpDataLargeIconSizeIndex] = Vector(400, 300, 0)
	},

	[kTechId.ClusterGrenade] =
	{
		[kUpDataTeamIndex] = 1,
		[kUpDataRankIndex] = 4,
		[kUpDataCostIndex] = 1,
		[kUpDataHardCapIndex] = 0,
		[kUpDataConsoleNameIndex] = "clustergrenade",
		[kUpDataCategoryIndex] = "Tech",
		[kUpDataPersistIndex] = true,
		[kUpDataPassiveIndex] = false,
		[kUpDataMutuallyExclusiveIndex] = { kTechId.GasGrenade, kTechId.PulseGrenade },
		[kUpDataIconTextureIndex] = "ui/combatui_marine_tech_icons.dds",
		[kUpDataIconTextureOffsetIndex] = 2,
		[kUpDataIconSizeIndex] = Vector(64, 64, 0),
		[kUpDataLargeIconTextureIndex] = "ui/marine_buy_bigicons.dds",
		[kUpDataLargeIconTextureOffsetIndex] = 12,
		[kUpDataLargeIconSizeIndex] = Vector(400, 300, 0)
	},

	[kTechId.GasGrenade] =
	{
		[kUpDataTeamIndex] = 1,
		[kUpDataRankIndex] = 4,
		[kUpDataCostIndex] = 1,
		[kUpDataHardCapIndex] = 0,
		[kUpDataConsoleNameIndex] = "gasgrenade",
		[kUpDataCategoryIndex] = "Tech",
		[kUpDataPersistIndex] = true,
		[kUpDataPassiveIndex] = false,
		[kUpDataMutuallyExclusiveIndex] = { kTechId.ClusterGrenade, kTechId.PulseGrenade },
		[kUpDataIconTextureIndex] = "ui/combatui_marine_tech_icons.dds",
		[kUpDataIconTextureOffsetIndex] = 3,
		[kUpDataIconSizeIndex] = Vector(64, 64, 0),
		[kUpDataLargeIconTextureIndex] = "ui/marine_buy_bigicons.dds",
		[kUpDataLargeIconTextureOffsetIndex] = 13,
		[kUpDataLargeIconSizeIndex] = Vector(400, 300, 0)
	},

	[kTechId.PulseGrenade] =
	{
		[kUpDataTeamIndex] = 1,
		[kUpDataRankIndex] = 4,
		[kUpDataCostIndex] = 1,
		[kUpDataHardCapIndex] = 0,
		[kUpDataConsoleNameIndex] = "pulsegrenade",
		[kUpDataCategoryIndex] = "Tech",
		[kUpDataPersistIndex] = true,
		[kUpDataPassiveIndex] = false,
		[kUpDataMutuallyExclusiveIndex] = { kTechId.ClusterGrenade, kTechId.GasGrenade },
		[kUpDataIconTextureIndex] = "ui/combatui_marine_tech_icons.dds",
		[kUpDataIconTextureOffsetIndex] = 4,
		[kUpDataIconSizeIndex] = Vector(64, 64, 0),
		[kUpDataLargeIconTextureIndex] = "ui/marine_buy_bigicons.dds",
		[kUpDataLargeIconTextureOffsetIndex] = 14,
		[kUpDataLargeIconSizeIndex] = Vector(400, 300, 0)
	},

	[kTechId.Armor1] =
	{
		[kUpDataTeamIndex] = 1,
		[kUpDataRankIndex] = 1,
		[kUpDataCostIndex] = 1,
		[kUpDataHardCapIndex] = 0,
		[kUpDataConsoleNameIndex] = "armor1",
		[kUpDataCategoryIndex] = "Upgrades",
		[kUpDataPersistIndex] = true,
		[kUpDataPassiveIndex] = false,
		[kUpDataMutuallyExclusiveIndex] = { },
		[kUpDataIconTextureIndex] = "ui/combatui_marine_upgrade_icons.dds",
		[kUpDataIconTextureOffsetIndex] = 0,
		[kUpDataIconSizeIndex] = Vector(64, 64, 0),
		[kUpDataLargeIconTextureIndex] = "ui/combatui_marine_icons_big.dds",
		[kUpDataLargeIconTextureOffsetIndex] = 4,
		[kUpDataLargeIconSizeIndex] = Vector(400, 300, 0)
	},

	[kTechId.Armor2] =
	{
		[kUpDataTeamIndex] = 1,
		[kUpDataRankIndex] = 2,
		[kUpDataCostIndex] = 1,
		[kUpDataHardCapIndex] = 0,
		[kUpDataConsoleNameIndex] = "armor2",
		[kUpDataCategoryIndex] = "Upgrades",
		[kUpDataPersistIndex] = true,
		[kUpDataPassiveIndex] = false,
		[kUpDataMutuallyExclusiveIndex] = { },
		[kUpDataIconTextureIndex] = "ui/combatui_marine_upgrade_icons.dds",
		[kUpDataIconTextureOffsetIndex] = 1,
		[kUpDataIconSizeIndex] = Vector(64, 64, 0),
		[kUpDataLargeIconTextureIndex] = "ui/combatui_marine_icons_big.dds",
		[kUpDataLargeIconTextureOffsetIndex] = 4,
		[kUpDataLargeIconSizeIndex] = Vector(400, 300, 0)
	},

	[kTechId.Armor3] =
	{
		[kUpDataTeamIndex] = 1,
		[kUpDataRankIndex] = 3,
		[kUpDataCostIndex] = 1,
		[kUpDataHardCapIndex] = 0,
		[kUpDataConsoleNameIndex] = "armor3",
		[kUpDataCategoryIndex] = "Upgrades",
		[kUpDataPersistIndex] = true,
		[kUpDataPassiveIndex] = false,
		[kUpDataMutuallyExclusiveIndex] = { },
		[kUpDataIconTextureIndex] = "ui/combatui_marine_upgrade_icons.dds",
		[kUpDataIconTextureOffsetIndex] = 2,
		[kUpDataIconSizeIndex] = Vector(64, 64, 0),
		[kUpDataLargeIconTextureIndex] = "ui/combatui_marine_icons_big.dds",
		[kUpDataLargeIconTextureOffsetIndex] = 4,
		[kUpDataLargeIconSizeIndex] = Vector(400, 300, 0)
	},

	[kTechId.Weapons1] =
	{
		[kUpDataTeamIndex] = 1,
		[kUpDataRankIndex] = 1,
		[kUpDataCostIndex] = 1,
		[kUpDataHardCapIndex] = 0,
		[kUpDataConsoleNameIndex] = "wpn1",
		[kUpDataCategoryIndex] = "Upgrades",
		[kUpDataPersistIndex] = true,
		[kUpDataPassiveIndex] = false,
		[kUpDataMutuallyExclusiveIndex] = { },
		[kUpDataIconTextureIndex] = "ui/combatui_marine_upgrade_icons.dds",
		[kUpDataIconTextureOffsetIndex] = 3,
		[kUpDataIconSizeIndex] = Vector(64, 64, 0),
		[kUpDataLargeIconTextureIndex] = "ui/combatui_marine_icons_big.dds",
		[kUpDataLargeIconTextureOffsetIndex] = 5,
		[kUpDataLargeIconSizeIndex] = Vector(400, 300, 0)
	},

	[kTechId.Weapons2] =
	{
		[kUpDataTeamIndex] = 1,
		[kUpDataRankIndex] = 2,
		[kUpDataCostIndex] = 1,
		[kUpDataHardCapIndex] = 0,
		[kUpDataConsoleNameIndex] = "wpn2",
		[kUpDataCategoryIndex] = "Upgrades",
		[kUpDataPersistIndex] = true,
		[kUpDataPassiveIndex] = false,
		[kUpDataMutuallyExclusiveIndex] = { },
		[kUpDataIconTextureIndex] = "ui/combatui_marine_upgrade_icons.dds",
		[kUpDataIconTextureOffsetIndex] = 4,
		[kUpDataIconSizeIndex] = Vector(64, 64, 0),
		[kUpDataLargeIconTextureIndex] = "ui/combatui_marine_icons_big.dds",
		[kUpDataLargeIconTextureOffsetIndex] = 5,
		[kUpDataLargeIconSizeIndex] = Vector(400, 300, 0)
	},

	[kTechId.Weapons3] =
	{
		[kUpDataTeamIndex] = 1,
		[kUpDataRankIndex] = 3,
		[kUpDataCostIndex] = 1,
		[kUpDataHardCapIndex] = 0,
		[kUpDataConsoleNameIndex] = "wpn3",
		[kUpDataCategoryIndex] = "Upgrades",
		[kUpDataPersistIndex] = true,
		[kUpDataPassiveIndex] = false,
		[kUpDataMutuallyExclusiveIndex] = { },
		[kUpDataIconTextureIndex] = "ui/combatui_marine_upgrade_icons.dds",
		[kUpDataIconTextureOffsetIndex] = 5,
		[kUpDataIconSizeIndex] = Vector(64, 64, 0)
	},

	[kTechId.MedPack] =
	{
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
		[kUpDataIconTextureIndex] = "ui/combatui_marine_upgrade_icons.dds",
		[kUpDataIconTextureOffsetIndex] = 6,
		[kUpDataIconSizeIndex] = Vector(64, 64, 0),
		[kUpDataLargeIconTextureIndex] = "ui/combatui_marine_icons_big.dds",
		[kUpDataLargeIconTextureOffsetIndex] = 0,
		[kUpDataLargeIconSizeIndex] = Vector(400, 300, 0)
	},

	[kTechId.AmmoPack] =
	{
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
		[kUpDataIconTextureIndex] = "ui/combatui_marine_upgrade_icons.dds",
		[kUpDataIconTextureOffsetIndex] = 7,
		[kUpDataIconSizeIndex] = Vector(64, 64, 0),
		[kUpDataLargeIconTextureIndex] = "ui/combatui_marine_icons_big.dds",
		[kUpDataLargeIconTextureOffsetIndex] = 1,
		[kUpDataLargeIconSizeIndex] = Vector(400, 300, 0)
	},

	[kTechId.CatPack] =
	{
		[kUpDataTeamIndex] = 1,
		[kUpDataRankIndex] = 5,
		[kUpDataCostIndex] = 1,
		[kUpDataHardCapIndex] = 0,
		[kUpDataConsoleNameIndex] = "catpack",
		[kUpDataCategoryIndex] = "Consumable",
		[kUpDataDescIndex] = "A pack that increases Marine movement and speed for a limited time.  Can be reused every time the cooldown expires.",
		[kUpDataPersistIndex] = true,
		[kUpDataPassiveIndex] = false,
		[kUpDataMutuallyExclusiveIndex] = { },
		[kUpDataIconTextureIndex] = "ui/combatui_marine_upgrade_icons.dds",
		[kUpDataIconTextureOffsetIndex] = 8,
		[kUpDataIconSizeIndex] = Vector(64, 64, 0),
		[kUpDataLargeIconTextureIndex] = "ui/combatui_marine_icons_big.dds",
		[kUpDataLargeIconTextureOffsetIndex] = 2,
		[kUpDataLargeIconSizeIndex] = Vector(400, 300, 0)
	},

	[kTechId.Scan] =
	{
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
		[kUpDataIconTextureIndex] = "ui/combatui_marine_upgrade_icons.dds",
		[kUpDataIconTextureOffsetIndex] = 9,
		[kUpDataIconSizeIndex] = Vector(64, 64, 0),
		[kUpDataLargeIconTextureIndex] = "ui/combatui_marine_icons_big.dds",
		[kUpDataLargeIconTextureOffsetIndex] = 3,
		[kUpDataLargeIconSizeIndex] = Vector(400, 300, 0)
	},

	[kTechId.Armory] =
	{
		[kUpDataClassIndex] = "Armory",
		[kUpDataTeamIndex] = 1,
		[kUpDataRankIndex] = 2,
		[kUpDataCostIndex] = 1,
		[kUpDataHardCapIndex] = 3,
		[kUpDataConsoleNameIndex] = "armory",
		[kUpDataCategoryIndex] = "Structures",
		[kUpDataPersistIndex] = false,
		[kUpDataPassiveIndex] = false,
		[kUpDataMutuallyExclusiveIndex] = { },
		[kUpDataIconTextureIndex] = "ui/combatui_marine_structure_icons.dds",
		[kUpDataIconTextureOffsetIndex] = 0,
		[kUpDataIconSizeIndex] = Vector(128, 192, 0),
		[kUpDataLargeIconTextureIndex] = "ui/combatui_marine_structure_icons_big.dds",
		[kUpDataLargeIconTextureOffsetIndex] = 0,
		[kUpDataLargeIconSizeIndex] = Vector(400, 300, 0)
	},

	[kTechId.PhaseGate] =
	{
		[kUpDataClassIndex] = "PhaseGate",
		[kUpDataTeamIndex] = 1,
		[kUpDataRankIndex] = 3,
		[kUpDataCostIndex] = 1,
		[kUpDataHardCapIndex] = 3,
		[kUpDataConsoleNameIndex] = "phasegate",
		[kUpDataCategoryIndex] = "Structures",
		[kUpDataPersistIndex] = false,
		[kUpDataPassiveIndex] = false,
		[kUpDataMutuallyExclusiveIndex] = { },
		[kUpDataIconTextureIndex] = "ui/combatui_marine_structure_icons.dds",
		[kUpDataIconTextureOffsetIndex] = 1,
		[kUpDataIconSizeIndex] = Vector(128, 192, 0),
		[kUpDataLargeIconTextureIndex] = "ui/combatui_marine_structure_icons_big.dds",
		[kUpDataLargeIconTextureOffsetIndex] = 1,
		[kUpDataLargeIconSizeIndex] = Vector(400, 300, 0)
	},

	[kTechId.Observatory] =
	{
		[kUpDataClassIndex] = "Observatory",
		[kUpDataTeamIndex] = 1,
		[kUpDataRankIndex] = 4,
		[kUpDataCostIndex] = 2,
		[kUpDataHardCapIndex] = 4,
		[kUpDataConsoleNameIndex] = "observatory",
		[kUpDataCategoryIndex] = "Structures",
		[kUpDataPersistIndex] = false,
		[kUpDataPassiveIndex] = false,
		[kUpDataMutuallyExclusiveIndex] = { },
		[kUpDataIconTextureIndex] = "ui/combatui_marine_structure_icons.dds",
		[kUpDataIconTextureOffsetIndex] = 2,
		[kUpDataIconSizeIndex] = Vector(128, 192, 0),
		[kUpDataLargeIconTextureIndex] = "ui/combatui_marine_structure_icons_big.dds",
		[kUpDataLargeIconTextureOffsetIndex] = 2,
		[kUpDataLargeIconSizeIndex] = Vector(400, 300, 0)
	},

	[kTechId.Sentry] =
	{
		[kUpDataClassIndex] = "Sentry",
		[kUpDataTeamIndex] = 1,
		[kUpDataRankIndex] = 5,
		[kUpDataCostIndex] = 1,
		[kUpDataHardCapIndex] = 8,
		[kUpDataConsoleNameIndex] = "sentry",
		[kUpDataCategoryIndex] = "Structures",
		[kUpDataDescIndex] = "An AI torrent that fires on enemy units.  Requires an active power node for the area it is located.",
		[kUpDataPersistIndex] = false,
		[kUpDataPassiveIndex] = false,
		[kUpDataMutuallyExclusiveIndex] = { },
		[kUpDataIconTextureIndex] = "ui/combatui_marine_structure_icons.dds",
		[kUpDataIconTextureOffsetIndex] = 3,
		[kUpDataIconSizeIndex] = Vector(128, 192, 0),
		[kUpDataLargeIconTextureIndex] = "ui/combatui_marine_structure_icons_big.dds",
		[kUpDataLargeIconTextureOffsetIndex] = 3,
		[kUpDataLargeIconSizeIndex] = Vector(400, 300, 0)
	},

	[kTechId.Skulk] =
	{
		[kUpDataTeamIndex] = 2,
		[kUpDataRankIndex] = 1,
		[kUpDataCostIndex] = 1,
		[kUpDataHardCapIndex] = 0,
		[kUpDataConsoleNameIndex] = "skulk",
		[kUpDataCategoryIndex] = "Lifeform",
		[kUpDataPersistIndex] = true,
		[kUpDataPassiveIndex] = false,
		[kUpDataMutuallyExclusiveIndex] = { kTechId.Gorge, kTechId.Lerk, kTechId.Fade, kTechId.Onos },
		[kUpDataRequiresGestation] = true
	},

	[kTechId.Gorge] =
	{
		[kUpDataTeamIndex] = 2,
		[kUpDataRankIndex] = 1,
		[kUpDataCostIndex] = 1,
		[kUpDataHardCapIndex] = 0,
		[kUpDataConsoleNameIndex] = "gorge",
		[kUpDataCategoryIndex] = "Lifeform",
		[kUpDataPersistIndex] = true,
		[kUpDataPassiveIndex] = false,
		[kUpDataMutuallyExclusiveIndex] = { kTechId.Skulk, kTechId.Lerk, kTechId.Fade, kTechId.Onos },
		[kUpDataRequiresGestation] = true
	},

	[kTechId.Lerk] =
	{
		[kUpDataTeamIndex] = 2,
		[kUpDataRankIndex] = 3,
		[kUpDataCostIndex] = 1,
		[kUpDataHardCapIndex] = 0,
		[kUpDataConsoleNameIndex] = "lerk",
		[kUpDataCategoryIndex] = "Lifeform",
		[kUpDataPersistIndex] = true,
		[kUpDataPassiveIndex] = false,
		[kUpDataMutuallyExclusiveIndex] = { kTechId.Skulk, kTechId.Gorge, kTechId.Fade, kTechId.Onos },
		[kUpDataRequiresGestation] = true
	},

	[kTechId.Fade] =
	{
		[kUpDataTeamIndex] = 2,
		[kUpDataRankIndex] = 5,
		[kUpDataCostIndex] = 2,
		[kUpDataHardCapIndex] = 0,
		[kUpDataConsoleNameIndex] = "fade",
		[kUpDataCategoryIndex] = "Lifeform",
		[kUpDataPersistIndex] = true,
		[kUpDataPassiveIndex] = false,
		[kUpDataMutuallyExclusiveIndex] = { kTechId.Skulk, kTechId.Gorge, kTechId.Lerk, kTechId.Onos },
		[kUpDataRequiresGestation] = true
	},

	[kTechId.Onos] =
	{
		[kUpDataTeamIndex] = 2,
		[kUpDataRankIndex] = 6,
		[kUpDataCostIndex] = 2,
		[kUpDataHardCapIndex] = 0,
		[kUpDataConsoleNameIndex] = "onos",
		[kUpDataCategoryIndex] = "Lifeform",
		[kUpDataPersistIndex] = true,
		[kUpDataPassiveIndex] = false,
		[kUpDataMutuallyExclusiveIndex] = { kTechId.Skulk, kTechId.Gorge, kTechId.Lerk, kTechId.Fade },
		[kUpDataRequiresGestation] = true
	},

	[kTechId.Spur] =
	{
		[kUpDataTeamIndex] = 2,
		[kUpDataRankIndex] = 2,
		[kUpDataCostIndex] = 1,
		[kUpDataHardCapIndex] = 0,
		[kUpDataConsoleNameIndex] = "spur",
		[kUpDataCategoryIndex] = "UpgradeType",
		[kUpDataPersistIndex] = true,
		[kUpDataPassiveIndex] = true,
		[kUpDataMutuallyExclusiveIndex] = { },
		[kUpDataRequiresGestation] = false
	},

	[kTechId.Veil] =
	{
		[kUpDataTeamIndex] = 2,
		[kUpDataRankIndex] = 2,
		[kUpDataCostIndex] = 1,
		[kUpDataHardCapIndex] = 0,
		[kUpDataConsoleNameIndex] = "veil",
		[kUpDataCategoryIndex] = "UpgradeType",
		[kUpDataPersistIndex] = true,
		[kUpDataPassiveIndex] = true,
		[kUpDataMutuallyExclusiveIndex] = { },
		[kUpDataRequiresGestation] = false
	},

	[kTechId.Shell] =
	{
		[kUpDataTeamIndex] = 2,
		[kUpDataRankIndex] = 2,
		[kUpDataCostIndex] = 1,
		[kUpDataHardCapIndex] = 0,
		[kUpDataConsoleNameIndex] = "shell",
		[kUpDataCategoryIndex] = "UpgradeType",
		[kUpDataPersistIndex] = true,
		[kUpDataPassiveIndex] = true,
		[kUpDataMutuallyExclusiveIndex] = { },
		[kUpDataRequiresGestation] = false
	},

	[kTechId.Adrenaline] =
	{
		[kUpDataTeamIndex] = 2,
		[kUpDataRankIndex] = 2,
		[kUpDataCostIndex] = 1,
		[kUpDataHardCapIndex] = 0,
		[kUpDataConsoleNameIndex] = "adrenaline",
		[kUpDataCategoryIndex] = "Upgrade",
		[kUpDataPersistIndex] = false,
		[kUpDataPassiveIndex] = false,
		[kUpDataMutuallyExclusiveIndex] = { kTechId.Celerity, kTechId.Silence },
		[kUpDataRequiresGestation] = true
	},

	[kTechId.Celerity] =
	{
		[kUpDataTeamIndex] = 2,
		[kUpDataRankIndex] = 2,
		[kUpDataCostIndex] = 1,
		[kUpDataHardCapIndex] = 0,
		[kUpDataConsoleNameIndex] = "celerity",
		[kUpDataCategoryIndex] = "Upgrade",
		[kUpDataPersistIndex] = false,
		[kUpDataPassiveIndex] = false,
		[kUpDataMutuallyExclusiveIndex] = { kTechId.Adrenaline, kTechId.Silence },
		[kUpDataRequiresGestation] = true
	},

	[kTechId.Silence] =
	{
		[kUpDataTeamIndex] = 2,
		[kUpDataRankIndex] = 2,
		[kUpDataCostIndex] = 1,
		[kUpDataHardCapIndex] = 0,
		[kUpDataConsoleNameIndex] = "silence",
		[kUpDataCategoryIndex] = "Upgrade",
		[kUpDataPersistIndex] = false,
		[kUpDataPassiveIndex] = false,
		[kUpDataMutuallyExclusiveIndex] = { kTechId.Adrenaline, kTechId.Celerity },
		[kUpDataRequiresGestation] = true
	},

	[kTechId.Aura] =
	{
		[kUpDataTeamIndex] = 2,
		[kUpDataRankIndex] = 2,
		[kUpDataCostIndex] = 1,
		[kUpDataHardCapIndex] = 0,
		[kUpDataConsoleNameIndex] = "aura",
		[kUpDataCategoryIndex] = "Upgrade",
		[kUpDataPersistIndex] = false,
		[kUpDataPassiveIndex] = false,
		[kUpDataMutuallyExclusiveIndex] = { kTechId.Focus, kTechId.Vampirism },
		[kUpDataRequiresGestation] = true
	},

	[kTechId.Focus] =
	{
		[kUpDataTeamIndex] = 2,
		[kUpDataRankIndex] = 2,
		[kUpDataCostIndex] = 1,
		[kUpDataHardCapIndex] = 0,
		[kUpDataConsoleNameIndex] = "focus",
		[kUpDataCategoryIndex] = "Upgrade",
		[kUpDataPersistIndex] = false,
		[kUpDataPassiveIndex] = false,
		[kUpDataMutuallyExclusiveIndex] = { kTechId.Aura, kTechId.Vampirism },
		[kUpDataRequiresGestation] = true
	},

	[kTechId.Vampirism] =
	{
		[kUpDataTeamIndex] = 2,
		[kUpDataRankIndex] = 2,
		[kUpDataCostIndex] = 1,
		[kUpDataHardCapIndex] = 0,
		[kUpDataConsoleNameIndex] = "vampirism",
		[kUpDataCategoryIndex] = "Upgrade",
		[kUpDataPersistIndex] = false,
		[kUpDataPassiveIndex] = false,
		[kUpDataMutuallyExclusiveIndex] = { kTechId.Aura, kTechId.Focus },
		[kUpDataRequiresGestation] = true
	},

	[kTechId.Regeneration] =
	{
		[kUpDataTeamIndex] = 2,
		[kUpDataRankIndex] = 2,
		[kUpDataCostIndex] = 1,
		[kUpDataHardCapIndex] = 0,
		[kUpDataConsoleNameIndex] = "regeneration",
		[kUpDataCategoryIndex] = "Upgrade",
		[kUpDataPersistIndex] = false,
		[kUpDataPassiveIndex] = false,
		[kUpDataMutuallyExclusiveIndex] = { kTechId.Carapace, kTechId.Crush },
		[kUpDataRequiresGestation] = true
	},

	[kTechId.Carapace] =
	{
		[kUpDataTeamIndex] = 2,
		[kUpDataRankIndex] = 2,
		[kUpDataCostIndex] = 1,
		[kUpDataHardCapIndex] = 0,
		[kUpDataConsoleNameIndex] = "carapace",
		[kUpDataCategoryIndex] = "Upgrade",
		[kUpDataPersistIndex] = false,
		[kUpDataPassiveIndex] = false,
		[kUpDataMutuallyExclusiveIndex] = { kTechId.Regeneration, kTechId.Crush },
		[kUpDataRequiresGestation] = true
	},

	[kTechId.Crush] =
	{
		[kUpDataTeamIndex] = 2,
		[kUpDataRankIndex] = 2,
		[kUpDataCostIndex] = 1,
		[kUpDataHardCapIndex] = 0,
		[kUpDataConsoleNameIndex] = "crush",
		[kUpDataCategoryIndex] = "Upgrade",
		[kUpDataPersistIndex] = false,
		[kUpDataPassiveIndex] = false,
		[kUpDataMutuallyExclusiveIndex] = { kTechId.Regeneration, kTechId.Carapace },
		[kUpDataRequiresGestation] = true
	},

	[kTechId.BileBomb] =
	{
		[kUpDataTeamIndex] = 2,
		[kUpDataRankIndex] = 4,
		[kUpDataCostIndex] = 1,
		[kUpDataHardCapIndex] = 0,
		[kUpDataConsoleNameIndex] = "bilebomb",
		[kUpDataCategoryIndex] = "Ability",
		[kUpDataPersistIndex] = true,
		[kUpDataPassiveIndex] = false,
		[kUpDataMutuallyExclusiveIndex] = { },
		[kUpDataRequiresGestation] = false,
		[kUpDataRequiresOneHiveIndex] = true,
		[kUpDataRequiresTwoHivesIndex] = false,
		[kUpDataRequiresThreeHivesIndex] = false
	},

	[kTechId.Leap] =
	{
		[kUpDataTeamIndex] = 2,
		[kUpDataRankIndex] = 3,
		[kUpDataCostIndex] = 1,
		[kUpDataHardCapIndex] = 0,
		[kUpDataConsoleNameIndex] = "leap",
		[kUpDataCategoryIndex] = "Ability",
		[kUpDataPersistIndex] = true,
		[kUpDataPassiveIndex] = false,
		[kUpDataMutuallyExclusiveIndex] = { },
		[kUpDataRequiresGestation] = false,
		[kUpDataRequiresOneHiveIndex] = true,
		[kUpDataRequiresTwoHivesIndex] = true,
		[kUpDataRequiresThreeHivesIndex] = false
	},

	[kTechId.Xenocide] =
	{
		[kUpDataTeamIndex] = 2,
		[kUpDataRankIndex] = 7,
		[kUpDataCostIndex] = 1,
		[kUpDataHardCapIndex] = 0,
		[kUpDataConsoleNameIndex] = "xenocide",
		[kUpDataCategoryIndex] = "Ability",
		[kUpDataPersistIndex] = true,
		[kUpDataPassiveIndex] = false,
		[kUpDataMutuallyExclusiveIndex] = { },
		[kUpDataRequiresGestation] = false,
		[kUpDataRequiresOneHiveIndex] = true,
		[kUpDataRequiresTwoHivesIndex] = true,
		[kUpDataRequiresThreeHivesIndex] = true
	},

	[kTechId.Spores] =
	{
		[kUpDataTeamIndex] = 2,
		[kUpDataRankIndex] = 3,
		[kUpDataCostIndex] = 1,
		[kUpDataHardCapIndex] = 0,
		[kUpDataConsoleNameIndex] = "spores",
		[kUpDataCategoryIndex] = "Ability",
		[kUpDataPersistIndex] = true,
		[kUpDataPassiveIndex] = false,
		[kUpDataMutuallyExclusiveIndex] = { },
		[kUpDataRequiresGestation] = false,
		[kUpDataRequiresOneHiveIndex] = true,
		[kUpDataRequiresTwoHivesIndex] = true,
		[kUpDataRequiresThreeHivesIndex] = false
	},

	[kTechId.Umbra] =
	{
		[kUpDataTeamIndex] = 2,
		[kUpDataRankIndex] = 5,
		[kUpDataCostIndex] = 1,
		[kUpDataHardCapIndex] = 0,
		[kUpDataConsoleNameIndex] = "umbra",
		[kUpDataCategoryIndex] = "Ability",
		[kUpDataPersistIndex] = true,
		[kUpDataPassiveIndex] = false,
		[kUpDataMutuallyExclusiveIndex] = { },
		[kUpDataRequiresGestation] = false,
		[kUpDataRequiresOneHiveIndex] = true,
		[kUpDataRequiresTwoHivesIndex] = false,
		[kUpDataRequiresThreeHivesIndex] = false
	},

	[kTechId.MetabolizeEnergy] =
	{
		[kUpDataTeamIndex] = 2,
		[kUpDataRankIndex] = 5,
		[kUpDataCostIndex] = 1,
		[kUpDataHardCapIndex] = 0,
		[kUpDataConsoleNameIndex] = "meta",
		[kUpDataCategoryIndex] = "Ability",
		[kUpDataPersistIndex] = true,
		[kUpDataPassiveIndex] = false,
		[kUpDataMutuallyExclusiveIndex] = { },
		[kUpDataRequiresGestation] = false,
		[kUpDataRequiresOneHiveIndex] = true,
		[kUpDataRequiresTwoHivesIndex] = false,
		[kUpDataRequiresThreeHivesIndex] = false
	},

	[kTechId.MetabolizeHealth] =
	{
		[kUpDataTeamIndex] = 2,
		[kUpDataRankIndex] = 6,
		[kUpDataCostIndex] = 1,
		[kUpDataHardCapIndex] = 0,
		[kUpDataConsoleNameIndex] = "advmeta",
		[kUpDataCategoryIndex] = "Ability",
		[kUpDataPersistIndex] = true,
		[kUpDataPassiveIndex] = false,
		[kUpDataMutuallyExclusiveIndex] = { },
		[kUpDataRequiresGestation] = false
	},

	[kTechId.Stab] =
	{
		[kUpDataTeamIndex] = 2,
		[kUpDataRankIndex] = 7,
		[kUpDataCostIndex] = 1,
		[kUpDataHardCapIndex] = 0,
		[kUpDataConsoleNameIndex] = "advmeta",
		[kUpDataCategoryIndex] = "Ability",
		[kUpDataPersistIndex] = true,
		[kUpDataPassiveIndex] = false,
		[kUpDataMutuallyExclusiveIndex] = { },
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
		[kUpDataTeamIndex] = 2,
		[kUpDataRankIndex] = 6,
		[kUpDataCostIndex] = 1,
		[kUpDataHardCapIndex] = 0,
		[kUpDataConsoleNameIndex] = "charge",
		[kUpDataCategoryIndex] = "Ability",
		[kUpDataPersistIndex] = true,
		[kUpDataPassiveIndex] = false,
		[kUpDataMutuallyExclusiveIndex] = { },
		[kUpDataRequiresGestation] = false,
		[kUpDataRequiresOneHiveIndex] = true,
		[kUpDataRequiresTwoHivesIndex] = false,
		[kUpDataRequiresThreeHivesIndex] = false
	},

	[kTechId.BoneShield] =
	{
		[kUpDataTeamIndex] = 2,
		[kUpDataRankIndex] = 7,
		[kUpDataCostIndex] = 1,
		[kUpDataHardCapIndex] = 0,
		[kUpDataConsoleNameIndex] = "boneshield",
		[kUpDataCategoryIndex] = "Ability",
		[kUpDataPersistIndex] = true,
		[kUpDataPassiveIndex] = false,
		[kUpDataMutuallyExclusiveIndex] = { },
		[kUpDataRequiresGestation] = false,
		[kUpDataRequiresOneHiveIndex] = true,
		[kUpDataRequiresTwoHivesIndex] = true,
		[kUpDataRequiresThreeHivesIndex] = false
	},

	[kTechId.Stomp] =
	{
		[kUpDataTeamIndex] = 2,
		[kUpDataRankIndex] = 8,
		[kUpDataCostIndex] = 1,
		[kUpDataHardCapIndex] = 0,
		[kUpDataConsoleNameIndex] = "stomp",
		[kUpDataCategoryIndex] = "Ability",
		[kUpDataPersistIndex] = true,
		[kUpDataPassiveIndex] = false,
		[kUpDataMutuallyExclusiveIndex] = { },
		[kUpDataRequiresGestation] = false,
		[kUpDataRequiresOneHiveIndex] = true,
		[kUpDataRequiresTwoHivesIndex] = true,
		[kUpDataRequiresThreeHivesIndex] = true
	}
}

function LookupUpgradeData(techId, index)

	assert(techId)
	assert(index)

	return kCombatUpgradeData[techId][index]

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

if Client then

	function PrecacheUpgradeTextures()

		for techId, values in ipairs(kCombatUpgradeData) do

			if values[kUpDataIconTextureIndex] then
				PrecacheAsset(values[kUpDataIconTextureIndex])
			end

		end

	end

end
