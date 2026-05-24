using ModShardLauncher;
using ModShardLauncher.Mods;
using UndertaleModLib.Models;

namespace QoLEnhanced
{
    public partial class QoLEnhanced : Mod
    {
        private void PatchBlock_03_TimeAndHotkeys()
        {
            // ========================================================================
            // 区块 3: 时间系统与快捷键 (Time System & Hotkeys)
            // ========================================================================
            // 功能: 增加便利的快捷键操作和时间显示功能
            // 范围: 时间显示、快捷键、存档机制、夜视等

            #region 3.1 时间显示与驱动 (Time Display & Driver)

            // [时间显示] 注册时间 UI 更新脚本
            // 目的: 在游戏中实时显示游戏内的时间
            Msl.SetStringGMLInFile(ModFiles.GetCode("gml_GlobalScript_scr_actionsLog.gml"), "gml_GlobalScript_scr_actionsLog");

            #endregion


            #region 3.2 自动寻路系统 (Auto-Pathfinder System)

            // 允许在标记后自动寻路到标记位置，支持地图标记和实体标记两种类型
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

            // 增加自动寻路状态标记，配合寻路脚本使用 o_player_Create_0 已迁移
            Msl.SetStringGMLInFile(ModFiles.GetCode("gml_Object_o_player_Other_17.gml"), "gml_Object_o_player_Other_17");
            Localization.ActionLogsPatching();              //本地化
            // ExportTable("gml_GlobalScript_table_lines");    //导出文本表，方便后续修改和本地化，暂时不用

            #endregion



            #region 3.3 快捷键系统 (Hotkey System)


            // [快捷键 F2] 注入 F2 键 (113) 切换全局加速速度
            Msl.SetStringGMLInFile(ModFiles.GetCode("gml_Object_o_player_KeyPress_113.gml"), "gml_Object_o_player_KeyPress_113");

            // [快捷键 F3] 注入 F3 键 (114) 前往标记点(自动寻路)
            // 目的: 提供快速前往最近的一个地图标记点的功能，提升游戏便利性
            Msl.SetStringGMLInFile(ModFiles.GetCode("gml_Object_o_player_KeyPress_114.gml"), "gml_Object_o_player_KeyPress_114");

            // [快捷键 F4] 注入 F4 键 (115) 打开马车储存箱的逻辑
            // 效果: 快速访问大篷车仓库
            Msl.SetStringGMLInFile(ModFiles.GetCode("gml_Object_o_player_KeyPress_115.gml"), "gml_Object_o_player_KeyPress_115");

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
            Msl.SetStringGMLInFile(ModFiles.GetCode("gml_Object_o_b_bless_Create_0.gml"), "gml_Object_o_b_bless_Create_0");
            Msl.SetStringGMLInFile(ModFiles.GetCode("gml_Object_o_b_bless_Alarm_2.gml"), "gml_Object_o_b_bless_Alarm_2");
            Msl.SetStringGMLInFile(ModFiles.GetCode("gml_Object_o_b_bless_Other_10.gml"), "gml_Object_o_b_bless_Other_10");


            #endregion



            #region 3.5 特殊效果 (Special Effects)

            // [夜视机制] 星盘在夜间提供视野的判定时间放宽，冷却时间缩短，效果增强
            // 目的: 使特定装备在夜间有明确的实用价值
            // 注意: 使用了 data 变量，确保在正确的上下文中使用
            Msl.SetStringGMLInFile(ModFiles.GetCode("gml_Object_o_inv_nikos_astrolabe_Other_24.gml"), "gml_Object_o_inv_nikos_astrolabe_Other_24");
            Msl.SetStringGMLInFile(ModFiles.GetCode("gml_Object_o_b_clearsight_Alarm_2.gml"), "gml_Object_o_b_clearsight_Alarm_2");

            // [马车调度] 调整马车调度时间为 1.5 天
            // 目的: 增加商人补给的频率，改善经济系统平衡
            Msl.SetStringGMLInFile(ModFiles.GetCode("gml_GlobalScript_scr_caravanSettingsGetDispatchTime.gml"), "gml_GlobalScript_scr_caravanSettingsGetDispatchTime");

            // 睡觉获得的精神焕发时间翻三倍
            Msl.SetStringGMLInFile(ModFiles.GetCode("gml_Object_o_sleepController_Other_10.gml"), "gml_Object_o_sleepController_Other_10");
            Msl.SetStringGMLInFile(ModFiles.GetCode("gml_Object_o_sleepController_Other_12.gml"), "gml_Object_o_sleepController_Other_12");
            Msl.SetStringGMLInFile(ModFiles.GetCode("gml_Object_o_sleepController_Other_13.gml"), "gml_Object_o_sleepController_Other_13");
            Msl.SetStringGMLInFile(ModFiles.GetCode("gml_Object_o_sleepController_Other_15.gml"), "gml_Object_o_sleepController_Other_15");

            // 时刻机警获得的精神焕发时间大幅延长
            // 时刻机警获得的精神焕发时间从 10 分钟提升到 1 小时，增强其在长时间探索中的实用性
            Msl.SetStringGMLInFile(ModFiles.GetCode("gml_Object_o_pass_skill_lightning_reflexes_Other_19.gml"), "gml_Object_o_pass_skill_lightning_reflexes_Other_19");
            // 修改技能描述文本，反映新的效果和机制
            // [已迁移] 运行时覆写 → o_textLoader_Other_25 case 3, 避免 argc 硬编码冲突

            #endregion
        }
    }
}
