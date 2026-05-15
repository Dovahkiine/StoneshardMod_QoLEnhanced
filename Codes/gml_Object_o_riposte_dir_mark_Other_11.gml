// Other_11 — 后备：如果 Alarm_1 因未知原因未创建 buff，在此补创建
// 不调用 event_inherited() 以跳过父类 o_invisible_mark 的 scr_skill_damage()
if (instance_exists(owner) && is_player(owner))
{
    var _buff = scr_instance_exists_in_list(__asset_get_index("o_b_riposte"), owner.buffs);
    if (_buff == -4)
    {
        if (target_x != 0 || target_y != 0)
        {
            var _angle = point_direction(o_player.x, o_player.y, target_x, target_y);
            o_player.__riposte_dir = (round(_angle / 45) mod 8);
        }
        else
            o_player.__riposte_dir = -4;
        scr_effect_create(__asset_get_index("o_b_riposte"), 3, owner, owner);
        scr_allturn();
    }
}
