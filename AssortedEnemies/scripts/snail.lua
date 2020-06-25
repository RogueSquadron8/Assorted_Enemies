local mod = mod_loader.mods[modApi.currentMod]
local trait = require(mod.scriptPath .."libs/trait")
local sprites = require(mod.scriptPath .."libs/sprites")

sprites.addEnemyUnits({
	Name = "slug",
	Default =           { PosX = -23, PosY = 2 },
	Animated =          { PosX = -23, PosY = 2, NumFrames = 8 },
	Submerged =         { PosX = -22, PosY = 9 },
	Emerge =            { PosX = -24, PosY = 3, NumFrames = 10, Loop = false },--needed for retreat animation
	Death =             { PosX = -24, PosY = 3, NumFrames = 8, Loop = false, Time = 0.1}, -- too slow without Time
})
sprites.addEnemyUnits({
	Name = "snail",
	Default =           { PosX = -24, PosY = 3 },
	Animated =          { PosX = -24, PosY = 3, NumFrames = 4 },
	Submerged =         { PosX = -22, PosY = 9 },
	Emerge =            { PosX = -24, PosY = 3, NumFrames = 10, Loop = false },
	Death =             { PosX = -24, PosY = 3, NumFrames = 13, Loop = false, Time = 0.1},
})

snail_animSettings = {
	NumFrames = 10,
	Loop = false,
	PosX = -24,
	PosY = 3,
	Time = 0.2
}
-- These animations are used for mimicking a retreat; see SnailMissionEndHook
sprites.addAnimation("effects", "SnailEmerge_Normal", snail_animSettings)
sprites.addAnimation("effects", "SnailEmerge_Alpha", snail_animSettings)
sprites.addAnimation("effects", "SnailEmerge_Boss", snail_animSettings)

AE_Snail1 = Pawn:new{
		Name = "Snail",
		Health = 2,
		MoveSpeed = 2,
		Image = "snail",
		Portrait = "enemy/Snail1",
		SkillList = { "SnailAtk1" },
		SoundLocation = "/enemy/firefly_soldier_1/",
		DefaultTeam = TEAM_ENEMY,
		ImpactMaterial = IMPACT_FLESH,
		Tier = TIER_NORMAL,
		SecondForm = "AE_Slug1",
		Minor = true,
	}

AE_Snail2 = AE_Snail1:new{
		Name = "Alpha Snail",
		Health = 4,
		MoveSpeed = 2,
		ImageOffset = 1,
		Portrait = "enemy/Snail2",
		SkillList = { "SnailAtk2" },
		SoundLocation = "/enemy/firefly_soldier_1/",
		DefaultTeam = TEAM_ENEMY,
		ImpactMaterial = IMPACT_FLESH,
		Tier = TIER_ALPHA,
		SecondForm = "AE_Slug2",
		Minor = true,
	}

AE_SnailBoss = Pawn:new{
	Name = "Snail Leader",
	Health = 5,
	MoveSpeed = 2,
	Image = "snail",
	ImageOffset = 2,
	Portrait = "enemy/SnailB",
	SkillList = { "SnailAtkB" },
	SoundLocation = "/enemy/firefly_soldier_1/",
	DefaultTeam = TEAM_ENEMY,
	ImpactMaterial = IMPACT_FLESH,
	Tier = TIER_BOSS,
	SecondForm = "AE_SlugBoss",
	Minor = true,
	Massive = true,
}
-- Special version of the function for Boss
local function CanSpawn_B(p)
	return not (Board:IsBlocked(p,PATH_GROUND) or Board:GetTerrain(p) == TERRAIN_WATER
		 or Board:GetTerrain(p) == TERRAIN_LAVA or Board:GetTerrain(p) == TERRAIN_ACID)
end

function AE_SnailBoss:GetDeathEffect(p)
	local ret = SkillEffect()
	ret:AddDelay(.8)
	--if Board:isPawnSpace(p) then LOG("Space occupied") end
	if CanSpawn_B(p) then
		--LOG("Can spawn")
		ret:AddScript(string.format("local p = Point(%i, %i) Board:AddPawn(%q, p)", p.x, p.y, self.SecondForm))
	else
		ret:AddScript(string.format([[
			local p = Point(%i, %i) 
			local pawn = PAWN_FACTORY:CreatePawn(%q)
			Board:AddPawn(pawn, p)
			pawn:Kill(true)
			]], p.x, p.y, self.SecondForm))
	end
	return ret
end

AE_Slug1 = Pawn:new{
	Name = "Slug",
	Health = 1,
	MoveSpeed = 2,
	Image = "slug",
	Portrait = "enemy/Slug1",
	SkillList = { "SlugAtk1" },
	SoundLocation = "/enemy/centipede_1/",
	DefaultTeam = TEAM_ENEMY,
	ImpactMaterial = IMPACT_INSECT,
	Tier = TIER_NORMAL,
}

