function scr_inv_container_add(argument0, argument1, argument2, argument3)
{
	// 手动重建原版的默认参数逻辑
    if (argument0 == undefined)
        argument0 = other.id;
    if (argument1 == undefined)
        argument1 = -4;
    if (argument2 == undefined)
        argument2 = false;
    if (argument3 == undefined)
        argument3 = true;

    if (!instance_exists(argument0))
        return -4;

    if (argument1 == -4)
        argument1 = ds_map_find_value(data, "lootList");

    var _free_place_array = [];

    if (!argument2)
        var _cellsDataArray = scr_inventory_get_cell_param();
    else
        _cellsDataArray = [[10, 20, o_inv_slot]];

    var _cells_data_size = array_length(_cellsDataArray);

    for (var n = 0; n < _cells_data_size; n++)
    {
        var _cell_x_size = _cellsDataArray[n][0];
        var _cell_y_size = _cellsDataArray[n][1];
        var _contentType = _cellsDataArray[n][2];
        var _cell_x = 1;
        var _cell_y = 1;

        if (!scr_item_can_add_to_container(_contentType, argument0, false))
            continue;

        for (var i = 0; i < _cell_x_size; i++)
        {
            for (var j = 0; j < _cell_y_size; j++)
                _free_place_array[i][j] = 0;
        }

        var _size = ds_list_size(argument1);

        for (var k = 0; k < _size; k++)
        {
            var _loot = ds_list_find_value(argument1, k);
            var _cell_container = ds_list_find_value(_loot, 2);

            if (_cell_container == n || _cell_container == -4)
            {
                var _id_name = ds_list_find_value(_loot, 0);
                var _cell = ds_list_find_value(_loot, 3);
                var _asset = __asset_get_index(_id_name);

                if (argument3 && instance_exists(argument0) && argument0.can_stack)
                    scr_item_stack_container(argument0, _id_name, _loot, argument1, k);

                if (instance_exists(argument0))
                {
                    if (_asset != -1)
                    {
                        if (_asset == o_inv_caravan_fodder || object_is(_asset, o_inv_sling_ammo_parent))
                        {
                            var _stack = ds_list_find_value(_loot, 6);
                            var _sprite = scr_item_stack_get_sprite(_stack, _asset, object_index);
                        }
                        else
                        {
                            _sprite = object_get_sprite(_asset);
                        }
                    }
                    else
                    {
                        _sprite = scr_item_get_asset(_id_name, "inv_sprite");
                    }

                    if (_cell == -4)
                        _cell = k;

                    var _x = _cell % _cell_x_size;
                    var _y = _cell div _cell_x_size;
                    _cell_x = sprite_get_width(_sprite) div 27;
                    _cell_y = sprite_get_height(_sprite) div 27;

                    for (var i = 0; i < _cell_x; i++)
                    {
                        for (var j = 0; j < _cell_y; j++)
                            _free_place_array[_x + i][_y + j] = 1;
                    }
                }
            }
        }

        if (instance_exists(argument0))
        {
            var _cell = scr_inv_find_free_cell(argument0, _free_place_array, _cell_x_size, _cell_y_size);

            if (_cell != -4)
                return [_cell, n];
        }
        else
        {
            return -4;
        }
    }

    return -4;
}

