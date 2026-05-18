if (is_open && instance_exists(owner))
{
    ds_map_clear(data);
    
    var _mp = 0, _hp = 0, _debuff_count = 0;
    
    with (owner)
    {
        _hp = HP/(max_hp * 0.2);
        _mp = MP/(max_mp * 0.2);
        _debuff_count = scr_instance_in_list(o_debuff, buffs, false);
        _hp = math_floor(_hp);
        _mp = math_floor(_mp);
    }
    
    // 根据现有魔力降低冷却与能量消耗
    ds_map_add(data, "Cooldown_Reduction", -4 * _mp);
    ds_map_add(data, "Abilities_Energy_Cost", -8 * _mp);
    
    // 根据现有生命提升武器伤害与命中率
    ds_map_add(data, "Weapon_Damage", 5 * _hp);
    ds_map_add(data, "Hit_Chance", 3 * _hp);
    
    // 根据负面状态数量提升抗性
    var _debuff_resistance = 5 * _debuff_count;
    ds_map_add(data, "Fortitude", _debuff_resistance);
    ds_map_add(data, "Bleeding_Resistance", _debuff_resistance);
    ds_map_add(data, "Stun_Resistance", _debuff_resistance);
    ds_map_add(data, "Knockback_Resistance", _debuff_resistance);
}

event_inherited();
