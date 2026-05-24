if (instance_exists(owner) && instance_exists(target) && !target.persistent)
{
    var _is_open = scr_passive_skill_is_open(o_pass_skill_potential_difference, owner);
    var _enemy_count_array = [];
    var _debuff_damage_static = 0;
    var _is_immob = 0;
    var _immob_chance = 0;
    
    if (_is_open)
    {
        with (owner)
        {
            if (is_player())
            {
                _enemy_count_array = scr_enemy_count_player(VSN, true);
                _debuff_damage_static = (1.2 + (WIL + Electromantic_Power) * 0.05) * (100 + Electromantic_Power) / 75;
                _is_immob = scr_chance_value(math_round((15 + LVL * 0.5)* ((Magic_Power + Electromantic_Power) / 100)) - other.target.Knockback_Resistance);
                _immob_chance = scr_chance_value(math_round((50 + LVL) * ((Magic_Power + Electromantic_Power) / 100)) - other.target.Knockback_Resistance);
            }
            else
            {
                _enemy_count_array = scr_enemy_count_around(VSN, false, false, true);
                _debuff_damage_static = 2 * (100 + Electromantic_Power) / 100;
                _is_immob = scr_chance_value(math_round(15 * ((Magic_Power + Electromantic_Power) / 100)) - other.target.Knockback_Resistance);
                _immob_chance = scr_chance_value(math_round(50 * ((Magic_Power + Electromantic_Power) / 100)) - other.target.Knockback_Resistance);
            }
        }

        var _length = array_length(_enemy_count_array);
        var _enemy_count = 1;
        
        for (var i = 0; i < _length; i++)
        {
            with (_enemy_count_array[i])
            {
                if (scr_instance_exists_in_list(o_db_resonance) || scr_instance_exists_in_list(o_db_impulse))
                    _enemy_count++;
            }
        }
        
        boost_damage = _enemy_count;
    }
    
    Shock_Damage = math_round(_debuff_damage_static * boost_damage);
    var _dmg = scr_damage_with_calc(target, true, 0, id, true);
    scr_skill_call_passive(o_pass_skill_conduit, owner, target, false, "", _dmg);
    
    repeat (4 + random(4))
    {
        with (instance_create_depth(target.x + random_range(-3, 3), target.y, 0, o_lighting_particle))
        {
            speed = 4 + random(4);
            direction = random_range(20, 160);
        }
    }
    
    if (_is_immob)
    {
        if (scr_cast_knockback(owner, target, 1, 0) && _is_open && _immob_chance)
            scr_effect_create(o_db_immob, 3, target, owner);
    }
}

if (target_is_visible)
{
    with (o_player)
        turn_available = true;
}