function scr_item_stack_container(argument0, argument1, argument2, argument3, argument4)
{
    var gold_left = argument0.stack;
    var _stack_limit = argument0.stack_limit;

    if (argument1 == object_get_name(argument0.object_index))
    {
        var _stack = ds_list_find_value(argument2, 6);
        var _asset = __asset_get_index(argument1);

        if (_asset == o_inv_caravan_fodder)
            _stack_limit = scr_item_get_stack_limit(_stack, _stack_limit);
        else if (object_is(_asset, o_inv_sling_ammo_parent))
            _stack_limit = scr_sling_ammo_get_stack_limit(_stack, argument2, argument3, argument4);

        _stack += gold_left;

        if (_stack > _stack_limit)
        {
            gold_left = abs(_stack_limit - _stack);
            _stack = _stack_limit;

            if (variable_instance_exists(id, "data") && argument1 == "o_inv_gold")
                scr_stack_data_replace(ds_list_find_value(argument2, 6), _stack, data);

            ds_list_set(argument2, 6, _stack);
        }
        else
        {
            gold_left = 0;

            if (variable_instance_exists(id, "data") && argument1 == "o_inv_gold")
                scr_stack_data_replace(ds_list_find_value(argument2, 6), _stack, data);

            ds_list_set(argument2, 6, _stack);
        }

        with (argument0)
        {
            stack = gold_left;

            if (gold_left <= 0)
            {
                audio_play_sound(drop_gui_sound, 4, 0);
                instance_destroy();
            }
            else
            {
                scr_item_stack_build();
            }
        }
    }
}

function scr_inv_find_free_cell(argument0, argument1, argument2, argument3)
{
    var _cells_x = sprite_get_width(argument0.s_index) div 27;
    var _cells_y = sprite_get_height(argument0.s_index) div 27;
    var _can_add = false;
    var _cell = -4;

    for (var i = 0; i < argument2; i++)
    {
        for (var j = 0; j < argument3; j++)
        {
            var _place_is_free = false;
            _cell = (argument2 * j) + i;

            if (argument1[i][j] == 0)
            {
                _place_is_free = true;

                if ((i + _cells_x) > argument2 || (j + _cells_y) > argument3)
                {
                    _place_is_free = false;
                }
                else
                {
                    for (var k = 0; k < _cells_x; k++)
                    {
                        for (var n = 0; n < _cells_y; n++)
                        {
                            if (argument1[i + k][j + n] != 0)
                                _place_is_free = false;
                        }
                    }
                }
            }

            if (_place_is_free)
            {
                _can_add = true;
                break;
            }
        }

        if (_can_add)
            break;
    }

    if (!_can_add)
        _cell = -4;

    return _cell;
}

function scr_container_add_new_item(argument0, argument1, argument2, argument3, argument4, argument5, argument6)
{
    // 手动重建原版的默认参数逻辑
    if (argument1 == undefined)
        argument1 = -4;
    if (argument2 == undefined)
        argument2 = -4;
    if (argument3 == undefined)
        argument3 = -4;
    if (argument4 == undefined)
        argument4 = false;
    if (argument5 == undefined)
        argument5 = -4;
    if (argument6 == undefined)
        argument6 = -4;

    var is_add = false;

    if (argument3 == -4)
        argument3 = ds_map_find_value(data, "lootList");

    if (!is_real(argument0))
    {
       var _item = scr_inventory_add_weapon(argument0, -4, true, false);
    }
    else
    {
        _item = scr_inventory_add_item(argument0, id, argument1, true, -4, false);
        argument0 = object_get_name(argument0);
    }

    if (_item)
    {
        var _cell = -4;
        var _container_index = 0;
        var _cellIndex = scr_inv_container_add(_item, argument3, argument4);

        if (_cellIndex != -4)
        {
            _cell = _cellIndex[0];
            _container_index = _cellIndex[1];
        }

        if (instance_exists(_item))
        {
            argument1 = _item.stack;
        }
        else
        {
            is_add = true;
            argument1 = 0;
        }

        if (argument1 == 0)
            is_add = true;

        if (_cell != -4)
        {
            if (argument2 == -4)
                argument2 = _item.charge;

            if (argument6 == -4)
                argument6 = _item.data;

            // 0.9.4.22.1 原版兼容：物品从有主容器转入容器记录时，将 HasOwner 从“有主”标记切到“已处理”标记。
            var _has_owner = ds_map_find_value(argument6, "HasOwner");

            if (_has_owner == 1 >> 0)
                ds_map_replace(argument6, "HasOwner", 2 >> 0);

            var _item_list = scr_save_item_single(argument0, ds_map_clone(argument6), _container_index, _cell, _item.i_index, argument2, argument1, false, false, "N/A");
            ds_list_add(argument3, _item_list);
            ds_list_mark_as_list(argument3, ds_list_size(argument3) - 1);
            is_add = true;
        }

        instance_destroy(_item);

        if (argument0 == "o_inv_gold" && _cellIndex != -4)
        {
            if (argument5 == -4)
            {
                if (variable_instance_exists(object_index, "data"))
                    argument5 = data;
            }

            if (argument5 != -4)
                scr_stack_data_replace(0, argument1, argument5);
        }
    }

    stack_left = argument1;
    return is_add;
}

