function _scr_qol_runic_boulder_apply_spawn_pull(argument0)
{
    // QoLEnhanced - 符文巨石召唤落点吸引。
    // argument0 是新生成的 o_runic_boulder。逻辑放在 helper 中，是为了让 o_runic_boulder_Alarm_1 保持主流程可读，
    // 同时后续调整吸引范围、真实伤害公式、眩晕概率时只改这一处。
    if (!instance_exists(argument0))
        return;
    
    var _boulder = argument0;
    var _owner = argument0.owner;
    
    if (!instance_exists(_owner))
        return;
    
    // 5x5 范围等价于以巨石为中心，横纵各 2 格。只检查 o_unit，避免影响可破坏物、门、容器等非单位目标。
    with (o_unit)
    {
        if (id != _owner)
        {
            var _dx = abs((x div 26) - (_boulder.x div 26));
            var _dy = abs((y div 26) - (_boulder.y div 26));
            
            if (_dx <= 2 && _dy <= 2)
            {
                // 真实伤害公式占位：
                // 当前保留原版同量级：6 * (1 + 地术法力%) * 魔法威力%，但走 scr_simple_damage 直接扣血。
                // 主人后续调伤害时优先改这里；不要改回 scr_skill_damage，否则会重新走抗性/护甲/法术伤害结算。
                var _crit = _boulder.is_crit ? max(1, _owner.Miracle_Power / 100) : 1;
                var _damage = (6 * (1 + (_owner.Geomantic_Power / 100)) * _owner.Magic_Power) / 100;
                _damage *= _crit;
                
                last_attacker = _owner;
                scr_simple_damage(id, _damage);
                scr_damage_info(id, _damage, _boulder.is_crit);
                
                // 裂隙 Schism 使用 scr_cast_knockback(center, target, distance, true) 将目标向中心吸引。
                // 这里让 5x5 边缘目标最多移动 2 格，靠近中心的目标移动 1 格，交给原版 knockback 处理碰撞与可能眩晕。
                var _pull_distance = max(1, max(_dx, _dy));
                _pull_distance = min(_pull_distance, 2);
                scr_cast_knockback(_boulder, id, _pull_distance, true);
            }
        }
    }
}
