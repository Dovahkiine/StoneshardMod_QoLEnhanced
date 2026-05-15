// ================================================================
//  _scr_scale_enemy_csv_by_level
//
//  根据玩家当前等级对 global.enemy_balance_csv 中的关键属性进行缩放。
//
//  缩放列：
//    70-74 → STR / AGL / Vitality / PRC / WIL（五维属性）
//
//  缓存机制：
//    - 首次调用时执行缩放并记录当前等级
//    - 后续调用时若等级未变化，直接返回（静默）
//    - 等级变化时从原始备份重新计算，防止倍率叠加
//
//  缩放公式：level_t = lvl²/100, stat_t = val/8
//           multiplier = clamp(1 + level_t×(0.4+0.6×stat_t), 1, 3)
// ================================================================
function _scr_scale_enemy_csv_by_level()
{
    // ---- 读取当前玩家等级 ----
    var _lvl = scr_atr("LVL");

    // ---- 缓存检查：等级未变化则静默退出 ----
    if (variable_global_exists("enemy_balance_by_LVL")
        && global.enemy_balance_by_LVL == _lvl)
        exit;

    // ---- 首次运行：从游戏原始函数重新加载干净的表 ----
    // 每次等级变化都从 table_mobs_stats() 重建，避免缩放叠加
    var _raw_table = scr_tableLoad(table_mobs_stats);
    var _stat_cols = [70, 71, 72, 73, 74]; // STR AGL Vitality PRC WIL
    // ---- 遍历表并应用缩放 ----
    var _row_count = array_length(_raw_table);

    for (var _r = 1; _r < array_length(_raw_table); _r++)
    {
        var _row = _raw_table[_r];

        for (var _ci = 0; _ci < array_length(_stat_cols); _ci++)
        {
            var _col = _stat_cols[_ci];

            if (_col >= array_length(_row)) continue;

            var _raw_val = _row[_col];

            // 空字符串、非数值、零或负值不处理
            if (!is_string(_raw_val) || _raw_val == "" || is_undefined(_raw_val)) continue;

            var _val = real(_raw_val);

            if (_val <= 0) continue;
            // ---- 计算缩放倍率 ----
            var _lvl_f  = lerp(0.2, 8, _lvl / 80); 
            var _stat_f = lerp(0.2, 2, _val / 40);

            var _multiplier = clamp(0.95 + (_lvl_f * _stat_f), 1.0, 4.0);
            var _new_val    = round(_val * _multiplier);

            _raw_table[_r][_col] = _new_val;
        }
    }

    // ---- 写回全局表并更新缓存标记 ----
    global.enemy_balance_csv    = _raw_table;
    global.enemy_balance_by_LVL = _lvl;
}
