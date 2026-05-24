event_user(1);
var _resonance_chance = 0;
var _knockback_chance = 0;
var _reflection_attacker = -4;
var _shock_damage_static = 0;

if (instance_exists(owner))
{
    with (owner)
    {
        if (is_player())
            _shock_damage_static = (7 + (WIL + Electromantic_Power) * 0.1) * (100 + Electromantic_Power + Magic_Power * 0.5) / 100;
        else
            _shock_damage_static = 8 * (100 + Electromantic_Power + Magic_Power * 0.5) / 100;

        _knockback_chance = math_round(35 * (Magic_Power + Electromantic_Power) / 100);
        _resonance_chance = math_round(70 * (Magic_Power + Electromantic_Power) / 100);

        if (other.is_crit)
        {
            _knockback_chance *= max(1, Miracle_Power / 100);
            _resonance_chance *= max(1, Miracle_Power / 100);
        }
        
        _reflection_attacker = reflection_attacker;
    }
}

Shock_Damage = max(1, math_round((_shock_damage_static * random_range(1, 210)) / 100));
event_inherited();

if (!is_shield_block)
{
    if (is_player(owner))
    {
        with (o_pass_skill_chain_reaction)
        {
            target = other.target;
            event_user(3);
        }
    }
    
    if (!instance_exists(target) || (object_is_ancestor(target.object_index, o_unit) && target.HP < 1))
        scr_skill_call_passive(o_pass_skill_recharge, owner, target);
    
    with (target)
        scr_audio_play_at(snd_skill_discharge_hit);
}

if (instance_exists(target) && !is_shield_block)
{
    if (object_is_ancestor(target.object_index, o_unit))
    {
        if (scr_chance_value(_resonance_chance - target.Shock_Resistance))
        {
            var _impulse = scr_instance_exists_in_list(o_db_impulse, target.buffs);
            var _dur = scr_skill_get_duration(8, owner);
            
            if (!_impulse)
            {
                scr_effect_create(o_db_resonance, _dur, target, owner);
            }
            else
            {
                with (_impulse)
                {
                    duration += _dur;
                    owner = other.owner;
                }
            }
        }
        
        if (!is_full_block && scr_chance_value(_knockback_chance - target.Knockback_Resistance))
        {
            var _side_array = -4;
            
            if (_reflection_attacker != -4 && instance_exists(_reflection_attacker))
                _side_array = scr_side_point_target(_reflection_attacker.x div 26, _reflection_attacker.y div 26, target.x div 26, target.y div 26);
            
            scr_cast_knockback(owner, target, 1, false, _side_array);
        }
        
        scr_skill_electromancy_water(target, Shock_Damage / 2);
        scr_skill_call_passive(o_pass_skill_conduit, owner, target, false, "", damage_done);
    }
}
