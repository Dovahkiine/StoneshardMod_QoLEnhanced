# QoLEnhanced 按需参考

以下内容从原项目入口迁入；代码、命令及普通文本路径仍相对 QoLEnhanced 根。仅查当前任务相关章节，历史数值与文件身份须以当前源码核对。

## 架构核心：MSL 注入机制

本模组的根本工作方式是**在游戏程序集（Undertale data.win）上做字符串匹配 + 代码替换**。不是运行时 hook，而是**构建时注入**。

### 文件类型与用途

| 目录 | 性质 | 用途 |
|------|------|------|
| `Codes/` | ✏️ 手写/修改的脚本 | 会被注入到游戏中，是实际生效的代码 |
| `DataCode v9.4.23/` | 📖 只读参考 | 当前游戏版本反编译文件，位于 `../DataCode v9.4.23/`，用于了解原版逻辑和定位匹配字符串 |
| `BaseDataCode/` | 📖 历史基线 | 旧版本反编译文件，位于 `../BaseDataCode/`，只用于版本差异比对 |

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

#### 规则 1a: `LoadGML` / `MatchFrom` 等匹配字符串里的参数名也必须用完整形式

当你从 BaseDataCode / UMT 反编译文本里抄一行去写 `MatchFrom`、`MatchBelow`、`MatchFromUntil` 的匹配字符串时，**不要保留 `arg0` / `arg1` / `arg2` 这种 UMT 缩写**，必须先改成 `argument0` / `argument1` / `argument2`，否则很容易匹配失败。

```
❌ 错误:  .MatchFrom("if (arg0 > 0)")
✅ 正确:  .MatchFrom("if (argument0 > 0)")

❌ 错误:  .MatchFrom("scr_skill_call_passive(arg0, arg1)")
✅ 正确:  .MatchFrom("scr_skill_call_passive(argument0, argument1)")
```

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

#### 规则 3a: 原始脚本文本的替代内容里，参数名同样必须写完整形式

这条规则不只适用于“函数定义”和“匹配字符串”，也适用于所有写回去的 GML 文本，包括：

- `ReplaceBy("...")`
- `InsertBelow("...")` / `InsertAbove("...")`
- `SetStringGMLInFile` 对应的整段脚本
- `Codes/` 目录下新增或替换的 `.gml` 文件

只要文本最终会被 MSL 当成 GML 重新编译，里面出现的参数引用就默认应写成 `argumentN`，不要写 `argN`。

```
❌ 错误:  .InsertBelow("if (arg0 > 0) arg1.value = arg0;")
✅ 正确:  .InsertBelow("if (argument0 > 0) argument1.value = argument0;")
```

#### 🔴 注入前自检清单：每次写 `LoadGML` 匹配/替代前都过一遍

1. **参数名检查**：BaseDataCode 里看到的 `argN`，在匹配字符串和替代字符串里都改成 `argumentN`
2. **分号检查**：`MatchFrom` / `MatchBelow` / `MatchFromUntil` 的匹配字符串末尾去掉 `;`
3. **作用域检查**：若替代文本要进 `with()`，优先确认是否需要提前 `var` 捕获，避免写出 `other.other`
4. **唯一性检查**：确认匹配字符串足够独特，避免命中多处

#### 规则 4: BaseDataCode 只读参考，不要照搬

从 BaseDataCode 复制代码行作为 `MatchFrom` 的匹配字符串时，需要将 `argN` 手动改写为 `argumentN`。但如果你是在做 **汇编级操作** (`LoadAssemblyAsString`)，则保持反汇编文本原样（因为它们操作的是字节码级别的符号）。

#### 规则 5: 函数首行/尾行注入优先用 `MatchAll` + `InsertAbove`/`InsertBelow`

在函数体开头或末尾注入代码时，`MatchAll` 比匹配特定字符串更稳健（不依赖具体行内容）：

```
✅ 推荐 (函数首行注入):  Msl.LoadGML("...").MatchAll().InsertAbove("新代码").Save();
✅ 推荐 (函数尾行注入):  Msl.LoadGML("...").MatchAll().InsertBelow("新代码").Save();
```

> `MatchAll` 匹配整个脚本的全部内容，`InsertAbove` 在所有内容之前插入，`InsertBelow` 在所有内容之后插入。

