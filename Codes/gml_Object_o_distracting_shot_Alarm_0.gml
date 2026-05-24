if (instance_exists(owner))
{
    if (!is_player(owner))
    {
        if (first_move)
        {
            scr_skill_call_buff(o_b_suppression, owner);
            nearest_target = owner.target;
        }
    }
    else if (first_move)
    {
        scr_skill_call_buff(o_b_suppression, owner);
        nearest_target = -4;
        var _min_distance = 100;
        
        with (o_enemy)
        {
            if (visible && !Unbreakable && state == "attack")
            {
                var _distance = scr_tile_distance(other.owner, id);
                
                if (_distance < _min_distance && _distance <= other.owner.range)
                {
                    other.nearest_target = id;
                    _min_distance = _distance;
                }
            }
        }
        
        if (!nearest_target)
        {
            with (o_enemy)
            {
                if (visible && !Unbreakable && !is_o_NPC_ancestor)
                {
                    var _distance = scr_tile_distance(other.owner, id);
                    
                    if (_distance < _min_distance && _distance <= other.owner.range)
                    {
                        other.nearest_target = id;
                        _min_distance = _distance;
                    }
                }
            }
        }
    }
    
    turn_count = scr_tile_distance(owner, target);
    
    if (first_move)
    {
        first_move = false;
        var _arrow = -4;
        var _target = nearest_target;
        
        if (_target)
        {
            if (_target.visible)
            {
                var _wd = -60 + owner.AGL;
                var _immob = 40 + owner.STR;
                
                with (owner)
                {
                    force_attack = true;
                    _target = scr_shoot_target_miss(_target, id);
                    
                    if (_target)
                    {
                        Weapon_Damage += _wd;
                        Immob_Chance += _immob;
                        scr_skill_call_passive(o_pass_skill_precision, id);
                        scr_crossbow_insert_bolt(false, false, true);
                        _arrow = scr_throw(_target, false, other.nearest_target);
                        
                        with (_arrow)
                            is_skill = true;
                        
                        other.turn_change = false;
                        
                        if (isSlingman && _target.object_index != o_attacked_target)
                        {
                            if (is_player())
                                scr_skill_change_KD(o_skill_distracting_shot_ico, -2);
                            else
                                scr_skill_change_KD_enemy("Distracting_Shot", -2);
                        }
                    }
                }
            }
        }
        
        arrow = _arrow;
    }
    else if (turn_count > 0 && ds_list_empty(owner.lock_turn))
    {
        with (owner)
        {
            scr_movementDust();
            
            if (!scr_one_path_move(other.target, true, id, false))
                instance_destroy(other.id);
            
            with (o_fogrender)
                event_user(2);
        }
    }
    else
    {
        turn_count = 0;
    }
    
    if (turn_count)
        alarm[0] = 2;
    else if (!instance_exists(arrow) || arrow <= 0)
        event_inherited();
}
else
{
    event_inherited();
}
