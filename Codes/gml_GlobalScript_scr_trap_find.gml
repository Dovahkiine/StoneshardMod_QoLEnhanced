function scr_trap_find(argument0)
{
    if (argument0 && instance_exists(o_state_megalomania))
        return 0;
    
    with (o_trap)
    {
        if (!visible)
        {
            var R = round(point_distance(grid_x, grid_y, other.grid_x, other.grid_y));
            var isVisible = false;
            
            if (instance_exists(o_fogrender))
                isVisible = is_visible();
            else
                isVisible = R >= 0 && R <= 24;
            
            if (isVisible)
            {
                if (R == 0)
                {
                    other.trap_find = 100;
                }
                else if (argument0)
                {
                    var _db_dark_stage = 0;
                    
                    with (o_db_dark)
                    {
                        if (is_player(target))
                            _db_dark_stage = stage;
                    }
                    
                    other.trap_find = scr_atr("PRC") / R;
                }
                else
                {
                    other.trap_find = 100;
                }
                
                if (unfindable)
                {
                    other.trap_find = 0;
                }
                else if (object_index == o_net_trap)
                {
                    if (argument0)
                        other.trap_find = scr_atr("PRC") / R;
                    else
                        other.trap_find = (5 + scr_atr("PRC")) / R;
                }
            }
            else
            {
                other.trap_find = 0;
            }
            
            if (scr_chance_value(other.trap_find))
            {
                if (!is_spawner)
                    visible = 1;
                else
                    event_user(8);
                
                if (!locate && !is_spawner)
                {
                    if (scr_actionsLogVisible(other.id))
                        scr_actionsLog("spotTrap", [scr_actionsLogGetName(other.id), scr_actionsLogGetName(id)]);
                    
                    if (object_index != o_webtrap)
                        scr_audio_play_at(1685);
                    
                    part_particles_create(global.main_part, x + 13, y + 13, global.whitepart, 6);
                    scr_random_speech("trapFind");
                    scr_characterStatsUpdateAdd("trapsFound", 1);
                }
                
                locate = 1;
                other.path = -1;
            }
        }
        else
        {
            locate = 1;
        }
    }
    
    if (instance_exists(o_secret_door))
    {
        with (o_secret_door)
        {
            if (!o_secret_door.is_open)
            {
                var R = round(point_distance(grid_x, grid_y, other.grid_x, other.grid_y));
                var find_chance = 0;
                var isVisible = false;
                
                if (instance_exists(o_fogrender))
                    isVisible = is_visible();
                else
                    isVisible = R >= 0 && R <= 24;
                
                if (isVisible)
                {
                    if (R == 0)
                        find_chance = 100;
                    else if (argument0)
                        find_chance = scr_atr("PRC") / R;
                    else
                        find_chance = 100;
                }
                else
                {
                    find_chance = 0;
                }
                
                if (scr_chance_value(find_chance))
                {
                    scr_characterStatsUpdateAdd("secretRoomsFound", 1);
                    o_secret_door.is_open = true;
                    audio_play_sound(snd_secret_room_find, 4, 0);
                    event_user(1);
                    
                    with (o_fogrender)
                        event_user(2);
                    
                    scr_psy_change("MoraleSituational", 10, "secret_find");
                }
            }
        }
    }
}
