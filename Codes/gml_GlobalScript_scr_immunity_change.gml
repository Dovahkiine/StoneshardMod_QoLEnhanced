function scr_immunity_change(argument0)
{
    with (o_player)
    {
        var change = argument0;
        ds_map_replace(global.characterDataMap, "Immunity", scr_atr("Immunity") + change);
        var immunity = scr_atr("Immunity");

        if (immunity > 1000)
            scr_atr_set("Immunity", 1000);
        else if (immunity < 0)
            scr_atr_set("Immunity", 0);
    }

    Immunity = clamp(scr_atr("Immunity"), 0, 1000);
}
