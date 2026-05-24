if (instance_exists(owner))
{
    var _chain_lightning_count = 4 + (owner.WIL * 2 + owner.Miracle_Power + owner.Magic_Power + owner.Electromantic_Power - 225) * 0.04;
    var _shock_damage_static = (9 + (owner.WIL + owner.Electromantic_Power) * 0.1) * (225 + owner.Electromantic_Power + owner.Magic_Power) / (350 - owner.Miracle_Power * 0.2);
    var _base_damage = max(1, math_round(_shock_damage_static * 0.01));
    ds_map_replace(text_map, "Chain_Lightning_Count", floor(_chain_lightning_count));
    ds_map_replace(text_map, "Chain_Lightning_Crit", floor(_chain_lightning_count * owner.Miracle_Power / 125));
    ds_map_replace(data, "Shock_Damage", math_round(_shock_damage_static * (1.7 + owner.WIL * 0.01)));
    ds_map_replace(text_map, "Base_Damage", _base_damage);
    ds_map_replace(data, "Stagger_Chance", math_round(50 * ((owner.Magic_Power + owner.Electromantic_Power) / 100)));
    ds_map_replace(data, "Debuff_Chance", math_round(80 * ((owner.Magic_Power + owner.Electromantic_Power) / 100)));
}

event_inherited();
