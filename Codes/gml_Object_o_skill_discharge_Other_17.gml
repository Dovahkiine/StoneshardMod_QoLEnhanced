if (instance_exists(owner))
{
    var _shock_damage = (7 + owner.WIL * 0.1 + owner.Electromantic_Power * 0.1) * (100 + owner.Electromantic_Power + owner.Magic_Power * 0.5) * 0.01;
    var _base_damage = max(1, math_round(_shock_damage * 0.01));
    ds_map_replace(data, "Shock_Damage", math_round(_shock_damage * 2.1));
    ds_map_replace(text_map, "Base_Damage", _base_damage);
    ds_map_replace(data, "Hit_Chance", owner.Spell_Hit_Chance + 10);
    ds_map_replace(data, "Debuff_Chance", math_round(70 * ((owner.Magic_Power + owner.Electromantic_Power) / 100)));
    ds_map_replace(data, "Knockback_Chance", math_round(35 * ((owner.Magic_Power + owner.Electromantic_Power) / 100)));
}

event_inherited();
