event_inherited();

if (instance_exists(owner))
{
    ds_map_replace(text_map, "Max_HP_Limit", 2 * (owner.STR + owner.AGL + owner.PRC));
    ds_map_replace(text_map, "HP_Limit", 0.5 * (owner.STR + owner.AGL + owner.PRC));
    ds_map_replace(text_map, "Restore_MP", 1.5 * owner.WIL);
    ds_map_replace(text_map, "Bodypart_Damage", 2.5 * owner.AGL);
    ds_map_replace(text_map, "CRT", 1.5 * owner.STR);
    ds_map_replace(text_map, "FMB", -2 * owner.PRC);
    ds_map_replace(text_map, "Manasteal", 5 * owner.WIL);
}

if (scr_is_weapon_type_any_hand("spear"))
    range++;
