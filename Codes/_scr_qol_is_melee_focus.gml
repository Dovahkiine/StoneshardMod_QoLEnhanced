function _scr_qol_is_melee_focus()
{
    // QoLEnhanced - 近战专注判定。
    //
    // 这个 helper 会被 scr_atr_calc 调用，而 scr_atr_calc 也会在 o_player 的早期 Alarm_11 中执行。
    // 因此这里必须把“实例尚未创建”视作正常状态，不能直接通过对象索引读取实例字段。
    //
    // 判定边界：
    // 1) 双手槽位都已经存在，且双手都没有已装备物品时，视作空手近战。
    // 2) 至少装备一件非射击武器时，视作近战。
    // 3) 盾牌、工具、纯远程武器不能单独触发近战抗控。
    // 4) 法术技能数量必须严格少于其他已学习技能数量，避免法师/半法师路线拿到完整近战补偿。
    // 5) 如果手部槽位或技能树实例还没有创建完成，直接返回 false；下一次属性刷新会重新计算。
    var _has_right_slot = instance_exists(o_inv_right_hand);
    var _has_left_slot = instance_exists(o_inv_left_hand);
    
    if (!_has_right_slot || !_has_left_slot)
        return false;
    
    var _equipped_hand_item_count = 0;
    var _melee_weapon_count = 0;
    
    var _right_slot = instance_find(o_inv_right_hand, 0);
    var _left_slot = instance_find(o_inv_left_hand, 0);
    
    if (!instance_exists(_right_slot) || !instance_exists(_left_slot))
        return false;
    
    // 右手检查：先取槽位实例，再取 children，避免在早期属性刷新中把对象索引当作实例读取。
    if (variable_instance_exists(_right_slot, "children"))
    {
        var _right_item = _right_slot.children;
        
        if (instance_exists(_right_item) && variable_instance_exists(_right_item, "equipped") && _right_item.equipped)
        {
            _equipped_hand_item_count++;
            
            var _right_is_weapon = false;
            var _right_is_ranged = false;
            
            if (variable_instance_exists(_right_item, "data") && ds_exists(_right_item.data, ds_type_map))
                _right_is_weapon = ds_map_find_value(_right_item.data, "Metatype") == "Weapon";
            
            if (variable_instance_exists(_right_item, "haveAmmunitionSlot"))
                _right_is_ranged = _right_item.haveAmmunitionSlot;
            
            if (_right_is_weapon && !_right_is_ranged)
                _melee_weapon_count++;
        }
    }
    
    // 左手检查：与右手保持完全对称，保证双持、副手、近战+盾牌的判定一致。
    if (variable_instance_exists(_left_slot, "children"))
    {
        var _left_item = _left_slot.children;
        
        if (instance_exists(_left_item) && variable_instance_exists(_left_item, "equipped") && _left_item.equipped)
        {
            _equipped_hand_item_count++;
            
            var _left_is_weapon = false;
            var _left_is_ranged = false;
            
            if (variable_instance_exists(_left_item, "data") && ds_exists(_left_item.data, ds_type_map))
                _left_is_weapon = ds_map_find_value(_left_item.data, "Metatype") == "Weapon";
            
            if (variable_instance_exists(_left_item, "haveAmmunitionSlot"))
                _left_is_ranged = _left_item.haveAmmunitionSlot;
            
            if (_left_is_weapon && !_left_is_ranged)
                _melee_weapon_count++;
        }
    }
    
    var _is_melee_loadout = (_equipped_hand_item_count == 0) || (_melee_weapon_count > 0);
    
    if (!_is_melee_loadout)
        return false;
    
    var _spell_skill_count = 0;
    var _other_skill_count = 0;
    var _has_any_skill_category = false;
    
    // 法术分类显式列出，避免在属性热路径里 with(o_skill_category) 扫父类对象。
    // mastery_of_magic 属于法术专精；wands 在原版不是 spell class，这里按非术法分类统计。
    var _spell_categories = [
        o_skill_category_arcanistics,
        o_skill_category_astromancy,
        o_skill_category_cryomancy,
        o_skill_category_electromancy,
        o_skill_category_geomancy,
        o_skill_category_mastery_of_magic,
        o_skill_category_psymancy,
        o_skill_category_pyromancy,
        o_skill_category_venomancy
    ];
    
    for (var i = 0; i < array_length(_spell_categories); i++)
    {
        var _category_object = _spell_categories[i];
        
        if (instance_exists(_category_object))
        {
            _has_any_skill_category = true;
            var _category_instance = instance_find(_category_object, 0);
            
            if (instance_exists(_category_instance) && variable_instance_exists(_category_instance, "skill"))
            {
                for (var j = 0; j < array_length(_category_instance.skill); j++)
                {
                    var _skill_object = _category_instance.skill[j];
                    
                    if (instance_exists(_skill_object))
                    {
                        var _skill_instance = instance_find(_skill_object, 0);
                        
                        if (instance_exists(_skill_instance) && variable_instance_exists(_skill_instance, "is_open") && _skill_instance.is_open)
                            _spell_skill_count++;
                    }
                }
            }
        }
    }
    
    // 非法术分类同样只扫描具体分类对象。
    // mob_skill/mob_skill_2 是怪物技能容器，不计入玩家专精；其余玩家可学习分类计入“其他类别技能”。
    var _other_categories = [
        o_skill_category_alchemy,
        o_skill_category_athletics,
        o_skill_category_axe,
        o_skill_category_basic_armor,
        o_skill_category_basic_skills,
        o_skill_category_bows,
        o_skill_category_class_skills,
        o_skill_category_combat,
        o_skill_category_crossbows,
        o_skill_category_dagger,
        o_skill_category_dual_wielding,
        o_skill_category_greataxe,
        o_skill_category_greatmauls,
        o_skill_category_greatsword,
        o_skill_category_mace,
        o_skill_category_medicine,
        o_skill_category_polearms,
        o_skill_category_sabotage,
        o_skill_category_shields,
        o_skill_category_staves,
        o_skill_category_survival,
        o_skill_category_sword,
        o_skill_category_utility,
        o_skill_category_wands,
        o_skill_category_weapon
    ];
    
    for (var k = 0; k < array_length(_other_categories); k++)
    {
        var _other_category_object = _other_categories[k];
        
        if (instance_exists(_other_category_object))
        {
            _has_any_skill_category = true;
            var _other_category_instance = instance_find(_other_category_object, 0);
            
            if (instance_exists(_other_category_instance) && variable_instance_exists(_other_category_instance, "skill"))
            {
                for (var m = 0; m < array_length(_other_category_instance.skill); m++)
                {
                    var _other_skill_object = _other_category_instance.skill[m];
                    
                    if (instance_exists(_other_skill_object))
                    {
                        var _other_skill_instance = instance_find(_other_skill_object, 0);
                        
                        if (instance_exists(_other_skill_instance) && variable_instance_exists(_other_skill_instance, "is_open") && _other_skill_instance.is_open)
                            _other_skill_count++;
                    }
                }
            }
        }
    }
    
    if (!_has_any_skill_category)
        return false;
    
    return _spell_skill_count < _other_skill_count;
}
