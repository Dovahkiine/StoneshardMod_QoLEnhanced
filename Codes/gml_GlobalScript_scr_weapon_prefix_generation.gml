// 参数：stat_name, slot, rarity, value_range_arg, max_stack, value_type
// value_type: 0=整数  1=0.5步进  2=0.2步进
function scr_weapon_prefix_generation(argument0, argument1, argument2, argument3, argument4, argument5)
{
    ds_map_add(global.weapon_slotmap, argument0, argument1);

    if (argument2 == 1)
        ds_map_add(global.weapon_common, argument0, argument0);
    else
        ds_map_add(global.weapon_rare, argument0, argument0);

    if (is_real(argument3))
    {
        var range = ds_list_create();
        ds_list_add(range, argument3);
        ds_list_add(range, argument3);
        ds_map_add(global.weapon_effect, argument0, range);
    }
    else if (is_array(argument3))
    {
        var range = ds_list_create();
        var length = array_length_1d(argument3);
        for (var i = 0; i < length; i++)
            ds_list_add(range, argument3[i]);
        ds_map_add(global.weapon_effect, argument0, range);
    }

    if (argument4 == undefined) argument4 = 1;
    ds_map_add(global.weapon_stackable, argument0, argument4);

    // ✅ 新增：写入值类型（缺省为 0 整数）
    var _vtype = argument5;
    if (_vtype == undefined) _vtype = 0;
    ds_map_add(global.weapon_value_type, argument0, _vtype);
}
