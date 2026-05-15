# QoLEnhanced — 约娜天赋"奇观致死"免费回合

## 概述

约娜 (Jonna / `o_runaway_wizzard`) 专属天赋：法术暴击击杀任意敌人后，获得额外免费回合（解锁移动）。

实现方式：**施法前快照 → 回合开始时对比**。

---

## 数据流

```
[施法瞬间]                        [回合开始]
    │                                  │
    ▼                                  ▼
o_skill_Other_13          scr_allturn()
(大多数技能)              遍历 jonna_pre_cast_enemies
    │                     如果任一敌人死亡 → lock_movement = false
    ▼                     清空数组
o_planar_exchange
Alarm_0
(维度错换专用)
    │
    ▼
global.jonna_pre_cast_enemies = [id1, id2, ...]
```

---

## 关键文件

| 文件 | 作用 |
|------|------|
| `gml_Object_o_perks_Create_0.gml` | 全局变量初始化 `global.jonna_pre_cast_enemies = []` |
| `gml_Object_o_skill_Other_13.gml` (L246-252) | **主快照点** — 覆盖绝大多数技能施法 |
| `gml_Object_o_planar_exchange_Alarm_0.gml` (L2-9) | **补充快照点** — 维度错换专用 |
| `gml_GlobalScript_scr_allturn.gml` (L6-23) | 回合开始时检查快照，触发免费回合 |
| `QoLEnhanced.cs` (L564-565) | MSL 注入代码：全局变量初始化 |
| `debug.gml` | 编译后生成的完整代码副本 |

---

## 为什么维度错换需要独立快照点

维度错换 (Planar Exchange) 的结算流程不走 `o_skill` 的标准施法管线。它是通过 `o_planar_exchange` 对象的 Alarm_0 事件来结算伤害和效果的，因此 `o_skill_Other_13` 中的快照无法覆盖它。

在 Alarm_0 开头（`scr_onUnitEffectDestroy` 之后、传送逻辑之前）插入快照，确保在伤害结算前记录了所有敌人。

---

## Alarm_0 中的匿名函数问题 ✅ 已解决

`o_planar_exchange_Alarm_0.gml` 中原有两个匿名函数赋值：

```gml
var _teleport_start = function(argument0) { ... };
var _apply_damage = function(argument0) { ... };
```

MSL 反编译/重编译时，匿名函数会生成类似 `gml_Script_anon_gml_Object_o_planar_exchange_Alarm_0_3028` 的随机脚本 ID，导致变量引用在多次编译间不稳定。

### 解决方案（已实施）

已将匿名函数抽成独立命名脚本：

| 脚本文件 | 对应原匿名函数 | 参数 |
|----------|---------------|------|
| `_scr_planar_exchange_teleport_start.gml` | `_teleport_start` | `argument0`（目标实例） |
| `_scr_planar_exchange_apply_damage.gml` | `_apply_damage` | `argument0`（目标）, `owner`, `is_crit` |

> `_apply_damage` 额外传入 `owner` 和 `is_crit`，因为原匿名函数通过闭包捕获了这两个外部变量。

---

## 注意事项

1. `jonna_pre_cast_enemies` 在 `scr_allturn` 检查完毕后**总是会被清空**，无论是否触发免费回合。
2. 快照范围是施法者周围 **30 格**（`point_distance / 26 < 30`）。
3. 仅在 `is_crit && is_player(owner) && instance_is(owner, o_runaway_wizzard)` 条件下拍快照。
4. 如果后续发现其他不走 `o_skill` 管线的技能，需参照维度错换的模式增加补充快照点。
