function scr_pain_percent_limits()
{
    var _asceticism_modifier = 5 * (instance_exists(o_pass_skill_asceticism) && o_pass_skill_asceticism.is_open);
    var _wildhunt_modifier = floor(scr_atr("LVL") * 0.6);
    
    var _modifier = _asceticism_modifier + _wildhunt_modifier;
    return [25 + _modifier, 50 + _modifier, 75 + _modifier];
}

function scr_paincheck()
{
    var _percent_limits = scr_pain_percent_limits();
    scr_check_condition("Pain", o_db_pain1, o_db_pain2, o_db_pain3, o_d_pain, _percent_limits[0], _percent_limits[1], _percent_limits[2]);
}
