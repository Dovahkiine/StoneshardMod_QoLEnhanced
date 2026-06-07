guiType = -1
guiParent = -4
guiChildrenList = ds_list_create()
ds_list_clear(guiChildrenList)
is_container = false
parent_container = -4
target = -4
if (!variable_global_exists("enemyhealthbars_enabled"))
    global.enemyhealthbars_enabled = 1
if (!variable_global_exists("enemyhealthbars_alpha"))
    global.enemyhealthbars_alpha = 75
if (!variable_global_exists("enemyhealthbars_color"))
    global.enemyhealthbars_color = "绿色"
if (!variable_global_exists("enemyhealthbars_offset_x"))
    global.enemyhealthbars_offset_x = 0
if (!variable_global_exists("enemyhealthbars_offset_y"))
    global.enemyhealthbars_offset_y = -3
if (!variable_global_exists("enemyhealthbars_bar_height"))
    global.enemyhealthbars_bar_height = 2
if (!variable_global_exists("enemyhealthbars_bar_width"))
    global.enemyhealthbars_bar_width = 22
if (!variable_global_exists("enemyhealthbars_border_width"))
    global.enemyhealthbars_border_width = 1
offset_x = global.enemyhealthbars_offset_x
offset_y = global.enemyhealthbars_offset_y
bar_width = global.enemyhealthbars_bar_width
bar_height = global.enemyhealthbars_bar_height
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
color_background = 1776411
color_border = 0
bar_alpha = clamp(global.enemyhealthbars_alpha / 100, 0, 1)
current_health = 0
max_health = 0
health_percent = 1
