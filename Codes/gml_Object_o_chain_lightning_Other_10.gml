event_user(1);
var _stagger_chance = 0;
var _resonance_chance = 0;

if (live_call())
    return global.live_result;

if (instance_exists(owner))
{
    chain_lightning_bonus = 4 + (owner.WIL * 2 + owner.Miracle_Power * 0.5 + owner.Magic_Power + owner.Electromantic_Power) * 0.04;
    chain_lightning_bonus = is_crit ? chain_lightning_bonus * 1.5 : chain_lightning_bonus;
    Shock_Damage_Static = (8 + (owner.WIL + owner.Electromantic_Power) * 0.2) * (100 + owner.Electromantic_Power + owner.Magic_Power * 0.5) / 100;
    Shock_Damage = max(1, math_round(Shock_Damage_Static * random_range(1, 170 + owner.WIL) / 100));
    _stagger_chance = math_round(50 * (owner.Magic_Power + owner.Electromantic_Power) / 100);
    _resonance_chance = math_round(80 * (owner.Magic_Power + owner.Electromantic_Power) / 100);
    
    if (is_crit)
        _stagger_chance *= max(1, owner.Miracle_Power / 100);
}

event_inherited();

with (target)
{
    scr_noise_produce(scr_noise_spell_cast(16), x div 26, y div 26);
    scr_audio_play_at(snd_skill_chainlightning_hit);
}

if (!is_shield_block)
{
    scr_skill_call_passive(o_pass_skill_conduit, owner, target, false, "", damage_done);
    _scr_residual_charge_on_spell_hit(owner, target);
    
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
    
    if (instance_exists(target))
    {
        if (object_is_ancestor(target.object_index, o_unit))
        {
            if (scr_chance_value(_stagger_chance - target.Stun_Resistance))
                scr_effect_create(o_db_stagger, 2, target, owner);
            
            if (scr_chance_value(_resonance_chance - target.Shock_Resistance))
                scr_effect_create(o_db_resonance, 4, target, owner);
            
            scr_skill_category_change_KD(o_skill_category_electromancy, 2);
        }
        
        scr_skill_electromancy_water(target, Shock_Damage / 2);
    }
}

var _target_array = array_create(0);

with (o_unit)
{
    if (id != other.owner.id && id != other.target)
    {
        var _distance = scr_tile_distance(id, other.target);

        if (_distance < 21)
            array_push(_target_array, id, _distance);
    }
}

var _min_distance = 100;
var _target = -4;
var _size = array_length(_target_array);
var _boogaloCounter = 0;

for (var i = 0; i < _size; i += 2)
{
    var _distance = _target_array[i + 1];
    
    if (_distance < _min_distance)
    {
        _target = _target_array[i];
        _min_distance = _distance;
    }
    
    with (_target_array[i])
    {
        var _ballighting = instance_nearest(x, y, o_ball_lightning);
        
        if (_ballighting)
        {
            var _shift = 26 * _ballighting.tile_region_size;
            
            if (collision_rectangle(_ballighting.x - _shift, _ballighting.y - _shift, _ballighting.x + _shift, _ballighting.y + _shift, id, false, false))
                _boogaloCounter++;
        }
    }
}

if (_boogaloCounter >= 2)
    scr_steam_achivment("Electric_Boogalo");

repeat (8 + random(4))
{
    with (instance_create_depth(x + random_range(-3, 3), y, 0, o_lighting_particle))
    {
        speed = 4 + random(4);
        direction = random_range(20, 160);
    }
}

if (_target && global.chain_lightning_count < chain_lightning_bonus)
{
    global.chain_lightning_count++;
    
    with (instance_create_depth(target.x, target.y, 0, object_index))
    {
        damage = other.damage;
        name = other.name;
        owner = other.owner;
        is_crit = other.is_crit;
        target_x = x;
        target_y = y;
        target = _target;
        is_flying = false;
        var _pointCenter = scr_findMaskCenter(target);
        direction = point_direction(x, y, _pointCenter[0], _pointCenter[1]);
    }
}
else if (is_player(owner))
{
    scr_allturn();
}
