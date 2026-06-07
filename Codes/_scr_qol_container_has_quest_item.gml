function _scr_qol_container_has_quest_item(argument0)
{
    var _container_id = argument0;
    var _has_quest_item = false;
    
    with (all)
    {
        if (_has_quest_item)
            continue;
        
        if (!variable_instance_exists(id, "owner") || owner != _container_id)
            continue;
        
        if (!variable_instance_exists(id, "data") || !ds_exists(data, ds_type_map))
            continue;
        
        var _id_name = ds_map_exists(data, "idName") ? ds_map_find_value(data, "idName") : "";
        if (_id_name == "" || !ds_map_exists(global.consum_stat_data, _id_name))
            continue;
        
        var _item_data = ds_map_find_value(global.consum_stat_data, _id_name);
        if (__is_undefined(_item_data) || !ds_exists(_item_data, ds_type_map))
            continue;
        
        if (ds_map_find_value(_item_data, "Subcat") == "quest")
        {
            _has_quest_item = true;
            break;
        }
    }
    
    return _has_quest_item;
}
