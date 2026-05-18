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
            Msl.LoadGML("gml_GlobalScript_scr_actionsLog").MatchFrom("scr_actionsLogUpdate").InsertAbove(@"
            // --- 时间戳前缀注入逻辑 ---
            if (variable_global_exists(""timeDataMap"") && ds_exists(global.timeDataMap, ds_type_map))
            {
                var _h = ds_map_find_value(global.timeDataMap, ""hours"")
                var _m = ds_map_find_value(global.timeDataMap, ""minutes"")

                if (!is_undefined(_h) && !is_undefined(_m))
                {
                    var _hs = (_h < 10 ? ""0"" : """") + string(_h)
                    var _ms = (_m < 10 ? ""0"" : """") + string(_m)

                    // 核心：修改原本传入的文本 (argument0)
                    // ~y~ 开启黄色，~c~ 或 ~w~ (根据原版色彩符定) 用于重置颜色，防止整句话都变黄
                    _log = ""[~y~"" + _hs + "":"" + _ms + ""~c~] "" + _log
                }
            }
            ").Save(); // 在日志更新函数前注入时间戳逻辑，确保每条日志都带有当前游戏时间的前缀

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

            Msl.LoadGML("gml_Object_o_player_Create_0").MatchAll().InsertBelow(@"
            auto_move = true
            tile_transition = false").Save(); // 增加自动寻路状态标记，配合寻路脚本使用
            Msl.LoadGML("gml_Object_o_player_Other_17").MatchAll().InsertAbove("tile_transition = true;").Save(); // 在玩家创建时默认开启 tile_transition，确保寻路功能正常使用
            Msl.LoadGML("gml_Object_o_player_Other_17").MatchAll().InsertBelow("tile_transition = false;").Save(); // 在玩家创建后立即关闭 tile_transition，确保正常游戏流程不受影响
            MslExtensions.QuickInsertBelow("gml_GlobalScript_scr_stop_player", "path = -1", @"
            if (!tile_transition)
                _scr_stop_auto_move();"); // 在原有的停止移动逻辑基础上增加对 tile_transition 的检查，确保只有在非寻路状态下才调用 _scr_stop_auto_move，避免寻路过程中被意外打断


            // [整合] o_player_Step_0 全量替换已移至 GlobalConfig.cs 区块 1.5
            Localization.ActionLogsPatching();              //本地化
            // ExportTable("gml_GlobalScript_table_lines");    //导出文本表，方便后续修改和本地化，暂时不用

            #endregion



            #region 3.3 快捷键系统 (Hotkey System)


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
            Msl.InsertGMLString(@"
            save_counter = 0;
            stage = ds_map_find_value(data, ""__stage"");
            if (is_undefined(stage))
                stage = 0;
            max_stage = 3;
            have_duration = false;
            draw_duration = false;
            have_stages = true;
            ", "gml_Object_o_b_bless_Create_0", 6);
            Msl.SetStringGMLInFile(@"
            event_user(0);

            if (is_player(target) && scr_psy_time_check(""BlessTime"", 24, 2))
                scr_psy_change(""SanityLifestyle"", 1 * scr_psy_get(""LifestyleSanityCoef"", false, 1), ""bless"");

            if (!is_load)
            {
                with (target)
                {
                    scr_guiAnimation(s_blessing, 1, 1);
                    audio_play_sound(snd_altar_buff, 4, 0);

                    if (is_player())
                        scr_characterStatsUpdateAdd(""usedAltars"", 1);
                }
            }
            ", "gml_Object_o_b_bless_Alarm_2");
            Msl.InsertGMLString(@"
            var _defense_boost = 0;

            if (scr_npc_lines_black_tablet_check_bless_boost())
                _defense_boost = 6;

            var _timer_fired = (save_counter >= 1440 || save_counter == 0);
            if (_timer_fired)
            {
                save_counter = 0;
                if (stage < max_stage)
                    stage++;
            }

            var _last_boost = ds_map_find_value(data, ""__boost_state"");
            if (is_undefined(_last_boost))
                _last_boost = -1;

            if (_timer_fired || _defense_boost != _last_boost)
            {
                __dsDebuggerMapClear(data);
                ds_map_add(data, ""__stage"", stage);
                ds_map_add(data, ""__boost_state"", _defense_boost);
                ds_map_add(data, ""Received_XP"", 5 * stage);
                ds_map_add(data, ""Sacred_Damage"", stage);
                ds_map_add(data, ""Fortitude"", 9 * stage);
                ds_map_add(data, ""Crit_Avoid"", (9 * stage) + _defense_boost);
                ds_map_add(data, ""Unholy_Resistance"", (9 * stage) + _defense_boost);
            }

            save_counter++;
            ", "gml_Object_o_b_bless_Other_10", 1);


            #endregion



            #region 3.5 特殊效果 (Special Effects)

            // [夜视机制] 星盘在夜间提供清晰视野效果
            // 目的: 使特定装备在夜间有明确的实用价值
            // 注意: 使用了 data 变量，确保在正确的上下文中使用
            MslExtensions.QuickMatchBelow("gml_Object_o_inv_nikos_astrolabe_Other_24", "if (global.floor_counter", 3, @"
            {
                if (ds_map_find_value(global.timeDataMap, ""hours"") >= 19 || ds_map_find_value(global.timeDataMap, ""hours"") <= 7)
                {
                    scr_effect_create(o_b_clearsight, 2880);
                    ds_map_set(data, ""use_kd"", 18);
            ");

            // [马车调度] 调整马车调度时间为 1.5 天
            // 目的: 增加商人补给的频率，改善经济系统平衡
            MslExtensions.QuickMatch("gml_GlobalScript_scr_caravanSettingsGetDispatchTime", "var _dispatchTime", "var _dispatchTime = 1.5;");

            // 睡觉获得的精神焕发时间翻三倍
            MslExtensions.QuickMatchBelow("gml_Object_o_sleepController_Other_10", "scr_lifeParamsUpdate", 2, @"
            _freshDuration = max(_freshDuration * 4, 480);
            scr_modifier_change(o_player, o_b_fresh, _freshDuration * sleepHours, 7200);");
            MslExtensions.QuickMatchBelow("gml_Object_o_sleepController_Other_12", "if _skillBedIsOpen", 5, @"
            scr_modifier_change(o_player, o_b_fresh, 480 * sleepHours, 7200);");
            MslExtensions.QuickMatchBelow("gml_Object_o_sleepController_Other_13", "if _skillBedIsOpen", 5, @"
            scr_modifier_change(o_player, o_b_fresh, 480 * sleepHours, 7200);");
            MslExtensions.QuickMatchBelow("gml_Object_o_sleepController_Other_15", "scr_lifeParamsUpdate", 6, @"
            _freshDuration = max(_freshDuration * 4, 480);
            scr_modifier_change(o_player, o_b_fresh, 600 * sleepHours, 7200);");

            // 时刻机警获得的精神焕发时间大幅延长
            // 时刻机警获得的精神焕发时间从 10 分钟提升到 1 小时，增强其在长时间探索中的实用性
            MslExtensions.QuickMatch("gml_Object_o_pass_skill_lightning_reflexes_Other_19", "scr_modifier_change",
            "scr_modifier_change(o_player, o_b_fresh, 120, 7200);");
            // 修改技能描述文本，反映新的效果和机制
            // [已迁移] 运行时覆写 → o_textLoader_Other_25 case 3, 避免 argc 硬编码冲突

            #endregion
        }
    }
}
