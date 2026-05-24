if (instance_exists(owner) && instance_exists(target))
{
    turn_count = scr_tile_distance_min(owner, target);
    xx = scr_round_cell(owner.x);
    yy = scr_round_cell(owner.y);

    if (turn_count > 1 && ds_list_empty(owner.lock_turn))
    {
        with (owner)
        {
            scr_movementDust();

            if (!scr_one_path_move(other.target, true, id))
                instance_destroy(other.id);
        }

        alarm[0] = 2;
    }
    else
    {
        var _hp_limit = 0.5 * (owner.STR + owner.AGL + owner.PRC);
        var _hp_max_limit = 2 * (owner.STR + owner.AGL + owner.PRC);
        var _restore_value = 1.5 * owner.WIL;

        with (target)
        {
            var key = ds_map_find_first(Body_Parts_map);
            var _min_value = 100;
            var _body_part = key;

            repeat (ds_map_size(Body_Parts_map))
            {
                var _condition = ds_map_find_value(Body_Parts_map, key);

                if (_condition <= _min_value)
                {
                    _min_value = _condition;
                    _body_part = key;
                }

                key = ds_map_find_next(Body_Parts_map, key);
            }

            Body_Part_target = _body_part;
        }

        with (owner)
        {
            scr_hit_deformation(other.target, o_hit_specialstrike);
            var hit = scr_skill_attack("any");

            if (hit && is_deal_damage)
            {
                with (other.target)
                {
                    if (HP < ((_hp_limit * max_hp) / 100) && HP < _hp_max_limit)
                    {
                        scr_simple_damage(id, HP);
                        counterattack_target = -4;
                    }
                }
            }

            if (other.target.HP <= 0)
            {
                if (is_player())
                {
                    with (o_skill_ico)
                    {
                        if (is_open && !passive && object_index != o_skill_finisher_ico)
                        {
                            var _category = scr_get_value_Dmap(skill, "Category");

                            if (_category != 0)
                            {
                                if (ds_list_find_index(_category, "Spell") >= 0 || ds_list_find_index(_category, "Attack") >= 0 || ds_list_find_index(_category, "Charge") >= 0)
                                {
                                    scr_set_kd(skill, "KD", 0);

                                    with (child_skill)
                                        scr_set_kd(skill, "KD", 0);
                                }
                            }
                        }
                    }
                }
                else
                {
                    var _size = array_length(skill_id_name);

                    for (var i = 0; i < _size; i++)
                    {
                        var _skill = skill_id_name[i];

                        if (_skill != "Finisher")
                            scr_set_kd(_skill, "KD", 0);
                    }
                }

                with (other.target)
                {
                    with (scr_guiAnimation(s_finisher_kill, 1, 1, 0))
                        scr_set_lt();
                }

                scr_restore_mp(id, (_restore_value * max_mp) / 100, scr_actionsLogGetNameSkill(other.id));
            }
        }

        with (o_player)
            event_user(5);

        event_inherited();
    }
}
else
{
    event_inherited();
}