AE_Slug2 = Pawn:new{
	Name = "Alpha Slug",
	Health = 1,
	MoveSpeed = 2,
	Image = "slug",
	ImageOffset = 1,
	Portrait = "enemy/Slug2",
	SkillList = { "SlugAtk2" },
	SoundLocation = "/enemy/centipede_2/",
	DefaultTeam = TEAM_ENEMY,
	ImpactMaterial = IMPACT_INSECT,
	Tier = TIER_ALPHA,
}

AE_SlugBoss = Pawn:new{
	Name = "Slug Leader",
	Health = 1,
	MoveSpeed = 2,
	Image = "slug",
	ImageOffset = 2,
	Portrait = "enemy/SlugB",
	SkillList = { "SlugAtkB" },
	SoundLocation = "/enemy/centipede_2/",
	DefaultTeam = TEAM_ENEMY,
	ImpactMaterial = IMPACT_INSECT,
	Tier = TIER_BOSS,
	Massive = true,
}

local function isSnail(pawn)
	return
		list_contains(_G[pawn:GetType()].SkillList, "SnailAtk1") or
		list_contains(_G[pawn:GetType()].SkillList, "SnailAtk2") or
		list_contains(_G[pawn:GetType()].SkillList, "SnailAtkB")
end

local function isSnailNormal(pawn)
	return list_contains(_G[pawn:GetType()].SkillList, "SnailAtk1")
end

local function isSnailAlpha(pawn)
	return list_contains(_G[pawn:GetType()].SkillList, "SnailAtk2")
end

local function CanSpawn(p)
	return not Board:IsBlocked(p,PATH_GROUND) --***************For the boss snail, water should not count
	--[[		Old check
	not (Board:GetTerrain(p) == TERRAIN_WATER or Board:GetTerrain(p) == TERRAIN_LAVA or Board:GetTerrain(p) == TERRAIN_ACID
		or Board:GetTerrain(p) == TERRAIN_HOLE or Board:IsBlocked(p,PATH_GROUND)) and Board:IsValid(p)	]]
end

trait:Add{
	PawnTypes = {"AE_Snail1","AE_Snail2","AE_SnailBoss"},
	Icon = {"img/combat/icons/icon_shell.png", Point(0,17)}, -- was (0,8)
	Description = {"Protective Shell", "This unit blocks damage with its shell, which must be destroyed before it can be killed."}
}

function AE_Snail1:GetDeathEffect(p)
	local ret = SkillEffect()
	ret:AddDelay(.8)
	if CanSpawn(p) then
		--LOG("Can spawn")
		ret:AddScript(string.format("local p = Point(%i, %i) Board:AddPawn(%q, p)", p.x, p.y, self.SecondForm))
	else
		ret:AddScript(string.format([[
			local p = Point(%i, %i) 
			local pawn = PAWN_FACTORY:CreatePawn(%q)
			Board:AddPawn(pawn, p)
			pawn:Kill(true)
			]], p.x, p.y, self.SecondForm))
	end
	return ret
end

local path = mod_loader.mods[modApi.currentMod].scriptPath
-- Because snail is a minor enemy, it simply dies at the end of a mission. This hook makes
-- it look like the snail retreats instead
function SnailMissionEndHook(mission)
	local enemyIds = Board:GetPawns(TEAM_ENEMY)
	local pawn
	local space
	--LOG("Fired")
	for _, id in ipairs(extract_table(enemyIds)) do
		pawn = Board:GetPawn(id)
		space = pawn:GetSpace()
		if isSnail(pawn) and not pawn:IsFrozen() then
			pawn:SetInvisible(true)
			pawn:SetSpace(Point(-1,-1)) -- move it over here and forget about it
			if isSnailNormal(pawn) then Board:AddAnimation(space,"SnailEmerge_Normal",ANIM_REVERSE)
			else if isSnailAlpha(pawn) then Board:AddAnimation(space,"SnailEmerge_Alpha",ANIM_REVERSE)
			else Board:AddAnimation(space,"SnailEmerge_Boss",ANIM_REVERSE) end end
		end
	end
end
-- Makes sure that snails that are on fire pass the status on to their slug
function SnailPawnKilledHook(mission, pawn)
	local p = pawn:GetSpace()
	if pawn:IsSnail() and pawn:IsFire() and Board:IsValid(p) and not
			Board:GetTerrain(p) == TERRAIN_WATER or TERRAIN_LAVA or TERRAIN_ACID or TERRAIN_HOLE then
		Board:SetFire(p,true)
	end
end

return {SnailMissionEndHook = SnailMissionEndHook, SnailPawnKilledHook = SnailPawnKilledHook}