function scr_container_add_gold(argument0, argument1, argument2)
{
    // 手动重建原版的默认参数逻辑
    if (argument0 == undefined)
        argument0 = 1000;
    if (argument1 == undefined)
        argument1 = o_inv_gold;
    if (argument2 == undefined)
        argument2 = 1000;

    var _gold_left = argument0;

    if (argument0 > argument2)
    {
        var _cell_stack = argument0 div argument2;

        repeat (_cell_stack)
        {
            if (scr_container_add_new_item(argument1, argument2))
                _gold_left -= argument2;
            else
                return _gold_left - (argument2 - stack_left);
        }

        var _gold = argument0 % argument2;

        if (_gold > 0)
        {
            if (scr_container_add_new_item(argument1, _gold))
                _gold_left -= _gold;
            else
                _gold_left -= (_gold - stack_left);
        }
    }
    else if (_gold_left > 0)
    {
        if (scr_container_add_new_item(argument1, argument0))
            _gold_left -= argument0;
        else
            _gold_left -= (argument0 - stack_left);
    }

    return _gold_left;
}

function scr_stack_data_replace(argument0, argument1, argument2)
{
    var _stack = ds_map_find_value_ext(argument2, "Stack", 0);
    ds_map_replace(argument2, "Stack", (_stack - argument0) + argument1);
}

function scr_caravan_stash_add_new_item(argument0, argument1)
{
    // 手动重建原版的默认参数逻辑
    if (argument1 == undefined)
        argument1 = -4;

    var _list_array = [global.caravanStashDataList1];

    if (scr_caravanUpgradeIsOpen("Chest2"))
        array_push(_list_array, global.caravanStashDataList2);

    if (scr_caravanUpgradeIsOpen("Chest3"))
        array_push(_list_array, global.caravanStashDataList3);

    if (scr_caravanUpgradeIsOpen("Chest4"))
        array_push(_list_array, global.caravanStashDataList4);

    var _array_size = array_length(_list_array);

    for (var i = 0; i < _array_size; i++)
    {
        var _loot_list = _list_array[i];
        var _is_add = scr_container_add_new_item(argument0, argument1, -4, _loot_list, true);

        if (_is_add)
            break;
    }
}

function scr_item_get_stack_limit(argument0, argument1, argument2)
{
    if (argument2 == undefined)
        argument2 = [100, 500, 999];
    var _array = argument2;
    var _length = array_length(argument2);

    for (var i = 0; i < _length; i++)
    {
        if (argument0 <= _array[i])
        {
            if (_array[i] <= argument1)
                argument1 = _array[i];
        }
    }

    return argument1;
}

function scr_sling_ammo_get_stack_limit(argument0, argument1, argument2, argument3)
{
    var _stack_limit = 100;

    if (argument0 <= 5 && object_is(object_index, o_inv_sling_ammo_quiver_parent))
    {
        if (ds_list_find_value(argument1, 3) == 1)
        {
            _stack_limit = scr_item_get_stack_limit(argument0, _stack_limit, [5, 100]);
        }
        else if ((argument3 + 1) < ds_list_size(argument2))
        {
            var _next_loot = ds_list_find_value(argument2, argument3 + 1);

            if (ds_list_find_value(argument1, 2) == ds_list_find_value(_next_loot, 2))
                _stack_limit = scr_item_get_stack_limit(argument0, _stack_limit, [5, 100]);
        }
    }
    else
    {
        _stack_limit = scr_item_get_stack_limit(argument0, _stack_limit, [5, 100]);
    }

    return _stack_limit;
}
