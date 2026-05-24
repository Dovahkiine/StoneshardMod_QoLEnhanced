event_inherited();
scr_buff_atr();
buff_snd = snd_skill_two_hand_sword_riposte;
stack = 1;
max_duration = 4;
is_execute = false;
previos_attacker = noone;

// ================================================================
//  精准格挡状态变量
// ================================================================
is_riposte_ready = true;
raw_absorbed_damage = 0;
counter_target = noone;
add_damage = 0;
riposte_direction = noone;

// 从 o_player 读取 mark 传来的方向（Destroy_0 中写入）
if (variable_instance_exists(o_player, "__riposte_dir"))
{
    riposte_direction = o_player.__riposte_dir;
    o_player.__riposte_dir = -4;
}
