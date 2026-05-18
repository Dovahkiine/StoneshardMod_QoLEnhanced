if (instance_exists(owner))
{
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

    var _shock_damage = (10.5 + (owner.WIL + owner.Electromantic_Power) * 0.12) * (100 + owner.Electromantic_Power + owner.Magic_Power * 0.5) / (80 - _count);
    var _base_damage = max(1, math_round(_shock_damage * 0.01));
    var _hp_limit = math_round(16 + 0.04 * owner.WIL + 0.04 * owner.Electromantic_Power);
    var _max_hp_limit = math_round(50 * (owner.WIL + owner.Magic_Power + owner.Electromantic_Power) / (120 - (owner.WIL + owner.Electromantic_Power) * 0.2));
    var _free_turn_chance = clamp(owner.Miracle_Chance + (owner.WIL + owner.Electromantic_Power) * 0.5, 0, 100);
    var _count_limit = 4 + (owner.WIL + owner.Miracle_Chance + owner.Electromantic_Power) / 40;
    var _count_crit = _count_limit * 1.5;
    ds_map_replace(data, "Shock_Damage", math_round(_shock_damage * 1.7 + owner.WIL));
    ds_map_replace(text_map, "Base_Damage", _base_damage);
    ds_map_replace(data, "Stun_Chance", math_round(20 + ((owner.Magic_Power + owner.Electromantic_Power) / 100)));
    ds_map_replace(data, "HP_Limit", _hp_limit);
    ds_map_replace(data, "Max_HP_Limit", _max_hp_limit);
    ds_map_replace(text_map, "Free_Turn_Chance", _free_turn_chance);
    ds_map_replace(text_map, "Count_Limit", floor(_count_limit));
    ds_map_replace(text_map, "Count_Crit", floor(_count_crit));
}

event_inherited();
