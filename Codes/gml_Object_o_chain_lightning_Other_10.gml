event_user(1);
var _stagger_chance = 0;
var _resonance_chance = 0;
var _chain_lightning_count = 6;
var _shock_damage_static = 0;
var _target_alive = instance_exists(target) && target.HP >= 1;

if (live_call())
    return global.live_result;

if (_target_alive && instance_exists(owner))
{
    with (owner)
    {
        if (is_player())
        {
            _chain_lightning_count = 4 + (WIL * 2 + Miracle_Power + Magic_Power + Electromantic_Power - 225) * 0.04;
            _shock_damage_static = (9 + (WIL + Electromantic_Power) * 0.1) * (225 + Electromantic_Power + Magic_Power) / (350 - Miracle_Power * 0.2);
            other.Shock_Damage = max(1, math_round(_shock_damage_static * random_range(1, 170 + WIL) / 100));
        }
        else
        {
            _shock_damage_static = 10 * (100 + Electromantic_Power + Magic_Power * 0.5) / 100;
            other.Shock_Damage = max(1, math_round(_shock_damage_static * random_range(1, 155 + WIL * 0.5) / 100));
        }

        _stagger_chance = math_round(50 * (Magic_Power + Electromantic_Power) / 100);
        _resonance_chance = math_round(80 * (Magic_Power + Electromantic_Power) / 100);

        if (other.is_crit)
        {
            _stagger_chance *= max(1, Miracle_Power / 100);
            _resonance_chance *= max(1, Miracle_Power / 100);
            _chain_lightning_count *= Miracle_Power / 125;
        }
    }
}
else if (!_target_alive && instance_exists(owner) && is_player(owner))
{
    with (owner)
        _chain_lightning_count = 4 + (WIL * 2 + Miracle_Power + Magic_Power + Electromantic_Power - 225) * 0.04;
}

if (_target_alive)
{
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
                {
                    var _impulse = scr_instance_exists_in_list(o_db_impulse, target.buffs);

                    if (!_impulse)
                        scr_effect_create(o_db_resonance, 4, target, owner);
                    else
                    {
                        with (_impulse)
                            scr_modifer_duration_change(6);
                    }
                }

                scr_skill_category_change_KD(o_skill_category_electromancy, 1);
            }

            scr_skill_electromancy_water(target, Shock_Damage / 2);
        }
    }
}

var _target_array = array_create(0);
var _owner_id = instance_exists(owner) ? owner.id : -4;

with (o_unit)
{
    if (HP < 1)
        continue;
    if (id == _owner_id || id == other.target)
        continue;

    var _distance = scr_tile_distance(id, other);

    if (_distance < 16)
        array_push(_target_array, id, _distance);
}

var _min_distance = 100;
var _target = -4;
var _size = array_length(_target_array);
var _boogaloCounter = 0;
var _weighted_target = -4;
var _total_weight = 0;

for (var i = 0; i < _size; i += 2)
{
    var _candidate = _target_array[i];
    var _distance = _target_array[i + 1];

    if (_distance < _min_distance)
    {
        _target = _candidate;
        _min_distance = _distance;
    }

    var _weight_distance = max(1, _distance);
    var _weight = 1 / (_weight_distance * _weight_distance);
    _total_weight += _weight;

    if (random(_total_weight) < _weight)
        _weighted_target = _candidate;

    with (_candidate)
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

if (_target && !scr_chance_value(40) && _weighted_target)
    _target = _weighted_target;

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

if (_target && global.chain_lightning_count < _chain_lightning_count)
{
    global.chain_lightning_count++;

    with (instance_create_depth(x, y, 0, object_index))
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
        var _travel_tiles = point_distance(x, y, _pointCenter[0], _pointCenter[1]) / 26;
        speed = min(20, 8 + _travel_tiles * 0.4);
        direction = point_direction(x, y, _pointCenter[0], _pointCenter[1]);
    }
}
else if (is_player(owner))
{
    scr_allturn();
}
