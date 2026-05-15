// key sk-4ef9af951cb6418cb246f8383d48b4c1
function scr_cook_check_raw_ingredients()
{
    var items_to_check = [o_inv_meat_fat_raw, o_inv_whitefish_raw, o_inv_chicken_raw, o_inv_pinecap, o_inv_stool, o_inv_pennybun, o_inv_flyagaric, o_inv_potato, o_inv_toughmeat_raw, o_inv_tendermeat_raw, o_inv_sinewymeat_raw, o_inv_morsel_raw, o_inv_acorn, o_inv_chanterelle, o_inv_morel, o_inv_egg, o_inv_crabmeat_raw, o_inv_harpy_egg_raw, o_inv_mussel, o_inv_redfish_raw, o_inv_redfishalt_raw, o_inv_fishmorsel_raw, o_inv_gulon_liver, o_inv_harpy_stomach, o_inv_wolf_tongue, o_inv_moose_kidney, o_inv_wildegg, o_inv_puffball, o_inv_truffle, o_inv_azurecap, o_inv_rockeater_flesh_raw];

    var _size = array_length(items_to_check);
    
    for (var i = 0; i < _size; i++)
    {
        with (items_to_check[i])
        {
            if (owner == o_craftingFoodMenu.id)
                return true;
        }
    }
    
    return false;
}

function scr_cook_ingredients_salting(argument0)
{   
    if (argument0 == undefined) 
        argument0 = false;
        
    static _destroy_element = function(argument0)
    {
        scr_item_destroy(argument0);
    };
    
    var items_to_check = [o_inv_meat_fat_raw, o_inv_chicken_raw, o_inv_toughmeat_raw, o_inv_tendermeat_raw, o_inv_sinewymeat_raw, o_inv_morsel_raw, o_inv_crabmeat_raw, o_inv_whitefish_raw, o_inv_bear_fat, o_inv_redfish_raw, o_inv_redfishalt_raw, o_inv_fishmorsel_raw, o_inv_gulon_liver, o_inv_harpy_stomach, o_inv_wolf_tongue, o_inv_moose_kidney];
    var _size = array_length(items_to_check);
    var _salt_require = 1;
    var _salt_count = 0;
    var _salt_array = [];
    
    with (o_inv_salt)
    {
        if (owner == o_craftingFoodMenu.id)
        {
            _salt_array[_salt_count] = id;
            _salt_count++;
        }
    }
    
    for (var i = 0; i < _size; i++)
    {
        with (items_to_check[i])
        {
            if (owner == o_craftingFoodMenu.id)
            {
                if (!argument0)
                {
                    if (_salt_count >= _salt_require)
                        return true;
                }
                else if (_salt_count >= _salt_require)
                {
                    var _object_name = object_get_name(object_index);
                    var _suffix = "_raw";
                    var _position = string_pos(_suffix, _object_name);
                    var _object = __asset_get_index(string_delete(_object_name, _position, string_length(_suffix)) + "_salted");
                    
                    if (_object >= 0)
                    {
                        scr_inventory_change_item(_object);
                        array_foreach(_salt_array, _destroy_element, 0, _salt_require);
                        array_delete(_salt_array, 0, _salt_require);
                        _salt_count -= _salt_require;
                    }
                }
            }
        }
    }
    
    return false;
}

function scr_craft_forage(argument0)
{
    if (argument0 == undefined) 
        argument0 = false;

    var _target = -4;
    var items_to_check = [];
    
    with (o_inv_consum)
    {
        if (owner == o_craftingConsumsMenu.id && fodder_value != 0)
            array_push(items_to_check, id, fodder_value);
    }
    
    var _size = array_length(items_to_check);
    
    if (!argument0)
    {
        return _size > 0;
    }
    else
    {
        var _stack = 0;
        
        for (var i = 0; i < _size; i += 2)
        {
            var _item = items_to_check[i];
            var _item_stack = items_to_check[i + 1];
            
            with (_item)
            {
                _stack += _item_stack;
                scr_item_destroy();
            }
        }
        
        if (_stack > 0)
        {
            with (scr_inventory_add_item(o_inv_caravan_fodder, id, _stack, true, -4, false))
            {
                _target = id;
                
                if (!scr_inventory_add(other.id, id, [other.consumsContainer]))
                {
                    forced_drop = true;
                    event_user(15);
                }
            }
        }
    }
    
    return _target;
}

