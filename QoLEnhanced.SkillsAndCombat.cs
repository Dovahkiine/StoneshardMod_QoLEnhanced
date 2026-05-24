using ModShardLauncher;
using ModShardLauncher.Mods;
using UndertaleModLib.Models;

namespace QoLEnhanced
{
    public partial class QoLEnhanced : Mod
    {
        private void PatchBlock_05_SkillsAndCombat()
        {
            // ========================================================================
            // 区块 5: 技能与战斗平衡 (Skills & Combat Balance)
            // ========================================================================
            // 功能: 调整技能机制和战斗参数，增强玩家的战术选择
            // 范围: 技能范围、伤害、消耗、效果时长等

            #region 5.1 主动技能调整 (Active Skills Adjustment)

            // [掌握主动] 增加技能范围和效果层数
            // 改进: 范围 +1, 层数加倍 | 目的: 提升技能实用性
            Msl.SetStringGMLInFile(ModFiles.GetCode("gml_Object_o_skill_seize_the_initiative_Other_17.gml"), "gml_Object_o_skill_seize_the_initiative_Other_17");

            // [掌握主动] 增加每次命中时叠加的层数
            // 原值: +1 | 新值: +2 | 持续轮数: 加倍
            Msl.SetStringGMLInFile(ModFiles.GetCode("gml_Object_o_db_ini_lost_Other_13.gml"), "gml_Object_o_db_ini_lost_Other_13");
            // 修改技能描述文本，反映新的效果和机制
            // [已迁移到运行时覆写]             Msl.LoadAssemblyAsString("skills").MatchFrom("push.s \"Seize_the_Initiative;Даёт")
            // .ReplaceBy(ModFiles.GetCode("skills_rebalance_seize_the_initiative.asm")).Save();

            // [招架] 精准格挡 + 全额反击 + 击杀额外回合
            // [伤害快照] 在 scr_attack 命中判定之前捕获攻击者潜在伤害
            // 必须在 scr_attack 而非 scr_damage 中快照：闪避时 scr_damage 的 argument1 恒为 0
            Msl.LoadGML("gml_GlobalScript_scr_attack").MatchFrom("_isFumbleDodge = false")
            .InsertBelow(@"argument0.__qol_riposte_raw = ((Slashing_Damage + Piercing_Damage + Blunt_Damage + Rending_Damage) * Weapon_Damage / 100) + ((Unholy_Damage + Sacred_Damage + Psionic_Damage + Arcane_Damage + Fire_Damage + Frost_Damage + Caustic_Damage + Poison_Damage + Shock_Damage) * Magic_Power / 100);").Save();
            Msl.SetStringGMLInFile(ModFiles.GetCode("gml_Object_o_b_riposte_Create_0.gml"), "gml_Object_o_b_riposte_Create_0");
            Msl.SetStringGMLInFile(ModFiles.GetCode("gml_Object_o_b_riposte_Other_13.gml"), "gml_Object_o_b_riposte_Other_13");
            Msl.SetStringGMLInFile(ModFiles.GetCode("gml_Object_o_skill_riposte_Other_17.gml"), "gml_Object_o_skill_riposte_Other_17");
            // [招架方向选择 UI] table_skills_stats 已在 PatchMod 主函数的表格替换区统一处理
            // 修改技能描述文本，反映新的效果和机制
            // [已迁移到运行时覆写]             Msl.LoadAssemblyAsString("skills").MatchFrom("push.s \"Riposte;Активирует")
            // .ReplaceBy(ModFiles.GetCode("skills_rebalance_riposte.asm")).Save();
            // 替换 Other_10 瞄准指示器：Riposte 用箭头，其他技能用默认 range 目前恒定为1，后续版本可以考虑根据技能定义动态调整
            Msl.SetStringGMLInFile(ModFiles.GetCode("gml_Object_o_skill_Other_10.gml"), "gml_Object_o_skill_Other_10");
            LogPatchTiming("Block 05.1 Active skills");
            #endregion



            #region 5.2 电系技能 (Discharge & Impulse Adjustment)
            // [放电] 伤害公式重做 + 不消耗回合
            // 新基础伤害: (7 + WIL*0.1 + EP*1) * (100+EP+MP*0.5)/100
            // 最终伤害: 基础伤害 * random_range(1,210)/100, 期望1.05x, 最低1点
            Msl.SetStringGMLInFile(ModFiles.GetCode("gml_Object_o_discharge_Other_10.gml"), "gml_Object_o_discharge_Other_10");

            // Other_11 可通过两种路径到达: 1) Other_10 的 event_user(1) 调用 2) 独立触发
            // got_free_turn 只写在 Other_11, 避免重复
            Msl.SetStringGMLInFile(ModFiles.GetCode("gml_Object_o_discharge_Other_11.gml"), "gml_Object_o_discharge_Other_11");

            Msl.SetStringGMLInFile(ModFiles.GetCode("gml_Object_o_skill_discharge_Other_17.gml"), "gml_Object_o_skill_discharge_Other_17");
            // [已迁移到运行时覆写]             Msl.LoadAssemblyAsString("skills").MatchFrom("push.s \"Discharge;Выпускает")
            // .ReplaceBy(ModFiles.GetCode("skills_rebalance_discharge.asm")).Save();
            LogPatchTiming("Block 05.2 Discharge");



            // [脉冲] 动态AOE范围 + 增强伤害公式
            // AOE范围: 1 + floor((WIL+MP+EP)/50), 上限4
            // 伤害: (10 + WIL*0.05 + EP*0.05) * (100+EP)/100, 随机波动0.01x~2.10x
            // DOT: (2 + WIL*0.01 + EP*0.01) * (100+EP)/100, 无波动
            Msl.SetStringGMLInFile(ModFiles.GetCode("gml_Object_o_impulse_birth_Other_10.gml"), "gml_Object_o_impulse_birth_Other_10");
            Msl.SetStringGMLInFile(ModFiles.GetCode("gml_Object_o_impulse_impact_Other_11.gml"), "gml_Object_o_impulse_impact_Other_11");

            Msl.SetStringGMLInFile(ModFiles.GetCode("gml_Object_o_skill_impulse_Other_17.gml"), "gml_Object_o_skill_impulse_Other_17");
            // AOE指示器：临时替换range让o_aoe_range方格跟随动态范围，执行后恢复，不影响施放距离

            Msl.SetStringGMLInFile(ModFiles.GetCode("gml_Object_o_db_impulse_Alarm_4.gml"), "gml_Object_o_db_impulse_Alarm_4");

            // [已迁移到运行时覆写]             Msl.LoadAssemblyAsString("skills").MatchFrom("push.s \"Impulse;Наносит")
            // .ReplaceBy(ModFiles.GetCode("skills_rebalance_impulse.asm")).Save();
            LogPatchTiming("Block 05.2 Impulse");



            // [连锁闪电] 强化技能伤害和弹射次数，不再限定弹射目标条件，移除目标过滤逻辑
            Msl.SetStringGMLInFile(ModFiles.GetCode("gml_Object_o_chain_lightning_Other_10.gml"), "gml_Object_o_chain_lightning_Other_10");
            MslExtensions.QuickMatch("gml_Object_o_chain_lightning_Collision_o_unit", "if (point_distance", "if (point_distance(x, y, target_x, target_y) < 24)");
            Msl.SetStringGMLInFile(ModFiles.GetCode("gml_Object_o_skill_chain_lightning_Other_17.gml"), "gml_Object_o_skill_chain_lightning_Other_17");
            LogPatchTiming("Block 05.2 Chain lightning");


            // [残余电荷] 减抗数值加强，增加暴击时的额外效果
            MslExtensions.QuickMatch("gml_Object_o_b_residual_charge_Create_0", "max_duration", "max_duration = 12;");
            // 改为创建12回合的残余电荷效果。
            MslExtensions.QuickMatch("gml_Object_o_pass_skill_residual_charge_Other_13", "scr_effect_create", "scr_effect_create(o_b_residual_charge, 12, owner, owner);");
            MslExtensions.QuickMatchFromUntil("gml_Object_o_pass_skill_residual_charge_Other_15", "_count = min", "scr_temp_incr_atr", @"
            if (is_player(owner))
            {
                _count = (_count + (owner.WIL + owner.Electromantic_Power + owner.Magic_Power) / 50) * (0.5 + owner.WIL * 0.01);
                _count = scr_chance_value(owner.Miracle_Chance) ? _count * 1.5 : _count;
                scr_temp_incr_atr(""Shock_Resistance"", -1 * _count, 12, target, target);
            }
            else
            {
                _count = min(_count, 6);
                scr_temp_incr_atr(""Shock_Resistance"", -0.5 * _count, 12, target, target);
            }");
            Msl.SetStringGMLInFile(ModFiles.GetCode("gml_Object_o_pass_skill_residual_charge_Other_17.gml"), "gml_Object_o_pass_skill_residual_charge_Other_17");
            MslExtensions.QuickMatch("gml_Object_o_lighting_Create_0", "scr_temp_incr_atr", "scr_temp_incr_atr(\"Electromantic_Power\", 25, 2400, owner, owner);");
            LogPatchTiming("Block 05.2 Residual charge");


            // [风雷大作] 强化技能伤害，增加电击目标，放宽目标过滤逻辑
            Msl.SetStringGMLInFile(ModFiles.GetCode("gml_Object_o_tempest_birth_Other_10.gml"), "gml_Object_o_tempest_birth_Other_10");
            Msl.SetStringGMLInFile(ModFiles.GetCode("gml_Object_o_tempest_Other_11.gml"), "gml_Object_o_tempest_Other_11");
            Msl.SetStringGMLInFile(ModFiles.GetCode("gml_Object_o_skill_tempest_Other_17.gml"), "gml_Object_o_skill_tempest_Other_17");
            LogPatchTiming("Block 05.2 Tempest");


            // [残余电荷] 法术命中触发减抗 — 球状闪电/静电场
            Msl.LoadGML("gml_Object_o_ball_lightning_Other_10")
                .MatchFrom("scr_skill_call_passive(o_pass_skill_conduit, owner, _target")
                .InsertBelow("_scr_residual_charge_on_spell_hit(owner, _target);")
                .Save();

            Msl.LoadGML("gml_Object_o_static_field_impact_Other_11")
                .MatchFrom("scr_skill_call_passive(o_pass_skill_recharge, owner, target")
                .InsertBelow("_scr_residual_charge_on_spell_hit(owner, target);")
                .Save();
            LogPatchTiming("Block 05.2 residual charge extra hooks");
            LogPatchTiming("Block 05.2 Electromancy");

            #endregion



            #region 5.3 范围和控制技能 (Area & Control Skills)

            // [战吼] 增加战吼范围，减少精力消耗与CD，改为稳定触发控制效果，持续12回合，延续激昂持续时间
            // 改变: 范围 12->15, 精力消耗降低, CD减少, 控制效果稳定触发
            // table_skills_stats 已在 PatchMod 主函数的表格替换区统一处理
            MslExtensions.QuickMatch("gml_Object_o_war_cry_birth_Other_10", "var _range", "var _range = 15;");
            MslExtensions.QuickMatchFromUntil("gml_Object_o_war_cry_impact_Other_11", "if scr_chance_value", "}", @"
            var _buff = -4;

            _buff = scr_effect_create(o_db_confuse, 12, target, target);
            if scr_chance_value(40 + 2 * owner.WIL)
                _buff = scr_effect_create(o_db_daze, 3, target, target);

            if _buff
            {
                with (owner)
                {
                    var _rage = scr_instance_exists_in_list(o_b_rage);

                    with (_rage)
                    {
                        if (duration <= 60)
                            duration += 4;
            ");
            // 修改技能描述文本，反映新的效果和机制
            // [已迁移到运行时覆写]             Msl.LoadAssemblyAsString("skills").MatchFrom("push.s \"War_Cry;Издаёт")
            // .ReplaceBy(ModFiles.GetCode("skills_rebalance_war_cry.asm")).Save();
            LogPatchTiming("Block 05.3 Area control");

            #endregion

            #region 5.4 被动技能 (Passive Skills)

            // [正中目标] 现在无论任何配装均可触发正中目标效果，增加命中率，减少失手几率，增加暴击率
            // 改进: 命中率 +8, 失手率 -8, 暴击率 +5
            Msl.SetStringGMLInFile(ModFiles.GetCode("gml_Object_o_pass_skill_right_on_target_Other_17.gml"), "gml_Object_o_pass_skill_right_on_target_Other_17");
            MslExtensions.QuickMatchBelow("gml_GlobalScript_scr_skill_right_on_target", "if (argument0 == 1)", 5, @"
            {
            Hit_Chance += 8;
            FMB -= 8;
            CRT += 5;
            }
            ");
            // 修改技能描述文本，反映新的效果和机制
            // [已迁移到运行时覆写]             Msl.LoadAssemblyAsString("skills").MatchFrom("push.s \"right_on_target;Даёт")
            // .ReplaceBy(ModFiles.GetCode("skills_rebalance_right_on_target.asm")).Save();


            // [准备就绪] 增加可叠加层数，增加命中率和伤害吸收率，减少能力消耗
            // 改进: 命中率 +8, 伤害减免 -8%, 能力消耗 -8%
            MslExtensions.QuickMatchFromUntil("gml_Object_o_pass_skill_preparation_Other_13", "Hit_Chance", "Abilities_Energy_Cost", @"
            scr_temp_effect_update(object_index, owner, ""Hit_Chance"", 8, 6, 3);
            scr_temp_effect_update(object_index, owner, ""Damage_Received"", -5, 6, 3);
            scr_temp_effect_update(object_index, owner, ""Abilities_Energy_Cost"", -8, 6, 3);");
            // 修改技能描述文本，反映新的效果和机制
            // [已迁移到运行时覆写]             Msl.LoadAssemblyAsString("skills").MatchFrom("push.s \"preparation;Пропуск")
            // .ReplaceBy(ModFiles.GetCode("skills_rebalance_preparation.asm")).Save();


            // [自修自缮] 装备耐久损耗速度变为40%，放宽装备属性加成阈值判定
            MslExtensions.QuickMatch("gml_Object_o_pass_skill_self_repair_Other_17", "ds_map_replace(data", @"
            var _durability_resistance = clamp(0.4 + (owner.Vitality * 0.02), 0.6, 1.0);
            ds_map_replace(data, ""Duration_Resistance"", _durability_resistance);
            ds_map_replace(text_map, ""Duration_Resistance"", math_round(_durability_resistance * 100));");
            MslExtensions.QuickMatch("gml_Object_o_pass_skill_self_repair_Other_17", "if (_duration >= ", "if (_duration >= (_maxDuration * 0.7))");
            // 修改技能描述文本，反映新的效果和机制
            // [已迁移到运行时覆写]             Msl.LoadAssemblyAsString("skills").MatchFrom("push.s \"self_repair;Даё")
            // .ReplaceBy(ModFiles.GetCode("skills_rebalance_self_repair.asm")).Save();


            // [远近兼攻] 获得的瞄准状态增加至3回合；添加弹药被射出时有50%概率不消耗直接复填
            MslExtensions.QuickMatch("gml_Object_o_pass_skill_thrift_Other_13", "scr_effect_create(o_b_taking_aim", "scr_effect_create(o_b_taking_aim, 3);");
            // 修改技能描述文本，反映新的效果和机制
            // [已迁移到运行时覆写]             Msl.LoadAssemblyAsString("skills").MatchFrom("push.s \"thrift;Уби")
            // .ReplaceBy(ModFiles.GetCode("skills_rebalance_thrift.asm")).Save();


            // [冲刺训练] 所有突进技能距离改为增加2
            MslExtensions.QuickMatch("gml_Object_o_pass_skill_sprint_training_Other_18", "Special_Bonus_Range", "Special_Bonus_Range += 2;");
            // 修改技能描述文本，反映新的效果和机制
            // [已迁移到运行时覆写]             Msl.LoadAssemblyAsString("skills").MatchFrom("push.s \"sprint_training;Даёт")
            // .ReplaceBy(ModFiles.GetCode("skills_rebalance_sprint_training.asm")).Save();
            LogPatchTiming("Block 05.4 Passive skills");


            #endregion

            #region 5.5 斩杀与终结 (Finishing Skills)

            // [最后一击] 增加突进距离，减少精力消耗和CD，增加斩杀阈值
            // 改进: 距离 +3, 精力消耗 -4, CD -2, 斩杀阈值提升
            // table_skills_stats 已在 PatchMod 主函数的表格替换区统一处理
            Msl.SetStringGMLInFile(ModFiles.GetCode("gml_Object_o_skill_finisher_Other_17.gml"), "gml_Object_o_skill_finisher_Other_17");
            Msl.SetStringGMLInFile(ModFiles.GetCode("gml_Object_o_finisher_Alarm_0.gml"), "gml_Object_o_finisher_Alarm_0");
            // 修改技能描述文本，反映新的效果和机制
            // Msl.LoadAssemblyAsString("skills").MatchFrom("push.s \"Finisher;Совершает")
            // .ReplaceBy(ModFiles.GetCode("skills_rebalance_finisher.asm")).Save();

            // [搏命] 修改为满血发挥最大效果，略微削弱最大效果数值
            // 目的: 鼓励玩家更主动地使用高风险技能
            Msl.SetStringGMLInFile(ModFiles.GetCode("gml_Object_o_pass_skill_last_effort_Other_17.gml"), "gml_Object_o_pass_skill_last_effort_Other_17");
            // 修改技能描述文本，反映新的效果和机制
            // [已迁移到运行时覆写]             Msl.LoadAssemblyAsString("skills").MatchFrom("push.s \"last_effort;Последнее")
            // .ReplaceBy(ModFiles.GetCode("skills_rename_last_effort.asm")).Save();
            // [已迁移到运行时覆写]             Msl.LoadAssemblyAsString("skills").MatchFrom("push.s \"last_effort;Даёт")
            // .ReplaceBy(ModFiles.GetCode("skills_rebalance_last_effort.asm")).Save();
            LogPatchTiming("Block 05.5 Finishing skills");

            #endregion

            #region 5.6 支援技能 (Support & Utility Skills)

            // [叫喊] 移除口渴副作用
            // 改进: 移除负面效果，提升技能吸引力
            Msl.SetStringGMLInFile(ModFiles.GetCode("gml_Object_o_shout_Other_12.gml"), "gml_Object_o_shout_Other_12");
            LogPatchTiming("Block 05.6 Support skills");

            #endregion

            #region 5.7 属性与防御 (Attributes & Defense)

            // [免疫属性] 提升免疫上限至 1000
            // 目的: 支持更高的免疫等级建设，增加属性成长空间
            Msl.SetStringGMLInFile(ModFiles.GetCode("gml_GlobalScript_scr_immunity_change.gml"), "gml_GlobalScript_scr_immunity_change");
            LogPatchTiming("Block 05.7 Attributes defense");

            #endregion

            #region 5.8 武器与装备 (Weapons & Equipment)


            //远程攻击重做，现在允许双持远程兵器，左右手的弩轮询装填；其余远程兵器每回合齐射一次
            Msl.SetStringGMLInFile(ModFiles.GetCode("gml_Object_o_enemy_Mouse_4.gml"), "gml_Object_o_enemy_Mouse_4");
            LogPatchTiming("Block 05.8 enemy mouse shoot");
            Msl.SetStringGMLInFile(ModFiles.GetCode("gml_GlobalScript_scr_is_ammo_exist.gml"), "gml_GlobalScript_scr_is_ammo_exist");
            Msl.SetStringGMLInFile(ModFiles.GetCode("gml_GlobalScript_scr_throw.gml"), "gml_GlobalScript_scr_throw");
            Msl.SetStringGMLInFile(ModFiles.GetCode("gml_GlobalScript_scr_crossbow_insert_bolt.gml"), "gml_GlobalScript_scr_crossbow_insert_bolt");
            Msl.SetStringGMLInFile(ModFiles.GetCode("gml_GlobalScript_scr_crossbow_is_armed.gml"), "gml_GlobalScript_scr_crossbow_is_armed");
            Msl.SetStringGMLInFile(ModFiles.GetCode("gml_GlobalScript_scr_crossbow_reject_bolt.gml"), "gml_GlobalScript_scr_crossbow_reject_bolt");
            LogPatchTiming("Block 05.8 ranged script replacements");

            // [慑敌连发] 适配远程双持：完整覆盖 Alarm_0，统一处理多箭登记与回合推进。
            Msl.SetStringGMLInFile(ModFiles.GetCode("gml_Object_o_pierce_through_missile_Alarm_0.gml"), "gml_Object_o_pierce_through_missile_Alarm_0");
            Msl.SetStringGMLInFile(ModFiles.GetCode("gml_Object_o_pierce_through_missile_Other_10.gml"), "gml_Object_o_pierce_through_missile_Other_10");
            Msl.SetStringGMLInFile(ModFiles.GetCode("gml_Object_o_skill_pierce_through_missile_Other_20.gml"), "gml_Object_o_skill_pierce_through_missile_Other_20");
            LogPatchTiming("Block 05.8 pierce through missile dual ranged");
            // 修改远程技能的使用条件，允许双持远程武器时正常使用，并按慑敌连发的新攻击协议检查弹药。
            Msl.SetStringGMLInFile(ModFiles.GetCode("gml_Object_o_skill_ico_Other_25.gml"), "gml_Object_o_skill_ico_Other_25");
            // 弩箭未装填时也允许使用转移注意
            Msl.SetStringGMLInFile(ModFiles.GetCode("gml_Object_o_distracting_shot_Alarm_0.gml"), "gml_Object_o_distracting_shot_Alarm_0");
            LogPatchTiming("Block 05.8 ranged skill conditions");
            //瞄准改为持续 8 回合；table_skills_stats 已在 PatchMod 主函数的表格替换区统一处理
            //修改瞄准的技能描述
            // [已迁移到运行时覆写]             Msl.LoadAssemblyAsString("skills").MatchFrom("push.s \"Taking_Aim;Акт")
            // .ReplaceBy(ModFiles.GetCode("skills_rebalance_taking_aim.asm")).Save();
            //瞄准最大持续时间改为24回合
            MslExtensions.QuickMatch("gml_Object_o_b_taking_aim_Create_0", "max_duration", "max_duration = 9;");
            LogPatchTiming("Block 05.8 taking aim");
            // [手持兵器] 移除双手兵器的持握限制
            // 目的: 允许单手使用双手武器，增加配装灵活性
            Msl.SetStringGMLInFile(ModFiles.GetCode("gml_GlobalScript_scr_inv_weapon_get_hands.gml"), "gml_GlobalScript_scr_inv_weapon_get_hands");
            Msl.SetStringGMLInFile(ModFiles.GetCode("gml_GlobalScript_scr_playerSpriteInit.gml"), "gml_GlobalScript_scr_playerSpriteInit");
            Msl.SetStringGMLInFile(ModFiles.GetCode("gml_GlobalScript_scr_playerSpriteArrayUpdate.gml"), "gml_GlobalScript_scr_playerSpriteArrayUpdate");
            Msl.SetStringGMLInFile(ModFiles.GetCode("gml_GlobalScript_scr_playerSpriteArrayDraw.gml"), "gml_GlobalScript_scr_playerSpriteArrayDraw");
            Msl.SetStringGMLInFile(ModFiles.GetCode("gml_GlobalScript_scr_playerSpriteUpdate.gml"), "gml_GlobalScript_scr_playerSpriteUpdate");
            Msl.SetStringGMLInFile(ModFiles.GetCode("gml_GlobalScript_scr_playerSpritePartsUpdate.gml"), "gml_GlobalScript_scr_playerSpritePartsUpdate");
            //单独改动铲子为双持，保持一致性
            MslExtensions.QuickMatch("gml_Object_o_inv_shovel_Create_0", "hands = 2", "hands = 1;");
            LogPatchTiming("Block 05.8 weapon hands");

            // [双持平衡] 移除双持时的重度主手/副手惩罚，并优化冷却缩减、失手率等收益
            // 改进: 主手效率 -25% -> 0%, 副手效率 -20%, 冷却缩减 +0, 失手率 5%
            Msl.SetStringGMLInFile(ModFiles.GetCode("gml_Object_o_db_dual_wielding_Create_0.gml"), "gml_Object_o_db_dual_wielding_Create_0");
            Msl.SetStringGMLInFile(ModFiles.GetCode("gml_Object_o_db_dual_wielding_Other_10.gml"), "gml_Object_o_db_dual_wielding_Other_10");

            // [暴击范围] 增加暴击范围的触发条件，只要装备单手近战武器即可触发暴击范围效果
            Msl.SetStringGMLInFile(ModFiles.GetCode("gml_GlobalScript_scr_attack_result_crit_aoe.gml"), "gml_GlobalScript_scr_attack_result_crit_aoe");

            // [格挡损耗] 降低格挡时的装备耐久消耗倍率 (0.02 -> 0.01)
            // 目的: 鼓励玩家使用防守战术
            Msl.SetStringGMLInFile(ModFiles.GetCode("gml_GlobalScript_scr_duration_decrese.gml"), "gml_GlobalScript_scr_duration_decrese");
            LogPatchTiming("Block 05.8 dual wield crit block");
            LogPatchTiming("Block 05.8 Weapons equipment");

            #endregion

            #region 5.9 修补与收集 (Crafting & Gathering)

            // [剥皮强化] 拥有"猎人大师"技能时，剥皮成功率提升至 100%，并增加皮革耐久
            // 目的: 经济系统更多选择，鼓励专门化培养
            MslExtensions.QuickMatch("gml_Object_o_flaying_Other_10", "if ((_resorcefullness",
            "if ((_resorcefullness && scr_chance_value(Pelt_Durability)) || (_is_hunting_secret && scr_chance_value(100)) || (_is_hunters_grit && scr_chance_value(scr_atr(\"Hunter's Grit\"))))");
            MslExtensions.QuickMatch("gml_Object_o_flaying_Other_10", "Pelt_Durability +=", "Pelt_Durability += 100");

            // [升级系统] 已在自动寻路处修改。修改玩家步进事件：解锁等级上限 (100)、替换阶段性经验曲线、将每级 AP 奖励提升至 3，SP 提升至 2
            // 目的: 延长游戏终局内容，增加角色养成深度
            LogPatchTiming("Block 05.9 Crafting gathering");

            #endregion


            #region 5.10 Alt键显示详细技能信息与说明 (Alt Key Detailed Skill Info)

            Msl.SetStringGMLInFile(base.ModFiles.GetCode("gml_Object_o_hoverSkill_Other_20.gml"), "gml_Object_o_hoverSkill_Other_20");
            Msl.SetStringGMLInFile(base.ModFiles.GetCode("gml_Object_o_hoverRender_Step_2.gml"), "gml_Object_o_hoverRender_Step_2");
            LogPatchTiming("Block 05.10 Alt skill details");

            #endregion


            #region 5.11 免费回合核心 (Free Turn Core)

            // [免费回合核心] 注入 scr_unitTurnNext 开头 — 调度敌人回合的唯一天然入口
            // 当 got_free_turn > 0 时阻止 alarm[4] 被设为正值，跳过整个敌人回合循环
            // alarm[4] 可在 argument0<=0 时被 global.Upspeed 强制覆写为 1，故不依赖 argument0
            // 仅在 argument0>0 时消费 got_free_turn（-1 为清理，undefined 为未预期调用）
            Msl.SetStringGMLInFile(ModFiles.GetCode("gml_GlobalScript_scr_unitTurnNext.gml"), "gml_GlobalScript_scr_unitTurnNext");
            Msl.SetStringGMLInFile(ModFiles.GetCode("gml_GlobalScript_scr_global_turn.gml"), "gml_GlobalScript_scr_global_turn");
            // Msl.SetStringGMLInFile(ModFiles.GetCode("gml_GlobalScript_scr_allturn.gml"), "gml_GlobalScript_scr_allturn");
            LogPatchTiming("Block 05.11 Free turn core");

            #endregion


            #region 5.12 派系魔法修正 (Faction Magic Correction)

            // [魔法威力] 移除学习特定派系魔法后对其他派系威力的负面修正
            // 目的: 允许混合魔法流派的角色构建，提升自定义性
            var magicBuffsMap = new Dictionary<string, string>
            {
                {
                    "gml_Object_o_b_electro_Other_15",
                    @"event_inherited();
                    ds_map_replace(data, ""Electromantic_Power"", 8 * stage);
                    ds_map_replace(data, ""Magic_Power"", stage);
                    ds_map_replace(data, ""Miracle_Power"", 4 * stage);"
                },
                {
                    "gml_Object_o_b_pyro_Other_15",
                    @"event_inherited();
                    ds_map_replace(data, ""Pyromantic_Power"", 8 * stage);
                    ds_map_replace(data, ""Magic_Power"", stage);
                    ds_map_replace(data, ""Miracle_Power"", 4 * stage);"
                },
                {
                    "gml_Object_o_b_geo_Other_15",
                    @"event_inherited();
                    ds_map_replace(data, ""Geomantic_Power"", 8 * stage);
                    ds_map_replace(data, ""Magic_Power"", stage);
                    ds_map_replace(data, ""Miracle_Power"", 4 * stage);"
                },
                {
                    "gml_Object_o_b_arcanistics_Other_15",
                    @"event_inherited();
                    ds_map_replace(data, ""Arcanistic_Power"", 8 * stage);
                    ds_map_replace(data, ""Magic_Power"", stage);
                    ds_map_replace(data, ""Miracle_Power"", 4 * stage);"
                }
            };

            foreach (var kvp in magicBuffsMap)
            {
                Msl.LoadGML(kvp.Key).MatchAll()
                    .ReplaceBy(kvp.Value)
                    .Save();
            }
            LogPatchTiming("Block 05.12 Faction magic");

            #endregion
        }
    }
}
