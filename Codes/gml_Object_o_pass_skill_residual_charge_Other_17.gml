// o_pass_skill_residual_charge — Other_17 (User Event 7)
// 提示文本刷新，同步更新暴击增益的数值显示
event_inherited();

if (instance_exists(owner))
{
    // 原有：基础 Shock 伤害值
    ds_map_replace(text_map, "Shock_DMG", owner.WIL * 0.2 * ((100 + owner.Electromantic_Power) / 100));
    
    var _count = 0;
    
    if (instance_exists(o_skill_category_electromancy))
    {
        with (o_skill_category_electromancy)
        {
            var _size = array_length(skill);
            for (var i = 0; i < _size; i++)
            {
                if (skill[i].is_open)
                    _count++;
            }
        }
    }
    _count = (_count + ((owner.WIL + owner.Electromantic_Power + owner.Magic_Power) / 50)) * (0.5 + (owner.WIL * 0.01));
    // 新增：暴击时的额外抗性减益值（固定 -1.5，可按需联动属性缩放）
    var _str_count = string_format(_count, 0, 1);
    ds_map_replace(text_map, "Resistance_Reduce", _str_count);
    _str_count = string_format(_count * 1.5, 0, 1);
    ds_map_replace(text_map, "Crit_Resistance_Reduce", _str_count);
}
