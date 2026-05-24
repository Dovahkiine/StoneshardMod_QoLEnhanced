function scr_attack_result_crit_aoe(argument0, argument1, argument2, argument3)
{
    var _slot = o_inv_right_hand.children;
    var _isShootingWeapon = false;
    
    if (argument1 && scr_is_weapon_type_shooting())
        _isShootingWeapon = true;
    
    if (!_isShootingWeapon && _slot > 0 && _slot.equipped)
    {
        var _target_array = scr_half_radialAOE(argument0);
        var _target_execute_array = [];
        var _length = array_length(_target_array);
        
        for (var i = 0; i < _length; i++)
        {
            var _target_point = _target_array[i];
            
            if (_target_point == argument0)
                continue;
            
            if (_target_point > 0 && _target_point != id && scr_can_be_broken(_target_point))
            {
                var _can_attack = true;
                var _target_execute_array_length = array_length(_target_execute_array);
                
                for (var j = 0; j < _target_execute_array_length; j++)
                {
                    if (_target_execute_array[j] == _target_array[i])
                    {
                        _can_attack = false;
                        break;
                    }
                }
                
                if (_can_attack)
                {
                    is_aoe_attack = true;
                    force_attack = true;
                    scr_atr_calc_combat();
                    scr_attack(_target_point, argument2, argument3);
                    force_attack = false;
                    is_aoe_attack = false;
                    array_push(_target_execute_array, _target_point);
                }
            }
        }
        
        var _dir = instance_exists(argument0) ? point_direction(x, y, argument0.x, argument0.y) : 0;
        
        with (instance_create_depth(x, y, 0, o_hit_mass))
        {
            image_angle = _dir;
            
            if (scr_is_weapon_type_any_hand("2hStaff"))
                sprite_index = s_stavesroundattack;
            else if (scr_is_weapon_type_any_hand("2haxe"))
                sprite_index = s_gaxeroundattack;
            else if (scr_is_weapon_type_any_hand("2hmace"))
                sprite_index = s_gmaceroundattack;
        }
    }
}
