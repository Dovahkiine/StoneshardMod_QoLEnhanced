if (instance_exists(owner))
{
    var _aoe_range = clamp(1 + floor(((owner.WIL + owner.Electromantic_Power) * 2 + owner.Magic_Power) / 100), 2, 6);
    var _shock_damage = (10.5 + owner.WIL * 0.12 + owner.Electromantic_Power * 0.12) * (100 + owner.Electromantic_Power + owner.Magic_Power * 0.5) / 80;
    var _base_damage = max(1, math_round(_shock_damage * 0.2));
    var _debuff_damage = math_round((1.2 + (owner.WIL + owner.Electromantic_Power) * 0.05) * (100 + owner.Electromantic_Power) / 75);
    AOE_Len = 10 + _aoe_range;
    AOE_Width = 10 + _aoe_range;
    ds_map_replace(text_map, "AOE_Range", _aoe_range);
    ds_map_replace(data, "Shock_Damage", math_round(_shock_damage * 2.2));
    ds_map_replace(text_map, "Base_Damage", _base_damage);
    ds_map_replace(data, "Debuff_Damage", _debuff_damage);
    ds_map_replace(data, "Knockback_Chance", math_round(40 * (owner.Magic_Power + owner.Electromantic_Power) / 100));
    ds_map_replace(data, "Debuff_Chance", math_round(85 * (owner.Magic_Power + owner.Electromantic_Power) / 100));
    ds_map_replace(data, "Stagger_Chance", math_round(100 * (owner.Magic_Power + owner.Electromantic_Power) / 100));
    ds_map_replace(data, "Debuff_Knockback", math_round(15 * (owner.Magic_Power + owner.Electromantic_Power) / 100));
}

event_inherited();
