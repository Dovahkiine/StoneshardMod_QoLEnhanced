using ModShardLauncher;
using ModShardLauncher.Mods;
using UndertaleModLib.Models;

namespace QoLEnhanced
{
    public partial class QoLEnhanced : Mod
    {
        private void PatchBlock_07_Consumables()
        {
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
        }
    }
}
