if (object_index != o_perk_wild_hunt)
{
    hunting_animals_array = [[o_gulon, "GulonKills"], [o_small_troll, "YoungTrollKills"], [o_bear, "BearKills"], [o_harpy, "HarpyKills"], [o_crawler, "CrawlerKills"], [o_crawler_broodmother, "CrawlerKills"], [o_bison, "BisonKills"], [o_saiga_m, "DeerSaigaKills"], [o_deer_m, "DeerSaigaKills"], [o_wolf, "WolfKills"], [o_moose, "MooseKills"], [o_snake, "SnakeKills"], [o_boar, "BoarKills"], [c_ghoul, "GhoulKills"], [o_Rockeater_parent, "RockeaterKills"]]; 
    array_foreach(hunting_animals_array, function(argument0)
    {
        var _entry_arg0 = argument0;
        scr_atr_add_simple(_entry_arg0[1], 0);
    });
    scr_perkTriggerAdd((4 >> 0), function(argument0)
    {
        var _entries = hunting_animals_array;
        var _entry_count = array_length(_entries);
        var _area = argument0;
        
        with (_area)
        {
            var _to_all = false;
            var _amount = 1;
            
            if (instance_is(id, o_manticore) || instance_is(id, o_ancientTroll))
            {
                _to_all = true;
                _amount = 5;
            }
            
            var i = _entry_count - 1;
            
            while (i >= 0)
            {
                var _entry = _entries[i];
                var _object_index = _entry[0];
                var _atr_key = _entry[1];
                
                if (_to_all || object_index == _object_index || object_is_ancestor(object_index, _object_index))
                    scr_atr_incr(_atr_key, _amount);
                
                i--;
            }
        }
    });
}
