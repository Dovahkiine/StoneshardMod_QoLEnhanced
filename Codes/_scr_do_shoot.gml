// 执行一次完整的 predictor 流程（创建 o_arrow，更新玩家状态）
// 原版 predictor 块的函数化封装，必须在玩家实例上下文中调用
// 返回: 新建的 o_arrow 实例 ID
//_target, _arg2, _missle_sprite, _used_obj, _loot_obj, _initial_speed
function _scr_do_shoot(argument0, argument1, argument2, argument3, argument4, argument5)
{
    diss += 100;

    if (!instance_exists(argument0))
        return noone;

    if (argument0.object_index == o_attacked_target
        && (!instance_exists(argument1) || argument1.object_index != o_attacked_target))
    {
        if (visible)
            scr_actionsLog("shotMiss", [scr_actionsLogGetName(id), scr_actionsLogGetName(argument1)]);
    }

    var _k = scr_passive_skill_is_open(o_pass_skill_constant_training) ? 1 : 2;
    RngPen = _k * (scr_tile_distance(id, argument0) - range);

    var _arrow_out = noone;
    var _arrow_inst = instance_create_depth(x, y - 6.5, 0, o_arrow);

    if (_arrow_inst == noone || _arrow_inst < 0)
        return noone;

    with (_arrow_inst)
    {
        sprite_index      = argument2;
        used_object_index = argument3;
        loot_object       = argument4;
        target            = argument0;
        scr_rest_disable(target);
        owner             = other.id;
        event_perform(ev_alarm, 0);
        alarm[0]          = -1;
        if (argument5 >= 0)
        {
            speed = argument5;
            if (!argument5)
                alarm[1] = 5;
        }
        _arrow_out        = id;
        scr_skill_call_passive(o_pass_skill_control_shot, owner, target);
        isSlingAmmo       = object_is(loot_object, o_inv_sling_ammo_quiver_parent);

        if (!isSlingAmmo)
            scr_audio_play_at(choose(snd_arrow_hit_1, snd_arrow_hit_2));
        else
            scr_audio_play_at(choose(snd_sling_shot_1, snd_sling_shot_2, snd_sling_shot_3, snd_sling_shot_4));
    }

    scr_characterStatsUpdateAdd("attacks", 1);
    scr_noise_attack_check(id, argument0, grid_x, grid_y);
    scr_hint_ranged();

    return _arrow_out;
}
