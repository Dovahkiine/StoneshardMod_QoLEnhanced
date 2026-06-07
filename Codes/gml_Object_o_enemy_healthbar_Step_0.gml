if (!global.enemyhealthbars_enabled)
{
    instance_destroy()
    return;
}
if (!instance_exists(target))
{
    instance_destroy()
    return;
}
if ((!instance_exists(target)) || (!(variable_instance_exists(target, "HP"))))
{
    instance_destroy()
    return;
}
var _is_neutral = variable_instance_exists(target, "is_neutral") && target.is_neutral
var _is_hostile = variable_instance_exists(target, "is_hostile") && target.is_hostile
var _state = variable_instance_exists(target, "state") ? target.state : ""
if (_is_neutral || !(_is_hostile || _state == "attack" || _state == "search" || _state == "alarm"))
{
    instance_destroy()
    return;
}
current_health = max(0, target.HP)
if variable_instance_exists(target, "max_hp")
    max_health = target.max_hp
if (max_health > 0)
    health_percent = clamp((current_health / max_health), 0, 1)
offset_x = global.enemyhealthbars_offset_x
offset_y = global.enemyhealthbars_offset_y
bar_width = global.enemyhealthbars_bar_width
bar_height = global.enemyhealthbars_bar_height
bar_alpha = clamp(global.enemyhealthbars_alpha / 100, 0, 1)
border_width = global.enemyhealthbars_border_width
if (is_string(global.enemyhealthbars_color))
{
    if (global.enemyhealthbars_color == "红色")
        color_health = c_red
    else
        color_health = c_lime
}
else if (global.enemyhealthbars_color == 0)
    color_health = c_red
else
    color_health = c_lime
if (target.HP <= 0)
{
    instance_destroy()
    return;
}
