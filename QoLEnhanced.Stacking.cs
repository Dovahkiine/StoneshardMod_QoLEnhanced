using ModShardLauncher;
using ModShardLauncher.Mods;
using UndertaleModLib.Models;

namespace QoLEnhanced
{
    public partial class QoLEnhanced : Mod
    {
        private void PatchBlock_10_Stacking()
        {
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
        }
    }
}
