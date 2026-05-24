event_inherited();

if (damage != 0 && attacker == owner)
{
    duration += 2;

    with (owner)
    {
        with (scr_instance_exists_in_list(o_b_ini_seized))
            duration += 2;
    }
}
