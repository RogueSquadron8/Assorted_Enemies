local mod = mod_loader.mods[modApi.currentMod]
local trait = require(mod.scriptPath .."libs/trait")

Snail1 = Pawn:new{
		Name = "Snail",
		Health = 2,
		MoveSpeed = 2,
		Image = "SnailAnim",
		SkillList = { "SnailAtk1" },
		SoundLocation = "/enemy/scorpion_soldier_1/",	--need to find good sounds
		DefaultTeam = TEAM_ENEMY,
		ImpactMaterial = IMPACT_INSECT,
		Tier = TIER_NORMAL,
		SecondForm = "Slug1",
		Minor = true,
	}

Snail2 = Snail1:new{
		Name = "Alpha Snail",
		Health = 4,
		MoveSpeed = 2,
		Image = "SnailAnim",
		ImageOffset = 1,
		SkillList = { "SnailAtk2" },
		SoundLocation = "/enemy/scorpion_soldier_1/",	--need to find good sounds
		DefaultTeam = TEAM_ENEMY,
		ImpactMaterial = IMPACT_INSECT,
		Tier = TIER_ALPHA,
		SecondForm = "Slug2",
		Minor = true,
	}

Slug1 =
	{
		Name = "Slug",
		Health = 1,
		MoveSpeed = 2,
		Image = "SlugAnim",
		SkillList = { "SlugAtk1" },
		SoundLocation = "/enemy/scorpion_soldier_1/",
		DefaultTeam = TEAM_ENEMY,
		ImpactMaterial = IMPACT_INSECT,
		Tier = TIER_NORMAL,
	}
AddPawn("Slug1")

Slug2 =
	{
		Name = "Alpha Slug",
		Health = 1,
		MoveSpeed = 2,
		Image = "SlugAnim",
		ImageOffset = 1,
		SkillList = { "SlugAtk2" },
		SoundLocation = "/enemy/scorpion_soldier_1/",
		DefaultTeam = TEAM_ENEMY,
		ImpactMaterial = IMPACT_INSECT,
		Tier = TIER_ALPHA,
	}
AddPawn("Slug2")

local function isSnail(pawn)
	return
		list_contains(_G[pawn:GetType()].SkillList, "SnailAtk1") or
		list_contains(_G[pawn:GetType()].SkillList, "SnailAtk2")
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
	PawnTypes = {"Snail1","Snail2"},
	Icon = {"img/combat/icons/icon_shell.png", Point(0,17)}, -- was (0,8)
	Description = {"Protective Shell", "This unit blocks damage with its shell, which must be destroyed before it can be killed."}
}

function Snail1:GetDeathEffect(p)
	local ret = SkillEffect()
	ret:AddDelay(.8)
	--if Board:isPawnSpace(p) then LOG("Space occupied") end
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
			else Board:AddAnimation(space,"SnailEmerge_Alpha",ANIM_REVERSE) end
		end
	end
end

return {SnailMissionEndHook = SnailMissionEndHook}