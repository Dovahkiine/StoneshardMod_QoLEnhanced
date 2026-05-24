instance_destroy(c_state);
instance_destroy(o_db_fragile);
var _psychicModifier = 1;
var _fatigueModifier = 1;
var _freshDuration = 120;

switch (room)
{
    case r_tavern_SentinelInn2floor:
        _psychicModifier = 2;
        _fatigueModifier = 2;
        break;

    case r_tavern_GoldenSpikeInn2floor:
        _psychicModifier = 3;
        _fatigueModifier = 3;
        _freshDuration = 180;
        scr_globaltile_set("Breakfast_Available", true);
        scr_npc_golden_spike_breakfast_start();
        break;

    case r_tavern_ThreePots2floor:
        _psychicModifier = 1.5;
        _fatigueModifier = 2;
        break;

    case r_DocksTavern02floor:
        _psychicModifier = 1;
        _fatigueModifier = 1.5;
        _freshDuration = 80;
        break;

    default:
        _psychicModifier = 1;
        _fatigueModifier = 1.5;
        break;
}

scr_lifeParamsUpdate(sleepHours, 1, 1, 1, 0, 1, _psychicModifier, _psychicModifier, 1, 1, _fatigueModifier, 1);
_freshDuration = max(_freshDuration * 4, 480);
scr_modifier_change(o_player, o_b_fresh, _freshDuration * sleepHours, 7200);
