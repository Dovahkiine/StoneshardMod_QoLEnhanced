function scr_inventory_stack(argument0, argument1, argument2, argument3, argument4, argument5)
{	
    // 手动重建原版的默认参数逻辑
    if (argument1 == undefined)
        argument1 = id;
    if (argument2 == undefined)
        argument2 = true;
    if (argument3 == undefined)
        argument3 = false;
    if (argument4 == undefined)
        argument4 = true;
    if (argument5 == undefined)
        argument5 = false;
	
    with (argument1)
    {
        var _gold_left = stack;
        var _item_owner = owner;
        var _is_replace = true;
        var _is_ammunition = object_is_ancestor(object_index, o_inv_ammunition_parent);
        var _is_sling_ammo = object_is_ancestor(object_index, o_inv_sling_ammo_parent);
        var _is_gold = object_is_ancestor(object_index, o_inv_gold_parent);
        
        if (argument0 == _item_owner)
            _is_replace = false;
        
        if (!argument5)
        {
            if (!_is_ammunition || (owner.object_index != o_container_quiver && argument0.object_index != o_container_quiver && owner.object_index != o_container_sling_ammo && argument0.object_index != o_container_sling_ammo))
            {
                var _id_name = object_get_name(object_index);
                var _container_array = [];
                var _item_stack_limit = stack_limit;
                
                if (_is_gold)
                {
                    _container_array = [o_inv_moneybag, o_inv_bag_belt_parent, o_inv_casket_parent, o_inv_backpack_parent];
                }
                else if (_is_ammunition)
                {
                    with (o_inv_quiver_parent)
                    {
                        if (equipped)
                        {
                            array_push(_container_array, id);
                            break;
                        }
                    }
                    
                    with (o_inv_quiver_parent)
                    {
                        if (!equipped)
                            array_push(_container_array, id);
                    }
                }
                
                var _sorted_containers = scr_item_container_sort_by_stack(_container_array, argument0, _item_owner, _is_replace, argument3, argument2, _id_name);
                var _sorted_containers_length = array_length(_sorted_containers);
                
                for (var i = 0; i < _sorted_containers_length; i++)
                {
                    with (_sorted_containers[i])
                    {
                        var _lootList = ds_map_find_value(data, "lootList");
                        var _size = ds_list_size(ds_map_find_value(data, "lootList"));
                        var _container_id = id;
                        var _inventory_container = container_id;
                        
                        if (is_open)
                        {
                            if (!instance_exists(o_trade_inventory))
                                continue;
                            
                            with (argument1)
                            {
                                if (object_index == o_inv_gold)
                                {
                                    _gold_left = scr_item_stack_same(_gold_left, argument0, argument3, _is_replace, argument4, false);
                                    stack = _gold_left;
                                    
                                    if (_gold_left <= 0)
                                    {
                                        scr_item_destroy();
                                    }
                                    else if (scr_item_can_add_to_container(_inventory_container))
                                    {
                                        repeat (ceil(_gold_left / 2000))
                                        {
                                            var _stack_size = min(2000, _gold_left);
                                            
                                            if (scr_inventory_get_cell_free(_inventory_container) != -4)
                                            {
                                                scr_inventory_add_item(o_inv_gold, _inventory_container, _stack_size);
                                                _gold_left -= _stack_size;
                                                
                                                if (_gold_left <= 0)
                                                {
                                                    scr_item_destroy();
                                                    break;
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        else if (_gold_left)
                        {
                            repeat (max(1, (stack_limit / _item_stack_limit) - _size))
                            {
                                var _cell = -4;
                                var _container_index = 0;
                                var _cellIndex = scr_inv_container_add(argument1, _lootList);
                                
                                if (_cellIndex != -4)
                                {
                                    _cell = _cellIndex[0];
                                    _container_index = _cellIndex[1];
                                }
                                else
                                {
                                    if (!instance_exists(argument1))
                                    {
                                        _gold_left = 0;
                                    }
                                    else
                                    {
                                        with (argument1)
                                            _gold_left = stack;
                                    }
                                    
                                    break;
                                }
                                
                                if (_cell == -4)
                                {
                                    if (!instance_exists(other.id))
                                    {
                                        _gold_left = 0;
                                    }
                                    else
                                    {
                                        with (argument1)
                                            _gold_left = stack;
                                    }
                                }
                                
                                if (_cell == -4 || _gold_left == 0)
                                    break;
                                
                                with (argument1)
                                {
                                    _gold_left = stack;
                                    
                                    if (_gold_left > 0 && _cell != -4)
                                    {
                                        if (stack > stack_limit)
                                        {
                                            _gold_left = abs(stack_limit - stack);
                                            stack = stack_limit;
                                        }
                                        else
                                        {
                                            stack = _gold_left;
                                            _gold_left = 0;
                                        }
                                        
                                        var _item = scr_save_item_single(_id_name, ds_map_clone(data), _container_index, _cell, i_index, charge, stack, equipped, is_deactivated, "N/A");
                                        ds_list_add(_lootList, _item);
                                        ds_list_mark_as_list(_lootList, ds_list_size(_lootList) - 1);
                                        
                                        if (object_index == o_inv_gold)
                                            scr_stack_data_replace(0, stack, other.data);
                                        
                                        if (_gold_left <= 0)
                                        {
                                            scr_item_destroy();
                                            break;
                                        }
                                        else
                                        {
                                            stack = _gold_left;
                                        }
                                    }
                                }
                            }
                        }
                        
                        if (object_is(object_index, o_inv_quiver_parent))
                        {
                            if (object_is(object_index, o_inv_sling_ammo_quiver_parent))
                                scr_sort_sling_quiver(_lootList, cells_x_size * 2);
                            
                            script_execute(update_ammo_order);
                        }
                    }
                }
            }
        }
        
        if (_gold_left > 0)
        {
            _gold_left = scr_item_stack_same(_gold_left, argument0, argument3, _is_replace, argument4);
            
            if (_gold_left > 0)
            {
                _gold_left = scr_item_stack_same(_gold_left, argument0, argument3, _is_replace, argument4, false);
            }
            else
            {
                scr_item_destroy();
                return true;
            }
            
            if (_gold_left > 0)
            {
                stack = _gold_left;
                scr_item_stack_build(false);
                
                if (scr_item_can_add_to_container(argument0))
                {
                    if (scr_inventory_add(argument0))
                    {
                        scr_steal();
                        return true;
                    }
                }
            }
            else
            {
                scr_item_destroy();
                return true;
            }
        }
        else
        {
            return true;
        }
        
        return false;
    }
}

function scr_item_stack_same(argument0, argument1, argument2, argument3, argument4, argument5 = true)
{
    var _item = id;
    var _item_owner = owner;
    
    with (object_index)
    {
        if ((id != _item && (equipped || !argument5) && stack < stack_limit) && (!argument2 || owner == argument1))
        {
            if (owner != _item_owner || !argument3)
            {
                if (__is_undefined(ds_map_find_value(data, "delivery_time")))
                {
                    stack += argument0;
                    argument0 = 0;
                    
                    if (stack > stack_limit)
                    {
                        argument0 = abs(stack_limit - stack);
                        stack = stack_limit;
                    }
                    
                    scr_item_stack_build(argument4, argument1);
                }
            }
        }
        
        if (argument0 == 0)
            break;
    }
    
    return argument0;
}

function scr_item_container_sort_by_stack(argument0, argument1, argument2, argument3, argument4, argument5, argument6)
{   
    var _container0 = argument0;
    var _container_length = array_length(argument0);
    var _has_gold = false;
    var _container_info = [];
    var _inventory_id = o_inventory.id;
    var _id = id;
    
    for (var i = 0; i < _container_length; i++)
    {
        var _cont_obj = _container0[i];
        
        with (_cont_obj)
        {
            var _gold_total = 0;
            var _container_id = id;
            
            if (owner.object_index != o_trade_inventory && (equipped || !object_is_ancestor(object_index, o_inv_backpack_parent)) && (argument5 || (owner == argument1 && owner != _inventory_id)))
            {
                if ((owner != argument2 || !argument3) && (!argument4 || owner == argument1))
                {
                    if (!is_open)
                    {
                        var _lootList = ds_map_find_value(data, "lootList");
                        var _size = ds_list_size(ds_map_find_value(data, "lootList"));
                        
                        for (var j = 0; j < _size; j++)
                        {
                            var _item_list = ds_list_find_value(_lootList, j);
                            
                            if (ds_list_find_value(_item_list, 0) == argument6)
                                _gold_total += ds_list_find_value(_item_list, 6);
                        }
                        
                        if (_gold_total)
                            _has_gold = true;
                        
                        array_push(_container_info, [id, _gold_total]);
                    }
                    else
                    {
                        with (o_inv_consum)
                        {
                            if (owner == _container_id.container_id)
                                _gold_total += stack;
                        }
                        
                        if (_gold_total)
                            _has_gold = true;
                        
                        array_push(_container_info, [id, _gold_total]);
                    }
                }
            }
        }
    }
    
    if (_has_gold)
    {
        array_sort(_container_info, function(argument0, argument1)
        {
            var _container_info0 = argument0;
            var _container_info1 = argument1;
            return _container_info1[1] - _container_info0[1];
        });
    }
    
    var _container_info_length = array_length(_container_info);
    var _sorted_containers = [];
    
    for (var i = 0; i < _container_info_length; i++)
        array_push(_sorted_containers, _container_info[i][0]);
    
    return _sorted_containers;
}
