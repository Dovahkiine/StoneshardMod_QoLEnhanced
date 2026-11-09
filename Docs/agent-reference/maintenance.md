# QoLEnhanced 按需参考

以下内容从原项目入口迁入；代码、命令及普通文本路径仍相对 QoLEnhanced 根。仅查当前任务相关章节，历史数值与文件身份须以当前源码核对。

## 工作流程

### 添加新功能的标准流程

1. **研究原版逻辑** — 在 `../DataCode v9.4.23/`（上级 `ModSources/DataCode v9.4.23/`）中找到目标脚本，理解当前版本实现
2. **确定注入策略** — 根据修改范围选择操作模式（替换值 → `LoadGML` 链式匹配; 新函数 → AddFunction; 全量替换 → SetStringGMLInFile）
3. **转换命名规范** — 将 BaseDataCode 中看到的 `argN` 改写为 `argumentN`（参见上方 MSL 编译规范），用 `var` 捕获替代多层 `other.other` 链
4. **编写脚本** — 在 `Codes/` 中创建 `.gml` 或 `.asm` 文件
5. **注册注入** — 在 `QoLEnhanced.cs` 的 `PatchMod()` 中添加注入代码，放入合适的区块/region
6. **测试** — 通过 MSL 编译并加载到游戏中验证

### 修改现有功能的注意事项

- **不要假设硬编码偏移量不变**：游戏版本更新后，`MatchFrom` 中的匹配字符串可能改变
- **已标注"硬编码"的代码位置**：版本升级时需优先检查（如骨器猎获、属性上限、经验曲线等）
- **匿名函数问题**：MSL 反编译/重编译时匿名函数会生成随机脚本 ID，应抽成独立命名脚本（参照 `SKILL.md` 中的解决方案）
- **匹配字符串必须有唯一性**：如果 `MatchFrom` 匹配到多处，注入行为不可预测

### 原版反编译目录使用方式

- **不要修改** `DataCode v9.4.23/` 或 `BaseDataCode/` 中的任何文件
- 当前版本目录位于 `../DataCode v9.4.23/`，历史基线目录位于 `../BaseDataCode/`，二者都不在 QoLEnhanced 子目录下
- 当需要了解某个原版函数的实现时，优先在当前版本目录中搜索对应的 `.gml` 文件
- 只有做版本差异比对时，才同时读取 `BaseDataCode/`
- 找到关键的代码行后，将其用作 `MatchFrom` 的匹配字符串
- 此目录文件巨大（如 `DialogueData.gml` 1.4MB），不要全量加载

---

## 全局变量清单

| 变量 | 初始化位置 | 用途 |
|------|-----------|------|
| `global.jonna_pre_cast_enemies` | `o_perk_magical_erudition_Create_0` | 约娜天赋：施法前敌人快照，`scr_allturn` 中检测 HP<1 判定击杀 |
| `global.riposte_free_turn` | `o_b_riposte_Create_0` | 招架击杀后的免费回合标志 |
| `global.enemy_balance_by_LVL` | `_scr_scale_enemy_csv_by_level` | 敌人属性缩放缓存的玩家等级 |
| `global.chain_lightning_count` | `scr_allturn` 每回合重置 | 连锁闪电当回合传导计数 |
| `global.weapon_value_type` | `_scr_init_weapon_prefixes` | 武器词缀 value_type 注册表 (ds_map) |

## 武器词缀 value_type 系统

附魔词缀的数值取值方式由 `value_type` 控制（存储在 `global.weapon_value_type` ds_map 中）：

| 值 | 含义 | 取值方式 |
|---|---|---|
| `0` | 整数（默认） | `irandom_range(floor(min), floor(max))` — 真正的 [a,b] 闭区间 |
| `1` | 0.5 步进 | `min + irandom(steps) * 0.5` |
| `2` | 0.2 步进 | `min + irandom(steps) * 0.2` |

诅咒装备（quality == Curse）对齐格点的写法：
```gml
if      (value_type == 1) char_value = round(_raw * 2) / 2
else if (value_type == 2) char_value = round(_raw * 5) / 5
else                      char_value = round(_raw)
```

