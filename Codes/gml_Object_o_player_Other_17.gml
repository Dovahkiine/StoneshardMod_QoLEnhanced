tile_transition = true;             // 在玩家创建时默认开启 tile_transition，确保寻路功能正常使用
scr_playerTileborderTransition();
end_turn = true;

if (!global.skill_activate)
{
    if (context_target_id != -4)
    {
        with (context_target_id)
        {
            var inter;
            
            if (object_is_ancestor(object_index, o_particles) || object_is_ancestor(object_index, o_trap))
                // 0.9.4.22.1 原版兼容：使用最小 tile 距离判断大型交互对象/陷阱。
                inter = scr_tile_distance_min(id, o_player) <= 1;
            else
                inter = scr_can_interract_posgrid(id, in_grid);
            
            if (inter)
            {
                scr_stop_player();
                
                if (interract_event != -4)
                    event_user(interract_event);
                
                other.context_target_id = -4;
            }
        }
    }
    else if (!instance_exists(o_dialogue))
    {
        with (o_floor_target)
            event_user(1);
    }
}
else
{
    context_target_id = -4;
}

with (o_floor_target)
    path = -4;

if (!force_stop)
{
    if (instance_exists(o_enemy) && path != -1 && !scr_unitTurnGetTime() && !scr_getAgredMobsCount(true))
        event_perform(ev_alarm, 4);
    else
        scr_unitTurnNext();
}

force_stop = false;
tile_transition = false;            // 在玩家创建后立即关闭 tile_transition，并恢复玩家手动切换的全局速度
// 在原有的停止移动逻辑基础上增加对 tile_transition 的检查，确保只有在非寻路状态下才调用 _scr_stop_auto_move，避免寻路过程中被意外打断
// 房间切换后重放玩家自定义全局速度，避免被房间切换流程恢复到默认值。
if (variable_global_exists("target_speed"))
    game_set_speed(global.target_speed, gamespeed_fps);
