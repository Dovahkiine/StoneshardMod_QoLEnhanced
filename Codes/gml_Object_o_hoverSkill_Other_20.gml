event_inherited();
var _linesHeight = lineHeight;

with (owner)
{
    event_user(7);
    var _space = scr_actionsLogGetSpace();
    var _KD = scr_get_value_Dmap(skill, "KD");
    other.title = name;
    other.titleKD = (_KD > 0) ? (scr_actionsLogGetSymbol("openRoundBracket") + string(_KD) + "~ly~" + "⧗" + "~/~" + scr_actionsLogGetSymbol("closeRoundBracket")) : "N/A";
    
    if (object_is_ancestor(object_index, o_skill_passive))
    {
        other.type = ds_list_find_value(global.skill_category, 2);
        other.typeColor = make_color_rgb(163, 183, 25);
    }
    else
    {
        var _typeList = scr_get_value_Dmap(skill, "Category");
        var _typeListSize = ds_list_size(_typeList);
        
        if (_typeListSize)
        {
            other.type = "";
            
            for (var _i = 0; _i < _typeListSize; _i++)
            {
                var _key = ds_list_find_value(_typeList, _i);
                other.type += ds_map_find_value_ext(global.skill_subtype, _key, "subtype[" + string(_key) + "]");
                
                if ((_i + 1) != _typeListSize)
                    other.type += (_space + "/" + _space);
            }
        }
        else
        {
            other.type = ds_list_find_value(global.skill_category, 1);
        }
        
        other.typeColor = make_colour_rgb(14, 215, 142);
    }
    
    other.typeMana = (MPcost > 0) ? (string(MPcost) + "~mpb~" + "⧘" + "~/~") : "N/A";
    other.typeKD = (maxKD > 0) ? (string(maxKD) + "~ly~" + "⧗" + "~/~") : "N/A";
    other.attributesArray = scr_hoversGetSkillAttributes();
    var _connectedAttributesList = attribute;
    var _connectedAttributesListSize = ds_list_size(_connectedAttributesList);
    
    if (_connectedAttributesListSize)
    {
        var _colon = scr_actionsLogGetSymbol("colon");
        var _commaEnum = scr_actionsLogGetSymbol("commaEnum");
        other.connectedAttributes = ds_list_find_value(global.skill_mid_text, 8) + _colon + _space;
        
        for (var _i = 0; _i < _connectedAttributesListSize; _i++)
        {
            other.connectedAttributes += ("~w~" + string(ds_list_find_value(_connectedAttributesList, _i)) + "~/~");
            
            if ((_i + 1) != _connectedAttributesListSize)
                other.connectedAttributes += (_commaEnum + _space);
        }
    }
    else
    {
        other.connectedAttributes = "N/A";
    }
    
    other.useCondition = (!is_enemy_skill && info != "") ? info : "N/A";
    if (keyboard_check(vk_alt))
{
    var __text = desc;
    if (!is_string(__text)) __text = string(__text);
    
// Resolve real skill object name: icons use child_skill to forward events
var __obj;
if (variable_instance_exists(id, "child_skill"))
    __obj = object_get_name(child_skill);
else
    __obj = object_get_name(object_index);
    var __pos  = 1;
    var __cap  = 96; // safety cap
    
    while (__cap > 0)
    {
        var __sub_from_pos = string_copy(__text, __pos, string_length(__text) - (__pos - 1));
        var __start_rel = string_pos("/*", __sub_from_pos);
        if (__start_rel == 0) break;
        var __start = __pos + __start_rel - 1;
        
        var __sub_after_start = string_copy(__text, __start + 2, string_length(__text) - (__start + 1));
        var __end_rel = string_pos("*/", __sub_after_start);
        if (__end_rel == 0) break;
        var __end = (__start + 2) + __end_rel - 1;
        
        var __key = string_copy(__text, __start + 2, __end - (__start + 2));
        
        // Inline formula cases (auto-generated from Other_17)
        var __form = "";
        switch (__obj)
        {
            case "o_pass_skill_adaptability":
                switch (__key)
                {
                    case "max_hp": __form = "10"; break;
                }
            break;
            case "o_pass_skill_armor_adjustment":
                switch (__key)
                {
                    case "MP_Restoration": __form = "_mp_resroration * _heavy_armor_count"; break;
                    case "MP": __form = "_mp * _heavy_armor_count"; break;
                    case "EVS": __form = "_evs * _mid_armor_count"; break;
                }
            break;
            case "o_pass_skill_asceticism":
                switch (__key)
                {
                    case "Pain_Resistance": __form = "10"; break;
                }
            break;
            case "o_pass_skill_astral_tides":
                switch (__key)
                {
                    case "Arcane_Damage": __form = "5 * (1 + (Arcanistic_Power / 100))"; break;
                }
            break;
            case "o_pass_skill_berserk_traditions":
                switch (__key)
                {
                    case "Damage_Received": __form = "-_hp_lost"; break;
                    case "EVS": __form = "_wound_degree"; break;
                    case "CRTD": __form = "_enemy_count"; break;
                    case "Weapon_Damage": __form = "_pain_count"; break;
                }
            break;
            case "o_pass_skill_care_blade":
                switch (__key)
                {
                    case "Bleeding_Chance_Main": __form = "7"; break;
                    case "Weapon_Damage_Main": __form = "5"; break;
                    case "CRT_Main": __form = "3"; break;
                    case "Bleeding_Chance_Off": __form = "5"; break;
                    case "Weapon_Damage_Off": __form = "5"; break;
                    case "CRT_Off": __form = "3"; break;
                }
            break;
            case "o_pass_skill_care_of_equipment":
                switch (__key)
                {
                    case "Savvy": __form = "0"; break;
                    case "Duration_Resistance": __form = "0"; break;
                }
            break;
            case "o_pass_skill_dual_wielding_training":
                switch (__key)
                {
                    case "Cooldown_Reduction": __form = "-10"; break;
                    case "Mainhand_Efficiency": __form = "5"; break;
                    case "FMB": __form = "-3"; break;
                }
            break;
            case "o_pass_skill_dying_fervor":
                switch (__key)
                {
                    case "Mainhand_Efficiency": __form = "20"; break;
                    case "Offhand_Efficiency": __form = "20"; break;
                    case "CRT": __form = "10"; break;
                    case "CTA": __form = "15"; break;
                    case "Crit_Avoid": __form = "15"; break;
                }
            break;
            case "o_pass_skill_electrical_potancial":
                switch (__key)
                {
                    case "Magic_Power": __form = "bonus"; break;
                    case "MP": __form = "2"; break;
                }
            break;
            case "o_pass_skill_ferocity":
                switch (__key)
                {
                    case "Regen_MP": __form = "-6 + WIL"; break;
                }
            break;
            case "o_pass_skill_huntmaster":
                switch (__key)
                {
                    case "FMB": __form = "-5"; break;
                }
            break;
            case "o_pass_skill_inaudible_steps":
                switch (__key)
                {
                    case "Noise_Produced": __form = "0"; break;
                    case "STL": __form = "0"; break;
                }
            break;
            case "o_pass_skill_inner_reserves":
                switch (__key)
                {
                    case "Regen_MP": __form = "math_round(10 + WIL)"; break;
                    case "CD": __form = "math_round(25 - (0.5 * Vitality))"; break;
                }
            break;
            case "o_pass_skill_last_effort":
                switch (__key)
                {
                    case "Cooldown_Reduction": __form = "-5 * _miss_mp"; break;
                    case "Abilities_Energy_Cost": __form = "-10 * _miss_mp"; break;
                    case "Weapon_Damage": __form = "5 * _miss_hp"; break;
                    case "Hit_Chance": __form = "5 * _miss_hp"; break;
                    case "Fortitude": __form = "_debuff_resistance"; break;
                    case "Bleeding_Resistance": __form = "_debuff_resistance"; break;
                    case "Stun_Resistance": __form = "_debuff_resistance"; break;
                    case "Knockback_Resistance": __form = "_debuff_resistance"; break;
                }
            break;
            case "o_pass_skill_lightning_reflexes":
                switch (__key)
                {
                    case "EVS": __form = "5"; break;
                }
            break;
            case "o_pass_skill_lingering_incantations":
                switch (__key)
                {
                    case "Spells_Energy_Cost": __form = "-10"; break;
                }
            break;
            case "o_pass_skill_magic_lore":
                switch (__key)
                {
                    case "Spells_Energy_Cost": __form = "-0.5 * global.open_spells"; break;
                    case "Cooldown_Reduction": __form = "-global.open_spells"; break;
                    case "Miracle_Power": __form = "1 * global.open_spells_passive"; break;
                    case "Magic_Power": __form = "1 * global.open_spells_passive"; break;
                }
            break;
            case "o_pass_skill_maim_and_kill":
                switch (__key)
                {
                    case "Regen_MP": __form = "math_round(-5 + WIL)"; break;
                }
            break;
            case "o_pass_skill_one_at_a_time":
                switch (__key)
                {
                    case "Weapon_Damage": __form = "5 * _double_bonus"; break;
                    case "Immob_Chance": __form = "5 * _double_bonus"; break;
                    case "CRT": __form = "3 * _double_bonus"; break;
                }
            break;
            case "o_pass_skill_one_on_one":
                switch (__key)
                {
                    case "Weapon_Damage": __form = "0"; break;
                    case "CRT": __form = "0"; break;
                }
            break;
            case "o_pass_skill_opportune_moment":
                switch (__key)
                {
                    case "Regen_MP": __form = "-5 + WIL"; break;
                }
            break;
            case "o_pass_skill_peak_performance":
                switch (__key)
                {
                    case "Weapon_Damage": __form = "0"; break;
                    case "EVS": __form = "0"; break;
                    case "Cooldown_Reduction": __form = "0"; break;
                }
            break;
            case "o_pass_skill_potential_difference":
                switch (__key)
                {
                    case "Immob_Chance": __form = "math_round(50 * ((Magic_Power + Electromantic_Power) / 100))"; break;
                }
            break;
            case "o_pass_skill_recharge":
                switch (__key)
                {
                    case "Miracle_Chance": __form = "_mrc"; break;
                }
            break;
            case "o_pass_skill_recklessness":
                switch (__key)
                {
                    case "CRT": __form = "3 * count"; break;
                    case "CTA": __form = "5 * count"; break;
                    case "Damage_Received": __form = "-5 * count"; break;
                }
            break;
            case "o_pass_skill_residual_charge":
                switch (__key)
                {
                    case "Shock_DMG": __form = "WIL * 0.2 * ((100 + Electromantic_Power) / 100)"; break;
                }
            break;
            case "o_pass_skill_resonance_cascade":
                switch (__key)
                {
                    case "Debuff_Chance": __form = "math_round(75 * ((Magic_Power + Electromantic_Power) / 100))"; break;
                }
            break;
            case "o_pass_skill_resourcefulness":
                switch (__key)
                {
                    case "Fatigue_Gain": __form = "10"; break;
                }
            break;
            case "o_pass_skill_respite":
                switch (__key)
                {
                    case "Regen_MP": __form = "-3 + WIL"; break;
                }
            break;
            case "o_pass_skill_revanche":
                switch (__key)
                {
                    case "Regen_MP": __form = "-6 + WIL"; break;
                }
            break;
            case "o_pass_skill_revel_in_battle":
                switch (__key)
                {
                    case "Regen_MP": __form = "math_round(10 + WIL)"; break;
                }
            break;
            case "o_pass_skill_right_on_target":
                switch (__key)
                {
                    case "HE": __form = "2 + open weapon skills"; break;
                    case "WD": __form = "0.5 * AGL"; break;
                    case "AP": __form = "0.5 * STR"; break;
                    case "FMB": __form = "_FMB"; break;
                    case "DR": __form = "-(0.5 * VIT)"; break;
                    case "SEC": __form = "-(0.5 * WIL)"; break;
                }
            break;
            case "o_pass_skill_self_repair":
                switch (__key)
                {
                    case "Duration_Resistance": __form = "0.4 + Vitality * 0.02"; break;
                    case "Bleeding_Resistance_Head": __form = "5 * _count_head"; break;
                    case "Bleeding_Resistance_Tors": __form = "5 * _count_torso"; break;
                    case "Bleeding_Resistance_Hands": __form = "5 * _count_hands"; break;
                    case "Bleeding_Resistance_Legs": __form = "5 * _count_legs"; break;
                    case "Crit_Avoid": __form = "3 * _count"; break;
                }
            break;
            case "o_pass_skill_spatial_anchors":
                switch (__key)
                {
                    case "Energy_Burn": __form = "10"; break;
                }
            break;
            case "o_pass_skill_spirit_and_body":
                switch (__key)
                {
                    case "Fatigue_Gain": __form = "10"; break;
                }
            break;
            case "o_pass_skill_stance_training":
                switch (__key)
                {
                    case "HP": __form = "0.5 * Vitality"; break;
                    case "Regen_MP": __form = "5 + WIL"; break;
                }
            break;
            case "o_pass_skill_study_of_anatomy":
                switch (__key)
                {
                    case "CRT": __form = "1"; break;
                }
            break;
            case "o_pass_skill_thaumaturgy":
                switch (__key)
                {
                    case "Miracle_Chance": __form = "3"; break;
                    case "Miracle_Power": __form = "10"; break;
                    case "Magic_Res": __form = "-math_round(0.5 * WIL)"; break;
                }
            break;
            case "o_pass_skill_trailblazer":
                switch (__key)
                {
                    case "VSN": __form = "1"; break;
                }
            break;
            case "o_pass_skill_ultimate_resilience":
                switch (__key)
                {
                    case "Regen_MP": __form = "-5 + WIL"; break;
                }
            break;
            case "o_pass_skill_unlimited_power":
                switch (__key)
                {
                    case "Magic_Power": __form = "0.1 * _current_mp"; break;
                    case "MP_Restoration": __form = "0.1 * _loss_mp"; break;
                }
            break;
            case "o_pass_skill_unstoppable":
                switch (__key)
                {
                    case "HP": __form = "math_round(0.5 * Vitality)"; break;
                    case "Regen_MP": __form = "math_round(1.5 * WIL)"; break;
                }
            break;
            case "o_pass_skill_vivifying_violence":
                switch (__key)
                {
                    case "Regen_MP": __form = "math_round(-6 + WIL)"; break;
                }
            break;
            case "o_pass_skill_wounding_spearhead":
                switch (__key)
                {
                    case "Max_DMG": __form = "math_round(STR + AGL)"; break;
                }
            break;
            case "o_skill_Tantum":
                switch (__key)
                {
                    case "Hit_Chance": __form = "15 * pain"; break;
                    case "Weapon_Damage": __form = "30 * pain"; break;
                    case "FMB": __form = "-5 * pain"; break;
                    case "Pain": __form = "5 * pain"; break;
                }
            break;
            case "o_skill_active_defence":
                switch (__key)
                {
                    case "Weapon_Damage": __form = "math_round(-60 + AGL)"; break;
                    case "Stagger_Chance": __form = "math_round(80 + (2 * PRC))"; break;
                    case "Regen_MP": __form = "math_round(-5 + WIL)"; break;
                }
            break;
            case "o_skill_adrenaline_rush":
                switch (__key)
                {
                    case "Restore_MP": __form = "2 * WIL * (1.5 - (HP / max_hp))"; break;
                    case "Pain": __form = "-2 * WIL * (2 - (HP / max_hp))"; break;
                    case "Duration": __form = "math_round((Vitality / 2) * (2 - (HP / max_hp)))"; break;
                }
            break;
            case "o_skill_advance":
                switch (__key)
                {
                    case "Weapon_Damage": __form = "10 + PRC + AGL"; break;
                    case "Armor_Piercing": __form = "5 + (0.5 * AGL) + (0.5 * STR)"; break;
                    case "Bleed_Debuff": __form = "2 * AGL"; break;
                    case "Damage_Debuff": __form = "PRC"; break;
                }
            break;
            case "o_skill_aether_shield":
                switch (__key)
                {
                    case "Arcane_Damage": __form = "(0.1 * WIL * (1 + (Arcanistic_Power / 100)) * Magic_Power) / 100"; break;
                    case "Arcane_Damage_Knockback": __form = "0.1"; break;
                    case "Control_Res": __form = "15 + (1.5 * WIL)"; break;
                    case "Move_Res": __form = "15 + (1.5 * WIL)"; break;
                    case "Bleed_Res": __form = "15 + (1.5 * WIL)"; break;
                    case "Damage_Taken": __form = "-(10 + (0.5 * WIL))"; break;
                }
            break;
            case "o_skill_against_the_odds":
                switch (__key)
                {
                    case "HP": __form = "2.5 * Vitality"; break;
                    case "Regen_MP": __form = "2.5 * WIL"; break;
                }
            break;
            case "o_skill_arc_cleave":
                switch (__key)
                {
                    case "Weapon_Damage": __form = "10 + PRC"; break;
                    case "Bleeding_Chance": __form = "20 + (2 * AGL)"; break;
                    case "Stagger_Chance": __form = "50 + STR"; break;
                    case "Regen_MP": __form = "-5 + WIL"; break;
                }
            break;
            case "o_skill_arcane_tether":
                switch (__key)
                {
                    case "Pull_Chance": __form = "100 * ((Magic_Power + Arcanistic_Power) / 100)"; break;
                    case "Arcane_Damage": __form = "16 * (1 + (Arcanistic_Power / 100))"; break;
                }
            break;
            case "o_skill_armor_break":
                switch (__key)
                {
                    case "Weapon_Damage": __form = "Weapon_Damage"; break;
                    case "Armor_Piercing": __form = "5 + (2 * STR)"; break;
                    case "Armor_Damage": __form = "100"; break;
                    case "Daze_WD": __form = "PRC"; break;
                    case "Stun_WD": __form = "5 * PRC"; break;
                    case "Stagger_Chance": __form = "20 + (2 * AGL) + (2 * STR)"; break;
                    case "Damage_Debuff": __form = "5 + (0.5 * PRC)"; break;
                    case "Move_Debuff": __form = "-(5 + (0.5 * AGL))"; break;
                }
            break;
            case "o_skill_astral_phantasm":
                switch (__key)
                {
                    case "Arcane_Damage": __form = "(1 + (Arcanistic_Power / 100)) * _arcane_damage"; break;
                    case "Hit_Chance": __form = "-Miscast_Chance + _hit_chance"; break;
                    case "CRT": __form = "Miracle_Chance + _crt"; break;
                    case "CRTD": __form = "Miracle_Power + _crtd"; break;
                    case "Armor_Piercing": __form = "((2 * PRC) - 20) + _prc"; break;
                }
            break;
            case "o_skill_ball_lightning":
                switch (__key)
                {
                    case "Shock_Damage": __form = "(math_round(3 * ((100 + Electromantic_Power) / 100)) * Magic_Power) / 100"; break;
                    case "Knockback_Chance": __form = "math_round(14 * ((Magic_Power + Electromantic_Power) / 100))"; break;
                }
            break;
            case "o_skill_battering_ram":
                switch (__key)
                {
                    case "Hit_Chance": __form = "math_round(50 + (2.5 * PRC) + (2.5 * AGL))"; break;
                    case "Blunt_Damage": __form = "math_round((0.5 * Body_DEF) + (0.5 * STR))"; break;
                    case "Stagger_Chance": __form = "math_round(70 + STR + Vitality)"; break;
                    case "Stun_Chance": __form = "math_round(60 + (2 * STR) + (2 * Vitality))"; break;
                    case "Weapon_Damage": __form = "max(math_round(0.33 * EVS), 0)"; break;
                }
            break;
            case "o_skill_blister_burst":
                switch (__key)
                {
                    case "Caustic_Damage": __form = "6"; break;
                    case "Unholy_Damage": __form = "6"; break;
                }
            break;
            case "o_skill_blood_clot":
                switch (__key)
                {
                    case "Unholy_Damage": __form = "3"; break;
                    case "Caustic_Damage": __form = "3"; break;
                }
            break;
            case "o_skill_blood_puddle":
                switch (__key)
                {
                    case "Unholy_Damage": __form = "13"; break;
                    case "Caustic_Damage": __form = "13"; break;
                }
            break;
            case "o_skill_blood_spit":
                switch (__key)
                {
                    case "Hit_Chance": __form = "85 + PRC"; break;
                    case "Unholy_Damage": __form = "13"; break;
                    case "Caustic_Damage": __form = "9"; break;
                    case "AoE_Unholy_Damage": __form = "13"; break;
                    case "AoE_Poison_Damage": __form = "9"; break;
                }
            break;
            case "o_skill_bone_fires":
                switch (__key)
                {
                    case "Piercing_Damage": __form = "12"; break;
                    case "Unholy_Damage": __form = "10"; break;
                    case "Aoe_Fire_Damage": __form = "5"; break;
                    case "Aoe_Unholy_Damage": __form = "5"; break;
                    case "Aoe_Sacred_Damage": __form = "5"; break;
                    case "Aoe_Arcane_Damage": __form = "5"; break;
                }
            break;
            case "o_skill_bone_throw":
                switch (__key)
                {
                    case "Hit_Chance": __form = "65 + AGL + PRC"; break;
                    case "Armor_Piercing": __form = "3 * PRC"; break;
                    case "Daze_Chance": __form = "10 + AGL + PRC"; break;
                    case "Bleed_Chance": __form = "10 + STR + PRC"; break;
                    case "Piercing_Damage": __form = "0.5 * STR"; break;
                    case "Poison_Damage": __form = "4"; break;
                    case "Unholy_Damage": __form = "4"; break;
                }
            break;
            case "o_skill_boulder_toss":
                switch (__key)
                {
                    case "Blunt_Damage": __form = "12 * ((Magic_Power + Geomantic_Power) / 100)"; break;
                    case "Arcane_Damage": __form = "(6 * (1 + (Geomantic_Power / 100)) * Magic_Power) / 100"; break;
                    case "Knockback_Chance": __form = "(70 * (Magic_Power + Geomantic_Power)) / 100"; break;
                    case "Stun_Chance": __form = "(15 * (Magic_Power + Geomantic_Power)) / 100"; break;
                    case "Daze_Chance": __form = "(25 * (Magic_Power + Geomantic_Power)) / 100"; break;
                }
            break;
            case "o_skill_brace_for_impact":
                switch (__key)
                {
                    case "CRT": __form = "-100"; break;
                    case "AP": __form = "-(5 + (2 * Vitality))"; break;
                    case "Hit_Chance": __form = "-(5 + (0.5 * PRC))"; break;
                    case "FMB": __form = "1.5 * AGL"; break;
                    case "Bodypart_Damage": __form = "-25"; break;
                }
            break;
            case "o_skill_breakthrough":
                switch (__key)
                {
                    case "Blunt_Damage": __form = "(6 + (0.25 * Block_PowerMax)) * scr_surprice_on_rush()"; break;
                    case "Knockback_Chance": __form = "40 + STR + AGL"; break;
                    case "Stagger_Chance": __form = "60 + (2 * STR)"; break;
                    case "Hit_Chance": __form = "65 + (2 * PRC)"; break;
                    case "CRT": __form = "0.1 * PRR * scr_surprice_on_rush()"; break;
                    case "Block_Recovery": __form = "0.5 * Vitality"; break;
                }
            break;
            case "o_skill_chain_lightning":
                switch (__key)
                {
                    case "Shock_Damage": __form = "(math_round(9 * ((100 + Electromantic_Power) / 100)) * Magic_Power) / 100"; break;
                    case "Stagger_Chance": __form = "math_round(50 * ((Magic_Power + Electromantic_Power) / 100))"; break;
                    case "Debuff_Chance": __form = "math_round(80 * ((Magic_Power + Electromantic_Power) / 100))"; break;
                }
            break;
            case "o_skill_cleave":
                switch (__key)
                {
                    case "Bodypart_Damage": __form = "15 + (2 * AGL)"; break;
                    case "Bleeding_Chance": __form = "35 + (2 * STR)"; break;
                    case "CTA": __form = "0.75 * PRC"; break;
                }
            break;
            case "o_skill_coals_and_embers":
                switch (__key)
                {
                    case "Fire_Damage": __form = "9"; break;
                    case "Unholy_Damage": __form = "3"; break;
                }
            break;
            case "o_skill_coup_de_grace":
                switch (__key)
                {
                    case "Weapon_Damage": __form = "1 + ((0.025 * AGL) + (0.025 * PRC))"; break;
                    case "Armor_Piercing": __form = "2 * STR"; break;
                    case "Bodypart_Damage": __form = "2 * PRC"; break;
                }
            break;
            case "o_skill_crippling_lunge":
                switch (__key)
                {
                    case "Weapon_Damage": __form = "Weapon_Damage"; break;
                    case "Bleeding_Chance": __form = "30 + STR + AGL"; break;
                    case "Stagger_Chance": __form = "35 + (1.5 * STR)"; break;
                    case "Bodypart_Damage": __form = "15 + (2.5 * PRC)"; break;
                }
            break;
            case "o_skill_cut_through":
                switch (__key)
                {
                    case "Weapon_Damage": __form = "5 + (1.5 * STR)"; break;
                    case "Armor_Piercing": __form = "5 + STR + AGL"; break;
                    case "Armor_Damage": __form = "20 + (3 * PRC)"; break;
                    case "Weapon_Damage_Add": __form = "5 + (0.5 * PRC) + (0.5 * AGL)"; break;
                    case "Block_Debuff": __form = "-2 * AGL"; break;
                    case "Block_Power_Debuff": __form = "-2 * STR"; break;
                }
            break;
            case "o_skill_darkbolt":
                switch (__key)
                {
                    case "Hit_Chance": __form = "75 + (1.5 * PRC)"; break;
                    case "Unholy_Damage": __form = "9"; break;
                }
            break;
            case "o_skill_deadly_trick":
                switch (__key)
                {
                    case "Weapon_Damage": __form = "AGL + PRC"; break;
                    case "CRT": __form = "STR"; break;
                    case "Stagger_Chance": __form = "55 + AGL + STR"; break;
                    case "Move_Chance": __form = "100 + (2 * AGL)"; break;
                }
            break;
            case "o_skill_deafening_roar":
                switch (__key)
                {
                    case "Psionic_Damage": __form = "5"; break;
                }
            break;
            case "o_skill_deafening_roar_ico":
                switch (__key)
                {
                    case "Stun_Chance": __form = "100"; break;
                }
            break;
            case "o_skill_death_touch":
                switch (__key)
                {
                    case "Unholy_Damage": __form = "13"; break;
                }
            break;
            case "o_skill_defensive_stance":
                switch (__key)
                {
                    case "Block_Recovery": __form = "5 + (0.5 * Vitality)"; break;
                }
            break;
            case "o_skill_deflect":
                switch (__key)
                {
                    case "Block_Power": __form = "math_round(STR)"; break;
                    case "PRR": __form = "math_round(0.5 * (Mainhand_Efficiency + Offhand_Efficiency))"; break;
                }
            break;
            case "o_skill_discharge":
                switch (__key)
                {
                    case "Shock_Damage": __form = "(math_round(7 * ((100 + Electromantic_Power) / 100)) * Magic_Power) / 100"; break;
                    case "Hit_Chance": __form = "80 + (3 * PRC)"; break;
                    case "Debuff_Chance": __form = "math_round(70 * ((Magic_Power + Electromantic_Power) / 100))"; break;
                    case "Knockback_Chance": __form = "math_round(35 * ((Magic_Power + Electromantic_Power) / 100))"; break;
                }
            break;
            case "o_skill_dismember":
                switch (__key)
                {
                    case "Bodypart_Damage": __form = "math_round(20 + (3 * PRC))"; break;
                    case "Crit_Chance": __form = "math_round((0.5 * AGL) + (0.5 * STR))"; break;
                    case "HP_Damage": __form = "math_round(7.5 + (0.25 * STR))"; break;
                    case "Bleeding_Chance": __form = "math_round(100 + (2 * PRC))"; break;
                }
            break;
            case "o_skill_distracting_shot":
                switch (__key)
                {
                    case "Weapon_Damage": __form = "-60 + AGL"; break;
                    case "MP_Restoration": __form = "Vitality"; break;
                    case "EVS": __form = "PRC"; break;
                    case "Immob_Chance": __form = "40 + STR"; break;
                }
            break;
            case "o_skill_double_jab":
                switch (__key)
                {
                    case "Weapon_Damage": __form = "AGL + PRC"; break;
                    case "Bodypart_Damage": __form = "STR"; break;
                }
            break;
            case "o_skill_earth_quake":
                switch (__key)
                {
                    case "Mana_Damage": __form = "math_round((((3 * (Magic_Power + Geomantic_Power)) / 100) * max_mp) / 100)"; break;
                    case "Mana_Damage_Max": __form = "WIL"; break;
                    case "Daze_Chance": __form = "(5 * (Magic_Power + Geomantic_Power)) / 100"; break;
                    case "Blunt_Damage": __form = "(3 * (Magic_Power + Geomantic_Power)) / 100"; break;
                }
            break;
            case "o_skill_elusiveness":
                switch (__key)
                {
                    case "EVS": __form = "0.4 * PRC"; break;
                    case "Damage_Received": __form = "-(0.2 * Vitality)"; break;
                    case "FMB": __form = "0.5 * AGL"; break;
                }
            break;
            case "o_skill_enough_for_everyone":
                switch (__key)
                {
                    case "CTA": __form = "0.5 * AGL"; break;
                    case "EVS": __form = "0.5 * PRC"; break;
                    case "Damage_Received": __form = "-0.5 * Vitality"; break;
                }
            break;
            case "o_skill_execution":
                switch (__key)
                {
                    case "Weapon_Damage": __form = "1 + (0.05 * STR) + (0.025 * AGL) + (0.025 * PRC)"; break;
                    case "Regen_MP": __form = "WIL * 2.5"; break;
                }
            break;
            case "o_skill_feint_swing":
                switch (__key)
                {
                    case "Bleeding_Chance": __form = "30 + (1.5 * AGL) + (1.5 * STR)"; break;
                    case "Bodypart_Damage": __form = "3 * PRC"; break;
                    case "Move_Debuff": __form = "-(STR + PRC)"; break;
                    case "Bleed_Debuff": __form = "-(AGL + PRC)"; break;
                }
            break;
            case "o_skill_finisher":
                switch (__key)
                {
                    case "Max_HP_Limit": __form = "(2 * STR) + AGL + PRC"; break;
                    case "HP_Limit": __form = "(0.5 * STR) + (0.5 * AGL) + (0.5 * PRC)"; break;
                    case "Restore_MP": __form = "1.5 * WIL"; break;
                    case "Bodypart_Damage": __form = "2.5 * AGL"; break;
                    case "CRT": __form = "1.5 * STR"; break;
                    case "FMB": __form = "-2 * PRC"; break;
                    case "Manasteal": __form = "5 * WIL"; break;
                }
            break;
            case "o_skill_fire_barrage":
                switch (__key)
                {
                    case "Fire_Damage": __form = "(6 * (1 + (Pyromantic_Power / 100)) * Magic_Power) / 100"; break;
                    case "Hit_Chance": __form = "65 + (2 * PRC)"; break;
                }
            break;
            case "o_skill_first_aid":
                switch (__key)
                {
                    case "HP": __form = "math_round(Vitality)"; break;
                    case "Condition": __form = "math_round((0.5 * Vitality) + (0.5 * PRC))"; break;
                    case "Healing_Received": __form = "math_round(30 + (3 * PRC))"; break;
                    case "Health_Restoration": __form = "math_round(5 + (0.5 * AGL))"; break;
                    case "Duration": __form = "math_round(6 * WIL)"; break;
                }
            break;
            case "o_skill_flame_ring":
                switch (__key)
                {
                    case "Fire_Damage": __form = "(12 * (1 + (Pyromantic_Power / 100)) * Magic_Power) / 100"; break;
                    case "Fire_Resistance": __form = "math_round((-5 * (Magic_Power + Pyromantic_Power)) / 100)"; break;
                    case "Chance": __form = "(40 * (Magic_Power + Pyromantic_Power)) / 100"; break;
                    case "Duration": __form = "(3 * (Magic_Power + Pyromantic_Power)) / 100"; break;
                }
            break;
            case "o_skill_flame_wave":
                switch (__key)
                {
                    case "Fire_Damage": __form = "(13 * (1 + (Pyromantic_Power / 100)) * Magic_Power) / 100"; break;
                }
            break;
            case "o_skill_flesh_explosion":
                switch (__key)
                {
                    case "Unholy_Damage": __form = "9"; break;
                    case "Caustic_Damage": __form = "26"; break;
                }
            break;
            case "o_skill_forceful_slam":
                switch (__key)
                {
                    case "Crit_Chance": __form = "math_round((0.5 * AGL) + (0.5 * STR))"; break;
                    case "Weapon_Damage": __form = "math_round(25 + PRC)"; break;
                }
            break;
            case "o_skill_gaping_wound":
                switch (__key)
                {
                    case "Weapon_Damage": __form = "Weapon_Damage"; break;
                    case "Armor_Piercing": __form = "AGL + STR"; break;
                    case "Bleeding_Chance": __form = "30 + (2 * PRC)"; break;
                    case "Bleed_Debuff": __form = "40 + PRC"; break;
                }
            break;
            case "o_skill_grave_cold":
                switch (__key)
                {
                    case "Immob_Chance": __form = "70 + WIL"; break;
                    case "Unholy_Damage": __form = "9"; break;
                    case "Frost_Damage": __form = "9"; break;
                }
            break;
            case "o_skill_grimace_of_terror":
                switch (__key)
                {
                    case "Psionic_Damage": __form = "9"; break;
                }
            break;
            case "o_skill_hail_of_blows":
                switch (__key)
                {
                    case "Weapon_Damage": __form = "-(30 - AGL)"; break;
                    case "Energy_Steal": __form = "15 + (2 * WIL)"; break;
                    case "Daze_Chance": __form = "40 + STR + PRC"; break;
                    case "Knockback_Chance": __form = "40 + STR + AGL"; break;
                    case "Stagger_Chance": __form = "40 + (2 * STR)"; break;
                }
            break;
            case "o_skill_hammer_and_anvil":
                switch (__key)
                {
                    case "Weapon_Damage": __form = "param"; break;
                }
            break;
            case "o_skill_headshot":
                switch (__key)
                {
                    case "Bodypart_Damage": __form = "20 + PRC + AGL"; break;
                    case "CRT": __form = "(0.5 * AGL) + (0.5 * STR)"; break;
                    case "CRTD": __form = "2 * PRC"; break;
                    case "Regen_MP": __form = "2 * WIL"; break;
                }
            break;
            case "o_skill_herald_of_ruination":
                switch (__key)
                {
                    case "Crushing_Damage": __form = "35"; break;
                    case "Unholy_Damage": __form = "10"; break;
                }
            break;
            case "o_skill_heroic_charge":
                switch (__key)
                {
                    case "Weapon_Damage": __form = "PRC"; break;
                    case "CRT": __form = "(0.25 * STR) + (0.25 * AGL)"; break;
                    case "Stagger_Chance": __form = "70 + AGL + STR"; break;
                }
            break;
            case "o_skill_hunters_mark":
                switch (__key)
                {
                    case "Weapon_Damage": __form = "(0.25 * STR) + (0.25 * PRC)"; break;
                    case "Bleeding_Chance": __form = "(0.5 * AGL) + (0.5 * PRC)"; break;
                }
            break;
            case "o_skill_impulse":
                switch (__key)
                {
                    case "Shock_Damage": __form = "math_round((10 + WIL * 0.05 + Electromantic_Power * 0.05) * ((100 + Electromantic_Power) / 100) * random_range(1, 210) / 100)"; break;
                    case "Knockback_Chance": __form = "math_round(40 * ((Magic_Power + Electromantic_Power) / 100))"; break;
                    case "Debuff_Chance": __form = "math_round(85 * ((Magic_Power + Electromantic_Power) / 100))"; break;
                    case "Stagger_Chance": __form = "math_round(100 * ((Magic_Power + Electromantic_Power) / 100))"; break;
                    case "Debuff_Knockback": __form = "math_round(15 * ((Magic_Power + Electromantic_Power) / 100))"; break;
                    case "Debuff_Damage": __form = "math_round((2 + WIL * 0.01 + Electromantic_Power * 0.01) * ((100 + Electromantic_Power) / 100))"; break;
                }
            break;
            case "o_skill_incineration":
                switch (__key)
                {
                    case "Fire_Damage": __form = "(9 * (1 + (Pyromantic_Power / 100)) * Magic_Power) / 100"; break;
                    case "Chance": __form = "(20 * (Magic_Power + Pyromantic_Power)) / 100"; break;
                }
            break;
            case "o_skill_inferno":
                switch (__key)
                {
                    case "Fire_Damage": __form = "(9 * (1 + (Pyromantic_Power / 100)) * Magic_Power) / 100"; break;
                }
            break;
            case "o_skill_intransigence":
                switch (__key)
                {
                    case "Weapon_Damage": __form = "math_round(AGL + PRC)"; break;
                    case "Bleeding_Chance": __form = "math_round(55 + (2 * STR))"; break;
                    case "Regen_MP": __form = "math_round(-5 + WIL)"; break;
                }
            break;
            case "o_skill_jagged_spike":
                switch (__key)
                {
                    case "Hit_Chance": __form = "Hit_Chance - 20"; break;
                    case "Poison_Damage": __form = "6"; break;
                    case "Piercing_Damage": __form = "14"; break;
                }
            break;
            case "o_skill_keeping_distance":
                switch (__key)
                {
                    case "Stagger_Chance": __form = "40 + (2 * STR)"; break;
                    case "Crit_Chance": __form = "5 + (0.5 * AGL) + (0.5 * PRC)"; break;
                }
            break;
            case "o_skill_killing_swing":
                switch (__key)
                {
                    case "Weapon_Damage": __form = "math_round(1.5 * PRC)"; break;
                    case "Armor_Piercing": __form = "math_round(STR + AGL)"; break;
                }
            break;
            case "o_skill_knockout":
                switch (__key)
                {
                    case "Weapon_Damage": __form = "25"; break;
                    case "Daze_WD": __form = "PRC"; break;
                    case "Stun_WD": __form = "5 * PRC"; break;
                    case "Stagger_Chance": __form = "40 + (2 * STR) + (2 * AGL)"; break;
                    case "CRT": __form = "5 + (0.5 * AGL)"; break;
                }
            break;
            case "o_skill_life_leech":
                switch (__key)
                {
                    case "Unholy_Damage": __form = "9"; break;
                }
            break;
            case "o_skill_long_range_shot":
                switch (__key)
                {
                    case "Weapon_Damage": __form = "(0.1 * PRC) + (0.1 * AGL)"; break;
                    case "Armor_Piercing": __form = "(0.1 * STR) + (0.1 * AGL)"; break;
                    case "Bodypart_Damage": __form = "(0.15 * PRC) + (0.15 * AGL)"; break;
                    case "Confuse_Chance": __form = "60 + (2 * PRC)"; break;
                }
            break;
            case "o_skill_magma_rain":
                switch (__key)
                {
                    case "Fire_Damage_Cast": __form = "(6 * (1 + (Pyromantic_Power / 100)) * Magic_Power) / 100"; break;
                    case "Fire_Damage_Dot": __form = "(3 * (1 + (Pyromantic_Power / 100)) * Magic_Power) / 100"; break;
                    case "Duration": __form = "(3 * (Magic_Power + Pyromantic_Power)) / 100"; break;
                    case "Chance": __form = "5"; break;
                    case "Fire_Resistance": __form = "-1"; break;
                }
            break;
            case "o_skill_mana_crystal":
                switch (__key)
                {
                    case "Range": __form = "_range"; break;
                    case "Arcane_Damage": __form = "(1 + (Arcanistic_Power / 100)) * _arcane_damage"; break;
                    case "Hit_Chance": __form = "-Miscast_Chance + _hit_chance"; break;
                    case "CRT": __form = "Miracle_Chance + _crt"; break;
                    case "CRTD": __form = "Miracle_Power + _crtd"; break;
                    case "Armor_Piercing": __form = "(PRC - 10) + _prc"; break;
                }
            break;
            case "o_skill_mana_crystal_bolt":
                switch (__key)
                {
                    case "Range": __form = "_range"; break;
                    case "Arcane_Damage": __form = "(1 + (Arcanistic_Power / 100)) * _arcane_damage"; break;
                    case "Hit_Chance": __form = "-Miscast_Chance + _hit_chance"; break;
                    case "CRT": __form = "Miracle_Chance + _crt"; break;
                    case "CRTD": __form = "Miracle_Power + _crtd"; break;
                    case "Armor_Piercing": __form = "(PRC - 10) + _prc"; break;
                }
            break;
            case "o_skill_mayhem":
                switch (__key)
                {
                    case "Weapon_Damage": __form = "25"; break;
                    case "Daze_WD": __form = "PRC"; break;
                    case "Stun_WD": __form = "5 * PRC"; break;
                }
            break;
            case "o_skill_melting_ray":
                switch (__key)
                {
                    case "Fire_Damage_Ray": __form = "(5 * (1 + (Pyromantic_Power / 100)) * Magic_Power) / 100"; break;
                    case "Fire_Damage_Explosion": __form = "(8 * (1 + (Pyromantic_Power / 100)) * Magic_Power) / 100"; break;
                    case "Chance": __form = "(14 * (Magic_Power + Pyromantic_Power)) / 100"; break;
                }
            break;
            case "o_skill_mighty_swing":
                switch (__key)
                {
                    case "Weapon_Damage": __form = "25"; break;
                    case "Daze_WD": __form = "PRC"; break;
                    case "Stun_WD": __form = "5 * PRC"; break;
                }
            break;
            case "o_skill_nail_down":
                switch (__key)
                {
                    case "Weapon_Damage": __form = "math_round(5 + AGL + PRC)"; break;
                    case "CRT": __form = "math_round(0.5 * AGL)"; break;
                    case "Knockback_Chance": __form = "math_round(30 + STR + AGL)"; break;
                    case "Bodypart_Damage": __form = "math_round(5 + PRC + AGL)"; break;
                    case "Immob_Chance": __form = "math_round(30 + (1.5 * STR) + (1.5 * PRC))"; break;
                }
            break;
            case "o_skill_net_throw":
                switch (__key)
                {
                    case "Hit_Chance": __form = "60 + (1.5 * PRC)"; break;
                }
            break;
            case "o_skill_onslaught":
                switch (__key)
                {
                    case "Weapon_Damage": __form = "-10"; break;
                    case "Knockback_Chance": __form = "40 + (3 * STR)"; break;
                    case "Daze_Chance": __form = "20 + STR + PRC"; break;
                    case "Manaburn": __form = "AGL"; break;
                    case "Stun_Debuff": __form = "AGL"; break;
                }
            break;
            case "o_skill_painful_stabs":
                switch (__key)
                {
                    case "Weapon_Damage": __form = "param"; break;
                }
            break;
            case "o_skill_peacemaker":
                switch (__key)
                {
                    case "Weapon_Damage": __form = "-10"; break;
                    case "Daze_Chance": __form = "50 + STR + PRC"; break;
                    case "Stagger_Chance": __form = "40 + STR + AGL"; break;
                }
            break;
            case "o_skill_petrification":
                switch (__key)
                {
                    case "Chance": __form = "scr_petrification_get_chance()"; break;
                    case "Pure_Damage": __form = "math_round(6 * (1 + (Geomantic_Power / 100)))"; break;
                }
            break;
            case "o_skill_phantom_bats":
                switch (__key)
                {
                    case "Unholy_Damage": __form = "13"; break;
                }
            break;
            case "o_skill_pierce_through_missile":
                switch (__key)
                {
                    case "Bleeding_Chance": __form = "10 + (2 * AGL)"; break;
                    case "Armor_Piercing": __form = "1.5 * PRC"; break;
                    case "Daze_Chance": __form = "20 + STR + PRC"; break;
                    case "Weapon_Damage": __form = "-40 + AGL"; break;
                    case "PRR": __form = "-STR"; break;
                    case "FMB": __form = "(0.5 * PRC) + (0.5 * AGL)"; break;
                }
            break;
            case "o_skill_piercing_lunge":
                switch (__key)
                {
                    case "Bodypart_Damage": __form = "math_round(2 * PRC)"; break;
                    case "Armor_Piercing": __form = "math_round(2 * AGL)"; break;
                    case "Bleeding_Chance": __form = "math_round(30 + (2 * STR))"; break;
                }
            break;
            case "o_skill_planar_exchange":
                switch (__key)
                {
                    case "Arcane_Damage": __form = "(2 * (1 + (Arcanistic_Power / 100)) * Magic_Power) / 100"; break;
                    case "Debuff_Chance": __form = "80 * ((Magic_Power + Arcanistic_Power) / 100)"; break;
                    case "Weapon_Damage": __form = "-0.5 * WIL"; break;
                    case "Hit_Chance": __form = "-0.5 * WIL"; break;
                    case "FMB": __form = "0.5 * WIL"; break;
                }
            break;
            case "o_skill_power_kick":
                switch (__key)
                {
                    case "Damage": __form = "6 + (0.3 * Legs_DEF) + (0.4 * STR)"; break;
                    case "Knockback_Chance": __form = "60 + (2 * STR)"; break;
                    case "Stun_Resistance": __form = "-(AGL + PRC)"; break;
                    case "Knockback_Resistance": __form = "-(AGL + PRC)"; break;
                    case "Block_Power": __form = "-(3 * STR)"; break;
                    case "Stagger_Chance": __form = "80 + (2 * AGL)"; break;
                    case "Crit_Avoid": __form = "-(1.5 * PRC)"; break;
                    case "Hit_Chance": __form = "100 + (2 * PRC)"; break;
                }
            break;
            case "o_skill_predigest":
                switch (__key)
                {
                    case "Caustic_Damage": __form = "12"; break;
                    case "Armor_Piercing": __form = "33"; break;
                    case "Hit_Chance": __form = "75"; break;
                    case "Debuff_Chance": __form = "25"; break;
                }
            break;
            case "o_skill_primal_aether":
                switch (__key)
                {
                    case "Arcane_Damage": __form = "12"; break;
                    case "Sacred_Damage": __form = "12"; break;
                    case "Unholy_Damage": __form = "12"; break;
                }
            break;
            case "o_skill_ram":
                switch (__key)
                {
                    case "Blunt_Damage": __form = "(8 + (0.3 * Block_PowerMax)) * scr_surprice_on_rush()"; break;
                    case "Daze_Chance": __form = "(2 * AGL) + (2 * PRC)"; break;
                    case "Knockback_Chance": __form = "60 + (2 * STR)"; break;
                    case "CRT": __form = "0.2 * PRR * scr_surprice_on_rush()"; break;
                    case "Hit_Chance": __form = "80 + (2 * PRC)"; break;
                    case "Block_Restore": __form = "-5 + (2 * Vitality)"; break;
                }
            break;
            case "o_skill_rampage":
                switch (__key)
                {
                    case "Max_HP_Limit": __form = "math_round(20 + (STR * 0.5))"; break;
                }
            break;
            case "o_skill_rampage_ico":
                switch (__key)
                {
                    case "Max_HP_Limit": __form = "math_round(20 + (STR * 0.5))"; break;
                }
            break;
            case "o_skill_regroup":
                switch (__key)
                {
                    case "Block_Power": __form = "math_round(2 * Vitality)"; break;
                }
            break;
            case "o_skill_reign_in_blood":
                switch (__key)
                {
                    case "Bleeding_Chance": __form = "math_round(40 + PRC + STR)"; break;
                    case "MP_Restore": __form = "math_round(0.5 * WIL)"; break;
                    case "Bodypart_Damage": __form = "math_round((2 * AGL) + (2 * PRC))"; break;
                    case "Knockback_Chance": __form = "math_round(40 + (2 * STR))"; break;
                }
            break;
            case "o_skill_riposte":
                switch (__key)
                {
                    case "PRR": __form = "AGL + PRC"; break;
                    case "Block_Power": __form = "STR"; break;
                    case "CTA": __form = "10 + PRC"; break;
                }
            break;
            case "o_skill_rock_toss":
                switch (__key)
                {
                    case "Crushing_Damage": __form = "60"; break;
                }
            break;
            case "o_skill_runic_boulder":
                switch (__key)
                {
                    case "Knockback_Chance": __form = "(75 * (Magic_Power + Geomantic_Power)) / 100"; break;
                    case "HP": __form = "scr_runic_boulder_get_hp()"; break;
                    case "Arcane_Damage": __form = "(4 * (1 + (Geomantic_Power / 100)) * Magic_Power) / 100"; break;
                    case "Arcane_Damage_Self": __form = "(4 * (1 + (Geomantic_Power / 100)) * Magic_Power) / 100"; break;
                    case "MP_turn": __form = "-3"; break;
                }
            break;
            case "o_skill_runic_explosion":
                switch (__key)
                {
                    case "Blunt_Damage": __form = "(8 * (Magic_Power + Geomantic_Power)) / 100"; break;
                    case "Arcane_Damage": __form = "(8 * (1 + (Geomantic_Power / 100)) * Magic_Power) / 100"; break;
                    case "Stun_Chance": __form = "(25 * (Magic_Power + Geomantic_Power)) / 100"; break;
                    case "Knockback_Chance": __form = "(40 * (Magic_Power + Geomantic_Power)) / 100"; break;
                }
            break;
            case "o_skill_schism":
                switch (__key)
                {
                    case "Arcane_Damage": __form = "(10 * (1 + (Arcanistic_Power / 100)) * Magic_Power) / 100"; break;
                    case "Debuff_Chance": __form = "40 * ((Magic_Power + Arcanistic_Power) / 100)"; break;
                    case "Knockback_Chance": __form = "100 * ((Magic_Power + Arcanistic_Power) / 100)"; break;
                }
            break;
            case "o_skill_scream_of_doom":
                switch (__key)
                {
                    case "Psionic_Damage": __form = "6"; break;
                }
            break;
            case "o_skill_seal_of_cleansing":
                switch (__key)
                {
                    case "HP": __form = "math_round(-7 + Vitality)"; break;
                    case "Regen_MP": __form = "math_round(0.5 * WIL)"; break;
                }
            break;
            case "o_skill_seal_of_power":
                switch (__key)
                {
                    case "Arcane_DMG_Default": __form = "WIL * 0.1"; break;
                    case "Fire_DMG": __form = "WIL * 0.2"; break;
                    case "Shock_DMG": __form = "WIL * 0.2"; break;
                    case "Arcane_DMG": __form = "WIL * 0.2"; break;
                }
            break;
            case "o_skill_seal_of_shackles":
                switch (__key)
                {
                    case "DMG": __form = "(math_round(10 + (1.5 * WIL)) * Magic_Power) / 100"; break;
                }
            break;
            case "o_skill_seize_the_initiative":
                switch (__key)
                {
                    case "EVS": __form = "-2.5 * AGL"; break;
                    case "PRR": __form = "-2.5 * STR"; break;
                    case "HC": __form = "AGL"; break;
                    case "FMB": __form = "-PRC"; break;
                }
            break;
            case "o_skill_shockwave":
                switch (__key)
                {
                    case "Crushing_Damage": __form = "30"; break;
                }
            break;
            case "o_skill_short_circuit":
                switch (__key)
                {
                    case "Shock_Damage": __form = "(math_round(6 * ((100 + Electromantic_Power) / 100)) * Magic_Power) / 100"; break;
                    case "Daze_Chance": __form = "math_round(40 * ((Magic_Power + Electromantic_Power) / 100))"; break;
                }
            break;
            case "o_skill_sign_of_darkness":
                switch (__key)
                {
                    case "Unholy_Damage": __form = "9"; break;
                }
            break;
            case "o_skill_skull_crusher":
                switch (__key)
                {
                    case "Stun_Chance": __form = "math_round(10 + (2 * STR) + (2 * PRC))"; break;
                    case "Bodypart_Damage": __form = "math_round(5 + PRC + AGL)"; break;
                }
            break;
            case "o_skill_stasis":
                switch (__key)
                {
                    case "Total_Damage": __form = "100 * ((Magic_Power + Arcanistic_Power) / 100)"; break;
                    case "Daze_Chance": __form = "80 * ((Magic_Power + Arcanistic_Power) / 100)"; break;
                    case "Chance": __form = "100 * ((Magic_Power + Arcanistic_Power) / 100)"; break;
                }
            break;
            case "o_skill_static_field":
                switch (__key)
                {
                    case "Shock_Damage": __form = "(math_round(2 * ((100 + Electromantic_Power) / 100)) * Magic_Power) / 100"; break;
                    case "Immob_Chance": __form = "math_round(7 * ((Magic_Power + Electromantic_Power) / 100))"; break;
                }
            break;
            case "o_skill_step_aside":
                switch (__key)
                {
                    case "Weapon_Damage": __form = "PRC + AGL"; break;
                    case "Knockback_Chance": __form = "40 + STR + AGL"; break;
                }
            break;
            case "o_skill_stone_armor":
                switch (__key)
                {
                    case "Duration": __form = "scr_stone_armor_get_duration()"; break;
                    case "Blunt_Damage": __form = "(4 * (Magic_Power + Geomantic_Power)) / 100"; break;
                    case "Knockback_Chance": __form = "(50 * (Magic_Power + Geomantic_Power)) / 100"; break;
                    case "Arcane_Damage": __form = "(6 * (Magic_Power + Geomantic_Power)) / 100"; break;
                    case "Max_DMG": __form = "3 * WIL"; break;
                }
            break;
            case "o_skill_stone_spikes":
                switch (__key)
                {
                    case "Blunt_Damage": __form = "scr_stone_spikes_get_dmg()"; break;
                    case "Piercing_Damage": __form = "12 * ((Magic_Power + Geomantic_Power) / 100)"; break;
                    case "Knockback_Chance": __form = "(40 * (Magic_Power + Geomantic_Power)) / 100"; break;
                    case "Stun_Chance": __form = "(10 * (Magic_Power + Geomantic_Power)) / 100"; break;
                    case "HP": __form = "scr_stone_spikes_get_hp()"; break;
                }
            break;
            case "o_skill_strangling_grasp":
                switch (__key)
                {
                    case "Immob_Chance": __form = "50 + STR"; break;
                }
            break;
            case "o_skill_sudden_strike":
                switch (__key)
                {
                    case "Confuse_Chance": __form = "50 + AGL"; break;
                    case "Weapon_Damage": __form = "-50"; break;
                    case "Stagger_Chance": __form = "40 + (2 * AGL) + (2 * PRC)"; break;
                }
            break;
            case "o_skill_sweep":
                switch (__key)
                {
                    case "Immob_Chance": __form = "65 + (2 * AGL)"; break;
                    case "Damage": __form = "4 + (0.2 * Legs_DEF) + (0.3 * STR)"; break;
                    case "FMB": __form = "5 + (0.5 * AGL)"; break;
                    case "CRT": __form = "-(5 + (0.5 * PRC))"; break;
                    case "Weapon_Damage": __form = "-(5 + (0.5 * STR))"; break;
                    case "Stagger_Chance": __form = "105 + (2 * STR)"; break;
                    case "Hit_Chance": __form = "80 + (2 * PRC)"; break;
                }
            break;
            case "o_skill_taking_aim":
                switch (__key)
                {
                    case "Weapon_Damage": __form = "PRC"; break;
                    case "Hit_Chance": __form = "59 + (1 * ranged_skill_learned)"; break;
                    case "Knockback_Chance": __form = "3 * STR"; break;
                    case "Immob_Chance": __form = "3 * AGL"; break;
                    case "Stagger_Chance": __form = "3 * PRC"; break;
                }
            break;
            case "o_skill_tempest":
                switch (__key)
                {
                    case "Shock_Damage": __form = "(math_round(10 * ((100 + Electromantic_Power) / 100)) * Magic_Power) / 100"; break;
                    case "Stun_Chance": __form = "math_round(20 + ((Magic_Power + Electromantic_Power) / 100))"; break;
                    case "HP_Limit": __form = "16"; break;
                    case "Max_HP_Limit": __form = "math_round(20 * ((Magic_Power + Electromantic_Power) / 100))"; break;
                }
            break;
            case "o_skill_throw_acid_bomb":
                switch (__key)
                {
                    case "Hit_Chance": __form = "40 + PRC"; break;
                }
            break;
            case "o_skill_throw_axe":
                switch (__key)
                {
                    case "Hit_Chance": __form = "50 + PRC"; break;
                    case "CRT": __form = "1 + (0.25 * PRC) + (0.25 * AGL)"; break;
                    case "Damage": __form = "_params_array[0]"; break;
                    case "Armor_Piercing": __form = "_params_array[1]"; break;
                }
            break;
            case "o_skill_throw_bee_bomb":
                switch (__key)
                {
                    case "Hit_Chance": __form = "40 + PRC"; break;
                }
            break;
            case "o_skill_throw_caltrop":
                switch (__key)
                {
                    case "Hit_Chance": __form = "80 + PRC"; break;
                }
            break;
            case "o_skill_throw_dagger":
                switch (__key)
                {
                    case "Hit_Chance": __form = "70 + PRC"; break;
                    case "CRT": __form = "1 + (0.25 * PRC) + (0.25 * AGL)"; break;
                    case "Damage": __form = "_params_array[0]"; break;
                    case "Armor_Piercing": __form = "_params_array[1]"; break;
                }
            break;
            case "o_skill_throw_fire_bomb":
                switch (__key)
                {
                    case "Hit_Chance": __form = "40 + PRC"; break;
                }
            break;
            case "o_skill_tongue_leech":
                switch (__key)
                {
                    case "Piercing_Damage": __form = "18"; break;
                    case "Poison_Damage": __form = "6"; break;
                    case "Unholy_Damage": __form = "6"; break;
                }
            break;
            case "o_skill_tongue_pull":
                switch (__key)
                {
                    case "Blunt_Damage": __form = "9"; break;
                    case "Poison_Damage": __form = "6"; break;
                    case "Unholy_Damage": __form = "6"; break;
                }
            break;
            case "o_skill_tongue_push":
                switch (__key)
                {
                    case "Blunt_Damage": __form = "9"; break;
                    case "Poison_Damage": __form = "6"; break;
                    case "Unholy_Damage": __form = "6"; break;
                }
            break;
            case "o_skill_torch_strike":
                switch (__key)
                {
                    case "Fire_Chance": __form = "33"; break;
                    case "Fire_Damage": __form = "14"; break;
                    case "Hit_Chance": __form = "100"; break;
                }
            break;
            case "o_skill_unstoppable_force":
                switch (__key)
                {
                    case "Knockback_Chance": __form = "math_round(50 + (2 * STR))"; break;
                    case "Armor_Damage": __form = "math_round(30 + (3 * PRC))"; break;
                }
            break;
            case "o_skill_vampire_rune":
                switch (__key)
                {
                    case "Unholy_Damage": __form = "9"; break;
                    case "Immob_Chance": __form = "(26 * Magic_Power) / 100"; break;
                }
            break;
            case "o_skill_vengeance_of_the_dead":
                switch (__key)
                {
                    case "Piercing_Damage": __form = "28"; break;
                    case "Unholy_Damage": __form = "12"; break;
                }
            break;
            case "o_skill_venomous_salvo":
                switch (__key)
                {
                    case "Debuff_Chance": __form = "50"; break;
                    case "Poison_Damage": __form = "16"; break;
                    case "Hit_Chance": __form = "Hit_Chance + 15"; break;
                }
            break;
            case "o_skill_war_cry":
                switch (__key)
                {
                    case "Psionic_Damage": __form = "2"; break;
                    case "Disable_Chance": __form = "45 + (3 * WIL)"; break;
                }
            break;
            case "o_skill_web_spit":
                switch (__key)
                {
                    case "Hit_Chance": __form = "80 + PRC"; break;
                    case "Caustic_Damage": __form = "8"; break;
                    case "Poison_Damage": __form = "4"; break;
                }
            break;
            case "o_skill_whirlwind":
                switch (__key)
                {
                    case "Stagger_Chance": __form = "math_round(80 + (2 * STR))"; break;
                    case "CTA": __form = "-math_round(2 * (AGL + PRC))"; break;
                    case "Move_Chance": __form = "math_round(100 + (3 * AGL))"; break;
                }
            break;
            case "o_skill_wide_cut":
                switch (__key)
                {
                    case "Weapon_Damage": __form = "math_round(-30 + PRC)"; break;
                    case "Armor_Piercing": __form = "math_round(5 + STR + AGL)"; break;
                    case "Bleeding_Chance": __form = "math_round(60 + STR + PRC)"; break;
                    case "Pull_Chance": __form = "math_round(80 + STR + AGL + Knockback_Chance)"; break;
                }
            break;
            case "o_skill_will_to_survive":
                switch (__key)
                {
                    case "DMG_Rec": __form = "-math_round(0.5 * Vitality)"; break;
                    case "HP": __form = "math_round(WIL + 5)"; break;
                    case "Fortitude": __form = "math_round(0.5 * Vitality)"; break;
                }
            break;
            case "o_skill_raise_shield":
                switch (__key)
                {
                    case "DMG_Rec": __form = "-math_round(0.5 * Vitality)"; break;
                    case "HP": __form = "math_round(WIL + 5)"; break;
                    case "Fortitude": __form = "math_round(0.5 * Vitality)"; break;
                }
            break;
            case "o_skill_wormhole":
                switch (__key)
                {
                    case "Block_Chanc": __form = "10 + ((AGL + Vitality) * scr_shield_get_defence(\"PRR\") * 0.01)"; break;
                    case "Block_Power": __form = "math_round(-5 + STR + Vitality)"; break;
                    case "CTA": __form = "math_round(5 + (0.5 * AGL))"; break;
                    case "Block_Restore": __form = "math_round(2 * Vitality)"; break;
                    case "Crit_Avoid": __form = "60 *math_round(AGL + PRC)"; break;
                }
            break;
        }
        
        if (is_string(__form) && string_length(__form) > 0)
        {
            var __before = string_copy(__text, 1, __start - 1);
            var __after  = string_copy(__text, __end + 2, string_length(__text) - (__end + 1));
            __text = __before + __form + __after;
            __pos = __start + string_length(__form);
        }
        else
        {
            __pos = __end + 2;
        }
        
        __cap -= 1;
        if (string_length(__text) > 12000) break;
    }
    
    other.description = __text;
}
else
{
    other.description = scr_parse_atr_text(text_map, desc);
}

    other.unlockCondition = scr_skill_reparse_locked();
}

