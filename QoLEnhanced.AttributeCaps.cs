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
        }
    }
}
