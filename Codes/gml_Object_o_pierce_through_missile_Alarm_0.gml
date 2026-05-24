target = -4;
var _is_player_owner = is_player(owner);
var _qol_throw_mode = 0;
__qol_hand_types = ["", ""];

if (_is_player_owner && instance_exists(owner))
{
    with (owner)
        other.__qol_hand_types = _scr_get_weapon_hand_types();
}

var _qol_hands = __qol_hand_types;
var _qol_dual_ranged = (_qol_hands[0] == "ranged" && _qol_hands[1] == "ranged");
var _qol_dual_crossbow = (_qol_hands[0] == "crossbow" && _qol_hands[1] == "crossbow");
var _qol_mixed = ((_qol_hands[0] == "crossbow" && _qol_hands[1] == "ranged") || (_qol_hands[0] == "ranged" && _qol_hands[1] == "crossbow"));
__qol_is_player_owner = _is_player_owner;
__qol_dual_crossbow = _qol_dual_crossbow;
__qol_mixed = _qol_mixed;

if (!_is_player_owner && instance_exists(owner))
    target_array = [owner.target];

var _size = array_length(target_array);

if (_size)
{
    if (!target_is_different)
    {
        for (var i = 0; i < (_size - 1); i++)
        {
            if (target_array[i] != target_array[i + 1])
            {
                target_is_different = true;
                break;
            }
        }
    }

    target = target_array[0];
    array_delete(target_array, 0, 1);
}

if (instance_exists(owner) && instance_exists(target))
{
    if (throw_count == 2)
        scr_skill_call_buff(o_b_suppression, owner);

    __qol_target_to_shoot = -4;

    with (owner)
    {
        force_attack = true;

        if (other.__qol_is_player_owner)
        {
            if (isCrossbowman || other.__qol_dual_crossbow || other.__qol_mixed)
                other.is_crossbow = true;
        }
        else
        {
            other.is_crossbow = isCrossbowmanEnemy;
        }

        if (other.target.object_index == o_attacked_target)
        {
            other.__qol_target_to_shoot = other.target;
        }
        else
        {
            other.__qol_target_to_shoot = scr_shoot_target_miss(other.target, id);

            if (!instance_exists(other.__qol_target_to_shoot))
                other.__qol_target_to_shoot = other.target;
        }
    }

    var _target = __qol_target_to_shoot;
    var _arrow = -4;
    var _qol_mode_name = "";
    __qol_last_arrow = -4;

    if (_target && instance_exists(_target))
    {
        var _wd, _daze_chance;

        if (throw_count == 2)
        {
            _wd = -40 + owner.AGL;
            _daze_chance = 20 + owner.STR + owner.PRC;
        }
        else
        {
            _wd = 0;
            _daze_chance = 0;
        }

        if (_is_player_owner)
        {
            if (_qol_dual_ranged)
            {
                if (throw_count == 2)
                    _qol_throw_mode = 1;
                else
                    _qol_throw_mode = 2;
            }
            else if (_qol_dual_crossbow || _qol_mixed)
                _qol_throw_mode = 1;
        }

        __qol_throw_mode_to_use = _qol_throw_mode;
        __qol_weapon_damage_delta = _wd;
        __qol_daze_chance_delta = _daze_chance;

        with (owner)
        {
            Weapon_Damage += other.__qol_weapon_damage_delta;
            Daze_Chance += other.__qol_daze_chance_delta;
            scr_skill_call_passive(o_pass_skill_precision, id);
            other.__qol_last_arrow = scr_throw(other.__qol_target_to_shoot, false, other.target, other.__qol_throw_mode_to_use);
            scr_setside(other.__qol_target_to_shoot);
        }

        _arrow = __qol_last_arrow;

        var _qol_arrows = [];

        if (instance_exists(owner) && variable_instance_exists(owner, "__qol_throw_arrows"))
            _qol_arrows = owner.__qol_throw_arrows;

        if (instance_exists(owner) && variable_instance_exists(owner, "__qol_throw_mode"))
            _qol_mode_name = owner.__qol_throw_mode;

        if (array_length(_qol_arrows) == 0 && _arrow != noone && _arrow != -4 && instance_exists(_arrow))
            array_push(_qol_arrows, _arrow);

        if (array_length(_qol_arrows) > 0)
        {
            target = _target;
            var _qol_registered_arrows = 0;
            var _will_repeat = !(throw_count == 1 || is_crossbow);
            var _turn_arrow_index = -1;

            if (!_will_repeat)
                _turn_arrow_index = array_length(_qol_arrows) - 1;

            for (var _qol_i = 0; _qol_i < array_length(_qol_arrows); _qol_i++)
            {
                var _qol_arrow = _qol_arrows[_qol_i];

                if (_qol_arrow != noone && _qol_arrow != -4 && instance_exists(_qol_arrow))
                {
                    array_push(arrow_id_array, _qol_arrow);
                    _qol_registered_arrows++;
                    __qol_arrow_skip_turn = (_qol_i == _turn_arrow_index);

                    with (_qol_arrow)
                    {
                        skip_turn = other.__qol_arrow_skip_turn;
                        is_skill = true;
                    }
                }
            }

            if (!variable_instance_exists(id, "__qol_pending_arrows"))
                __qol_pending_arrows = 0;

            __qol_pending_arrows += _qol_registered_arrows;
        }
    }

    var _qol_valid_arrow = (_arrow != noone && _arrow != -4 && instance_exists(_arrow));

    if (!(throw_count == 1 || is_crossbow))
        alarm[0] = 15;

    throw_count--;

    if (is_crossbow && _qol_valid_arrow)
    {
        throw_count = 0;

        if (!_is_player_owner)
            crossbowIsLoaded = true;
        else if (_qol_mode_name == "")
            scr_crossbow_insert_bolt(false, false, false);
    }

    if (!_qol_valid_arrow)
        event_inherited();
}
else
{
    turn_change = true;
    event_inherited();
}