titleHeight = scr_stringGetHeightExt(title, minWidth, global.f_digits, textScale);

if (titleKD == "N/A")
{
    titleKDHeight = 0;
}
else
{
    scr_colorTextCreate(titleKDTextMap, titleKD, 16777215, minWidth, textScale, global.f_digits);
    titleKDHeight = ds_map_find_value(titleKDTextMap, "height");
}

typeHeight = fontDmgHeight;

if (typeMana == "N/A")
{
    typeManaHeight = 0;
}
else
{
    scr_colorTextCreate(typeManaTextMap, typeMana, 16777215, minWidth, textScale);
    typeManaHeight = ds_map_find_value(typeManaTextMap, "height");
}

if (typeKD == "N/A")
{
    typeKDHeight = 0;
}
else
{
    scr_colorTextCreate(typeKDTextMap, typeKD, 16777215, minWidth, textScale);
    typeKDHeight = ds_map_find_value(typeKDTextMap, "height");
}

attributesHeight = (array_length(attributesArray) / 3) * fontDmgHeight;

if (connectedAttributes == "N/A")
{
    connectedAttributesHeight = 0;
}
else
{
    scr_colorTextCreate(connectedAttributesTextMap, connectedAttributes, make_colour_rgb(157, 154, 154), minWidth, textScale);
    connectedAttributesHeight = ds_map_find_value(connectedAttributesTextMap, "height");
}

