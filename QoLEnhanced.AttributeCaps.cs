using ModShardLauncher;
using ModShardLauncher.Mods;
using UndertaleModLib.Models;

namespace QoLEnhanced
{
    public partial class QoLEnhanced : Mod
    {
        private void PatchBlock_11_AttributeCaps()
        {
            // ========================================================================
            // 区块 11: 属性上限与战斗公式 (Attribute Limits & Combat Formulas)
            // ========================================================================
            // 功能: 提升属性上限，优化战斗计算公式
            // 范围: 属性 clamp 上限、属性按钮解锁等

            #region 11.1 全局属性计算 (Global Attribute Calculation)

            // [属性计算] 替换全局属性计算脚本，大幅提升各项数值的 clamp 上限
            // 目的: 支持更高等级的属性成长，延长游戏重玩价值
            Msl.SetStringGMLInFile(ModFiles.GetCode("gml_GlobalScript_scr_atr_calc.gml"), "gml_GlobalScript_scr_atr_calc");
            Msl.SetStringGMLInFile(ModFiles.GetCode("gml_GlobalScript_scr_atr_calc_combat.gml"), "gml_GlobalScript_scr_atr_calc_combat");

            MslExtensions.QuickMatchFromUntil("gml_Object_o_skill_Other_17", "if (maxKD < (_maxCD", "maxKD = ", ""); //解除技能冷却上限对属性的限制

            #endregion

            #region 11.2 属性提升 UI (Attribute Enhancement UI)

            // [UI 交互] 解锁属性按钮点击限制：允许在 AP 充足时将单项属性提升至 100
            // 改进: 属性上限从原版提升至 100，提升个性化空间
            MslExtensions.QuickMatch("gml_Object_o_attribute_button_Step_2", "if (scr_atr", "if (scr_atr(\"AP\") && scr_atr(attributeKey) < 100)");
            MslExtensions.QuickMatch("gml_Object_o_character_attribute_Step_2", "if (scr_atr", "if (scr_atr(\"AP\") && scr_atr(attributeKey) < 100)");

            #endregion

            #region 11.3 新增属性 (New Attributes)

            // [新增属性] 添加新的属性：连续回合/连动 (Chain Turn)，丰富战斗策略
            Msl.LoadGML("gml_Object_o_textLoader_Other_25")
            .MatchFrom("ds_map_set(global.attribute_decimals, \"EVS\", 1)").InsertBelow("ds_map_set(global.attribute_decimals, \"Chain_Turn\", 1);")
            .MatchFrom("global.attribute_percent = __dsDebuggerMapCreate()").InsertBelow("scr_add_atr_percent(\"Chain_Turn\");").Save();
            MslExtensions.QuickInsertBelow("gml_Object_o_characterBottomContainer_Other_10", "scr_param_list_add(\"Hit_Chance\", _hitChance)", 
            @"var _chain_turn = 100 * power(0.98, o_player.AGL - 10);
            ds_map_replace(text_map, ""Chain_Turn"", 100 / _chain_turn);
            scr_param_list_add(""Chain_Turn"", scr_hoversGetAttributeValueString(""Chain_Turn"", 100 - _chain_turn, false));");

            #endregion
        }
    }
}
