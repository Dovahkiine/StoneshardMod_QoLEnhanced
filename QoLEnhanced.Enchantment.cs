using ModShardLauncher;
using ModShardLauncher.Mods;
using UndertaleModLib.Models;

namespace QoLEnhanced
{
    public partial class QoLEnhanced : Mod
    {
        private void PatchBlock_02_Enchantment()
        {
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
            Msl.SetStringGMLInFile(ModFiles.GetCode("gml_Object_o_skill_enchantment_Other_11.gml"), "gml_Object_o_skill_enchantment_Other_11");

            // [附魔核心] 注入附魔核心逻辑脚本
            // 作用: 构建完整的附魔体系，支持更丰富的镶嵌组合
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
        }
    }
}
