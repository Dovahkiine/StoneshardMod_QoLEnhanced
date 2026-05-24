function scr_global_turn()
{
    global.chain_lightning_count = 0;
    global.wizzard_turn = false;
    global.free_turn_consumed = false;
    
    if (global.got_free_turn > 0)
    {
        global.got_free_turn--;
        global.free_turn_consumed = true;
        
        with (o_player)
        {
            alarm[1] = -1;
            alarm[4] = -1;
            lock_movement = false;
            
            with (o_skill)
                last_activated = false;
        }
        
        exit;
    }
    
    var _is_cutscene = scr_is_cutscene();
    
    with (o_time_controller)
        event_user(4);
    
    if (!instance_exists(o_player))
        return false;
    
    if (!_is_cutscene)
        scr_states_duration_dec(o_player, false);
    
    global.enemy_death_count = 0;
    
    with (o_animal_border_destroyer)
        event_user(0);
    
    with (o_weather)
        event_user(15);
    
    with (o_horse_random_side)
        event_user(0);
    
    with (o_player)
    {
        is_agred_npc = false;
        
        with (o_enemy)
        {
            if (!is_neutral && ai_is_on)
                other.is_agred_npc = true;
        }
        
        scr_hunger_thirsty_add();
        scr_hungercheck();
        scr_thirsty_check();
        scr_pain_decrease(true);
        scr_intoxication_decrese();
        scr_psy_check();
        scr_fatigue_change(Fatigue_Change, 1);
        scr_actionsLogBleeding();
        counterattack_target = -4;
    }
    
    scr_perkTriggerCall(0 >> 0);
    
    if (!scr_timeIsFrozen())
    {
        scr_timeUpdate(30);
        scr_characterTimeUpdate();
    }
    
    with (o_restrictedAreaMarker)
        event_user(0);
    
    with (o_magic_stuff)
        event_user(2);
    
    with (o_church_reliquaryaltar)
        event_user(0);
    
    with (o_stone_spikes_instance)
        event_user(2);
    
    with (o_player)
    {
        if (!forceAllTurn)
        {
            var _hp_modifier = 1 + (scr_instance_exists_in_list(o_b_hyssop) != -4);
            var _mp_modifier = 1 + (scr_instance_exists_in_list(o_b_azurecap) != -4);
            scr_unit_regen(_hp_modifier, _mp_modifier);
        }
    }
    
    with (o_Attitude)
    {
        if (is_activate)
            event_user(3);
    }
    
    with (o_player)
        event_user(2);
    
    with (o_unit_text)
        event_user(0);
    
    with (c_player_turn_trigger)
        event_user(0);
    
    with (o_controller)
        turns += 1;
    
    if (!_is_cutscene)
    {
        scr_states_duration_dec(o_player, true);
        
        with (o_player)
        {
            buffs_is_change = true;
            
            if (stats_is_change)
            {
                scr_atr_calc(id);
                stats_is_change = false;
            }
        }
    }
    
    with (c_tile_mark)
        event_user(0);
    
    with (o_intransigence_spawner)
        event_user(1);
    
    with (o_stone_spikes_vengeance)
        event_user(2);
    
    with (o_smoke_everyturn_event_controller)
        event_user(0);
    
    with (o_unit_state_indicator_agred)
        done = true;
    
    with (o_hearing_indicator)
        event_user(0);
    
    with (o_music_controller)
        event_user(1);
    
    with (o_player)
        movingIsDone = false;
    
    with (o_NPC)
        movingIsDone = false;
    
    with (o_simple_NPC)
        movingIsDone = false;
    
    with (o_unit)
    {
        if (!is_simple)
        {
            Block_RecoveryStatus += (Block_Recovery / 100);
            Block_RecoveryStatus = clamp(Block_RecoveryStatus, 0, 1);
            Block_Power = math_round(Block_PowerMax * Block_RecoveryStatus);
        }
    }
    
    scr_noise_receiver_global_clear();
}
