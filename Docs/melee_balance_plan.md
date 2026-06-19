# QoLEnhanced 近战流派平衡计划

## Summary

本轮实施“单体强度 + 近战抗控”方案。怪物数量、地表 3 倍生成和精英组合数量不调整；只修正敌人单体后期缩放、猛踹清空格挡条、以及近战玩家被控制链压死的问题。

## Key Changes

- 猛踹削弱：实际命中时将格挡削减改为 `-min(target.Block_PowerMax * 0.45, 1.5 * STR + 20)`，保留击退、眩晕、破阵定位，但不允许单次清空高投入盾牌构筑。
- 敌人单体强度调整：只改 `_scr_scale_enemy_csv_by_level.gml`，不改刷怪数量；降低 Vitality 的额外基础值和倍率上限，避免后期敌人同时获得过高生命、命中、伤害和控制容错。
- 近战专属抗控：在 `scr_atr_calc.gml` 玩家分支中增加近战专注判定。玩家装备近战武器，或双手都空手，且已学习法术技能数量小于其他类别技能数量时，获得额外 `Fortitude`。
- 抗控公式：额外 `Fortitude = clamp(STR * 0.20 + AGL * 0.15 + Vitality * 0.45 + PRC * 0.10 + WIL * 0.30, 0, 80)`。Vitality 和 WIL 权重最高，STR/AGL/PRC 提供较小补正。
- 免疫路径：不逐个改 debuff；复用原版 `scr_effect_create` 中 `duration = ceil(duration * (1 - target.Fortitude / 100))`。当持续时间被缩到 0 或低于 1 时，由持续时间递减逻辑自然清除，相当于免疫短控制。

## Implementation Notes

- 新增 `_scr_qol_is_melee_focus.gml` 判断近战专注，避免在 `scr_atr_calc.gml` 里堆大量分类逻辑。
- 法术技能计数：遍历 `o_skill_category`，`class == "spell"` 的已开启技能计入法术；其他非 spell 分类已开启技能计入非术法。
- 近战判定：双手都空手时视作近战；否则要求至少一件已装备武器，且该武器不是射击武器、没有弹药槽。纯远程不触发。
- `Fortitude` 是最终接口，不重写所有 debuff 的创建点，避免扩大到 `scr_effect_create`、各类 `o_db_*`、`scr_temp_*` 和技能命中脚本。
- Alt 详情中猛踹的 `Block_Power` 公式显示施放者侧线性上限；实际命中时还会按目标 `Block_PowerMax * 0.45` 再取小，避免 hover 阶段引用不存在的目标实例。

## Test Plan

- 编译：`dotnet build`，允许既有 `MSB3277` 警告，不允许新增错误。
- 静态检查：确认不引入未知硬编码 ID；`LoadGML MatchFrom` 不带末尾分号。
- 猛踹测试：盾牌近战满格挡被猛踹后应明显损失格挡，但不应直接归零。
- 抗控测试：近战专注角色受到 1-3 回合眩晕/困惑/定身时，持续时间应明显缩短；高属性构筑可免疫短控制。
- 空手测试：双手都空手、且非法术专精时应获得近战抗控收益。
- 三派对照：远程和法师不因装备远程/法术路线获得同等抗控收益；近战抗控来自贴身高风险补偿。

## Assumptions

- 怪物数量不调整。
- 双手都空手明确视作近战。
- 第一版不重写全部负面状态系统，只复用原版 `Fortitude` 持续时间缩短接口。
- 遇到 BaseDataCode 中不明数字 ID 时不自行推断，实施时优先使用对象符号名或向主人确认。
