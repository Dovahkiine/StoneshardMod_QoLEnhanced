event_user(0);

if (is_player(target) && scr_psy_time_check("BlessTime", 24, 2))
    scr_psy_change("SanityLifestyle", 1 * scr_psy_get("LifestyleSanityCoef", false, 1), "bless");
    
if (!is_load)
{
    with (target)
    {
        scr_guiAnimation(s_blessing, 1, 1);
        audio_play_sound(snd_altar_buff, 4, 0);
        
        if (is_player())
        scr_characterStatsUpdateAdd("usedAltars", 1);
    }
}

__dsDebuggerMapClear(data);
ds_map_add(data, "Received_XP", 5 * stage);
ds_map_add(data, "Sacred_Damage", stage);
ds_map_add(data, "Fortitude", 9 * stage);
ds_map_add(data, "Crit_Avoid", (9 * stage) + defense_boost);
ds_map_add(data, "Unholy_Resistance", (9 * stage) + defense_boost);