function scr_craft_trinket(arg0 = false)
{
    if (argument0 == undefined) 
        argument0 = false;
        
    var _target = -4;
    var _relic = o_inv_hilda_trinket;
    var _owner = o_craftingConsumsMenu.id;
    var items_to_check = [o_inv_gulon_liver, o_inv_troll_gland, o_inv_bear_fat, o_inv_harpy_stomach, o_inv_spider_eye, o_inv_horns_bison, o_inv_horns_deer, o_inv_horns_saiga, o_inv_wolf_tongue, o_inv_moose_kidney, o_inv_boar_tusks, o_inv_rockeater_gland, o_inv_ghoul_heart];
    
    if (instance_exists(_relic) && _relic.owner == _owner)
    {
        var _size = array_length(items_to_check);
        
        if (!argument0)
        {
            var _items_count = 0;
            
            for (var i = 0; i < _size; i++)
            {
                with (items_to_check[i])
                {
                    if (owner == _owner)
                    {
                        _items_count++;
                        break;
                    }
                }
            }
            
            if (_items_count >= 1)
                return true;
        }
        else
        {
            static _sort_function = function(arg0, arg1)
            {
                if (instance_exists(arg0.guiParent) && instance_exists(arg1.guiParent))
                    return arg0.guiParent.index > arg1.guiParent.index;
            };
            
            var _items_id_array = [];
            
            for (var i = 0; i < _size; i++)
            {
                with (items_to_check[i])
                {
                    if (owner == _owner)
                        array_push(_items_id_array, id);
                }
            }
            
            array_sort(_items_id_array, _sort_function);
            _size = array_length(_items_id_array);
            var _char_num = -1;
            var _current_char_count = 0;
            var _max_char_count = 0;
            
            with (o_inv_hilda_trinket)
            {
                _max_char_count = 15;
                
                for (var i = 0; i < 17; i++)
                {
                    if (!__is_undefined(ds_map_find_value(data, "Char" + string(i))))
                        _current_char_count++;
                    else
                        break;
                }
            }
            
            var _last_attribute = "";
            
            for (var i = 0; i < _size; i++)
            {
                var _attribute_name = "";
                var _attribute_value = 0;
                
                with (_items_id_array[i])
                {
                    var _attribute_array = scr_consum_hilda_enchant_assign();
                    _attribute_name = _attribute_array[0];
                    _attribute_value = _attribute_array[1];
                    
                    if (_last_attribute != _attribute_name)
                    {
                        with (o_inv_hilda_trinket)
                        {
                            if (!__is_undefined(ds_map_find_value(data, _attribute_name)))
                            {
                                for (var j = 0; j < 17; j++)
                                {
                                    var _key = "Char" + string(j);
                                    var _char = ds_map_find_value(data, _key);
                                    
                                    if (__is_undefined(_char))
                                        break;
                                    
                                    if (string_pos(_attribute_name, _char) != 0)
                                    {
                                        ds_map_delete(data, _attribute_name);
                                        ds_map_delete(data, _key);
                                        _char_num = j;
                                        break;
                                    }
                                }
                            }
                            else if (_current_char_count <= _max_char_count)
                            {
                                _char_num = _current_char_count;
                            }
                            else
                            {
                                _char_num = 15;
                                var _key = "Char0";
                                var _char = ds_map_find_value(data, _key);
                                _char = string_split_custom(_char, " ");
                                var _attr = _char[0];
                                ds_map_delete(data, _attr);
                                ds_map_delete(data, _key);
                                ds_map_set(data, "Char0", ds_map_find_value(data, "Char1"));
                                ds_map_set(data, "Char1", ds_map_find_value(data, "Char2"));
                                ds_map_delete(data, "Char2");
                            }
                            
                            scr_consum_char_add(_attribute_name, _attribute_value, _char_num, false);
                            _last_attribute = _attribute_name;
                        }
                        
                        scr_item_destroy();
                    }
                }
                
                if (_char_num != -1)
                    return o_inv_hilda_trinket.id;
            }
        }
    }
    
    return false;
}
