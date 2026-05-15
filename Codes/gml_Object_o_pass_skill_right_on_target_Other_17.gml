ds_map_clear(data);
var _hand_eff = 3 + (2 * global.open_weapon_skills);
var _WD = (0.75 * owner.AGL) + (0.5 * global.open_weapon_skills);
var _armor_piercing = (0.75 * owner.STR) + (0.5 * global.open_weapon_skills);
var _FMB = -(0.75 * owner.PRC) + (0.5 * global.open_weapon_skills);
var _damage_received = -((0.75 * owner.Vitality) + (0.5 * global.open_weapon_skills));
var _skills_cost = -((0.75 * owner.WIL) + (0.5 * global.open_weapon_skills));
ds_map_replace(text_map, "HE", _hand_eff);
ds_map_replace(text_map, "WD", _WD);
ds_map_replace(text_map, "AP", _armor_piercing);
ds_map_replace(text_map, "FMB", _FMB);
ds_map_replace(text_map, "DR", _damage_received);
ds_map_replace(text_map, "SEC", _skills_cost);

if (is_open)
{
    ds_map_add(data, "Mainhand_Efficiency", _hand_eff);
    ds_map_add(data, "Weapon_Damage", _WD);
    ds_map_add(data, "Armor_Piercing", _armor_piercing);
    ds_map_add(data, "FMB", _FMB);
    ds_map_add(data, "Damage_Received", _damage_received);
    ds_map_replace(data, "Abilities_Energy_Cost", _skills_cost);
}

event_inherited();
