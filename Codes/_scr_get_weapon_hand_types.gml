// 返回双手武器类型数组 [rh_type, lh_type]
// 类型值: "crossbow" / "ranged" / "melee" / ""（空手）
function _scr_get_weapon_hand_types()
{
    var _rh = "melee", _lh = "melee";

    if (instance_exists(o_inv_right_hand))
    {
        var _rh_child = o_inv_right_hand.children;
        if (instance_exists(_rh_child) && _rh_child.equipped)
        {
            if (variable_instance_exists(_rh_child, "haveAmmunitionSlot") && _rh_child.haveAmmunitionSlot)
                _rh = _rh_child.isCrossbow ? "crossbow" : "ranged";
        }
    }

    if (instance_exists(o_inv_left_hand))
    {
        var _lh_child = o_inv_left_hand.children;
        if (instance_exists(_lh_child) && _lh_child.equipped)
        {
            if (variable_instance_exists(_lh_child, "haveAmmunitionSlot") && _lh_child.haveAmmunitionSlot)
                _lh = _lh_child.isCrossbow ? "crossbow" : "ranged";
        }
    }

    return [_rh, _lh];
}
