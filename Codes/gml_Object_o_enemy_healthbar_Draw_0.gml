if (!instance_exists(target))
    return;
if (!target.visible)
    return;
if (health_percent >= 1)
    return;
var _bar_x = (target.bbox_left + target.bbox_right) * 0.5 + offset_x
var _bar_y = target.bbox_top + offset_y
draw_set_alpha(bar_alpha)
draw_set_color(color_background)
draw_rectangle((_bar_x - bar_width / 2), _bar_y, (_bar_x + bar_width / 2), (_bar_y + bar_height), false)
var _health_width = bar_width * health_percent
var _left = _bar_x - bar_width / 2
var _right = _bar_x + bar_width / 2
var _top = _bar_y
var _bottom = _bar_y + bar_height
var _split = _top + bar_height * 0.8
var _color_dark = merge_color(color_health, c_black, 0.38)
draw_set_color(color_health)
draw_rectangle(_left, _top, (_left + _health_width), _split, false)
draw_set_color(_color_dark)
draw_rectangle(_left, _split, (_left + _health_width), _bottom, false)
var _bw = border_width
if (_bw > 0)
{
    draw_set_color(color_border)
    draw_rectangle((_left - _bw), (_top - _bw), (_right + _bw), (_top - 1), false)
    draw_rectangle((_left - _bw), (_bottom + 1), (_right + _bw), (_bottom + _bw), false)
    draw_rectangle((_left - _bw), _top, (_left - 1), _bottom, false)
    draw_rectangle((_right + 1), _top, (_right + _bw), _bottom, false)
}
draw_set_alpha(1)
draw_set_color(c_white)
