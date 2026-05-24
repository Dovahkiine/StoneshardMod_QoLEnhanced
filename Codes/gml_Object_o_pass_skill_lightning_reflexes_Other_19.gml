event_inherited();

if (instance_exists(o_player) && is_open)
{
    if (scr_instance_exists_in_list(o_b_fresh, o_player.buffs))
        scr_modifier_change(o_player, o_b_fresh, 120, 7200);
}
