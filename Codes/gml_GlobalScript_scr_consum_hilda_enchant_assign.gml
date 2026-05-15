function scr_consum_hilda_enchant_assign(argument0)
{
    if (argument0 == undefined)
        argument0 = object_index;

    var _attribute_name = "";
    var _attribute_value = 0;
    
    switch (argument0)
    {
        case o_inv_gulon_liver:
            _attribute_name = "Lifesteal";
            _attribute_value = min(3 + (0.67 * scr_atr("GulonKills", 0)), 20);
            break;
        
        case o_inv_troll_gland:
            _attribute_name = "Damage_Received";
            _attribute_value = -min(4.5 + (0.85 * scr_atr("YoungTrollKills", 0)), 30);
            break;
        
        case o_inv_bear_fat:
            _attribute_name = "Weapon_Damage";
            _attribute_value = min(5 + scr_atr("BearKills", 0), 50);
            break;
        
        case o_inv_harpy_stomach:
            _attribute_name = "EVS";
            _attribute_value = min(5 + scr_atr("HarpyKills", 0), 60);
            break;
        
        case o_inv_spider_eye:
            _attribute_name = "Manasteal";
            _attribute_value = min(4.5 + (0.6 * scr_atr("CrawlerKills", 0)), 20);
            break;
        
        case o_inv_horns_bison:
            _attribute_name = "max_hp";
            _attribute_value = min(4.5 + (0.85 * scr_atr("BisonKills", 0)), 30);
            break;
        
        case o_inv_horns_deer:
            _attribute_name = "max_mp";
            _attribute_value = min(2 + (0.5 * scr_atr("DeerSaigaKills", 0)), 30);
            break;
        
        case o_inv_horns_saiga:
            _attribute_name = "max_mp";
            _attribute_value = min(2 + (0.5 * scr_atr("DeerSaigaKills", 0)), 8);
            break;
        
        case o_inv_wolf_tongue:
            _attribute_name = "Abilities_Energy_Cost";
            _attribute_value = -min(2 + (0.6 * scr_atr("WolfKills", 0)), 8);
            break;
        
        case o_inv_moose_kidney:
            _attribute_name = "Magic_Power";
            _attribute_value = min(4.5 + (0.85 * scr_atr("MooseKills", 0)), 50);
            break;
        
        case o_inv_rockeater_gland:
            _attribute_name = "Fatigue_Gain";
            _attribute_value = min(4.5 + (0.6 * scr_atr("RockeaterKills", 0)), 50);
            break;
        
        case o_inv_boar_tusks:
            _attribute_name = "Cooldown_Reduction";
            _attribute_value = -min(4.5 + (0.67 * scr_atr("BoarKills", 0)), 30);
            break;
        
        case o_inv_ghoul_heart:
            _attribute_name = "Health_Restoration";
            _attribute_value = min(4.5 + (0.5 * scr_atr("GhoulKills", 0)), 30);
            break;
    }
    
    return [_attribute_name, _attribute_value];
}
