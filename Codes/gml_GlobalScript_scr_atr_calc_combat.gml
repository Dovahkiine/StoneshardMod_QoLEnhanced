function scr_atr_calc_combat(argument0, argument1, argument2) // o_inv_slot 是对象符号；不要用 UMT 导出的硬编码对象 ID 做匹配
{
    if (!instance_exists(o_inv_left_hand) || !instance_exists(o_inv_right_hand))
        exit;
    
    if (!is_player())
    {
        scr_atr_calc(id, true);
        exit;
    }
    
    var _bonusAGL = floor((AGL - 10)/5);
    var _bonusSTR = floor((STR - 10)/5);
    Mainhand_Efficiency = clamp(100 + scr_inv_buff_atr("Mainhand_Efficiency") + (2.5 * _bonusAGL), 30, 500);
    Offhand_Efficiency = clamp(100 + scr_inv_buff_atr("Offhand_Efficiency") + (2.5 * _bonusAGL), 30, 500);
    var _isTwoHand = false;
    var _weapon_count = 0;
    
    with (o_weapon_slot_parent)
    {
        if (instance_exists(children))
        {
            if (children.equipped)
                _weapon_count++;
            
            if (children.object_index == o_inv_slot)
            {
                if (children.hands == 2)
                    _isTwoHand = true;
            }
        }
    }
    
    if (_isTwoHand)
    {
        Mainhand_Efficiency = max(100, Mainhand_Efficiency);
        Offhand_Efficiency = max(100, Offhand_Efficiency);
    }
    
    var _mainHandItem = (argument0 == undefined) ? noone : argument0;
    var _offHandItem = (argument1 == undefined) ? noone : argument1;
    var _both_ranged = (argument2 == undefined) ? false : argument2;
    
    if (argument0 == undefined || argument1 == undefined)
    {
        var _rh_child = o_inv_right_hand.children;
        var _lh_child = o_inv_left_hand.children;
        
        if (instance_exists(_rh_child))
            _mainHandItem = _rh_child;
        if (instance_exists(_lh_child))
            _offHandItem = _lh_child;
    }
    var _mainHandDebuff = Mainhand_Efficiency / 100;
    var _offHandDebuff = Offhand_Efficiency / 100;
    
    if (_weapon_count == 1 && !instance_exists(o_db_dual_wielding))
        _offHandDebuff = _mainHandDebuff;
    
    var _main_weapon_hit_chance = scr_inv_param("Hit_Chance", _mainHandItem);
    
    if (_main_weapon_hit_chance)
        mainHitChance = _main_weapon_hit_chance * _mainHandDebuff;
    else
        mainHitChance = _main_weapon_hit_chance / _mainHandDebuff;
    
    var _off_weapon_hit_chance = scr_inv_param("Hit_Chance", _offHandItem);
    
    if (_off_weapon_hit_chance)
        offHitChance = _off_weapon_hit_chance * _offHandDebuff;
    else
        offHitChance = _off_weapon_hit_chance / _offHandDebuff;
      
    var _hitChance = scr_inv_param("Hit_Chance", o_inv_slot, true) + scr_buff_param("Hit_Chance");

    if (argument2 == undefined && instance_exists(_mainHandItem) && instance_exists(_offHandItem))
    {
        var _m_r = variable_instance_exists(_mainHandItem, "haveAmmunitionSlot") && _mainHandItem.haveAmmunitionSlot;
        var _o_r = variable_instance_exists(_offHandItem, "haveAmmunitionSlot") && _offHandItem.haveAmmunitionSlot;
        _both_ranged = _m_r && _o_r;
    }

    var _prc_coef = _both_ranged ? 1.8 : 1.5;
    var _source = 65 + (_prc_coef * PRC) + _hitChance;

    if (_both_ranged)
        Hit_Chance = clamp(_source + (0.8 * mainHitChance) + (0.4 * offHitChance), 10, 400);
    else
        Hit_Chance = clamp(_source + mainHitChance + offHitChance, 10, 400);
    
    mainHitChance = clamp(_source + mainHitChance, 10, 400);
    offHitChance = clamp(_source + offHitChance, 10, 400);
    mainCRTD = (scr_inv_param("CRTD", _mainHandItem) * _mainHandDebuff) + scr_buff_param("CRTD_Main");
    offCRTD = (scr_inv_param("CRTD", _offHandItem) * _offHandDebuff) + scr_buff_param("CRTD_Off");
    var _critDMG = scr_inv_param("CRTD", o_inv_slot, true) + scr_buff_param("CRTD");
    _source = 125 + _critDMG + (_bonusSTR * 10);
    CRTD = clamp(_source + mainCRTD + offCRTD, 125, 1000);
    mainCRTD = clamp(_source + mainCRTD, 125, 1000);
    offCRTD = clamp(_source + offCRTD, 125, 1000);
    mainCRT = (scr_inv_param("CRT", _mainHandItem) * _mainHandDebuff) + scr_buff_param("CRT_Main");
    offCRT = (scr_inv_param("CRT", _offHandItem) * _offHandDebuff) + scr_buff_param("CRT_Off");
    var _critChance = scr_inv_param("CRT", o_inv_slot, true) + scr_buff_param("CRT");
    var _bonusPRC = floor((PRC - 10) / 5) * 5;
    _source = 1 + _critChance + _bonusPRC;
    CRT = clamp(_source + mainCRT + offCRT, 0, 400);
    mainCRT = clamp(_source + mainCRT, 0, 400);
    offCRT = clamp(_source + offCRT, 0, 400);
    mainArmorDamage = scr_inv_param("Armor_Damage", _mainHandItem) * _mainHandDebuff;
    offArmorDamage = scr_inv_param("Armor_Damage", _offHandItem) * _offHandDebuff;
    var _armorDamage = scr_inv_param("Armor_Damage", o_inv_slot, true) + scr_buff_param("Armor_Damage");
    _source = _armorDamage + (_bonusSTR * 15);
    Armor_Damage = clamp(_source + mainArmorDamage + offArmorDamage, 0, 1000);
    mainArmorDamage = clamp(_source + mainArmorDamage, 0, 1000);
    offArmorDamage = clamp(_source + offArmorDamage, 0, 1000);
    mainArmorPiercing = scr_inv_param("Armor_Piercing", _mainHandItem) * _mainHandDebuff;
    offArmorPiercing = scr_inv_param("Armor_Piercing", _offHandItem) * _offHandDebuff;
    var _armorPiercing = scr_inv_param("Armor_Piercing", o_inv_slot, true) + scr_buff_param("Armor_Piercing");
    _source = -15 + (1.5 * PRC) + _armorPiercing;
    Armor_Piercing = clamp(_source + mainArmorPiercing + offArmorPiercing, 0, 200);
    mainArmorPiercing = clamp(_source + mainArmorPiercing, 0, 200);
    offArmorPiercing = clamp(_source + offArmorPiercing, 0, 200);
    Spell_Armor_Piercing = clamp(bSpell_Armor_Piercing + scr_inv_buff_atr("Spell_Armor_Piercing") + (1.5 * PRC), 0, 200);
    Spell_Hit_Chance = clamp(bSpell_Hit_Chance + scr_inv_buff_atr("Spell_Hit_Chance") + (1.5 * PRC), 5, 500);
    mainLifesteal = scr_inv_param("Lifesteal", _mainHandItem) * _mainHandDebuff;
    offLifesteal = scr_inv_param("Lifesteal", _offHandItem) * _offHandDebuff;
    var _lifesteal = scr_inv_param("Lifesteal", o_inv_slot, true) + scr_buff_param("Lifesteal");
    Lifesteal = clamp(_lifesteal + mainLifesteal + offLifesteal, 0, 100);
    mainLifesteal = clamp(_lifesteal + mainLifesteal, 0, 100);
    offLifesteal = clamp(_lifesteal + offLifesteal, 0, 100);
    mainManasteal = scr_inv_param("Manasteal", _mainHandItem) * _mainHandDebuff;
    offManasteal = scr_inv_param("Manasteal", _offHandItem) * _offHandDebuff;
    var _manasteal = scr_inv_param("Manasteal", o_inv_slot, true) + scr_buff_param("Manasteal");
    Manasteal = clamp(_manasteal + mainManasteal + offManasteal, 0, 100);
    mainManasteal = clamp(_manasteal + mainManasteal, 0, 100);
    offManasteal = clamp(_manasteal + offManasteal, 0, 100);
    mainBodyDamage = scr_inv_param("Bodypart_Damage", _mainHandItem) * _mainHandDebuff;
    offBodyDamage = scr_inv_param("Bodypart_Damage", _offHandItem) * _offHandDebuff;
    var _bodyDamage = scr_inv_param("Bodypart_Damage", o_inv_slot, true) + scr_buff_param("Bodypart_Damage");
    _source = (7.5 * _bonusSTR) + _bodyDamage;
    Bodypart_Damage = clamp(_source + mainBodyDamage + offBodyDamage, 0, 1000);
    mainBodyDamage = clamp(_source + mainBodyDamage, 0, 1000);
    offBodyDamage = clamp(_source + offBodyDamage, 0, 1000);
    mainBleed = (scr_inv_param("Bleeding_Chance", _mainHandItem) * _mainHandDebuff) + scr_buff_param("Bleeding_Chance_Main");
    offBleed = (scr_inv_param("Bleeding_Chance", _offHandItem) * _offHandDebuff) + scr_buff_param("Bleeding_Chance_Off");
    var _bleedChance = scr_inv_param("Bleeding_Chance", o_inv_slot, true) + scr_buff_param("Bleeding_Chance");
    Bleeding_Chance = clamp(_bleedChance + mainBleed + offBleed, 0, 400);
    mainBleed = clamp(_bleedChance + mainBleed, 0, 400);
    offBleed = clamp(_bleedChance + offBleed, 0, 400);
    mainDaze = scr_inv_param("Daze_Chance", _mainHandItem) * _mainHandDebuff;
    offDaze = scr_inv_param("Daze_Chance", _offHandItem) * _offHandDebuff;
    var _dazeChance = scr_inv_param("Daze_Chance", o_inv_slot, true) + scr_buff_param("Daze_Chance");
    Daze_Chance = clamp(_dazeChance + mainDaze + offDaze, 0, 400);
    mainDaze = clamp(_dazeChance + mainDaze, 0, 400);
    offDaze = clamp(_dazeChance + offDaze, 0, 400);
    mainKnockback = scr_inv_param("Knockback_Chance", _mainHandItem) * _mainHandDebuff;
    offKnockback = scr_inv_param("Knockback_Chance", _offHandItem) * _offHandDebuff;
    var _knockbackChance = scr_inv_param("Knockback_Chance", o_inv_slot, true) + scr_buff_param("Knockback_Chance");
    Knockback_Chance = clamp(_knockbackChance + mainKnockback + offKnockback, 0, 400);
    mainKnockback = clamp(_knockbackChance + mainKnockback, 0, 400);
    offKnockback = clamp(_knockbackChance + offKnockback, 0, 400);
    mainStun = scr_inv_param("Stun_Chance", _mainHandItem) * _mainHandDebuff;
    offStun = scr_inv_param("Stun_Chance", _offHandItem) * _offHandDebuff;
    var _stunChance = scr_inv_param("Stun_Chance", o_inv_slot, true) + scr_buff_param("Stun_Chance");
    Stun_Chance = clamp(_stunChance + mainStun + offStun, 0, 400);
    mainStun = clamp(_stunChance + mainStun, 0, 400);
    offStun = clamp(_stunChance + offStun, 0, 400);
    mainImmob = scr_inv_param("Immob_Chance", _mainHandItem) * _mainHandDebuff;
    offImmob = scr_inv_param("Immob_Chance", _offHandItem) * _offHandDebuff;
    var _immobChance = scr_inv_param("Immob_Chance", o_inv_slot, true) + scr_buff_param("Immob_Chance");
    Immob_Chance = clamp(_immobChance + mainImmob + offImmob, 0, 400);
    mainImmob = clamp(_immobChance + mainImmob, 0, 400);
    offImmob = clamp(_immobChance + offImmob, 0, 400);
    mainStagger = scr_inv_param("Stagger_Chance", _mainHandItem) * _mainHandDebuff;
    offStagger = scr_inv_param("Stagger_Chance", _offHandItem) * _offHandDebuff;
    var _staggerChance = scr_inv_param("Stagger_Chance", o_inv_slot, true) + scr_buff_param("Stagger_Chance");
    Stagger_Chance = clamp(_staggerChance + mainStagger + offStagger, 0, 400);
    mainStagger = clamp(_staggerChance + mainStagger, 0, 400);
    offStagger = clamp(_staggerChance + offStagger, 0, 400);
    var _main_weapon_fmb = scr_inv_param("FMB", _mainHandItem);
    var _off_weapon_fmb = scr_inv_param("FMB", _offHandItem);
    
    if (_main_weapon_fmb)
        mainFMB = _main_weapon_fmb / _mainHandDebuff;
    else
        mainFMB = _main_weapon_fmb * _mainHandDebuff;
    
    if (_off_weapon_fmb)
        offFMB = _off_weapon_fmb / _offHandDebuff;
    else
        offFMB = _off_weapon_fmb * _offHandDebuff;
    
    var _fumble = scr_inv_param("FMB", o_inv_slot, true) + scr_buff_param("FMB");
    _source = (35 + _fumble) - (1.5 * AGL);
    FMB = clamp(_source + mainFMB + offFMB, 0, 100);
    mainFMB = clamp(_source + mainFMB, 0, 100);
    offFMB = clamp(_source + offFMB, 0, 100);
    mainWD = (scr_inv_param("Weapon_Damage", _mainHandItem) * _mainHandDebuff) + scr_buff_param("Weapon_Damage_Main");
    offWD = (scr_inv_param("Weapon_Damage", _offHandItem) * _offHandDebuff) + scr_buff_param("Weapon_Damage_Off");
    var _weaponDamage = scr_inv_param("Weapon_Damage", o_inv_slot, true) + scr_buff_param("Weapon_Damage");
    
    if (scr_is_weapon_type_shooting())
        atr = 0;
    else
        atr = 0;
    
    _source = 85 + _weaponDamage + (1.5 * STR) + (0.5 * STR * scr_check_item_inventory(o_inv_hill_tapestry));
    Weapon_Damage = clamp(_source + mainWD + offWD, 25, 1000);
    mainWD = clamp(_source + mainWD, 25, 1000);
    offWD = clamp(_source + offWD, 25, 1000);
    var _mainSlashing = scr_inv_param("Slashing_Damage", _mainHandItem) * _mainHandDebuff;
    var _offSlashing = scr_inv_param("Slashing_Damage", _offHandItem) * _offHandDebuff;
    var _mainPiercing = scr_inv_param("Piercing_Damage", _mainHandItem) * _mainHandDebuff;
    var _offPiercing = scr_inv_param("Piercing_Damage", _offHandItem) * _offHandDebuff;
    var _mainBlunt = scr_inv_param("Blunt_Damage", _mainHandItem) * _mainHandDebuff;
    var _offBlunt = scr_inv_param("Blunt_Damage", _offHandItem) * _offHandDebuff;
    var _mainRending = scr_inv_param("Rending_Damage", _mainHandItem) * _mainHandDebuff;
    var _offRending = scr_inv_param("Rending_Damage", _offHandItem) * _offHandDebuff;
    var _buffSlashing = scr_buff_param("Slashing_Damage");
    var _buffPiercing = scr_buff_param("Piercing_Damage");
    var _buffBlunt = scr_buff_param("Blunt_Damage");
    var _buffRending = scr_buff_param("Rending_Damage");
    Slashing_Damage = _mainSlashing + _offSlashing + _buffSlashing;
    Piercing_Damage = _mainPiercing + _offPiercing + _buffPiercing;
    Blunt_Damage = _mainBlunt + _offBlunt + _buffBlunt;
    Rending_Damage = _mainRending + _offRending + _buffRending;
    Magic_Power = clamp(100 + scr_inv_buff_atr("Magic_Power") + floor((WIL - 10) / 5) * 7.5, 25, 1000);
    var _buffFire_Damage = scr_buff_param("Fire_Damage");
    var _buffShock_Damage = scr_buff_param("Shock_Damage");
    var _buffFrost_Damage = scr_buff_param("Frost_Damage");
    var _buffCaustic_Damage = scr_buff_param("Caustic_Damage");
    var _buffPoison_Damage = scr_buff_param("Poison_Damage");
    var _buffArcane_Damage = scr_buff_param("Arcane_Damage");
    var _buffPsionic_Damage = scr_buff_param("Psionic_Damage");
    var _buffUnholy_Damage = scr_buff_param("Unholy_Damage");
    var _buffSacred_Damage = scr_buff_param("Sacred_Damage");
    var _mainFire_Damage = scr_inv_param("Fire_Damage", _mainHandItem) * _mainHandDebuff;
    var _mainShock_Damage = scr_inv_param("Shock_Damage", _mainHandItem) * _mainHandDebuff;
    var _mainFrost_Damage = scr_inv_param("Frost_Damage", _mainHandItem) * _mainHandDebuff;
    var _mainCaustic_Damage = scr_inv_param("Caustic_Damage", _mainHandItem) * _mainHandDebuff;
    var _mainPoison_Damage = scr_inv_param("Poison_Damage", _mainHandItem) * _mainHandDebuff;
    var _mainArcane_Damage = scr_inv_param("Arcane_Damage", _mainHandItem) * _mainHandDebuff;
    var _mainPsionic_Damage = scr_inv_param("Psionic_Damage", _mainHandItem) * _mainHandDebuff;
    var _mainUnholy_Damage = scr_inv_param("Unholy_Damage", _mainHandItem) * _mainHandDebuff;
    var _mainSacred_Damage = scr_inv_param("Sacred_Damage", _mainHandItem) * _mainHandDebuff;
    var _offFire_Damage = scr_inv_param("Fire_Damage", _offHandItem) * _offHandDebuff;
    var _offShock_Damage = scr_inv_param("Shock_Damage", _offHandItem) * _offHandDebuff;
    var _offFrost_Damage = scr_inv_param("Frost_Damage", _offHandItem) * _offHandDebuff;
    var _offCaustic_Damage = scr_inv_param("Caustic_Damage", _offHandItem) * _offHandDebuff;
    var _offPoison_Damage = scr_inv_param("Poison_Damage", _offHandItem) * _offHandDebuff;
    var _offArcane_Damage = scr_inv_param("Arcane_Damage", _offHandItem) * _offHandDebuff;
    var _offPsionic_Damage = scr_inv_param("Psionic_Damage", _offHandItem) * _offHandDebuff;
    var _offUnholy_Damage = scr_inv_param("Unholy_Damage", _offHandItem) * _offHandDebuff;
    var _offSacred_Damage = scr_inv_param("Sacred_Damage", _offHandItem) * _offHandDebuff;
    Fire_Damage = _mainFire_Damage + _offFire_Damage + _buffFire_Damage;
    Shock_Damage = _mainShock_Damage + _offShock_Damage + _buffShock_Damage;
    Frost_Damage = _mainFrost_Damage + _offFrost_Damage + _buffFrost_Damage;
    Caustic_Damage = _mainCaustic_Damage + _offCaustic_Damage + _buffCaustic_Damage;
    Poison_Damage = _mainPoison_Damage + _offPoison_Damage + _buffPoison_Damage;
    Arcane_Damage = _mainArcane_Damage + _offArcane_Damage + _buffArcane_Damage;
    Psionic_Damage = _mainPsionic_Damage + _offPsionic_Damage + _buffPsionic_Damage;
    Unholy_Damage = _mainUnholy_Damage + _offUnholy_Damage + _buffUnholy_Damage;
    Sacred_Damage = _mainSacred_Damage + _offSacred_Damage + _buffSacred_Damage;
    magicMainDMG = 0;
    magicOffDMG = 0;
    var _MP = Magic_Power / 100;
    magicMainDMG = _mainFire_Damage + _buffFire_Damage + (_mainShock_Damage + _buffShock_Damage) + (_mainFrost_Damage + _buffFrost_Damage) + (_mainCaustic_Damage + _buffCaustic_Damage) + (_mainPoison_Damage + _buffPoison_Damage) + (_mainArcane_Damage + _buffArcane_Damage) + (_mainPsionic_Damage + _buffPsionic_Damage) + (_mainUnholy_Damage + _buffUnholy_Damage) + (_mainSacred_Damage + _buffSacred_Damage);
    magicMainDMG *= _MP;
    magicOffDMG = _offFire_Damage + _buffFire_Damage + (_offShock_Damage + _buffShock_Damage) + (_offFrost_Damage + _buffFrost_Damage) + (_offCaustic_Damage + _buffCaustic_Damage) + (_offPoison_Damage + _buffPoison_Damage) + (_offArcane_Damage + _buffArcane_Damage) + (_offPsionic_Damage + _buffPsionic_Damage) + (_offUnholy_Damage + _buffUnholy_Damage) + (_offSacred_Damage + _buffSacred_Damage);
    magicOffDMG *= _MP;
    var inv_dmg = scr_inv_param("DMG");
    DMG = 0;
    offDMG = 0;
    melee_damage = STR;
    var _melee_damage = 0;

    with (o_inv_gloves)
    {
        if (children > 0)
        {
            with (children)
                _melee_damage += scr_inv_param("DEF", id);
        }
    }
    
    melee_damage += _melee_damage;

    if (inv_dmg == 0 || isGround == -1)
    {
        scr_enemy_damage_reset();
        DMG = melee_damage;
        offDMG = DMG;
        Blunt_Damage = DMG;
        DamageType = "Blunt_Damage";
    }
    else
    {
        DMG = (_mainSlashing + _buffSlashing + (_mainPiercing + _buffPiercing) + (_mainBlunt + _buffBlunt) + (_mainRending + _offRending + _buffRending)) * (Weapon_Damage / 100);
        offDMG = (_offSlashing + _buffSlashing + (_offPiercing + _buffPiercing) + (_offBlunt + _buffBlunt) + (_mainRending + _offRending + _buffRending)) * (Weapon_Damage / 100);
        
        if (instance_exists(o_inv_left_hand) && instance_exists(o_inv_right_hand))
        {
            if (instance_exists(o_inv_left_hand.children))
            {
                if (o_inv_left_hand.children.object_index == o_inv_slot)
                {
                    if (ds_map_find_value(o_inv_left_hand.children.data, "Metatype") == "Weapon")
                        DamageType = o_inv_left_hand.children.DamageType;
                }
            }
            
            if (instance_exists(o_inv_right_hand.children))
            {
                if (o_inv_right_hand.children.object_index == o_inv_slot)
                {
                    if (ds_map_find_value(o_inv_right_hand.children.data, "Metatype") == "Weapon")
                        DamageType = o_inv_right_hand.children.DamageType;
                }
            }
        }
        
        if (_isTwoHand)
        {
            if (DMG > offDMG)
                offDMG = DMG;
            else
                DMG = offDMG;
            
            if (magicMainDMG > magicOffDMG)
                magicOffDMG = magicMainDMG;
            else
                magicMainDMG = magicOffDMG;
        }
    }
}
