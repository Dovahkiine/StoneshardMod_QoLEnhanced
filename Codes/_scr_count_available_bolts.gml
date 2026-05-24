// 统计当前可用于十字弩装填的弩箭数量。
// argument0: 是否包含 deactivated 装备来源，默认 false。
function _scr_count_available_bolts(argument0)
{
    if (argument0 == undefined) argument0 = false;

    var _count = 0;

    with (o_inv_ammunition_parent)
    {
        var _owner_is_inventory = instance_exists(owner) && owner.object_index == o_inventory;

        if (stack > 0 && slot == "bolt" && (_owner_is_inventory || equipped || (argument0 && is_deactivated)))
            _count += stack;
    }

    with (o_inv_quiver_parent)
    {
        var _owner_is_inventory = instance_exists(owner) && owner.object_index == o_inventory;

        if (slot == "bolt" && (_owner_is_inventory || equipped || (argument0 && is_deactivated)))
        {
            var _loot_list = ds_map_find_value(data, "lootList");
            var _size = ds_list_size(_loot_list);

            for (var i = 0; i < _size; i++)
            {
                var _item = ds_list_find_value(_loot_list, i);
                _count += ds_list_find_value(_item, 6);
            }
        }
    }

    return _count;
}
