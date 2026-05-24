using ModShardLauncher;
using ModShardLauncher.Mods;
using UndertaleModLib.Models;

namespace QoLEnhanced
{
    public partial class QoLEnhanced : Mod
    {
        private void PatchBlock_04_CharacterMechanics()
        {
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
            /* string[] wildHuntChecks =
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
            } */
            Msl.SetStringGMLInFile(ModFiles.GetCode("gml_GlobalScript_scr_fatigue_check.gml"), "gml_GlobalScript_scr_fatigue_check");
            Msl.SetStringGMLInFile(ModFiles.GetCode("gml_GlobalScript_scr_hungercheck.gml"), "gml_GlobalScript_scr_hungercheck");
            Msl.SetStringGMLInFile(ModFiles.GetCode("gml_GlobalScript_scr_intoxication_check.gml"), "gml_GlobalScript_scr_intoxication_check");
            Msl.SetStringGMLInFile(ModFiles.GetCode("gml_GlobalScript_scr_paincheck.gml"), "gml_GlobalScript_scr_paincheck");
            Msl.SetStringGMLInFile(ModFiles.GetCode("gml_GlobalScript_scr_thirsty_check.gml"), "gml_GlobalScript_scr_thirsty_check");

            LogPatchTiming("Block 04.1 Wild Hunt");

            // [全角色开局饰品] 为所有初始角色增加"希尔达的饰品 (Hilda's Trinket)"
            /* string[] starterChars = {
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
            } */
            Msl.LoadGML("gml_Object_o_player_Create_0").MatchAll().InsertBelow(@"
            with (o_inventory)
            {
                var _list = scr_atr(""recipesConsumsOpened"");
                if (!global.is_load_game && scr_atr(""nameKey"") != ""Hilda"" && !ds_list_find_index(_list, ""hilda_trinket""))
                {
                    scr_inventory_add_item(o_inv_hilda_trinket);
                    ds_list_add(_list, ""hilda_trinket"");
                }
            }
            auto_move = true;
            tile_transition = false;
            ").Save();
            LogPatchTiming("Block 04.1 Hilda starter trinket");

            // [希尔达饰品] 修改骨器猎获的初始数值和最高数值
            // 目的: 增强希尔达被动机制的实用性和成长空间 带有硬编码标记，后续版本可能需要调整
            Msl.SetStringGMLInFile(ModFiles.GetCode("gml_GlobalScript_scr_consum_hilda_enchant_assign.gml"), "gml_GlobalScript_scr_consum_hilda_enchant_assign");
            Msl.LoadAssemblyAsString("gml_GlobalScript_scr_cook_check_raw_ingredients")
            .MatchBelow(":[92]", 1).ReplaceBy("pushi.e 15")
            .MatchBelow(":[93]", 2).ReplaceBy("pushloc.v local.i\r\npushi.e 17")
            .MatchBelow("pushloc.v local.j", 1).ReplaceBy("pushi.e 17")
            .MatchBelow(":[114]", 1).ReplaceBy("pushi.e 15").Save(); // 修改骨器猎获类别上限
            MslExtensions.QuickMatch("gml_GlobalScript_scr_hoversGetEnchantedAttributes", "while (_i < 10)", "while (_i < 17)");
            LogPatchTiming("Block 04.1 Hilda enchant values");

            #endregion



            #region 4.2 开局装备强化 (Starter Equipment Boost)

            // [开局 DLC 物品] 启用开局获得 DLC 物品
            // 目的: 所有玩家都能体验完整的装备选择
            MslExtensions.QuickMatch("gml_Object_o_player_chest_Alarm_1", "if (scr_user_owns", "");
            LogPatchTiming("Block 04.2 Starter equipment");

            #endregion



            #region 4.3 阿娜天赋优化 (Ana Talented Optimization)

            // [阿娜天赋] 提升阿娜誓约天赋的属性加成效果
            // 目的: 增强誓约天赋的实用性，使其成为更有吸引力的选择
            Msl.LoadAssemblyAsString("gml_Object_o_perk_vow_feat_Create_0").MatchFromUntil("push.d 0.4", "push.d 0.02").ReplaceBy("push.d 0.6\r\npush.d 0.06").Save();
            // 修改天赋描述文本，反映新的效果和机制
            // [已迁移到运行时覆写]             Msl.LoadAssemblyAsString("skills").MatchFrom("push.s \"vow_feat;Каждый")
            // .ReplaceBy(ModFiles.GetCode("skills_rebalance_vow_feat.asm")).Save();
            LogPatchTiming("Block 04.3 Ana talent");

            #endregion



            #region 4.4 约娜天赋优化 (Yona Talented Optimization)

            // [约娜天赋] 为约娜的天赋添加全新的法术暴击斩杀赋予额外回合的效果
            // 利用原版的 scr_crit_death → is_crit_magic_death 统计链路，
            // 在暴击法术击杀时设置全局标记，由 scr_allturn 检查并授予免费回合
            MslExtensions.QuickInsertBelow("gml_GlobalScript_scr_crit_death", "is_crit_magic_death = true", @"
            if (is_crit_magic_death && !global.wizzard_turn && instance_is(argument0, o_runaway_wizzard))
            {
                global.got_free_turn++;
                global.wizzard_turn = true;
            }");
            // 修改天赋描述文本，反映新的效果和机制
            // [已迁移到运行时覆写]             Msl.LoadAssemblyAsString("skills").MatchFrom("push.s \"magical_erudition;Даёт")
            // .ReplaceBy(ModFiles.GetCode("skills_rebalance_magical_erudition.asm")).Save();
            LogPatchTiming("Block 04.4 Jonna talent");

            #endregion
        }
    }
}
