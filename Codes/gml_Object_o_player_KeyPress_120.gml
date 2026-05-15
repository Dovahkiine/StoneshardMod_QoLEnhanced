if (keyboard_check_pressed(vk_f9))
{
    global.fog = !global.fog;
    
    with (o_fogrender)
    {
        var _roomCellsX = room_width div 26;
        var _roomCellsY = room_height div 26;
        
        for (var _i = 0; _i < _roomCellsX; _i++)
        {
            for (var _j = 0; _j < _roomCellsY; _j++)
                tile_set_alpha(ds_grid_get(fogTiles, _i, _j), global.fog);
        }
    }
    
    with (o_globalmap)
    {
        with (fogPartsContainer)
        {
            for (var _i = 0; _i < guiChildrenCount; _i++)
            {
                with (ds_list_find_value(guiChildrenList, _i))
                    event_user(0);
            }
        }
    }
}

if (keyboard_check_pressed(vk_f9))
    scr_actionsLogUpdate("F9 切换所有迷雾！包括地面！");
