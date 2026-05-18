function scr_weapon_generation()
{
    empty = false;
    scr_inventory_weapon_get_params();
    
    if (is_new)
    {
        // ✅ 移除临时 map 创建（已由 init_global_weapon_prefixes() 初始化全局变量）
        
        Common = (1 >> 0);
        Uncommon = (2 >> 0);
        Rare = (3 >> 0);
        Epic = (4 >> 0);
        Curse = (5 >> 0);
        Unique = (6 >> 0);
        Treasure = (7 >> 0);
        
        var tech = __dsDebuggerMapCreate();
        ds_map_add(tech, string(Common), 16777215);
        ds_map_add(tech, string(Uncommon), make_colour_rgb(89, 219, 76));
        ds_map_add(tech, string(Rare), make_colour_rgb(76, 127, 255));
        ds_map_add(tech, string(Epic), make_colour_rgb(255, 183, 43));
        ds_map_add(tech, string(Curse), make_colour_rgb(130, 72, 88));
        ds_map_add(tech, string(Unique), make_colour_rgb(130, 72, 188));
        ds_map_add(tech, string(Treasure), make_colour_rgb(229, 193, 85));
        
        if (ds_map_find_value(data, "rarity") == "Unique")
            determined_quality = Unique;
        
        if (determined_quality != -4)
        {
            quality = determined_quality;
        }
        else
        {
            quality = Common;
            
            if (scr_chance_value(30, 1))
                quality = Uncommon;
            
            if (scr_chance_value(15, 1))
                quality = Rare;

            if (scr_chance_value(10, 1))
                quality = Epic;

            if (scr_chance_value(4, 1))
                quality = Unique;
            
            if (scr_chance_value(1, 1))
                quality = Treasure;
            
            if (quality == Uncommon || quality == Rare)
            {
                if (scr_chance_value(10))
                    quality = Curse;
            }
        }
        
        var common_chars = 0;
        var rare_chars = 0;
        identified = true;
        key = "";
        var char = 0;
        
        switch (quality)
        {
            case Common:
                identified = true;
                break;
            
            case Uncommon:
                repeat (3)
                if (scr_chance_value(50))
                    common_chars += 1;
                else
                    rare_chars += 1;
                
                identified = false;
                break;
            
            case Rare:
                repeat (4)
                {
                    if (scr_chance_value(50))
                        common_chars += 1;
                    else
                        rare_chars += 1;
                }
                
                identified = false;
                break;
            
            case Epic:
                repeat (5)
                {
                    if (scr_chance_value(50))
                        common_chars += 1;
                    else
                        rare_chars += 1;
                }
                
                identified = false;
                break;
            
            case Unique:
                repeat (6)
                {
                    if (scr_chance_value(50))
                        common_chars += 1;
                    else
                        rare_chars += 1;
                }
                
                identified = true;
                break;
            
            case Treasure:
                repeat (8)
                {
                    if (scr_chance_value(50))
                        common_chars += 1;
                    else
                        rare_chars += 1;
                }
                
                identified = false;
                break;

            case Curse:
                identified = true;
                break;
         
        }
        
        n = 0;
        
        // ✅ 使用全局变量进行词缀搜索
        scr_weapon_generation_prefix_search(common_chars, global.weapon_common);
        scr_weapon_generation_prefix_search(rare_chars, global.weapon_rare);
        
        if (n == 0)
            ds_map_add(data, "key", key);
        
        ds_map_add(data, "Suffix", string(quality) + " " + type);
        ds_map_add(data, "Colour", ds_map_find_value(tech, string(quality)));
        curse_list = __dsDebuggerListCreate();
        ds_map_add(data, "cursedQuality", -4);
        
        if (quality == Curse)
        {
            scr_Curse();
            ds_map_add(data, ds_list_find_value(curse_list, 2), ds_list_find_value(curse_list, 3));
            ds_map_replace(data, "is_cursed", true);
            
            if ((common_chars + rare_chars) == 1)
                ds_map_replace(data, "cursedQuality", Uncommon);
            else
                ds_map_replace(data, "cursedQuality", Rare);
        }
        else
        {
            ds_map_add(data, "is_cursed", false);
        }
        
        ds_map_add_list(data, "Curse", curse_list);
        ds_map_add(data, "identified", identified);
        ds_map_add(data, "quality", quality);
        tech = __dsDebuggerMapDestroy(tech);
    }
}