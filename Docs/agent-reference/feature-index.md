# QoLEnhanced 按需参考

以下内容从原项目入口迁入；代码、命令及普通文本路径仍相对 QoLEnhanced 根。仅查当前任务相关章节，历史数值与文件身份须以当前源码核对。

## 功能区块全览 (10 文件, ~50+ 项修改)

### 区块 1: 全局配置与游戏机制 (QoLEnhanced.GlobalConfig.cs)

| 功能 | 涉及文件 |
|------|---------|
| 密室 100% 出现 | `scr_dungeonHasSecretRoom` |
| 地牢光照颜色调整 | `scr_dungeonSetSettings` |
| 陷阱发现基于 PRC 属性 | `scr_trap_find` |
| 刷怪 3 倍 | `o_mob_point_Other_11`, `scr_surfaceSpawnsDoc` |
| 地面刷新列表强化 | `table_surface_spawn.gml` |
| 敌人属性按玩家等级缩放 | `_scr_scale_enemy_csv_by_level.gml` |
| 经验值缩放调整 | `o_enemy_Destroy_0_insert.asm` |
| 初始 AP 0→5, SP 2→5 | `scr_characterMapInit` |
| 等级上限 UI 30→100 | `o_character_panel_mask_Draw_0` |
| 敏捷额外减伤 2%/点 | `table_attributes_rebalance_agility.asm` |
| 宝箱奖励翻倍 | `c_container_Other_13` |

### 区块 2: 物品与附魔系统 (QoLEnhanced.Enchantment.cs)

| 功能 | 涉及文件 |
|------|---------|
| 物品稀有度文本本地化 | `table_text_prefix.asm` |
| 附魔品质文本本地化 | `table_text_rarity.asm` |
| 文本数组扩容 | `table_text` |
| 附魔生成逻辑优化 | `o_skill_enchantment_Other_11_instead.gml` |
| 附魔核心脚本注入 | `_scr_init_weapon_prefixes.gml`, `scr_weapon_generation.gml`, `scr_weapon_prefix_generation.gml`, `scr_weapon_generation_prefix_search.gml` |
| 附魔条件限制 | `o_skill_enchantment_Other_20` |
| 史诗品质背景色 | `scr_qualityBgDraw` |

### 区块 3: 时间系统与快捷键 (QoLEnhanced.TimeAndHotkeys.cs)

| 功能 | 涉及文件 |
|------|---------|
| 日志时间戳 | `scr_actionsLog` |
| 自动寻路系统 | `_scr_*` 7个文件, `o_globalmapMarkUserContext_Other_25`, `o_player_Create_0`, `o_player_Other_17`, `scr_stop_player` |
| 等级/AP/SP 修改 | `o_player_Step_0_levelup.asm`, `o_player_Step_0_instead.asm`, `o_player_Step_0_insert.asm` |
| 本地化文本注入 | `table_log` |
| F2 前往标记点 | `o_player_KeyPress_113.gml` |
| F3 打开马车仓库 | `o_player_KeyPress_114.gml` |
| F5 快速存档 | `o_player_KeyPress_116.gml` |
| F9 去除迷雾 | `o_player_KeyPress_120.gml` |
| 人类祈祷永久持续+阶段增益 | `o_b_bless_Create_0`, `o_b_bless_Alarm_2`, `o_b_bless_Other_10` |
| 星盘夜视 | `o_inv_nikos_astrolabe_Other_24` |
| 马车调度 1.5 天 | `scr_caravanSettingsGetDispatchTime` |
| 精神焕发翻倍 | `o_sleepController_Other_10` |
| 时刻机警强化 | `table_skills_rebalance_lightning_reflexes.asm` |

### 区块 4: 角色机制与开局优化 (QoLEnhanced.CharacterMechanics.cs)

| 功能 | 涉及文件 |
|------|---------|
| 野性狩猎全局生效 | `o_perks_Create_0.gml` |
| 野性狩猎效果强化 | 5个状态检查脚本 |
| 移除野性狩猎硬性判定 | `o_pass_skill_resourcefulness_Alarm_4` |
| 全角色开局希尔达饰品 | 7个角色 Create 事件 |
| 骨器猎获数值强化 | `scr_consum_hilda_enchant_assign.gml`, `scr_cook_check_raw_ingredients` |
| 开局获得 DLC 物品 | `o_player_chest_Alarm_1` |
| 阿娜天赋加成提升 | `o_perk_vow_feat_Create_0`, `table_skills_rebalance_vow_feat.asm` |
| 约娜天赋击杀免费回合 | `scr_allturn.gml`, `table_skills_rebalance_magical_erudition.asm` |

### 区块 5: 技能与战斗平衡 (QoLEnhanced.SkillsAndCombat.cs)

