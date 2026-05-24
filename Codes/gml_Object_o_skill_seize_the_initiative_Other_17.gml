if (instance_exists(owner))
{
    ds_map_replace(data, "EVS", -2.5 * owner.AGL);
    ds_map_replace(data, "PRR", -2.5 * owner.STR);
    ds_map_replace(data, "HC", owner.AGL);
    ds_map_replace(data, "FMB", -owner.PRC);
}

event_inherited();

if (scr_is_weapon_type_any_hand("spear"))
    range = 3;
else if (!scr_is_weapon_type_shooting() && !is_enemy_skill)
    range = 2;
