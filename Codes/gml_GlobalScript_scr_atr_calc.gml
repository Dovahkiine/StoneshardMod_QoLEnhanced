function scr_atr_calc(argument0, argument1)
{
    if(argument0 == undefined)
        argument0 = id;

    if(argument1 == undefined)
        argument1 = false;

    var enemy_targ = o_enemy;

    if (!instance_exists(argument0))
        return 0;

    if (argument0 != o_player && argument0 != o_unit)
        enemy_targ = argument0;

    var isPlayer = is_player(argument0);

    if (isPlayer && !instance_exists(o_player))
        return 0;

    if (argument0 != o_player && !isPlayer)
    {
        if (room == r_test)
            return 0;

        with (enemy_targ)
        {
            if (HP < 1)
                return 0;

            if (!is_simple)
            {
                scr_enemy_buff_buffer();
                var _vit = scr_buff_param("Vitality");
                var _agl = scr_buff_param("AGL");
                var _str = scr_buff_param("STR");
                var _prc = scr_buff_param("PRC");
                var _will = scr_buff_param("WIL");
                STR = clamp(bSTR + _str, 2, 200);
                AGL = clamp(bAGL + _agl, 2, 180);
                PRC = clamp(bPRC + _prc, 2, 180);
                Vitality = clamp(bVIT + _vit, 2, 300);
                WIL = clamp(bWIL + _will, 2, 200);
                Avoiding_Trap = bAvoiding_Trap;
                Bonus_Range = scr_buff_param("Bonus_Range");

                if (is_mage)
                    Bonus_Range += bBonus_Range;

                Charge_Distance = scr_buff_param("Charge_Distance");
                Arcanistic_Distance = scr_buff_param("Arcanistic_Distance");

                if (!is_mage && !is_shoot)
                    Bonus_Range = 0;

                range = max(1, (brange + scr_buff_param("range")) * ((100 + Bonus_Range) / 100));

                // 0.9.4.22.1 原版兼容：法师单位射程仍按新版原版固定为 1。
                if (is_mage)
                    range = min(1, range);
                MP_turn = scr_buff_param("MP_turn");
                HP_turn = scr_buff_param("HP_turn");

                if (!argument1)
                {
                    var relation = HP / max_hp;

                    if (attributes_owner_depender && instance_exists(owner))
                    {
                        var _owner_hp = (object_index == o_astral_phantasm) ? (owner.Magic_Power / 100) : (owner.Magic_Power / 100);
                        max_hp = ((bHP * _owner_hp * (1.05 - (scr_tile_distance_min(id, owner) * 0.05))) + scr_buff_param("max_hp") + Vitality * 3) * 2;
                    }
                    else
                    {
                        max_hp = math_round(bHP + scr_buff_param("max_hp") + Vitality * 3) * 2;
                    }

                    max_hp = math_round(max(1, max_hp));
                    HP = math_round(max_hp * relation);
                    Health_Threshold = clamp(100 - scr_Health_Threshold_calc(isPlayer), 0, 100);
                    var _hpChange = (max_hp * Health_Threshold) / 100;

                    if (HP > _hpChange)
                        HP = math_round(_hpChange);

                    if (HP < 1)
                        HP = 1;

                    Max_Energy_Threshold = clamp(100 + scr_buff_param("Max_Energy_Threshold"), 0, 100);

                    if (max_mp != 0 && bMP != 0)
                    {
                        var _relat = MP / max_mp;

                        if (!is_real(_relat))
                            _relat = 1;

                        max_mp = max(1, math_round(bMP + scr_buff_param("max_mp")));
                        MP = math_round(max_mp * _relat);
                        var _mpChange = (max_mp * Max_Energy_Threshold) / 100;

                        if (MP > _mpChange)
                            MP = _mpChange;

                        MP = math_round(MP);
                    }
                }

                MP_Restoration = bMP_Restoration + scr_buff_param("MP_Restoration");
                PRR = clamp(bPRR + scr_buff_param("PRR") + STR * 1.5, 0, 100);
                scr_def_calc(isPlayer);
                Weapon_Damage = clamp(100 + scr_buff_param("Weapon_Damage") + STR * 2, 25, 500);      // QoL: STR 传导武器伤害
                Swimming_Cost = bSwimming_Cost + scr_buff_param("Swimming_Cost");
                CRTD = clamp(bCRTD + scr_buff_param("CRTD") + STR * 4, 125, 500);               // QoL: STR 传导暴击伤害效果
                Crit_Avoid = clamp(bCrit_Avoid + scr_buff_param("Crit_Avoid") + 0.5 * AGL, -20, 150); // QoL: AGL 传导暴击免疫
                Block_PowerMax = max(0, bBlock_Power + scr_buff_param("Block_Power"));
                Block_Recovery = clamp(bBlock_Recovery + scr_buff_param("Block_Recovery") + 5, 1, 100);
                Block_Power = math_round(Block_PowerMax * Block_RecoveryStatus);
                Armor_Piercing = clamp(bArmor_Piercing + scr_buff_param("Armor_Piercing") + PRC, 0, 100);                       // QoL: PRC 传导护甲穿透
                Spell_Armor_Piercing = clamp(bSpell_Armor_Piercing + scr_buff_param("Spell_Armor_Piercing") + PRC, 0, 100);     // QoL: PRC 传导法术穿透
                Bodypart_Damage = bBodypart_Damage + scr_buff_param("Bodypart_Damage");
                EVS = bEVS + scr_buff_param("EVS") + AGL;                                // QoL: AGL 传导闪避
                CTA = bCTA + scr_buff_param("CTA") + AGL * 1.5;                                // QoL: AGL 传导反击几率
                CRT = clamp(bCRT + scr_buff_param("CRT") + PRC, 0, 150);                     // QoL: PRC 传导暴击几率
                FMB = bFMB + scr_buff_param("FMB") - AGL * 1.5;                                    // QoL: AGL 减小失手几率
                STL = bSTL + scr_buff_param("STL");
                Savvy = clamp(5 + AGL + scr_buff_param("Savvy"), 0, 100);
                VSN_Bonus = clamp(scr_buff_param("VSN_Bonus"), -75, 100);
                VSN = clamp((bVSN + scr_buff_param("VSN")) * (1 + (VSN_Bonus / 100)), 0, 15);
                currentVSN = clamp(VSN + scr_buff_param("currentVSN"), 0, 15);
                hear_value = clamp(bhear_value + scr_buff_param("HEAR"), 0, 1);
                morale_factor = clamp(bmorale_factor + scr_buff_param("Morale_Factor") + (WIL + PRC + Vitality) * 8, 0, 2000); // QoL: WIL/PRC/Vitality 传导士气，最高 200→1000
                Hit_Chance = clamp(bHit_Chance + scr_buff_param("Hit_Chance") + AGL * 1.5, 5, 300); // QoL: AGL 传导命中，上限 150→300
                Spell_Hit_Chance = clamp(bSpell_Hit_Chance + scr_buff_param("Spell_Hit_Chance") + PRC * 1.5, 5, 300); // QoL: PRC 传导法术命中
                Magic_Power = clamp(bMagic_Power + scr_buff_param("Magic_Power") + WIL * 2, 25, 500); // QoL: WIL 传导法力伤害，上限 300→500

                if (!argument1)
                {
                    Healing_Received = bHealing_Received + scr_buff_param("Healing_Received");
                    Health_Restoration = clamp(bHealth_Restoration + scr_buff_param("Health_Restoration"), 0, 100);
                    Magic_Resistance = math_round(bMagic_Resistance + scr_buff_param("Magic_Resistance"));
                    Fortitude = clamp(bFortitude + _will + scr_buff_param("Fortitude") + WIL * 1.5, -100, 95); // QoL: WIL 传导强韧，上限 50→100
                    MP_Restoration = clamp(bMP_Restoration + scr_buff_param("MP_Restoration"), 0, 100);
                    Backfire_Damage_Change = clamp(scr_buff_param("Backfire_Damage_Change"), -200, 200);
                    Miracle_Chance = clamp(bMiracle_Chance + scr_buff_param("Miracle_Chance") + PRC, 0, 150);    // QoL: PRC 传导奇观几率
                    Miracle_Power = clamp(125 + scr_buff_param("Miracle_Power") + WIL * 1, 125, 500);                 // QoL: WIL 传导奇迹威力，上限 250→500
                    Miscast_Chance = clamp(bMiscast_Chance + scr_buff_param("Miscast_Chance") - AGL * 1.5, -200, 100); // QoL: AGL 减小法术失误
                    scr_painlimit(isPlayer);
                    Pain_Change = scr_buff_param("Pain_Change");
                    Pain_K = 1;
                    var _total_attributes = STR + AGL + Vitality + PRC + WIL; // QoL: 五维属性总和影响伤害增减
                    Lifesteal = bLifesteal + scr_buff_param("Lifesteal") + (STR + AGL + Vitality + PRC + WIL) * 0.01; // QoL: 五维属性总和传导生命偷取
                    Manasteal = bManasteal + scr_buff_param("Manasteal") + (STR + AGL + Vitality + PRC + WIL) * 0.01; // QoL: 五维属性总和传导法力偷取
                    Damage_Received = clamp((bDamage_Received + scr_buff_param("Damage_Received")) * power(0.99, _total_attributes / 1.5), 5, 200); // QoL: 五维之和降低受伤
                    Damage_Returned = clamp(bDamage_Returned + scr_buff_param("Damage_Returned"), 0, 100);
                    Pyromantic_Power = scr_buff_param("Pyromantic_Power") + bPyromantic_Power;
                    Geomantic_Power = scr_buff_param("Geomantic_Power") + bGeomantic_Power;
                    Venomantic_Power = scr_buff_param("Venomantic_Power") + bVenomantic_Power;
                    Cryomantic_Power = scr_buff_param("Cryomantic_Power") + bCryomantic_Power;
                    Electromantic_Power = scr_buff_param("Electromantic_Power") + bElectromantic_Power;
                    Arcanistic_Power = scr_buff_param("Arcanistic_Power") + bArcanistic_Power;
                    Astromantic_Power = scr_buff_param("Astromantic_Power") + bAstromantic_Power;
                    Psimantic_Power = scr_buff_param("Psimantic_Power") + bPsimantic_Power;
                    var _cooldown_reduction_mod = 0;

                    if (!scr_passive_skill_is_open(o_enemy_pass_steadfastness))
                        _cooldown_reduction_mod = scr_buff_param("Cooldown_Reduction");

                    Cooldown_Reduction = clamp(bCooldown_Reduction + _cooldown_reduction_mod - WIL, 10, 200);       // QoL: WIL 减少冷却时间，最低 10%
                    Spells_Energy_Cost = clamp(bSpells_Energy_Cost + scr_buff_param("Spells_Energy_Cost"), -75, 200);
                    Skills_Energy_Cost = clamp(bSkills_Energy_Cost + scr_buff_param("Skills_Energy_Cost"), -75, 200);
                    Abilities_Energy_Cost = clamp(bAbilities_Energy_Cost + scr_buff_param("Abilities_Energy_Cost"), 25, 300);
                    var _resistance_max = 300;
                    Pain_Resistance = clamp(bPain_Resistance + scr_buff_param("Pain_Resistance"), -200, _resistance_max);
                    Physical_Resistance = clamp(bPhysical_Resistance + scr_buff_param("Physical_Resistance"), -200, _resistance_max);
                    Nature_Resistance = clamp(bNature_Resistance + scr_buff_param("Nature_Resistance"), -200, _resistance_max);
                    Fire_Resistance_RAW = clamp(bFire_Resistance + scr_buff_param("Fire_Resistance"), -200, _resistance_max);
                    Frost_Resistance_RAW = clamp(bFrost_Resistance + scr_buff_param("Frost_Resistance"), -200, _resistance_max);
                    Shock_Resistance_RAW = clamp(bShock_Resistance + scr_buff_param("Shock_Resistance"), -200, _resistance_max);
                    Caustic_Resistance_RAW = clamp(bCaustic_Resistance + scr_buff_param("Caustic_Resistance"), -200, _resistance_max);
                    Fire_Resistance = clamp(Fire_Resistance_RAW + Nature_Resistance, -200, _resistance_max);
                    Frost_Resistance = clamp(Frost_Resistance_RAW + Nature_Resistance, -200, _resistance_max);
                    Shock_Resistance = clamp(Shock_Resistance_RAW + Nature_Resistance, -200, _resistance_max);
                    Caustic_Resistance = clamp(Caustic_Resistance_RAW + Nature_Resistance, -200, _resistance_max);

                    if (Poison_Immunity)
                    {
                        Poison_Resistance = _resistance_max;
                        Poison_Resistance_RAW = _resistance_max;
                    }
                    else
                    {
                        Poison_Resistance = clamp(bPoison_Resistance + scr_buff_param("Poison_Resistance"), -200, _resistance_max);
                        Poison_Resistance_RAW = Poison_Resistance;
                    }

                    Slashing_Resistance_RAW = clamp(bSlashing_Resistance + scr_buff_param("Slashing_Resistance"), -200, _resistance_max);
                    Piercing_Resistance_RAW = clamp(bPiercing_Resistance + scr_buff_param("Piercing_Resistance"), -200, _resistance_max);
                    Blunt_Resistance_RAW = clamp(bBlunt_Resistance + scr_buff_param("Blunt_Resistance"), -200, _resistance_max);
                    Rending_Resistance_RAW = clamp(bRending_Resistance + scr_buff_param("Rending_Resistance"), -200, _resistance_max);
                    Slashing_Resistance = clamp(Slashing_Resistance_RAW + Physical_Resistance, -200, _resistance_max);
                    Piercing_Resistance = clamp(Piercing_Resistance_RAW + Physical_Resistance, -200, _resistance_max);
                    Blunt_Resistance = clamp(Blunt_Resistance_RAW + Physical_Resistance, -200, _resistance_max);
                    Rending_Resistance = clamp(Rending_Resistance_RAW + Physical_Resistance, -200, _resistance_max);
                    Arcane_Resistance_RAW = clamp(bArcane_Resistance + scr_buff_param("Arcane_Resistance"), -200, _resistance_max);
                    Unholy_Resistance_RAW = clamp(bUnholy_Resistance + scr_buff_param("Unholy_Resistance"), -200, _resistance_max);
                    Sacred_Resistance_RAW = clamp(bSacred_Resistance + scr_buff_param("Sacred_Resistance"), -200, _resistance_max);
                    Psionic_Resistance_RAW = clamp(bPsionic_Resistance + scr_buff_param("Psionic_Resistance"), -200, _resistance_max);
                    Arcane_Resistance = clamp(Arcane_Resistance_RAW + Magic_Resistance, -200, _resistance_max);
                    Unholy_Resistance = clamp(Unholy_Resistance_RAW + Magic_Resistance, -200, _resistance_max);
                    Sacred_Resistance = clamp(Sacred_Resistance_RAW + Magic_Resistance, -200, _resistance_max);
                    Psionic_Resistance = clamp(Psionic_Resistance_RAW + Magic_Resistance, -200, _resistance_max);
                    Knockback_Resistance = _resistance_max;
                    Bleeding_Resistance = _resistance_max;
                    Stun_Resistance = _resistance_max;

                    if (!Knockback_Immunity)
                        Knockback_Resistance = clamp(bKnockback_Resistance + scr_buff_param("Knockback_Resistance"), -100, _resistance_max);

                    if (!Stun_Immunity)
                        Stun_Resistance = clamp(bStun_Resistance + scr_buff_param("Stun_Resistance"), -100, _resistance_max);

                    if (!Bleeding_Immunity)
                        Bleeding_Resistance = clamp(bBleeding_Resistance + scr_buff_param("Bleeding_Resistance"), -100, _resistance_max);

                    if (object_is_ancestor(object_index, o_Hive))
                    {
                        Knockback_Resistance = _resistance_max;
                        Knockback_Immunity = true;
                    }
                }

                Armor_Damage = clamp(bArmor_Damage + scr_buff_param("Armor_Damage") + STR * 1.5, 0, 500);               // QoL: STR 传导破甲
                Bodypart_Damage = clamp(bBodypart_Damage + scr_buff_param("Bodypart_Damage") + STR * 0.8, 0, 400);     // QoL: STR 传导肢体伤害
                Bleeding_Chance = clamp(bBleeding_Chance + scr_buff_param("Bleeding_Chance") + AGL * 0.4, 0, 200);     // QoL: AGL 传导出血
                Daze_Chance = clamp(bDaze_Chance + scr_buff_param("Daze_Chance") + STR * 0.2, 0, 200);                 // QoL: STR 传导眩晕
                Stun_Chance = clamp(bStun_Chance + scr_buff_param("Stun_Chance") + STR * 0.2, 0, 200);                 // QoL: STR 传导击晕
                Immob_Chance = clamp(bImmob_Chance + scr_buff_param("Immob_Chance") + PRC * 0.2, 0, 200);              // QoL: PRC 传导定身
                Knockback_Chance = clamp(bKnockback_Chance + scr_buff_param("Knockback_Chance") + STR * 0.1 + PRC * 0.1, 0, 200);  // QoL: STR 传导击退
                Stagger_Chance = clamp(bStagger_Chance + scr_buff_param("Stagger_Chance") + STR * 0.2, 0, 200);        // QoL: STR 传导踉跄
                scr_enemy_damage_load();
            }
            else
            {
                var relation = HP / max_hp;
                max_hp = math_round(bHP + scr_buff_param("max_hp"));
                max_hp = math_round(max_hp);
                HP = math_round(max_hp * relation);
                Health_Threshold = clamp(100 - scr_Health_Threshold_calc(isPlayer), 0, 100);
                var _hpChange = (max_hp * Health_Threshold) / 100;

                if (HP > _hpChange)
                    HP = math_round(_hpChange);

                if (max_mp != 0 && bMP != 0)
                {
                    var _relat = MP / max_mp;

                    if (!is_real(_relat))
                        _relat = 1;

                    max_mp = max(1, math_round(bMP + scr_buff_param("max_hp")));
                    MP = math_round(max_mp * _relat);
                    var _mpChange = (max_mp * Max_Energy_Threshold) / 100;

                    if (MP > _mpChange)
                        MP = _mpChange;

                    MP = math_round(MP);
                }
            }
        }
    }

    if (argument0 == o_unit || argument0 == o_player || isPlayer)
    {
        with (o_player)
        {
            if (HP < 1)
                return false;

            scr_player_buff_buffer();
            LVL = scr_atr("LVL");
            STR = clamp(scr_FullAtr("STR"), 5, 160);
            AGL = clamp(scr_FullAtr("AGL"), 5, 160);
            PRC = clamp(scr_FullAtr("PRC"), 5, 160);
            Vitality = clamp(scr_FullAtr("Vitality"), 5, 160);
            WIL = clamp(scr_FullAtr("WIL"), 5, 160);
            var _bonusAGL = floor((AGL - 10)/5);
            var _bonusPRC = floor((PRC - 10)/5);
            var _bonusVIT = floor((Vitality - 10)/5);
            var _bonusWIL = floor((WIL - 10)/5);

            if ((!scr_is_weapon_type_shooting() && scr_inv_param("DMG")) || scr_inv_param("Block_Power"))
            {
                PRR = clamp(-15 + (STR * 1.5) + scr_inv_buff_atr("PRR"), 0, 100);
                var _type = "shield";
                var kWeapon = 0;

                if (instance_exists(o_inv_right_hand.children) && o_inv_right_hand.children.equipped)
                    _type = o_inv_right_hand.children.type;

                if (instance_exists(o_inv_left_hand.children) && _type == "shield")
                {
                    if (o_inv_left_hand.children.equipped)
                        _type = o_inv_left_hand.children.type;
                }

                switch (_type)
                {
                    case "shield":
                        kWeapon = 2;
                        break;

                    case "mace":
                        kWeapon = 0.75;
                        break;

                    case "axe":
                        kWeapon = 0.75;
                        break;

                    case "sword":
                        kWeapon = 1.1;
                        break;

                    case "dagger":
                        kWeapon = 0.5;
                        break;

                    case "2hsword":
                        kWeapon = 1.25;
                        break;

                    case "2hStaff":
                        kWeapon = 0.9;
                        break;

                    case "spear":
                        kWeapon = 1;
                        break;

                    case "2haxe":
                        kWeapon = 0.85;
                        break;

                    case "2hmace":
                        kWeapon = 0.9;
                        break;
                }

                Block_PowerMax = (((STR * kWeapon) + scr_inv_buff_atr("Block_Power")) * (100 + scr_inv_buff_atr("BlockPowerBonus"))) / 100;
                Block_PowerMax = max(Block_PowerMax, 0);
                Block_Power = math_round(Block_PowerMax * Block_RecoveryStatus);
                Block_Recovery = clamp(scr_inv_buff_atr("Block_Recovery") + 5 + (_bonusVIT * 5), 1, 200);
            }
            else
            {
                PRR = 0;
                Block_Power = 0;
                Block_PowerMax = 0;
                Block_Recovery = 0;
            }

            EVS = clamp(1 + scr_atr("bEVS") + scr_inv_buff_atr("EVS") + (_bonusAGL * 5), -25, 300);
            CTA = clamp(-14 + (1.5 * AGL) + scr_inv_buff_atr("CTA"), 0, 300);
            STL = clamp(scr_inv_buff_atr("STL"), -100, 100);
            Savvy = clamp(50 + scr_atr("bSavvy") + scr_inv_buff_atr("Savvy"), 0, 100);
            VSN_Bonus = clamp(scr_buff_param("VSN_Bonus"), -30, 200);
            var _buff_vsn = scr_buff_param("VSN") + scr_atr("bVSN");
            var _base_vsn = (bVSN + _bonusPRC) * (1 + (0.05 * _bonusPRC)) + _buff_vsn;
            VSN = clamp(math_round(_base_vsn * (1 + (VSN_Bonus / 100)) + scr_inv_param("VSN")), 1, 40);

            var _current_buff = scr_buff_param("currentVSN");
            var _current_with_prc = VSN + _current_buff + _bonusPRC * 0.5;
            if (_current_with_prc < VSN)
                currentVSN = clamp(math_round(_current_with_prc), 1, 40);
            else
                currentVSN = clamp(VSN + _current_buff, 1, 40);
            Bonus_Range = math_round(scr_inv_buff_atr("Bonus_Range") + (_bonusPRC * 8));
            MP_turn = scr_buff_param("MP_turn");
            HP_turn = scr_buff_param("HP_turn");
            var relation = HP / max_hp;
            max_hp = math_round(100 + scr_inv_param("HP") + scr_inv_param("max_hp") + scr_buff_param("max_hp") + (_bonusVIT * 15));
            Health_Threshold = clamp(100 - scr_Health_Threshold_calc(isPlayer), 0, 100);
            HP = max_hp * relation;
            var _hpChange = (max_hp * Health_Threshold) / 100;

            if (HP > _hpChange)
                HP = _hpChange;

            HP = max(1, math_round(HP));
            Healing_Received = clamp(100 + scr_inv_buff_atr("Healing_Received"), 0, 1000);
            Toxicity_Resistance = clamp(scr_inv_buff_atr("Toxicity_Resistance"), -100, 200);
            Immunity = clamp(scr_atr("Immunity"), 0, 1000);
            Immunity_Influence = clamp(scr_inv_buff_atr("Immunity_Influence"), 1, 10);
            Health_Restoration = clamp(10 + scr_inv_buff_atr("Health_Restoration"), 0, 1000);
            var _relat = MP / max_mp;
            max_mp = max(math_round(60 + (Vitality * 4) + scr_atr("bMp") + scr_inv_buff_atr("MP") + scr_inv_buff_atr("max_mp")), 1);
            Max_Energy_Threshold = clamp((100 + scr_inv_buff_atr("Max_Energy_Threshold")) - (0.5 * scr_atr("Fatigue")), 0, 100);
            MP = max_mp * _relat;
            var _mpChange = (max_mp * Max_Energy_Threshold) / 100;

            if (MP > _mpChange)
                MP = _mpChange;

            MP = math_round(MP);
            MP_Restoration = clamp(scr_inv_buff_atr("MP_Restoration") + (Vitality * 2), 0, 1000);
            scr_characterStatsUpdateMin("healthLowest", (HP / max_hp) * 100);
            Fortitude = clamp(scr_inv_buff_atr("Fortitude") + (_bonusWIL * 7.5), -100, 200);
            var _weight = 0;

            with (o_inv_weapon_slot)
            {
                with (children)
                {
                    if (Weight == "Light")
                        _weight += 0.25;
                    else if (Weight == "Medium")
                        _weight += 0.5;
                    else if (Weight == "Heavy")
                        _weight += 1;
                }
            }

            var _costWill = 115 + (WIL * -1.5);
            Spells_Energy_Cost = clamp(scr_inv_buff_atr("Spells_Energy_Cost"), -99, 200);
            Skills_Energy_Cost = clamp(scr_inv_buff_atr("Skills_Energy_Cost"), -99, 200);
            Abilities_Energy_Cost = clamp(_costWill + scr_inv_buff_atr("Abilities_Energy_Cost"), 1, 300);
            Cooldown_Reduction = clamp(_costWill + scr_inv_buff_atr("Cooldown_Reduction"), 1, 200);
            Pain_Resistance = clamp(scr_inv_buff_atr("Pain_Resistance") + (_bonusWIL * 7.5), -100, 300);
            var _mainHandItem = noone;
            var _offHandItem = noone;
            var _both_ranged = false;

            if (instance_exists(o_inv_right_hand))
            {
                var _rh_child = o_inv_right_hand.children;
                if (instance_exists(_rh_child) && _rh_child.equipped)
                    _mainHandItem = _rh_child;
            }
            if (instance_exists(o_inv_left_hand))
            {
                var _lh_child = o_inv_left_hand.children;
                if (instance_exists(_lh_child) && _lh_child.equipped)
                    _offHandItem = _lh_child;
            }

            if (instance_exists(_mainHandItem) && instance_exists(_offHandItem))
            {
                var _m_r = variable_instance_exists(_mainHandItem, "haveAmmunitionSlot") && _mainHandItem.haveAmmunitionSlot;
                var _o_r = variable_instance_exists(_offHandItem, "haveAmmunitionSlot") && _offHandItem.haveAmmunitionSlot;
                _both_ranged = _m_r && _o_r;
            }

            Swimming_Cost = clamp(2 + _weight + scr_inv_buff_atr("Swimming_Cost"), 0, 100);
            scr_atr_calc_combat(_mainHandItem, _offHandItem, _both_ranged);
            scr_def_calc(isPlayer);

            range = _both_ranged ? math_round(max(1, ceil(scr_inv_param("Range") / 2)) * (100 + Bonus_Range) / (100 - _bonusPRC)) : math_round(max(1, ceil(scr_inv_param("Range"))) * (100 + Bonus_Range) / (100 - _bonusPRC));

            if (!scr_is_weapon_type_shooting())
                range = 1;

            with (o_skill_attack_mode_shot)
            {
                event_user(7);

                if (is_activate)
                {
                    with (o_aoe_range)
                    {
                        if (scr_tile_distance(id, o_player) > other.range)
                            instance_destroy();
                    }
                }
            }

            melee_range = 2;
            Damage_Returned = clamp(scr_inv_buff_atr("Damage_Returned"), 0, 200);
            Hunger_Resistance = clamp(bHunger_Resistance + scr_inv_buff_atr("Hunger_Resistance"), -100, 200);
            Damage_Received = clamp((100 + scr_inv_buff_atr("Damage_Received") - 10 * scr_check_item_inventory(o_inv_hill_tapestry)) * power(0.98, Vitality - 10), 1, 400);
            Noise_Produced = clamp(100 + scr_inv_buff_atr("Noise_Produced"), 1, 200);
            Backfire_Damage = clamp(scr_atr("Backfire_Damage") + scr_inv_buff_atr("Backfire_Damage"), 0, 200);
            Backfire_Damage_Change = clamp(scr_inv_buff_atr("Backfire_Damage_Change"), -200, 200);
            Miracle_Chance = clamp(5 + (_bonusPRC * 5) + scr_FullAtr("Miracle_Chance"), 0, 300);
            Miracle_Power = clamp(125 + scr_inv_buff_atr("Miracle_Power"), 125, 1000);
            Miscast_Chance = clamp((35 - (1.5 * AGL)) + scr_inv_buff_atr("Miscast_Chance"), -200, 100);
            scr_painlimit(isPlayer);
            Pain_Change = scr_inv_buff_atr("Pain_Change");
            Fatigue_Change = scr_buff_param("Fatigue_Change");
            Toxicity_Change = clamp(scr_inv_buff_atr("Toxicity_Change"), -100, 100);
            Immunity_Change = clamp(scr_inv_buff_atr("Immunity_Change"), -100, 100);
            Hunger_Change = scr_inv_buff_atr("Hunger_Change");
            Thirst_Change = scr_inv_buff_atr("Thirst_Change");
            Sanity_Change = scr_inv_buff_atr("Sanity_Change");
            Morale_Change = scr_inv_buff_atr("Morale_Change");
            Temporary_Morale = scr_inv_buff_atr("MoraleTemporary");
            var _fatigue_gain = 0;
            var _received_xp = 0;

            if (scr_caravanUpgradeIsOpen("Incense"))
            {
                if (scr_atr("Morale") > 50)
                    _fatigue_gain += 8;

                if (scr_atr("Sanity") > 50)
                    _received_xp += 8;
            }

            if (scr_caravanUpgradeIsOpen("Dummy"))
                _received_xp += 8;

            var _bFatigueGain = scr_atr("Fatigue_Gain");

            if (__is_undefined(_bFatigueGain))
                _bFatigueGain = 0;

            Fatigue_Gain = clamp(_bFatigueGain + scr_inv_buff_atr("Fatigue_Gain") + _fatigue_gain, -100, 200);
            Crit_Avoid = clamp(bCrit_Avoid + scr_inv_buff_atr("Crit_Avoid"), -20, 200);
            Received_XP = clamp(scr_FullAtr("Received_XP") + _received_xp, 25, 500);
            ReputationGainGlobal = 100 + scr_FullAtr("ReputationGainGlobal");
            ReputationGainContract = scr_FullAtr("ReputationGainContract");
            Physical_Resistance = scr_inv_buff_param_ext("Physical_Resistance");
            Physical_Resistance_Head = clamp(scr_inv_param_slot("Physical_Resistance", o_inv_head) + Physical_Resistance, -200, 100);
            Physical_Resistance_Tors = clamp(scr_inv_param_slot("Physical_Resistance", o_inv_armor) + Physical_Resistance, -200, 100);
            Physical_Resistance_Hands = clamp(scr_inv_param_slot("Physical_Resistance", o_inv_gloves) + Physical_Resistance, -200, 100);
            Physical_Resistance_Legs = clamp(scr_inv_param_slot("Physical_Resistance", o_inv_boots) + Physical_Resistance, -200, 100);
            Nature_Resistance = scr_inv_buff_param_ext("Nature_Resistance");
            Nature_Resistance_Head = clamp(scr_inv_param_slot("Nature_Resistance", o_inv_head) + Nature_Resistance, -200, 100);
            Nature_Resistance_Tors = clamp(scr_inv_param_slot("Nature_Resistance", o_inv_armor) + Nature_Resistance, -200, 100);
            Nature_Resistance_Hands = clamp(scr_inv_param_slot("Nature_Resistance", o_inv_gloves) + Nature_Resistance, -200, 100);
            Nature_Resistance_Legs = clamp(scr_inv_param_slot("Nature_Resistance", o_inv_boots) + Nature_Resistance, -200, 100);
            Magic_Resistance = scr_inv_buff_param_ext("Magic_Resistance");
            Magic_Resistance_Head = clamp(scr_inv_param_slot("Magic_Resistance", o_inv_head) + Magic_Resistance, -200, 100);
            Magic_Resistance_Tors = clamp(scr_inv_param_slot("Magic_Resistance", o_inv_armor) + Magic_Resistance, -200, 100);
            Magic_Resistance_Hands = clamp(scr_inv_param_slot("Magic_Resistance", o_inv_gloves) + Magic_Resistance, -200, 100);
            Magic_Resistance_Legs = clamp(scr_inv_param_slot("Magic_Resistance", o_inv_boots) + Magic_Resistance, -200, 100);
            scr_resistance_calc("Fire_Resistance", "Nature_Resistance");
            scr_resistance_calc("Frost_Resistance", "Nature_Resistance");
            scr_resistance_calc("Shock_Resistance", "Nature_Resistance");
            scr_resistance_calc("Caustic_Resistance", "Nature_Resistance");
            scr_resistance_calc("Poison_Resistance", "Nature_Resistance");
            scr_resistance_calc("Slashing_Resistance", "Physical_Resistance");
            scr_resistance_calc("Piercing_Resistance", "Physical_Resistance");
            scr_resistance_calc("Blunt_Resistance", "Physical_Resistance");
            scr_resistance_calc("Rending_Resistance", "Physical_Resistance");
            scr_resistance_calc("Arcane_Resistance", "Magic_Resistance");
            scr_resistance_calc("Unholy_Resistance", "Magic_Resistance");
            scr_resistance_calc("Sacred_Resistance", "Magic_Resistance");
            scr_resistance_calc("Psionic_Resistance", "Magic_Resistance");
            Bleeding_Resistance = scr_inv_buff_param_ext("Bleeding_Resistance");
            Bleeding_Resistance_Head = clamp(scr_inv_param_slot("Bleeding_Resistance", o_inv_head) + Bleeding_Resistance + scr_buff_param("Bleeding_Resistance_Head"), -100, 200);
            Bleeding_Resistance_Tors = clamp(scr_inv_param_slot("Bleeding_Resistance", o_inv_armor) + Bleeding_Resistance + scr_buff_param("Bleeding_Resistance_Tors"), -100, 200);
            Bleeding_Resistance_Hands = clamp(scr_inv_param_slot("Bleeding_Resistance", o_inv_gloves) + Bleeding_Resistance + scr_buff_param("Bleeding_Resistance_Hands"), -100, 200);
            Bleeding_Resistance_Legs = clamp(scr_inv_param_slot("Bleeding_Resistance", o_inv_boots) + Bleeding_Resistance + scr_buff_param("Bleeding_Resistance_Legs"), -100, 200);
            Knockback_Resistance = clamp(scr_inv_buff_atr("Knockback_Resistance") + (_bonusAGL * 7.5), -100, 200);
            Stun_Resistance = clamp(scr_inv_buff_atr("Stun_Resistance") + (_bonusVIT * 7.5), -100, 200);
            Pyromantic_Power = scr_inv_buff_atr("Pyromantic_Power");
            Geomantic_Power = scr_inv_buff_atr("Geomantic_Power");
            Venomantic_Power = scr_inv_buff_atr("Venomantic_Power");
            Cryomantic_Power = scr_inv_buff_atr("Cryomantic_Power");
            Electromantic_Power = scr_inv_buff_atr("Electromantic_Power");
            Arcanistic_Power = scr_inv_buff_atr("Arcanistic_Power");
            Astromantic_Power = scr_inv_buff_atr("Astromantic_Power");
            Psimantic_Power = scr_inv_buff_atr("Psimantic_Power");
            Pyromantic_Miscast_Chance = scr_inv_buff_atr("Pyromantic_Miscast_Chance");
            Geomantic_Miscast_Chance = scr_inv_buff_atr("Geomantic_Miscast_Chance");
            Venomantic_Miscast_Chance = scr_inv_buff_atr("Venomantic_Miscast_Chance");
            Cryomantic_Miscast_Chance = scr_inv_buff_atr("Cryomantic_Miscast_Chance");
            Electromantic_Miscast_Chance = scr_inv_buff_atr("Electromantic_Miscast_Chance");
            Arcanistic_Miscast_Chance = scr_inv_buff_atr("Arcanistic_Miscast_Chance");
            Astromantic_Miscast_Chance = scr_inv_buff_atr("Astromantic_Miscast_Chance");
            Psimantic_Miscast_Chance = scr_inv_buff_atr("Psimantic_Miscast_Chance");
            isCrossbowman = false;
            isSlingman = false;
            ranged_skill_learned = global.open_ranged_skill;
            Charge_Distance = scr_buff_param("Charge_Distance");
            Arcanistic_Distance = scr_buff_param("Arcanistic_Distance");
            Daze_Chance_Multiplier = max(1, scr_inv_param("Daze_Chance_Multiplier"));
            Stun_Chance_Multiplier = max(1, scr_inv_param("Stun_Chance_Multiplier"));
            Stagger_Chance_Multiplier = max(1, scr_inv_param("Stun_Chance_Multiplier"));

            with (o_inv_weapon_slot)
            {
                if (instance_exists(children))
                {
                    if (children.isCrossbow)
                        other.isCrossbowman = true;
                    else if (children.isSling)
                        other.isSlingman = true;
                }
            }

            Pain_K = 1;
            Sword_Duration_Resistance = 1 - scr_buff_param("Sword_Duration_Resistance");
            Duration_Resistance = 1 - scr_buff_param("Duration_Resistance");
            var _avoid = 1;

            if (instance_exists(o_pass_skill_lightning_reflexes) && o_pass_skill_lightning_reflexes.is_open)
                _avoid = 2;

            // 0.9.4.22.1 原版兼容：陷阱规避基础值从 25 下调为 5。
            Avoiding_Trap = (5 + EVS + scr_buff_param("Avoiding_Trap")) * _avoid;
            Trade_Favorability = scr_buff_param("Trade_Favorability");
            scr_gold_count();
        }
    }
}

