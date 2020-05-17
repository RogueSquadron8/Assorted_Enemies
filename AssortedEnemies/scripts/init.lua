local AE_modApiExt

local function init(self)
	local extDir = self.scriptPath .."modApiExt/"
	AE_modApiExt = require(extDir .."modApiExt")
	AE_modApiExt:init(extDir)

	-- Snail images
	modApi:appendAsset("img/weapons/enemy_snail1.png",self.resourcePath.."img/weapons/enemy_snail1.png")
	modApi:appendAsset("img/weapons/enemy_snail2.png",self.resourcePath.."img/weapons/enemy_snail2.png")
	modApi:appendAsset("img/effects/snail1_projectile_R.png",self.resourcePath.."img/effects/snail1_projectile_R.png")
	modApi:appendAsset("img/effects/snail2_projectile_R.png",self.resourcePath.."img/effects/snail2_projectile_R.png")
	modApi:appendAsset("img/effects/snail1_projectile_U.png",self.resourcePath.."img/effects/snail1_projectile_U.png")
	modApi:appendAsset("img/effects/snail2_projectile_U.png",self.resourcePath.."img/effects/snail2_projectile_U.png")
	modApi:appendAsset("img/combat/icons/icon_shell.png",self.resourcePath.."img/icons/icon_shell.png")
	modApi:appendAsset("img/combat/icons/icon_shell_glow.png",self.resourcePath.."img/icons/icon_shell_glow.png")
	modApi:appendAsset("img/portraits/enemy/Slug1.png",self.resourcePath.."img/portraits/enemy/Slug1.png")
	modApi:appendAsset("img/portraits/enemy/Snail1.png",self.resourcePath.."img/portraits/enemy/Snail1.png")
	modApi:appendAsset("img/portraits/enemy/Slug2.png",self.resourcePath.."img/portraits/enemy/Slug2.png")
	modApi:appendAsset("img/portraits/enemy/Snail2.png",self.resourcePath.."img/portraits/enemy/Snail2.png")

	-- Snail scripts
	require(self.scriptPath.."snailWeapons")
	require(self.scriptPath.."snail")
	require(self.scriptPath.."spawners")
	
end

local function load(self, options, version)
	AE_modApiExt:load(self, options, version)
	require(self.scriptPath.."libs/trait"):load()
	
	local SnailHooks = require(self.scriptPath.."snail")
	modApi:addMissionEndHook(SnailHooks.SnailMissionEndHook)
	AE_modApiExt:addPawnKilledHook(SnailHooks.SnailPawnKilledHook)
end

return {
	id = "AssortedEnemies",
    name = "Assorted Enemies",
    description = "Adds extra enemies to the game.",
	version = "0.5.1.3",
	requirements = {},
	icon = "img/icons/AE_icon.png",
	init = init,
	load = load,
}