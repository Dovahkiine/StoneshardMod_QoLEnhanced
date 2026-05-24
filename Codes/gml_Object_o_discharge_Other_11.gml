var _shock_damage_static = 0;
if (instance_exists(owner))
{
    with (owner)
    {
        if (is_player())
        {
            _shock_damage_static = (7 + (WIL + Electromantic_Power) * 0.1) * (100 + Electromantic_Power + Magic_Power * 0.5) / 100;
            global.got_free_turn++;
        }
        else
        {
            _shock_damage_static = 8 * (100 + Electromantic_Power + Magic_Power * 0.5) / 100;
        }
    }
    Shock_Damage = max(1, math_round(_shock_damage_static * random_range(1, 210) / 100));
}

if (instance_exists(target))
{
    var _dir = direction;
    
    with (scr_skill_create_impact(target.x, target.y, s_discharge_hit))
    {
        image_angle = 0;
        
        repeat (8 + irandom(4))
        {
            with (instance_create_depth(x + irandom_range(-3, 3), y, 0, o_lighting_particle))
            {
                speed = 4 + random(4);
                direction = random_range(20, 160);
            }
        }
    }
    
    if (!object_is_ancestor(target.object_index, o_unit))
        scr_skill_electromancy_water(-4, Shock_Damage / 2);
}
else
{
    scr_skill_electromancy_water(-4, Shock_Damage / 2);
    instance_destroy();
}
