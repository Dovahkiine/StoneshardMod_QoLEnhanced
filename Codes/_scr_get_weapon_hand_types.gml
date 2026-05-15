// 返回双手武器类型数组 [rh_type, lh_type]
// 类型值: "crossbow" / "ranged" / "melee" / ""（空手）
function scr_get_weapon_hand_types()
{
    var _rh = "", _lh = "";

    if (instance_exists(o_inv_right_hand))
        with (o_inv_right_hand) with (children)
            if (equipped)
            {
                if (haveAmmunitionSlot)
                    _rh = isCrossbow ? "crossbow" : "ranged";
                else
                    _rh = "melee";
            }

    if (instance_exists(o_inv_left_hand))
        with (o_inv_left_hand) with (children)
            if (equipped)
            {
                if (haveAmmunitionSlot)
                    _lh = isCrossbow ? "crossbow" : "ranged";
                else
                    _lh = "melee";
            }

    return [_rh, _lh];
}