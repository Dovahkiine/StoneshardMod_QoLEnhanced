global.actionsLogTurnsLine = false;

function scr_actionsLog(argument0, argument1)
{
    var _battlePassed = true;

    if (global.actionsLogBattle)
    {
        with (o_player)
        {
            if (in_battle && ds_list_find_index(global.actionsLogBattleExcluded, argument0) != -1)
                _battlePassed = false;
        }
    }

    if (!_battlePassed)
    {
        global.actionsLogBuffer = "";
        exit;
    }

    var _pattern = scr_actionsLogGetPattern(argument0);
    var _log = "N/A";

    if (global.actionsLogBuffer != "")
    {
        _pattern = _pattern + global.actionsLogBuffer;
        global.actionsLogBuffer = "";
    }

    _log = scr_colorTextStringPlaceholdersReplace(_pattern, argument1, "$", true);

    if (global.language == 6)
        _log = scr_dialog_text_choose_gender(_log);

    if (variable_global_exists("timeDataMap") && ds_exists(global.timeDataMap, ds_type_map))
    {
        var _h = ds_map_find_value(global.timeDataMap, "hours");
        var _m = ds_map_find_value(global.timeDataMap, "minutes");

        if (!is_undefined(_h) && !is_undefined(_m))
        {
            var _hs = (_h < 10 ? "0" : "") + string(_h);
            var _ms = (_m < 10 ? "0" : "") + string(_m);
            _log = "[~y~" + _hs + ":" + _ms + "~c~] " + _log;
        }
    }

    scr_actionsLogUpdate(_log);
}
