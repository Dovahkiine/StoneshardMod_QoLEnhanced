function _scr_qol_runic_boulder_merge_damage(argument0, argument1, argument2, argument3, argument4)
{
    // QoLEnhanced - 符文巨石合并沿途伤害与挤开。
    // argument0: 参与合并的巨石数组
    // argument1 / argument2: 合并点像素坐标
    // argument3: 奇数距离碰撞倍率；两石距离为奇数时传入 1.25，否则 1
    // argument4: 合并中心偏移强度，第一阶段只用于注释和未来动画/震屏扩展，当前不直接参与数值。
    //
    // 返回值：沿途敌人受到的最大真实伤害。调用方会把这个值的 25% 反作用到参与合并的巨石。
    var _boulders = argument0;
    var _center_x = argument1;
    var _center_y = argument2;
    var _odd_multiplier = argument3;
    var _max_damage = 0;
    var _count = array_length(_boulders);
    
    if (_count <= 0)
        return 0;
    
    var _owner = _boulders[0].owner;
    
    if (!instance_exists(_owner))
        return 0;
    
    // 第一阶段的“沿途”采用每块巨石到合并点形成的轴对齐包围盒，并向外扩 1 格。
    // 这样能覆盖直线和斜向路径上的单位，避免手写复杂线段栅格导致 MSL 编译风险。
    // 后续若要更精确，可替换为 Bresenham 路径采样，但接口保持不变。
    for (var i = 0; i < _count; i++)
    {
        var _boulder = _boulders[i];
        
        if (!instance_exists(_boulder))
            continue;
        
        var _min_x = min(_boulder.x, _center_x) - 26;
        var _max_x = max(_boulder.x, _center_x) + 26;
        var _min_y = min(_boulder.y, _center_y) - 26;
        var _max_y = max(_boulder.y, _center_y) + 26;
        
        with (o_unit)
        {
            if (x >= _min_x && x <= _max_x && y >= _min_y && y <= _max_y)
            {
                var _dist_to_center = max(abs((x div 26) - (_center_x div 26)), abs((y div 26) - (_center_y div 26)));
                var _dist_factor = 1 + max(0, 4 - _dist_to_center) * 0.25;
                
                // 合并真实伤害公式占位：
                // 单位越靠近中心，_dist_factor 越高；奇数格碰撞 _odd_multiplier = 1.25。
                // 主人后续平衡时优先调 _base_damage，不需要动路径、挤开或巨石自伤流程。
                var _base_damage = (10 * (1 + (_owner.Geomantic_Power / 100)) * _owner.Magic_Power) / 100;
                var _damage = _base_damage * _dist_factor * _odd_multiplier;
                
                last_attacker = _owner;
                var _actual_damage = scr_simple_damage(id, _damage);
                scr_damage_info(id, _actual_damage, false);
                _max_damage = max(_max_damage, _actual_damage);
                
                // 先尝试把沿途单位从合并中心挤开。这里使用普通击退方向，目标会远离 center boulder。
                // 碰撞、阻挡、可能眩晕仍由原版 knockback 系统处理。
                scr_cast_knockback(_boulder, id, 1, false);
            }
        }
    }
    
    // 合并结束后仍然贴近中心的敌人获得 2 回合限制移动。这里使用 o_db_immob 符号名，避免硬编码 ID。
    with (o_unit)
    {
        var _near_center = max(abs((x div 26) - (_center_x div 26)), abs((y div 26) - (_center_y div 26))) <= 1;
        
        if (_near_center && id != _owner)
            scr_effect_create(o_db_immob, 2, id, _owner);
    }
    
    return _max_damage;
}
