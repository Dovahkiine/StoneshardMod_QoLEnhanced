// ================================================================
//  _scr_scale_enemy_csv_by_level
//
//  根据玩家当前等级对 global.enemy_balance_csv 中的关键属性进行缩放。
//
//  缩放列：
//    STR / AGL / Vitality / PRC / WIL（按表头查找，避免列号漂移）
//
//  缓存机制：
//    - 首次调用时执行缩放并记录当前等级
//    - 后续调用时若等级未变化，直接返回（静默）
//    - 等级变化时从原始备份重新计算，防止倍率叠加
//
//  缩放公式：
//    multiplier = clamp(0.95 + level_factor * stat_factor, 1, 4)
//    Vitality 使用更高倍率并额外增加生命成长。
// ================================================================
function _scr_scale_enemy_csv_by_level()
{
    // ---- 读取当前玩家等级 ----
    var _lvl = scr_atr("LVL");

    // ---- 缓存检查：等级未变化则静默退出 ----
    if (global.enemy_balance_by_LVL == _lvl)
        exit;

    // ---- 从游戏原始函数重新加载干净的表 ----
    // 每次等级变化都从 table_mobs_stats() 重建，避免缩放叠加
    var _raw_table = scr_tableLoad(table_mobs_stats);
    var _stat_names = ["STR", "AGL", "Vitality", "PRC", "WIL"];
    var _stat_cols = [];
    var _header = _raw_table[0];
    var _col_vit = -1;

    for (var _si = 0; _si < array_length(_stat_names); _si++)
    {
        var _col = -1;

        for (var _hi = 0; _hi < array_length(_header); _hi++)
        {
            if (_header[_hi] == _stat_names[_si])
            {
                _col = _hi;
                break;
            }
        }

        array_push(_stat_cols, _col);

        if (_stat_names[_si] == "Vitality")
            _col_vit = _col;
    }

    for (var _r = 1; _r < array_length(_raw_table); _r++)
    {
        var _row = _raw_table[_r];

        for (var _ci = 0; _ci < array_length(_stat_cols); _ci++)
        {
            var _col = _stat_cols[_ci];

            if (_col < 0 || _col >= array_length(_row)) continue;

            var _raw_val = _row[_col];

            // 空字符串、非数值、零或负值不处理
            if (!is_string(_raw_val) || _raw_val == "" || is_undefined(_raw_val)) continue;

            var _val = real(_raw_val);

            if (_val <= 0) continue;
            // ---- 计算缩放倍率 ----
            var _lvl_f  = lerp(0.2, 4, _lvl / 80); 
            var _stat_f = lerp(0.2, 2, _val / 40);
            if (_col == _col_vit)
            {
                _val += 20; // 基础活力增加20点
                var _multiplier = clamp(0.95 + power(_lvl_f, 1.5) * power(_stat_f, 1.25), 1.5, 8.0);
            }
            else
            {
                _multiplier = clamp(0.95 + power(_lvl_f, 1.3) * power(_stat_f, 1.2), 1.0, 4.5);
            }
            var _new_val    = round(_val * _multiplier);

                
            _raw_table[_r][_col] = _new_val;
        }
    }

    // ---- 写回全局表并更新缓存标记 ----
    global.enemy_balance_csv    = _raw_table;
    global.enemy_balance_by_LVL = _lvl;
}
