event_inherited();
var _can_interract = scr_skill_can_interact();

if (_can_interract)
{
    target = scr_attack_tile(o_player, false);

    with (target)
    {
        if (object_index == o_attacked_target)
            alarm[0] = -1;
    }

    array_push(target_array, target);
    var _id = id;

    if (instance_exists(target) && (!object_is_ancestor(target.object_index, o_enemy) || !target.Unbreakable))
    {
        with (target)
        {
            if (object_is_ancestor(object_index, o_unit) || object_index == o_attacked_target)
                array_push(_id.mark_array, scr_onUnitEffectCreate(id, 1865, -152, 0, 0, true));
        }

        use_count--;

        var _force_single_target = false;
        var _hands = _scr_get_weapon_hand_types();
        var _rh = _hands[0];
        var _lh = _hands[1];

        if ((_rh == "crossbow" && _lh == "crossbow") || (_rh == "crossbow" && _lh == "ranged") || (_rh == "ranged" && _lh == "crossbow"))
        {
            _force_single_target = true;
        }
        else if (!(_rh == "ranged" && _lh == "ranged"))
        {
            if (scr_crossbow_is_armed() == 1)
                _force_single_target = true;
        }

        if (_force_single_target)
            use_count = 0;

        if (use_count == 0)
            scr_skill_prepare_to_use(_can_interract);
    }
}
else
{
    scr_skill_denied();
}
