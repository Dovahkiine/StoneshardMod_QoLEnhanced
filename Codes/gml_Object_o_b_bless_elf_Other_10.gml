event_inherited();

var _last_stage = stage;
var _in_battle = false;

if (instance_exists(target))
    _in_battle = target.in_battle || scr_getAgredMobsCount(true);
else
    _in_battle = scr_getAgredMobsCount(true);

save_counter++;

if (_in_battle)
{
    if (stage > 120 && save_counter >= 12)
    {
        save_counter = 0;
        stage = max(120, stage - 1);
    }
}
else
{
    if (stage < 200 && save_counter >= 24)
    {
        save_counter = 0;
        stage = min(200, stage + 1);
    }
}

if (_last_stage != stage)
    event_user(5);
