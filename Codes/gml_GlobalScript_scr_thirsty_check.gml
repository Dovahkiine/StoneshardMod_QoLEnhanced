function scr_thirsty_percent_limits()
{
    var _asceticism_modifier = 5 * (instance_exists(o_pass_skill_asceticism) && o_pass_skill_asceticism.is_open);
    var _wildhunt_modifier = floor(scr_atr("LVL") * 0.6);
    var _modifier = _asceticism_modifier + _wildhunt_modifier;
    return [25 + _modifier, 50 + _modifier, 75 + _modifier];
}

function scr_thirsty_check()
{
    var _percent_limits = scr_thirsty_percent_limits();
    scr_check_condition("Thirsty", o_db_thirst1, o_db_thirst2, o_db_thirst3, o_db_thirst, _percent_limits[0], _percent_limits[1], _percent_limits[2]);
}
