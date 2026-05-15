// Copyright (C)
// See LICENSE file for extended copyright information.
// This file is part of the repository from .

using ModShardLauncher;
using ModShardLauncher.Mods;
using UndertaleModLib.Models;
using System.Windows;
using System.Diagnostics;
using System.IO;

namespace QoLEnhanced
{

    public class QoLEnhanced : Mod
    {
        // ========================================================================
        // 模组元数据 (Mod Metadata)
        // ========================================================================

        public override string Author => "Dovahkiin";

        public override string Name => "品质优化";

        public override string Description => "游戏内容大修，详见Nexusmods更新说明";

        public override string Version => "1.0.0.0";

        public override string TargetVersion => "0.9.4.14";

        // ========================================================================
        // 模组补丁入口 (Mod Patch Entry)
        // ========================================================================


        public override void PatchMod()
        {

            // 定义一个内部函数用来弹窗，避免编译器直接检查 System.Windows
            Action<string> safeShow = (msg) =>
            {

                // 在已加载的程序集中寻找 WPF 库
                var ass = AppDomain.CurrentDomain.GetAssemblies()
                            .FirstOrDefault(a => a.GetName().Name == "PresentationFramework");
                var type = ass?.GetType("System.Windows.MessageBox");
                type?.GetMethod("Show", new[] { typeof(string) })?.Invoke(null, new[] { msg });

            };

            /* try
            {
                // 1. 使用反射强行获取 MSL 内部的 Data 属性
                var dataProp = typeof(ModLoader).GetProperty("Data", System.Reflection.BindingFlags.Static | System.Reflection.BindingFlags.NonPublic);

                if (dataProp != null)
                {
                    // 2. 将拿到的数据转换为 UndertaleData 类型
                    var data = dataProp.GetValue(null) as UndertaleModLib.UndertaleData;

                    if (data != null)
                    {
                        string found = "开始搜索...\n";
                        int count = 0;

                        // 3. 遍历所有的代码文件
                        foreach (var code in data.Code)
                        {
                            // 关键词
                            if (code.Name?.Content != null && code.Name.Content.Contains("", StringComparison.OrdinalIgnoreCase))
                            {
                                found += $"发现: {code.Name.Content}\n";
                                count++;
                            }
                        }

                        // 4. 强行弹窗显示结果
                        safeShow(found + $"搜索结果 (共 {count} 个)");
                        string mub = Msl.GetStringGMLFromFile("");
                        safeShow(mub);
                        return; // 找到名字后就退出，别让后面的代码崩了
                    }
                }
                safeShow("反射获取 Data 失败。");
            }
            catch (Exception ex)
            {
                safeShow($"搜索代码崩了: {ex.Message}");
            }


            return; */ // 阻断原有的崩溃逻辑




            // return; //先阻断后续的修改，避免不必要的崩溃，等后续功能开发稳定了再放开

            // ========================================================================
            // 运行时文本覆写 (在 table 加载完成后覆盖，替代 ASM argc 硬编码)
            // .asm 文件存完整 CSV 行 (key;lang1;...;lang12)，GML 注入时拆分为数组取当前语言
            // ========================================================================

            // --- table_skills (case 3): 描述文本 ---
            {
                var sb = new System.Text.StringBuilder();
                foreach (var asm in new[] {
                    "gml_GlobalScript_table_skills_rebalance_discharge.asm",
                    "gml_GlobalScript_table_skills_rebalance_impulse.asm",
                    "gml_GlobalScript_table_skills_rebalance_last_effort.asm",
                    "gml_GlobalScript_table_skills_rebalance_lightning_reflexes.asm",
                    "gml_GlobalScript_table_skills_rebalance_magical_erudition.asm",
                    "gml_GlobalScript_table_skills_rebalance_preparation.asm",
                    "gml_GlobalScript_table_skills_rebalance_right_on_target.asm",
                    "gml_GlobalScript_table_skills_rebalance_riposte.asm",
                    "gml_GlobalScript_table_skills_rebalance_seize_the_initiative.asm",
                    "gml_GlobalScript_table_skills_rebalance_self_repair.asm",
                    "gml_GlobalScript_table_skills_rebalance_sprint_training.asm",
                    "gml_GlobalScript_table_skills_rebalance_taking_aim.asm",
                    "gml_GlobalScript_table_skills_rebalance_thrift.asm",
                    "gml_GlobalScript_table_skills_rebalance_vow_feat.asm",
                    "gml_GlobalScript_table_skills_rebalance_war_cry.asm",
                })
                {
                    var raw = ModFiles.GetCode(asm).Trim();
                    var t = raw.StartsWith("push.s \"") ? raw.Substring(8, raw.Length - 9) : raw;
                    var parts = t.Split(';');
                    if (parts.Length < 2) continue;
                    var arr = "[" + string.Join(", ", parts.Select(p => $"\"{p.Replace("\\", "\\\\").Replace("\"", "\\\"")}\"")) + "]";
                    sb.AppendLine($"var _e = {arr}; ds_map_set(global.skill_desc, _e[0], string_replace_all(_e[global.language], \"#\", \"\\n\"));");
                }
                Msl.LoadGML("gml_Object_o_textLoader_Other_25")
                    .MatchFrom("scr_tableWriteList(global.skill_mid_text, _array, \"skill_mid_text\")")
                    .InsertBelow(sb.ToString().TrimEnd())
                    .Save();
            }

