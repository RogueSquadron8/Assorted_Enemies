local AE_modApiExt

local function init(self)
	local extDir = self.scriptPath .."modApiExt/"
	AE_modApiExt = require(extDir .."modApiExt")
	AE_modApiExt:init(extDir)

	require(self.scriptPath.."FURL")(self, {
		{
			Type = "enemy",
			Name = "SlugAnim",
			Filename = "slug",
			Path = "img/units/aliens", 
			ResourcePath = "units/aliens",
			Height = 3,
			Default =           { PosX = -23, PosY = 2 },
			Animated =          { PosX = -23, PosY = 2, NumFrames = 8 },
			Submerged =         { PosX = -17, PosY = -4 },
			Emerge =            { PosX = -24, PosY = 3, NumFrames = 10 },--needed for retreat animation
			Death =             { PosX = -24, PosY = 3, NumFrames = 8 },
		},
		{
			Type = "enemy",
			Name = "SnailAnim",
			Filename = "snail",
			Path = "img/units/aliens", 
			ResourcePath = "units/aliens",
			Height = 3,
			Default =           { PosX = -24, PosY = 3 },
			Animated =          { PosX = -24, PosY = 3, NumFrames = 4 },
			Submerged =         { PosX = -17, PosY = -4 },
			Emerge =            { PosX = -24, PosY = 3, NumFrames = 10 },
			Death =             { PosX = -24, PosY = 3, NumFrames = 13 },
		},
		{
			Type = "anim",
			Filename = "SnailEmerge_Normal",
			Path = "img/effects", 
			ResourcePath = "effects",
			
			Name = "SnailEmerge_Normal",
			Base = "Animation",
			
				NumFrames = 10,
				Loop = false,
				PosX = -24,
				PosY = 3,
				Time = 0.2
		},		
		{
			Type = "anim",
			Filename = "SnailEmerge_Alpha",
			Path = "img/effects", 
			ResourcePath = "effects",
			
			Name = "SnailEmerge_Alpha",
			Base = "Animation",
			
				NumFrames = 10,
				Loop = false,
				PosX = -24,
				PosY = 3,
				Time = 0.2
		}	
	});

	modApi:appendAsset("img/weapons/enemy_snail1.png",self.resourcePath.."img/weapons/enemy_snail1.png")
	modApi:appendAsset("img/weapons/enemy_snail2.png",self.resourcePath.."img/weapons/enemy_snail2.png")
	modApi:appendAsset("img/effects/snail1_projectile_R.png",self.resourcePath.."img/effects/snail1_projectile_R.png")
	modApi:appendAsset("img/effects/snail2_projectile_R.png",self.resourcePath.."img/effects/snail2_projectile_R.png")
	modApi:appendAsset("img/effects/snail1_projectile_U.png",self.resourcePath.."img/effects/snail1_projectile_U.png")
	modApi:appendAsset("img/effects/snail2_projectile_U.png",self.resourcePath.."img/effects/snail2_projectile_U.png")
	modApi:appendAsset("img/combat/icons/icon_shell.png",self.resourcePath.."img/icons/icon_shell.png")
	modApi:appendAsset("img/combat/icons/icon_shell_glow.png",self.resourcePath.."img/icons/icon_shell_glow.png")

	require(self.scriptPath.."snailWeapons")
	require(self.scriptPath.."snail")
	require(self.scriptPath.."spawners")
	
end

local function load(self, options, version)
	AE_modApiExt:load(self, options, version)
	require(self.scriptPath.."libs/trait"):load()
	-- Hook to simulate snails fleeing
	local SnailHooks = require(self.scriptPath.."snail")
	modApi:addMissionEndHook(SnailHooks.SnailMissionEndHook)
end

return {
	id = "AssortedEnemies",
    name = "Assorted Enemies",
    description = "Adds extra enemies to the game.",
	version = "0.5.0",
	requirements = {},
	icon = "img/icons/AE_icon.png",
	init = init,
	load = load,
}