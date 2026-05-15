function scr_crossbow_insert_bolt(argument0, argument1, argument2)
{
    if (argument0 == undefined) argument0 = true;
    if (argument1 == undefined) argument1 = false;
    if (argument2 == undefined) argument2 = true;

    // 收集所有需要装填的十字弩（左右手中 bolt 为空的）
    var _crossbows = [];

    with (o_weapon_slot_parent)
    {
        var _children = argument1 ? deactivated_children : children;
        
        with (_children)
        {
            if (haveAmmunitionSlot && isCrossbow)
            {
                var _bolt = scr_inv_atr("bolt");
                
                if (_bolt == "" || __is_undefined(_bolt))
                    array_push(_crossbows, id);
            }
        }
    }
    
    if (array_length(_crossbows) == 0)
        return -4;
    
    scr_noise_produce(scr_noise_crossbow_reload(), o_player.grid_x, o_player.grid_y);
    var _ammo_index = 0;
    var _crossbow_count = array_length(_crossbows);
    
    // 第一来源：装备弹药槽（o_inv_ammunition_parent）
    // 仅接受名称含 "bolt" 的弩箭，过滤掉箭矢/石块
    with (o_inv_ammunition_parent)
    {
        if (stack > 0 && slot == "bolt")
        {
            if(owner.object_index == o_inventory || equipped || (argument1 && is_deactivated)){
                var _name = object_get_name(object_index);
                while (_ammo_index < _crossbow_count && stack > 0)
                {
                    if (instance_exists(o_pass_skill_thrift) && o_pass_skill_thrift.is_open)
                    {
                        if irandom(100) < 50 // 50%概率不消耗弹药
                            stack--;
                    }
                    else
                        stack--;
                    with (_crossbows[_ammo_index])
                            scr_inv_atr_set("bolt", _name);
                    _ammo_index++;
                }
            }
        }
    }
    
    // 第二来源：装备的箭袋（o_inv_quiver_parent）
    if (_ammo_index < _crossbow_count)
    {
        with (o_inv_quiver_parent)
        {
            if((owner.object_index == o_inventory && slot == "bolt") || equipped || (argument1 && is_deactivated))
            {
                var _loot_list = ds_map_find_value(data, "lootList");
                
                while (_ammo_index < _crossbow_count && ds_list_size(_loot_list) > 0)
                {
                    var _item      = ds_list_find_value(_loot_list, 0);
                    var _item_name = ds_list_find_value(_item, 0);
                    if (ds_list_find_value(_item, 6) <= 0) break;

                    if (instance_exists(o_pass_skill_thrift) && o_pass_skill_thrift.is_open)
                    {
                        if irandom(100) < 50 // 50%概率不消耗弹药
                            ds_list_set_post(_item, 6, ds_list_find_value(_item, 6) - 1);
                    }
                    else
                        ds_list_set_post(_item, 6, ds_list_find_value(_item, 6) - 1);
                    with (_crossbows[_ammo_index])
                        scr_inv_atr_set("bolt", _item_name);
                    
                    if (ds_list_find_value(_item, 6) == 0)
                    {
                        ds_list_delete(_loot_list, 0);
                        _item = __dsDebuggerListDestroy(_item);
                        scr_sort_item_in_container(_loot_list);
                    }
                
                    _ammo_index++;
                }
                break;
            }
        }
    }
    
    if (_ammo_index > 0)
    {
        with (o_player)
        {
            scr_guiAnimation(s_gui_anim_crossbow_reload, 1, 1, false);
            scr_actionsLog("crossbowReload", [scr_actionsLogGetName(id)]);
            scr_audio_play_at(choose(snd_crossbow_charge_1, snd_crossbow_charge_2, snd_crossbow_charge_3));
        }
        
        if (argument0)
            scr_allturn();
        
        if (argument2)
            scr_atr_calc(o_player);
    }

    return _ammo_index;
}
