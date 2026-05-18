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
                var attributesFiles = new[] {
                    "gml_GlobalScript_table_attributes_rebalance_strength.asm",
                    "gml_GlobalScript_table_attributes_rebalance_agility.asm",
                    "gml_GlobalScript_table_attributes_rebalance_perception.asm",
                    "gml_GlobalScript_table_attributes_rebalance_vitality.asm",
                    "gml_GlobalScript_table_attributes_rebalance_willpower.asm",
                };
                List<string> attributesTable = ModLoader.GetTable("gml_GlobalScript_table_attributes");

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
                ModLoader.SetTable(attributesTable, "gml_GlobalScript_table_attributes");
            }

            // ========================================================================
            // 区块 0: 资产注册 (Asset Registration)
            // ========================================================================
            // ⚠️ AddFunction / AddObject / AddNewEvent / AddMenu / GetSprite 必须在
            //    所有 Replace/Insert 操作之前执行，确保被引用的资产已存在于游戏数据中。

            #region 0.1 函数注册 (Function Registration)

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
            Msl.AddFunction(ModFiles.GetCode("_scr_get_weapon_hand_types.gml"), "gml_GlobalScript__scr_get_weapon_hand_types");
            Msl.AddFunction(ModFiles.GetCode("_scr_residual_charge_on_spell_hit.gml"), "gml_GlobalScript__scr_residual_charge_on_spell_hit");

            #endregion

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

            #endregion

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

            #endregion

            #region 0.4 精灵注册 (Sprite Registration)

            Msl.GetSprite("s_inventory_720_12x11");
            Msl.GetSprite("s_inventory_540_rusty10x7");
            Msl.GetSprite("s_trade_inventory_720_10x7");
            Msl.GetSprite("s_trade_inventory_540_rusty10x7");
            Msl.GetSprite("s_stash_inventory_720_10x7");
            Msl.GetSprite("s_stash_inventory_540_rusty10x7");
            Msl.GetSprite("s_stash_trade_inventory_720_10x7");
            Msl.GetSprite("s_stash_trade_540_rusty10x7");

            #endregion

            // ========================================================================
            // 功能区块调度 (Feature Block Dispatch)
            // ========================================================================

            PatchBlock_01_GlobalConfig();
            PatchBlock_02_Enchantment();
            PatchBlock_03_TimeAndHotkeys();
            PatchBlock_04_CharacterMechanics();
            PatchBlock_05_SkillsAndCombat();
            PatchBlock_07_Consumables();
            PatchBlock_08_Economy();
            PatchBlock_09_InventoryUI();
            PatchBlock_10_Stacking();
            PatchBlock_11_AttributeCaps();
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
