function _scr_qol_container_bonus(argument0, argument1, argument2, argument3, argument4)
{
    var _container_owner = argument0;
    var _container_id = argument1;
    var _loot_script = argument2;
    var _loot_script_key = argument3;
    var _loot_script_tier = argument4;
    
    if (!instance_exists(_container_owner) || !instance_exists(_container_id))
        return;
    
    var _is_quest = variable_instance_exists(_container_owner, "isQuest") && _container_owner.isQuest;
    
    if (_is_quest)
        return;
    
    if (_scr_qol_container_has_quest_item(_container_id))
        return;
    
    if (_loot_script == -4)
        return;
    
    var _base_value = _scr_qol_container_bonus_value(_container_id);
    if (_base_value <= 0)
        return;
    
    var _is_tomb = variable_instance_exists(_container_owner, "is_tomb") && _container_owner.is_tomb;
    
    var _target_bonus_value = min(5000, max(30, _base_value));
    var _bonus_value = 0;
    var _coin_value = 4;
    
    repeat (3)
    {
        var _pre_bone_count = 0;
        if (_is_tomb)
        {
            with (all)
            {
                if (variable_instance_exists(id, "owner") && owner == _container_id && _scr_qol_container_bonus_is_bone(object_index))
                    _pre_bone_count++;
            }
        }
        
        with (_container_id)
        {
            script_execute(_loot_script, _loot_script_key, _loot_script_tier);
            randomize();
        }
        
        if (_is_tomb)
        {
            var _current_bone_count = 0;
            with (all)
            {
                if (variable_instance_exists(id, "owner") && owner == _container_id && _scr_qol_container_bonus_is_bone(object_index))
                {
                    _current_bone_count++;
                    if (_current_bone_count > _pre_bone_count)
                        scr_item_destroy();
                }
            }
        }
        
        _bonus_value = _scr_qol_container_bonus_value(_container_id) - _base_value;
        if (_bonus_value >= _target_bonus_value)
            break;
    }
    
    if (_bonus_value < _target_bonus_value)
    {
        var _deficit = _target_bonus_value - _bonus_value;
        var _fallback_value = irandom_range(ceil(_deficit * 0.6), _deficit);
        var _coin_count = max(1, ceil(_fallback_value / _coin_value));

        with (_container_id)
        {
            scr_inventory_add_item(o_inv_old_coin, id, _coin_count);
        }
    }
}
