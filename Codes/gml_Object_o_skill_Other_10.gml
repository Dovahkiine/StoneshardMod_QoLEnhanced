if (instance_exists(aoe_target))
{
    if (pointed == "No Target")
    {
        yscale = 1;
        event_user(3);
        event_user(5);

        if (duration && !tactics_exist)
            alarm[1] = 2;
    }
    else
    {
        scr_escapeButtonListAdd();

        with (o_skill)
            is_activate = false;

        is_activate = true;
        global.skill_activate = true;
        var xx = scr_round_cell(aoe_target.xx);
        var yy = scr_round_cell(aoe_target.yy);

        if (indication_enemy)
            scr_create_aoe_indicator_only(aoe_target, 1, always_visible);

        if (AOE_Len)
        {
            i_id = scr_create_aoe(aoe_target, AOE_Len, AOE_Width, is_moving, target_group);
        }
        else if (pointed == "Target Point")
        {
            if (skill == "Riposte")
            {
                with (instance_create_depth(mouse_x, mouse_y, 0, o_riposte_dir_indicator))
                    range = 1;
            }
            else
            {
                with (instance_create_depth(mouse_x, mouse_y, 0, o_skill_tile_indicator))
                    range = other.range;
            }
        }

        with (instance_create_depth(xx + 13, yy + 13, 0, o_startcast_loop))
        {
            startcast_sprite_tag = other.startcast_sprite_tag;

            if (other.loop_sound != -4)
                snd_loop = scr_audio_play_at_loop(other.loop_sound);

            event_user(0);
        }

        with (o_controller)
            event_user(1);

        if (object_index == o_skill_attack_mode_shot)
        {
            with (o_player)
            {
                scr_collision_clear(o_controller.newgrid, x div 26, y div 26);
                scr_stop_player();
                var __qol_xx = self.xx;
                var __qol_yy = self.yy;
                scr_change_coordinat(__qol_xx, __qol_yy, id, true);

                with (o_fogrender)
                    event_user(2);
            }
        }

        var i = -range;

        while (i <= range)
        {
            var j = -range;

            while (j <= range)
            {
                var _targetX = xx + (i * 26) + 13;
                var _targetY = yy + (j * 26) + 13;

                if (_targetX >= 0 && _targetY >= 0 && _targetX <= room_width && _targetY <= room_height)
                {
                    if (script_execute(filter, aoe_target.x, aoe_target.y, _targetX, _targetY, false, range))
                    {
                        with (instance_create_depth(_targetX, _targetY, 0, o_aoe_range))
                        {
                            delete_on_line = other.delete_on_line;
                            visible_check = other.visible_check;
                            range = other.range;
                            var _inst = scr_tile_get_instance(x, y, 0, 0);

                            if (_inst && delete_on_line)
                            {
                                if (!scr_can_interract_path(_inst, other.aoe_target, other.range))
                                    instance_destroy();
                            }

                            event_perform(ev_step, ev_step_normal);
                            var _obj = ds_grid_get_ext(o_controller.posgrid, grid_x, grid_y);

                            if (_obj && instance_exists(_obj) && _obj.object_index == o_tile_transition)
                                instance_destroy();
                        }
                    }
                }

                j++;
            }

            i++;
        }

        if (skill_single_tile_check)
        {
            var _bor = 0;
            var _checked = true;
            var _range_count = 1000;

            repeat (_range_count)
            {
                var _x = aoe_target.x + _bor;
                var _y = aoe_target.y + _bor;
                var _range = skill_single_tile_check_range;
                _checked = true;

                with (o_aoe_range)
                {
                    var _cx = x;
                    var _cy = y;
                    var _distance = scr_tile_distance_xy(_x, _y, x, y);

                    if (_distance < _range)
                        continue;

                    var _width = sprite_width;
                    var _height = sprite_height;
                    var _t = place_meeting(_cx, _cy - _height, o_aoe_range);
                    var _b = place_meeting(_cx, _cy + _height, o_aoe_range);
                    var _l = place_meeting(_cx - _width, _cy, o_aoe_range);
                    var _r = place_meeting(_cx + _width, _cy, o_aoe_range);
                    var _tl = place_meeting(_cx - _width, _cy - _height, o_aoe_range);
                    var _tr = place_meeting(_cx + _width, _cy - _height, o_aoe_range);
                    var _bl = place_meeting(_cx - _width, _cy + _height, o_aoe_range);
                    var _br = place_meeting(_cx + _width, _cy + _height, o_aoe_range);
                    var _count = 0;

                    if (_t)
                        _count++;

                    if (_b)
                        _count++;

                    if (_l)
                        _count++;

                    if (_r)
                        _count++;

                    if (_tl)
                        _count++;

                    if (_tr)
                        _count++;

                    if (_bl)
                        _count++;

                    if (_br)
                        _count++;

                    if (_count < 1)
                    {
                        instance_destroy();
                        _checked = false;
                    }
                }

                if (_checked)
                    break;
            }
        }
    }
}
