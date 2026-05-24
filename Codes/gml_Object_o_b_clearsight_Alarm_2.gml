event_inherited();

with (target)
{
    __dsDebuggerMapClear(other.data);
    ds_map_add(other.data, "VSN_Bonus", 20);
    ds_map_add(other.data, "Hit_Chance", 5);
    ds_map_add(other.data, "CRT", 5);
    ds_map_add(other.data, "Miracle_Chance", 5);
    ds_map_add(other.data, "Bonus_Range", 30);
}
