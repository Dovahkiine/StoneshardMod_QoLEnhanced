function scr_fatigue_percent_limits()
{
    var _asceticism_modifier = 5 * (instance_exists(o_pass_skill_asceticism) && o_pass_skill_asceticism.is_open);
    var _wildhunt_modifier = floor(scr_atr("LVL") * 0.6);
    var _modifier = _asceticism_modifier + _wildhunt_modifier;
    return [25 + _modifier, 50 + _modifier, 75 + _modifier];
}

function scr_fatigue_check()
{
    var _percent_limits = scr_fatigue_percent_limits();
    scr_check_condition("Fatigue", o_db_tired01, o_db_tired02, o_db_tired03, o_db_fatigue, _percent_limits[0], _percent_limits[1], _percent_limits[2]);
}

function scr_fatigue_change(argument0, argument1, argument2)
{
    if (argument1 == undefined)
        argument1 = false;

    if (argument2 == undefined)
        argument2 = o_player.Fatigue_Gain;

    if (argument1)
        _fatigue = scr_atr("Fatigue") + argument0;
    else
        _fatigue = scr_atr("Fatigue") + (argument0 * (100 / o_player.max_mp) * ((100 - argument2) / 100));
    
    var _fatigue = clamp(_fatigue, 0, 100);
    scr_atr_set_simple("Fatigue", _fatigue);
    scr_fatigue_check();
}
