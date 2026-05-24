if (instance_exists(o_controller))
{
    if (global.floor_counter == 0 && ds_map_find_value(data, "use_kd") == 0 && !o_controller.inhouse)
    {
        if (ds_map_find_value(global.timeDataMap, "hours") >= 19 || ds_map_find_value(global.timeDataMap, "hours") <= 7)
        {
            scr_effect_create(o_b_clearsight, 2880);
            ds_map_set(data, "use_kd", 18);
            charge++;
            var _timestamp = scr_timeGetTimestamp();
            ds_map_replace(data, "Timestamp", _timestamp);
            event_inherited();
        }
    }
}
