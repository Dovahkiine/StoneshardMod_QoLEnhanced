function scr_item_stack_build(argument0, argument1) {
    // 手动重建原版的默认参数逻辑
    if (argument0 == undefined)
        argument0 = false;
    if (argument1 == undefined)
        argument1 = owner;

    if (size_can_change)
        scr_item_stack_choose_sprite(argument0, argument1);

    if (!forced_drop)
        scr_item_stack_get_index();
}

function scr_item_stack_choose_sprite(argument0, argument1, argument2) {
    // 手动重建原版的默认参数逻辑
    if (argument0 == undefined)
        argument0 = false;
    if (argument1 == undefined)
        argument1 = owner;
    if (argument2 == undefined)
        argument2 = true;

    var _container = argument1;

    if (instance_exists(argument1))
        _container = argument1.object_index;

    if (select)
        argument2 = false;

    s_index = scr_item_stack_get_sprite(stack, object_index, _container);

    if (s_prev_index != s_index)
    {
        if (argument2)
            scr_item_cells_update(id, false);

        if (argument0 && !equipped && !is_deactivated) {
            if (!slotDestroyed) {
                if (!scr_inventory_add(argument1, id)) {
                    forced_drop = true;
                    event_user(15);
                }
            }
        }
        else {
            event_user(1);

            if (argument2 && !equipped)
                scr_item_cells_update(id, true);
        }

        draw_stack_shift = sprite_get_height(s_index) - 11;
        s_prev_index = s_index;
    }
}

// 这里是饲料的堆叠贴图显示逻辑
function scr_item_stack_get_sprite(argument0, argument1, argument2) {
    // 手动重建原版的默认参数逻辑
    if (argument0 == undefined)
        argument0 = stack;
    if (argument1 == undefined)
        argument1 = object_index;
    if (argument2 == undefined)
        argument2 = object_index;

    var _sprite = object_get_sprite(argument1);

    if (argument1 == o_inv_caravan_fodder || argument1 == o_loot_caravan_fodder) {
        var _base = (argument1 == o_inv_caravan_fodder) ? "s_inv_fodder" : "s_loot_fodder";

        if (argument0 <= 100)
            return __asset_get_index(_base + "01");

        if (argument0 <= 500)
            return __asset_get_index(_base + "02");

        if (argument0 <= 999)
            return __asset_get_index(_base + "03");

        return __asset_get_index(_base + "04");
    }
    else {
        var _spr_name = sprite_get_name(_sprite);

        if (argument0 > 3)
            _sprite = sprite_get_index(string_replace_all(_spr_name, "01", "02"), _sprite);
    }

    return _sprite;
}

function scr_item_stack_get_index() {
    if (object_is(object_index, o_inv_gold_parent)) {
        if (stack < 4)
            i_index = stack - 1;
        else if (stack < (stack_limit * 0.3))
            i_index = floor(lerp(2, 6, stack / (stack_limit * 0.3)));
        else
            i_index = 6;
    }
    else if (object_is(object_index, o_inv_sling_ammo_parent)) {
        if (stack < 3)
            i_index = stack - 1;
        else if (stack < (stack_limit * 0.75))
            i_index = floor(lerp(2, 6, stack / (stack_limit * 0.75)));
        else
            i_index = 6;
    }
    else if (stack < stack_limit) {
        if (stack < 3)
            i_index = stack - 1;
        else if (stack < (stack_limit * 0.5))
            i_index = floor(lerp(2, 5, stack / (stack_limit * 0.5)));
        else
            i_index = 5;
    }
    else {
        i_index = 5;
    }

    ds_map_replace(data, "i_index", i_index);
}
