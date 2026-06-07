// 0.9.4.22.1 原版兼容：owner 已不存在时直接销毁，避免后续读取 owner.STR/PRC/AGL 崩溃。
if (!instance_exists(owner))
{
    instance_destroy();
    exit;
}

var _prr = -owner.STR;
var _fmb = (0.5 * owner.PRC) + (0.5 * owner.AGL);

if (attack_result != "miss")
{
    with (target)
    {
        if (object_is_ancestor(object_index, o_unit))
        {
            var _double_power = 1;
            var _double_duration = 1;

            if (other.target_is_different && !other.is_crossbow)
                _double_duration = 2;
            else if (other.is_crossbow)
                _double_power = 2;

            scr_temp_effect_update(other.object_index, id, "PRR", _prr * _double_power, 5 * _double_duration, 1);
            scr_temp_effect_update(other.object_index, id, "FMB", _fmb * _double_power, 5 * _double_duration, 1);
            var _kd_inc = 0;

            if (is_player())
            {
                with (o_skill_ico)
                {
                    if (is_open && !passive)
                    {
                        var _kd = scr_get_value_Dmap(skill, "KD");
                        var _set_kd = _kd_inc + _kd;
                        scr_set_kd(skill, "KD", _set_kd);

                        with (child_skill)
                            scr_set_kd(skill, "KD", _set_kd);
                    }
                }
            }
            else if (!scr_passive_skill_is_open(264))
            {
                for (var i = 0; i < array_length(skill_id_name); i++)
                {
                    var _skill = skill_id_name[i];
                    var _kd = scr_get_value_Dmap(_skill, "KD");
                    var _set_kd = _kd_inc + _kd;
                    scr_set_kd(_skill, "KD", _set_kd);
                }
            }
        }
    }
}

if (variable_instance_exists(id, "__qol_pending_arrows"))
{
    __qol_pending_arrows--;

    if (__qol_pending_arrows < 0)
        __qol_pending_arrows = 0;
}

if (throw_count <= 0 || !instance_exists(target))
{
    if (!variable_instance_exists(id, "__qol_pending_arrows") || __qol_pending_arrows <= 0)
        instance_destroy();
}
