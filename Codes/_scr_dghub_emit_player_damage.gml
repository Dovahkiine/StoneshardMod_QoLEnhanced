function _scr_dghub_emit_player_damage(argument0, argument1, argument2, argument3, argument4 = -4)
{
    if (argument0 <= 0)
        return false;

    if (variable_global_exists("qol_dghub_enabled") && !global.qol_dghub_enabled)
        return false;

    var _line = "{\"event\":\"player_damaged\""
        + ",\"damage\":" + string(argument0)
        + ",\"hp_before\":" + string(argument1)
        + ",\"hp_after\":" + string(argument2)
        + ",\"max_hp\":" + string(argument3)
        + ",\"attacker_id\":" + string(argument4)
        + ",\"time_ms\":" + string(current_time)
        + "}" + "\n";

    scr_fileSave(working_directory, "qol_dghub_events.jsonl", _line, true);
    return true;
}
