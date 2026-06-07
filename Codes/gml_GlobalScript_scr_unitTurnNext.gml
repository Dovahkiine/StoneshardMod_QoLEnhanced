function scr_unitTurnNext(argument0)
{
    if (argument0 == undefined) argument0 = 1;
    
    if (global.Upspeed)
        argument0 = 1;

    if (!global.free_turn_consumed)
    {
        with (o_player)
        {
            // 将原本的递归概率连动改为稳定累进：
            // 每次玩家行动后推进一次“敌方回合进度”，进度未满 1 则继续由玩家行动。
            global.agility_chain_turn += clamp(power(0.98, AGL - 10), 0, 1);
        }
    }
    
    if (!global.free_turn_consumed && global.agility_chain_turn < 1)
    {
        with (o_player)
        {
            if (scr_getAgredMobsCount(true))
            {
                var _name = scr_actionsLogGetName(id);
                scr_actionsLogUpdate(_name + "获得了一个连续回合");
                if (scr_chance_value(40))
                    scr_actionsLogSpeech(id, "speech", "再来！");
            }

            // 连动回合会跳过敌方回合推进，因此在这里补上玩家自身的恢复。
            if (!forceAllTurn)
            {
                var _hp_modifier = 1 + (scr_instance_exists_in_list(o_b_hyssop) != -4);
                var _mp_modifier = 1 + (scr_instance_exists_in_list(o_b_azurecap) != -4);
                scr_unit_regen(_hp_modifier, _mp_modifier);
            }

            scr_pain_decrease(true);
            global.free_turn_consumed = true;
        }

        // 连动只跳过敌人行动，但仍按一次正常玩家回合推进技能冷却。
        with (o_skill)
            alarm[10] = 1;
    }
    else if (!global.free_turn_consumed)
    {
        global.agility_chain_turn--;
    }

    if (global.free_turn_consumed)
    {
        with (o_player)
        {
            alarm[4] = -1;
            alarm[1] = -1;
            lock_movement = false;
        }
        
        exit;
    }
    
    with (o_player)
        alarm[4] = argument0;
}
