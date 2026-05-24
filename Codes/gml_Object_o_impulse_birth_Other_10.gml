if (!is_execute)
{
    if (instance_exists(owner))
    {
        with (o_skill_aoe_zone)
        {
            if (main_owner == other.owner)
                instance_destroy();
        }
        
        with (owner)
        {
            with (scr_guiAnimation_ext(x, y, s_impulse_cast_back))
                depth_offset = 1;
            
            scr_guiAnimation_ext(x, y, s_impulse_cast_front);
        }
        
        is_execute = true;
        var _id = id;
        var _create_impact = false;
        var _aoe_range = clamp(1 + floor(((owner.WIL + owner.Electromantic_Power) * 2 + owner.Magic_Power) / 100), 2, 6);
        
        with (o_unit)
        {
            if (id != other.owner.id && scr_tile_distance_min(other.owner, id) <= _aoe_range)
            {
                _create_impact = true;
                
                with (instance_create_depth(x, y, 0, o_impulse_impact))
                {
                    damage = _id.damage;
                    owner = _id.owner;
                    name = _id.name;
                    xx = other.x;
                    yy = other.y;
                    is_crit = _id.is_crit;
                }
            }
        }
        
        if (!_create_impact && is_player(owner))
            scr_allturn();
        
        instance_create_depth(x, y, 0, o_explosion_hole);
        
        repeat (4 + irandom(4))
        {
            with (instance_create_depth(x + irandom_range(-3, 3), y, 0, o_lighting_particle))
            {
                speed = 4 + random(4);
                direction = random_range(20, 160);
            }
        }
    }
}
