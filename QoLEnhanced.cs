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

    public partial class QoLEnhanced : Mod
    {
        private readonly Stopwatch _patchTimer = new();
        private long _lastTimingMs;
        private readonly string _timingLogPath = Path.Combine("logs", "qol_patch_timing.log");

        // ========================================================================
        // 模组元数据 (Mod Metadata)
        // ========================================================================

        public override string Author => "Dovahkiin";

        public override string Name => "品质优化";

        public override string Description => "游戏内容大修，详见Nexusmods更新说明";

        public override string Version => "1.0.0.0";

        public override string TargetVersion => "0.9.4.14";

        private void ResetPatchTiming()
        {
            _lastTimingMs = 0;
            _patchTimer.Restart();
        }

        private void LogPatchTiming(string label)
        {
            try
            {
                Directory.CreateDirectory(Path.GetDirectoryName(_timingLogPath) ?? ".");
                long elapsedMs = _patchTimer.ElapsedMilliseconds;
                long deltaMs = elapsedMs - _lastTimingMs;
                _lastTimingMs = elapsedMs;
                File.AppendAllText(_timingLogPath,
                    $"[{DateTime.Now:yyyy-MM-dd HH:mm:ss.fff}] {label}: +{deltaMs} ms, total {elapsedMs} ms{Environment.NewLine}");
            }
            catch
            {
                // 计时日志不能影响实际补丁流程。
            }
        }

        private void RunTimed(string label, Action action)
        {
            action();
            LogPatchTiming(label);
        }

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

            ResetPatchTiming();
            LogPatchTiming("PatchMod start");

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
            // 编译时表格替换 (GetTable/SetTable 直接修改 CSV 源数据)
            // .asm 文件存完整 CSV 行 (push.s "key;lang0;...;lang11;")
            // ========================================================================

            // --- table_skills: 描述文本 + 名称覆写 ---
            {
                var skillDescFiles = new[] {
                    "gml_GlobalScript_table_skills_rebalance_chain_lightning.asm",
                    "gml_GlobalScript_table_skills_rebalance_discharge.asm",
                    "gml_GlobalScript_table_skills_rebalance_impulse.asm",
                    "gml_GlobalScript_table_skills_rebalance_last_effort.asm",
                    "gml_GlobalScript_table_skills_rebalance_lightning_reflexes.asm",
                    "gml_GlobalScript_table_skills_rebalance_magical_erudition.asm",
                    "gml_GlobalScript_table_skills_rebalance_preparation.asm",
                    "gml_GlobalScript_table_skills_rebalance_residual_charge.asm",
                    "gml_GlobalScript_table_skills_rebalance_right_on_target.asm",
                    "gml_GlobalScript_table_skills_rebalance_riposte.asm",
                    "gml_GlobalScript_table_skills_rebalance_seize_the_initiative.asm",
                    "gml_GlobalScript_table_skills_rebalance_self_repair.asm",
                    "gml_GlobalScript_table_skills_rebalance_sprint_training.asm",
                    "gml_GlobalScript_table_skills_rebalance_taking_aim.asm",
                    "gml_GlobalScript_table_skills_rebalance_tempest.asm",
                    "gml_GlobalScript_table_skills_rebalance_thrift.asm",
                    "gml_GlobalScript_table_skills_rebalance_vow_feat.asm",
                    "gml_GlobalScript_table_skills_rebalance_war_cry.asm",
                };
                var skillNameFiles = new[] {
                    "gml_GlobalScript_table_skills_rename_last_effort.asm",
                };

                List<string> skillTable = ModLoader.GetTable("gml_GlobalScript_table_skills");
                foreach (var asm in skillDescFiles.Concat(skillNameFiles))
                {
                    var csv = ModFiles.GetCode(asm).Trim();
                    var prefix = csv.Substring(0, Math.Min(30, csv.Length));
                    for (int i = 0; i < skillTable.Count; i++)
                    {
                        if (skillTable[i].StartsWith(prefix))
                        {
                            skillTable[i] = csv;
                            break;
                        }
                    }
                }
                ModLoader.SetTable(skillTable, "gml_GlobalScript_table_skills");
            }

            // --- table_text: prefix 新增 + rarity 新增 ---
            {
                List<string> textTable = ModLoader.GetTable("gml_GlobalScript_table_text");
                int prefixEndIdx = textTable.FindIndex(r => r.StartsWith(";prefix_end"));
                foreach (var line in ModFiles.GetCode("gml_GlobalScript_table_text_prefix.asm").Split('\n'))
                {
                    var t = line.Trim();
                    if (string.IsNullOrEmpty(t)) continue;
                    if (prefixEndIdx >= 0)
                        textTable.Insert(prefixEndIdx++, t);
                }
                int rarityEndIdx = textTable.FindIndex(r => r.StartsWith(";rarity_end"));
                foreach (var line in ModFiles.GetCode("gml_GlobalScript_table_text_rarity.asm").Split('\n'))
                {
                    var t = line.Trim();
                    if (string.IsNullOrEmpty(t)) continue;
                    if (rarityEndIdx >= 0)
                        textTable.Insert(rarityEndIdx++, t);
                }
                ModLoader.SetTable(textTable, "gml_GlobalScript_table_text");
            }

            // --- table_items: hilda_trinket 描述覆写 ---
            {
                var itemsFiles = new[] {
                    "gml_GlobalScript_table_items_hilda_trinket.asm",
                };

                List<string> itemsTable = ModLoader.GetTable("gml_GlobalScript_table_items");
                foreach (var asm in itemsFiles)
                {
                    var csv = ModFiles.GetCode(asm).Trim();
                    var prefix = csv.Substring(0, Math.Min(30, csv.Length));
                    for (int i = 0; i < itemsTable.Count; i++)
                    {
                        if (itemsTable[i].StartsWith(prefix))
                        {
                            itemsTable[i] = csv;
                            break;
                        }
                    }
                }
                ModLoader.SetTable(itemsTable, "gml_GlobalScript_table_items");
            }

            // --- table_attributes: 五维属性（STR、AGL、PRC、Vitality、WIL） 描述覆写 ---
            {
                List<string> attributesTable = ModLoader.GetTable("gml_GlobalScript_table_attributes");
                var attributesFiles = new[] {
                    "gml_GlobalScript_table_attributes_rebalance_strength.asm",
                    "gml_GlobalScript_table_attributes_rebalance_agility.asm",
                    "gml_GlobalScript_table_attributes_rebalance_perception.asm",
                    "gml_GlobalScript_table_attributes_rebalance_vitality.asm",
                    "gml_GlobalScript_table_attributes_rebalance_willpower.asm",
                };

                foreach (var asm in attributesFiles)
                {
                    var csv = ModFiles.GetCode(asm).Trim();
                    var prefix = csv.Substring(0, Math.Min(30, csv.Length));
                    for (int i = 0; i < attributesTable.Count; i++)
                    {
                        if (attributesTable[i].StartsWith(prefix))
                        {
                            attributesTable[i] = csv;
                            break;
                        }
                    }
                }

                void InsertAttributeRowsAfter(string sectionKey, string afterKey, string codeFile)
                {
                    // 先限定 table_attributes 的子表段，再按属性 key 定位，避免同名 key 在不同子表中互相干扰。
                    int sectionStart = attributesTable.FindIndex(r => r.StartsWith($";{sectionKey};"));
                    if (sectionStart < 0) return;

                    int sectionEnd = attributesTable.FindIndex(sectionStart + 1, r =>
                        r.StartsWith(";attribute_") && !r.StartsWith($";{sectionKey};"));
                    if (sectionEnd < 0)
                        sectionEnd = attributesTable.Count;

                    int insertIndex = attributesTable.FindIndex(sectionStart + 1, sectionEnd - sectionStart - 1,
                        r => r.StartsWith($"{afterKey};"));
                    if (insertIndex < 0) return;

                    foreach (var line in ModFiles.GetCode(codeFile).Split('\n'))
                    {
                        var t = line.Trim();
                        if (string.IsNullOrEmpty(t)) continue;
                        attributesTable.Insert(++insertIndex, t);
                    }
                }

                InsertAttributeRowsAfter("attribute_text", "EVS", "gml_GlobalScript_table_attributes_add_chain_turn.asm");
                InsertAttributeRowsAfter("attribute_desc", "EVS", "gml_GlobalScript_table_attributes_addinfo_chain_turn.asm");

                ModLoader.SetTable(attributesTable, "gml_GlobalScript_table_attributes");
            }

            // --- table_skills_stats: 技能基础参数覆写 ---
            {
                List<string> skillsStatsTable = ModLoader.GetTable("gml_GlobalScript_table_skills_stats");
                var skillsStatsFiles = new[]
                {
                    "gml_GlobalScript_table_skills_stats_riposte.asm",
                    "gml_GlobalScript_table_skills_stats_war_cry.asm",
                    "gml_GlobalScript_table_skills_stats_finisher.asm",
                    "gml_GlobalScript_table_skills_stats_taking_aim.asm",
                };

                foreach (var asm in skillsStatsFiles)
                {
                    var csv = ModFiles.GetCode(asm).Trim();
                    var prefix = csv.Substring(0, Math.Min(10, csv.Length));
                    for (int i = 0; i < skillsStatsTable.Count; i++)
                    {
                        if (skillsStatsTable[i].StartsWith(prefix))
                        {
                            skillsStatsTable[i] = csv;
                            break;
                        }
                    }
                }

                ModLoader.SetTable(skillsStatsTable, "gml_GlobalScript_table_skills_stats");
            }
            LogPatchTiming("Table replacements");

            // ========================================================================
            // 区块 0: 资产注册 (Asset Registration)
            // ========================================================================
            // ⚠️ AddFunction / AddObject / AddNewEvent / AddMenu / GetSprite 必须在
            //    所有 Replace/Insert 操作之前执行，确保被引用的资产已存在于游戏数据中。

            #region 0.1 函数注册 (Function Registration)

            // 调用实例内部函数变量，兼容 method 与普通 script。
            Msl.AddFunction(ModFiles.GetCode("_scr_call_method.gml"), "gml_GlobalScript__scr_call_method");
            // 敌人属性缩放
            Msl.AddFunction(ModFiles.GetCode("_scr_scale_enemy_csv_by_level.gml"), "gml_GlobalScript__scr_scale_enemy_csv_by_level");
            // 武器前缀初始化
            Msl.AddFunction(ModFiles.GetCode("_scr_init_weapon_prefixes.gml"), "gml_GlobalScript__scr_init_weapon_prefixes");
            // 自动寻路系统
            Msl.AddFunction(base.ModFiles.GetCode("_scr_redeactivate_instances.gml"), "gml_Script__scr_redeactivate_instances");
            Msl.AddFunction(base.ModFiles.GetCode("_scr_stop_auto_move.gml"), "gml_Script__scr_stop_auto_move");
            Msl.AddFunction(base.ModFiles.GetCode("_scr_move_player_to.gml"), "gml_Script__scr_move_player_to");
            Msl.AddFunction(base.ModFiles.GetCode("_scr_calculate_closest_point.gml"), "gml_Script__scr_calculate_closest_point");
            Msl.AddFunction(base.ModFiles.GetCode("_scr_find_nearest_tile_transition.gml"), "gml_Script__scr_find_nearest_tile_transition");
            Msl.AddFunction(base.ModFiles.GetCode("_scr_find_exit_door.gml"), "gml_Script__scr_find_exit_door");
            Msl.AddFunction(base.ModFiles.GetCode("_scr_auto_move_to_transition.gml"), "gml_Script__scr_auto_move_to_transition");
            // 远程攻击重做
            Msl.AddFunction(ModFiles.GetCode("_scr_do_shoot.gml"), "gml_GlobalScript__scr_do_shoot");
            Msl.AddFunction(ModFiles.GetCode("_scr_extract_crossbow_bolt.gml"), "gml_GlobalScript__scr_extract_crossbow_bolt");
            Msl.AddFunction(ModFiles.GetCode("_scr_fire_bow_once.gml"), "gml_GlobalScript__scr_fire_bow_once");
            Msl.AddFunction(ModFiles.GetCode("_scr_count_available_bolts.gml"), "gml_GlobalScript__scr_count_available_bolts");
            Msl.AddFunction(ModFiles.GetCode("_scr_get_weapon_hand_types.gml"), "gml_GlobalScript__scr_get_weapon_hand_types");
            Msl.AddFunction(ModFiles.GetCode("_scr_residual_charge_on_spell_hit.gml"), "gml_GlobalScript__scr_residual_charge_on_spell_hit");
            Msl.AddFunction(ModFiles.GetCode("_scr_dghub_emit_player_damage.gml"), "gml_GlobalScript__scr_dghub_emit_player_damage");
            Msl.AddFunction(ModFiles.GetCode("_scr_qol_container_bonus_value.gml"), "gml_GlobalScript__scr_qol_container_bonus_value");
            Msl.AddFunction(ModFiles.GetCode("_scr_qol_container_bonus_is_bone.gml"), "gml_GlobalScript__scr_qol_container_bonus_is_bone");
            Msl.AddFunction(ModFiles.GetCode("_scr_qol_container_has_quest_item.gml"), "gml_GlobalScript__scr_qol_container_has_quest_item");
            Msl.AddFunction(ModFiles.GetCode("_scr_qol_container_bonus.gml"), "gml_GlobalScript__scr_qol_container_bonus");
            Msl.AddFunction(ModFiles.GetCode("_scr_qol_ore_bonus_gem.gml"), "gml_GlobalScript__scr_qol_ore_bonus_gem");

            #endregion
            LogPatchTiming("Function registration");

            #region 0.2 对象与事件注册 (Object & Event Registration)

            // 招架系统
            Msl.AddNewEvent("o_b_riposte", ModFiles.GetCode("gml_Object_o_b_riposte_Alarm_0.gml"), EventType.Alarm, 0);
            Msl.AddObject("o_riposte_dir_indicator", "s_piercethrough_arrow", "", true, false, true, (CollisionShapeFlags)0);
            Msl.AddNewEvent("o_riposte_dir_indicator", ModFiles.GetCode("gml_Object_o_riposte_dir_indicator_Create_0.gml"), EventType.Create, 0);
            Msl.AddNewEvent("o_riposte_dir_indicator", ModFiles.GetCode("gml_Object_o_riposte_dir_indicator_Step_0.gml"), EventType.Step, 0);
            Msl.AddNewEvent("o_riposte_dir_indicator", ModFiles.GetCode("gml_Object_o_riposte_dir_indicator_Draw_0.gml"), EventType.Draw, 0);
            GameObjectUtils.ApplyEvent(Msl.AddObject("o_riposte_dir_mark", "s_piercethrough_arrow", "o_invisible_mark", true, false, true, (CollisionShapeFlags)0), base.ModFiles, (MslEvent[])(object)new MslEvent[6]
            {
                new MslEvent("gml_Object_o_riposte_dir_mark_PreCreate_0.gml", EventType.PreCreate, 0),
                new MslEvent("gml_Object_o_riposte_dir_mark_Create_0.gml", EventType.Create, 0),
                new MslEvent("gml_Object_o_riposte_dir_mark_Alarm_1.gml", EventType.Alarm, 1),
                new MslEvent("gml_Object_o_riposte_dir_mark_Other_11.gml", EventType.Other, 11),
                new MslEvent("gml_Object_o_riposte_dir_mark_Alarm_0.gml", EventType.Alarm, 0),
                new MslEvent("gml_Object_o_riposte_dir_mark_Destroy_0.gml", EventType.Destroy, 0)
            });
            // 脉冲 AOE 指示器
            Msl.AddNewEvent("o_skill_impulse", ModFiles.GetCode("gml_Object_o_skill_impulse_Other_10.gml"), EventType.Other, 10);
            // 箭矢延迟起飞
            Msl.AddNewEvent("o_arrow", ModFiles.GetCode("gml_Object_o_arrow_Alarm_1.gml"), EventType.Alarm, 1);
            // 传送系统
            GameObjectUtils.ApplyEvent(Msl.AddObject("o_globalmapTP", "s_gui_button_skipturn", "o_button", true, false, true, (CollisionShapeFlags)0), base.ModFiles, (MslEvent[])(object)new MslEvent[2]
            {
                new MslEvent("gml_Object_o_globalmapTP_Create_0.gml", EventType.Create, 0u),
                new MslEvent("gml_Object_o_globalmapTP_Other_10.gml", EventType.Other, 10u)
            });
            GameObjectUtils.ApplyEvent(Msl.AddObject("o_enemy_healthbar", "", "", true, false, true, (CollisionShapeFlags)0), base.ModFiles, (MslEvent[])(object)new MslEvent[5]
            {
                new MslEvent("gml_Object_o_enemy_healthbar_Create_0.gml", EventType.Create, 0),
                new MslEvent("gml_Object_o_enemy_healthbar_Destroy_0.gml", EventType.Destroy, 0),
                new MslEvent("gml_Object_o_enemy_healthbar_Draw_0.gml", EventType.Draw, 0),
                new MslEvent("gml_Object_o_enemy_healthbar_Step_0.gml", EventType.Step, 0),
                new MslEvent("gml_Object_o_enemy_healthbar_Step_2.gml", EventType.Step, 2)
            });

            #endregion
            LogPatchTiming("Object and event registration");

            #region 0.3 菜单注册 (Menu Registration)

            Msl.AddMenu("自动寻路", (UIComponent[])(object)new UIComponent[2]
            {
                    new UIComponent("地图标记", "map_mark_type", 0, new string[12]
                    {
                        "Flag", "Grave", "Sword", "Crown", "Bow", "Diamond", "Arrow", "Food", "Tower", "Cross",
                        "Chest", "Skull"
                    }),
                    new UIComponent("如果有多个选定的标记，前往最近的那个点", "go_to_nearest_mark", (UIComponentType)1, 0)
            });
            Msl.AddMenu("传送", (UIComponent[])(object)new UIComponent[4]
            {
                new UIComponent("标记图案", "tp_mark_type", (UIComponentType)0, new string[12]
                {
                    "Flag", "Grave", "Sword", "Crown", "Bow", "Diamond", "Arrow", "Food", "Tower", "Cross",
                    "Chest", "Skull"
                }, false),
                new UIComponent("允许传送到马车点", "tp_flag_msl", (UIComponentType)1, 0, false),
                new UIComponent("允许传送到地牢门口", "tp_dungeon_msl", (UIComponentType)1, 0, false),
                new UIComponent("允许传送到大篷车扎营处", "tp_caravan_msl", (UIComponentType)1, 0, false)
            });
            Msl.AddMenu("敌人生命条", (UIComponent[])(object)new UIComponent[8]
            {
                new UIComponent("显示生命条", "enemyhealthbars_enabled", UIComponentType.CheckBox, 1, false),
                new UIComponent("生命条颜色", "enemyhealthbars_color", UIComponentType.ComboBox, new string[2] { "绿色", "红色" }, false),
                new UIComponent("透明度", "enemyhealthbars_alpha", UIComponentType.Slider, (0, 100), 75, false),
                new UIComponent("水平定位", "enemyhealthbars_offset_x", UIComponentType.Slider, (-15, 15), 0, false),
                new UIComponent("垂直定位", "enemyhealthbars_offset_y", UIComponentType.Slider, (-15, 40), -3, false),
                new UIComponent("高度", "enemyhealthbars_bar_height", UIComponentType.Slider, (1, 8), 2, false),
                new UIComponent("宽度", "enemyhealthbars_bar_width", UIComponentType.Slider, (8, 64), 23, false),
                new UIComponent("边框宽度", "enemyhealthbars_border_width", UIComponentType.Slider, (0, 5), 1, false)
            });

            #endregion
            LogPatchTiming("Menu registration");

            #region 0.4 精灵注册 (Sprite Registration)

            Msl.GetSprite("s_inventory_720_12x11");
            Msl.GetSprite("s_inventory_540_rusty10x7");
            Msl.GetSprite("s_trade_inventory_720_10x7");
            Msl.GetSprite("s_trade_inventory_540_rusty10x7");
            Msl.GetSprite("s_stash_inventory_720_10x7");
            Msl.GetSprite("s_stash_inventory_540_rusty10x7");
            Msl.GetSprite("s_stash_trade_inventory_720_10x7");
            Msl.GetSprite("s_stash_trade_540_rusty10x7");
            var fullBar = Msl.GetSprite("full_bar");
            fullBar.OriginX = 0;
            fullBar.OriginY = 0;
            var fullBarRounded = Msl.GetSprite("full_bar_rounded");
            fullBarRounded.OriginX = 0;
            fullBarRounded.OriginY = 0;
            var fullBarBorderRounded = Msl.GetSprite("full_bar_w_border_rounded");
            fullBarBorderRounded.OriginX = 0;
            fullBarBorderRounded.OriginY = 0;

            #endregion
            LogPatchTiming("Sprite registration");

            // 敌人生命条实例生成注入。
            Msl.LoadGML("gml_Object_o_enemy_Create_0")
                .MatchAll()
                .InsertBelow(@"
if (global.enemyhealthbars_enabled == 1)
{
    if (!variable_instance_exists(id, ""__qol_ehb_initialized"") || !__qol_ehb_initialized)
    {
        var _healthbar = instance_create_depth(x, y, (depth - 1), o_enemy_healthbar)
        _healthbar.target = id
        __qol_ehb_initialized = true
    }
}")
                .Save();

            // ========================================================================
            // 功能区块调度 (Feature Block Dispatch)
            // ========================================================================

            RunTimed("Block 01 GlobalConfig", PatchBlock_01_GlobalConfig);
            RunTimed("Block 02 Enchantment", PatchBlock_02_Enchantment);
            RunTimed("Block 03 TimeAndHotkeys", PatchBlock_03_TimeAndHotkeys);
            RunTimed("Block 04 CharacterMechanics", PatchBlock_04_CharacterMechanics);
            RunTimed("Block 05 SkillsAndCombat", PatchBlock_05_SkillsAndCombat);
            RunTimed("Block 07 Consumables", PatchBlock_07_Consumables);
            RunTimed("Block 08 Economy", PatchBlock_08_Economy);
            RunTimed("Block 09 InventoryUI", PatchBlock_09_InventoryUI);
            RunTimed("Block 10 Stacking", PatchBlock_10_Stacking);
            RunTimed("Block 11 AttributeCaps", PatchBlock_11_AttributeCaps);
            LogPatchTiming("PatchMod complete");
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
    }
}
