event_inherited();

with (o_db_crowbar)
    event_user(6);

with (o_player)
{
    audio_play_sound(scr_random_snd_list(hey_sound), 2, 0);
    scr_hunger_change(-2);
    scr_intoxication_change(-1);
    scr_immunity_change(4);
    scr_fatigue_change(-1);
    scr_noise_produce(scr_noise_shout(), grid_x, grid_y);
}

scr_random_speech("player_shout", 100, o_player, true);

with (o_enemy)
{
    if (visible && state == "attack")
    {
        if (attack_voice_tag != "")
            scr_random_speech(attack_voice_tag, 50, id, true);
    }
}

scr_allturn();

with (object_index)
    is_activate = false;
