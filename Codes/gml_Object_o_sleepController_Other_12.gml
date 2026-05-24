var _skillBedIsOpen = instance_exists(o_pass_skill_halt) && o_pass_skill_halt.is_open;
var _campfireExists = scr_campfire_is_near(o_player);

with (owner)
{
    if (object_index == o_campbed_crafted)
        instance_destroy();
}

var _psychicModifier = 0.5 + (_skillBedIsOpen * 0.25);
var _healthModifier = 0.5 + (_skillBedIsOpen * 0.25);
var _fatigueModifier = 1 + (_skillBedIsOpen * 0.25);
scr_lifeParamsUpdate(sleepHours, 1, 1, 1, 0, 1, _psychicModifier, _psychicModifier, _healthModifier, _healthModifier, _fatigueModifier, 1);

if (_skillBedIsOpen)
{
    scr_modifier_change(o_player, o_b_fresh, 480 * sleepHours, 7200);
}

scr_characterStatsUpdateAdd("usedBedrolls", 1);
