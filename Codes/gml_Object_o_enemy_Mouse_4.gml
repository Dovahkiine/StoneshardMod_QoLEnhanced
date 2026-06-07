if (global.unit_inspect_id == id)
{
    scr_exploreMenuOpen(id);
    exit;
}

if (keyboard_check(vk_shift) || scr_mouse_on_unit() != id)
    exit;

var _is_gui = instance_position(global.guiMouseX, global.guiMouseY, c_GUI);

if (_is_gui && _is_gui.object_index != o_context_button)
    exit;

if (Unbreakable)
    exit;

if (global.inv_select)
    exit;

if (global.skill_activate)
    exit;

if (instance_exists(o_enemy_path_debug))
    exit;

if (scr_instance_exists_in_list(o_b_untargetable))
    exit;

if (scr_is_cutscene())
    exit;

if (!is_allow_actions())
    exit;

if (!visible)
{
    var _freeCellCoordsArray = scr_mpgridFindNearestFreeCell(o_controller.newgrid, mouse_x div 26, mouse_y div 26);
    
    if (_freeCellCoordsArray[0] != -4 && _freeCellCoordsArray[1] != -4)
        scr_player_move(_freeCellCoordsArray[0] * 26, _freeCellCoordsArray[1] * 26);
    
    exit;
}

var _move = false;

with (o_player)
{
    if (is_moving)
        exit;
    
    var _attack_target = scr_player_enemy_target_validate(other.id, range);
    var _distance = scr_tile_distance_min(id, _attack_target);
    var _interract = _distance <= range;
    var _is_attack = _distance <= 1 && !other.has_the_high_ground;
    
    if (_interract || _is_attack)
    {
        if (abs(_attack_target.diss) < 40)
        {
            var _crt = CRT;
            var _is_shoot = false;
            var _hands = _scr_get_weapon_hand_types();
            
            if (ds_list_empty(lock_attack))
            {
                var _is_range_weapon = scr_is_weapon_type_shooting();
                
                if (_is_range_weapon)
                {
                    var _target = scr_shoot_target_miss(_attack_target, id);
                    
                    if (scr_throw(_target, false, _attack_target))
                    {
                        last_skill = -4;
                        scr_skill_call_buff(o_db_curse, id);
                        scr_fatigue_change(0.01);
                        _is_shoot = true;
                        var _rh = _hands[0];
                        var _lh = _hands[1];
                        var _has_melee = (_rh == "melee" || _lh == "melee");
                        
                        if (_has_melee && _distance <= 2)
                            scr_two_hands_attack(_attack_target);
                    }
                }
                
                if (!_is_shoot)
                {
                    var _hands = _scr_get_weapon_hand_types();
                    var _is_amo_exist = _hands[0] != "melee" || _hands[1] != "melee" || scr_crossbow_is_armed();
                    
                    if (_is_attack && !_is_amo_exist)
                    {
                        if (_is_range_weapon)
                        {
                            scr_weapon_slot_equip(-4, false);
                            scr_atr_calc_combat();
                        }
                        
                        scr_fatigue_change(0.03);
                        scr_two_hands_attack(_attack_target);
                        scr_global_turn();
                        
                        if (_is_range_weapon)
                        {
                            scr_weapon_slot_equip(o_weapon_slot_parent, true);
                            scr_atr_calc_combat();
                        }
                    }
                    else
                    {
                        _move = true;
                    }
                }
            }
            else
            {
                scr_skip_turn();
            }
            
            CRT = _crt;
            
            with (o_floor_target)
                animate = 6;
        }
    }
    else
    {
        _move = true;
    }
    
    if (_move && _distance > range)
        scr_one_path_move(other.id, false, o_player, true, astar_grid_path);
}
