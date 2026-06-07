if (!global.tp_flag_msl && !global.tp_dungeon_msl && !global.tp_caravan_msl)
{
    scr_actionsLogUpdate("设置中未勾选，无法使用传送功能。")
    instance_destroy(o_globalmap)
    exit
}
var _closest_x = undefined
var _closest_y = undefined
var _min_distance = -1
var _mark_type = "Flag"
var _caravan_grid_x = ds_map_find_value_ext(global.caravanDataMap, "gridX", -1)
var _caravan_grid_y = ds_map_find_value_ext(global.caravanDataMap, "gridY", -1)
if (variable_global_exists("tp_mark_type") && is_string(global.tp_mark_type) && global.tp_mark_type != "0")
    _mark_type = global.tp_mark_type
ds_list_clear(global.globalmapUserMarksList)
with(o_globalmap)
{
    with (marksContainer)
    {
        for (var _i = 0; _i < guiChildrenCount; _i++)
        {
            with (ds_list_find_value(guiChildrenList, _i))
            {
                if (object_index == o_globalmapMarkUser)
                    ds_list_add(global.globalmapUserMarksList, sprite_get_name(sprite_index), image_index, guiLayoutOffsetLeft / global.glmapScale, guiLayoutOffsetTop / global.glmapScale);
            }
        }
    }
}
var _userMarksNumberFound = 0
var _userMarksListSize = ds_list_size(global.globalmapUserMarksList)
var _Locations = ["Osbrook", "Mannshire", "Denbrie", "RottenWillow", "Homestead", "NewOrchard", "Winery", "BrynnSuburbs", "TheDrunkenWoodsmanTavern", "RoadsideInn", "CoalBurners", "OakenGrove", "OsbrookBrewery", "Mill", "KendricksHomestead", "SouthernOutpost", "BridgeCamp", "RoadsideTower"]
for (var _i = 0; _i < _userMarksListSize; _i += 4)
{
    var _mark = asset_get_index(ds_list_find_value(global.globalmapUserMarksList, _i))
    var _gridX = ds_list_find_value(global.globalmapUserMarksList, (_i + 2)) div 52
    var _gridY = ds_list_find_value(global.globalmapUserMarksList, (_i + 3)) div 52
    if (sprite_get_name(_mark) == "s_glmap_mark_user_" + _mark_type)
    {
        _userMarksNumberFound++
        var _distance = point_distance(_gridX, _gridY, global.playerGridX, global.playerGridY)
        if (_min_distance == -1 || _distance < _min_distance)
        {
            if (global.tp_flag_msl && scr_array_get_index(_Locations, scr_globaltile_get("Location", _gridX, _gridY, "N/A")) != -1)
            {
                _min_distance = _distance
                _closest_x = _gridX
                _closest_y = _gridY
            }
            if (global.tp_dungeon_msl && scr_globaltile_get("dungeon", _gridX, _gridY, -1, global.globaltile_lookup_save) != -1)
            {
                _min_distance = _distance
                _closest_x = _gridX
                _closest_y = _gridY
            }
            if (global.tp_caravan_msl && _gridX == _caravan_grid_x && _gridY == _caravan_grid_y)
            {
                _min_distance = _distance
                _closest_x = _gridX
                _closest_y = _gridY
            }
        }
    }
}
if (global.floor_counter != 0)
{
    scr_actionsLogUpdate(scr_colorTextStringPlaceholdersReplace("~w~$~/~不在地面上，无法传送。", [scr_id_get_name(o_player)]))
    instance_destroy(o_globalmap)
    exit
}
if (scr_getAgredMobsCount())
{
    scr_actionsLogUpdate(scr_colorTextStringPlaceholdersReplace("~w~$~/~在战斗中，无法传送。", [scr_id_get_name(o_player)]))
    instance_destroy(o_globalmap)
    exit
}
if (!is_undefined(_closest_x) && !is_undefined(_closest_y))
{
    if (_userMarksNumberFound > 1)
    {
        scr_actionsLogUpdate(scr_colorTextStringPlaceholdersReplace("~w~$~/~不知道要传送到~y~$~/~标记地点中的哪一个。", [scr_id_get_name(o_player), _userMarksNumberFound]))
        instance_destroy(o_globalmap)
        exit
    }
    if (scr_globaltile_get("isOpen", _closest_x, _closest_y))
        scr_actionsLogUpdate(scr_colorTextStringPlaceholdersReplace("~w~$~/~要传送到~lg~$~/~。", [scr_id_get_name(o_player), scr_glmap_getTitle(_closest_x, _closest_y)]))
    else
        scr_actionsLogUpdate(scr_colorTextStringPlaceholdersReplace("~w~$~/~要传送到位于地图坐标~lg~（$，$）~/~的未知区域。", [scr_id_get_name(o_player), string(_closest_x), string(_closest_y)]))
    // var skip_time = ceil(scr_tile_distance_xy(global.playerGridX, global.playerGridY, _closest_x, _closest_y, 1) * 0.5)
    global.playerGridX = _closest_x
    global.playerGridY = _closest_y
    if (_closest_x == _caravan_grid_x && _closest_y == _caravan_grid_y)
        global.position_tag = "caravan"
    else
        global.position_tag = scr_globaltile_get("dungeon", _closest_x, _closest_y, -1, global.globaltile_lookup_save) == -1 ? "fasttravel" : "dungeonExit"
    var _smoothChanger = scr_smoothRoomChange(scr_globaltile_get_room(_closest_x, _closest_y), [4], room_speed / 2)
    with (instance_create_depth(-50, -50, 0, o_sleepController))
    {
        smoothChanger = _smoothChanger
        sleepType = 12
        sleepHours = 0      //原本是根据距离计算的skip_time时间，但考虑到玩家可能会传送很远的距离，改为固定时间，避免过长的等待
        timeUpdate = true
        actionsLog = false
    }
}
else
{
    if (_userMarksNumberFound > 0)
        scr_actionsLogUpdate(scr_colorTextStringPlaceholdersReplace("~w~$~/~标记的地点无法传送。", [scr_id_get_name(o_player)]))
    else
        scr_actionsLogUpdate(scr_colorTextStringPlaceholdersReplace("~w~$~/~没有标记要传送的地点。", [scr_id_get_name(o_player)]))
}
instance_destroy(o_globalmap)
