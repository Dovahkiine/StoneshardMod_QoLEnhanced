if (instance_exists(o_inv_right_hand) && instance_exists(o_inv_left_hand))
{
    var _rh_child = o_inv_right_hand.children;
    var _lh_child = o_inv_left_hand.children;
    if (!_rh_child || !_lh_child)
    {
        instance_destroy();
        exit;
    }
    else if (instance_exists(_rh_child) && instance_exists(_lh_child))
    {
        if (__is_undefined(ds_map_find_value(_rh_child.data, "DMG")) || __is_undefined(ds_map_find_value(_lh_child.data, "DMG")))
        {
            instance_destroy();
            exit;
        }
    }
}
else
{
    instance_destroy();
    exit;
}
