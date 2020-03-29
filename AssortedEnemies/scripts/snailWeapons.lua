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
		CustomPawn = "Snail1"
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
		CustomPawn = "Snail2"
	}
}

SlugAtk1 = SnailAtk1:new{
	TipImage = {
		Unit = Point(2,3),
		Enemy = Point(2,1),
		Building = Point(2,0),
		Target = Point(2,2),
		CustomPawn = "Slug1"
	}
}

SlugAtk2 = SnailAtk2:new{
	TipImage = {
		Unit = Point(2,3),
		Enemy = Point(2,1),
		Building = Point(2,0),
		Target = Point(2,2),
		CustomPawn = "Slug2"
	}
}

--make boss slug's attack pierce as projectiles, so that objects several tiles behind the first target will still be hit