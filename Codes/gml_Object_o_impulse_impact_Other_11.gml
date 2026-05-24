if (!is_created && instance_exists(owner))
{
    is_created = true;
    target = scr_tile_get_instance(xx, yy, 0, 0);
    var _duration = 8, _temp_duration = 0, _shock_damage_static = 0, _knockback_chance = 0, _debuff_chance = 0, _stagger_chance = 0;
    
    with (owner)
    {
        if (is_player())
        {
            _shock_damage_static = (10.5 + WIL * 0.12 + Electromantic_Power * 0.12) * (100 + Electromantic_Power + Magic_Power * 0.5) / 80;
        }
        else
        {
            _shock_damage_static = math_round(12 * ((100 + Electromantic_Power) / 100));
        }
        _knockback_chance = math_round(40 * ((Magic_Power + Electromantic_Power) / 100));
        _debuff_chance = math_round(85 * ((Magic_Power + Electromantic_Power) / 100));
        _stagger_chance = math_round(100 * ((Magic_Power + Electromantic_Power) / 100));
        
        if (other.is_crit)
        {
            _duration *= max(1, Miracle_Power / 100);
            _knockback_chance *= max(1, Miracle_Power / 100);
            _debuff_chance *= max(1, Miracle_Power / 100);
            _stagger_chance *= max(1, Miracle_Power / 100);
        }
    }
    
    _duration = scr_skill_get_duration(_duration, owner);
    _temp_duration = _duration;
    Shock_Damage = max(1, math_round(_shock_damage_static * random_range(20, 220) / 100));
    
    event_inherited();
    scr_skill_damage();
    
    if (instance_exists(target))
    {
        var _impulse = -4;
        var _is_knockback = false;
        
        if (scr_chance_value(_knockback_chance - target.Knockback_Resistance))
            _is_knockback = scr_cast_knockback(owner, target, 1, 0);
        
        _impulse = scr_instance_exists_in_list(o_db_impulse, target.buffs);
        
        if (!_is_knockback && scr_chance_value(_debuff_chance - target.Knockback_Resistance))
            scr_effect_create(o_db_stagger, 2, target, owner);
        
        var _resonance = scr_instance_exists_in_list(o_db_resonance, target.buffs);
        
        if (_resonance)
        {
            _resonance.duration += _duration;
            _duration = _resonance.duration;

            if (!_impulse)
                _impulse = scr_effect_create(o_db_impulse, _duration, target, owner);
            else
                _impulse.duration += _duration;
        }

        if (scr_chance_value(_debuff_chance - target.Shock_Resistance))
        {
            if (!_impulse)
                _impulse = scr_effect_create(o_db_impulse, _temp_duration, target, owner);
            else
                _impulse.duration += _temp_duration;
        }
        
        if (is_player(owner))
        {
            with (o_pass_skill_chain_reaction)
            {
                target = other.target;
                event_user(3);
            }
        }
        
        if (!instance_exists(target) || target.HP < 1)
            scr_skill_call_passive(o_pass_skill_recharge, owner, target);
    }
    
    scr_skill_electromancy_water(target, Shock_Damage / 2);
    
    repeat (4 + irandom(4))
    {
        with (instance_create_depth(x + irandom_range(-3, 3), y, 0, o_lighting_particle))
        {
            speed = 4 + random(4);
            direction = random_range(20, 160);
        }
    }
}
