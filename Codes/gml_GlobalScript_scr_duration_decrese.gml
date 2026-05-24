function scr_duration_decrese(argument0, argument1, argument2, argument3 = "")
{
    var _Armordamage = 1;
    
    if (instance_exists(argument1) && instance_exists(argument2))
    {
        if (object_is_ancestor(argument2.object_index, o_unit))
            _Armordamage = 1 + (argument2.Armor_Damage / 100);
    }
    
    var value = argument0 * _Armordamage;
    scr_duration_decrese_simple(value, argument1, argument3);
}

function scr_duration_decrese_shield(argument0)
{
    var _maxBlockPower = 0;
    var _blockItem = -4;
    
    with (o_weapon_slot_parent)
    {
        with (children)
        {
            var _Power = scr_inv_param("Block_Power", id);
            var _IsShield = type == "shield";
            var _CurrentIsShield = _blockItem != -4 && _blockItem.type == "shield";
            
            if (_IsShield && !_CurrentIsShield)
            {
                _maxBlockPower = _Power;
                _blockItem = id;
            }
            else if (_IsShield && _CurrentIsShield)
            {
                if (_Power > _maxBlockPower)
                {
                    _maxBlockPower = _Power;
                    _blockItem = id;
                }
                else if (_Power == _maxBlockPower && scr_chance_value(50))
                {
                    _blockItem = id;
                }
            }
            else if (_Power > _maxBlockPower && !_CurrentIsShield)
            {
                _maxBlockPower = _Power;
                _blockItem = id;
            }
            else if (_Power == _maxBlockPower && !_CurrentIsShield && scr_chance_value(50))
            {
                _blockItem = id;
            }
        }
    }
    
    if (_blockItem != -4)
        scr_duration_decrese(_tmpBlockReduction * 0.01, _blockItem, argument0, "block");
}
