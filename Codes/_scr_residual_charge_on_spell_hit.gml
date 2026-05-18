function _scr_residual_charge_on_spell_hit(argument0, argument1)
{
    if (!instance_exists(argument1))
        exit;
    if (!is_player(argument0))
        exit;
    with (o_pass_skill_residual_charge)
    {
        if (is_open && owner == argument0)
        {
            target = argument1;
            event_user(5);
            target = -4;
        }
    }
}