function scr_def_calc(argument0)
{
    if (argument0)
    {
        DEF = max(0, 0 + scr_buff_param("DEF"));
        Head_DEF = scr_inv_param_slot("DEF", o_inv_head) + DEF + scr_buff_param("Head_DEF");
        Body_DEF = scr_inv_param_slot("DEF", o_inv_armor) + DEF + scr_buff_param("Body_DEF");
        Arms_DEF = scr_inv_param_slot("DEF", o_inv_gloves) + DEF + scr_buff_param("Arms_DEF");
        Legs_DEF = scr_inv_param_slot("DEF", o_inv_boots) + DEF + scr_buff_param("Legs_DEF");
    }
    else
    {
        var _ArmorDurabilityNormalized = ArmorDurability / 100;
        Head_DEF = (bHead_DEF * _ArmorDurabilityNormalized) + scr_enemy_buff_param("Head_DEF");
        Body_DEF = (bBody_DEF * _ArmorDurabilityNormalized) + scr_enemy_buff_param("Body_DEF");
        Arms_DEF = (bArms_DEF * _ArmorDurabilityNormalized) + scr_enemy_buff_param("Arms_DEF");
        Legs_DEF = (bLegs_DEF * _ArmorDurabilityNormalized) + scr_enemy_buff_param("Legs_DEF");
    }
}

