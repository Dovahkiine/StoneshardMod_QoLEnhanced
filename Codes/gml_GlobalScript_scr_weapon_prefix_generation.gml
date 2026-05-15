function scr_weapon_prefix_generation(argument0, argument1, argument2, argument3, argument4)
{
    // ✅ 使用 argument 参数，而不是实例变量
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
    
    // ✅ 处理未定义的 max_stack
    if (argument4 == undefined)
        argument4 = 1;
    
    ds_map_add(global.weapon_stackable, argument0, argument4);
}