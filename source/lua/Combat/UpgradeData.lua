Script.Load("lua/TechTreeConstants.lua")

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

-- Index used to retrieve a table of tech ids that indicate other upgrades that are
-- mutually exclusive to the upgrade indicated
kUpDataMutuallyExclusiveIndex = "mutuallyExclusive"

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
		[kUpDataMutuallyExclusiveIndex] = { }
	},

	[kTechId.Jetpack] =
	{
		[kUpDataTeamIndex] = 1,
		[kUpDataRankIndex] = 9,
		[kUpDataCostIndex] = 2,
		[kUpDataHardCapIndex] = 0,
		[kUpDataConsoleNameIndex] = "jp",
		[kUpDataCategoryIndex] = "Tech",
		[kUpDataPersistIndex] = false,
		[kUpDataMutuallyExclusiveIndex] = { }
	},

	[kTechId.DualMinigunExosuit] =
	{
		[kUpDataTeamIndex] = 1,
		[kUpDataRankIndex] = 10,
		[kUpDataCostIndex] = 2,
		[kUpDataHardCapIndex] = 1/3,
		[kUpDataConsoleNameIndex] = "minigunexo",
		[kUpDataCategoryIndex] = "Tech",
		[kUpDataDescIndex] = "An armored exosuit with a minigun equipped to each arm.",
		[kUpDataPersistIndex] = false,
		[kUpDataMutuallyExclusiveIndex] = { kTechId.DualRailgunExosuit }
	},

	[kTechId.DualRailgunExosuit] =
	{
		[kUpDataTeamIndex] = 1,
		[kUpDataRankIndex] = 10,
		[kUpDataCostIndex] = 2,
		[kUpDataHardCapIndex] = 1/3,
		[kUpDataConsoleNameIndex] = "railgunexo",
		[kUpDataCategoryIndex] = "Tech",
		[kUpDataDescIndex] = "An armored exosuit with a railgun equipped to each arm.",
		[kUpDataPersistIndex] = false,
		[kUpDataMutuallyExclusiveIndex] = { kTechId.DualMinigunExosuit }
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
		[kUpDataMutuallyExclusiveIndex] = { }
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
		[kUpDataMutuallyExclusiveIndex] = { kTechId.Shotgun, kTechId.Flamethrower, kTechId.GrenadeLauncher, kTechId.HeavyMachineGun }
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
		[kUpDataMutuallyExclusiveIndex] = { kTechId.Rifle, kTechId.Flamethrower, kTechId.GrenadeLauncher, kTechId.HeavyMachineGun }
	},

	[kTechId.Flamethrower] =
	{
		[kUpDataTeamIndex] = 1,
		[kUpDataRankIndex] = 6,
		[kUpDataCostIndex] = 1,
		[kUpDataHardCapIndex] = 1/2,
		[kUpDataConsoleNameIndex] = "flamethrower",
		[kUpDataCategoryIndex] = "Weapon",
		[kUpDataPersistIndex] = false,
		[kUpDataMutuallyExclusiveIndex] = { kTechId.Rifle, kTechId.Shotgun, kTechId.GrenadeLauncher, kTechId.HeavyMachineGun }
	},

	[kTechId.GrenadeLauncher] =
	{
		[kUpDataTeamIndex] = 1,
		[kUpDataRankIndex] = 7,
		[kUpDataCostIndex] = 2,
		[kUpDataHardCapIndex] = 1/2,
		[kUpDataConsoleNameIndex] = "gl",
		[kUpDataCategoryIndex] = "Weapon",
		[kUpDataPersistIndex] = false,
		[kUpDataMutuallyExclusiveIndex] = { kTechId.Rifle, kTechId.Shotgun, kTechId.Flamethrower, kTechId.HeavyMachineGun }
	},

	[kTechId.HeavyMachineGun] =
	{
		[kUpDataTeamIndex] = 1,
		[kUpDataRankIndex] = 8,
		[kUpDataCostIndex] = 2,
		[kUpDataHardCapIndex] = 1/2,
		[kUpDataConsoleNameIndex] = "hmg",
		[kUpDataCategoryIndex] = "Weapon",
		[kUpDataPersistIndex] = false,
		[kUpDataMutuallyExclusiveIndex] = { kTechId.Rifle, kTechId.Shotgun, kTechId.Flamethrower, kTechId.GrenadeLauncher }
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
		[kUpDataMutuallyExclusiveIndex] = { }
	},

	[kTechId.LayMines] =
	{
		[kUpDataTeamIndex] = 1,
		[kUpDataRankIndex] = 5,
		[kUpDataCostIndex] = 1,
		[kUpDataHardCapIndex] = 0,
		[kUpDataConsoleNameIndex] = "mines",
		[kUpDataCategoryIndex] = "Tech",
		[kUpDataPersistIndex] = false,
		[kUpDataMutuallyExclusiveIndex] = { }
	},

	[kTechId.ClusterGrenade] =
	{
		[kUpDataTeamIndex] = 1,
		[kUpDataRankIndex] = 6,
		[kUpDataCostIndex] = 1,
		[kUpDataHardCapIndex] = 0,
		[kUpDataConsoleNameIndex] = "clustergrenade",
		[kUpDataCategoryIndex] = "Tech",
		[kUpDataPersistIndex] = true,
		[kUpDataMutuallyExclusiveIndex] = { kTechId.GasGrenade, kTechId.PulseGrenade }
	},

	[kTechId.GasGrenade] =
	{
		[kUpDataTeamIndex] = 1,
		[kUpDataRankIndex] = 6,
		[kUpDataCostIndex] = 1,
		[kUpDataHardCapIndex] = 0,
		[kUpDataConsoleNameIndex] = "gasgrenade",
		[kUpDataCategoryIndex] = "Tech",
		[kUpDataPersistIndex] = true,
		[kUpDataMutuallyExclusiveIndex] = { kTechId.ClusterGrenade, kTechId.PulseGrenade }
	},

	[kTechId.PulseGrenade] =
	{
		[kUpDataTeamIndex] = 1,
		[kUpDataRankIndex] = 6,
		[kUpDataCostIndex] = 1,
		[kUpDataHardCapIndex] = 0,
		[kUpDataConsoleNameIndex] = "pulsegrenade",
		[kUpDataCategoryIndex] = "Tech",
		[kUpDataPersistIndex] = true,
		[kUpDataMutuallyExclusiveIndex] = { kTechId.ClusterGrenade, kTechId.GasGrenade }
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
		[kUpDataMutuallyExclusiveIndex] = { }
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
		[kUpDataMutuallyExclusiveIndex] = { }
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
		[kUpDataMutuallyExclusiveIndex] = { }
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
		[kUpDataMutuallyExclusiveIndex] = { }
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
		[kUpDataMutuallyExclusiveIndex] = { }
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
		[kUpDataMutuallyExclusiveIndex] = { }
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
		[kUpDataMutuallyExclusiveIndex] = { }
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
		[kUpDataMutuallyExclusiveIndex] = { }
	},

	[kTechId.CatPack] =
	{
		[kUpDataTeamIndex] = 1,
		[kUpDataRankIndex] = 7,
		[kUpDataCostIndex] = 1,
		[kUpDataHardCapIndex] = 0,
		[kUpDataConsoleNameIndex] = "catpack",
		[kUpDataCategoryIndex] = "Consumable",
		[kUpDataDescIndex] = "A pack that increases Marine movement and speed for a limited time.  Can be reused every time the cooldown expires.",
		[kUpDataPersistIndex] = true,
		[kUpDataMutuallyExclusiveIndex] = { }
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
		[kUpDataMutuallyExclusiveIndex] = { }
	},

	[kTechId.Armory] =
	{
		[kUpDataTeamIndex] = 1,
		[kUpDataRankIndex] = 3,
		[kUpDataCostIndex] = 1,
		[kUpDataHardCapIndex] = 0,
		[kUpDataConsoleNameIndex] = "armory",
		[kUpDataCategoryIndex] = "Structures",
		[kUpDataPersistIndex] = true,
		[kUpDataMutuallyExclusiveIndex] = { }
	},

	[kTechId.PhaseGate] =
	{
		[kUpDataTeamIndex] = 1,
		[kUpDataRankIndex] = 4,
		[kUpDataCostIndex] = 1,
		[kUpDataHardCapIndex] = 0,
		[kUpDataConsoleNameIndex] = "phasegate",
		[kUpDataCategoryIndex] = "Structures",
		[kUpDataPersistIndex] = true,
		[kUpDataMutuallyExclusiveIndex] = { }
	},

	[kTechId.Observatory] =
	{
		[kUpDataTeamIndex] = 1,
		[kUpDataRankIndex] = 5,
		[kUpDataCostIndex] = 2,
		[kUpDataHardCapIndex] = 0,
		[kUpDataConsoleNameIndex] = "observatory",
		[kUpDataCategoryIndex] = "Structures",
		[kUpDataPersistIndex] = true,
		[kUpDataMutuallyExclusiveIndex] = { }
	},

	[kTechId.Sentry] =
	{
		[kUpDataTeamIndex] = 1,
		[kUpDataRankIndex] = 6,
		[kUpDataCostIndex] = 1,
		[kUpDataHardCapIndex] = 0,
		[kUpDataConsoleNameIndex] = "sentry",
		[kUpDataCategoryIndex] = "Structures",
		[kUpDataDescIndex] = "An AI torrent that fires on enemy units.  Requires an active power node for the area it is located.",
		[kUpDataPersistIndex] = true,
		[kUpDataMutuallyExclusiveIndex] = { }
	},

	[kTechId.Skulk] =
	{
		[kUpDataTeamIndex] = 2,
		[kUpDataRankIndex] = 1,
		[kUpDataCostIndex] = 1,
		[kUpDataHardCapIndex] = 0,
		[kUpDataConsoleNameIndex] = "skulk",
		[kUpDataCategoryIndex] = "Lifeforms",
		[kUpDataPersistIndex] = false,
		[kUpDataMutuallyExclusiveIndex] = { kTechId.Gorge, kTechId.Lerk, kTechId.Fade, kTechId.Onos }
	},

	[kTechId.Gorge] =
	{
		[kUpDataTeamIndex] = 2,
		[kUpDataRankIndex] = 1,
		[kUpDataCostIndex] = 1,
		[kUpDataHardCapIndex] = 0,
		[kUpDataConsoleNameIndex] = "gorge",
		[kUpDataCategoryIndex] = "Lifeforms",
		[kUpDataPersistIndex] = false,
		[kUpDataMutuallyExclusiveIndex] = { kTechId.Skulk, kTechId.Lerk, kTechId.Fade, kTechId.Onos }
	},

	[kTechId.Lerk] =
	{
		[kUpDataTeamIndex] = 2,
		[kUpDataRankIndex] = 3,
		[kUpDataCostIndex] = 1,
		[kUpDataHardCapIndex] = 0,
		[kUpDataConsoleNameIndex] = "lerk",
		[kUpDataCategoryIndex] = "Lifeforms",
		[kUpDataPersistIndex] = false,
		[kUpDataMutuallyExclusiveIndex] = { kTechId.Skulk, kTechId.Gorge, kTechId.Fade, kTechId.Onos }
	},

	[kTechId.Fade] =
	{
		[kUpDataTeamIndex] = 2,
		[kUpDataRankIndex] = 6,
		[kUpDataCostIndex] = 2,
		[kUpDataHardCapIndex] = 0,
		[kUpDataConsoleNameIndex] = "fade",
		[kUpDataCategoryIndex] = "Lifeforms",
		[kUpDataPersistIndex] = false,
		[kUpDataMutuallyExclusiveIndex] = { kTechId.Skulk, kTechId.Gorge, kTechId.Lerk, kTechId.Onos }
	},

	[kTechId.Onos] =
	{
		[kUpDataTeamIndex] = 2,
		[kUpDataRankIndex] = 9,
		[kUpDataCostIndex] = 2,
		[kUpDataHardCapIndex] = 0,
		[kUpDataConsoleNameIndex] = "onos",
		[kUpDataCategoryIndex] = "Lifeforms",
		[kUpDataPersistIndex] = false,
		[kUpDataMutuallyExclusiveIndex] = { kTechId.Skulk, kTechId.Gorge, kTechId.Lerk, kTechId.Fade }
	},

	[kTechId.Spur] =
	{
		[kUpDataTeamIndex] = 2,
		[kUpDataRankIndex] = 2,
		[kUpDataCostIndex] = 1,
		[kUpDataHardCapIndex] = 0,
		[kUpDataConsoleNameIndex] = "spur",
		[kUpDataCategoryIndex] = "Upgrades",
		[kUpDataPersistIndex] = true,
		[kUpDataMutuallyExclusiveIndex] = { }
	},

	[kTechId.Veil] =
	{
		[kUpDataTeamIndex] = 2,
		[kUpDataRankIndex] = 2,
		[kUpDataCostIndex] = 1,
		[kUpDataHardCapIndex] = 0,
		[kUpDataConsoleNameIndex] = "veil",
		[kUpDataCategoryIndex] = "Upgrades",
		[kUpDataPersistIndex] = true,
		[kUpDataMutuallyExclusiveIndex] = { }
	},

	[kTechId.Shell] =
	{
		[kUpDataTeamIndex] = 2,
		[kUpDataRankIndex] = 2,
		[kUpDataCostIndex] = 1,
		[kUpDataHardCapIndex] = 0,
		[kUpDataConsoleNameIndex] = "shell",
		[kUpDataCategoryIndex] = "Upgrades",
		[kUpDataPersistIndex] = true,
		[kUpDataMutuallyExclusiveIndex] = { }
	},

	[kTechId.Adrenaline] =
	{
		[kUpDataTeamIndex] = 2,
		[kUpDataRankIndex] = 2,
		[kUpDataCostIndex] = 1,
		[kUpDataHardCapIndex] = 0,
		[kUpDataConsoleNameIndex] = "adrenaline",
		[kUpDataCategoryIndex] = "Upgrades",
		[kUpDataPersistIndex] = false,
		[kUpDataMutuallyExclusiveIndex] = { kTechId.Celerity, kTechId.Silence }
	},

	[kTechId.Celerity] =
	{
		[kUpDataTeamIndex] = 2,
		[kUpDataRankIndex] = 2,
		[kUpDataCostIndex] = 1,
		[kUpDataHardCapIndex] = 0,
		[kUpDataConsoleNameIndex] = "celerity",
		[kUpDataCategoryIndex] = "Upgrades",
		[kUpDataPersistIndex] = false,
		[kUpDataMutuallyExclusiveIndex] = { kTechId.Adrenaline, kTechId.Silence }
	},

	[kTechId.Silence] =
	{
		[kUpDataTeamIndex] = 2,
		[kUpDataRankIndex] = 2,
		[kUpDataCostIndex] = 1,
		[kUpDataHardCapIndex] = 0,
		[kUpDataConsoleNameIndex] = "silence",
		[kUpDataCategoryIndex] = "Upgrades",
		[kUpDataPersistIndex] = false,
		[kUpDataMutuallyExclusiveIndex] = { kTechId.Adrenaline, kTechId.Celerity }
	},

	[kTechId.Aura] =
	{
		[kUpDataTeamIndex] = 2,
		[kUpDataRankIndex] = 2,
		[kUpDataCostIndex] = 1,
		[kUpDataHardCapIndex] = 0,
		[kUpDataConsoleNameIndex] = "aura",
		[kUpDataCategoryIndex] = "Upgrades",
		[kUpDataPersistIndex] = false,
		[kUpDataMutuallyExclusiveIndex] = { kTechId.Focus, kTechId.Vampirism }
	},

	[kTechId.Focus] =
	{
		[kUpDataTeamIndex] = 2,
		[kUpDataRankIndex] = 2,
		[kUpDataCostIndex] = 1,
		[kUpDataHardCapIndex] = 0,
		[kUpDataConsoleNameIndex] = "focus",
		[kUpDataCategoryIndex] = "Upgrades",
		[kUpDataPersistIndex] = false,
		[kUpDataMutuallyExclusiveIndex] = { kTechId.Aura, kTechId.Vampirism }
	},

	[kTechId.Vampirism] =
	{
		[kUpDataTeamIndex] = 2,
		[kUpDataRankIndex] = 2,
		[kUpDataCostIndex] = 1,
		[kUpDataHardCapIndex] = 0,
		[kUpDataConsoleNameIndex] = "vampirism",
		[kUpDataCategoryIndex] = "Upgrades",
		[kUpDataPersistIndex] = false,
		[kUpDataMutuallyExclusiveIndex] = { kTechId.Aura, kTechId.Focus }
	},

	[kTechId.Regeneration] =
	{
		[kUpDataTeamIndex] = 2,
		[kUpDataRankIndex] = 2,
		[kUpDataCostIndex] = 1,
		[kUpDataHardCapIndex] = 0,
		[kUpDataConsoleNameIndex] = "regeneration",
		[kUpDataCategoryIndex] = "Upgrades",
		[kUpDataPersistIndex] = false,
		[kUpDataMutuallyExclusiveIndex] = { kTechId.Carapace, kTechId.Crush }
	},

	[kTechId.Carapace] =
	{
		[kUpDataTeamIndex] = 2,
		[kUpDataRankIndex] = 2,
		[kUpDataCostIndex] = 1,
		[kUpDataHardCapIndex] = 0,
		[kUpDataConsoleNameIndex] = "carapace",
		[kUpDataCategoryIndex] = "Upgrades",
		[kUpDataPersistIndex] = false,
		[kUpDataMutuallyExclusiveIndex] = { kTechId.Regeneration, kTechId.Crush }
	},

	[kTechId.Crush] =
	{
		[kUpDataTeamIndex] = 2,
		[kUpDataRankIndex] = 2,
		[kUpDataCostIndex] = 1,
		[kUpDataHardCapIndex] = 0,
		[kUpDataConsoleNameIndex] = "crush",
		[kUpDataCategoryIndex] = "Upgrades",
		[kUpDataPersistIndex] = false,
		[kUpDataMutuallyExclusiveIndex] = { kTechId.Regeneration, kTechId.Carapace }
	},

	[kTechId.BileBomb] =
	{
		[kUpDataTeamIndex] = 2,
		[kUpDataRankIndex] = 4,
		[kUpDataCostIndex] = 1,
		[kUpDataHardCapIndex] = 0,
		[kUpDataConsoleNameIndex] = "bilebomb",
		[kUpDataCategoryIndex] = "Upgrades",
		[kUpDataPersistIndex] = true,
		[kUpDataMutuallyExclusiveIndex] = { }
	},

	[kTechId.Leap] =
	{
		[kUpDataTeamIndex] = 2,
		[kUpDataRankIndex] = 3,
		[kUpDataCostIndex] = 1,
		[kUpDataHardCapIndex] = 0,
		[kUpDataConsoleNameIndex] = "leap",
		[kUpDataCategoryIndex] = "Upgrades",
		[kUpDataPersistIndex] = true,
		[kUpDataMutuallyExclusiveIndex] = { }
	},

	[kTechId.Xenocide] =
	{
		[kUpDataTeamIndex] = 2,
		[kUpDataRankIndex] = 8,
		[kUpDataCostIndex] = 1,
		[kUpDataHardCapIndex] = 0,
		[kUpDataConsoleNameIndex] = "xenocide",
		[kUpDataCategoryIndex] = "Upgrades",
		[kUpDataPersistIndex] = true,
		[kUpDataMutuallyExclusiveIndex] = { }
	},

	[kTechId.Spores] =
	{
		[kUpDataTeamIndex] = 2,
		[kUpDataRankIndex] = 3,
		[kUpDataCostIndex] = 1,
		[kUpDataHardCapIndex] = 0,
		[kUpDataConsoleNameIndex] = "spores",
		[kUpDataCategoryIndex] = "Upgrades",
		[kUpDataPersistIndex] = true,
		[kUpDataMutuallyExclusiveIndex] = { }
	},

	[kTechId.Umbra] =
	{
		[kUpDataTeamIndex] = 2,
		[kUpDataRankIndex] = 6,
		[kUpDataCostIndex] = 1,
		[kUpDataHardCapIndex] = 0,
		[kUpDataConsoleNameIndex] = "umbra",
		[kUpDataCategoryIndex] = "Upgrades",
		[kUpDataPersistIndex] = true,
		[kUpDataMutuallyExclusiveIndex] = { }
	},

	[kTechId.MetabolizeEnergy] =
	{
		[kUpDataTeamIndex] = 2,
		[kUpDataRankIndex] = 6,
		[kUpDataCostIndex] = 1,
		[kUpDataHardCapIndex] = 0,
		[kUpDataConsoleNameIndex] = "meta",
		[kUpDataCategoryIndex] = "Upgrades",
		[kUpDataPersistIndex] = true,
		[kUpDataMutuallyExclusiveIndex] = { }
	},

	[kTechId.MetabolizeHealth] =
	{
		[kUpDataTeamIndex] = 2,
		[kUpDataRankIndex] = 7,
		[kUpDataCostIndex] = 1,
		[kUpDataHardCapIndex] = 0,
		[kUpDataConsoleNameIndex] = "advmeta",
		[kUpDataCategoryIndex] = "Upgrades",
		[kUpDataPersistIndex] = true,
		[kUpDataMutuallyExclusiveIndex] = { }
	},

	[kTechId.Stab] =
	{
		[kUpDataTeamIndex] = 2,
		[kUpDataRankIndex] = 7,
		[kUpDataCostIndex] = 1,
		[kUpDataHardCapIndex] = 0,
		[kUpDataConsoleNameIndex] = "advmeta",
		[kUpDataCategoryIndex] = "Upgrades",
		[kUpDataPersistIndex] = true,
		[kUpDataMutuallyExclusiveIndex] = { }
	},

	[kTechId.Charge] =
	{
		[kUpDataTeamIndex] = 2,
		[kUpDataRankIndex] = 9,
		[kUpDataCostIndex] = 1,
		[kUpDataHardCapIndex] = 0,
		[kUpDataConsoleNameIndex] = "charge",
		[kUpDataCategoryIndex] = "Upgrades",
		[kUpDataPersistIndex] = true,
		[kUpDataMutuallyExclusiveIndex] = { }
	},

	[kTechId.BoneShield] =
	{
		[kUpDataTeamIndex] = 2,
		[kUpDataRankIndex] = 10,
		[kUpDataCostIndex] = 1,
		[kUpDataHardCapIndex] = 0,
		[kUpDataConsoleNameIndex] = "boneshield",
		[kUpDataCategoryIndex] = "Upgrades",
		[kUpDataPersistIndex] = true,
		[kUpDataMutuallyExclusiveIndex] = { }
	},

	[kTechId.Stomp] =
	{
		[kUpDataTeamIndex] = 2,
		[kUpDataRankIndex] = 10,
		[kUpDataCostIndex] = 1,
		[kUpDataHardCapIndex] = 0,
		[kUpDataConsoleNameIndex] = "stomp",
		[kUpDataCategoryIndex] = "Upgrades",
		[kUpDataPersistIndex] = true,
		[kUpDataMutuallyExclusiveIndex] = { }
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
