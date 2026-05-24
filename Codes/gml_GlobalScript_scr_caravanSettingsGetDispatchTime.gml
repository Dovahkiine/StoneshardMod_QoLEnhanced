function scr_caravanSettingsGetDispatchTime(argument0, argument1)
{
    if (0 || global.playerGridX == -4)
        return 0;

    var _modifiersTime = scr_caravanFollowerPerksModifiersGetValue("caravanDispatchTime");
    return math_round(1.5 + ((1.5 * _modifiersTime) / 100));
}
