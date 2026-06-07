event_user(5);

if (!is_load)
{
    with (target)
    {
        scr_guiAnimation(s_blessing_elf, 1, 1);
        audio_play_sound(snd_altar_buff, 4, 0);
        
        if (is_player())
        {
            scr_characterStatsUpdateAdd("usedAltars", 1);
            
            if (scr_psy_time_check("BlessTime", 24, 2))
                scr_psy_change("SanityLifestyle", 1 * scr_psy_get("LifestyleSanityCoef", false, 1), "bless_elf");
        }
    }
}
