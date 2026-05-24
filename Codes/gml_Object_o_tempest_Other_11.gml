instance_create_depth(x, y, 0, o_explosion_hole);

repeat (3)
{
    with (instance_create_depth(x + irandom_range(-3, 3), y, 0, o_firemagick_paricle))
    {
        speed = 3 + random(4);
        direction = random_range(45, 145);
    }
}

if (!instance_exists(target))
    exit;

if (!instance_exists(owner))
    exit;

var _shock_damage_static = 0;

if (!is_created)
{
    is_created = true;
    var _target = target;
    target = scr_skill_reflection(target);

    if (_target != target)
    {
        with (instance_create_depth(target.x, target.y, 0, o_tempest))
        {
            damage = other.damage;
            owner = other.owner;
            name = other.name;
            target = other.target;
            scr_set_lt();
            is_crit = other.is_crit;
        }
        exit;
    }

    if (is_player(owner))
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
        
        _shock_damage_static = math_round((10.5 + owner.WIL * 0.12 + owner.Electromantic_Power * 0.12) * (100 + owner.Electromantic_Power + owner.Magic_Power * 0.5) / (80 - _count));
    }
    else
    {
        _shock_damage_static = math_round(12 * ((100 + owner.Electromantic_Power) / 100));
    }


    var _is_stun = false;
    var _chance = math_round(20 + ((owner.Magic_Power + owner.Electromantic_Power) / 100));

    with (target)
    {
        scr_camera_shake(random_range(5, 7));

        repeat (8)
        {
            with (instance_create_depth(x + irandom_range(-3, 3), y, 0, o_lighting_particle))
            {
                speed = 3 + random(4);
                direction = random_range(20, 160);
            }
        }

        var _stage = 0;
        var _dur = 0;
        var _resonance = scr_instance_exists_in_list(o_db_resonance);

        if (_resonance)
        {
            _stage += _resonance.stage;
            _dur += _resonance.duration;
            instance_destroy(_resonance);

            if (scr_chance_value((_chance * (1 + (0.1 * _dur))) - Stun_Resistance))
            {
                scr_effect_create(o_db_stun, 2, id, other.owner);
                _is_stun = true;
            }
        }

        var _impulse = scr_instance_exists_in_list(o_db_impulse);

        if (_impulse)
        {
            _stage += _impulse.stage;
            _dur += _impulse.duration;
            instance_destroy(_impulse);

            if (scr_chance_value((_chance * (1 + (0.05 * _dur))) - Stun_Resistance))
            {
                scr_effect_create(o_db_stun, 2, id, other.owner);
                _is_stun = true;
            }
        }

        _shock_damage_static *= (1 + (0.1 * _dur));
    }

    Shock_Damage = max(1, math_round(_shock_damage_static * random_range(1, 170 + owner.WIL) / 100));

    event_inherited();
    var _dmg = scr_skill_damage(target, false);
    scr_skill_call_passive(o_pass_skill_conduit, owner, target, false, "", _dmg);
    _scr_residual_charge_on_spell_hit(owner, target);

    with (target)
        scr_noise_produce(scr_noise_spell_cast(26), x div 26, y div 26);

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

    if (_is_stun == true)
    {
        _target = -4;

        with (o_unit)
        {
            if (id != other.owner.id && id != other.target && scr_tile_distance(id, other.target) <= 12)
            {
                _target = id;
                break;
            }
        }

        if (_target && instance_exists(_target))
        {
            with (instance_create_depth(_target.x, _target.y, 0, object_index))
            {
                damage = other.damage;
                name = other.name;
                owner = other.owner;
                is_crit = other.is_crit;
                target_x = _target.x;
                target_y = _target.y;
                target = _target;
                var _pointCenter = scr_findMaskCenter(target);
                direction = point_direction(x, y, _pointCenter[0], _pointCenter[1]);
            }
        }
    }

    scr_skill_electromancy_water(target, Shock_Damage / 2);

    if (instance_exists(target))
    {
        if (target.HP < ((0.16 + 0.04 * (owner.WIL + owner.Electromantic_Power)/ 100) * target.max_hp) && target.HP <= math_round(50 * (owner.WIL + owner.Magic_Power + owner.Electromantic_Power) / (104 - _count - (owner.WIL + owner.Electromantic_Power) * 0.1)))
        {
            with (target)
                scr_simple_damage(id, HP);
        }
    }
}