| 子区块 | 涉及技能 | 关键文件 |
|--------|---------|---------|
| 5.1 主动技能 | 掌握主动、准备就绪、招架 | `o_skill_seize_the_initiative_*`, `o_pass_skill_preparation_*`, `o_b_riposte_*` |
| 5.2 范围控制 | 战吼 | `table_skills_stats`, `o_war_cry_birth_Other_10`, `o_war_cry_impact_Other_11` |
| 5.3 被动技能 | 正中目标、自我修复、远近兼攻、冲刺训练 | `o_pass_skill_right_on_target_Other_17.gml`, `table_skills_rebalance_self_repair.asm`, `table_skills_rebalance_thrift.asm`, `table_skills_rebalance_sprint_training.asm` |
| 5.4 斩杀终结 | 最后一击、搏命 | `table_skills_stats`, `o_skill_finisher_*`, `o_pass_skill_last_effort_Other_17.gml` |
| 5.5 支援技能 | 叫喊 | `o_shout_Other_12` |
| 5.6 属性防御 | 免疫上限 125→1000 | `scr_immunity_change` |
| 5.7 武器装备 | 远程双持重做、双手武器单持、双持惩罚移除、暴击范围、格挡损耗 | `_scr_do_shoot.gml`, `_scr_extract_crossbow_bolt.gml`, `_scr_fire_bow_once.gml`, `_scr_get_weapon_hand_types.gml`, `scr_is_ammo_exist.gml`, `scr_throw.gml`, `scr_crossbow_insert_bolt.gml`, `scr_crossbow_reject_bolt.gml`, `scr_inv_weapon_get_hands.gml`, `table_skills_rebalance_taking_aim.asm` |
| 5.8 修补收集 | 剥皮强化 100% | `o_flaying_Other_10` |
| 5.9 Alt 键详情 | 按 Alt 显示详细技能信息 | `o_hoverSkill_Other_20.gml`, `o_hoverRender_Step_2.gml` |
| 5.10 连锁闪电修复 | 连续释放传导失效修复、动态传导上限 | `o_skill_chain_lightning_Other_17.gml`, `table_skills_rebalance_chain_lightning.asm` |
| 5.11 残余电荷强化 | Shock_Resistance 衰减 + 暴击强化分支 | `o_pass_skill_residual_charge_Other_17.gml`, `o_skill_electromancy_Other_15.gml`, `table_skills_rebalance_residual_charge.asm` |

### 区块 6: 魔法系统平衡 (已合并至 SkillsAndCombat.cs 5.12)

| 功能 | 涉及文件 |
|------|---------|
| 移除派系魔法互斥惩罚 | 4个魔法派系的 `Other_15` 事件 |

### 区块 7: 消耗品与工具强化 (QoLEnhanced.Consumables.cs)

| 功能 | 变更 |
|------|------|
| 撬棍 | 耐久 50→100, 损耗 40→20 |
| 维修工具 | 次数 5→15 |
| 药膏 / 绷带 / 夹板 / 灵药 | 次数大幅提升 |
| 水囊 | 次数 6→20 |
| 涤魂圣杯 | 次数 1→20 |
| 卷轴系统 | 辨识/附魔/褪魔卷轴 8 次+次数显示 |
| 加盐保鲜 | Fresh 值 x1000 |
| 大篷车保鲜 | 腐败速度 x0.001 |
| 食物新鲜度显示 | 24h 内切换为小时显示 |

### 区块 8: 经济系统优化 (QoLEnhanced.Economy.cs)

| 功能 | 涉及文件 |
|------|---------|
| 统一商人定价 | `o_NPC_Create_0_Price.gml` |
| 商人基础金币 +1500 | `scr_npc_gold_init` |
| 大篷车随从强化 | `o_npc_darrel_caravan_Create_0.gml` |
| 马车夫强化 | `o_npc_tott_Create_0.gml` |
| 传送系统 | `o_globalmapTP_Create_0.gml`, `o_globalmapTP_Other_10.gml`, `o_globalmap_Other_10`, `o_globalmapMarkUserContext_Other_25` |

### 区块 9: 背包与仓库 UI (QoLEnhanced.InventoryUI.cs)

| 功能 | 涉及文件 |
|------|---------|
| 交易界面扩容 | `o_trade_inventory_Create_0` |
| 仓库界面扩容 | `o_stash_inventory_Create_0` |
| 背包扩容 (11x12) | `o_inventory_Create_0` |
| UI 贴图替换 (720p) | 4个 inventory 对象 |

### 区块 10: 堆叠系统优化 (QoLEnhanced.Stacking.cs)

| 功能 | 变更 |
|------|------|
| 金币堆叠 | 100→1000 |
| 钱袋堆叠 | 2000→20000 |
| 古钱币堆叠 | 50→1000 |
| 弹药堆叠 | 20→100 + 贴图重算 |
| 投石索弹药 | 10→100 |

### 区块 11: 属性上限与战斗公式 (QoLEnhanced.AttributeCaps.cs)

| 功能 | 涉及文件 |
|------|---------|
| 属性计算上限提升 | `scr_atr_calc.gml`, `scr_atr_calc_combat.gml` |
| 技能冷却上限解除 | `o_skill_Other_17` |
| 属性提升 UI 上限至 100 | `o_attribute_button_Step_2`, `o_character_attribute_Step_2` |

---
