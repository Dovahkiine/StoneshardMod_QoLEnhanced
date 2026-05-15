depth = -y + 18;

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

image_alpha = place_meeting(x, y, o_aoe_range);
