function scr_consum_food_change(argument0)
{
    if (argument0 == undefined)
        argument0 = 1;

    if (can_change && roomEntityTag == "drop")
    {
        var _fresh = ds_map_find_value(data, "Fresh");
        
        if (__is_undefined(_fresh))
            return false;
        
        var _previousFresh = _fresh;
        var _isLoot = object_is_ancestor(object_index, o_consument_loot);
        
        if (!_isLoot)
        {
            if (instance_exists(owner))
            {
                if (object_is_ancestor(owner.object_index, o_stash_inventory))
                {
                    if (scr_caravanUpgradeIsOpen("Spices"))
                        argument0 *= 0.001;
                }
                else if (instance_exists(o_container) && !o_container.can_spoil)
                {
                    if (owner.object_index == o_container)
                    {
                        ds_map_delete(data, "Timestamp");
                        return false;
                    }
                }
            }
        }
        
        _fresh = max(_fresh - argument0, 0);
        
        if (!_isLoot && _fresh == 5)
        {
            if (object_index == o_inv_bomb_bee)
                scr_actionsLog("beebombSpoilageSoon", []);
            else
                scr_actionsLog("foodSpoliageSoon", [scr_actionsLogGetName(id)]);
        }
        
        ds_map_replace(data, "Fresh", _fresh);
        ds_map_replace(data, "Timestamp", scr_timeGetTimestamp());
        
        if (!_fresh)
        {
            var _spr = 1;
            
            if (!_isLoot)
            {
                if (object_index == o_inv_bomb_bee)
                    scr_actionsLog("beebombSpoilage", []);
                else
                    scr_actionsLog("foodSpoliage", [scr_actionsLogGetName(id)]);
                
                if (sprite_get_number(s_index) > 2)
                    _spr = i_index;
            }
            else if (image_number > 2)
            {
                _spr = i_index;
            }
            
            var _objectName = object_get_name(object_index);
            
            if (string_ends_with(_objectName, "_raw"))
            {
                _objectName = string_replace(_objectName, "_raw", "");
                _spr = 0;
            }
            else if (string_ends_with(_objectName, "_fried"))
            {
                _objectName = string_replace(_objectName, "_fried", "");
            }
            else if (string_ends_with(_objectName, "_cooked"))
            {
                _objectName = string_replace(_objectName, "_cooked", "");
            }
            else if (__asset_get_index(_objectName + "_fried") > -1)
            {
                _spr = 0;
            }
            
            var _object = __asset_get_index(_objectName + "_rot");
            var _charge = charge;
            var _select = select;
            
            if (!_isLoot)
            {
                var _cell = guiParent;
                var _owner = owner;
            }
            
            scr_item_destroy(id, false);
            
            if (_object)
            {
                if (!_isLoot)
                {
                    with (o_craftingFoodMenu)
                    {
                        with (foodContainer)
                            contentType = o_inv_dish;
                    }
                    
                    with (scr_inventory_add_item(_object, _owner))
                    {
                        charge = _charge;
                        i_index = _spr;
                        ds_map_replace(data, "charge", charge);
                        ds_map_replace(data, "i_index", i_index);
                        scr_consum_food_choose_plate();
                        
                        if (i_index == 0)
                            plate = -4;
                        
                        if (!forced_drop)
                        {
                            scr_item_cells_update(id, false);
                            scr_item_attach_to_cell(id, _cell);
                            event_user(1);
                            scr_item_placed();
                        }
                    }
                    
                    with (o_craftingFoodMenu)
                    {
                        with (foodContainer)
                            contentType = o_loot;
                    }
                }
                else
                {
                    with (scr_loot_drop(x, y, _object))
                    {
                        event_user(2);
                        event_user(1);
                        i_index = _spr;
                        charge = _charge;
                        ds_map_replace(data, "charge", charge);
                        ds_map_replace(data, "i_index", i_index);
                        image_index = i_index;
                    }
                }
            }
            else
            {
                show_error_message("ROTTED ITEMS ERROR", "Object not found (" + _objectName + "_rot)");
            }
        }
        
        with (o_craftingFoodMenu)
            event_user(3);
    }
}