function scr_resistance_calc(argument0, argument1)
{
    var _general_resistance = scr_inv_buff_param_ext(argument0);
    variable_instance_set(id, argument0, _general_resistance);
    var _head_resistance = clamp(scr_inv_param_slot(argument0, o_inv_head) + _general_resistance, -200, 100);
    var _tors_resistance = clamp(scr_inv_param_slot(argument0, o_inv_armor) + _general_resistance, -200, 100);
    var _hands_resistance = clamp(scr_inv_param_slot(argument0, o_inv_gloves) + _general_resistance, -200, 100);
    var _legs_resistance = clamp(scr_inv_param_slot(argument0, o_inv_boots) + _general_resistance, -200, 100);
    variable_instance_set(id, argument0 + "_Head_RAW", _head_resistance);
    variable_instance_set(id, argument0 + "_Tors_RAW", _tors_resistance);
    variable_instance_set(id, argument0 + "_Hands_RAW", _hands_resistance);
    variable_instance_set(id, argument0 + "_Legs_RAW", _legs_resistance);
    var _additional_resistance_head = variable_instance_get(id, argument1 + "_Head");
    var _additional_resistance_tors = variable_instance_get(id, argument1 + "_Tors");
    var _additional_resistance_hands = variable_instance_get(id, argument1 + "_Hands");
    var _additional_resistance_legs = variable_instance_get(id, argument1 + "_Legs");
    variable_instance_set(id, argument0 + "_Head", clamp(_head_resistance + _additional_resistance_head, -200, 100));
    variable_instance_set(id, argument0 + "_Tors", clamp(_tors_resistance + _additional_resistance_tors, -200, 100));
    variable_instance_set(id, argument0 + "_Hands", clamp(_hands_resistance + _additional_resistance_hands, -200, 100));
    variable_instance_set(id, argument0 + "_Legs", clamp(_legs_resistance + _additional_resistance_legs, -200, 100));
}
