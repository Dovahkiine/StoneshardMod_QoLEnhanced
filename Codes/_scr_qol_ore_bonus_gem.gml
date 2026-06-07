function _scr_qol_ore_bonus_gem(argument0, argument1, argument2)
{
    var _chance = 0;
    
    if (argument0 == o_inv_coal)
        _chance = 4;
    else if (argument0 == o_inv_copper_nugget)
        _chance = 6;
    else if (argument0 == o_inv_iron_nugget)
        _chance = 8;
    else if (argument0 == o_inv_silver_nugget)
        _chance = 10;
    else if (argument0 == o_inv_gold_nugget)
        _chance = 12;
    
    if (_chance <= 0 || !scr_chance_value(_chance))
        return -4;
    
    var _roll = irandom(99);
    var _gem = o_inv_sapphire;
    
    if (_roll < 10)
        _gem = o_inv_jade;
    else if (_roll < 20)
        _gem = o_inv_moonstone;
    else if (_roll < 30)
        _gem = o_inv_turquoise;
    else if (_roll < 40)
        _gem = o_inv_agate;
    else if (_roll < 50)
        _gem = o_inv_amber;
    else if (_roll < 58)
        _gem = o_inv_morion;
    else if (_roll < 66)
        _gem = o_inv_aquamarine;
    else if (_roll < 74)
        _gem = o_inv_topaz;
    else if (_roll < 82)
        _gem = o_inv_amethyst;
    else if (_roll < 87)
        _gem = o_inv_ruby;
    else if (_roll < 92)
        _gem = o_inv_emerald;
    else if (_roll < 96)
        _gem = o_inv_diamond;
    
    return scr_loot_drop(argument1, argument2, _gem);
}
