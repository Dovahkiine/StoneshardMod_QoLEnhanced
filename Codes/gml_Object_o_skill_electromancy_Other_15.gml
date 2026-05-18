var _crit = is_crit;
event_inherited();

if (instance_exists(o_player))
{
    scr_skill_call_passive(o_pass_skill_residual_charge, o_player.id, -4, _crit);
    scr_skill_call_passive(o_pass_skill_resonance_cascade, o_player.id, -4, _crit);
    scr_skill_electromancy_water(o_player);
}
