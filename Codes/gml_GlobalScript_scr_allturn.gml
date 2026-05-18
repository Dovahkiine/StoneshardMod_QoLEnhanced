function scr_allturn(argument0)
{
    if (argument0 == undefined) argument0 = global.TurnDelay;

    global.chain_lightning_count = 0;
    global.wizzard_turn = false;
    global.free_turn_consumed = false; // 每次进入 scr_allturn 都重置免费回合消费标记，确保每个回合都能正确处理免费回合逻辑
    with (o_player) {
        if(scr_chance_value(100 - 100 * power(0.975, AGL - 10)))
            global.got_free_turn++;
    }

    
    if (global.got_free_turn > 0)
    {
        // 巫师天赋：免费回合（仅限玩家回合，敌人回合不受影响）
        // 通过 got_free_turn 计数实现多层免费回合叠加，直到下一次玩家回合结束才重置
        global.got_free_turn--;
        global.free_turn_consumed = true; // 标记本回合的免费回合已被消费，防止重复递减 got_free_turn

        with (o_player)
        {
            alarm[1] = -1;
            alarm[4] = -1;
            lock_movement = false;

            with (o_skill)
                last_activated = false;
        }

        exit;   // 直接跳过 scr_global_turn()，不推进任何回合相关的逻辑（buff/CD/状态等都不变）
    }

    scr_global_turn();

    with (o_player) {
        if (path && argument0 > 1) argument0 = 4;
        alarm[1] = argument0;
        lock_movement = true;
    }
}