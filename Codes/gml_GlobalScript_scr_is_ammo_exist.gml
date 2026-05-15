function scr_is_ammo_exist(argument0)
{
    var _crossbow = false;
    if (argument0 == undefined) argument0 = 1;
    if (argument0 == 99)
    {
        argument0 = 1;
        _crossbow = true; // 仅检查是否存在可用弩箭时才考虑十字弩的情况（不干扰常规弹药检查）
    }

    var _has_crossbow = _crossbow && scr_crossbow_is_armed() != -4;

    // 一次遍历所有箭袋，内部按类型分路
    with (o_inv_quiver_parent)
    {
        if ((owner.object_index == o_inventory) || equipped)
        {
            if (object_is(object_index, o_inv_bolt_quiver_parent))
            {
                if (_has_crossbow)
                {
                    var _loot_list = ds_map_find_value(data, "lootList");
                    if (ds_list_size(_loot_list) > 0)
                        return true;
                }
            }
            else
            {
                var _loot_list = ds_map_find_value(data, "lootList");
                var _size = ds_list_size(_loot_list);

                if (_size > 0)
                {
                    var _arrow_count = 0;
                    for (var i = 0; i < _size; i++)
                    {
                        var _loot = ds_list_find_value(_loot_list, i);
                        _arrow_count += ds_list_find_value(_loot, 6);
                        if (_arrow_count >= argument0)
                            return true;
                    }
                }
            }
        }
    }

    // 装备弹药槽 — 弓箭
    with (o_inv_arrows_parent)
    {
        if (((owner.object_index == o_inventory) || equipped) && stack >= argument0)
            return true;
    }

    // 装备弹药槽 — 投石索
    with (o_inv_sling_ammo_parent)
    {
        if (((owner.object_index == o_inventory) || equipped) && stack >= argument0)
            return true;
    }

    // 弩箭：散装弹药槽 + 已装填状态
    if (_has_crossbow)
    {
        with (o_inv_ammunition_parent)
        {
            if (((owner.object_index == o_inventory) || equipped)
                && slot == "bolt" && stack >= argument0)
                return true;
        }

        if (scr_crossbow_is_armed())
            return true;
    }

    return false;
}