            // --- table_skills (case 3): 名称覆写 ---
            {
                var raw = ModFiles.GetCode("gml_GlobalScript_table_skills_rename_last_effort.asm").Trim();
                var t = raw.StartsWith("push.s \"") ? raw.Substring(8, raw.Length - 9) : raw;
                var parts = t.Split(';');
                var arr = "[" + string.Join(", ", parts.Select(p => $"\"{p.Replace("\\", "\\\\").Replace("\"", "\\\"")}\"")) + "]";
                Msl.LoadGML("gml_Object_o_textLoader_Other_25")
                    .MatchFrom("scr_tableWriteList(global.skill_mid_text, _array, \"skill_mid_text\")")
                    .InsertBelow($"var _e = {arr}; ds_map_set(global.skill_name_text, _e[0], string_replace_all(_e[global.language], \"#\", \"\\n\"));")
                    .Save();
            }

            // --- table_text (case 0): prefix (ds_map) + rarity (ds_list) ---
            {
                var sb = new System.Text.StringBuilder();
                foreach (var line in ModFiles.GetCode("gml_GlobalScript_table_text_prefix.asm").Split('\n'))
                {
                    var t = line.Trim();
                    if (!t.StartsWith("push.s \"")) continue;
                    var inner = t.Substring(8, t.Length - 9);
                    var parts = inner.Split(';');
                    var arr = "[" + string.Join(", ", parts.Select(p => $"\"{p.Replace("\\", "\\\\").Replace("\"", "\\\"")}\"")) + "]";
                    sb.AppendLine($"var _e = {arr}; ds_map_set(global.prefix_text, _e[0], string_replace_all(_e[global.language], \"#\", \"\\n\"));");
                }
                foreach (var line in ModFiles.GetCode("gml_GlobalScript_table_text_rarity.asm").Split('\n'))
                {
                    var t = line.Trim();
                    if (!t.StartsWith("push.s \"")) continue;
                    var inner = t.Substring(8, t.Length - 9);
                    var parts = inner.Split(';');
                    var arr = "[" + string.Join(", ", parts.Select(p => $"\"{p.Replace("\\", "\\\\").Replace("\"", "\\\"")}\"")) + "]";
                    sb.AppendLine($"var _e = {arr}; ds_list_add(global.rar_text, string_replace_all(_e[global.language], \"#\", \"\\n\"));");
                }
                Msl.LoadGML("gml_Object_o_textLoader_Other_25")
                    .MatchFrom("scr_tableWriteMap(global.sight_text, _array, \"sight\")")
                    .InsertAbove(sb.ToString().TrimEnd())
                    .Save();
            }

            // ========================================================================
            // 区块 1: 全局配置与游戏机制 (Global Configuration & Game Mechanics)
            // ========================================================================
            // 功能: 提升游戏难度和视觉体验，调整地牢机制
            // 范围: 密室生成、照明、陷阱发现、敌人生成、初始属性等

            #region 1.1 地牢机制 (Dungeon Mechanics)

            // [密室机制] 密室出现概率上调至 100%
            // 原值: 5% | 新值: 100% | 目的: 提升地牢探索的多样性和挑战
            MslExtensions.QuickMatch("gml_GlobalScript_scr_dungeonHasSecretRoom", "return scr_chance_value(5)", "return scr_chance_value(100);");

            // [全局亮度] 调整地牢光照颜色，提升视觉体验
            // 作用: 统一所有地形的光照效果，增强视觉一致性
            Msl.LoadGML("gml_GlobalScript_scr_dungeonSetSettings")
                .MatchFrom("_settings.LightColor = (_settings.CurrentFloor == 1 ? [72,")
                .ReplaceBy("_settings.LightColor = (_settings.CurrentFloor == 1 ? [122, 198, 177] : [122, 198, 177]);")
                .MatchFrom("_settings.LightColor = (_settings.CurrentFloor == 1 ? [50,")
                .ReplaceBy("_settings.LightColor = (_settings.CurrentFloor == 1 ? [90, 107, 194] : [90, 107, 194]);")
                .MatchFrom("_settings.LightColor = (_settings.CurrentFloor == 1 ? [123,")
                .ReplaceBy("_settings.LightColor = (_settings.CurrentFloor == 1 ? [182, 106, 106] : [151, 75, 75]);")
                .MatchFrom("_settings.LightColor = (_settings.CurrentFloor == 1 ? [97,")
                .ReplaceBy("_settings.LightColor = (_settings.CurrentFloor == 1 ? [151, 75, 75] : [182, 106, 106]);")
                .MatchFrom("_settings.LightColor = (_settings.CurrentFloor == 1 ? [62,")
                .ReplaceBy("_settings.LightColor = (_settings.CurrentFloor == 1 ? [102, 120, 114] : [102, 120, 114]);")
                .Save();


            #endregion


            #region 1.2 陷阱与敌人 (Traps & Enemies)


            // [陷阱发现] 陷阱发现几率基于感知属性 (PRC)，移除固定概率
            // 目的: 使陷阱发现与角色属性挂钩，增加游戏平衡性
            Msl.LoadGML("gml_GlobalScript_scr_trap_find")
                .MatchFrom("other.trap_find = (0.75").ReplaceBy("other.trap_find = scr_atr(\"PRC\") / R")
                .MatchFrom("other.trap_find = 0.05").ReplaceBy("other.trap_find = scr_atr(\"PRC\") / R")
                .MatchFrom("find_chance = 0.5").ReplaceBy("find_chance = scr_atr(\"PRC\") / R")
                .Save();

            // [刷怪倍率] 敌人生成数量提升至 3 倍
            // 原值: 1x | 新值: 3x | 难度提升: 增加战斗挑战性
            Msl.LoadGML("gml_Object_o_mob_point_Other_11")
                .MatchFrom("var _size ")
                .InsertBelow("repeat (3)")
                .Save();

            // 地面敌人生成数量变为 3 倍
            Msl.LoadGML("gml_GlobalScript_scr_surfaceSpawnsDoc").MatchFrom("if (_enemyStringArray").InsertAbove("repeat (3)").Save();
            // 全面加强地面生物刷新列表强度
            Msl.SetStringGMLInFile(ModFiles.GetCode("gml_GlobalScript_table_surface_spawn.gml"), "gml_GlobalScript_table_surface_spawn");

            // [敌人属性缩放] 根据玩家等级动态调整怪物属性，提升游戏挑战性
            Msl.AddFunction(ModFiles.GetCode("_scr_scale_enemy_csv_by_level.gml"), "gml_GlobalScript__scr_scale_enemy_csv_by_level");
            MslExtensions.QuickInsertBelow("gml_Object_o_mob_point_Other_10", "}", "_scr_scale_enemy_csv_by_level();");
            MslExtensions.QuickInsertBelow("gml_GlobalScript_scr_sessionDataInit", "audio_sound_gain", @"
            _scr_scale_enemy_csv_by_level();
            global.got_free_turn = 0;");

            // 调整经验值缩放公式，确保在高等级时仍能获得合理的经验奖励，避免过度惩罚玩家
            Msl.LoadAssemblyAsString("gml_Object_o_enemy_Destroy_0").MatchBelow("pop.v.v local._lvl", 14).ReplaceBy(ModFiles.GetCode("gml_Object_o_enemy_Destroy_0_insert.asm")).Save();

            #endregion

            #region 1.3 初始属性 (Initial Attributes)

            // [初始属性] 提升新游戏初始能力点 (AP) 0 -> 5
            // 影响: 玩家开局自由度提升，更灵活的属性配置
            MslExtensions.QuickMatch("gml_GlobalScript_scr_characterMapInit",
                "ds_map_add(global.characterDataMap, \"AP\", 0)",
                "ds_map_add(global.characterDataMap, \"AP\", 5);");

            // [初始属性] 提升新游戏初始技能点 (SP) 2 -> 5
            // 影响: 玩家初期技能学习更加便利
            MslExtensions.QuickMatch("gml_GlobalScript_scr_characterMapInit",
                "ds_map_add(global.characterDataMap, \"SP\", 2)",
                "ds_map_add(global.characterDataMap, \"SP\", 5);");

            // [等级上限] UI 面板修正：将经验条和等级显示的硬上限从 30 提升至 100
            // 目的: 支持更高的角色等级上限，提升长期游玩目标
            MslExtensions.QuickMatch("gml_Object_o_character_panel_mask_Draw_0",
                "var _maxLevel = scr_atr(\"LVL\") == 30",
                "var _maxLevel = scr_atr(\"LVL\") == 100;");

            // [敏捷增益] 敏捷属性获得每点提供额外减伤 2% 的效果
            Msl.LoadAssemblyAsString("gml_GlobalScript_table_attributes")
                .MatchFrom("push.s \"AGL;~sy~").ReplaceBy(ModFiles.GetCode("gml_GlobalScript_table_attributes_rebalance_agility.asm"))
                .Save();


            #endregion

            #region 1.4 宝箱奖励机制调整 (Chest Reward Mechanism Adjustments)

            // 增加箱子奖励的数量
            MslExtensions.QuickMatchBelow("gml_Object_c_container_Other_13", "with (scr_container_create", 5, @"
            {
                repeat (2)
                {
                    randomize();
                    script_execute(other.loot_script, other.loot_script_key, other.loot_script_tier);
                }
            }");

            #endregion




            // ========================================================================
            // 区块 2: 物品与附魔系统 (Items & Enchantment System)
            // ========================================================================
            // 功能: 强化物品附魔系统，添加新的品质前缀，提升装备自定义性
            // 范围: 物品品质、附魔生成、附魔核心逻辑等

            #region 2.1 物品品质与装饰文本 (Item Quality & Text Tables)


            #endregion




            #region 2.2 附魔生成与机制 (Enchantment Generation & Mechanism)

            // [附魔生成] 优化附魔词缀生成逻辑，增加更多前缀种类，并使其与物品属性更紧密地挂钩
            // 目的: 提升附魔系统的丰富性和不可预测性
            MslExtensions.QuickMatchBelowFiles("gml_Object_o_skill_enchantment_Other_11", "if (image_alpha", 2, ModFiles, "gml_Object_o_skill_enchantment_Other_11_instead.gml");

            // [附魔核心] 注入附魔核心逻辑脚本
            // 作用: 构建完整的附魔体系，支持更丰富的镶嵌组合
            Msl.AddFunction(ModFiles.GetCode("_scr_init_weapon_prefixes.gml"), "gml_GlobalScript__scr_init_weapon_prefixes");
            Msl.SetStringGMLInFile(ModFiles.GetCode("gml_GlobalScript_scr_weapon_generation.gml"), "gml_GlobalScript_scr_weapon_generation");
            Msl.SetStringGMLInFile(ModFiles.GetCode("gml_GlobalScript_scr_weapon_prefix_generation.gml"), "gml_GlobalScript_scr_weapon_prefix_generation");
            Msl.SetStringGMLInFile(ModFiles.GetCode("gml_GlobalScript_scr_weapon_generation_prefix_search.gml"), "gml_GlobalScript_scr_weapon_generation_prefix_search");

            // [附魔条件] 限制附魔只对已识别的武器生效，且不能是诅咒装备
            // 目的: 防止玩家利用附魔规避限制
            MslExtensions.QuickMatch("gml_Object_o_skill_enchantment_Other_20",
                "if (owner.object_index",
                "if (owner.object_index != o_trade_inventory && is_weapon && ds_map_find_value_ext(data, \"identified\", false) && !ds_map_find_value_ext(data, \"is_cursed\", true))");

            #endregion




            #region 2.3 品质自定义 (Quality Customization)

            // [品质背景] 为史诗品质 (Epic) 添加专属背景色
            // 目的: 提高稀有装备的视觉识别度
            MslExtensions.QuickInsertBelow("gml_GlobalScript_scr_qualityBgDraw", "_colorTexture = make_color_rgb(34", @"
            break;
            
            case (4 << 0):
                _colorBG = make_color_rgb(51, 40, 1);
                _colorTexture = make_color_rgb(92, 67, 5);");

            #endregion




            // ========================================================================
            // 区块 3: 时间系统与快捷键 (Time System & Hotkeys)
            // ========================================================================
            // 功能: 增加便利的快捷键操作和时间显示功能
            // 范围: 时间显示、快捷键、存档机制、夜视等

            #region 3.1 时间显示与驱动 (Time Display & Driver)

            // [时间显示] 注册时间 UI 更新脚本
            // 目的: 在游戏中实时显示游戏内的时间
            Msl.LoadGML("gml_GlobalScript_scr_actionsLog").MatchFrom("scr_actionsLogUpdate").InsertAbove(@"
            // --- 时间戳前缀注入逻辑 ---
            if (variable_global_exists(""timeDataMap"") && ds_exists(global.timeDataMap, ds_type_map)) 
            {
                var _h = ds_map_find_value(global.timeDataMap, ""hours"")
                var _m = ds_map_find_value(global.timeDataMap, ""minutes"")
                
                if (!is_undefined(_h) && !is_undefined(_m)) 
                {
                    var _hs = (_h < 10 ? ""0"" : """") + string(_h)
                    var _ms = (_m < 10 ? ""0"" : """") + string(_m)
                    
                    // 核心：修改原本传入的文本 (argument0)
                    // ~y~ 开启黄色，~c~ 或 ~w~ (根据原版色彩符定) 用于重置颜色，防止整句话都变黄
                    _log = ""[~y~"" + _hs + "":"" + _ms + ""~c~] "" + _log
                }
            }
            ").Save(); // 在日志更新函数前注入时间戳逻辑，确保每条日志都带有当前游戏时间的前缀

            #endregion


            #region 3.2 自动寻路系统 (Auto-Pathfinder System)

            // 允许在标记后自动寻路到标记位置，支持地图标记和实体标记两种类型
            Msl.AddFunction(base.ModFiles.GetCode("_scr_redeactivate_instances.gml"), "gml_Script__scr_redeactivate_instances");
            Msl.AddFunction(base.ModFiles.GetCode("_scr_stop_auto_move.gml"), "gml_Script__scr_stop_auto_move");
            Msl.AddFunction(base.ModFiles.GetCode("_scr_move_player_to.gml"), "gml_Script__scr_move_player_to");
            Msl.AddFunction(base.ModFiles.GetCode("_scr_calculate_closest_point.gml"), "gml_Script__scr_calculate_closest_point");
            Msl.AddFunction(base.ModFiles.GetCode("_scr_find_nearest_tile_transition.gml"), "gml_Script__scr_find_nearest_tile_transition");
            Msl.AddFunction(base.ModFiles.GetCode("_scr_find_exit_door.gml"), "gml_Script__scr_find_exit_door");
            Msl.AddFunction(base.ModFiles.GetCode("_scr_auto_move_to_transition.gml"), "gml_Script__scr_auto_move_to_transition");
            Msl.AddMenu("自动寻路", (UIComponent[])(object)new UIComponent[2]
            {
                    new UIComponent("地图标记", "map_mark_type", 0, new string[12]
                    {
                        "Flag", "Grave", "Sword", "Crown", "Bow", "Diamond", "Arrow", "Food", "Tower", "Cross",
                        "Chest", "Skull"
                    }),
                    new UIComponent("如果有多个选定的标记，前往最近的那个点", "go_to_nearest_mark", (UIComponentType)1, 0)
            });
            Msl.LoadGML("gml_Object_o_globalmapMarkUserContext_Other_25").MatchFrom("var _mark = scr_globalmapMarkCreate").InsertAbove(@"
                var _mark_type = ""Flag"";

                if (variable_global_exists(""map_mark_type"") && is_string(global.map_mark_type) && global.map_mark_type != ""0"")
                    _mark_type = global.map_mark_type;

                var _target_sprite = asset_get_index(""s_glmap_mark_user_"" + _mark_type)

                if (!global.go_to_nearest_mark && other.markSpriteIndex == _target_sprite)
                {
                    with (o_globalmapMarkUser)
                    {
                        if (sprite_index == _target_sprite)
                            instance_destroy();
                    }
                }
                ").Save();      // 确定使用者的标记类型，并在玩家创建标记时检查是否需要销毁现有标记，避免重复标记造成混乱

            Msl.LoadGML("gml_Object_o_player_Create_0").MatchAll().InsertBelow(@"
            auto_move = true
            tile_transition = false").Save(); // 增加自动寻路状态标记，配合寻路脚本使用
            Msl.LoadGML("gml_Object_o_player_Other_17").MatchAll().InsertAbove("tile_transition = true;").Save(); // 在玩家创建时默认开启 tile_transition，确保寻路功能正常使用
            Msl.LoadGML("gml_Object_o_player_Other_17").MatchAll().InsertBelow("tile_transition = false;").Save(); // 在玩家创建后立即关闭 tile_transition，确保正常游戏流程不受影响
            MslExtensions.QuickInsertBelow("gml_GlobalScript_scr_stop_player", "path = -1", @"
            if (!tile_transition)
                _scr_stop_auto_move();"); // 在原有的停止移动逻辑基础上增加对 tile_transition 的检查，确保只有在非寻路状态下才调用 _scr_stop_auto_move，避免寻路过程中被意外打断


            // [整合] o_player_Step_0 全量替换 — 合并等级AP/SP、经验曲线、标记地点导航、免费回合移动消费
            Msl.SetStringGMLInFile(ModFiles.GetCode("gml_Object_o_player_Step_0.gml"), "gml_Object_o_player_Step_0");
            Localization.ActionLogsPatching();              //本地化
            // ExportTable("gml_GlobalScript_table_lines");    //导出文本表，方便后续修改和本地化，暂时不用

            #endregion



            #region 3.3 快捷键系统 (Hotkey System)


            // [快捷键 F2] 注入 F2 键 (113) 前往标记点(自动寻路)
            // 目的: 提供快速前往最近的一个地图标记点的功能，提升游戏便利性
            Msl.SetStringGMLInFile(ModFiles.GetCode("gml_Object_o_player_KeyPress_113.gml"), "gml_Object_o_player_KeyPress_113");

            // [快捷键 F3] 注入 F3 键 (114) 打开马车储存箱的逻辑
            // 效果: 快速访问大篷车仓库
            Msl.SetStringGMLInFile(ModFiles.GetCode("gml_Object_o_player_KeyPress_114.gml"), "gml_Object_o_player_KeyPress_114");

            // [快捷键 F5] 注入 F5 键 (116) 快速存档功能的逻辑
            // 效果: 快速保存游戏进度，无需打开菜单
            // 注意: 可能与原生存档系统冲突，建议暂时禁用此功能进行测试
            Msl.SetStringGMLInFile(ModFiles.GetCode("gml_Object_o_player_KeyPress_116.gml"), "gml_Object_o_player_KeyPress_116");

            // [快捷键 F9] 注入 F9 键 (120) 去除所有迷雾功能的逻辑
            // 效果: 揭示地图迷雾，便于探索和规划
            Msl.SetStringGMLInFile(ModFiles.GetCode("gml_Object_o_player_KeyPress_120.gml"), "gml_Object_o_player_KeyPress_120");

            #endregion



            #region 3.4 人类祈祷优化 (Human Blessing Optimization)

            // 重写人类祈祷的核心逻辑，改为永久持续且基于时间的阶段性增益系统，增加了与黑色石碑相关(烂柳任务)的额外属性加成
            Msl.InsertGMLString(@"
            save_counter = 0;
            stage = ds_map_find_value(data, ""__stage"");
            if (is_undefined(stage))
                stage = 0;
            max_stage = 3;
            have_duration = false;
            draw_duration = false;
            have_stages = true;
            ", "gml_Object_o_b_bless_Create_0", 6);
            Msl.SetStringGMLInFile(@"
            event_user(0);

            if (is_player(target) && scr_psy_time_check(""BlessTime"", 24, 2))
                scr_psy_change(""SanityLifestyle"", 1 * scr_psy_get(""LifestyleSanityCoef"", false, 1), ""bless"");

            if (!is_load)
            {
                with (target)
                {
                    scr_guiAnimation(s_blessing, 1, 1);
                    audio_play_sound(snd_altar_buff, 4, 0);
                    
                    if (is_player())
                        scr_characterStatsUpdateAdd(""usedAltars"", 1);
                }
            }
            ", "gml_Object_o_b_bless_Alarm_2");
            Msl.InsertGMLString(@"
            var _defense_boost = 0;

            if (scr_npc_lines_black_tablet_check_bless_boost())
                _defense_boost = 6;

            var _timer_fired = (save_counter >= 1440 || save_counter == 0);
            if (_timer_fired)
            {
                save_counter = 0;
                if (stage < max_stage)
                    stage++;
            }

            var _last_boost = ds_map_find_value(data, ""__boost_state"");
            if (is_undefined(_last_boost))
                _last_boost = -1;

            if (_timer_fired || _defense_boost != _last_boost)
            {
                __dsDebuggerMapClear(data);
                ds_map_add(data, ""__stage"", stage);
                ds_map_add(data, ""__boost_state"", _defense_boost);
                ds_map_add(data, ""Received_XP"", 5 * stage);
                ds_map_add(data, ""Sacred_Damage"", stage);
                ds_map_add(data, ""Fortitude"", 9 * stage);
                ds_map_add(data, ""Crit_Avoid"", (9 * stage) + _defense_boost);
                ds_map_add(data, ""Unholy_Resistance"", (9 * stage) + _defense_boost);
            }

            save_counter++;
            ", "gml_Object_o_b_bless_Other_10", 1);


            #endregion



            #region 3.5 特殊效果 (Special Effects)

            // [夜视机制] 星盘在夜间提供清晰视野效果
            // 目的: 使特定装备在夜间有明确的实用价值
            // 注意: 使用了 data 变量，确保在正确的上下文中使用
            MslExtensions.QuickMatchBelow("gml_Object_o_inv_nikos_astrolabe_Other_24", "if (global.floor_counter", 3, @"
            {
                if (ds_map_find_value(global.timeDataMap, ""hours"") >= 19 || ds_map_find_value(global.timeDataMap, ""hours"") <= 7)
                {
                    scr_effect_create(o_b_clearsight, 2880);
                    ds_map_set(data, ""use_kd"", 18);
            ");

            // [马车调度] 调整马车调度时间为 1.5 天
            // 目的: 增加商人补给的频率，改善经济系统平衡
            MslExtensions.QuickMatch("gml_GlobalScript_scr_caravanSettingsGetDispatchTime", "var _dispatchTime", "var _dispatchTime = 1.5;");

            // 睡觉获得的精神焕发时间翻三倍
            MslExtensions.QuickMatchBelow("gml_Object_o_sleepController_Other_10", "scr_lifeParamsUpdate", 2, @"
            _freshDuration = max(_freshDuration * 4, 480);
            scr_modifier_change(o_player, o_b_fresh, _freshDuration * sleepHours, 7200);");

            // 时刻机警获得的精神焕发时间大幅延长
            // 时刻机警获得的精神焕发时间从 10 分钟提升到 1 小时，增强其在长时间探索中的实用性
            MslExtensions.QuickMatch("gml_Object_o_pass_skill_lightning_reflexes_Other_19", "scr_modifier_change",
            "scr_modifier_change(o_player, o_b_fresh, 120, 7200);");
            // 修改技能描述文本，反映新的效果和机制
            // [已迁移] 运行时覆写 → o_textLoader_Other_25 case 3, 避免 argc 硬编码冲突

            #endregion


            // ========================================================================
            // 区块 4: 角色机制与全开局优化 (Character Mechanics & Starter Buffs)
            // ========================================================================
            // 功能: 强化角色被动和初始装备，预设所有角色获得优势
            // 范围: 野性狩猎、初始饰品、DLC 物品等

            #region 4.1 野性狩猎全局生效 (Wild Hunt Global Application)

            // [野性狩猎逻辑] 移除对 o_perk_wild_hunt 存在的硬性判定，使全局生效
            // [全角色野性狩猎] 将"野性狩猎 kill 统计 + Trigger(4)"注册逻辑挂到 perk 基类的 Create
            // - 避免直接 patch 某些特定 perk（例如 vow_feat）时触发反编译崩溃
            // - gml_Object_o_perk_wild_hunt_array_0.gml 内部用 global.qol_wild_hunt_registered 做"只注册一次"保护
            // 目的: 使所有角色都能受益于野性狩猎相关机制
            Msl.InsertGMLString(ModFiles.GetCode("gml_Object_o_perks_Create_0.gml"), "gml_Object_o_perks_Create_0", 15);

            // [野性狩猎强化] 所有人都默认具有野性狩猎的负面阈值提升效果，增加阈值成长性
            // 修改对象: 多个状态检查脚本（疼痛、中毒、饥饿、口渴、疲劳）
            string[] wildHuntChecks =
            {
                "gml_GlobalScript_scr_paincheck",
                "gml_GlobalScript_scr_intoxication_check",
                "gml_GlobalScript_scr_hungercheck",
                "gml_GlobalScript_scr_thirsty_check",
                "gml_GlobalScript_scr_fatigue_check",
            };
            foreach (var gmlName in wildHuntChecks)
            {
                MslExtensions.QuickMatch(gmlName, "var _wildhunt_modifier", "var _wildhunt_modifier = floor(scr_atr(\"LVL\") * 0.6);");
                MslExtensions.QuickMatchBelow(gmlName, "var _wildhunt_modifier", 2, "");
            }

            // [野性狩猎移除限制] 移除对野性狩猎实例存在性的硬性判定
            // 效果: 被动生效不再依赖特定 perk 对象
            MslExtensions.QuickMatch("gml_Object_o_pass_skill_resourcefulness_Alarm_4", "if instance_exists(o_perk_wild_hunt)", "");

            // [全角色开局饰品] 为所有初始角色增加"希尔达的饰品 (Hilda's Trinket)"
            string[] starterChars = {
                "gml_Object_o_knight_maiden_Create_0", "gml_Object_o_runaway_wizzard_Create_0",
                "gml_Object_o_reaver_Create_0", "gml_Object_o_revenger_Create_0",
                "gml_Object_o_woodward_Create_0", "gml_Object_o_agemon_Create_0",
                "gml_Object_o_dervish_Create_0"
            };
            string hildaTrinketGML = @"
                scr_inventory_add_item(o_inv_hilda_trinket);
                var _list = scr_atr(""recipesConsumsOpened"");
                ds_list_add(_list, ""hilda_trinket"");
            ";
            foreach (var character in starterChars)
            {
                MslExtensions.QuickInsertBelow(character, "scr_inventory_add_item(o_inv_map_osbrook)", hildaTrinketGML);
            }

            // [希尔达饰品] 修改骨器猎获的初始数值和最高数值
            // 目的: 增强希尔达被动机制的实用性和成长空间 带有硬编码标记，后续版本可能需要调整
            Msl.SetStringGMLInFile(ModFiles.GetCode("gml_GlobalScript_scr_consum_hilda_enchant_assign.gml"), "gml_GlobalScript_scr_consum_hilda_enchant_assign");
            Msl.LoadAssemblyAsString("gml_GlobalScript_scr_cook_check_raw_ingredients")
            .MatchBelow(":[92]", 1).ReplaceBy("pushi.e 15")
            .MatchBelow(":[93]", 2).ReplaceBy("pushloc.v local.i\r\npushi.e 17")
            .MatchBelow("pushloc.v local.j", 1).ReplaceBy("pushi.e 17")
            .MatchBelow(":[114]", 1).ReplaceBy("pushi.e 15").Save(); // 修改骨器猎获类别上限

            #endregion



            #region 4.2 开局装备强化 (Starter Equipment Boost)

            // [开局 DLC 物品] 启用开局获得 DLC 物品
            // 目的: 所有玩家都能体验完整的装备选择
            MslExtensions.QuickMatch("gml_Object_o_player_chest_Alarm_1", "if (scr_user_owns", "");

            #endregion



            #region 4.3 阿娜天赋优化 (Ana Talented Optimization)

            // [阿娜天赋] 提升阿娜誓约天赋的属性加成效果
            // 目的: 增强誓约天赋的实用性，使其成为更有吸引力的选择
            Msl.LoadAssemblyAsString("gml_Object_o_perk_vow_feat_Create_0").MatchFromUntil("push.d 0.4", "push.d 0.02").ReplaceBy("push.d 0.6\r\npush.d 0.06").Save();
            // 修改天赋描述文本，反映新的效果和机制
            // [已迁移到运行时覆写]             Msl.LoadAssemblyAsString("gml_GlobalScript_table_skills").MatchFrom("push.s \"vow_feat;Каждый")
            // .ReplaceBy(ModFiles.GetCode("gml_GlobalScript_table_skills_rebalance_vow_feat.asm")).Save();

            #endregion



            #region 4.4 约娜天赋优化 (Yona Talented Optimization)

            // [约娜天赋] 为约娜的天赋添加全新的法术暴击斩杀赋予额外回合的效果
            // 利用原版的 scr_crit_death → is_crit_magic_death 统计链路，
            // 在暴击法术击杀时设置全局标记，由 scr_allturn 检查并授予免费回合
            MslExtensions.QuickInsertBelow("gml_GlobalScript_scr_crit_death",
                "is_crit_magic_death = true",
                @"if (is_crit_magic_death && instance_is(argument0, o_runaway_wizzard))
                    global.got_free_turn += 1;");
            // [免费回合核心] 注入 scr_unitTurnNext 开头 — 调度敌人回合的唯一天然入口
            // 当 got_free_turn > 0 时阻止 alarm[4] 被设为正值，跳过整个敌人回合循环
            // alarm[4] 可在 argument0<=0 时被 global.Upspeed 强制覆写为 1，故不依赖 argument0
            // 仅在 argument0>0 时消费 got_free_turn（-1 为清理，undefined 为未预期调用）
            Msl.LoadGML("gml_GlobalScript_scr_unitTurnNext").MatchFrom("with").InsertAbove(@"
            if (global.got_free_turn > 0) {
                if (argument0 > 0) {
                    global.got_free_turn--;
                }
                with (o_player) {
                    lock_movement = false;
                    alarm[4] = -1;
                    alarm[1] = -60;
                    with (o_skill) { last_activated = false; }
                }
                exit;
            }").Save();
            // 修改天赋描述文本，反映新的效果和机制
            // [已迁移到运行时覆写]             Msl.LoadAssemblyAsString("gml_GlobalScript_table_skills").MatchFrom("push.s \"magical_erudition;Даёт")
            // .ReplaceBy(ModFiles.GetCode("gml_GlobalScript_table_skills_rebalance_magical_erudition.asm")).Save();

            #endregion



            // ========================================================================
            // 区块 5: 技能与战斗平衡 (Skills & Combat Balance)
            // ========================================================================
            // 功能: 调整技能机制和战斗参数，增强玩家的战术选择
            // 范围: 技能范围、伤害、消耗、效果时长等

            #region 5.1 主动技能调整 (Active Skills Adjustment)

            // [掌握主动] 增加技能范围和效果层数
            // 改进: 范围 +1, 层数加倍 | 目的: 提升技能实用性
            MslExtensions.QuickMatch("gml_Object_o_skill_seize_the_initiative_Other_17", "range = 2", "range = 3;");
            MslExtensions.QuickMatch("gml_Object_o_skill_seize_the_initiative_Other_17", "range = 1", "range = 2;");

            // [掌握主动] 增加每次命中时叠加的层数
            // 原值: +1 | 新值: +2 | 持续轮数: 加倍
            MslExtensions.QuickMatch("gml_Object_o_db_ini_lost_Other_13", "duration++", "duration += 2;");
            MslExtensions.QuickMatch("gml_Object_o_db_ini_lost_Other_13", "duration++", "duration += 2;");
            // 修改技能描述文本，反映新的效果和机制
            // [已迁移到运行时覆写]             Msl.LoadAssemblyAsString("gml_GlobalScript_table_skills").MatchFrom("push.s \"Seize_the_Initiative;Даёт")
            // .ReplaceBy(ModFiles.GetCode("gml_GlobalScript_table_skills_rebalance_seize_the_initiative.asm")).Save();

            // [招架] 精准格挡 + 全额反击 + 击杀额外回合
            // [伤害快照] 在 scr_attack 命中判定之前捕获攻击者潜在伤害
            // 必须在 scr_attack 而非 scr_damage 中快照：闪避时 scr_damage 的 argument1 恒为 0
            Msl.LoadGML("gml_GlobalScript_scr_attack").MatchFrom("_isFumbleDodge = false")
            .InsertBelow(@"argument0.__qol_riposte_raw = ((Slashing_Damage + Piercing_Damage + Blunt_Damage + Rending_Damage) * Weapon_Damage / 100) + ((Unholy_Damage + Sacred_Damage + Psionic_Damage + Arcane_Damage + Fire_Damage + Frost_Damage + Caustic_Damage + Poison_Damage + Shock_Damage) * Magic_Power / 100);").Save();
            Msl.LoadGML("gml_Object_o_b_riposte_Create_0").MatchAll().InsertBelow(ModFiles.GetCode("gml_Object_o_b_riposte_Create_0_insert.gml")).Save();
            Msl.LoadGML("gml_Object_o_b_riposte_Other_13").MatchAll().InsertBelow(ModFiles.GetCode("gml_Object_o_b_riposte_Other_13_insert.gml")).Save();
            Msl.LoadGML("gml_Object_o_skill_riposte_Other_17").MatchFrom("}").InsertAbove("ds_map_replace(data, \"CTA_damage\", owner.STR + owner.AGL + owner.PRC - 30);").Save();
            Msl.AddNewEvent("o_b_riposte", ModFiles.GetCode("gml_Object_o_b_riposte_Alarm_0.gml"), EventType.Alarm, 0);
            // [招架方向选择 UI] ASM 表：Riposte → Target Point + Range=1
            Msl.LoadAssemblyAsString("gml_GlobalScript_table_skills_stats")
            .MatchFrom("push.s \"Riposte;o_b_riposte;No Target")
            .ReplaceBy("push.s \"Riposte;o_riposte_dir_mark;Target Point;1;10;18;0;3;0;0;0;normal;AVOID_TILEMARKS;skill;0;;2hsword;0;;weapon;0;0;;;;1;;;\"")
            .Save();
            // 修改技能描述文本，反映新的效果和机制
            // [已迁移到运行时覆写]             Msl.LoadAssemblyAsString("gml_GlobalScript_table_skills").MatchFrom("push.s \"Riposte;Активирует")
            // .ReplaceBy(ModFiles.GetCode("gml_GlobalScript_table_skills_rebalance_riposte.asm")).Save();
            // 方向指示器对象（必须在 Other_10 引用 o_riposte_dir_indicator 之前注册）
            Msl.AddObject("o_riposte_dir_indicator", "s_piercethrough_arrow", "", true, false, true, (CollisionShapeFlags)0);
            Msl.AddNewEvent("o_riposte_dir_indicator", ModFiles.GetCode("gml_Object_o_riposte_dir_indicator_Create_0.gml"), EventType.Create, 0);
            Msl.AddNewEvent("o_riposte_dir_indicator", ModFiles.GetCode("gml_Object_o_riposte_dir_indicator_Step_0.gml"), EventType.Step, 0);
            Msl.AddNewEvent("o_riposte_dir_indicator", ModFiles.GetCode("gml_Object_o_riposte_dir_indicator_Draw_0.gml"), EventType.Draw, 0);
            // 替换 Other_10 瞄准指示器：Riposte 用箭头，其他技能用默认 range 目前恒定为1，后续版本可以考虑根据技能定义动态调整
            Msl.LoadGML("gml_Object_o_skill_Other_10").MatchFromUntil("with (instance_create_depth", "range = other.range").ReplaceBy(@"
            if (skill == ""Riposte"")
            {
                with (instance_create_depth(mouse_x, mouse_y, 0, o_riposte_dir_indicator))
                    range = 1
            }
            else
            {
                with (instance_create_depth(mouse_x, mouse_y, 0, o_skill_tile_indicator))
                    range = other.range
            }").MatchFrom("scr_change_coordinat").ReplaceBy(@"
            var __qol_xx = self.xx;
            var __qol_yy = self.yy;
            scr_change_coordinat(__qol_xx, __qol_yy, id, true);").Save();
            // 方向选择 mark（PreCreate / Create / Alarm_1 / Other_11 / Alarm_0 / Destroy）
            GameObjectUtils.ApplyEvent(Msl.AddObject("o_riposte_dir_mark", "s_piercethrough_arrow", "o_invisible_mark", true, false, true, (CollisionShapeFlags)0), base.ModFiles, (MslEvent[])(object)new MslEvent[6]
            {
                new MslEvent("gml_Object_o_riposte_dir_mark_PreCreate_0.gml", EventType.PreCreate, 0),
                new MslEvent("gml_Object_o_riposte_dir_mark_Create_0.gml", EventType.Create, 0),
                new MslEvent("gml_Object_o_riposte_dir_mark_Alarm_1.gml", EventType.Alarm, 1),
                new MslEvent("gml_Object_o_riposte_dir_mark_Other_11.gml", EventType.Other, 11),
                new MslEvent("gml_Object_o_riposte_dir_mark_Alarm_0.gml", EventType.Alarm, 0),
                new MslEvent("gml_Object_o_riposte_dir_mark_Destroy_0.gml", EventType.Destroy, 0)
            });

            // [放电] 伤害公式重做 + 不消耗回合
            // 新基础伤害: (7 + WIL*0.1 + EP*1) * (100+EP+MP*0.5)/100
            // 最终伤害: 基础伤害 * random_range(1,210)/100, 期望1.05x, 最低1点
            Msl.LoadGML("gml_Object_o_discharge_Other_10").MatchFrom("Shock_Damage").ReplaceBy(@"
            Shock_Damage_Static = (7 + owner.WIL * 0.1 + owner.Electromantic_Power * 0.1) * (100 + owner.Electromantic_Power + owner.Magic_Power * 0.5) / 100
            Shock_Damage = max(1, math_round(Shock_Damage_Static * random_range(1, 210) / 100))").Save();

            // Other_11 可通过两种路径到达: 1) Other_10 的 event_user(1) 调用 2) 独立触发
            // got_free_turn 只写在 Other_11, 避免重复
            Msl.LoadGML("gml_Object_o_discharge_Other_11").MatchFrom("Shock_Damage").ReplaceBy(@"
            {
                Shock_Damage_Static = (7 + owner.WIL * 0.1 + owner.Electromantic_Power * 0.1) * (100 + owner.Electromantic_Power + owner.Magic_Power * 0.5) / 100;
                Shock_Damage = max(1, math_round(Shock_Damage_Static * random_range(1, 210) / 100));
            }
            global.got_free_turn += 1;").Save();

            Msl.SetStringGMLInFile(ModFiles.GetCode("gml_Object_o_skill_discharge_Other_17.gml"), "gml_Object_o_skill_discharge_Other_17");
            // [已迁移到运行时覆写]             Msl.LoadAssemblyAsString("gml_GlobalScript_table_skills").MatchFrom("push.s \"Discharge;Выпускает")
            // .ReplaceBy(ModFiles.GetCode("gml_GlobalScript_table_skills_rebalance_discharge.asm")).Save();

            // [脉冲] 动态AOE范围 + 增强伤害公式
            // AOE范围: 1 + floor((WIL+MP+EP)/50), 上限4
            // 伤害: (10 + WIL*0.05 + EP*0.05) * (100+EP)/100, 随机波动0.01x~2.10x
            // DOT: (2 + WIL*0.01 + EP*0.01) * (100+EP)/100, 无波动
            Msl.LoadGML("gml_Object_o_impulse_birth_Other_10").MatchFrom("with (o_unit)")
            .InsertAbove("var _aoe_range = clamp(2 + floor((owner.WIL * 2 + owner.Magic_Power + owner.Electromantic_Power * 2) / 100), 2, 6);")
            .MatchFrom("scr_tile_distance_min(other.owner, id)")
            .ReplaceBy("if (id != other.owner && scr_tile_distance_min(other.owner, id) >= 1 && scr_tile_distance_min(other.owner, id) <= _aoe_range)").Save();

            Msl.LoadGML("gml_Object_o_impulse_impact_Other_11").MatchFrom("Shock_Damage = math_round(12 *").ReplaceBy(@"
            Shock_Damage_Static = (10.5 + owner.WIL * 0.12 + owner.Electromantic_Power * 0.12) * (100 + owner.Electromantic_Power + owner.Magic_Power * 0.5) / 80
            Shock_Damage = max(1, math_round(Shock_Damage_Static * random_range(20, 220) / 100))").Save();

            Msl.SetStringGMLInFile(ModFiles.GetCode("gml_Object_o_skill_impulse_Other_17.gml"), "gml_Object_o_skill_impulse_Other_17");
            // AOE指示器：临时替换range让o_aoe_range方格跟随动态范围，执行后恢复，不影响施放距离
            Msl.AddNewEvent("o_skill_impulse", ModFiles.GetCode("gml_Object_o_skill_impulse_Other_10.gml"), EventType.Other, 10);

            Msl.LoadGML("gml_Object_o_db_impulse_Alarm_4").MatchFrom("Shock_Damage").ReplaceBy(@"
            Debuff_Damage_Static = (1.8 + owner.WIL * 0.02 + owner.Electromantic_Power * 0.02) * (100 + owner.Electromantic_Power) / 80
            Shock_Damage = math_round(Debuff_Damage_Static * boost_damage)").Save();

            // [已迁移到运行时覆写]             Msl.LoadAssemblyAsString("gml_GlobalScript_table_skills").MatchFrom("push.s \"Impulse;Наносит")
            // .ReplaceBy(ModFiles.GetCode("gml_GlobalScript_table_skills_rebalance_impulse.asm")).Save();


            #endregion

            #region 5.2 范围和控制技能 (Area & Control Skills)

            // [战吼] 增加战吼范围，减少精力消耗与CD，改为稳定触发控制效果，持续12回合，延续激昂持续时间
            // 改变: 范围 12->15, 精力消耗降低, CD减少, 控制效果稳定触发
            Msl.LoadAssemblyAsString("gml_GlobalScript_table_skills_stats")
            .MatchFrom("push.s \"War_Cry;")
            .ReplaceBy("push.s \"War_Cry;o_war_cry_birth;Target Area;15;12;8;0;0;19;19;0;circle;;skill;0;s_warcrycast_;combat;0;;utility;0;0;;;;1;;;\"")
            .Save();
            MslExtensions.QuickMatch("gml_Object_o_war_cry_birth_Other_10", "var _range", "var _range = 15;");
            MslExtensions.QuickMatchFromUntil("gml_Object_o_war_cry_impact_Other_11", "if scr_chance_value", "}", @"
            var _buff = -4;
            
            _buff = scr_effect_create(o_db_confuse, 12, target, target);
            if scr_chance_value(40 + 2 * owner.WIL)
                _buff = scr_effect_create(o_db_daze, 3, target, target);
            
            if _buff
            {
                with (owner)
                {
                    var _rage = scr_instance_exists_in_list(o_b_rage);
                    
                    with (_rage)
                    {
                        if (duration <= 60)
                            duration += 4;
            ");
            // 修改技能描述文本，反映新的效果和机制
            // [已迁移到运行时覆写]             Msl.LoadAssemblyAsString("gml_GlobalScript_table_skills").MatchFrom("push.s \"War_Cry;Издаёт")
            // .ReplaceBy(ModFiles.GetCode("gml_GlobalScript_table_skills_rebalance_war_cry.asm")).Save();

            #endregion

            #region 5.3 被动技能 (Passive Skills)

            // [正中目标] 现在无论任何配装均可触发正中目标效果，增加命中率，减少失手几率，增加暴击率
            // 改进: 命中率 +8, 失手率 -8, 暴击率 +5
            Msl.SetStringGMLInFile(ModFiles.GetCode("gml_Object_o_pass_skill_right_on_target_Other_17.gml"), "gml_Object_o_pass_skill_right_on_target_Other_17");
            MslExtensions.QuickMatchBelow("gml_GlobalScript_scr_skill_right_on_target", "if (argument0 == 1)", 5, @"
            {
            Hit_Chance += 8;
            FMB -= 8;
            CRT += 5;
            }
            ");
            // 修改技能描述文本，反映新的效果和机制
            // [已迁移到运行时覆写]             Msl.LoadAssemblyAsString("gml_GlobalScript_table_skills").MatchFrom("push.s \"right_on_target;Даёт")
            // .ReplaceBy(ModFiles.GetCode("gml_GlobalScript_table_skills_rebalance_right_on_target.asm")).Save();

            // [准备就绪] 增加可叠加层数，增加命中率和伤害吸收率，减少能力消耗
            // 改进: 命中率 +8, 伤害减免 -8%, 能力消耗 -8%
            MslExtensions.QuickMatch("gml_Object_o_pass_skill_preparation_Other_13", "Hit_Chance",
            "scr_temp_effect_update(object_index, owner, \"Hit_Chance\", 8, 5, 3);");
            MslExtensions.QuickMatch("gml_Object_o_pass_skill_preparation_Other_13", "Damage_Received",
            "scr_temp_effect_update(object_index, owner, \"Damage_Received\", -8, 5, 3);");
            MslExtensions.QuickMatch("gml_Object_o_pass_skill_preparation_Other_13", "Abilities_Energy_Cost",
            "scr_temp_effect_update(object_index, owner, \"Abilities_Energy_Cost\", -8, 5, 3);");
            // 修改技能描述文本，反映新的效果和机制
            // [已迁移到运行时覆写]             Msl.LoadAssemblyAsString("gml_GlobalScript_table_skills").MatchFrom("push.s \"preparation;Пропуск")
            // .ReplaceBy(ModFiles.GetCode("gml_GlobalScript_table_skills_rebalance_preparation.asm")).Save();

            // [自修自缮] 装备耐久损耗速度变为40%，放宽装备属性加成阈值判定
            MslExtensions.QuickMatch("gml_Object_o_pass_skill_self_repair_Other_17", "ds_map_replace(data", @"
            var _durability_resistance = 0.4 + (owner.Vitality * 0.02);
            ds_map_replace(data, ""Duration_Resistance"", _durability_resistance);
            ds_map_replace(text_map, ""Duration_Resistance"", clamp(_durability_resistance * 100, 60, 100));");
            MslExtensions.QuickMatch("gml_Object_o_pass_skill_self_repair_Other_17", "if (_duration >= ", "if (_duration >= (_maxDuration * 0.7))");
            // 修改技能描述文本，反映新的效果和机制
            // [已迁移到运行时覆写]             Msl.LoadAssemblyAsString("gml_GlobalScript_table_skills").MatchFrom("push.s \"self_repair;Даё")
            // .ReplaceBy(ModFiles.GetCode("gml_GlobalScript_table_skills_rebalance_self_repair.asm")).Save();

            // [远近兼攻] 获得的瞄准状态增加至3回合；添加弹药被射出时有50%概率不消耗直接复填
            MslExtensions.QuickMatch("gml_Object_o_pass_skill_thrift_Other_13", "scr_effect_create(o_b_taking_aim", "scr_effect_create(o_b_taking_aim, 3);");
            // 修改技能描述文本，反映新的效果和机制
            // [已迁移到运行时覆写]             Msl.LoadAssemblyAsString("gml_GlobalScript_table_skills").MatchFrom("push.s \"thrift;Уби")
            // .ReplaceBy(ModFiles.GetCode("gml_GlobalScript_table_skills_rebalance_thrift.asm")).Save();

            // [冲刺训练] 所有突进技能距离改为增加2
            MslExtensions.QuickMatch("gml_Object_o_pass_skill_sprint_training_Other_18", "Special_Bonus_Range", "Special_Bonus_Range += 2;");
            // 修改技能描述文本，反映新的效果和机制
            // [已迁移到运行时覆写]             Msl.LoadAssemblyAsString("gml_GlobalScript_table_skills").MatchFrom("push.s \"sprint_training;Даёт")
            // .ReplaceBy(ModFiles.GetCode("gml_GlobalScript_table_skills_rebalance_sprint_training.asm")).Save();


            #endregion

            #region 5.4 斩杀与终结 (Finishing Skills)

            // [最后一击] 增加突进距离，减少精力消耗和CD，增加斩杀阈值
            // 改进: 距离 +3, 精力消耗 -4, CD -2, 斩杀阈值提升
            Msl.LoadAssemblyAsString("gml_GlobalScript_table_skills_stats")
                .MatchFrom("push.s \"Finisher;")
                .ReplaceBy("push.s \"Finisher;o_finisher;Target Object;6;10;18;0;0;0;0;1;normal;;skill;0;s_finishercast_;combat;0;;utility;0;0;1;;1;;;;\"")
                .Save();
            MslExtensions.QuickMatchBelow("gml_Object_o_skill_finisher_Other_17", "if instance_exists", 3, @"
            {
                ds_map_replace(text_map, ""Max_HP_Limit"", 2 * (owner.STR + owner.AGL + owner.PRC));
                ds_map_replace(text_map, ""HP_Limit"",  0.5 * (owner.STR +  owner.AGL + owner.PRC));
            ");
            MslExtensions.QuickMatchBelow("gml_Object_o_finisher_Alarm_0", "else", 3, @"
            {
                var _hp_limit = 0.5 * (owner.STR + owner.AGL + owner.PRC);
                var _hp_max_limit = 2 * (owner.STR + owner.AGL + owner.PRC);
            ");
            // 修改技能描述文本，反映新的效果和机制
            // Msl.LoadAssemblyAsString("gml_GlobalScript_table_skills").MatchFrom("push.s \"Finisher;Совершает")
            // .ReplaceBy(ModFiles.GetCode("gml_GlobalScript_table_skills_rebalance_finisher.asm")).Save();

            // [搏命] 修改为满血发挥最大效果，略微削弱最大效果数值
            // 目的: 鼓励玩家更主动地使用高风险技能
            Msl.SetStringGMLInFile(ModFiles.GetCode("gml_Object_o_pass_skill_last_effort_Other_17.gml"), "gml_Object_o_pass_skill_last_effort_Other_17");
            // 修改技能描述文本，反映新的效果和机制
            // [已迁移到运行时覆写]             Msl.LoadAssemblyAsString("gml_GlobalScript_table_skills").MatchFrom("push.s \"last_effort;Последнее")
            // .ReplaceBy(ModFiles.GetCode("gml_GlobalScript_table_skills_rename_last_effort.asm")).Save();
            // [已迁移到运行时覆写]             Msl.LoadAssemblyAsString("gml_GlobalScript_table_skills").MatchFrom("push.s \"last_effort;Даёт")
            // .ReplaceBy(ModFiles.GetCode("gml_GlobalScript_table_skills_rebalance_last_effort.asm")).Save();

            #endregion

            #region 5.5 支援技能 (Support & Utility Skills)

            // [叫喊] 移除口渴副作用
            // 改进: 移除负面效果，提升技能吸引力
            MslExtensions.QuickMatch("gml_Object_o_shout_Other_12", "scr_thirsty_change", @"
            scr_hunger_change(-2);
            scr_intoxication_change(-1);
            scr_immunity_change(4);
            scr_fatigue_change(-1);
            scr_atr_set(""Morale"", 100);
            scr_atr_set(""Sanity"", 100);
            ");

            #endregion

            #region 5.6 属性与防御 (Attributes & Defense)

            // [免疫属性] 提升免疫上限至 1000
            // 目的: 支持更高的免疫等级建设，增加属性成长空间
            MslExtensions.QuickMatchFromUntil("gml_GlobalScript_scr_immunity_change", "if (immunity > 125)", "Immunity = clamp", @"
                if (immunity > 1000)
                    scr_atr_set(""Immunity"", 1000);
                else if (immunity < 0)
                    scr_atr_set(""Immunity"", 0);
            }
            
            Immunity = clamp(scr_atr(""Immunity""), 0, 1000);
            ");

            #endregion

            #region 5.7 武器与装备 (Weapons & Equipment)


            //远程攻击重做，现在允许双持远程兵器，左右手的弩轮询装填；其余远程兵器每回合齐射一次
            Msl.AddFunction(ModFiles.GetCode("_scr_do_shoot.gml"), "gml_GlobalScript__scr_do_shoot");
            Msl.AddFunction(ModFiles.GetCode("_scr_extract_crossbow_bolt.gml"), "gml_GlobalScript__scr_extract_crossbow_bolt");
            Msl.AddFunction(ModFiles.GetCode("_scr_fire_bow_once.gml"), "gml_GlobalScript__scr_fire_bow_once");
            Msl.AddFunction(ModFiles.GetCode("_scr_get_weapon_hand_types.gml"), "gml_GlobalScript__scr_get_weapon_hand_types");
            Msl.LoadGML("gml_Object_o_enemy_Mouse_4").MatchFrom("var _is_shoot").InsertBelow("var _hands = scr_get_weapon_hand_types();")
            .MatchFrom("_is_shoot = true").InsertBelow(@"
            var _rh = _hands[0];
            var _lh = _hands[1];
            var _has_melee = (_rh == ""melee"" || _lh == ""melee"");

            if (_has_melee)
            {
                // 注意：scr_global_turn() 已由 scr_throw 内部推进，此处不再调用
                scr_two_hands_attack(_attack_target);
            }")
            .MatchFrom("var _is_amo_exist")
            .ReplaceBy("var _hands = scr_get_weapon_hand_types();\r\nvar _is_amo_exist = (_hands[0] != \"melee\"&& _hands[0] != \"\") || (_hands[1] != \"melee\"&& _hands[1] != \"\") || scr_crossbow_is_armed();").Save();
            Msl.SetStringGMLInFile(ModFiles.GetCode("gml_GlobalScript_scr_is_ammo_exist.gml"), "gml_GlobalScript_scr_is_ammo_exist");
            Msl.SetStringGMLInFile(ModFiles.GetCode("gml_GlobalScript_scr_throw.gml"), "gml_GlobalScript_scr_throw");
            Msl.SetStringGMLInFile(ModFiles.GetCode("gml_GlobalScript_scr_crossbow_insert_bolt.gml"), "gml_GlobalScript_scr_crossbow_insert_bolt");
            Msl.SetStringGMLInFile(ModFiles.GetCode("gml_GlobalScript_scr_crossbow_is_armed.gml"), "gml_GlobalScript_scr_crossbow_is_armed");
            Msl.SetStringGMLInFile(ModFiles.GetCode("gml_GlobalScript_scr_crossbow_reject_bolt.gml"), "gml_GlobalScript_scr_crossbow_reject_bolt");
            // 修改远程技能的使用条件，允许双持远程武器时正常使用
            Msl.LoadGML("gml_Object_o_skill_ico_Other_25").MatchFrom("_ammo_count = 2").InsertBelow(@"
            if ((skill == ""Distracting_Shot"" || skill == ""Taking_Aim""))
                _ammo_count = 99;   
            ").Save();
            // 弩箭未装填时也允许使用转移注意
            MslExtensions.QuickInsertBelow("gml_Object_o_distracting_shot_Alarm_0", "scr_skill_call_passive", "scr_crossbow_insert_bolt(false, false, true);");
            // 为 o_arrow 注入 Alarm_1 事件，用于双持远程时延迟第二支箭的起飞（不能用 Alarm_0，父对象已有）
            Msl.AddNewEvent("o_arrow", ModFiles.GetCode("gml_Object_o_arrow_Alarm_1.gml"), EventType.Alarm, 1);
            //瞄准改为持续6回合
            Msl.LoadAssemblyAsString("gml_GlobalScript_table_skills_stats")
            .MatchFrom("push.s \"Taking_Aim;")
            .ReplaceBy("push.s \"Taking_Aim;o_b_taking_aim;No Target;0;1;4;0;6;0;0;0;normal;;skill;0;;ranged;0;;weapon;0;0;;;;1;;;\"").Save();
            //修改瞄准的技能描述
            // [已迁移到运行时覆写]             Msl.LoadAssemblyAsString("gml_GlobalScript_table_skills").MatchFrom("push.s \"Taking_Aim;Акт")
            // .ReplaceBy(ModFiles.GetCode("gml_GlobalScript_table_skills_rebalance_taking_aim.asm")).Save();
            //瞄准最大持续时间改为24回合
            MslExtensions.QuickMatch("gml_Object_o_b_taking_aim_Create_0", "max_duration", "max_duration = 24;");
            // [手持兵器] 移除双手兵器的持握限制
            // 目的: 允许单手使用双手武器，增加配装灵活性
            Msl.SetStringGMLInFile(ModFiles.GetCode("gml_GlobalScript_scr_inv_weapon_get_hands.gml"), "gml_GlobalScript_scr_inv_weapon_get_hands");
            //单独改动铲子为双持，保持一致性
            MslExtensions.QuickMatch("gml_Object_o_inv_shovel_Create_0", "hands = 2", "hands = 1;");

            // [双持平衡] 移除双持时的重度主手/副手惩罚，并优化冷却缩减、失手率等收益
            // 改进: 主手效率 -25% -> 0%, 副手效率 -20%, 冷却缩减 +0, 失手率 5%
            MslExtensions.QuickMatchFromUntil("gml_Object_o_db_dual_wielding_Create_0",
            "ds_map_add(data, \"Mainhand_Efficiency\", -25)",
            "ds_map_add(data, \"Miscast_Chance\", 10)",
            @"ds_map_add(data, ""Mainhand_Efficiency"", 0)
            ds_map_add(data, ""Offhand_Efficiency"", -20)
            ds_map_add(data, ""Cooldown_Reduction"", 0)
            ds_map_add(data, ""FMB"", 5)
            ds_map_add(data, ""Miscast_Chance"", 5);");

            // [暴击范围] 增加暴击范围的触发条件，只要装备单手近战武器即可触发暴击范围效果
            MslExtensions.QuickMatch("gml_GlobalScript_scr_attack_result_crit_aoe", "if ((!_isShootingWeapon) &&",
            "if (!_isShootingWeapon && _slot > 0 && _slot.equipped)");

            // [格挡损耗] 降低格挡时的装备耐久消耗倍率 (0.02 -> 0.01)
            // 目的: 鼓励玩家使用防守战术
            MslExtensions.QuickMatch("gml_GlobalScript_scr_duration_decrese",
                "\"block\"",
                "scr_duration_decrese(_tmpBlockReduction * 0.01, _blockItem, argument0, \"block\");");

            #endregion

            #region 5.8 修补与收集 (Crafting & Gathering)

            // [剥皮强化] 拥有"猎人大师"技能时，剥皮成功率提升至 100%，并增加皮革耐久
            // 目的: 经济系统更多选择，鼓励专门化培养
            MslExtensions.QuickMatch("gml_Object_o_flaying_Other_10", "if ((_resorcefullness",
            "if ((_resorcefullness && scr_chance_value(Pelt_Durability)) || (_is_hunting_secret && scr_chance_value(100)) || (_is_hunters_grit && scr_chance_value(scr_atr(\"Hunter's Grit\"))))");
            MslExtensions.QuickMatch("gml_Object_o_flaying_Other_10", "Pelt_Durability +=", "Pelt_Durability += 100");

            // [升级系统] 已在自动寻路处修改。修改玩家步进事件：解锁等级上限 (100)、替换阶段性经验曲线、将每级 AP 奖励提升至 3，SP 提升至 2
            // 目的: 延长游戏终局内容，增加角色养成深度

            #endregion


            #region 5.9 Alt键显示详细技能信息与说明 (Alt Key Detailed Skill Info)

            Msl.SetStringGMLInFile(base.ModFiles.GetCode("gml_Object_o_hoverSkill_Other_20.gml"), "gml_Object_o_hoverSkill_Other_20");
            Msl.SetStringGMLInFile(base.ModFiles.GetCode("gml_Object_o_hoverRender_Step_2.gml"), "gml_Object_o_hoverRender_Step_2");


            #endregion


            // ========================================================================
            // 区块 6: 魔法系统平衡 (Magic System Balance)
            // ========================================================================
            // 功能: 优化各派系魔法的平衡性，移除职业限制效果
            // 范围: 魔法威力、奇迹威力等

            #region 6.1 派系魔法修正 (Faction Magic Correction)

            // [魔法威力] 移除学习特定派系魔法后对其他派系威力的负面修正
            // 目的: 允许混合魔法流派的角色构建，提升自定义性
            string[] magicBuffs = { "gml_Object_o_b_electro_Other_15", "gml_Object_o_b_pyro_Other_15", "gml_Object_o_b_geo_Other_15", "gml_Object_o_b_arcanistics_Other_15" };
            foreach (var magic in magicBuffs)
            {
                Msl.LoadGML(magic).MatchAll()
                    .ReplaceBy(@"
                    event_inherited();
                    ds_map_replace(data, ""Magic_Power"", stage);
                    ds_map_replace(data, ""Geomantic_Power"", 1.5 * stage);
                    ds_map_replace(data, ""Pyromantic_Power"", 1.5 * stage);
                    ds_map_replace(data, ""Electromantic_Power"", 1.5 * stage);
                    ds_map_replace(data, ""Astromantic_Power"", 1.5 * stage);
                    ds_map_replace(data, ""Venomantic_Power"", 1.5 * stage);
                    ds_map_replace(data, ""Cryomantic_Power"", 1.5 * stage);
                    ds_map_replace(data, ""Arcanistic_Power"", 1.5 * stage);
                    ds_map_replace(data, ""Psimantic_Power"", 1.5 * stage);
                    ds_map_replace(data, ""Chronomantic_Power"", 1.5 * stage);
                    ds_map_replace(data, ""Miracle_Power"", 4 * stage);
                    ").Save();
            }

            #endregion


            // ========================================================================
            // 区块 7: 消耗品与工具强化 (Consumables & Tools Enhancement)
            // ========================================================================
            // 功能: 提升消耗品的可用性和持续时间，改善游戏流畅性
            // 范围: 医疗用品、卷轴、保鲜、工具等

            #region 7.1 工具与维修 (Tools & Repair)

            // [撬棍] 提升耐久至 100，并将每次使用的损耗值降低至 20
            // 原值: 耐久 50, 消耗 40 | 新值: 耐久 100, 消耗 20 | 目的: 延长工具使用时间
            Msl.LoadGML("gml_Object_o_inv_tinker_Create_0")
                .MatchFrom("duration =").ReplaceBy("duration = 100")
                .MatchFrom("duration_change").ReplaceBy("duration_change = 20")
                .Save();

            // [维修工具] 强化：将可用次数从 5 次提升至 15 次
            // 效果: 玩家可以更多次地维修装备
            MslExtensions.QuickMatch("gml_Object_o_inv_repkit_Create_0", "charge = 5", "charge = 15;");

            #endregion

            #region 7.2 医疗与应急物品 (Medical & Emergency Items)

            // [药膏] 强化：将初始次数从 3 次提升至 8 次
            MslExtensions.QuickMatch("gml_Object_o_inv_salve_Create_0", "charge = 3", "charge = 8;");

            // [绷带] 强化：将初始次数从 2 次提升至 8 次
            MslExtensions.QuickMatch("gml_Object_o_inv_bandage_Create_0", "charge = 2", "charge = 8;");

            // [夹板] 强化：将初始次数从 1 次提升至 3 次，添加max_charge属性
            MslExtensions.QuickMatch("gml_Object_o_inv_splint_Create_0", "charge = 1", @"
            charge = 3;
            max_charge = charge;
            ");

            // [灵药] 强化：初始次数从 1 次提升至 8 次
            MslExtensions.QuickMatch("gml_Object_o_inv_aqua_vitae_Create_0", "charge = 1", @"
            charge = 8;
            max_charge = charge;
            ");

            #endregion

            #region 7.3 容器与储存 (Containers & Storage)

            // [水囊] 强化：初始可用次数提升至 20 次
            MslExtensions.QuickMatch("gml_Object_o_inv_wineskin_Create_0", "charge = 6", "charge = 20;");

            // [涤魂圣杯] 强化：可用次数提升至 20 次
            MslExtensions.QuickMatch("gml_Object_o_inv_cleansing_goblet_water_Create_0", "charge = 1", "charge = 20;");

            #endregion

            #region 7.4 卷轴与消耗品系统 (Scrolls & Consumable System)

            // [卷轴系统] 批量重构：使辨识、附魔、褪魔卷轴均支持 8 次使用，并开启次数显示
            // 目的: 增加卷轴的实用性，提升游戏后期的可行策略
            MslExtensions.QuickMatch("gml_Object_o_inv_scroll_parent_Create_0",
            "identified = true",
            @"
            identified = true;
            charge = 8;
            max_charge = 8;
            draw_charges = true;");

            #endregion

            #region 7.5 食物保鲜 (Food Preservation)

            // [保鲜增强] 提升加盐保鲜效果：将 Fresh 值乘数从原版提升至 1000 倍
            // 原值: 2x | 新值: 1000x | 目的: 降低食物管理压力
            MslExtensions.QuickMatch("gml_GlobalScript_scr_consum_char_add",
                "ds_map_set(data, \"Fresh\"",
                "ds_map_set(data, \"Fresh\", (_value * 1000))");
            MslExtensions.QuickMatch("gml_Object_o_hoverConsum_Other_20",
            "var _middleTextCharacter",
            "var _middleTextCharacter = ds_map_find_value_ext(global.consum_mid, idName + \"_hilda\", \"N/A\");"); //骨器文本内容描述修正
            MslExtensions.QuickMatch("gml_Object_o_hoverConsum_Other_20",
                "_fresh *=",
                "_fresh *= 1000");

            // [大篷车保鲜] 如果马车开启了香料升级，使马车仓库内的食物腐败速度大幅降低 (0.005x)
            // 目的: 鼓励投资大篷车升级，建立长期资源积累系统
            MslExtensions.QuickMatch("gml_GlobalScript_scr_consum_food_change",
                "argument0 *= 0.5",
                "argument0 *= 0.001");

            MslExtensions.QuickMatchFromUntil("gml_Object_o_hoverConsum_Other_20", "var _freshValue", "other.freshColor", @"
            if (_fresh > 24)
            {
                // 原版逻辑：显示天数
                var _freshDays  = ceil(_fresh / 24) - 1;
                other.freshLeft  = ds_list_find_value(global.other_hover, 52) + scr_actionsLogGetSpace();
                other.freshRight = string(_freshDays) + scr_actionsLogGetSpace() + scr_pluralFormChoose(_freshDays, ds_list_find_value(global.other_hover, 53));
                other.freshColor = 16777215;
            }
            else if (_fresh >= 2)
            {
                // 改动：剩余 ≤ 24 小时时切换为小时显示
                var _freshHours  = ceil(_fresh) - 1;
                other.freshLeft  = ds_list_find_value(global.other_hover, 52) + scr_actionsLogGetSpace();
                other.freshRight = string(_freshHours) + scr_actionsLogGetSpace() + scr_pluralFormChoose(_freshHours, ds_list_find_value(global.other_hover, 74));
                other.freshColor = make_colour_rgb(158, 27, 49);
            }
            else
            {
                // 不足一小时的食物显示为[不足一小时]，并且颜色变为鲜红色
                other.freshLeft  = ds_list_find_value(global.other_hover, 52) + scr_actionsLogGetSpace();
                other.freshRight = ds_list_find_value(global.other_hover, 84);
                other.freshColor = make_colour_rgb(202, 31, 55);
            }
            ");

            #endregion


            // ========================================================================
            // 区块 8: 经济系统优化 (Economy System)
            // ========================================================================
            // 功能: 调整商人定价和大篷车系统，提升经济平衡
            // 范围: NPC 定价、商人库存、自持金币等

            #region 8.1 商人定价系统 (Merchant Pricing System)

            // [商人定价] 替换 NPC Create 中的价格参数块
            // 目的: 统一调整所有商人的定价逻辑，改善玩家经济压力
            Msl.LoadGML("gml_Object_o_NPC_Create_0").MatchBelow("Buying_Tier", 61).ReplaceBy(base.ModFiles, "gml_Object_o_NPC_Create_0_Price.gml").Save();
            // 所有商人的基础金币增加 1500 金
            MslExtensions.QuickMatch("gml_GlobalScript_scr_npc_gold_init", "Gold_Amount_Base", "Gold_Amount_Base = [argument0 + 1500, argument1 + 1500];");

            #endregion

            #region 8.2 大篷车系统与传送 (Caravan System & Teleportation)

            // [大篷车随从] 修改大篷车随从备货和自持金币
            // 目的: 提升大篷车商人的经济吸引力
            MslExtensions.QuickMatchAll("gml_Object_o_npc_darrel_caravan_Create_0", base.ModFiles, "gml_Object_o_npc_darrel_caravan_Create_0.gml");

            MslExtensions.QuickMatch("gml_Object_o_skill_repair_item_master_Other_20", "if (_material_spec[i]", "if (_material_spec[i] == \"all\" || _material_spec[i] == _material)");

            // [马车夫] 修改马车夫备货和自持金币
            MslExtensions.QuickMatchAll("gml_Object_o_npc_tott_Create_0", base.ModFiles, "gml_Object_o_npc_tott_Create_0.gml");

            // [传送系统] 增加传送功能，允许从任意地点移动到马车点和地牢门口
            Msl.AddMenu("传送", (UIComponent[])(object)new UIComponent[3]
            {
                new UIComponent("标记图案", "tp_mark_type", (UIComponentType)0, new string[12]
                {
                    "Flag", "Grave", "Sword", "Crown", "Bow", "Diamond", "Arrow", "Food", "Tower", "Cross",
                    "Chest", "Skull"
                }, false),
                new UIComponent("允许传送到马车点", "tp_flag_msl", (UIComponentType)1, 0, false),
                new UIComponent("允许传送到地牢门口", "tp_dungeon_msl", (UIComponentType)1, 0, false)
            });
            GameObjectUtils.ApplyEvent(Msl.AddObject("o_globalmapTP", "s_gui_button_skipturn", "o_button", true, false, true, (CollisionShapeFlags)0), base.ModFiles, (MslEvent[])(object)new MslEvent[2]
            {
                new MslEvent("gml_Object_o_globalmapTP_Create_0.gml", EventType.Create, 0u),
                new MslEvent("gml_Object_o_globalmapTP_Other_10.gml", EventType.Other, 10u)
            });
            Msl.LoadGML("gml_Object_o_globalmap_Other_10").MatchFrom("event_perform(ev_step, ev_step_begin)").InsertAbove(@"
            if (fullscreen)
            {
                tp_to_flag_button = scr_guiCreateInteractive(id, o_globalmapTP, _depth - 13)
                with (tp_to_flag_button)
                {
                    scr_guiLayoutOffsetUpdate(id, (other.spaceSize + 12), (_visibleAreaHeight - sprite_height - other.spaceSize - 20))
                }
            }").Save();
            Msl.LoadGML("gml_Object_o_globalmapMarkUserContext_Other_25").MatchFrom("var _mark = scr_globalmapMarkCreate").InsertAbove(@"
            if (variable_global_exists(""tp_mark_type"") && is_string(global.tp_mark_type) && global.tp_mark_type != ""0"")
            {
                _mark_type = global.tp_mark_type
            }

            _target_sprite = asset_get_index(""s_glmap_mark_user_"" + _mark_type)
            if (other.markSpriteIndex == _target_sprite)
            {
                with (o_globalmapMarkUser)
                {
                    if (sprite_index == _target_sprite)
                    {
                        instance_destroy()
                    }
                }
            }").Save();


            #endregion


            // ========================================================================
            // 区块 9: 背包与仓库 UI (Inventory & Stash UI)
            // ========================================================================
            // 功能: 扩展背包容量，优化 UI 尺寸参数
            // 范围: 背包、仓库、交易界面、UI 贴图等

            #region 9.1 仓库扩容 (Stash Expansion) && 交易界面尺寸调整 (UI Scaling)

            // [交易界面扩容] 调整交易界面尺寸参数
            // 目的: 增加可视范围，提升交易便利性
            String[] o_trade_inventory_Create_0 = { "scrollbarDOWN = scr_guiCreateInteractive(id, o_scrollbarDOWN, (depth - 5), (adaptiveOffsetX + 274), (adaptiveOffsetY + 278))", "image_yscale = 191", "image_yscale = 218", "areaHeight = 215", "trackHeight = 189", "itemsContainerHeight = 215", "cellsRowHeight = 8" };
            String[] o_trade_inventory_Replace_0 = { "scrollbarDOWN = scr_guiCreateInteractive(id, o_scrollbarDOWN, (depth - 5), (adaptiveOffsetX + 274), (adaptiveOffsetY + 332))", "image_yscale = 245", "image_yscale = 272", "areaHeight = 269", "trackHeight = 243", "itemsContainerHeight = 269", "cellsRowHeight = 40" };

            for (int i = 0; i < o_trade_inventory_Create_0.Length; i++)
            {
                MslExtensions.QuickMatch("gml_Object_o_trade_inventory_Create_0", o_trade_inventory_Create_0[i], o_trade_inventory_Replace_0[i]);
            }

            // [仓库界面扩容] 调整仓库界面尺寸参数
            String[] o_stash_inventory_Create_0 = { "scrollbarDOWN = scr_guiCreateInteractive(id, o_scrollbarDOWN, (depth - 5), (adaptiveOffsetX + 274), (adaptiveOffsetY + 276))", "image_yscale = 218", "image_yscale = 245", "areaHeight = 242", "trackHeight = 216", "itemsContainerHeight = 242", "cellsRowHeight = 20" };
            String[] o_stash_inventory_Replace_0 = { "scrollbarDOWN = scr_guiCreateInteractive(id, o_scrollbarDOWN, (depth - 5), (adaptiveOffsetX + 274), (adaptiveOffsetY + 330))", "image_yscale = 272", "image_yscale = 299", "areaHeight = 296", "trackHeight = 270", "itemsContainerHeight = 296", "cellsRowHeight = 200" };

            for (int i = 0; i < o_stash_inventory_Create_0.Length; i++)
            {
                MslExtensions.QuickMatch("gml_Object_o_stash_inventory_Create_0", o_stash_inventory_Create_0[i], o_stash_inventory_Replace_0[i]);
            }

            #endregion

            #region 9.2 背包扩容与图形优化 (Inventory Expansion & Graphics)

            // [背包扩容] 根据分辨率自适应容器容量
            // 540p (1920x1080): 10列7行 / 720p (2560x1440): 12列11行
            MslExtensions.QuickMatchFromUntil("gml_Object_o_inventory_Create_0",
            "itemsContainer = scr_guiCreateContainer(id, o_guiContainerEmpty, depth, adaptiveOffsetX, (adaptiveOffsetY + 151))",
            "scr_inventory_container_cells_add(id, cellsContainer, 5)", @"
            var _inv_cols = (global.cameraHeight >= 720) ? 12 : 10
            var _inv_rows = (global.cameraHeight >= 720) ? 11 : 7
            var _offsetX = (global.cameraHeight >= 720) ? (47 - adaptiveOffsetX) : adaptiveOffsetX
            itemsContainer = scr_guiCreateContainer(id, o_guiContainerEmpty, depth, _offsetX, (adaptiveOffsetY + 151))
            cellsContainer = scr_inventory_container_create(itemsContainer, _inv_cols)
            scr_inventory_container_cells_add(id, cellsContainer, _inv_rows)");

            // [精灵注册] 确保所有分辨率的精灵贴图被 MSL 导入游戏
            // 540p (1920x1080) 和 720p (2560x1440) 两套精灵各 4 个
            Msl.GetSprite("s_inventory_720_12x11");
            Msl.GetSprite("s_inventory_540_rusty10x7");
            Msl.GetSprite("s_trade_inventory_720_10x7");
            Msl.GetSprite("s_trade_inventory_540_rusty10x7");
            Msl.GetSprite("s_stash_inventory_720_10x7");
            Msl.GetSprite("s_stash_inventory_540_rusty10x7");
            Msl.GetSprite("s_stash_trade_inventory_720_10x7");
            Msl.GetSprite("s_stash_trade_540_rusty10x7");

            // [UI 贴图] 运行时根据 global.cameraHeight 自动选择对应分辨率的精灵
            // 540p (cameraHeight=540): _540_rusty 系列 | 720p (cameraHeight=720): _720 系列
            Msl.LoadGML("gml_Object_o_inventory_Create_0").MatchFrom("is_start_equipment = false").InsertBelow(@"
            if (global.cameraHeight >= 720)
                sprite_index = s_inventory_720_12x11
            else
                sprite_index = s_inventory_540_rusty10x7").Save();

            Msl.LoadGML("gml_Object_o_trade_inventory_Create_0").MatchFrom("event_inherited()").InsertBelow(@"
            if (global.cameraHeight >= 720)
                sprite_index = s_trade_inventory_720_10x7
            else
                sprite_index = s_trade_inventory_540_rusty10x7").Save();

            Msl.LoadGML("gml_Object_o_stash_inventory_Create_0").MatchFrom("event_inherited()").InsertBelow(@"
            if (global.cameraHeight >= 720)
                sprite_index = s_stash_inventory_720_10x7
            else
                sprite_index = s_stash_inventory_540_rusty10x7").Save();

            Msl.LoadGML("gml_Object_o_stash_inventory_right_Create_0").MatchFrom("closeLeftMenu = true").InsertBelow(@"
            if (global.cameraHeight >= 720)
                sprite_index = s_stash_trade_inventory_720_10x7
            else
                sprite_index = s_stash_trade_540_rusty10x7").Save();

            #endregion


            // ========================================================================
            // 区块 10: 堆叠系统优化 (Stacking System)
            // ========================================================================
            // 功能: 提升各类物品的堆叠上限，改善背包管理
            // 范围: 金币、弹药、消耗品等

            #region 10.1 货币堆叠 (Currency Stacking)

            // [金币] 提升堆叠上限：100 -> 1000
            // 目的: 更方便地积累和转移货币
            MslExtensions.QuickMatch("gml_Object_o_inv_gold_parent_Create_0", "stack_limit = 100", "stack_limit = 1000;");
            Msl.LoadGML("gml_Object_o_inv_gold_parent_Create_0")
               .MatchBelow("event_inherited()", 1).ReplaceBy("stack_limit = 1000;")
               .Save();
            // [钱袋] 提升堆叠上限：2000 -> 20000
            MslExtensions.QuickMatch("gml_Object_o_inv_moneybag_Create_0", "stack_limit = 2000", "stack_limit = 20000;");

            // [古钱币] 提升堆叠上限：50 -> 1000
            MslExtensions.QuickMatch("gml_Object_o_inv_old_coin_Create_0", "stack_limit = 50", "stack_limit = 1000;");

            #endregion

            #region 10.2 弹药与消耗品堆叠 (Ammo & Consumable Stacking)

            // [弹药] 提升箭矢/弩箭堆叠上限至 100，并重算贴图索引
            // 原值: 20 | 新值: 100 | 改进: 减少背包占用空间
            Msl.LoadGML("gml_Object_o_inv_ammunition_parent_Create_0")
                .MatchFrom("stack = 20").ReplaceBy("stack = 100;")
                .MatchFrom("stack_limit = 20").ReplaceBy("stack_limit = stack;")
                .MatchFrom("i_index =").ReplaceBy("i_index = 4 + ((stack * (i_number - 4)) / 100);")
                .Save();

            // [投石索] 提升投石索弹药堆叠上限：10 -> 100
            MslExtensions.QuickMatch("gml_Object_o_inv_sling_ammo_parent_Create_0", "stack_limit = 10", "stack_limit = 100;");

            #endregion

            #region 10.3 堆叠逻辑核心修正 (Stacking Logic Core)

            // [堆叠逻辑] 修正合并、拆分、查找空位的脚本，支持高额堆叠
            // 目的: 确保所有堆叠逻辑都能支持新的上限
            MslExtensions.QuickMatchAll("gml_GlobalScript_scr_inventory_stack", ModFiles, "gml_GlobalScript_scr_inventory_stack.gml");
            MslExtensions.QuickMatchAll("gml_GlobalScript_scr_inv_find_free_cell", ModFiles, "gml_GlobalScript_scr_inv_find_free_cell.gml");
            MslExtensions.QuickMatchAll("gml_GlobalScript_scr_item_stack_build", ModFiles, "gml_GlobalScript_scr_item_stack_build.gml");

            #endregion


            // ========================================================================
            // 区块 11: 属性上限与战斗公式 (Attribute Limits & Combat Formulas)
            // ========================================================================
            // 功能: 提升属性上限，优化战斗计算公式
            // 范围: 属性 clamp 上限、属性按钮解锁等

            #region 11.1 全局属性计算 (Global Attribute Calculation)

            // [属性计算] 替换全局属性计算脚本，大幅提升各项数值的 clamp 上限
            // 目的: 支持更高等级的属性成长，延长游戏重玩价值
            MslExtensions.QuickMatchAll("gml_GlobalScript_scr_atr_calc", ModFiles, "gml_GlobalScript_scr_atr_calc.gml");
            MslExtensions.QuickMatchAll("gml_GlobalScript_scr_atr_calc_combat", ModFiles, "gml_GlobalScript_scr_atr_calc_combat.gml");

            MslExtensions.QuickMatchFromUntil("gml_Object_o_skill_Other_17", "if (maxKD < (_maxCD", "maxKD = ", ""); //解除技能冷却上限对属性的限制

            #endregion

            #region 11.2 属性提升 UI (Attribute Enhancement UI)

            // [UI 交互] 解锁属性按钮点击限制：允许在 AP 充足时将单项属性提升至 100
            // 改进: 属性上限从原版提升至 100，提升个性化空间
            MslExtensions.QuickMatch("gml_Object_o_attribute_button_Step_2", "if (scr_atr", "if (scr_atr(\"AP\") && scr_atr(attributeKey) < 100)");
            MslExtensions.QuickMatch("gml_Object_o_character_attribute_Step_2", "if (scr_atr", "if (scr_atr(\"AP\") && scr_atr(attributeKey) < 100)");

            #endregion


            // ========================================================================
            // 区块 12: 其他优化 (Other Optimizations)
            // ========================================================================
            // 功能: 其他未归类的系统调整
            // 范围: 职业被动、待实装功能等

            #region 12.1 职业被动强化 (Class Passive Enhancement)

            // TODO: [阿娜被动] 增强阿娜的被动对于正面情绪状态的效果增益
            // 说明: 计划中的功能，待后续补充

            #endregion


            #region 12.2 待实装功能 (To Be Implemented)

            #endregion

        }

        private static void ExportTable(string table)
        {
            DirectoryInfo directoryInfo = new DirectoryInfo("ModSources/QoLEnhanced/tmp");
            if (!directoryInfo.Exists)
            {
                directoryInfo.Create();
            }
            List<string> table2 = ModLoader.GetTable(table);
            if (table2 != null)
            {
                File.WriteAllLines(Path.Join(directoryInfo.FullName, Path.DirectorySeparatorChar.ToString(), table + ".tsv"), table2.Select((string x) => string.Join('\t', x.Split(';'))));
            }
        }

        // ========================================================================
        // MSL 扩展工具类 (MSL Extension Utility Class)
        // ========================================================================
        // 功能: 提供 MSL 操作的便利方法集，简化重复代码
        // 设计: 按功能分类，便于复用和维护

        public static class MslExtensions
        {
            // ════════════════════════════════════════════════════════════════════
            // 工具类区块 A: 基础替换操作 (Basic Replacement Operations)
            // ════════════════════════════════════════════════════════════════════

            // 快速匹配并替换 GML 脚本中的字符串
            public static void QuickMatch(string gmlName, string original, string replacement)
            {
                Msl.LoadGML(gmlName).MatchFrom(original).ReplaceBy(replacement).Peek().Save();
            }

            // 快速在指定位置下方进行替换
            public static void QuickMatchBelow(string gmlName, string original, int linesAfter, string replacement)
            {
                Msl.LoadGML(gmlName).MatchBelow(original, linesAfter).ReplaceBy(replacement).Save();
            }

            // 快速从范围到范围的替换操作
            public static void QuickMatchFromUntil(string gmlName, string originalFrom, string originalUntil, string replacement)
            {
                Msl.LoadGML(gmlName).MatchFromUntil(originalFrom, originalUntil).ReplaceBy(replacement).Save();
            }

            // ════════════════════════════════════════════════════════════════════
            // 工具类区块 B: 文件导入替换操作 (File Import Operations)
            // ════════════════════════════════════════════════════════════════════

            // 从外部文件导入内容进行替换
            public static void QuickMatchFiles(string gmlName, string original, ModFile ModFiles, string replacement)
            {
                Msl.LoadGML(gmlName).MatchFrom(original).ReplaceBy(ModFiles, replacement).Save();
            }

            // 全量替换为外部文件内容
            public static void QuickMatchAll(string gmlName, ModFile ModFiles, string replacement)
            {
                Msl.LoadGML(gmlName).MatchAll().ReplaceBy(ModFiles, replacement).Save();
            }

            // 从范围内替换为外部文件内容
            public static void QuickMatchFromUntilFiles(string gmlName, string originalFrom, string originalUntil, ModFile ModFiles, string replacement)
            {
                Msl.LoadGML(gmlName).MatchFromUntil(originalFrom, originalUntil).ReplaceBy(ModFiles, replacement).Save();
            }

            // ════════════════════════════════════════════════════════════════════
            // 工具类区块 C: 插入操作 (Insertion Operations)
            // ════════════════════════════════════════════════════════════════════

            // 在指定位置下方插入文件内容
            public static void QuickInsertBelowFiles(string gmlName, string original, ModFile modFiles, string replacement)
            {
                Msl.LoadGML(gmlName).Peek().MatchFrom(original).InsertBelow(modFiles, replacement).Save();
            }

            // 在指定位置下方插入文本内容
            public static void QuickInsertBelow(string gmlName, string original, string insertion)
            {
                Msl.LoadGML(gmlName).MatchFrom(original).InsertBelow(insertion).Save();
            }

            // ════════════════════════════════════════════════════════════════════
            // 工具类区块 D: 高级操作 (Advanced Operations)
            // ════════════════════════════════════════════════════════════════════

            // 在指定行数后使用文件替换
            public static void QuickMatchBelowFiles(string gmlName, string original, int linesAfter, ModFile ModFiles, string replacement)
            {
                Msl.LoadGML(gmlName).MatchBelow(original, linesAfter).ReplaceBy(ModFiles, replacement).Save();
            }

            // 在程序集级别进行行数后替换
            public static void QuickAssemblyMatchBelowFiles(string gmlName, string original, int linesAfter, ModFile ModFiles, string replacement)
            {
                Msl.LoadAssemblyAsString(gmlName).MatchBelow(original, linesAfter).ReplaceBy(ModFiles, replacement).Save();
            }

            public static IEnumerable<string> InsertCode(IEnumerable<string> input, string target, string codeToInsert)
            {
                foreach (string item in input)
                {
                    if (item.Contains(target))
                    {
                        yield return codeToInsert;
                    }
                    yield return item;
                }
            }

            public static void QuickInject(string fileName, string target, string codeAsString)
            {
                ProcessAndSave(fileName, lines => lines.InjectIf(l => l.Contains(target), codeAsString));
            }

            public static void QuickReplace(string fileName, string target, string codeAsString)
            {
                ProcessAndSave(fileName, lines => lines.ReplaceIf(l => l.Contains(target), codeAsString));
            }

            public static void QuickReplaceRange(string fileName, string target, int linesToRemove, string newCode)
            {
                ProcessAndSave(fileName, lines => lines.ReplaceRangeIf(target, linesToRemove, newCode));
            }

            // 提取出的公共文件流处理方法
            private static void ProcessAndSave(string fileName, Func<IEnumerable<string>, IEnumerable<string>> action)
            {
                // 1. 获取原始代码流
                var originalLines = Msl.LoadAssemblyAsString(fileName).ienumerable;

                // 2. 执行动作
                var resultLines = action(originalLines);

                // 3. 【核心修复】深度扁平化清理
                // 先把所有内容拼成一个大字符串，再按行切开，确保每一行都能被 Trim
                string totalContent = string.Join("\n", resultLines);

                var finalLines = totalContent
                    .Split(new[] { "\r\n", "\n" }, StringSplitOptions.None) // 切开
                    .Select(line => line.Trim())                            // 每一行都 Trim
                    .Where(line => !string.IsNullOrWhiteSpace(line))        // 去掉空行
                    .ToList();

                // 3. 写回文件注意：由于 IEnumerable 是惰性的，调用 ToList 确保在保存前逻辑已经执行完成
                Msl.SetAssemblyString(string.Join("\n", finalLines), fileName);
            }
        }
    }


    public static class GmlInjectionExtensions
    {


        public static IEnumerable<string> InjectIf(this IEnumerable<string> input, Func<string, bool> matchCondition, string codeToInsert)
        {

            Action<string> safeShow = (msg) =>
                {

                    // 在已加载的程序集中寻找 WPF 库
                    var ass = AppDomain.CurrentDomain.GetAssemblies()
                                .FirstOrDefault(a => a.GetName().Name == "PresentationFramework");
                    var type = ass?.GetType("System.Windows.MessageBox");
                    type?.GetMethod("Show", new[] { typeof(string) })?.Invoke(null, new[] { msg });

                };

            bool isMatched = false;
            foreach (var line in input)
            {
                if (matchCondition(line) && !isMatched)
                {
                    isMatched = true;
                    yield return codeToInsert;
                }
                yield return line;
            }

            if (!isMatched) { safeShow($"InjectIf: 未找到匹配项!"); }
        }

        public static IEnumerable<string> ReplaceIf(this IEnumerable<string> input, Func<string, bool> matchCondition, string codeToReplace)
        {

            Action<string> safeShow = (msg) =>
                {

                    // 在已加载的程序集中寻找 WPF 库
                    var ass = AppDomain.CurrentDomain.GetAssemblies()
                                .FirstOrDefault(a => a.GetName().Name == "PresentationFramework");
                    var type = ass?.GetType("System.Windows.MessageBox");
                    type?.GetMethod("Show", new[] { typeof(string) })?.Invoke(null, new[] { msg });

                };

            bool isMatched = false;
            foreach (var line in input)
            {
                if (matchCondition(line) && !isMatched)
                {
                    isMatched = true;
                    yield return codeToReplace; // 只返回新代码，不返回 line
                }
                else
                {
                    yield return line;
                }

            }

            if (!isMatched) { safeShow($"ReplaceIf: 未找到匹配项!"); }
        }

        public static IEnumerable<string> ReplaceRangeIf(this IEnumerable<string> input, string target, int linesToRemove, string newCode)
        {

            Action<string> safeShow = (msg) =>
                {

                    // 在已加载的程序集中寻找 WPF 库
                    var ass = AppDomain.CurrentDomain.GetAssemblies()
                                .FirstOrDefault(a => a.GetName().Name == "PresentationFramework");
                    var type = ass?.GetType("System.Windows.MessageBox");
                    type?.GetMethod("Show", new[] { typeof(string) })?.Invoke(null, new[] { msg });

                };

            int skipCounter = 0;
            bool isMatched = false;
            foreach (var line in input)
            {
                // 如果计数器还在运作，说明这行是要被“吃掉”的，直接跳过
                if (skipCounter > 0)
                {
                    skipCounter--;
                    continue;
                }

                // 如果匹配到目标
                if (line.Contains(target) && !isMatched)
                {
                    isMatched = true;
                    yield return newCode;              // 返回你的新代码
                    skipCounter = linesToRemove - 1;   // 设定接下来要跳过（删除）几行
                }
                else
                {
                    yield return line;                 // 正常返回原行
                }
            }

            if (!isMatched) { safeShow($"ReplaceRangeIf: 未找到匹配项: {target}"); }
        }
    }

    public class Localization
    {
        public static void ActionLogsPatching()
        {
            List<string> list = new List<string>();
            string value = "planTravelTo";
            string text = "~w~$~/~ plans to go to ~lg~$~/~.";
            string value2 = "~w~$~/~计划前往~lg~$~/~。";
            list.Add(string.Concat($"{value};{text};{text};{value2};", string.Concat(Enumerable.Repeat(text + ";", 9))));
            value = "planTravelToUnknown";
            text = "~w~$~/~ plans to travel to an unknown area located at map coordinates ~lg~($, $)~/~.";
            value2 = "~w~$~/~计划前往一个位于地图坐标~lg~（$，$）~/~的未知区域。";
            list.Add(string.Concat($"{value};{text};{text};{value2};", string.Concat(Enumerable.Repeat(text + ";", 9))));
            value = "whereToGo";
            text = "~w~$~/~ doesn't know where to go.";
            value2 = "~w~$~/~不知道要往哪去。";
            list.Add(string.Concat($"{value};{text};{text};{value2};", string.Concat(Enumerable.Repeat(text + ";", 9))));
            value = "whereToGoMultiMarkers";
            text = "~w~$~/~ doesn't know ~lg~which~/~ of the ~r~$~/~ marked locations to travel to?";
            value2 = "~w~$~/~不知道应该前往这~r~$~/~个标记地点的~lg~哪一个~/~？";
            list.Add(string.Concat($"{value};{text};{text};{value2};", string.Concat(Enumerable.Repeat(text + ";", 9))));
            value = "doorInaccessible";
            text = "~w~$~/~ noticed that the far side was blocked by an obstacle and needed to change position to re-plan the journey.";
            value2 = "~w~$~/~发现远处被障碍物挡住了，需要换个位置重新规划行程。";
            list.Add(string.Concat($"{value};{text};{text};{value2};", string.Concat(Enumerable.Repeat(text + ";", 9))));
            value = "doorNotExist";
            text = "~w~$~/~ couldn't find any exit or roads.";
            value2 = "~w~$~/~找不到任何出口或道路。";
            list.Add(string.Concat($"{value};{text};{text};{value2};", string.Concat(Enumerable.Repeat(text + ";", 9))));
            string item = string.Concat(";", string.Concat(Enumerable.Repeat("text_end;", 12)));
            List<string> table = ModLoader.GetTable("gml_GlobalScript_table_log");
            table.InsertRange(table.IndexOf(item), list);
            ModLoader.SetTable(table, "gml_GlobalScript_table_log");
        }
    }

}
