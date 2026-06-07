event_inherited();
audio_listener_position(x, y, 0);
audio_listener_orientation(x, y, 1000, 0, -1, 0);
var _moving_script = scr_check_keyboard_array;
var _unit_is_turn = scr_unitTurnGetTime();

if (!_unit_is_turn)
{
    with (o_animation_blocker)
    {
        if (is_visible(owner, true))
        {
            _unit_is_turn = true;
            break;
        }
    }
}

if (path || _unit_is_turn || is_moving || xx != x || yy != y)
{
    with (o_floor_target)
        invisible = true;
}
else
{
    with (o_floor_target)
        invisible = false;
}

var _is_enemy = scr_getAgredMobsCount(true);
var _is_allow_actions = is_allow_actions();

if (!variable_global_exists("__qol_enemyhealthbars_enabled_prev"))
    global.__qol_enemyhealthbars_enabled_prev = global.enemyhealthbars_enabled
if (global.__qol_enemyhealthbars_enabled_prev != global.enemyhealthbars_enabled)
{
    global.__qol_enemyhealthbars_enabled_prev = global.enemyhealthbars_enabled
    if (!global.enemyhealthbars_enabled)
    {
        with (o_enemy_healthbar)
            instance_destroy()
    }
    else
    {
        with (o_enemy)
        {
            if (variable_instance_exists(id, "HP") && HP > 0 && (!variable_instance_exists(id, "__qol_ehb_initialized") || !__qol_ehb_initialized))
            {
                var _healthbar = instance_create_depth(x, y, (depth - 1), o_enemy_healthbar)
                _healthbar.target = id
                __qol_ehb_initialized = true
            }
        }
    }
}

if (((_is_allow_actions || (!_is_enemy && !_unit_is_turn)) && ds_list_empty(lock_turn)) || force_move)
{
    if (step < (path_get_number(path) - 1))
    {
        _x = path_get_point_x(path, step + 1);
        _y = path_get_point_y(path, step + 1);

        if (!is_moving)
        {
            step++;

            if (!scr_turn())
            {
                scr_stop_player();
            }
            else if (point_distance(x, y, xx, yy) > spd)
            {
                scr_global_turn();

                with (o_skill)
                    alarm[10] = 1;

                scr_noise_produce(scr_noise_moving(), grid_x, grid_y);
            }
        }
    }
    else if (speed == 0)
    {
        step = 0;
        path = -1;
    }

    var _stop = false;

    if (_is_enemy)
    {
        _moving_script = scr_check_keyboard_pressed_array;

        if (path)
        {
            scr_stop_player(true);
            _stop = true;

            if (global.returnCamera)
                scr_camera_reset();
        }
    }
}

var _lvl = scr_atr("LVL");
var _xp = scr_atr("XP");
max_xp = 250 * _lvl;

// [经验曲线重做] 替换原版 max_xp = 250 * _lvl
if (_lvl < 4)
    max_xp = 150 + (_lvl * 150);
else
    max_xp = 300 + (_lvl * 200);

if (_lvl == 100 && _xp >= max_xp)
{
    _xp = max_xp - 1;
    scr_atr_set("XP", _xp);
}

if (_xp >= max_xp)
{
    scr_atr_incr("LVL", 1);
    scr_atr_set("XP", _xp - max_xp);
    _lvl = scr_atr("LVL");

    with (o_skill_ico)
        event_user(1);

    // [等级获得AP/SP重做] 替换原版固定 1 AP / 1 SP
    if (_lvl < 20)
    {
        scr_atr_incr("AP", 3);
        scr_atr_incr("SP", 2);
    }
    else
    {
        scr_atr_incr("AP", 5);
        scr_atr_incr("SP", 3);
    }
    _oldXp = max_xp;    
    instance_create_depth(x, y, 0, o_lvlup);
    HP = max_hp;

    if (_lvl > 1)
    {
        scr_actionsLog("level", [scr_actionsLogGetName(id), scr_atr("LVL")]);

        if (!audio_is_playing(snd_level_up))
            audio_play_sound(snd_level_up, 4, 0);

        scr_characterStatsUpdateReplace("timeLevel", global.timeLevel / (_lvl - 1));
    }

    scr_atr_calc(id);
}

target = -4;

if (speed > 0)
    audio_listener_set_position(0, x, y, 0);

if (HP > max_hp)
    HP = max_hp;

