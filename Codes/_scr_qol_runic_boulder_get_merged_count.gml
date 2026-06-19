function _scr_qol_runic_boulder_get_merged_count(argument0)
{
    // QoLEnhanced - 符文巨石融合数量读取接口。
    // 后续其它地术技能需要根据“这块符文巨石由多少块基础巨石融合而成”调整效果时，
    // 优先调用这个 helper，而不是直接读取内部变量名。这样以后若变量结构变化，只需要改这一处。
    if (!instance_exists(argument0))
        return 0;
    
    if (variable_instance_exists(argument0, "__qol_merged_count"))
        return max(1, argument0.__qol_merged_count);
    
    return 1;
}
