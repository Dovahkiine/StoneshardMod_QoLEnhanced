using ModShardLauncher;
using ModShardLauncher.Mods;
using UndertaleModLib.Models;

namespace QoLEnhanced
{
    public partial class QoLEnhanced : Mod
    {
        private void PatchBlock_08_Economy()
        {
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

            #region 8.3 道具定价调整 (Item Pricing Adjustments)

            // [卷轴定价] 附魔卷轴 200→8000, 鉴定卷轴 10→500
            List<string> itemsStats = ModLoader.GetTable("gml_GlobalScript_table_items_stats");
            for (int i = 0; i < itemsStats.Count; i++)
            {
                if (itemsStats[i].StartsWith("scroll_enchant;"))
                    itemsStats[i] = itemsStats[i].Replace(";200;", ";8000;");
                else if (itemsStats[i].StartsWith("scroll_identification;"))
                    itemsStats[i] = itemsStats[i].Replace(";10;", ";500;");
            }
            ModLoader.SetTable(itemsStats, "gml_GlobalScript_table_items_stats");

            #endregion
        }
    }
}
