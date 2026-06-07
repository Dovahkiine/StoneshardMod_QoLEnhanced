if (!is_created && instance_exists(owner))
{
    is_created = true;
    target = scr_tile_get_instance(x, y, 0, 0);

    if (target && instance_exists(target))
    {
        if (!object_is_ancestor(target.object_index, o_unit) || (is_player(owner) && !target.is_player_enemy))
        {
            instance_destroy();
            exit;
        }

        event_inherited();

        with (target)
        {
            with (scr_guiAnimation_ext(x, y, 1772))
                block_disable_frame = 0;
        }

        var _buff = -4;

        _buff = scr_effect_create(o_db_confuse, 12, target, target);

        if (scr_chance_value(40 + (2 * owner.WIL)))
            _buff = scr_effect_create(o_db_daze, 3, target, target);

        if (_buff)
        {
            with (owner)
            {
                var _rage = scr_instance_exists_in_list(o_b_rage);

                with (_rage)
                {
                    if (duration <= 60)
                        duration += 4;
                }
            }
        }
    }
}

instance_destroy();