#### 规则 6: 方法变量（execute 等）不能用 `self.method()` 直接调用

游戏对象在 Create 事件中以 `execute = function(){...}` 形式赋值的方法变量，**不在 Scripts 列表中**。直接写 `self.execute(true)` 可能被 MSL 编译成错误的实例方法调用形态，导致栈泄漏或运行时异常。

```gml
❌ 错误:  self.execute(true)  // 栈泄漏
✅ 候选写法（需按具体上下文测试）:
with (o_inv_bone_cradle)
{
    var _fn = variable_instance_get(id, "execute");
    script_execute(_fn, true);
}
```

> 注意：当前游戏运行时无法找到 `method_call`，不要使用 `method_call(_fn, [...])`。如果 `script_execute(_fn, ...)` 对内部函数变量不生效，需要进一步对照原版 ASM 的 `push.v builtin.execute` + `callv.v` 调用形态，或改用全局 `AddFunction` 脚本承载逻辑。

#### 规则 7: AddFunction 必须在调用方之前注册

`Msl.AddFunction()` 注册的新函数必须在所有引用它的代码（`SetStringGMLInFile`、`InsertBelow` 等）**之前**执行。否则 MSL 编译器无法解析函数调用，导致运行时崩溃。

#### 规则 7a: AddFunction 的注册顺序必须按依赖拓扑排列（高优先级）

如果新增函数之间存在调用关系，顺序必须是：

1. 先注册底层 helper（被调用者）
2. 再注册上层 helper（调用者）
3. 最后再注入/替换会调用它们的原版脚本

> 记忆法：**先被调用者，后调用者，最后改原版脚本。**

#### 规则 7b: 为了规避 MSL 解析器脆弱性，helper 默认坚持“一文件一函数”（高优先级）

虽然 GameMaker 语法允许一个文件里写多个函数，但在本项目的 MSL `AddFunction` 工作流里，**默认必须坚持一个 `.gml` 文件只放一个函数**。不要把多个 helper 塞进同一个 `_scr_*.gml` 文件后再一起注册。

> 这样做的目的不是语法正确性，而是降低 MSL 解析、注册名映射、依赖排查时的歧义。

#### 规则 8: `scr_skill_call_passive` 签名速查

```gml
function scr_skill_call_passive(arg0, arg1=id, arg2=-4, arg3=false, arg4="", arg5=0)
// arg0 = 被动对象类型 (如 o_pass_skill_residual_charge)
// arg1 = owner id
// arg2 = target（-4 为不指定）
// arg3 = crit_attack ← 暴击标志从这里传入
// arg4 = 附加字符串参数
// arg5 = 附加数值参数
```

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
Msl.LoadGML("gml_GlobalScript_scr_trap_find")
    .MatchFrom("find_chance = 0.5")
    .ReplaceBy("find_chance = scr_atr(\"PRC\") / R")
    .Save();
```

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
Msl.LoadGML("gml_Object_o_skill_enchantment_Other_11")
    .MatchFromUntil("if (image_alpha", "目标结束锚点")
    .ReplaceBy(ModFiles.GetCode("gml_Object_o_skill_enchantment_Other_11_instead.gml"))
    .Save();
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

#### 模式 7: UI/菜单注入

```csharp
Msl.AddMenu("自动寻路", new UIComponent[2] { ... });
// AddObject 签名: (name, sprite, parent, visible, solid, isAwake, collisionShape)
Msl.AddObject("o_globalmapTP", "s_gui_button_skipturn", "o_button", true, false, true, (CollisionShapeFlags)0);
```

### 操作模式选择指南

| 场景 | 推荐方式 |
|------|---------|
| 修改单个值/常量 | `LoadGML` + `MatchFrom` + `ReplaceBy` (模式1) |
| 修改 table_* 中的技能描述 | `LoadAssemblyAsString` + `MatchFrom/ReplaceBy` + `.asm` 文件 (模式2) |
| 替换整个函数实现 | `SetStringGMLInFile` (模式5) |
| 新增可复用函数 | `AddFunction` (模式4) |
| 在现有逻辑中插入新代码 | `LoadGML` + `InsertBelow` (模式6) |

---