> 修复了原版 `ceil(random_range(min, max))` 两端取不到的问题。`irandom_range` 是真正的闭区间。

## 电系技能被动触发机制

### 问题根因

`o_skill_electromancy_Other_15`（电系基类 UE5）中 `event_inherited()` 调用 `o_skill_Other_15`，基类末尾执行 `is_crit = false`。子类在 `event_inherited()` 之后调用 `scr_skill_call_passive()` 时，暴击状态已丢失。

### 解决方案

在 `event_inherited()` 之前捕获 `is_crit`，通过 `scr_skill_call_passive` 的 arg3 传入被动：

```gml
var _crit = is_crit
event_inherited()
if (instance_exists(o_player))
{
    scr_skill_call_passive(o_pass_skill_residual_charge, o_player.id, -4, _crit)
}
```

### 残余电荷被动 (o_pass_skill_residual_charge) 事件映射

| 事件 | 职责 |
|------|------|
| Other_13 (UE3) | 激活时：创建 buff `o_b_residual_charge` |
| Other_15 (UE5) | 属性结算：Shock_Resistance 衰减 + 暴击强化 |
| Other_17 (UE7) | 提示文本刷新 |

暴击分支数值：

| | 普通命中 | 法术暴击 |
|---|---|---|
| 每层衰减 | -0.5% | -1.0% |
| 持续时间 | 6 回合 | 8 回合 |

---

## 调试与诊断

- `debug.gml` 是编译后生成的完整代码副本，用于验证最终注入结果
- `ExportTable()` 方法可将游戏数据表导出为 TSV 文件到 `tmp/` 目录
- 被注释掉的代码块（如 L51-92 的搜索工具、L1108-1115 的 1080p 适配）是历史实验或备用方案
- **🔴 `show_message("info")` 断点调试（最高优先级调试策略）**：当有多个分支可能性无法确认时，**首先使用 `show_message()` 判断具体错误点**，而非穷举推理。直接在目标事件脚本中插入 `show_message("到达 X 事件")` 或 `show_message(string(variable))`。可用于：
  - 确认某个事件是否被执行
  - 打印变量值、实例 ID 确认是否正确获取
  - 追踪脚本执行路径
  - **最高效方式**：通过 UMT (UndertaleModTool) 直接在已编译的 data.win 中插入 `show_message()` 语句，无需重新构建 MSL 项目。只需在对话中告诉用户在哪行插入什么内容即可
- **`with(owner)` 作用域陷阱**：进入 `with (owner)` 后，当前作用域已经切换到 owner 实例本身。此时不要再写 `owner.Magic_Power`、`owner.Electromantic_Power` 之类访问，因为这里的 `owner` 会解析为“owner 实例自己的 owner 变量”，可能是 `-4`，最终触发 `Unable to find instance for object index -4`。正确写法是在 `with (owner)` 内直接使用裸变量（如 `Magic_Power`、`Electromantic_Power`、`Miracle_Power`、`WIL`），或在进入 `with` 前用 `var _owner = owner` 捕获外层实例。若第一条 `show_message()` 之前直接报错，应优先检查其前面的初始化表达式和 `with` 作用域变量解析，而不是只盯后续分支。

## 版本升级风险点

游戏版本更新时，以下部分最容易出问题：

1. **`table_skills`/`table_skills_stats` 的 ASM 匹配** — 技能描述文本可能改变
2. **`o_player_Step_0` 的字节码范围替换** — 经验曲线硬编码
3. **`o_NPC_Create_0` 的价格表偏移** — `MatchBelow("Buying_Tier", 61)` 的 61 行偏移可能改变
4. **骨器猎获的 ASM 偏移标记** — 如 `:[92]`, `:[93]`, `:[114]`
5. **`scr_cook_check_raw_ingredients`** — 使用硬编码偏移量

<!-- QOL_SIGNATURE: 主人优先，规则至上 -->
