event_inherited();
contentWidth = (drawAreaWidth - (contentSpaceX * 2)) * surfaceScale;
var _lineHeight = lineHeight;
var _spaceHeight = spaceHeight;
var _fontDmgHeight = fontDmgHeight;
var _showFullStats = keyboard_check(vk_alt);

with (unit)
{
    other.titleHeight = scr_stringGetHeightExt(name, other.contentWidth, global.f_digits, other.textScale);
    other.typeHeight = (string_length(string_replace_all(type, " ", "")) > 0) ? (_fontDmgHeight + _spaceHeight) : 0;
    other.statusHeight = _fontDmgHeight;
    other.contentHeight += (other.titleHeight + other.typeHeight + other.statusHeight + _lineHeight);
    other.mainParamsHeight = _fontDmgHeight * 2;
    
    if ((Head_DEF + Body_DEF + Arms_DEF + Legs_DEF) > 0)
        other.armorDurabilityHeight = _fontDmgHeight;
    
    if (morale_k > 0)
        other.moraleHeight = _fontDmgHeight;
    
    other.contentHeight += (other.mainParamsHeight + other.armorDurabilityHeight + other.moraleHeight);
    var _buffsListSize = ds_list_size(buffs);
    
    if (_buffsListSize)
    {
        var _buffsContainer = other.buffsContainer;
        var _buffWidth = other.buffWidth;
        var _buffHeight = other.buffHeight;
        var _buffOffsetLeft = floor(_buffWidth / 2);
        var _buffOffsetTop = floor(_buffHeight / 2);
        var _buffsCount = 0;
        
        for (var _i = 0; _i < _buffsListSize; _i++)
        {
            var _buff = ds_list_find_value(buffs, _i);
            
            if (instance_exists(_buff))
            {
                with (_buff)
                {
                    if (global.buff_info || !object_is(object_index, o_invisible_buff))
                    {
                        depth = _buffsContainer.depth - 1;
                        guiVisibility = true;
                        scr_guiVisibleUpdate(id, true);
                        scr_guiSizeUpdate(id, _buffWidth, _buffHeight);
                        scr_guiLayoutOffsetUpdate(id, _buffOffsetLeft, _buffOffsetTop);
                        scr_guiContainerChildAdd(_buffsContainer, id);
                        scr_guiInteractiveEventUpdate(id, 14);
                        _buffsCount++;
                    }
                }
            }
            else
            {
                show_error_message("BUFF NOT FOUND", "Object name " + string(object_get_name(_buff)));
            }
        }
        
        if (_buffsCount)
            other.contentHeight += (_spaceHeight + _fontDmgHeight + _lineHeight);
        
        var _buffsContainerOffsetLeft = other.contentX / other.surfaceScale;
        var _buffsContainerOffsetTop = (other.contentY + other.contentHeight) / other.surfaceScale;
        scr_guiContainerSizeMaxUpdate(_buffsContainer, other.contentWidth / other.surfaceScale);
        scr_guiContainerLayoutUpdate(_buffsContainer);
        scr_guiLayoutOffsetUpdate(_buffsContainer, _buffsContainerOffsetLeft, _buffsContainerOffsetTop);
        other.buffsHeight = _buffsContainer.guiHeight * other.surfaceScale;
        other.contentHeight += other.buffsHeight;
    }
    
    var _skillsContainer = other.skillsContainer;
    var _skillWidth = other.skillWidth;
    var _skillHeight = other.skillHeight;
    var _skillOffsetLeft = floor(_skillWidth / 2);
    var _skillOffsetTop = floor(_skillHeight / 2);
    var _key = "";
    var _skillsArraySize = array_length(skill_active_set);
    var _skillsCount = 0;
    
    for (var _i = 0; _i < _skillsArraySize; _i++)
    {
        _key = skill_active_set[_i];
        var _skillData = ds_map_find_value(map_skills, _key);
        var _skillAsset = __asset_get_index("o_skill_" + string_lower(_key) + "_ico");
        
        with (scr_guiCreateInteractive(_skillsContainer, _skillAsset, 0, _skillOffsetLeft, _skillOffsetTop))
        {
            depth = _skillsContainer.depth - 1;
            start_depth = depth;
            guiVisibility = true;
            scr_guiVisibleUpdate(id, true);
            scr_guiSizeUpdate(id, _skillWidth, _skillHeight);
            scr_guiInteractiveEventUpdate(id, 14);
            var _map = ds_map_find_value(map_skills, _key);
            _map = __dsDebuggerMapDestroy(_map);
            ds_map_delete(map_skills, _key);
            ds_map_add(map_skills, _key, _skillData);
            owner = other.id;
            is_enemy_skill = true;
            in_focus = true;
            is_open = true;
            is_lock = false;
            event_user(1);
        }
        
        _skillsCount++;
    }
    
    var _passSkillsListSize = ds_list_size(pass_skill);
    
    for (var _i = 0; _i < _passSkillsListSize; _i++)
    {
        var _passSkill = ds_list_find_value(pass_skill, _i);
        
        if (!_passSkill.is_open)
            continue;
        
        with (_passSkill)
        {
            depth = _skillsContainer.depth - 1;
            guiVisibility = true;
            scr_guiVisibleUpdate(id, true);
            scr_guiSizeUpdate(id, _skillWidth, _skillHeight);
            scr_guiLayoutOffsetUpdate(id, _skillOffsetLeft, _skillOffsetTop);
        }
        
        scr_guiContainerChildAdd(_skillsContainer, _passSkill);
        scr_guiInteractiveEventUpdate(_passSkill, 14);
        _skillsCount++;
    }
    
    if (_skillsCount)
        other.contentHeight += (_spaceHeight + _fontDmgHeight + _lineHeight);
    
    var _skillsContainerOffsetLeft = other.contentX / other.surfaceScale;
    var _skillsContainerOffsetTop = (other.contentY + other.contentHeight) / other.surfaceScale;
    scr_guiContainerSizeMaxUpdate(_skillsContainer, other.contentWidth / other.surfaceScale);
    scr_guiContainerLayoutUpdate(_skillsContainer);
    scr_guiLayoutOffsetUpdate(_skillsContainer, _skillsContainerOffsetLeft, _skillsContainerOffsetTop);
    other.skillsHeight = _skillsContainer.guiHeight * other.surfaceScale;
    other.contentHeight += other.skillsHeight;
    
    other.resistsHeight = 0;
    
    if (_showFullStats)
    {
        var _allStats = [
            "Slashing_Damage", "Piercing_Damage", "Blunt_Damage", "Rending_Damage",
            "Fire_Damage", "Frost_Damage", "Shock_Damage", "Poison_Damage", "Caustic_Damage",
            "Arcane_Damage", "Psionic_Damage", "Sacred_Damage", "Unholy_Damage",
            "Physical_Resistance", "Nature_Resistance", "Magic_Resistance",
            "Slashing_Resistance", "Piercing_Resistance", "Blunt_Resistance", "Rending_Resistance",
            "Fire_Resistance", "Frost_Resistance", "Shock_Resistance", "Poison_Resistance", "Caustic_Resistance",
            "Arcane_Resistance", "Psionic_Resistance", "Sacred_Resistance", "Unholy_Resistance",
            "Bleeding_Resistance", "Knockback_Resistance", "Stun_Resistance", "Pain_Resistance",
            "EVS", "Hit_Chance", "CRT", "CRTD", "CTA", "FMB",
            "Armor_Piercing", "Bodypart_Damage", "Damage_Received", "Cooldown_Reduction",
            "Weapon_Damage", "Magic_Power", "Block_Power", "Block_Recovery",
            "Miracle_Chance", "Miracle_Power", "Miscast_Chance",
            "Bleeding_Chance", "Daze_Chance", "Stun_Chance", "Knockback_Chance", "Immob_Chance", "Stagger_Chance",
            "Lifesteal", "Manasteal", "Fortitude", "Health_Restoration", "MP_Restoration", "Healing_Received", "Crit_Avoid"
        ];
        
        var _statsCount = array_length_1d(_allStats);
        for (var _j = 0; _j < _statsCount; _j++)
        {
            var _varName = _allStats[_j];
            if (variable_instance_exists(id, _varName))
            {
                var _val = variable_instance_get(id, _varName);
                if (is_real(_val) && _val != 0)
                    other.resistsHeight += _fontDmgHeight;
            }
        }
    }
    else
    {
        var _resistsListSize = ds_list_size(resistance_list);
        
        for (var _i = 0; _i < _resistsListSize; _i++)
        {
            var _variable = ds_list_find_value(resistance_list, _i);
            var _variableRaw = _variable + "_RAW";
            var _variableValue = variable_instance_get(id, _variable);
            
            if (variable_instance_exists(id, _variableRaw))
                _variableValue = variable_instance_get(id, _variableRaw);
            
            if (_variableValue != 0)
                other.resistsHeight += _fontDmgHeight;
        }
    }
    
    if (other.resistsHeight)
        other.contentHeight += (_spaceHeight + _fontDmgHeight + _lineHeight);
    
    other.contentHeight += other.resistsHeight;
    other.contentHeight += _lineHeight;
    desc = scr_stringInsertLineBreaks(desc, other.contentWidth, global.f_dmg, other.textScale);
    other.descriptionHeight = scr_stringGetHeightExt(desc, other.contentWidth, global.f_dmg, other.textScale);
    other.contentHeight += other.descriptionHeight;
}
