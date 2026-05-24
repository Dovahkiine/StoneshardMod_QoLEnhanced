event_inherited();
var _last_boost = defense_boost;
save_counter++;

if (scr_npc_lines_black_tablet_check_bless_boost())
    defense_boost = 6;

if (save_counter >= 2880)
{
    save_counter = 0;

    if (stage < max_stage)
        stage++;
}

if (!save_counter || _last_boost != defense_boost)
{
    __dsDebuggerMapClear(data);
    ds_map_add(data, "Received_XP", 5 * stage);
    ds_map_add(data, "Sacred_Damage", stage);
    ds_map_add(data, "Fortitude", 9 * stage);
    ds_map_add(data, "Crit_Avoid", (9 * stage) + defense_boost);
    ds_map_add(data, "Unholy_Resistance", (9 * stage) + defense_boost);
}