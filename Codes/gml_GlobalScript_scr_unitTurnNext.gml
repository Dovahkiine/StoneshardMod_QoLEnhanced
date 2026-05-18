function scr_unitTurnNext(argument0)
{
    if (argument0 == undefined) argument0 = 1;
    
    if (global.Upspeed)
        argument0 = 1;
    
    if (global.free_turn_consumed)
    {
        with (o_player)
        {
            alarm[4] = -1;
            alarm[1] = -1;
            lock_movement = false;
        }
        
        exit;
    }
    
    with (o_player)
        alarm[4] = argument0;
}
