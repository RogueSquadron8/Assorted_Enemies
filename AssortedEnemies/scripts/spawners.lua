local this = {}

function this:load(options)
    -- Snails
    if options["opt_Snails"].enabled then 
        table.insert(EnemyLists.Unique, "AE_Snail")
        IslandLocks.Snail = 1
        Spawner.max_pawns.Snail = 2
    end
    -- Snail Boss    
    if options["opt_SnailBoss"].enabled then
        table.insert(Corp_Default.Bosses, 111)
        if options["opt_FinalMissionBosses"].enabled then
            table.insert(Mission_Final.BossList, "AE_SnailBoss")
            table.insert(Mission_Final_Cave.BossList, "AE_SnailBoss")
        end
    end
end

return this