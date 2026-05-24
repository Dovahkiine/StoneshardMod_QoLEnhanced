depth = -y + 18;

var _riposte_active = false;
with (o_skill)
{
    if (is_activate && skill == "Riposte")
        _riposte_active = true;
}

if (!global.skill_activate || !_riposte_active)
{
    instance_destroy();
    exit;
}

if (instance_exists(o_floor_target))
{
    x = o_floor_target.x;
    y = o_floor_target.y;
    grid_x = x div 26;
    grid_y = y div 26;

    var _angle = point_direction(o_player.x, o_player.y, x, y);
    image_angle = round(_angle / 45) * 45;
}
else
    instance_destroy();

image_alpha = 1;
