function scr_intoxication_percent_limits()
{
    var _wildhunt_modifier = floor(scr_atr("LVL") * 0.6);
    return [25 + _wildhunt_modifier, 50 + _wildhunt_modifier, 75 + _wildhunt_modifier];
}

function scr_intoxication_check()
{
    var _percent_limits = scr_intoxication_percent_limits();
    scr_check_condition("Intoxication", o_db_tox1, o_db_tox2, o_db_tox3, o_db_intoxicated, _percent_limits[0], _percent_limits[1], _percent_limits[2]);
}
