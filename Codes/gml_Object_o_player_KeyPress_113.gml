if (!variable_global_exists("target_speed"))
    global.target_speed = 40;

if (global.target_speed == 40)
{
    scr_actionsLogUpdate("加速x4倍");
    global.target_speed = 160;                // 40 就是原速
    game_set_speed(global.target_speed, gamespeed_fps);
}
else if (global.target_speed == 160)
{
    scr_actionsLogUpdate("加速x2倍");
    global.target_speed = 80;
    game_set_speed(global.target_speed, gamespeed_fps);
}
else if (global.target_speed == 80)
{
    scr_actionsLogUpdate("恢复正常速度");
    global.target_speed = 40;
    game_set_speed(global.target_speed, gamespeed_fps);
}
