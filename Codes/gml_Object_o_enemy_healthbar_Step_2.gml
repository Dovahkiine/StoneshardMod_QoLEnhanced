if (!instance_exists(target))
    return;
var _mx = mouse_x
var _my = mouse_y
var _hover = point_in_rectangle(_mx, _my, target.bbox_left, target.bbox_top, target.bbox_right, target.bbox_bottom)
var _bright = 0.14
if _hover
{
    color_health = merge_color(color_health, c_white, _bright)
    color_background = merge_color(0x1B1B1B, c_white, _bright)
    color_border = merge_color(c_black, c_white, _bright)
    bar_alpha = 1
}
else
{
    color_background = 1776411
    color_border = 0
    bar_alpha = clamp(global.enemyhealthbars_alpha / 100, 0, 1)
}
var _hover_pull = 2
depth = target.depth - 1 - (_hover ? _hover_pull : 0)
