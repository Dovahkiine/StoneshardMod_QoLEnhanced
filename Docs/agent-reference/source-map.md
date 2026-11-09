# QoLEnhanced 按需参考

以下内容从原项目入口迁入；代码、命令及普通文本路径仍相对 QoLEnhanced 根。仅查当前任务相关章节，历史数值与文件身份须以当前源码核对。

## 目录结构

```
ModSources
├── QoLEnhanced/
│   ├── QoLEnhanced.cs               # 🔴 主入口 — 元数据 + PatchMod() 调度 (~300行)
│   ├── QoLEnhanced.GlobalConfig.cs   # 区块1: 地牢/陷阱/初始属性/宝箱/全局初始化
│   ├── QoLEnhanced.Enchantment.cs    # 区块2: 附魔系统
│   ├── QoLEnhanced.TimeAndHotkeys.cs # 区块3: 时间/自动寻路/快捷键/祈祷/特效
│   ├── QoLEnhanced.CharacterMechanics.cs # 区块4: 角色机制与开局
│   ├── QoLEnhanced.SkillsAndCombat.cs   # 区块5: 技能/免费回合/派系魔法
│   ├── QoLEnhanced.Consumables.cs    # 区块7: 消耗品与工具
│   ├── QoLEnhanced.Economy.cs        # 区块8: 经济系统
│   ├── QoLEnhanced.InventoryUI.cs    # 区块9: 背包与仓库UI
│   ├── QoLEnhanced.Stacking.cs       # 区块10: 堆叠系统
│   ├── QoLEnhanced.AttributeCaps.cs  # 区块11: 属性上限
│   ├── Localization.cs               # 本地化文本注入
│   ├── QoLEnhanced.csproj            # 项目配置
│   ├── QoLEnhanced.slnx              # 解决方案
│   ├── SKILL.md                      # 单功能深度文档（约娜天赋）
│   ├── AGENTS.md                     # 本文件 — 项目总览与架构文档
│   ├── Codes/                        # 🟡 注入的 GML/ASM 脚本 (66+ 个文件)
│   │   ├── gml_GlobalScript_*.gml     # 全量替换型脚本（替换原版函数）
│   │   ├── _scr_*.gml                 # 新增辅助函数（通过 AddFunction 注册）
│   │   ├── gml_Object_o_*_insert.gml  # 增量注入脚本（InsertBelow）
│   │   ├── gml_Object_o_*_instead.gml # 局部替换脚本（ReplaceBy）
│   │   ├── *.asm                      # ASM 字节码片段（ReplaceBy 到汇编上下文）
│   │   └── debug.gml                  # 编译后完整代码副本（调试用）
│   ├── Sprites/                      # 🖼️ UI 贴图 (540p / 720p 两种规格)
│   ├── lib/                          # 依赖 DLL (ModShardLauncher.dll, UndertaleModLib.dll)
│   └── tmp/                          # 临时导出文件
├── BaseDataCode/             # 📚 旧版本反编译脚本，用于版本差异比对
└── DataCode v9.4.23/         # 📚 当前版本反编译脚本，用于 MSL 匹配定位
```
