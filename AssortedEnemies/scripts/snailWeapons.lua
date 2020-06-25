SnailAtk1 = Skill:new{
    Name = "Piercing Venom",
    Description = "Fire a peircing glob of venom. Cannot penetrate mountains.",
    Icon = "weapons/enemy_snail1.png",
    Class = "Enemy",
    Range = RANGE_PROJECTILE,
    Damage = 1,
    Pierce = 1,
    Explosion = "ExploFirefly1",
	ImpactSound = "/impact/dynamic/enemy_projectile",
	Projectile = "effects/snail1_projectile",
	TipImage = {
		Unit = Point(2,3),
		Enemy = Point(2,1),
		Building = Point(2,0),
		Target = Point(2,2),
		CustomPawn = "AE_Snail1"
	}
}

function SnailAtk1:GetSkillEffect(p1,p2)
	local ret = SkillEffect()
	local direction = GetDirection(p2 - p1)
			
	local target = GetProjectileEnd(p1,p2)  
    
    ret:AddQueuedProjectile(SpaceDamage(target, self.Damage),self.Projectile)
	
	local hitMountain = Board:GetTerrain(target) == TERRAIN_MOUNTAIN
    for i = 1, self.Pierce do 
		local newTarget = Point(target + DIR_VECTORS[direction]*i)
		if not hitMountain then										--Don't let pierce go through mountains
			ret:AddQueuedDamage(SpaceDamage(newTarget, self.Damage))
		end
		hitMountain = Board:IsValid(newTarget) and Board:GetTerrain(newTarget) == TERRAIN_MOUNTAIN
	end
	
	return ret
end

SnailAtk2 = SnailAtk1:new{
	Name = "Penetrating Venom",
	Icon = "weapons/enemy_snail2.png",
	Damage = 3,
	Projectile = "effects/snail2_projectile",
	TipImage = {
		Unit = Point(2,3),
		Enemy = Point(2,1),
		Building = Point(2,0),
		Target = Point(2,2),
		CustomPawn = "AE_Snail2"
	}
}

SlugAtk1 = SnailAtk1:new{
	TipImage = {
		Unit = Point(2,3),
		Enemy = Point(2,1),
		Building = Point(2,0),
		Target = Point(2,2),
		CustomPawn = "AE_Slug1"
	}
}

SlugAtk2 = SnailAtk2:new{
	TipImage = {
		Unit = Point(2,3),
		Enemy = Point(2,1),
		Building = Point(2,0),
		Target = Point(2,2),
		CustomPawn = "AE_Slug2"
	}
}

SnailAtkB = Skill:new{
	Name = "Puncturing Venom",
    Description = "Fire a glob of venom that keeps traveling after the first hit. Cannot penetrate mountains.",
    Icon = "weapons/enemy_snailB.png",
    Class = "Enemy",
    Range = RANGE_PROJECTILE,
    Damage = 5,
    Pierce = 1,
    Explosion = "ExploFirefly1",
	ImpactSound = "/impact/dynamic/enemy_projectile",
	Projectile = "effects/snailB_projectile",
	TipImage = {
		Unit = Point(2,0),
		Enemy = Point(2,2),
		Building = Point(2,4),
		Target = Point(2,1),
		CustomPawn = "AE_SnailBoss"
	}
}

-- Note: the snail boss will currently kill friendly units in order to attack a target behind them
-- BUG: pierce does not update when you move a unit to block (Cannot replicate)
function SnailAtkB:GetSkillEffect(p1,p2)
	local ret = SkillEffect()
	local dir = GetDirection(p2 - p1)
	local p = p2	-- This variable is used to find the end of the projectile's path
	local pierces = self.Pierce + 1

	-- Iterate over each tile along the path of the projectile until we find where it will need to stop
	while Board:IsValid(p) and (pierces > 0) and not (Board:GetTerrain(p) == TERRAIN_MOUNTAIN) do
		if Board:IsBuilding(p) or Board:IsPawnSpace(p) then
			pierces = pierces - 1
		end
		p = p + DIR_VECTORS[dir]
	end
	-- Make sure that the pierce does not go too far due to the order of checking pierces and moving p
	-- If the max number of pierces has occured and p ends on a mountain, need to make sure p is moved back
	-- Otherwise, if p ends on a mountain, it does not need ot be moved
	if (not (Board:GetTerrain(p) == TERRAIN_MOUNTAIN)) or pierces == 0 then
		p = p - DIR_VECTORS[dir]
	end
	
	local projectileDamage = SpaceDamage(p, self.Damage)
	ret:AddQueuedProjectile(projectileDamage, self.Projectile, NO_DELAY)
	
	local damage
	local target = p1 + DIR_VECTORS[dir]
	while target ~= p do 
		ret:AddQueuedDelay(0.1)
		damage = SpaceDamage(target,self.Damage)
		damage.sAnimation = self.Explosion
		damage.sSound = self.ImpactSound
		if Board:IsPawnSpace(target) or Board:IsBuilding(target) or Board:GetTerrain(target) == TERRAIN_MOUNTAIN then
			ret:AddQueuedDamage(damage)
		end
		target = target + DIR_VECTORS[dir]
	end
	
	return ret
end

SlugAtkB = SnailAtkB:new{
	TipImage = {
		Unit = Point(2,0),
		Enemy = Point(2,2),
		Building = Point(2,4),
		Target = Point(2,1),
		CustomPawn = "AE_SlugBoss"
	}
}