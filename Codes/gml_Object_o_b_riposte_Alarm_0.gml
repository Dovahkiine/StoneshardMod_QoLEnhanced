// ================================================================
//  Alarm_0 — 精准格挡后 1 step 触发，执行反击
//  此时 scr_damage 的所有 buff 遍历已完成，add_damage 可安全归零
// ================================================================

// 归零免疫标志，防止影响后续攻击
add_damage = 0;

if (!instance_exists(counter_target))
{
    counter_target     = noone;
    raw_absorbed_damage = 0;
    exit;
}

with (target) // target = 玩家
{
    var _abs_dmg     = other.raw_absorbed_damage;
    var _orig_target = other.counter_target;

    // ---- 确定反击目标 ----
    // 优先：攻击者在相邻 1 格内 → 直接反击
    // 否则：在周围相邻敌人中随机选一个
    var _real_target = noone;

    if (instance_exists(_orig_target) && scr_tile_distance(id, _orig_target) <= 1)
    {
        _real_target = _orig_target;
    }
    else
    {
        var _adj = [];
        with (o_enemy)
        {
            if (instance_exists(id) && scr_tile_distance(id, other) <= 1)
                array_push(_adj, id);
        }
        if (array_length(_adj) > 0)
            _real_target = _adj[irandom(array_length(_adj) - 1)];
    }

    if (!instance_exists(_real_target))
    {
        other.counter_target      = noone;
        other.raw_absorbed_damage = 0;
        exit;
    }

    // ================================================================
    //  反击伤害 = 原始伤害 × 3 + 玩家三维属性总和 × 2（作为 Arcane 附加）
    //  武器伤害仍正常计算，此额外伤害叠加在其上
    // ================================================================
    var _prev_arcane = Arcane_Damage;
    Arcane_Damage    = ((STR + AGL + PRC) - 30) + _abs_dmg * 2;

    // ---- 临时将命中率拉满，确保反击必中 ----
    var _prev_hit = Hit_Chance;
    Hit_Chance = 800;

    // ---- 执行反击（force_attack=true 跳过回合计时，arg1=true 标记为反击）----
    force_attack = true;
    scr_attack(_real_target, true);
    force_attack = false;

    // ---- 恢复临时修改的属性 ----
    Arcane_Damage = _prev_arcane;
    Hit_Chance    = _prev_hit;

    // ---- 检测是否击杀 → 累加免费回合（每次反击击杀 +2）----
    if (!instance_exists(_real_target) || _real_target.HP < 1) global.got_free_turn += 1;
}

// 清理
counter_target     = noone;
raw_absorbed_damage = 0;
