// ================================================================
//  精准格挡状态变量
// ================================================================
is_riposte_ready    = true;
raw_absorbed_damage  = 0;
counter_target      = noone;
add_damage          = 0;
riposte_direction   = -4;

// 从 o_player 读取 mark 传来的方向（Destroy_0 中写入）
if (variable_instance_exists(o_player, "__riposte_dir"))
{
    riposte_direction = o_player.__riposte_dir;
    o_player.__riposte_dir = -4;
}
