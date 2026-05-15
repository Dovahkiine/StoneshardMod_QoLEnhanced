# CLAUDE.md — QoLEnhanced 模组项目总览

## 项目身份

- **模组名称**: QoLEnhanced (品质优化)
- **目标游戏**: StoneShard (目标版本 `0.9.4.14`)
- **模组框架**: [ModShardLauncher](https://github.com/ModShardLauncher/ModShardLauncher) (MSL) — 基于 `UndertaleModLib` 的 GameMaker 游戏模组注入框架
- **技术栈**: C# (.NET 6.0-windows, WPF) + GML (GameMaker Language) + ASM (Undertale 字节码)
- **作者**: Dovahkiin
- **版本**: `1.0.0.0`

## 🔨 构建与测试

- **编译 C# 项目**: `dotnet build`（.NET 6.0-windows, WPF）
- **MSL 编译流程**: ModShardLauncher.exe 启动 → 选择 QoLEnhanced → 执行 `PatchMod()` → 将全部注入应用到 data.win → 输出到 `Mods/` 目录
- **测试**: ModShardLauncher.exe 勾选 QoLEnhanced → 启动游戏 → 加载存档验证功能

## 🔴 核心协作规则（最高优先级）

### 自约束定式

以下规则用于防止过度思考导致上下文膨胀和注意力分散：

0. **🔴 中文思考输出（最高优先级，强制执行）**：所有思考、推理、分析过程**必须使用中文**——包括 thinking/thought 内部推理块、分析总结、方案对比。代码和必要技术术语保留英文。代码注释使用中文。**目的**：让用户能实时监控推理链路，发现幻觉或过度深入时能及时打断纠正。
1. **已知/未知分离**：每次分析先列出「已确认的事实」和「尚不确定的点」。不模拟超过 2 层的"可能情况"。
2. **不静默换方案**：用户已决定的方案（如"用方案 A"），必须严格执行。如果发现阻塞，**先报告再等指令**，不自作主张切到方案 B。
3. **最多 2 个选项**：需要用户选择时，只提供最可行的 2 个选项。不展开 4-5 个分支讨论。
4. **一次一问**：不连续追问多个开放性问题。每次交互聚焦一个关键决策点。
5. **深度限制**：分析定位根因时最多阅读 5 个参考文件。超过 5 个仍未定位 → 先提问。

### 称呼规则

**每次对话的第一条回复必须以「主人」开头**，不得省略。此规则用于验证 AI 是否在回复前已阅读本 CLAUDE.md 文档。

以下场景均视为「新对话的起点」，必须重新以「主人」开头：
- 会话重置后（`/clear`）
- 上下文压缩后（PreCompact/自动压缩）
- 新对话/新会话开始
- 长时间无交互后恢复对话

> 如果回复不以「主人」开头，说明 AI 未阅读 CLAUDE.md，用户应立即终止对话并重新开始。

### 提问规则

遇到以下情况时，**必须先向用户提问确认**，不得自行假设或推断后直接编码：

- 调用不熟悉的 MSL API 或不确定其参数签名时（如 `AddObject` 的参数顺序和含义）
- 需要了解某个原版游戏函数的完整实现逻辑，但尚未阅读 `../BaseDataCode/`（上级 `ModSources/BaseDataCode/`）中对应文件时
- 涉及 GML 作用域、变量生命周期、MSL 编译行为等底层机制且有歧义时
- 需要在多种可行方案中选择，而选择会显著影响后续架构时
- 在 BaseDataCode 或匹配字符串中遇到不明含义的硬编码数字（如 `4719`、`83`）时——**UMT 反编译会将精灵/对象引用替换为数字 ID**，不要自行猜测其含义，直接向用户提问
- 需要将硬编码数字作为 `MatchFrom` 匹配字符串时——**先提醒用户**，因为硬编码 ID 可能在游戏版本更新时变化导致匹配失效。优先尝试使用不含数字的唯一片段（如 `"item_check = "` 替代 `"item_check = 4719"`）

提问时应说明：已确认的事实、尚存疑的点、以及当前倾向的推断。直到可以清晰描述主要流程后，再开始编码。

### MSL API 参考与开发文档

**不熟悉 MSL API 用法时，优先去 `D:\Downloads\StoneShard_Lib\ModShardLauncher-Enhanced\Guides\` 目录阅读 HTML 开发文档。** 该目录包含以下指南：

| 指南文件 | 内容 |
|---------|------|
| **MSL_Modding_Survival_Guide.html** | 🔴 最重要：MSL 安全/不安全 API、GML 预处理系统、变量命名规范、崩溃原因、测试策略、Proven Patterns |
| **MSLE_New_Texture_Loader_Guide.html** | 精灵贴图系统：`NewTextureLoader.LoadTextures(ModFiles)` 批量导入、替换原版精灵、创建新精灵。PNG 放入 `Textures/` 目录 |
| **MSLE_Audio_Integration_Guide.html** | 音频系统：`AudioLoader.LoadAudio(ModFiles)` 自动导入 `Sounds/` 目录下 .ogg/.wav |
| **MSLE_FontLoader_Guide.html** | 字体系统：`FontLoader.LoadFonts(ModFiles)` 提取 .ttf/.otf 到 AppData |
| **MSLE_Shader_Guide.html** | 着色器系统：`shaders/` 目录结构、GLSL 模板、uniform 设置 |
| **MSLE_v1.08+_Features_Guide.html** | `[ModDependency]` 声明模组依赖 |

**关键 MSL API 速查：**

```
// 精灵导入 (推荐: NewTextureLoader, 替代逐条 Msl.GetSprite)
NewTextureLoader.LoadTextures(ModFiles);  // 批量处理 Textures/ 下所有 PNG

// Msl.GetSprite 是查找/注册函数，逐个调用仅注册单个精灵
Msl.GetSprite("s_my_sprite");  // 确保精灵被导入 (旧方式)

// 资产加载顺序: Textures → Audio → Fonts
NewTextureLoader.LoadTextures(ModFiles);
AudioLoader.LoadAudio(ModFiles);
FontLoader.LoadFonts(ModFiles);

// ⚠️ AddFunction 必须在所有被引用对象/资产创建之前调用
// ⚠️ 一个 GML 文件只能包含一个函数 (MSL 解析器限制)
// ⚠️ 避免 Msl.AddCode() — 不可靠
```

## 目录结构

```
ModSources
├── QoLEnhanced/
│   ├── QoLEnhanced.cs          # 🔴 主入口 — 所有功能的注入调度代码 (~1510行)
│   ├── QoLEnhanced.csproj       # 项目配置
│   ├── QoLEnhanced.slnx         # 解决方案
│   ├── SKILL.md                 # 单功能深度文档（约娜天赋），其他功能可参照此格式
│   ├── CLAUDE.md                # 本文件 — 项目总览与架构文档
│   ├── Codes/                   # 🟡 注入的 GML/ASM 脚本 (66 个文件)
│   │   ├── gml_GlobalScript_*.gml     # 全量替换型脚本（替换原版函数）
│   │   ├── _scr_*.gml                 # 新增辅助函数（通过 AddFunction 注册）
│   │   ├── gml_Object_o_*_insert.gml  # 增量注入脚本（InsertBelow）
│   │   ├── gml_Object_o_*_instead.gml # 局部替换脚本（ReplaceBy）
│   │   ├── *.asm                      # ASM 字节码片段（ReplaceBy 到汇编上下文）
│   │   └── debug.gml                  # 编译后完整代码副本（调试用）
│   ├── Sprites/                 # 🖼️ UI 贴图 (540p / 720p 两种规格)
│   ├── lib/                     # 依赖 DLL (ModShardLauncher.dll, UndertaleModLib.dll)
│   └── tmp/                     # 临时导出文件
└── BaseDataCode/         # 📚 原始游戏反编译脚本（位于 `ModSources\BaseDataCode\`，用于 MSL 匹配定位）
```

## 架构核心：MSL 注入机制

本模组的根本工作方式是**在游戏程序集（Undertale data.win）上做字符串匹配 + 代码替换**。不是运行时 hook，而是**构建时注入**。

### 文件类型与用途

| 目录 | 性质 | 用途 |
|------|------|------|
| `Codes/` | ✏️ 手写/修改的脚本 | 会被注入到游戏中，是实际生效的代码 |
| `BaseDataCode/` | 📖 只读参考 | 原始游戏反编译文件，位于 `../BaseDataCode/`，用于了解原版逻辑和定位匹配字符串 |

### 事件编号速查

GML 事件名 ↔ `event_user(N)` ↔ C# `MslEvent` 构造函数参数的映射：

| GML 文件名后缀 | GML 调用 | C# EventType | C# subtype |
|---------------|----------|-------------|-----------|
| `_Create_0` | — | `EventType.Create` | `0` |
| `_PreCreate_0` | — | `EventType.PreCreate` | `0` |
| `_Step_0` | — | `EventType.Step` | `0` |
| `_Draw_0` | — | `EventType.Draw` | `0` |
| `_Destroy_0` | — | `EventType.Destroy` | `0` |
| `_Alarm_0` | — | `EventType.Alarm` | `0` |
| `_Alarm_6` | — | `EventType.Alarm` | `6` |
| `_Other_10` | `event_user(10)` | `EventType.Other` | `10` |
| `_Other_11` | `event_user(11)` | `EventType.Other` | `11` |
| `_Other_12` | `event_user(12)` | `EventType.Other` | `12` |

> `Msl.AddNewEvent` 可直接用 `EventType.Other`、`EventType.Alarm` 等名称，无需强制转型。

### ⚠️ 文本中的波浪键转义

游戏用 `~` 作为文本标记分隔符（如 `~ly~`、`~w~`、`~/~`），`scr_colorTextStringRemovePattern` 无条件成对删除 `~...~` 之间的内容。`~~` 被当作空标签吞掉。

- **要显示波浪键**：使用 Unicode 替代符 `～`（U+FF5E，全角）或 `∼`（U+223C）
- **不要**在两个颜色标签之间写 `~~` 留空——中间必须有内容或被解析为 `~/~` 关闭标签

### ⚠️ MSL 编译规范：变量命名与作用域限制

BaseDataCode 中的文件是通过 **UMT (UndertaleModTool)** 反编译得来的。UMT 使用缩略形参名（`arg0`, `arg1`），但 **MSL 编译器只识别完整形参名**。在 C# 注入字符串和 `Codes/` 的 `.gml` 文件中写入代码时，必须遵循以下规则：

#### 规则 1: 函数参数必须用完整形式

```
❌ 错误 (UMT 风格):  scr_defence_mod(arg0, arg1, arg2)
✅ 正确 (MSL 规范):  scr_defence_mod(argument0, argument1, argument2)

❌ 错误:  arg0.__qol_riposte_raw = arg1;
✅ 正确:  argument0.__qol_riposte_raw = argument1;
```

> **记忆口诀**：BaseDataCode 中看到 `argN` → 在注入代码中写成 `argumentN`

#### 规则 2: 避免跨多层作用域的 other 链

`with()` 语句中的 `other` 指向调用方作用域，但嵌套多层 `with()` 时：

```
❌ 可能出问题:  other.other._var
```

当需要从深层 `with()` 中访问外部变量时，**在进入 `with()` 之前用 `var` 捕获**：

```gml
var _val = outer_var;
with (some_instance)
{
    // 使用 _val 而非 other.other.outer_var
}
```

#### 🔴 规则 3: `LoadGML` 匹配时去掉行末分号（反复遗忘！必须检查）

UMT 反编译的 GML 源码在通过 `Msl.LoadGML` 加载时，**行末分号会被略去**。因此 `MatchFrom` 的匹配字符串不应包含末尾分号：

```
❌ 错误:  .MatchFrom("_isFumbleDodge = false;")
✅ 正确:  .MatchFrom("_isFumbleDodge = false")
```

> 查看 `QoLEnhanced.cs` 中已有的 `MatchFrom` 调用可确认此规则（如 `"return scr_chance_value(5)"`, `"range = 2"` 等均无分号）

#### 规则 4: BaseDataCode 只读参考，不要照搬

从 BaseDataCode 复制代码行作为 `MatchFrom` 的匹配字符串时，需要将 `argN` 手动改写为 `argumentN`。但如果你是在做 **汇编级操作** (`LoadAssemblyAsString`)，则保持反汇编文本原样（因为它们操作的是字节码级别的符号）。

#### 规则 5: 函数首行/尾行注入优先用 `MatchAll` + `InsertAbove`/`InsertBelow`

在函数体开头或末尾注入代码时，`MatchAll` 比匹配特定字符串更稳健（不依赖具体行内容）：

```
✅ 推荐 (函数首行注入):  Msl.LoadGML("...").MatchAll().InsertAbove("新代码").Save();
✅ 推荐 (函数尾行注入):  Msl.LoadGML("...").MatchAll().InsertBelow("新代码").Save();
```

> `MatchAll` 匹配整个脚本的全部内容，`InsertAbove` 在所有内容之前插入，`InsertBelow` 在所有内容之后插入。

### 操作模式

MSL 通过 C# 链式 API 操作 GML/ASM 代码：

```
Msl.LoadGML("目标脚本名")     // 加载为 GML 源码上下文
   .MatchFrom("匹配字符串")    // 定位到某行（行间关键词匹配）
   .ReplaceBy("替换内容")      // 🔴 替换整行！不是替换匹配片段！
   .InsertBelow("插入内容")    // 在该行下方插入
   .Save();                   // 提交修改

⚠️ ReplaceBy 陷阱：MatchFrom 只匹配行间关键词片段，但 ReplaceBy 的参数会替换掉被匹配的**整个原始行**。
   如果原行是 `if (id != owner && distance == 1)`，ReplaceBy("distance <= 2") 会产出 `distance <= 2`——丢失 `if` 条件！
   正确做法：ReplaceBy("if (id != owner && distance <= 2)")——给完整的替换行。
```

#### 模式 1: 字符串精确替换

最精确、最安全的方式。匹配原始 GML 源码中的字符串并替换。

```csharp
MslExtensions.QuickMatch("gml_GlobalScript_scr_trap_find", "find_chance = 0.5", "find_chance = scr_atr(\"PRC\") / R");
```

对应底层调用: `Msl.LoadGML(...).MatchFrom(old).ReplaceBy(new).Save()`

#### 模式 2: 汇编级替换 (LoadAssemblyAsString)

当需要精确到字节码级别操作时使用。操作对象是反编译后的汇编文本（`push.s`, `pop.v.v`, `call.i` 等指令）。

```csharp
Msl.LoadAssemblyAsString("gml_GlobalScript_table_attributes")
    .MatchFrom("push.s \"AGL;~sy~")
    .ReplaceBy(ModFiles.GetCode("gml_GlobalScript_table_attributes_rebalance_agility.asm"))
    .Save();
```

#### 模式 3: 局部代码块替换

用 `MatchFromUntil` 圈定范围，整体替换为一个文件内容。

```csharp
MslExtensions.QuickMatchBelowFiles("gml_Object_o_skill_enchantment_Other_11", "if (image_alpha", 2,
    ModFiles, "gml_Object_o_skill_enchantment_Other_11_instead.gml");
```

#### 模式 4: 函数注册 (AddFunction)

将新的 GML 脚本注册为全局可调用函数：

```csharp
Msl.AddFunction(ModFiles.GetCode("_scr_do_shoot.gml"), "gml_GlobalScript__scr_do_shoot");
```

文件命名约定: `_scr_*.gml` → 注册为 `gml_GlobalScript__scr_*.gml`

#### 模式 5: 全量替换 (SetStringGMLInFile)

整个脚本完全替换为新版本：

```csharp
Msl.SetStringGMLInFile(ModFiles.GetCode("gml_GlobalScript_scr_weapon_generation.gml"),
    "gml_GlobalScript_scr_weapon_generation");
```

#### 模式 6: 对象/事件注入

为游戏对象添加新事件或修改已有事件：

```csharp
// 在已有事件中插入代码
Msl.LoadGML("gml_Object_o_player_Create_0").MatchAll().InsertBelow("...").Save();
// 为对象添加全新事件
Msl.AddNewEvent("o_b_riposte", ModFiles.GetCode("...gml"), EventType.Alarm, 0);
```

#### 模式 6b: 批量事件注册 (GameObjectUtils.ApplyEvent)

`AddObject` 返回的对象可通过 `GameObjectUtils.ApplyEvent` 一次性注册多个事件：

```csharp
GameObjectUtils.ApplyEvent(
    Msl.AddObject("o_my_obj", "s_sprite", "", true, false, true, (CollisionShapeFlags)0),
    base.ModFiles,
    new MslEvent[3]
    {
        new MslEvent("gml_Object_o_my_obj_Create_0.gml", EventType.Create, 0),
        new MslEvent("gml_Object_o_my_obj_Other_11.gml", EventType.Other, 11),
        new MslEvent("gml_Object_o_my_obj_Destroy_0.gml", EventType.Destroy, 0)
    }
);
```

> `MslEvent` 的构造函数: `(string fileName, EventType type, int subtype)`

#### 模式 7: 原始行级操作 (QuickInject/QuickReplace/QuickReplaceRange)

通过 `MslExtensions` 工具类操作反汇编后的原始文本行：

```csharp
MslExtensions.QuickInject("gml_Object_o_player_Step_0", ":[end]", someCode);
MslExtensions.QuickReplace("gml_GlobalScript_table_text", "call.i @@NewGMLArray@@", newLine);
MslExtensions.QuickReplaceRange("gml_Object_o_player_Step_0", "pop.v.v self.max_xp", 5, newCode);
```

#### 模式 8: UI/菜单注入

```csharp
Msl.AddMenu("自动寻路", new UIComponent[2] { ... });
// AddObject 签名: (name, sprite, parent, visible, solid, isAwake, collisionShape)
Msl.AddObject("o_globalmapTP", "s_gui_button_skipturn", "o_button", true, false, true, (CollisionShapeFlags)0);
```

### 操作模式选择指南

| 场景 | 推荐方式 |
|------|---------|
| 修改单个值/常量 | `QuickMatch` (模式1) |
| 修改 table_* 中的技能描述 | `LoadAssemblyAsString` + `MatchFrom/ReplaceBy` + `.asm` 文件 (模式2) |
| 替换整个函数实现 | `SetStringGMLInFile` (模式5) |
| 新增可复用函数 | `AddFunction` (模式4) |
| 在现有逻辑中插入新代码 | `LoadGML` + `InsertBelow` (模式6) |
| 操作反汇编文本行 | `QuickInject` / `QuickReplace` / `QuickReplaceRange` (模式7) |

## MslExtensions 工具类 (QoLEnhanced.cs:1237-1364)

项目内部封装了一套 MSL 操作便利方法，分为四个区块：

### A: 基础替换
- `QuickMatch(gmlName, original, replacement)` — 精确匹配 + 替换
- `QuickMatchBelow(gmlName, original, linesAfter, replacement)` — 匹配后偏移 N 行替换
- `QuickMatchFromUntil(gmlName, from, until, replacement)` — 范围替换

### B: 文件导入替换
- `QuickMatchFiles` — 匹配替换为外部文件
- `QuickMatchAll` — 全量替换为外部文件
- `QuickMatchFromUntilFiles` — 范围替换为外部文件

### C: 插入操作
- `QuickInsertBelow` — 文本插入
- `QuickInsertBelowFiles` — 文件内容插入

### D: 高级操作
- `QuickMatchBelowFiles` — 偏移+文件替换
- `QuickAssemblyMatchBelowFiles` — 汇编级偏移+文件替换
- `QuickInject` / `QuickReplace` / `QuickReplaceRange` — 行级注入/替换

## GmlInjectionExtensions (QoLEnhanced.cs:1368-1472)

针对 `IEnumerable<string>` (反汇编文本行流) 的扩展方法：
- `InjectIf` — 匹配行前插入
- `ReplaceIf` — 匹配行替换
- `ReplaceRangeIf` — 匹配行 + 删除后续 N 行 + 插入新代码

所有方法在未匹配时弹出 WPF 提示框，用于调试定位。

---

## 功能区块全览 (12 区块, ~50+ 项修改)

### 区块 1: 全局配置与游戏机制 (L99-205)

| 功能 | 注入方式 | 涉及文件 |
|------|---------|---------|
| 密室 100% 出现 | QuickMatch | `scr_dungeonHasSecretRoom` |
| 地牢光照颜色调整 | LoadGML + MatchFrom/ReplaceBy 链 | `scr_dungeonSetSettings` |
| 陷阱发现基于 PRC 属性 | QuickMatch x3 | `scr_trap_find` |
| 刷怪 3 倍 | LoadGML + InsertBelow | `o_mob_point_Other_11`, `scr_surfaceSpawnsDoc` |
| 地面刷新列表强化 | SetStringGMLInFile | `table_surface_spawn.gml` |
| 敌人属性按玩家等级缩放 | AddFunction + QuickInsertBelow | `_scr_scale_enemy_csv_by_level.gml` |
| 经验值缩放调整 | LoadAssemblyAsString + MatchBelow/ReplaceBy | `o_enemy_Destroy_0_insert.asm` |
| 初始 AP 0→5 | QuickMatch | `scr_characterMapInit` |
| 初始 SP 2→5 | QuickMatch | `scr_characterMapInit` |
| 等级上限 UI 30→100 | QuickMatch | `o_character_panel_mask_Draw_0` |
| 敏捷额外减伤 2%/点 | LoadAssemblyAsString + ReplaceBy | `table_attributes_rebalance_agility.asm` |
| 宝箱奖励翻倍 | QuickMatchBelow | `c_container_Other_13` |

### 区块 2: 物品与附魔系统 (L208-267)

| 功能 | 注入方式 | 涉及文件 |
|------|---------|---------|
| 物品稀有度文本本地化 | QuickInject | `table_text_prefix.asm` |
| 附魔品质文本本地化 | QuickInject | `table_text_rarity.asm` |
| 文本数组扩容 | QuickReplace | `table_text` |
| 附魔生成逻辑优化 | QuickMatchBelowFiles | `o_skill_enchantment_Other_11_instead.gml` |
| 附魔核心脚本注入 | AddFunction + SetStringGMLInFile x3 | `_scr_init_weapon_prefixes.gml`, `scr_weapon_generation.gml`, `scr_weapon_prefix_generation.gml`, `scr_weapon_generation_prefix_search.gml` |
| 附魔条件限制 | QuickMatch | `o_skill_enchantment_Other_20` |
| 史诗品质背景色 | QuickInsertBelow | `scr_qualityBgDraw` |

### 区块 3: 时间系统与快捷键 (L270-473)

| 功能 | 注入方式 | 涉及文件 |
|------|---------|---------|
| 日志时间戳 | LoadGML + MatchFrom/InsertAbove | `scr_actionsLog` |
| 自动寻路系统 | AddFunction x7 + AddMenu + LoadGML 注入 | `_scr_*` 7个文件, `o_globalmapMarkUserContext_Other_25`, `o_player_Create_0`, `o_player_Other_17`, `scr_stop_player` |
| 等级/AP/SP 修改 | LoadAssemblyAsString + QuickReplaceRange + QuickInject | `o_player_Step_0_levelup.asm`, `o_player_Step_0_instead.asm`, `o_player_Step_0_insert.asm` |
| 本地化文本注入 | Localization.ActionLogsPatching() | `table_log` |
| F2 前往标记点 | SetStringGMLInFile | `o_player_KeyPress_113.gml` |
| F3 打开马车仓库 | SetStringGMLInFile | `o_player_KeyPress_114.gml` |
| F5 快速存档 | SetStringGMLInFile | `o_player_KeyPress_116.gml` |
| F9 去除迷雾 | SetStringGMLInFile | `o_player_KeyPress_120.gml` |
| 人类祈祷永久持续+阶段增益 | InsertGMLString + SetStringGMLInFile | `o_b_bless_Create_0`, `o_b_bless_Alarm_2`, `o_b_bless_Other_10` |
| 星盘夜视 | QuickMatchBelow | `o_inv_nikos_astrolabe_Other_24` |
| 马车调度 1.5 天 | QuickMatch | `scr_caravanSettingsGetDispatchTime` |
| 精神焕发翻倍 | QuickMatchBelow | `o_sleepController_Other_10` |
| 时刻机警强化 | QuickMatch + ReplaceBy | `table_skills_rebalance_lightning_reflexes.asm` |

### 区块 4: 角色机制与开局优化 (L476-580)

| 功能 | 注入方式 | 涉及文件 |
|------|---------|---------|
| 野性狩猎全局生效 | InsertGMLString | `o_perks_Create_0.gml` (perk 基类注册) |
| 野性狩猎效果强化 | QuickMatch x5 (循环) | 5个状态检查脚本 |
| 移除野性狩猎硬性判定 | QuickMatch | `o_pass_skill_resourcefulness_Alarm_4` |
| 全角色开局希尔达饰品 | QuickInsertBelow x7 (循环) | 7个角色 Create 事件 |
| 骨器猎获数值强化 | SetStringGMLInFile + LoadAssemblyAsString | `scr_consum_hilda_enchant_assign.gml`, `scr_cook_check_raw_ingredients` |
| 开局获得 DLC 物品 | QuickMatch | `o_player_chest_Alarm_1` |
| 阿娜天赋加成提升 | LoadAssemblyAsString + MatchFromUntil/ReplaceBy | `o_perk_vow_feat_Create_0`, `table_skills_rebalance_vow_feat.asm` |
| 约娜天赋暴击免费回合 | QuickInsertBelow + SetStringGMLInFile | `scr_crit_death`, `scr_allturn.gml`, `table_skills_rebalance_magical_erudition.asm` |

### 区块 5: 技能与战斗平衡 (L584-831)

| 子区块 | 涉及技能 | 关键文件 |
|--------|---------|---------|
| 5.1 主动技能 | 掌握主动、准备就绪、招架 | `o_skill_seize_the_initiative_*`, `o_pass_skill_preparation_*`, `o_b_riposte_*` |
| 5.2 范围控制 | 战吼 | `table_skills_stats`, `o_war_cry_birth_Other_10`, `o_war_cry_impact_Other_11` |
| 5.3 被动技能 | 正中目标、自我修复、远近兼攻、冲刺训练 | `o_pass_skill_right_on_target_Other_17.gml`, `table_skills_rebalance_self_repair.asm`, `table_skills_rebalance_thrift.asm`, `table_skills_rebalance_sprint_training.asm` |
| 5.4 斩杀终结 | 最后一击、搏命 | `table_skills_stats`, `o_skill_finisher_*`, `o_pass_skill_last_effort_Other_17.gml` |
| 5.5 支援技能 | 叫喊 | `o_shout_Other_12` |
| 5.6 属性防御 | 免疫上限 125→1000 | `scr_immunity_change` |
| 5.7 武器装备 | 远程双持重做、双手武器单持、双持惩罚移除、暴击范围、格挡损耗 | `_scr_do_shoot.gml`, `_scr_extract_crossbow_bolt.gml`, `_scr_fire_bow_once.gml`, `_scr_get_weapon_hand_types.gml`, `scr_is_ammo_exist.gml`, `scr_throw.gml`, `scr_crossbow_insert_bolt.gml`, `scr_crossbow_reject_bolt.gml`, `scr_inv_weapon_get_hands.gml`, `table_skills_rebalance_taking_aim.asm` |
| 5.8 修补收集 | 剥皮强化 100% | `o_flaying_Other_10` |
| 5.9 Alt 键详情 | 按 Alt 显示详细技能信息 | `o_hoverSkill_Other_20.gml`, `o_hoverRender_Step_2.gml` |

### 区块 6: 魔法系统平衡 (L834-864)

| 功能 | 注入方式 | 涉及文件 |
|------|---------|---------|
| 移除派系魔法互斥惩罚 | LoadGML + MatchAll/ReplaceBy x4 (循环) | 4个魔法派系的 `Other_15` 事件 |

### 区块 7: 消耗品与工具强化 (L868-980)

| 功能 | 变更 | 注入方式 |
|------|------|---------|
| 撬棍 | 耐久 50→100, 损耗 40→20 | LoadGML + MatchFrom/ReplaceBy |
| 维修工具 | 次数 5→15 | QuickMatch |
| 药膏 | 次数 3→8 | QuickMatch |
| 绷带 | 次数 2→8 | QuickMatch |
| 夹板 | 次数 1→3, 添加 max_charge | QuickMatch |
| 灵药 | 次数 1→8 | QuickMatch |
| 水囊 | 次数 6→20 | QuickMatch |
| 涤魂圣杯 | 次数 1→20 | QuickMatch |
| 卷轴系统 | 辨识/附魔/褪魔卷轴 8 次+次数显示 | QuickMatch |
| 加盐保鲜 | Fresh 值 x1000 | QuickMatch x2 |
| 大篷车保鲜 | 腐败速度 x0.001 | QuickMatch |
| 食物新鲜度显示 | 24h 内切换为小时显示 | QuickMatchFromUntil |

### 区块 8: 经济系统优化 (L984-1054)

| 功能 | 注入方式 | 涉及文件 |
|------|---------|---------|
| 统一商人定价 | LoadGML + MatchBelow/ReplaceBy | `o_NPC_Create_0_Price.gml` |
| 商人基础金币 +1500 | QuickMatch | `scr_npc_gold_init` |
| 大篷车随从强化 | QuickMatchAll | `o_npc_darrel_caravan_Create_0.gml` |
| 马车夫强化 | QuickMatchAll | `o_npc_tott_Create_0.gml` |
| 传送系统 | AddMenu + AddObject + LoadGML 注入 | `o_globalmapTP_Create_0.gml`, `o_globalmapTP_Other_10.gml`, `o_globalmap_Other_10`, `o_globalmapMarkUserContext_Other_25` |

### 区块 9: 背包与仓库 UI (L1058-1117)

| 功能 | 注入方式 | 涉及文件 |
|------|---------|---------|
| 交易界面扩容 | QuickMatch x7 (循环) | `o_trade_inventory_Create_0` |
| 仓库界面扩容 | QuickMatch x7 (循环) | `o_stash_inventory_Create_0` |
| 背包扩容 (11x12) | QuickMatchFromUntil | `o_inventory_Create_0` |
| UI 贴图替换 (720p) | Msl.GetObject().Sprite = | 4个 inventory 对象 |
| 1080p 适配 (已注释) | — | — |

### 区块 10: 堆叠系统优化 (L1120-1165)

| 功能 | 变更 | 注入方式 |
|------|------|---------|
| 金币堆叠 | 100→1000 | QuickMatch + LoadGML/MatchBelow/ReplaceBy |
| 钱袋堆叠 | 2000→20000 | QuickMatch |
| 古钱币堆叠 | 50→1000 | QuickMatch |
| 弹药堆叠 | 20→100 + 贴图重算 | LoadGML + MatchFrom/ReplaceBy x3 |
| 投石索弹药 | 10→100 | QuickMatch |
| 堆叠逻辑核心 | 合并/拆分/找空位 | QuickMatchAll x3 |

### 区块 11: 属性上限与战斗公式 (L1168-1192)

| 功能 | 注入方式 | 涉及文件 |
|------|---------|---------|
| 属性计算上限提升 | QuickMatchAll x2 | `scr_atr_calc.gml`, `scr_atr_calc_combat.gml` |
| 技能冷却上限解除 | QuickMatchFromUntil | `o_skill_Other_17` |
| 属性提升 UI 上限至 100 | QuickMatch x2 | `o_attribute_button_Step_2`, `o_character_attribute_Step_2` |

### 区块 12: 其他优化 (L1195-1210)

- 12.1: 职业被动强化 (TODO — 阿娜被动增益计划中)
- 12.2: 待实装功能 (预留)

---

## 关键文件索引

### 大型脚本 (>500 行)

| 文件 | 行数 (估计) | 用途 |
|------|-----------|------|
| [scr_atr_calc.gml](Codes/gml_GlobalScript_scr_atr_calc.gml) | ~1000+ | 全局属性计算核心（clamp 上限修改） |
| [scr_atr_calc_combat.gml](Codes/gml_GlobalScript_scr_atr_calc_combat.gml) | ~500+ | 战斗属性计算 |
| [scr_weapon_generation.gml](Codes/gml_GlobalScript_scr_weapon_generation.gml) | ~300+ | 武器生成逻辑 |
| [scr_weapon_prefix_generation.gml](Codes/gml_GlobalScript_scr_weapon_prefix_generation.gml) | ~200+ | 武器前缀生成 |
| [scr_throw.gml](Codes/gml_GlobalScript_scr_throw.gml) | ~200+ | 远程攻击核心（双持远程重做） |
| [scr_crossbow_insert_bolt.gml](Codes/gml_GlobalScript_scr_crossbow_insert_bolt.gml) | ~200+ | 弩箭装填逻辑 |
| [scr_consum_hilda_enchant_assign.gml](Codes/gml_GlobalScript_scr_consum_hilda_enchant_assign.gml) | ~80 | 希尔达饰品附魔分配 |

### 辅助脚本 (来自 `Codes/`)

| 文件 | 注册名 | 用途 |
|------|--------|------|
| `_scr_do_shoot.gml` | `gml_GlobalScript__scr_do_shoot` | 远程攻击 projectile 创建封装 |
| `_scr_get_weapon_hand_types.gml` | `gml_GlobalScript__scr_get_weapon_hand_types` | 获取双手武器类型 |
| `_scr_extract_crossbow_bolt.gml` | `gml_GlobalScript__scr_extract_crossbow_bolt` | 提取弩箭 |
| `_scr_fire_bow_once.gml` | `gml_GlobalScript__scr_fire_bow_once` | 单次弓箭射击 |
| `_scr_init_weapon_prefixes.gml` | `gml_GlobalScript__scr_init_weapon_prefixes` | 武器前缀初始化 |
| `_scr_move_player_to.gml` | `gml_Script__scr_move_player_to` | 自动寻路：移动玩家 |
| `_scr_calculate_closest_point.gml` | `gml_Script__scr_calculate_closest_point` | 自动寻路：计算最近点 |
| `_scr_find_nearest_tile_transition.gml` | `gml_Script__scr_find_nearest_tile_transition` | 自动寻路：找最近的 tile 过渡 |
| `_scr_find_exit_door.gml` | `gml_Script__scr_find_exit_door` | 自动寻路：找出口 |
| `_scr_auto_move_to_transition.gml` | `gml_Script__scr_auto_move_to_transition` | 自动寻路：移动到过渡点 |
| `_scr_redeactivate_instances.gml` | `gml_Script__scr_redeactivate_instances` | 自动寻路：重新停用实例 |
| `_scr_stop_auto_move.gml` | `gml_Script__scr_stop_auto_move` | 自动寻路：停止自动移动 |
| `_scr_scale_enemy_csv_by_level.gml` | `gml_GlobalScript__scr_scale_enemy_csv_by_level` | 按等级缩放敌人属性 |

### ASM 片段

| 文件 | 注入目标 | 用途 |
|------|---------|------|
| `table_attributes_rebalance_agility.asm` | `table_attributes` | 敏捷额外减伤 2%/点 |
| `table_skills_rebalance_*.asm` (7个) | `table_skills` | 7个技能的描述文本修正 |
| `table_text_prefix.asm` | `table_text` | 附魔词缀本地化 |
| `table_text_rarity.asm` | `table_text` | 稀有度文本本地化 |
| `o_player_Step_0_levelup.asm` | `o_player_Step_0` | 升级 AP/SP 奖励修改 |
| `o_player_Step_0_instead.asm` | `o_player_Step_0` | 等级上限经验曲线替换 |
| `o_player_Step_0_insert.asm` | `o_player_Step_0` | 标记地点全局判断 |
| `o_enemy_Destroy_0_insert.asm` | `o_enemy_Destroy_0` | 经验值缩放修正 |

---

## 工作流程

### 添加新功能的标准流程

1. **研究原版逻辑** — 在 `../BaseDataCode/`（上级 `ModSources/BaseDataCode/`）中找到目标脚本，理解原始实现
2. **确定注入策略** — 根据修改范围选择操作模式（替换值 → QuickMatch; 新函数 → AddFunction; 全量替换 → SetStringGMLInFile）
3. **转换命名规范** — 将 BaseDataCode 中看到的 `argN` 改写为 `argumentN`（参见上方 MSL 编译规范），用 `var` 捕获替代多层 `other.other` 链
4. **编写脚本** — 在 `Codes/` 中创建 `.gml` 或 `.asm` 文件
5. **注册注入** — 在 `QoLEnhanced.cs` 的 `PatchMod()` 中添加注入代码，放入合适的区块/region
6. **测试** — 通过 MSL 编译并加载到游戏中验证

### 修改现有功能的注意事项

- **不要假设硬编码偏移量不变**：游戏版本更新后，`MatchFrom` 中的匹配字符串可能改变
- **已标注"硬编码"的代码位置**：版本升级时需优先检查（如骨器猎获、属性上限、经验曲线等）
- **匿名函数问题**：MSL 反编译/重编译时匿名函数会生成随机脚本 ID，应抽成独立命名脚本（参照 `SKILL.md` 中的解决方案）
- **匹配字符串必须有唯一性**：如果 `MatchFrom` 匹配到多处，注入行为不可预测

### BaseDataCode 使用方式

- **不要修改** BaseDataCode 中的任何文件
- 此目录位于 `../BaseDataCode/`（即 `ModSources/BaseDataCode/`），不在 QoLEnhanced 子目录下
- 当需要了解某个原版函数的实现时，在此目录中搜索对应的 `.gml` 文件
- 找到关键的代码行后，将其用作 `MatchFrom` 的匹配字符串
- 此目录文件巨大（如 `DialogueData.gml` 1.4MB），不要全量加载

---

## 调试与诊断

- `MslExtensions` 中的所有方法在未匹配时通过反射调用 WPF `MessageBox.Show` 弹出警告
- `debug.gml` 是编译后生成的完整代码副本，用于验证最终注入结果
- `ExportTable()` 方法可将游戏数据表导出为 TSV 文件到 `tmp/` 目录
- 被注释掉的代码块（如 L51-92 的搜索工具、L1108-1115 的 1080p 适配）是历史实验或备用方案
- **🔴 `show_message("info")` 断点调试（最高优先级调试策略）**：当有多个分支可能性无法确认时，**首先使用 `show_message()` 判断具体错误点**，而非穷举推理。直接在目标事件脚本中插入 `show_message("到达 X 事件")` 或 `show_message(string(variable))`。可用于：
  - 确认某个事件是否被执行
  - 打印变量值、实例 ID 确认是否正确获取
  - 追踪脚本执行路径
  - **最高效方式**：通过 UMT (UndertaleModTool) 直接在已编译的 data.win 中插入 `show_message()` 语句，无需重新构建 MSL 项目。只需在对话中告诉用户在哪行插入什么内容即可

## 版本升级风险点

游戏版本更新时，以下部分最容易出问题：

1. **`table_skills`/`table_skills_stats` 的 ASM 匹配** — 技能描述文本可能改变
2. **`o_player_Step_0` 的字节码范围替换** — 经验曲线硬编码
3. **`o_NPC_Create_0` 的价格表偏移** — `MatchBelow("Buying_Tier", 61)` 的 61 行偏移可能改变
4. **骨器猎获的 ASM 偏移标记** — 如 `:[92]`, `:[93]`, `:[114]`
5. **`scr_cook_check_raw_ingredients`** — 使用硬编码偏移量

<!-- QOL_SIGNATURE: 主人优先，规则至上 -->
