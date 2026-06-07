if (!alarm[1] && image_speed == 0 && !is_execute)
{
    var _pickaxe_id = scr_player_equipped_get("Pickaxe");
    
    if (_pickaxe_id == -4)
    {
        with (o_player)
        {
            scr_random_speech("ore_pickaxe", 100);
            audio_play_sound(snd_mouse_skill_denied, 4, 0);
        }
        
        exit;
    }
    
    scr_allturn();
    scr_actionsLog("mine", [scr_actionsLogGetName(o_player), scr_actionsLogGetName(id)]);
    scr_audio_play_at(choose(snd_pickaxe_impact_1, snd_pickaxe_impact_2, snd_pickaxe_impact_3, snd_pickaxe_impact_4));
    scr_noise_produce(16, x div 26, y div 26);
    scr_duration_decrese_simple(0.1, _pickaxe_id);
    scr_fatigue_change(0.03);
    
    with (o_player)
    {
        var dir = point_direction(x, y, other.x, other.y);
        drawdir = dir + 180;
        diss = -200;
    }
    
    alarm[1] = 10;
    
    with (scr_guiAnimation(choose(s_block01, s_block02, s_block03)))
    {
        position_update = false;
        x += random_range(-6.5, 6.5);
        y += random_range(-26, 0);
        depth_update = false;
        depth = other.depth;
        scr_set_lt();
    }
    
    var _dmg = scr_inv_param("DMG", _pickaxe_id);
    hp -= _dmg;
    _scr_qol_ore_bonus_gem(oreType, x, y);
    diss = 200;
    
    if (hp <= 0)
    {
        image_speed = 1;
        
        repeat (irandom_range(1, oreCount))
            scr_loot(oreType, x, y, 100);
        
        repeat (irandom_range(0, 2))
        {
            with (scr_loot(o_loot_ammo_stone, x, y, 66))
            {
                stack = 1;
                image_index = 0;
            }
        }
    }
}