if (floor(HP) == 1)
{
    if (max_hp > 1)
        comaback = true;
}

if (global.playerGodMode)
{
    MP = 200;
    max_mp = MP;
}

if (global.playerNoDeathMode)
{
    if (HP <= 1)
        HP = 1;

    if (max_hp <= 1)
        max_hp = 1;
}

if (global.playerNoPain)
{
    scr_bodyPartsConditionChange(id, 100);
    scr_atr_set("Hunger", 0);
    scr_atr_set("Thirsty", 0);
    scr_atr_set("Intoxication", 0);
    scr_atr_set("Pain", 0);
    scr_atr_set("Fatigue", 0);
}

if (comaback && HP >= max_hp)
{
    scr_steam_achivment("Comeback!");
    comaback = false;
}

if (HP < 1)
{
    with (o_inv_etnarch_mask)
        _scr_call_method(execute);

    var _cd_validate = true;

    if (scr_psy_get("SecondWindRandomCD") > 0)
        _cd_validate = false;

    if (scr_playerPerkExists(o_perk_vow_feat))
        _cd_validate = true;

    if (scr_chance_value(ds_map_find_value(psyData, "TrigLowHP")) && scr_psy_get("TrigAccumCurrent") == "TrigLowHP" && _cd_validate && scr_atr("Morale") >= 50 && scr_atr("Sanity") >= 50)
    {
        HP = 1;
        scr_psy_state_create("SecondWind", 30, o_state_secondwind);
        ds_map_set(psyData, "TrigCurrent", "TrigNo");
        ds_map_set(psyData, "TrigLowHP", 0);
        scr_psy_set("SecondWindRandomCD", 2880);
    }

    if (HP < 1)
        event_user(6);
}

if (!global.devCamera)
{
    if (!global.consoleEnabled)
    {
        if (!global.skill_activate)
        {
            if (global.skill_can_cast)
            {
                if (_is_allow_actions || (!_is_enemy && !_unit_is_turn))
                {
                    if (!scr_is_cutscene())
                    {
                        if (can_press())
                        {
                            if (script_execute(_moving_script, 4) || (script_execute(_moving_script, 0) && script_execute(_moving_script, 2)))
                                scr_keyboard_control((grid_x - 1) * 26, (grid_y - 1) * 26);

                            if (script_execute(_moving_script, 5) || (script_execute(_moving_script, 0) && script_execute(_moving_script, 3)))
                                scr_keyboard_control((grid_x + 1) * 26, (grid_y - 1) * 26);

                            if (script_execute(_moving_script, 6) || (script_execute(_moving_script, 1) && script_execute(_moving_script, 2)))
                                scr_keyboard_control((grid_x - 1) * 26, (grid_y + 1) * 26);

                            if (script_execute(_moving_script, 7) || (script_execute(_moving_script, 1) && script_execute(_moving_script, 3)))
                                scr_keyboard_control((grid_x + 1) * 26, (grid_y + 1) * 26);

                            if (script_execute(_moving_script, 0))
                                scr_keyboard_control(grid_x * 26, (grid_y - 1) * 26);

                            if (script_execute(_moving_script, 1))
                                scr_keyboard_control(grid_x * 26, (grid_y + 1) * 26);

                            if (script_execute(_moving_script, 2))
                                scr_keyboard_control((grid_x - 1) * 26, grid_y * 26);

                            if (script_execute(_moving_script, 3))
                                scr_keyboard_control((grid_x + 1) * 26, grid_y * 26);

                            if (_is_allow_actions && scr_check_keyboard_array(10))
                            {
                                var loot = instance_nearest(x, y, o_loot);

                                if (instance_exists(loot))
                                {
                                    if (loot.grid_x == grid_x && loot.grid_y == grid_y)
                                    {
                                        if (!instance_exists(o_container_parent))
                                        {
                                            with (loot)
                                                mask_index = sprite_index;

                                            instance_create_depth(x, y, 0, o_buffer_target);

                                            with (o_floor_target)
                                                event_user(0);
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

visible = true;
diss /= 1.2;
ediss /= 1.2;

// [标记地点导航] 检测是否启用自动寻路到标记地点
if (!scr_is_cutscene() && is_allow_actions() && auto_move && variable_global_exists("pathfinder_dest") && global.pathfinder_dest != -4)
{
    auto_move = false;
    _scr_auto_move_to_transition(global.pathfinder_dest[0], global.pathfinder_dest[1]);
}
