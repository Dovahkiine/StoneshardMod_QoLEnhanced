if (passive)
    exit;

if (!is_open)
    exit;

var _is_ready = false;

if (instance_exists(o_controller) && o_controller.can_fight)
    _is_ready = true;

if (instance_exists(owner))
{
    if (is_movement && !ds_list_empty(owner.lock_turn))
        _is_ready = false;
}

with (o_player)
{
    if (isGround == -1)
        _is_ready = false;
}

if (instance_exists(o_player) && instance_exists(o_controller))
{
    var _target = o_player.id;

    if (MPcost > _target.MP || !_is_ready || (!ds_list_empty(_target.lock_skills) && class == "skill"))
        can_skill_use = false;
    else
        can_skill_use = true;

    if (class == "spell" && !ds_list_empty(_target.lock_spells))
        can_skill_use = false;
}

if (can_skill_use)
{
    var _branch = scr_get_value_Dmap(skill, "Branch");

    if (metacategory == "weapon")
    {
        if (_branch != "ranged")
        {
            var _weapon_type = _branch;

            if (_branch == "staff")
                _weapon_type = "2hStaff";

            if (!scr_is_weapon_type_any_hand(_weapon_type))
                can_skill_use = false;
        }
        else
        {
            var _ammo_count = 1;
            var _has_required_ammo = false;

            if (object_is(object_index, o_skill_pierce_through_missile_ico))
            {
                var _hands = _scr_get_weapon_hand_types();
                var _rh = _hands[0];
                var _lh = _hands[1];

                if (_rh == "ranged" && _lh == "ranged")
                {
                    _ammo_count = 3;
                    _has_required_ammo = scr_is_ammo_exist(_ammo_count);
                }
                else if (_rh == "crossbow" && _lh == "crossbow")
                {
                    var _loaded_bolts = 0;

                    if (scr_crossbow_is_armed(o_inv_right_hand) == 1)
                        _loaded_bolts++;

                    if (scr_crossbow_is_armed(o_inv_left_hand) == 1)
                        _loaded_bolts++;

                    _has_required_ammo = (_loaded_bolts + _scr_count_available_bolts() >= 2);
                }
                else if ((_rh == "crossbow" && _lh == "ranged") || (_rh == "ranged" && _lh == "crossbow"))
                {
                    _has_required_ammo = scr_is_ammo_exist(1);
                }
                else
                {
                    _ammo_count = 2;
                    _has_required_ammo = (scr_is_ammo_exist(_ammo_count) || scr_crossbow_is_armed());
                }
            }
            else
            {
                if (object_is(object_index, o_skill_distracting_shot_ico) || object_is(object_index, o_skill_taking_aim_ico))
                    _ammo_count = 99;

                _has_required_ammo = scr_is_ammo_exist(_ammo_count);
            }

            if (!(scr_is_weapon_type_shooting() && _has_required_ammo))
                can_skill_use = false;
        }
    }
    else if (metacategory == "utility")
    {
        if (_branch == "dual")
        {
            if (!scr_two_hands_check())
                can_skill_use = false;
        }
    }
    else if (metacategory == "sorcery")
    {
        if (_branch == "geomancy" && (object_index != o_skill_runic_boulder_ico && object_index != o_skill_stone_armor_ico))
            can_skill_use = scr_runic_boulder_ready();
    }
}
