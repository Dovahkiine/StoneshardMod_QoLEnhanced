function _scr_qol_container_bonus_value(argument0)
{
    var _container_id = argument0;
    var _total_value = 0;
    
    with (all)
    {
        if (variable_instance_exists(id, "owner") && owner == _container_id)
        {
            var _stack = 1;
            var _item_value = 0;
            
            if (variable_instance_exists(id, "stack"))
                _stack = max(1, stack);
            
            if (variable_instance_exists(id, "base_price"))
                _item_value = max(_item_value, base_price);
            
            if (variable_instance_exists(id, "price"))
                _item_value = max(_item_value, price);
            
            _total_value += max(0, _item_value) * _stack;
        }
    }
    
    return _total_value;
}
