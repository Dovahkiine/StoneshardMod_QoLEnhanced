if (!is_execute && instance_exists(owner) && instance_exists(target))
{
    var _owner = owner.id;
    var _target = target.id;
    var _is_player_owner = is_player(owner);

    with (o_skill_aoe_zone)
    {
        if (main_owner == _owner)
            instance_destroy();
    }

    var _count_limit = 4 + (owner.WIL + owner.Miracle_Chance + owner.Electromantic_Power) / 40;

    if (_is_player_owner && scr_chance_value(owner.Miracle_Chance + (owner.WIL + owner.Electromantic_Power) * 0.5))
    {
        global.got_free_turn++;
        _count_limit = _count_limit * 1.5;
    }

    is_execute = true;
    var _target_array = [];
    var _count = 0;
    
    array_push(_target_array, _target);

    with (o_unit)
    {
        if ((visible || !_is_player_owner) && id != _owner && id != _target)
        {
            var _distance = scr_tile_distance(id, _owner);

            if (_distance <= _owner.VSN)
            {
                var _state_check = is_hostile || state == "attack" || state == "search" || state == "alarm";

                if (_state_check || (!_is_player_owner && faction_key != _owner.faction_key))
                {
                    var _resonance = scr_instance_exists_in_list(o_db_resonance);
                    var _impulse = scr_instance_exists_in_list(o_db_impulse);

                    if (_impulse || _resonance)
                    {
                        array_push(_target_array, id);
                    }
                    else if (_count < _count_limit)
                    {
                        array_push(_target_array, id);
                        _count++;
                    }
                }
            }
        }
    }

    var _size = array_length(_target_array);

    if (_size < 3)
    {
        with (o_abstract_stuff)
        {
            if (is_visible(id) && can_broke && scr_can_be_broken(id) && scr_tile_distance(id, other.target) < 5)
            {
                array_push(_target_array, id);
                _size++;
            }

            if (_size >= 3)
                break;
        }
    }

    for (var i = 0; i < _size; i++)
    {
        _target = _target_array[i];
        with (instance_create_depth(_target.x, _target.y, 0, o_tempest))
        {
            damage = other.damage;
            owner = other.owner;
            name = other.name;
            target = _target;
            scr_set_lt();
            is_crit = other.is_crit;
        }
    }

    var _empty_slots = 3 - _size;

    if (_empty_slots > 0)
    {
        var _list = __dsDebuggerListCreate();
        var _mass = scr_free_tile_array(target.x, target.y, 5, false, false);

        for (var i = 0; i < array_length(_mass); i += 2)
            ds_list_add(_list, string(_mass[i]) + "/" + string(_mass[i + 1]));

        ds_list_shuffle(_list);
        ds_list_shuffle(_list);
        _size = min(_empty_slots * 2, ds_list_size(_list));

        for (var i = 0; i < _size; i++)
        {
            var _x = string_to_real(string_extract(ds_list_find_value(_list, i), "/", 0));
            var _y = string_to_real(string_extract(ds_list_find_value(_list, i), "/", 1));
            with (instance_create_depth(target.x + _x, target.y + _y, 0, o_tempest))
            {
                damage = other.damage;
                owner = other.owner;
                name = other.name;
                target = -4;
                scr_set_lt();
                is_crit = other.is_crit;
            }

            with (o_pass_skill_residual_charge)
            {
                if (is_open && instance_exists(owner) && owner.id == other.owner)
                    scr_temp_incr_atr("Electromantic_Power", 25, 2400, owner, owner);
            }
        }

        _list = __dsDebuggerListDestroy(_list);
    }
}
