# QoLEnhanced 0.9.4.23 Injection Impact Audit

This document inventories original-game GML payloads and C# injection targets, then cross-checks them against the 0.9.4.23 size-diff set.

- Original-game `Codes/*.gml` payloads, excluding `_*.gml` and `debug.gml`: 132
- Unique C# / payload target records: 326
- Targets whose decompiled source size changed/added/removed in 0.9.4.23: 24

| Target | Kind | Source | Method | Changed In 0.9.4.23 | Risk | Anchor |
|---|---|---|---|---|---|---|
| `gml_GlobalScript_scr_actionsLog` | Code | `Codes/gml_GlobalScript_scr_actionsLog.gml` | Codes original-gml payload | no_size_change_or_not_found | low-static-risk | `` |
| `gml_GlobalScript_scr_actionsLog` | Code | `QoLEnhanced.TimeAndHotkeys.cs` | SetStringGMLInFile | no_size_change_or_not_found | low-static-risk | `` |
| `gml_GlobalScript_scr_allturn` | Code | `Codes/gml_GlobalScript_scr_allturn.gml` | Codes original-gml payload | no_size_change_or_not_found | low-static-risk | `` |
| `gml_GlobalScript_scr_allturn` | Code | `QoLEnhanced.SkillsAndCombat.cs` | SetStringGMLInFile | no_size_change_or_not_found | low-static-risk | `` |
| `gml_GlobalScript_scr_atr_calc` | Code | `Codes/gml_GlobalScript_scr_atr_calc.gml` | Codes original-gml payload | changed_size delta=-135 | changed-target-review | `` |
| `gml_GlobalScript_scr_atr_calc` | Code | `QoLEnhanced.AttributeCaps.cs` | SetStringGMLInFile | changed_size delta=-135 | full-replacement-review | `` |
| `gml_GlobalScript_scr_atr_calc_combat` | Code | `Codes/gml_GlobalScript_scr_atr_calc_combat.gml` | Codes original-gml payload | no_size_change_or_not_found | low-static-risk | `` |
| `gml_GlobalScript_scr_atr_calc_combat` | Code | `QoLEnhanced.AttributeCaps.cs` | SetStringGMLInFile | no_size_change_or_not_found | low-static-risk | `` |
| `gml_GlobalScript_scr_attack` | Code | `QoLEnhanced.SkillsAndCombat.cs` | LoadGML Match/InsertBelow | changed_size delta=-93 | anchor-review | `_isFumbleDodge = false` |
| `gml_GlobalScript_scr_attack_result_crit_aoe` | Code | `Codes/gml_GlobalScript_scr_attack_result_crit_aoe.gml` | Codes original-gml payload | no_size_change_or_not_found | low-static-risk | `` |
| `gml_GlobalScript_scr_attack_result_crit_aoe` | Code | `QoLEnhanced.SkillsAndCombat.cs` | SetStringGMLInFile | no_size_change_or_not_found | low-static-risk | `` |
| `gml_GlobalScript_scr_caravanSettingsGetDispatchTime` | Code | `Codes/gml_GlobalScript_scr_caravanSettingsGetDispatchTime.gml` | Codes original-gml payload | no_size_change_or_not_found | low-static-risk | `` |
| `gml_GlobalScript_scr_caravanSettingsGetDispatchTime` | Code | `QoLEnhanced.TimeAndHotkeys.cs` | SetStringGMLInFile | no_size_change_or_not_found | low-static-risk | `` |
| `gml_GlobalScript_scr_characterMapInit` | Code | `QoLEnhanced.GlobalConfig.cs` | LoadGML Match/ReplaceBy | no_size_change_or_not_found | low-static-risk | `ds_map_add(global.characterDataMap, \"AP\", 0)` |
| `gml_GlobalScript_scr_consum_char_add` | Code | `QoLEnhanced.Consumables.cs` | LoadGML Match/ReplaceBy | no_size_change_or_not_found | low-static-risk | `ds_map_set(data, \"Fresh\"` |
| `gml_GlobalScript_scr_consum_food_change` | Code | `Codes/gml_GlobalScript_scr_consum_food_change.gml` | Codes original-gml payload | no_size_change_or_not_found | low-static-risk | `` |
| `gml_GlobalScript_scr_consum_food_change` | Code | `QoLEnhanced.Consumables.cs` | SetStringGMLInFile | no_size_change_or_not_found | low-static-risk | `` |
| `gml_GlobalScript_scr_consum_hilda_enchant_assign` | Code | `Codes/gml_GlobalScript_scr_consum_hilda_enchant_assign.gml` | Codes original-gml payload | no_size_change_or_not_found | low-static-risk | `` |
| `gml_GlobalScript_scr_consum_hilda_enchant_assign` | Code | `QoLEnhanced.CharacterMechanics.cs` | SetStringGMLInFile | no_size_change_or_not_found | low-static-risk | `` |
| `gml_GlobalScript_scr_cook_check_raw_ingredients` | Assembly | `QoLEnhanced.CharacterMechanics.cs` | LoadAssemblyAsString Match/ReplaceBy | no_size_change_or_not_found | low-static-risk | `:[92]` |
| `gml_GlobalScript_scr_crit_death` | Code | `QoLEnhanced.CharacterMechanics.cs` | LoadGML Match/InsertBelow | no_size_change_or_not_found | low-static-risk | `is_crit_magic_death = true` |
| `gml_GlobalScript_scr_crossbow_insert_bolt` | Code | `Codes/gml_GlobalScript_scr_crossbow_insert_bolt.gml` | Codes original-gml payload | no_size_change_or_not_found | low-static-risk | `` |
| `gml_GlobalScript_scr_crossbow_insert_bolt` | Code | `QoLEnhanced.SkillsAndCombat.cs` | SetStringGMLInFile | no_size_change_or_not_found | low-static-risk | `` |
| `gml_GlobalScript_scr_crossbow_is_armed` | Code | `Codes/gml_GlobalScript_scr_crossbow_is_armed.gml` | Codes original-gml payload | no_size_change_or_not_found | low-static-risk | `` |
| `gml_GlobalScript_scr_crossbow_is_armed` | Code | `QoLEnhanced.SkillsAndCombat.cs` | SetStringGMLInFile | no_size_change_or_not_found | low-static-risk | `` |
| `gml_GlobalScript_scr_crossbow_reject_bolt` | Code | `Codes/gml_GlobalScript_scr_crossbow_reject_bolt.gml` | Codes original-gml payload | no_size_change_or_not_found | low-static-risk | `` |
| `gml_GlobalScript_scr_crossbow_reject_bolt` | Code | `QoLEnhanced.SkillsAndCombat.cs` | SetStringGMLInFile | no_size_change_or_not_found | low-static-risk | `` |
| `gml_GlobalScript_scr_dungeonHasSecretRoom` | Code | `Codes/gml_GlobalScript_scr_dungeonHasSecretRoom.gml` | Codes original-gml payload | no_size_change_or_not_found | low-static-risk | `` |
| `gml_GlobalScript_scr_dungeonHasSecretRoom` | Code | `QoLEnhanced.GlobalConfig.cs` | SetStringGMLInFile | no_size_change_or_not_found | low-static-risk | `` |
| `gml_GlobalScript_scr_dungeonSetSettings` | Code | `QoLEnhanced.GlobalConfig.cs` | LoadGML Match/ReplaceBy | no_size_change_or_not_found | low-static-risk | `_settings.LightColor = (_settings.CurrentFloor == 1 ? [72,` |
| `gml_GlobalScript_scr_duration_decrese` | Code | `Codes/gml_GlobalScript_scr_duration_decrese.gml` | Codes original-gml payload | no_size_change_or_not_found | low-static-risk | `` |
| `gml_GlobalScript_scr_duration_decrese` | Code | `QoLEnhanced.SkillsAndCombat.cs` | SetStringGMLInFile | no_size_change_or_not_found | low-static-risk | `` |
| `gml_GlobalScript_scr_fatigue_check` | Code | `Codes/gml_GlobalScript_scr_fatigue_check.gml` | Codes original-gml payload | no_size_change_or_not_found | low-static-risk | `` |
| `gml_GlobalScript_scr_fatigue_check` | Code | `QoLEnhanced.CharacterMechanics.cs` | SetStringGMLInFile | no_size_change_or_not_found | low-static-risk | `` |
| `gml_GlobalScript_scr_global_turn` | Code | `Codes/gml_GlobalScript_scr_global_turn.gml` | Codes original-gml payload | no_size_change_or_not_found | low-static-risk | `` |
| `gml_GlobalScript_scr_global_turn` | Code | `QoLEnhanced.SkillsAndCombat.cs` | SetStringGMLInFile | no_size_change_or_not_found | low-static-risk | `` |
| `gml_GlobalScript_scr_guiControllerCreate` | Code | `QoLEnhanced.InventoryUI.cs` | LoadGML Match/InsertBelow | no_size_change_or_not_found | low-static-risk | `ds_list_add(global.guiInteractiveExcludedObjectsList,` |
| `gml_GlobalScript_scr_hoversGetEnchantedAttributes` | Code | `Codes/gml_GlobalScript_scr_hoversGetEnchantedAttributes.gml` | Codes original-gml payload | no_size_change_or_not_found | low-static-risk | `` |
| `gml_GlobalScript_scr_hoversGetEnchantedAttributes` | Code | `QoLEnhanced.CharacterMechanics.cs` | SetStringGMLInFile | no_size_change_or_not_found | low-static-risk | `` |
| `gml_GlobalScript_scr_hungercheck` | Code | `Codes/gml_GlobalScript_scr_hungercheck.gml` | Codes original-gml payload | no_size_change_or_not_found | low-static-risk | `` |
| `gml_GlobalScript_scr_hungercheck` | Code | `QoLEnhanced.CharacterMechanics.cs` | SetStringGMLInFile | no_size_change_or_not_found | low-static-risk | `` |
| `gml_GlobalScript_scr_immunity_change` | Code | `Codes/gml_GlobalScript_scr_immunity_change.gml` | Codes original-gml payload | no_size_change_or_not_found | low-static-risk | `` |
| `gml_GlobalScript_scr_immunity_change` | Code | `QoLEnhanced.SkillsAndCombat.cs` | SetStringGMLInFile | no_size_change_or_not_found | low-static-risk | `` |
| `gml_GlobalScript_scr_intoxication_check` | Code | `Codes/gml_GlobalScript_scr_intoxication_check.gml` | Codes original-gml payload | no_size_change_or_not_found | low-static-risk | `` |
| `gml_GlobalScript_scr_intoxication_check` | Code | `QoLEnhanced.CharacterMechanics.cs` | SetStringGMLInFile | no_size_change_or_not_found | low-static-risk | `` |
| `gml_GlobalScript_scr_inv_find_free_cell` | Code | `Codes/gml_GlobalScript_scr_inv_find_free_cell.gml` | Codes original-gml payload | no_size_change_or_not_found | low-static-risk | `` |
| `gml_GlobalScript_scr_inv_find_free_cell` | Code | `QoLEnhanced.Stacking.cs` | SetStringGMLInFile | no_size_change_or_not_found | low-static-risk | `` |
| `gml_GlobalScript_scr_inv_weapon_get_hands` | Code | `Codes/gml_GlobalScript_scr_inv_weapon_get_hands.gml` | Codes original-gml payload | no_size_change_or_not_found | low-static-risk | `` |
| `gml_GlobalScript_scr_inv_weapon_get_hands` | Code | `QoLEnhanced.SkillsAndCombat.cs` | SetStringGMLInFile | no_size_change_or_not_found | low-static-risk | `` |
| `gml_GlobalScript_scr_inventory_stack` | Code | `Codes/gml_GlobalScript_scr_inventory_stack.gml` | Codes original-gml payload | no_size_change_or_not_found | low-static-risk | `` |
| `gml_GlobalScript_scr_inventory_stack` | Code | `QoLEnhanced.Stacking.cs` | SetStringGMLInFile | no_size_change_or_not_found | low-static-risk | `` |
| `gml_GlobalScript_scr_is_ammo_exist` | Code | `Codes/gml_GlobalScript_scr_is_ammo_exist.gml` | Codes original-gml payload | no_size_change_or_not_found | low-static-risk | `` |
| `gml_GlobalScript_scr_is_ammo_exist` | Code | `QoLEnhanced.SkillsAndCombat.cs` | SetStringGMLInFile | no_size_change_or_not_found | low-static-risk | `` |
| `gml_GlobalScript_scr_item_select_cell_find_nearest` | Code | `Codes/gml_GlobalScript_scr_item_select_cell_find_nearest.gml` | Codes original-gml payload | no_size_change_or_not_found | low-static-risk | `` |
| `gml_GlobalScript_scr_item_select_cell_find_nearest` | Code | `QoLEnhanced.InventoryUI.cs` | SetStringGMLInFile | no_size_change_or_not_found | low-static-risk | `` |
| `gml_GlobalScript_scr_item_stack_build` | Code | `Codes/gml_GlobalScript_scr_item_stack_build.gml` | Codes original-gml payload | no_size_change_or_not_found | low-static-risk | `` |
| `gml_GlobalScript_scr_item_stack_build` | Code | `QoLEnhanced.Stacking.cs` | SetStringGMLInFile | no_size_change_or_not_found | low-static-risk | `` |
| `gml_GlobalScript_scr_morale_reduce` | Code | `QoLEnhanced.SkillsAndCombat.cs` | LoadGML Match/InsertBelow | no_size_change_or_not_found | low-static-risk | `argument0 *= (argument1.morale_factor / 100)` |
| `gml_GlobalScript_scr_npc_gold_init` | Code | `QoLEnhanced.Economy.cs` | LoadGML Match/ReplaceBy | no_size_change_or_not_found | low-static-risk | `Gold_Amount_Base` |
| `gml_GlobalScript_scr_paincheck` | Code | `Codes/gml_GlobalScript_scr_paincheck.gml` | Codes original-gml payload | no_size_change_or_not_found | low-static-risk | `` |
| `gml_GlobalScript_scr_paincheck` | Code | `QoLEnhanced.CharacterMechanics.cs` | SetStringGMLInFile | no_size_change_or_not_found | low-static-risk | `` |
| `gml_GlobalScript_scr_param` | Code | `QoLEnhanced.GlobalConfig.cs` | LoadGML Match/InsertAbove | changed_size delta=63 | anchor-review | `var _needChange = argument1` |
| `gml_GlobalScript_scr_playerSpriteArrayDraw` | Code | `Codes/gml_GlobalScript_scr_playerSpriteArrayDraw.gml` | Codes original-gml payload | no_size_change_or_not_found | low-static-risk | `` |
| `gml_GlobalScript_scr_playerSpriteArrayDraw` | Code | `QoLEnhanced.SkillsAndCombat.cs` | SetStringGMLInFile | no_size_change_or_not_found | low-static-risk | `` |
| `gml_GlobalScript_scr_playerSpriteArrayUpdate` | Code | `Codes/gml_GlobalScript_scr_playerSpriteArrayUpdate.gml` | Codes original-gml payload | no_size_change_or_not_found | low-static-risk | `` |
| `gml_GlobalScript_scr_playerSpriteArrayUpdate` | Code | `QoLEnhanced.SkillsAndCombat.cs` | SetStringGMLInFile | no_size_change_or_not_found | low-static-risk | `` |
| `gml_GlobalScript_scr_playerSpriteInit` | Code | `Codes/gml_GlobalScript_scr_playerSpriteInit.gml` | Codes original-gml payload | changed_size delta=4 | changed-target-review | `` |
| `gml_GlobalScript_scr_playerSpriteInit` | Code | `QoLEnhanced.SkillsAndCombat.cs` | SetStringGMLInFile | changed_size delta=4 | full-replacement-review | `` |
| `gml_GlobalScript_scr_playerSpritePartsUpdate` | Code | `Codes/gml_GlobalScript_scr_playerSpritePartsUpdate.gml` | Codes original-gml payload | changed_size delta=9 | changed-target-review | `` |
| `gml_GlobalScript_scr_playerSpritePartsUpdate` | Code | `QoLEnhanced.SkillsAndCombat.cs` | SetStringGMLInFile | changed_size delta=9 | full-replacement-review | `` |
| `gml_GlobalScript_scr_playerSpriteUpdate` | Code | `Codes/gml_GlobalScript_scr_playerSpriteUpdate.gml` | Codes original-gml payload | changed_size delta=35 | changed-target-review | `` |
| `gml_GlobalScript_scr_playerSpriteUpdate` | Code | `QoLEnhanced.SkillsAndCombat.cs` | SetStringGMLInFile | changed_size delta=35 | full-replacement-review | `` |
| `gml_GlobalScript_scr_qualityBgDraw` | Code | `QoLEnhanced.Enchantment.cs` | LoadGML Match/InsertBelow | no_size_change_or_not_found | low-static-risk | `_colorTexture = make_color_rgb(34` |
| `gml_GlobalScript_scr_runic_boulder_get_hp` | Code | `Codes/gml_GlobalScript_scr_runic_boulder_get_hp.gml` | Codes original-gml payload | no_size_change_or_not_found | low-static-risk | `` |
| `gml_GlobalScript_scr_runic_boulder_get_hp` | Code | `QoLEnhanced.SkillsAndCombat.cs` | SetStringGMLInFile | no_size_change_or_not_found | low-static-risk | `` |
| `gml_GlobalScript_scr_sessionDataInit` | Code | `QoLEnhanced.GlobalConfig.cs` | LoadGML Match/InsertBelow | no_size_change_or_not_found | low-static-risk | `audio_sound_gain` |
| `gml_GlobalScript_scr_simple_damage` | Code | `QoLEnhanced.GlobalConfig.cs` | LoadGML Match/InsertBelow | no_size_change_or_not_found | low-static-risk | `scr_characterStatsUpdateMax(\"damageReceivedHighest\", _hit_dmg)` |
| `gml_GlobalScript_scr_skill_right_on_target` | Code | `QoLEnhanced.SkillsAndCombat.cs` | LoadGML Match/ReplaceBy | no_size_change_or_not_found | low-static-risk | `if (argument0 == 1)` |
| `gml_GlobalScript_scr_surfaceSpawnsDoc` | Code | `QoLEnhanced.GlobalConfig.cs` | LoadGML Match/InsertAbove | no_size_change_or_not_found | low-static-risk | `if (_enemyStringArray` |
| `gml_GlobalScript_scr_thirsty_check` | Code | `Codes/gml_GlobalScript_scr_thirsty_check.gml` | Codes original-gml payload | no_size_change_or_not_found | low-static-risk | `` |
| `gml_GlobalScript_scr_thirsty_check` | Code | `QoLEnhanced.CharacterMechanics.cs` | SetStringGMLInFile | no_size_change_or_not_found | low-static-risk | `` |
| `gml_GlobalScript_scr_throw` | Code | `Codes/gml_GlobalScript_scr_throw.gml` | Codes original-gml payload | no_size_change_or_not_found | low-static-risk | `` |
| `gml_GlobalScript_scr_throw` | Code | `QoLEnhanced.SkillsAndCombat.cs` | SetStringGMLInFile | no_size_change_or_not_found | low-static-risk | `` |
| `gml_GlobalScript_scr_trap_find` | Code | `Codes/gml_GlobalScript_scr_trap_find.gml` | Codes original-gml payload | changed_size delta=69 | changed-target-review | `` |
| `gml_GlobalScript_scr_trap_find` | Code | `QoLEnhanced.GlobalConfig.cs` | SetStringGMLInFile | changed_size delta=69 | full-replacement-review | `` |
| `gml_GlobalScript_scr_unitTurnNext` | Code | `Codes/gml_GlobalScript_scr_unitTurnNext.gml` | Codes original-gml payload | no_size_change_or_not_found | low-static-risk | `` |
| `gml_GlobalScript_scr_unitTurnNext` | Code | `QoLEnhanced.SkillsAndCombat.cs` | SetStringGMLInFile | no_size_change_or_not_found | low-static-risk | `` |
| `gml_GlobalScript_scr_weapon_generation` | Code | `Codes/gml_GlobalScript_scr_weapon_generation.gml` | Codes original-gml payload | no_size_change_or_not_found | low-static-risk | `` |
| `gml_GlobalScript_scr_weapon_generation` | Code | `QoLEnhanced.Enchantment.cs` | SetStringGMLInFile | no_size_change_or_not_found | low-static-risk | `` |
| `gml_GlobalScript_scr_weapon_generation_prefix_search` | Code | `Codes/gml_GlobalScript_scr_weapon_generation_prefix_search.gml` | Codes original-gml payload | no_size_change_or_not_found | low-static-risk | `` |
| `gml_GlobalScript_scr_weapon_generation_prefix_search` | Code | `QoLEnhanced.Enchantment.cs` | SetStringGMLInFile | no_size_change_or_not_found | low-static-risk | `` |
| `gml_GlobalScript_scr_weapon_prefix_generation` | Code | `Codes/gml_GlobalScript_scr_weapon_prefix_generation.gml` | Codes original-gml payload | no_size_change_or_not_found | low-static-risk | `` |
| `gml_GlobalScript_scr_weapon_prefix_generation` | Code | `QoLEnhanced.Enchantment.cs` | SetStringGMLInFile | no_size_change_or_not_found | low-static-risk | `` |
| `gml_GlobalScript_table_surface_spawn` | Code | `Codes/gml_GlobalScript_table_surface_spawn.gml` | Codes original-gml payload | no_size_change_or_not_found | low-static-risk | `` |
| `gml_GlobalScript_table_surface_spawn` | Code | `QoLEnhanced.GlobalConfig.cs` | SetStringGMLInFile | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_c_container_Other_13` | Code | `QoLEnhanced.GlobalConfig.cs` | LoadGML Match/InsertBelow | no_size_change_or_not_found | low-static-risk | `randomize()` |
| `gml_Object_c_ore_parent_Other_10` | Code | `Codes/gml_Object_c_ore_parent_Other_10.gml` | Codes original-gml payload | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_c_ore_parent_Other_10` | Code | `QoLEnhanced.GlobalConfig.cs` | SetStringGMLInFile | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_NPC_Create_0` | Code | `QoLEnhanced.Economy.cs` | LoadGML Match/ReplaceBy | no_size_change_or_not_found | low-static-risk | `Buying_Tier` |
| `gml_Object_o_NPC_Create_0_Price` | Code | `Codes/gml_Object_o_NPC_Create_0_Price.gml` | Codes original-gml payload | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_arrow_Alarm_1` | Code | `Codes/gml_Object_o_arrow_Alarm_1.gml` | Codes original-gml payload | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_arrow_Alarm_1` | Code | `QoLEnhanced.cs` | AddNewEvent o_arrow | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_attribute_button_Step_2` | Code | `QoLEnhanced.AttributeCaps.cs` | LoadGML Match/ReplaceBy | no_size_change_or_not_found | low-static-risk | `if (scr_atr` |
| `gml_Object_o_b_bless_Alarm_2` | Code | `Codes/gml_Object_o_b_bless_Alarm_2.gml` | Codes original-gml payload | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_b_bless_Alarm_2` | Code | `QoLEnhanced.TimeAndHotkeys.cs` | SetStringGMLInFile | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_b_bless_Create_0` | Code | `Codes/gml_Object_o_b_bless_Create_0.gml` | Codes original-gml payload | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_b_bless_Create_0` | Code | `QoLEnhanced.TimeAndHotkeys.cs` | SetStringGMLInFile | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_b_bless_Other_10` | Code | `Codes/gml_Object_o_b_bless_Other_10.gml` | Codes original-gml payload | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_b_bless_Other_10` | Code | `QoLEnhanced.TimeAndHotkeys.cs` | SetStringGMLInFile | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_b_bless_elf_Alarm_2` | Code | `Codes/gml_Object_o_b_bless_elf_Alarm_2.gml` | Codes original-gml payload | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_b_bless_elf_Alarm_2` | Code | `QoLEnhanced.TimeAndHotkeys.cs` | SetStringGMLInFile | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_b_bless_elf_Create_0` | Code | `Codes/gml_Object_o_b_bless_elf_Create_0.gml` | Codes original-gml payload | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_b_bless_elf_Create_0` | Code | `QoLEnhanced.TimeAndHotkeys.cs` | SetStringGMLInFile | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_b_bless_elf_Other_10` | Code | `Codes/gml_Object_o_b_bless_elf_Other_10.gml` | Codes original-gml payload | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_b_bless_elf_Other_10` | Code | `QoLEnhanced.TimeAndHotkeys.cs` | SetStringGMLInFile | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_b_bless_elf_Other_15` | Code | `Codes/gml_Object_o_b_bless_elf_Other_15.gml` | Codes original-gml payload | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_b_bless_elf_Other_15` | Code | `QoLEnhanced.TimeAndHotkeys.cs` | AddNewEvent o_b_bless_elf | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_b_clearsight_Alarm_2` | Code | `Codes/gml_Object_o_b_clearsight_Alarm_2.gml` | Codes original-gml payload | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_b_clearsight_Alarm_2` | Code | `QoLEnhanced.TimeAndHotkeys.cs` | SetStringGMLInFile | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_b_residual_charge_Create_0` | Code | `QoLEnhanced.SkillsAndCombat.cs` | LoadGML Match/ReplaceBy | no_size_change_or_not_found | low-static-risk | `max_duration` |
| `gml_Object_o_b_riposte_Alarm_0` | Code | `Codes/gml_Object_o_b_riposte_Alarm_0.gml` | Codes original-gml payload | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_b_riposte_Alarm_0` | Code | `QoLEnhanced.cs` | AddNewEvent o_b_riposte | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_b_riposte_Create_0` | Code | `Codes/gml_Object_o_b_riposte_Create_0.gml` | Codes original-gml payload | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_b_riposte_Create_0` | Code | `QoLEnhanced.SkillsAndCombat.cs` | SetStringGMLInFile | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_b_riposte_Other_13` | Code | `Codes/gml_Object_o_b_riposte_Other_13.gml` | Codes original-gml payload | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_b_riposte_Other_13` | Code | `QoLEnhanced.SkillsAndCombat.cs` | SetStringGMLInFile | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_b_taking_aim_Create_0` | Code | `QoLEnhanced.SkillsAndCombat.cs` | LoadGML Match/ReplaceBy | no_size_change_or_not_found | low-static-risk | `max_duration` |
| `gml_Object_o_ball_lightning_Other_10` | Code | `QoLEnhanced.SkillsAndCombat.cs` | LoadGML Match/InsertBelow | changed_size delta=-40 | anchor-review | `Shock_Damage = _shock_damage` |
| `gml_Object_o_chain_lightning_Collision_o_unit` | Code | `QoLEnhanced.SkillsAndCombat.cs` | LoadGML Match/ReplaceBy | no_size_change_or_not_found | low-static-risk | `if (point_distance` |
| `gml_Object_o_chain_lightning_Other_10` | Code | `Codes/gml_Object_o_chain_lightning_Other_10.gml` | Codes original-gml payload | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_chain_lightning_Other_10` | Code | `QoLEnhanced.SkillsAndCombat.cs` | SetStringGMLInFile | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_characterBottomContainer_Other_10` | Code | `QoLEnhanced.AttributeCaps.cs` | LoadGML Match/InsertBelow | no_size_change_or_not_found | low-static-risk | `scr_param_list_add(\"Hit_Chance\", _hitChance)` |
| `gml_Object_o_character_attribute_Step_2` | Code | `QoLEnhanced.AttributeCaps.cs` | LoadGML Match/ReplaceBy | no_size_change_or_not_found | low-static-risk | `if (scr_atr` |
| `gml_Object_o_character_panel_mask_Draw_0` | Code | `QoLEnhanced.GlobalConfig.cs` | LoadGML Match/ReplaceBy | no_size_change_or_not_found | low-static-risk | `var _maxLevel = scr_atr(\"LVL\") == 30` |
| `gml_Object_o_db_dual_wielding_Create_0` | Code | `Codes/gml_Object_o_db_dual_wielding_Create_0.gml` | Codes original-gml payload | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_db_dual_wielding_Create_0` | Code | `QoLEnhanced.SkillsAndCombat.cs` | SetStringGMLInFile | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_db_dual_wielding_Other_10` | Code | `Codes/gml_Object_o_db_dual_wielding_Other_10.gml` | Codes original-gml payload | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_db_dual_wielding_Other_10` | Code | `QoLEnhanced.SkillsAndCombat.cs` | SetStringGMLInFile | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_db_impulse_Alarm_4` | Code | `Codes/gml_Object_o_db_impulse_Alarm_4.gml` | Codes original-gml payload | changed_size delta=154 | changed-target-review | `` |
| `gml_Object_o_db_impulse_Alarm_4` | Code | `QoLEnhanced.SkillsAndCombat.cs` | SetStringGMLInFile | changed_size delta=154 | full-replacement-review | `` |
| `gml_Object_o_db_ini_lost_Other_13` | Code | `Codes/gml_Object_o_db_ini_lost_Other_13.gml` | Codes original-gml payload | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_db_ini_lost_Other_13` | Code | `QoLEnhanced.SkillsAndCombat.cs` | SetStringGMLInFile | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_discharge_Other_10` | Code | `Codes/gml_Object_o_discharge_Other_10.gml` | Codes original-gml payload | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_discharge_Other_10` | Code | `QoLEnhanced.SkillsAndCombat.cs` | SetStringGMLInFile | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_discharge_Other_11` | Code | `Codes/gml_Object_o_discharge_Other_11.gml` | Codes original-gml payload | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_discharge_Other_11` | Code | `QoLEnhanced.SkillsAndCombat.cs` | SetStringGMLInFile | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_distracting_shot_Alarm_0` | Code | `Codes/gml_Object_o_distracting_shot_Alarm_0.gml` | Codes original-gml payload | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_distracting_shot_Alarm_0` | Code | `QoLEnhanced.SkillsAndCombat.cs` | SetStringGMLInFile | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_enemy_Create_0` | Code | `QoLEnhanced.cs` | LoadGML Match/InsertBelow | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_enemy_Destroy_0` | Assembly | `QoLEnhanced.GlobalConfig.cs` | LoadAssemblyAsString Match/ReplaceBy | no_size_change_or_not_found | low-static-risk | `pop.v.v local._lvl` |
| `gml_Object_o_enemy_Mouse_4` | Code | `Codes/gml_Object_o_enemy_Mouse_4.gml` | Codes original-gml payload | changed_size delta=146 | changed-target-review | `` |
| `gml_Object_o_enemy_Mouse_4` | Code | `QoLEnhanced.SkillsAndCombat.cs` | SetStringGMLInFile | changed_size delta=146 | full-replacement-review | `` |
| `gml_Object_o_enemy_healthbar_Create_0` | Code | `Codes/gml_Object_o_enemy_healthbar_Create_0.gml` | Codes original-gml payload | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_enemy_healthbar_Destroy_0` | Code | `Codes/gml_Object_o_enemy_healthbar_Destroy_0.gml` | Codes original-gml payload | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_enemy_healthbar_Draw_0` | Code | `Codes/gml_Object_o_enemy_healthbar_Draw_0.gml` | Codes original-gml payload | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_enemy_healthbar_Step_0` | Code | `Codes/gml_Object_o_enemy_healthbar_Step_0.gml` | Codes original-gml payload | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_enemy_healthbar_Step_2` | Code | `Codes/gml_Object_o_enemy_healthbar_Step_2.gml` | Codes original-gml payload | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_exploreMenu_Step_0` | Code | `Codes/gml_Object_o_exploreMenu_Step_0.gml` | Codes original-gml payload | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_exploreMenu_Step_0` | Code | `QoLEnhanced.SkillsAndCombat.cs` | AddNewEvent o_exploreMenu | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_exploreRender_Other_20` | Code | `Codes/gml_Object_o_exploreRender_Other_20.gml` | Codes original-gml payload | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_exploreRender_Other_20` | Code | `QoLEnhanced.SkillsAndCombat.cs` | SetStringGMLInFile | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_exploreRender_Other_21` | Code | `Codes/gml_Object_o_exploreRender_Other_21.gml` | Codes original-gml payload | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_exploreRender_Other_21` | Code | `QoLEnhanced.SkillsAndCombat.cs` | SetStringGMLInFile | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_finisher_Alarm_0` | Code | `Codes/gml_Object_o_finisher_Alarm_0.gml` | Codes original-gml payload | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_finisher_Alarm_0` | Code | `QoLEnhanced.SkillsAndCombat.cs` | SetStringGMLInFile | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_flaying_Other_10` | Code | `QoLEnhanced.SkillsAndCombat.cs` | LoadGML Match/ReplaceBy | no_size_change_or_not_found | low-static-risk | `Pelt_Durability +=` |
| `gml_Object_o_flaying_Other_10` | Code | `QoLEnhanced.SkillsAndCombat.cs` | LoadGML Match/ReplaceBy | no_size_change_or_not_found | low-static-risk | `if ((_resorcefullness` |
| `gml_Object_o_globalmapMarkUserContext_Other_25` | Code | `QoLEnhanced.Economy.cs` | LoadGML Match/InsertAbove | no_size_change_or_not_found | low-static-risk | `var _mark = scr_globalmapMarkCreate` |
| `gml_Object_o_globalmapMarkUserContext_Other_25` | Code | `QoLEnhanced.TimeAndHotkeys.cs` | LoadGML Match/InsertAbove | no_size_change_or_not_found | low-static-risk | `var _mark = scr_globalmapMarkCreate` |
| `gml_Object_o_globalmapTP_Create_0` | Code | `Codes/gml_Object_o_globalmapTP_Create_0.gml` | Codes original-gml payload | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_globalmapTP_Other_10` | Code | `Codes/gml_Object_o_globalmapTP_Other_10.gml` | Codes original-gml payload | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_globalmap_Other_10` | Code | `QoLEnhanced.Economy.cs` | LoadGML Match/InsertAbove | no_size_change_or_not_found | low-static-risk | `event_perform(ev_step, ev_step_begin)` |
| `gml_Object_o_hoverConsum_Other_20` | Code | `QoLEnhanced.Consumables.cs` | LoadGML Match/ReplaceBy | no_size_change_or_not_found | low-static-risk | `_fresh *=` |
| `gml_Object_o_hoverConsum_Other_20` | Code | `QoLEnhanced.Consumables.cs` | LoadGML Match/ReplaceBy | no_size_change_or_not_found | low-static-risk | `var _freshValue` |
| `gml_Object_o_hoverConsum_Other_20` | Code | `QoLEnhanced.Consumables.cs` | LoadGML Match/ReplaceBy | no_size_change_or_not_found | low-static-risk | `var _middleTextCharacter` |
| `gml_Object_o_hoverRender_Step_2` | Code | `Codes/gml_Object_o_hoverRender_Step_2.gml` | Codes original-gml payload | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_hoverRender_Step_2` | Code | `QoLEnhanced.SkillsAndCombat.cs` | SetStringGMLInFile | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_hoverSkill_Other_20` | Code | `Codes/gml_Object_o_hoverSkill_Other_20.gml` | Codes original-gml payload | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_hoverSkill_Other_20` | Code | `QoLEnhanced.SkillsAndCombat.cs` | SetStringGMLInFile | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_impulse_birth_Other_10` | Code | `Codes/gml_Object_o_impulse_birth_Other_10.gml` | Codes original-gml payload | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_impulse_birth_Other_10` | Code | `QoLEnhanced.SkillsAndCombat.cs` | SetStringGMLInFile | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_impulse_impact_Other_11` | Code | `Codes/gml_Object_o_impulse_impact_Other_11.gml` | Codes original-gml payload | changed_size delta=-12 | changed-target-review | `` |
| `gml_Object_o_impulse_impact_Other_11` | Code | `QoLEnhanced.SkillsAndCombat.cs` | SetStringGMLInFile | changed_size delta=-12 | full-replacement-review | `` |
| `gml_Object_o_inv_ammunition_parent_Create_0` | Code | `QoLEnhanced.Stacking.cs` | LoadGML Match/ReplaceBy | no_size_change_or_not_found | low-static-risk | `stack = 20` |
| `gml_Object_o_inv_aqua_vitae_Create_0` | Code | `QoLEnhanced.Consumables.cs` | LoadGML Match/ReplaceBy | changed_size delta=-20 | anchor-review | `charge = 1` |
| `gml_Object_o_inv_bandage_Create_0` | Code | `QoLEnhanced.Consumables.cs` | LoadGML Match/ReplaceBy | no_size_change_or_not_found | low-static-risk | `charge = 2` |
| `gml_Object_o_inv_cleansing_goblet_water_Create_0` | Code | `QoLEnhanced.Consumables.cs` | LoadGML Match/ReplaceBy | changed_size delta=-56 | anchor-review | `charge = 1` |
| `gml_Object_o_inv_gold_parent_Create_0` | Code | `QoLEnhanced.Stacking.cs` | LoadGML Match/ReplaceBy | no_size_change_or_not_found | low-static-risk | `event_inherited()` |
| `gml_Object_o_inv_gold_parent_Create_0` | Code | `QoLEnhanced.Stacking.cs` | LoadGML Match/ReplaceBy | no_size_change_or_not_found | low-static-risk | `stack_limit = 100` |
| `gml_Object_o_inv_moneybag_Create_0` | Code | `QoLEnhanced.Stacking.cs` | LoadGML Match/ReplaceBy | no_size_change_or_not_found | low-static-risk | `stack_limit = 2000` |
| `gml_Object_o_inv_nikos_astrolabe_Other_24` | Code | `Codes/gml_Object_o_inv_nikos_astrolabe_Other_24.gml` | Codes original-gml payload | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_inv_nikos_astrolabe_Other_24` | Code | `QoLEnhanced.TimeAndHotkeys.cs` | SetStringGMLInFile | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_inv_old_coin_Create_0` | Code | `QoLEnhanced.Stacking.cs` | LoadGML Match/ReplaceBy | no_size_change_or_not_found | low-static-risk | `stack_limit = 50` |
| `gml_Object_o_inv_repkit_Create_0` | Code | `QoLEnhanced.Consumables.cs` | LoadGML Match/ReplaceBy | no_size_change_or_not_found | low-static-risk | `charge = 5` |
| `gml_Object_o_inv_salve_Create_0` | Code | `QoLEnhanced.Consumables.cs` | LoadGML Match/ReplaceBy | no_size_change_or_not_found | low-static-risk | `charge = 3` |
| `gml_Object_o_inv_scroll_parent_Create_0` | Code | `QoLEnhanced.Consumables.cs` | LoadGML Match/ReplaceBy | no_size_change_or_not_found | low-static-risk | `identified = true` |
| `gml_Object_o_inv_shovel_Create_0` | Code | `QoLEnhanced.SkillsAndCombat.cs` | LoadGML Match/ReplaceBy | changed_size delta=2 | anchor-review | `hands = 2` |
| `gml_Object_o_inv_sling_ammo_parent_Create_0` | Code | `QoLEnhanced.Stacking.cs` | LoadGML Match/ReplaceBy | no_size_change_or_not_found | low-static-risk | `stack_limit = 10` |
| `gml_Object_o_inv_splint_Create_0` | Code | `QoLEnhanced.Consumables.cs` | LoadGML Match/ReplaceBy | no_size_change_or_not_found | low-static-risk | `charge = 1` |
| `gml_Object_o_inv_tinker_Create_0` | Code | `QoLEnhanced.Consumables.cs` | LoadGML Match/ReplaceBy | no_size_change_or_not_found | low-static-risk | `duration =` |
| `gml_Object_o_inv_wineskin_Create_0` | Code | `QoLEnhanced.Consumables.cs` | LoadGML Match/ReplaceBy | no_size_change_or_not_found | low-static-risk | `charge = 6` |
| `gml_Object_o_inventory_Create_0` | Code | `QoLEnhanced.InventoryUI.cs` | LoadGML Match/InsertBelow | no_size_change_or_not_found | low-static-risk | `is_start_equipment = false` |
| `gml_Object_o_inventory_Create_0` | Code | `QoLEnhanced.InventoryUI.cs` | LoadGML Match/ReplaceBy | no_size_change_or_not_found | low-static-risk | `itemsContainer = scr_guiCreateContainer(id,` |
| `gml_Object_o_inventory_Other_11` | Code | `QoLEnhanced.InventoryUI.cs` | LoadGML Match/InsertBelow | no_size_change_or_not_found | low-static-risk | `scr_escapeButtonListAdd()` |
| `gml_Object_o_lighting_Create_0` | Code | `QoLEnhanced.SkillsAndCombat.cs` | LoadGML Match/ReplaceBy | no_size_change_or_not_found | low-static-risk | `scr_temp_effect_update(object_index, owner, \"Electromantic_Power\", 10, 1200, 1)` |
| `gml_Object_o_mob_point_Other_11` | Code | `QoLEnhanced.GlobalConfig.cs` | LoadGML Match/InsertBelow | no_size_change_or_not_found | low-static-risk | `var _size ` |
| `gml_Object_o_npc_darrel_caravan_Create_0` | Code | `Codes/gml_Object_o_npc_darrel_caravan_Create_0.gml` | Codes original-gml payload | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_npc_darrel_caravan_Create_0` | Code | `QoLEnhanced.Economy.cs` | LoadGML Match/ReplaceBy | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_npc_tott_Create_0` | Code | `Codes/gml_Object_o_npc_tott_Create_0.gml` | Codes original-gml payload | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_npc_tott_Create_0` | Code | `QoLEnhanced.Economy.cs` | LoadGML Match/ReplaceBy | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_pass_skill_last_effort_Other_17` | Code | `Codes/gml_Object_o_pass_skill_last_effort_Other_17.gml` | Codes original-gml payload | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_pass_skill_last_effort_Other_17` | Code | `QoLEnhanced.SkillsAndCombat.cs` | SetStringGMLInFile | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_pass_skill_lightning_reflexes_Other_19` | Code | `Codes/gml_Object_o_pass_skill_lightning_reflexes_Other_19.gml` | Codes original-gml payload | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_pass_skill_lightning_reflexes_Other_19` | Code | `QoLEnhanced.TimeAndHotkeys.cs` | SetStringGMLInFile | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_pass_skill_preparation_Other_13` | Code | `QoLEnhanced.SkillsAndCombat.cs` | LoadGML Match/ReplaceBy | no_size_change_or_not_found | low-static-risk | `Hit_Chance` |
| `gml_Object_o_pass_skill_residual_charge_Other_13` | Code | `QoLEnhanced.SkillsAndCombat.cs` | LoadGML Match/ReplaceBy | no_size_change_or_not_found | low-static-risk | `scr_effect_create` |
| `gml_Object_o_pass_skill_residual_charge_Other_15` | Code | `QoLEnhanced.SkillsAndCombat.cs` | LoadGML Match/ReplaceBy | no_size_change_or_not_found | low-static-risk | `_count = min` |
| `gml_Object_o_pass_skill_residual_charge_Other_17` | Code | `Codes/gml_Object_o_pass_skill_residual_charge_Other_17.gml` | Codes original-gml payload | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_pass_skill_residual_charge_Other_17` | Code | `QoLEnhanced.SkillsAndCombat.cs` | SetStringGMLInFile | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_pass_skill_right_on_target_Other_17` | Code | `Codes/gml_Object_o_pass_skill_right_on_target_Other_17.gml` | Codes original-gml payload | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_pass_skill_right_on_target_Other_17` | Code | `QoLEnhanced.SkillsAndCombat.cs` | SetStringGMLInFile | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_pass_skill_self_repair_Other_17` | Code | `QoLEnhanced.SkillsAndCombat.cs` | LoadGML Match/ReplaceBy | no_size_change_or_not_found | low-static-risk | `ds_map_replace(data` |
| `gml_Object_o_pass_skill_self_repair_Other_17` | Code | `QoLEnhanced.SkillsAndCombat.cs` | LoadGML Match/ReplaceBy | no_size_change_or_not_found | low-static-risk | `if (_duration >= ` |
| `gml_Object_o_pass_skill_sprint_training_Other_18` | Code | `QoLEnhanced.SkillsAndCombat.cs` | LoadGML Match/ReplaceBy | no_size_change_or_not_found | low-static-risk | `Special_Bonus_Range` |
| `gml_Object_o_pass_skill_thrift_Other_13` | Code | `QoLEnhanced.SkillsAndCombat.cs` | LoadGML Match/ReplaceBy | no_size_change_or_not_found | low-static-risk | `if (scr_is_ammo_exist() \|\| scr_crossbow_is_armed())` |
| `gml_Object_o_perk_vow_feat_Create_0` | Assembly | `QoLEnhanced.CharacterMechanics.cs` | LoadAssemblyAsString Match/ReplaceBy | no_size_change_or_not_found | low-static-risk | `push.d 0.4` |
| `gml_Object_o_perks_Create_0` | Code | `Codes/gml_Object_o_perks_Create_0.gml` | Codes original-gml payload | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_pierce_through_missile_Alarm_0` | Code | `Codes/gml_Object_o_pierce_through_missile_Alarm_0.gml` | Codes original-gml payload | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_pierce_through_missile_Alarm_0` | Code | `QoLEnhanced.SkillsAndCombat.cs` | SetStringGMLInFile | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_pierce_through_missile_Other_10` | Code | `Codes/gml_Object_o_pierce_through_missile_Other_10.gml` | Codes original-gml payload | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_pierce_through_missile_Other_10` | Code | `QoLEnhanced.SkillsAndCombat.cs` | SetStringGMLInFile | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_player_Create_0` | Code | `QoLEnhanced.CharacterMechanics.cs` | LoadGML Match/InsertBelow | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_player_KeyPress_113` | Code | `Codes/gml_Object_o_player_KeyPress_113.gml` | Codes original-gml payload | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_player_KeyPress_113` | Code | `QoLEnhanced.TimeAndHotkeys.cs` | SetStringGMLInFile | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_player_KeyPress_114` | Code | `Codes/gml_Object_o_player_KeyPress_114.gml` | Codes original-gml payload | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_player_KeyPress_114` | Code | `QoLEnhanced.TimeAndHotkeys.cs` | SetStringGMLInFile | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_player_KeyPress_115` | Code | `Codes/gml_Object_o_player_KeyPress_115.gml` | Codes original-gml payload | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_player_KeyPress_115` | Code | `QoLEnhanced.TimeAndHotkeys.cs` | SetStringGMLInFile | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_player_KeyPress_116` | Code | `Codes/gml_Object_o_player_KeyPress_116.gml` | Codes original-gml payload | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_player_KeyPress_116` | Code | `QoLEnhanced.TimeAndHotkeys.cs` | SetStringGMLInFile | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_player_KeyPress_117` | Code | `Codes/gml_Object_o_player_KeyPress_117.gml` | Codes original-gml payload | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_player_KeyPress_120` | Code | `Codes/gml_Object_o_player_KeyPress_120.gml` | Codes original-gml payload | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_player_KeyPress_120` | Code | `QoLEnhanced.TimeAndHotkeys.cs` | SetStringGMLInFile | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_player_Other_17` | Code | `Codes/gml_Object_o_player_Other_17.gml` | Codes original-gml payload | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_player_Other_17` | Code | `QoLEnhanced.TimeAndHotkeys.cs` | SetStringGMLInFile | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_player_Step_0` | Code | `Codes/gml_Object_o_player_Step_0.gml` | Codes original-gml payload | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_player_Step_0` | Code | `QoLEnhanced.GlobalConfig.cs` | SetStringGMLInFile | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_player_chest_Alarm_1` | Code | `QoLEnhanced.CharacterMechanics.cs` | LoadGML Match/ReplaceBy | no_size_change_or_not_found | low-static-risk | `if (scr_user_owns` |
| `gml_Object_o_power_kick_Alarm_0` | Code | `QoLEnhanced.SkillsAndCombat.cs` | LoadGML Match/ReplaceBy | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_riposte_dir_indicator_Create_0` | Code | `Codes/gml_Object_o_riposte_dir_indicator_Create_0.gml` | Codes original-gml payload | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_riposte_dir_indicator_Create_0` | Code | `QoLEnhanced.cs` | AddNewEvent o_riposte_dir_indicator | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_riposte_dir_indicator_Draw_0` | Code | `Codes/gml_Object_o_riposte_dir_indicator_Draw_0.gml` | Codes original-gml payload | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_riposte_dir_indicator_Draw_0` | Code | `QoLEnhanced.cs` | AddNewEvent o_riposte_dir_indicator | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_riposte_dir_indicator_Step_0` | Code | `Codes/gml_Object_o_riposte_dir_indicator_Step_0.gml` | Codes original-gml payload | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_riposte_dir_indicator_Step_0` | Code | `QoLEnhanced.cs` | AddNewEvent o_riposte_dir_indicator | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_riposte_dir_mark_Alarm_0` | Code | `Codes/gml_Object_o_riposte_dir_mark_Alarm_0.gml` | Codes original-gml payload | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_riposte_dir_mark_Alarm_1` | Code | `Codes/gml_Object_o_riposte_dir_mark_Alarm_1.gml` | Codes original-gml payload | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_riposte_dir_mark_Create_0` | Code | `Codes/gml_Object_o_riposte_dir_mark_Create_0.gml` | Codes original-gml payload | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_riposte_dir_mark_Destroy_0` | Code | `Codes/gml_Object_o_riposte_dir_mark_Destroy_0.gml` | Codes original-gml payload | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_riposte_dir_mark_Other_11` | Code | `Codes/gml_Object_o_riposte_dir_mark_Other_11.gml` | Codes original-gml payload | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_riposte_dir_mark_PreCreate_0` | Code | `Codes/gml_Object_o_riposte_dir_mark_PreCreate_0.gml` | Codes original-gml payload | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_runic_boulder_Alarm_1` | Code | `Codes/gml_Object_o_runic_boulder_Alarm_1.gml` | Codes original-gml payload | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_runic_boulder_Alarm_1` | Code | `QoLEnhanced.SkillsAndCombat.cs` | SetStringGMLInFile | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_runic_boulder_Create_0` | Code | `Codes/gml_Object_o_runic_boulder_Create_0.gml` | Codes original-gml payload | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_runic_boulder_Create_0` | Code | `QoLEnhanced.SkillsAndCombat.cs` | SetStringGMLInFile | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_runic_boulder_Destroy_0` | Code | `Codes/gml_Object_o_runic_boulder_Destroy_0.gml` | Codes original-gml payload | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_runic_boulder_Destroy_0` | Code | `QoLEnhanced.SkillsAndCombat.cs` | SetStringGMLInFile | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_runic_boulder_Draw_0` | Code | `Codes/gml_Object_o_runic_boulder_Draw_0.gml` | Codes original-gml payload | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_runic_boulder_Draw_0` | Code | `QoLEnhanced.SkillsAndCombat.cs` | SetStringGMLInFile | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_runic_boulder_Other_12` | Code | `Codes/gml_Object_o_runic_boulder_Other_12.gml` | Codes original-gml payload | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_runic_boulder_Other_12` | Code | `QoLEnhanced.SkillsAndCombat.cs` | SetStringGMLInFile | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_runic_boulder_Step_0` | Code | `Codes/gml_Object_o_runic_boulder_Step_0.gml` | Codes original-gml payload | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_runic_boulder_Step_0` | Code | `QoLEnhanced.SkillsAndCombat.cs` | SetStringGMLInFile | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_shout_Other_12` | Code | `Codes/gml_Object_o_shout_Other_12.gml` | Codes original-gml payload | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_shout_Other_12` | Code | `QoLEnhanced.SkillsAndCombat.cs` | SetStringGMLInFile | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_skill_Other_10` | Code | `Codes/gml_Object_o_skill_Other_10.gml` | Codes original-gml payload | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_skill_Other_10` | Code | `QoLEnhanced.SkillsAndCombat.cs` | SetStringGMLInFile | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_skill_Other_17` | Code | `QoLEnhanced.AttributeCaps.cs` | LoadGML Match/ReplaceBy | no_size_change_or_not_found | low-static-risk | `if (maxKD < (_maxCD` |
| `gml_Object_o_skill_chain_lightning_Other_17` | Code | `Codes/gml_Object_o_skill_chain_lightning_Other_17.gml` | Codes original-gml payload | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_skill_chain_lightning_Other_17` | Code | `QoLEnhanced.SkillsAndCombat.cs` | SetStringGMLInFile | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_skill_discharge_Other_17` | Code | `Codes/gml_Object_o_skill_discharge_Other_17.gml` | Codes original-gml payload | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_skill_discharge_Other_17` | Code | `QoLEnhanced.SkillsAndCombat.cs` | SetStringGMLInFile | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_skill_electromancy_Other_15` | Code | `Codes/gml_Object_o_skill_electromancy_Other_15.gml` | Codes original-gml payload | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_skill_enchantment_Other_11` | Code | `Codes/gml_Object_o_skill_enchantment_Other_11.gml` | Codes original-gml payload | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_skill_enchantment_Other_11` | Code | `QoLEnhanced.Enchantment.cs` | SetStringGMLInFile | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_skill_enchantment_Other_20` | Code | `QoLEnhanced.Enchantment.cs` | LoadGML Match/ReplaceBy | no_size_change_or_not_found | low-static-risk | `if (owner.object_index` |
| `gml_Object_o_skill_finisher_Other_17` | Code | `Codes/gml_Object_o_skill_finisher_Other_17.gml` | Codes original-gml payload | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_skill_finisher_Other_17` | Code | `QoLEnhanced.SkillsAndCombat.cs` | SetStringGMLInFile | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_skill_ico_Other_25` | Code | `Codes/gml_Object_o_skill_ico_Other_25.gml` | Codes original-gml payload | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_skill_ico_Other_25` | Code | `QoLEnhanced.SkillsAndCombat.cs` | SetStringGMLInFile | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_skill_impulse_Other_10` | Code | `Codes/gml_Object_o_skill_impulse_Other_10.gml` | Codes original-gml payload | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_skill_impulse_Other_10` | Code | `QoLEnhanced.cs` | AddNewEvent o_skill_impulse | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_skill_impulse_Other_17` | Code | `Codes/gml_Object_o_skill_impulse_Other_17.gml` | Codes original-gml payload | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_skill_impulse_Other_17` | Code | `QoLEnhanced.SkillsAndCombat.cs` | SetStringGMLInFile | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_skill_pierce_through_missile_Other_20` | Code | `Codes/gml_Object_o_skill_pierce_through_missile_Other_20.gml` | Codes original-gml payload | changed_size delta=-22 | changed-target-review | `` |
| `gml_Object_o_skill_pierce_through_missile_Other_20` | Code | `QoLEnhanced.SkillsAndCombat.cs` | SetStringGMLInFile | changed_size delta=-22 | full-replacement-review | `` |
| `gml_Object_o_skill_power_kick_Other_17` | Code | `QoLEnhanced.SkillsAndCombat.cs` | LoadGML Match/ReplaceBy | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_skill_repair_item_master_Other_20` | Code | `QoLEnhanced.Economy.cs` | LoadGML Match/ReplaceBy | no_size_change_or_not_found | low-static-risk | `if (_material_spec[i]` |
| `gml_Object_o_skill_riposte_Other_17` | Code | `Codes/gml_Object_o_skill_riposte_Other_17.gml` | Codes original-gml payload | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_skill_riposte_Other_17` | Code | `QoLEnhanced.SkillsAndCombat.cs` | SetStringGMLInFile | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_skill_seize_the_initiative_Other_17` | Code | `Codes/gml_Object_o_skill_seize_the_initiative_Other_17.gml` | Codes original-gml payload | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_skill_seize_the_initiative_Other_17` | Code | `QoLEnhanced.SkillsAndCombat.cs` | SetStringGMLInFile | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_skill_tempest_Other_17` | Code | `Codes/gml_Object_o_skill_tempest_Other_17.gml` | Codes original-gml payload | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_skill_tempest_Other_17` | Code | `QoLEnhanced.SkillsAndCombat.cs` | SetStringGMLInFile | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_sleepController_Other_10` | Code | `Codes/gml_Object_o_sleepController_Other_10.gml` | Codes original-gml payload | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_sleepController_Other_10` | Code | `QoLEnhanced.TimeAndHotkeys.cs` | SetStringGMLInFile | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_sleepController_Other_12` | Code | `Codes/gml_Object_o_sleepController_Other_12.gml` | Codes original-gml payload | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_sleepController_Other_12` | Code | `QoLEnhanced.TimeAndHotkeys.cs` | SetStringGMLInFile | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_sleepController_Other_13` | Code | `Codes/gml_Object_o_sleepController_Other_13.gml` | Codes original-gml payload | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_sleepController_Other_13` | Code | `QoLEnhanced.TimeAndHotkeys.cs` | SetStringGMLInFile | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_sleepController_Other_15` | Code | `Codes/gml_Object_o_sleepController_Other_15.gml` | Codes original-gml payload | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_sleepController_Other_15` | Code | `QoLEnhanced.TimeAndHotkeys.cs` | SetStringGMLInFile | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_stash_inventory_Create_0` | Code | `QoLEnhanced.InventoryUI.cs` | LoadGML Match/InsertBelow | no_size_change_or_not_found | low-static-risk | `event_inherited()` |
| `gml_Object_o_stash_inventory_Create_0` | Code | `QoLEnhanced.InventoryUI.cs` | LoadGML Match/ReplaceBy | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_stash_inventory_right_Create_0` | Code | `QoLEnhanced.InventoryUI.cs` | LoadGML Match/InsertBelow | no_size_change_or_not_found | low-static-risk | `closeLeftMenu = true` |
| `gml_Object_o_static_field_impact_Other_11` | Code | `QoLEnhanced.SkillsAndCombat.cs` | LoadGML Match/InsertBelow | no_size_change_or_not_found | low-static-risk | `event_inherited()` |
| `gml_Object_o_tempest_Other_11` | Code | `Codes/gml_Object_o_tempest_Other_11.gml` | Codes original-gml payload | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_tempest_Other_11` | Code | `QoLEnhanced.SkillsAndCombat.cs` | SetStringGMLInFile | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_tempest_birth_Other_10` | Code | `Codes/gml_Object_o_tempest_birth_Other_10.gml` | Codes original-gml payload | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_tempest_birth_Other_10` | Code | `QoLEnhanced.SkillsAndCombat.cs` | SetStringGMLInFile | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_textLoader_Other_25` | Code | `QoLEnhanced.AttributeCaps.cs` | LoadGML Match/InsertBelow | no_size_change_or_not_found | low-static-risk | `ds_map_set(global.attribute_decimals, \"EVS\", 1)` |
| `gml_Object_o_trade_inventory_Create_0` | Code | `QoLEnhanced.InventoryUI.cs` | LoadGML Match/InsertBelow | no_size_change_or_not_found | low-static-risk | `event_inherited()` |
| `gml_Object_o_trade_inventory_Create_0` | Code | `QoLEnhanced.InventoryUI.cs` | LoadGML Match/ReplaceBy | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_war_cry_birth_Other_10` | Code | `QoLEnhanced.SkillsAndCombat.cs` | LoadGML Match/ReplaceBy | no_size_change_or_not_found | low-static-risk | `var _range` |
| `gml_Object_o_war_cry_impact_Other_11` | Code | `Codes/gml_Object_o_war_cry_impact_Other_11.gml` | Codes original-gml payload | no_size_change_or_not_found | low-static-risk | `` |
| `gml_Object_o_war_cry_impact_Other_11` | Code | `QoLEnhanced.SkillsAndCombat.cs` | SetStringGMLInFile | no_size_change_or_not_found | low-static-risk | `` |
