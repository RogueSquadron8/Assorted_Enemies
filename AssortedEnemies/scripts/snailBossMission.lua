Mission_SnailBoss = Mission_Boss:new{
    BossPawn = "AE_SnailBoss", -- Must kill the slug to get the reward, not just the snail
    GlobalSpawnMod = 0,
    SpawnStartMod = -1,
    SpawnMod = 0,
    BossText = "Destroy the Snail Leader",
}

_G[111] = Mission_SnailBoss
IslandLocks[111] = 2

-- Ensures that the objective is not completed until both the snail and the slug are dead
function Mission_SnailBoss:IsBossDead()
    for _, id in ipairs(extract_table(Board:GetPawns(TEAM_ENEMY))) do
        if Board:GetPawn(id):GetType() == "AE_SnailBoss" or Board:GetPawn(id):GetType() == "AE_SlugBoss" then
            return false
        end
	end
	return true
end