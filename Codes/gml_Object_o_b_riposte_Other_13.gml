event_inherited();

if (attack_result == "block" || attack_result == "fumbleBlock" || attack_result == "critBlock")
{
    if (is_player(target))
    {
        with (o_skill_riposte_ico)
        {
            repeat (2)
            {
                scr_map_kd_decrease();

                with (child_skill)
                    scr_map_kd_decrease();
            }
        }
    }
    else
    {
        with (target)
            scr_skill_change_KD_enemy("Riposte", -2);
    }

    scr_temp_incr_atr("Block_Recovery", 10, 3, target, target);

    with (target)
        scr_guiAnimation_ext(x, y, s_riposite_part, 1, 1, 1, 16777215, 0);
}

// ================================================================
//  Other_13 — 被攻击时触发（event_user(3) 来自 scr_damage）
//  可用变量: damage（防御削减后的 net 伤害）/ attacker / attack_result / add_damage / target
//  新增变量: target.__qol_riposte_raw（scr_attack 在命中判定前注入的攻击者潜在伤害）
// ================================================================

// ================================================================
//  精准格挡：完全免疫 + 方向判定 + 记录原始伤害用于反击
//  触发条件：buff 本次尚未触发过（is_riposte_ready）且有有效攻击者
//  当 riposte_direction < 0 时全向格挡，否则只格挡指定方向
// ================================================================
if (is_riposte_ready && !is_execute && instance_exists(attacker))
{
    var _raw = 0;
    if (instance_exists(target))
        _raw = target.__qol_riposte_raw;

    if (_raw > 0)
    {
        var _blocked = true;

        if (riposte_direction >= 0 && riposte_direction <= 7)
        {
            var _angle = point_direction(target.x, target.y, attacker.x, attacker.y);
            var _attack_dir = (round(_angle / 45) mod 8);
            _blocked = (_attack_dir == riposte_direction);
        }

        if (_blocked)
        {
            raw_absorbed_damage = _raw;
            add_damage = -damage;
            counter_target = attacker;
            is_execute = true;
            is_riposte_ready = false;

            with (target)
            {
                with (scr_guiAnimation_ext(x, y, s_riposite_part, 1, 0.75, 1, c_yellow, 0))
                {
                    image_blend = c_yellow;
                    image_xscale = 1.35;
                    image_yscale = 1.35;
                    depth_offset = -3;
                    scale_update = false;
                }

                with (scr_guiAnimation_ext(x, y - 6, s_riposite_part, 1, 0.9, 1, make_color_rgb(255, 244, 160), 0))
                {
                    image_blend = make_color_rgb(255, 244, 160);
                    image_xscale = 1.65;
                    image_yscale = 1.65;
                    depth_offset = -4;
                    scale_update = false;
                }
            }

            alarm[0] = 1;
        }
    }
}
