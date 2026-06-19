if (!instance_exists(owner))
    exit

if (instance_is(owner, o_NPC))
    scr_npc_trigger_player_assault()

owner = owner.id

with (owner)
{
    // 原版这里刷新 Rune of Binding / Runic Power 相关持续时间。
    with (scr_instance_exists_in_list(o_b_stone_armor))
        scr_modifer_duration_change(3)
}

HP = scr_runic_boulder_get_hp()
max_hp = HP

// 真实伤害公式占位：
// 该值只用于 hover/formula 对齐和后续调试；实际召唤伤害在 _scr_qol_runic_boulder_apply_spawn_pull 中集中计算。
Arcane_Damage = 6 * (1 + (owner.Geomantic_Power / 100))
scr_skill_destroy_carpet()

// QoLEnhanced - 召唤落点从“邻近格击退”改为“5x5 范围吸引 + 真实伤害”。
// helper 内部复用裂隙同款 scr_cast_knockback(..., true)，碰撞与可能眩晕交给原版 knockback。
_scr_qol_runic_boulder_apply_spawn_pull(id)

// 原版地术被动触发。
scr_skill_call_passive(o_pass_skill_rune_of_binding, owner, owner)

// 原版 Rune of Fortifying 巨石自身减伤。
if (scr_passive_skill_is_open(o_pass_skill_rune_of_fortifying, owner))
    Damage_Received -= 25

// 新巨石完成基础初始化后先尝试与 7 格内同 owner 巨石合并。
// 上限结算必须放在合并之后：如果新召唤的巨石已经并入旧聚合体，场上实例数量会先下降，
// 此时不应触发原版“超过上限摧毁旧巨石”的逻辑。
_scr_qol_runic_boulder_try_merge(id)

// QoLEnhanced - 合并后再结算召唤上限。
// 如果 try_merge 因生成动画未播完而挂起，则 Step 会在真正合并完成后再调用 apply_limit。
// 这能覆盖“场上已达上限，新召唤巨石即将与旧巨石合并”的场景：不能在合并前误删旧巨石。
if (!(variable_instance_exists(id, "__qol_merge_pending") && __qol_merge_pending))
    _scr_qol_runic_boulder_apply_limit(id)

if (is_player(owner))
    scr_allturn()
else
    event_user(2)
