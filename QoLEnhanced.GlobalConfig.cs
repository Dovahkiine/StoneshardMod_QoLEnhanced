using ModShardLauncher;
using ModShardLauncher.Mods;
using UndertaleModLib.Models;

namespace QoLEnhanced
{
    public partial class QoLEnhanced : Mod
    {
        private void PatchBlock_01_GlobalConfig()
        {
            // ========================================================================
            // 区块 1: 全局配置与游戏机制 (Global Configuration & Game Mechanics)
            // ========================================================================
            // 功能: 提升游戏难度和视觉体验，调整地牢机制
            // 范围: 密室生成、照明、陷阱发现、敌人生成、初始属性等

            #region 1.1 地牢机制 (Dungeon Mechanics)

            // [密室机制] 密室出现概率上调至 100%
            // 原值: 5% | 新值: 100% | 目的: 提升地牢探索的多样性和挑战
            MslExtensions.QuickMatch("gml_GlobalScript_scr_dungeonHasSecretRoom", "return scr_chance_value(5)", "return 1;");

            // [全局亮度] 调整地牢光照颜色，提升视觉体验
            // 作用: 统一所有地形的光照效果，增强视觉一致性
            Msl.LoadGML("gml_GlobalScript_scr_dungeonSetSettings")
                .MatchFrom("_settings.LightColor = (_settings.CurrentFloor == 1 ? [72,")
                .ReplaceBy("_settings.LightColor = (_settings.CurrentFloor == 1 ? [122, 198, 177] : [122, 198, 177]);")
                .MatchFrom("_settings.LightColor = (_settings.CurrentFloor == 1 ? [50,")
                .ReplaceBy("_settings.LightColor = (_settings.CurrentFloor == 1 ? [90, 107, 194] : [90, 107, 194]);")
                .MatchFrom("_settings.LightColor = (_settings.CurrentFloor == 1 ? [123,")
                .ReplaceBy("_settings.LightColor = (_settings.CurrentFloor == 1 ? [182, 106, 106] : [151, 75, 75]);")
                .MatchFrom("_settings.LightColor = (_settings.CurrentFloor == 1 ? [97,")
                .ReplaceBy("_settings.LightColor = (_settings.CurrentFloor == 1 ? [151, 75, 75] : [182, 106, 106]);")
                .MatchFrom("_settings.LightColor = (_settings.CurrentFloor == 1 ? [62,")
                .ReplaceBy("_settings.LightColor = (_settings.CurrentFloor == 1 ? [102, 120, 114] : [102, 120, 114]);")
                .Save();


            #endregion


            #region 1.2 陷阱与敌人 (Traps & Enemies)


            // [陷阱发现] 陷阱发现几率基于感知属性 (PRC)，移除固定概率
            // 目的: 使陷阱发现与角色属性挂钩，增加游戏平衡性
            Msl.LoadGML("gml_GlobalScript_scr_trap_find")
                .MatchFrom("other.trap_find = (0.75").ReplaceBy("other.trap_find = scr_atr(\"PRC\") / R")
                .MatchFrom("other.trap_find = 0.05").ReplaceBy("other.trap_find = scr_atr(\"PRC\") / R")
                .MatchFrom("find_chance = 0.5").ReplaceBy("find_chance = scr_atr(\"PRC\") / R")
                .Save();

            // [刷怪倍率] 敌人生成数量提升至 3 倍
            // 原值: 1x | 新值: 3x | 难度提升: 增加战斗挑战性
            Msl.LoadGML("gml_Object_o_mob_point_Other_11")
                .MatchFrom("var _size ")
                .InsertBelow("repeat (3)")
                .Save();

            // 地面敌人生成数量变为 3 倍
            Msl.LoadGML("gml_GlobalScript_scr_surfaceSpawnsDoc").MatchFrom("if (_enemyStringArray").InsertAbove("repeat (3)").Save();
            // 全面加强地面生物刷新列表强度
            Msl.SetStringGMLInFile(ModFiles.GetCode("gml_GlobalScript_table_surface_spawn.gml"), "gml_GlobalScript_table_surface_spawn");

            // [敌人属性缩放] 根据玩家等级动态调整怪物属性，提升游戏挑战性
            MslExtensions.QuickInsertBelow("gml_Object_o_mob_point_Other_10", "}", "_scr_scale_enemy_csv_by_level();");

            // 调整经验值缩放公式，确保在高等级时仍能获得合理的经验奖励，避免过度惩罚玩家
            Msl.LoadAssemblyAsString("gml_Object_o_enemy_Destroy_0").MatchBelow("pop.v.v local._lvl", 14).ReplaceBy(ModFiles.GetCode("gml_Object_o_enemy_Destroy_0_insert.asm")).Save();

            #endregion

            #region 1.3 初始属性 (Initial Attributes)

            // [初始属性] 提升新游戏初始能力点 (AP) 0 -> 5
            // 影响: 玩家开局自由度提升，更灵活的属性配置
            MslExtensions.QuickMatch("gml_GlobalScript_scr_characterMapInit",
                "ds_map_add(global.characterDataMap, \"AP\", 0)",
                "ds_map_add(global.characterDataMap, \"AP\", 5);");

            // [初始属性] 提升新游戏初始技能点 (SP) 2 -> 5
            // 影响: 玩家初期技能学习更加便利
            MslExtensions.QuickMatch("gml_GlobalScript_scr_characterMapInit",
                "ds_map_add(global.characterDataMap, \"SP\", 2)",
                "ds_map_add(global.characterDataMap, \"SP\", 5);");

            // [等级上限] UI 面板修正：将经验条和等级显示的硬上限从 30 提升至 100
            // 目的: 支持更高的角色等级上限，提升长期游玩目标
            MslExtensions.QuickMatch("gml_Object_o_character_panel_mask_Draw_0",
                "var _maxLevel = scr_atr(\"LVL\") == 30",
                "var _maxLevel = scr_atr(\"LVL\") == 100;");

            #endregion

            #region 1.4 宝箱奖励机制调整 (Chest Reward Mechanism Adjustments)

            // 增加箱子奖励的数量
            MslExtensions.QuickMatchBelow("gml_Object_c_container_Other_13", "with (scr_container_create", 5, @"
            {
                repeat (2)
                {
                    randomize();
                    script_execute(other.loot_script, other.loot_script_key, other.loot_script_tier);
                }
            }");

            #endregion

            #region 1.5 全局初始化与玩家核心逻辑 (Global Init & Player Core)

            // [初始化] 在游戏初始化时重置所有全局变量，确保每次新游戏或加载都能正确应用新的游戏机制
            MslExtensions.QuickInsertBelow("gml_GlobalScript_scr_sessionDataInit", "audio_sound_gain", @"
            _scr_init_weapon_prefixes();
            global.chain_lightning_count = 0;   // 重置连锁闪电计数
            global.enemy_balance_by_LVL = -1;   // 重置等级缩放缓存
            global.free_turn_consumed = false;  // 新增标记：本回合的免费回合是否已被消费
            if (!variable_global_exists(""got_free_turn""))
                global.got_free_turn = 0;
            if (!variable_global_exists(""wizzard_turn""))
                global.wizzard_turn = false;    // 重置约娜免费回合标记
            _scr_scale_enemy_csv_by_level();
            ");

            // [整合] o_player_Step_0 全量替换 — 合并等级AP/SP、经验曲线、标记地点导航、免费回合移动消费
            Msl.SetStringGMLInFile(ModFiles.GetCode("gml_Object_o_player_Step_0.gml"), "gml_Object_o_player_Step_0");

            #endregion
        }
    }
}