if (useCondition == "N/A")
    useConditionHeight = 0;
else
    useConditionHeight = scr_stringGetHeightExt(useCondition, minWidth, global.f_dmg, textScale);

scr_colorTextCreate(descriptionTextMap, description, make_colour_rgb(157, 154, 154), minWidth, textScale);
descriptionHeight = ds_map_find_value(descriptionTextMap, "height");

if (unlockCondition == "N/A")
{
    unlockConditionHeight = 0;
}
else
{
    scr_colorTextCreate(unlockConditionTextMap, unlockCondition, make_colour_rgb(172, 60, 81), minWidth, textScale);
    unlockConditionHeight = ds_map_find_value(unlockConditionTextMap, "height");
}

if (attributesHeight)
{
    if (connectedAttributesHeight || useConditionHeight)
        attributesHeight += spaceHeight;
}

if (connectedAttributesHeight)
{
    if (useConditionHeight)
        connectedAttributesHeight += spaceHeight;
}

if (attributesHeight || connectedAttributesHeight || useConditionHeight)
    _linesHeight += lineHeight;

if (unlockConditionHeight)
    _linesHeight += lineHeight;

contentWidth = minWidth;
contentHeight = titleHeight + typeHeight + attributesHeight + connectedAttributesHeight + useConditionHeight + descriptionHeight + unlockConditionHeight + _linesHeight;
