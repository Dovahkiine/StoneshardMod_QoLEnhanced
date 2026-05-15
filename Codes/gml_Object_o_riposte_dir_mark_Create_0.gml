// ================================================================
//  招架方向选择 mark — Create_0
//  属性初始化；方向计算 + buff 创建推迟至 Alarm_1
//  （Create_0 触发时 target_x/target_y 尚未由 scr_cast_spell 设置）
// ================================================================
event_inherited();
dir = 0;
image_speed = 0;
is_execute = false;
duration = 2;
alarm[6] = 5;
unit_only = true;
category = "weapon";
is_visisble_lock = true;
type = "2hsword";
target = -4;
depth = -y + 18;

with (o_riposte_dir_indicator)
    instance_destroy();
