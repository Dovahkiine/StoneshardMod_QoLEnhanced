event_inherited();
var _multiplier = clamp(stage, 100, 200) / 100;

__dsDebuggerMapClear(data);
ds_map_add(data, "Received_XP", 10 * _multiplier);
ds_map_add(data, "Hunger_Resistance", 10 * _multiplier);
ds_map_add(data, "Cooldown_Reduction", -5 * _multiplier);
ds_map_add(data, "FMB", -3 * _multiplier);
ds_map_add(data, "Miscast_Chance", -3 * _multiplier);

if (scr_npc_lines_black_tablet_check_bless_boost())
{
    ds_map_add(data, "Crit_Avoid", 5 * _multiplier);
    ds_map_add(data, "Unholy_Resistance", 5 * _multiplier);
}
