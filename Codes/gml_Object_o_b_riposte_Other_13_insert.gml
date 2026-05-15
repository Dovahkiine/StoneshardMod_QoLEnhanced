// ================================================================
//  Other_13 — 被攻击时触发（event_user(3) 来自 scr_damage）
//  可用变量: damage（防御削减后的 net 伤害）/ attacker / attack_result / add_damage / target
//  新增变量: target.__qol_riposte_raw（scr_attack 在命中判定前注入的攻击者潜在伤害）
// ================================================================

// ================================================================
//  精准格挡：完全免疫 + 方向判定 + 记录原始伤害用于反击
//  触发条件：buff 本次尚未触发过（is_riposte_ready）且有有效攻击者
//  当 riposte_direction < 0 时全向格挡，否则只格挡指定方向
// ================================================================
if (is_riposte_ready && !is_execute && instance_exists(attacker))
{
    // ---- 从 target（buff 持有者/玩家）读取防御削减前的原始伤害 ----
    var _raw = 0;
    if (instance_exists(target))
        _raw = target.__qol_riposte_raw;

    if (_raw > 0)
    {
        // ---- 方向判定 ----
        var _blocked = true;

        if (riposte_direction >= 0 && riposte_direction <= 7)
        {
            // 计算攻击者相对于玩家所处的 8 方向索引
            var _angle = point_direction(target.x, target.y, attacker.x, attacker.y);
            var _attack_dir = (round(_angle / 45) mod 8);
            _blocked = (_attack_dir == riposte_direction);
        }

        if (_blocked)
        {
            // ---- 记录原始伤害供 Alarm_0 反击使用 ----
            raw_absorbed_damage = _raw;

            // ---- 完全免疫本次实际扣血：令 scr_damage 的 arg1 += add_damage 后归零 ----
            add_damage = -damage;

            // ---- 记录反击目标 ----
            counter_target   = attacker;
            is_execute       = true;
            is_riposte_ready = false;

            // ---- 视觉反馈：金色 = 精准格挡成功 ----
            with (target)
                scr_guiAnimation_ext(x, y, 359, 1, 1, 1, c_yellow, 0);

            // ---- 1 step 后执行反击（等待 scr_damage 的 buff 遍历完全结束）----
            alarm[0] = 1;
        }
    }
}
