function scr_allturn(argument0) {
    if (argument0 == undefined) argument0 = global.TurnDelay;

    // 免费回合拦截已移至 scr_unitTurnNext（敌人回合调度的唯一天然入口）
    scr_global_turn();

    with (o_player) {
        if (path && argument0 > 1) argument0 = 4;
        alarm[1] = argument0;
        lock_movement = true;
    }
}