event_inherited();
var _lineHeight = lineHeight;
var _spaceHeight = spaceHeight;
var _fontDmgHeight = fontDmgHeight;
var _contentX = contentX;
var _contentY = contentY;
var _contentWidth = contentWidth;
var _offsetY = 0;
var _showFullStats = keyboard_check(vk_alt);

with (unit)
{
    var _stateColor = make_color_rgb(190, 190, 190);
    
    if (state == "alarm")
        _stateColor = make_color_rgb(246, 187, 21);
    else if (state == "attack")
        _stateColor = make_color_rgb(236, 77, 73);
    else if (state == "npc combat")
        _stateColor = make_color_rgb(236, 77, 73);
    else if (state == "threat")
        _stateColor = make_color_rgb(242, 141, 49);
    
    var _dangerLevel = ds_list_find_value(global.enemy_level, 1);
    
    if (Tier == 1)
        _dangerLevel = ds_list_find_value(global.enemy_level, 2);
    else if (Tier == 2)
        _dangerLevel = ds_list_find_value(global.enemy_level, 3);
    else if (Tier == 3)
        _dangerLevel = ds_list_find_value(global.enemy_level, 4);
    else if (Tier == 4)
        _dangerLevel = ds_list_find_value(global.enemy_level, 5);
    else if (Tier == 5)
        _dangerLevel = ds_list_find_value(global.enemy_level, 6);
    
    scr_drawTextExt(_contentX + (_contentWidth / 2), _contentY + _offsetY, name, 16777215, _contentWidth, 1, 0, global.f_digits, other.textScale);
    _offsetY += other.titleHeight;
    
    if (other.typeHeight > 0)
    {
        scr_drawText(_contentX + (_contentWidth / 2), _contentY + _offsetY, type, make_colour_rgb(149, 121, 106), 1, 0, global.f_dmg, other.textScale);
        _offsetY += other.typeHeight;
    }
    
    scr_drawText(_contentX, _contentY + _offsetY, _dangerLevel, 16777215, 0, 0, global.f_dmg, 1);
    scr_drawText(_contentX + _contentWidth, _contentY + _offsetY, scr_enemy_suspicious_text_get(), _stateColor, 2, 0, global.f_dmg, other.textScale);
    _offsetY += other.statusHeight;
    scr_hoversDrawLine(_contentX, _contentY + _offsetY, _contentWidth, _lineHeight, 2);
    _offsetY += _lineHeight;
    
    if (other.mainParamsHeight)
    {
        scr_drawText(_contentX, _contentY + _offsetY, ds_map_find_value(global.attribute, "HP"), 16777215, 0, 0, global.f_dmg, other.textScale);
        
        if (_showFullStats)
            scr_drawText(_contentX + _contentWidth, _contentY + _offsetY, string(HP) + "/" + string(max_hp), 16777215, 2, 0, global.f_dmg, other.textScale);
        else
            scr_drawText(_contentX + _contentWidth, _contentY + _offsetY, string(ceil((HP / max_hp) * 100)) + "%", 16777215, 2, 0, global.f_dmg, other.textScale);
        
        _offsetY += _fontDmgHeight;
        scr_drawText(_contentX, _contentY + _offsetY, ds_map_find_value(global.attribute, "MP"), 16777215, 0, 0, global.f_dmg, other.textScale);
        
        if (_showFullStats)
            scr_drawText(_contentX + _contentWidth, _contentY + _offsetY, string(MP) + "/" + string(max_mp), 16777215, 2, 0, global.f_dmg, other.textScale);
        else
            scr_drawText(_contentX + _contentWidth, _contentY + _offsetY, string((max_mp == 0) ? 0 : ceil((MP / max_mp) * 100)) + "%", 16777215, 2, 0, global.f_dmg, other.textScale);
        
        _offsetY += _fontDmgHeight;
    }
    
    if (other.armorDurabilityHeight)
    {
        scr_drawText(_contentX, _contentY + _offsetY, ds_map_find_value(global.attribute, "Armor_Durability"), 16777215, 0, 0, global.f_dmg, other.textScale);
        scr_drawText(_contentX + _contentWidth, _contentY + _offsetY, string(ceil(ArmorDurability)) + "%", 16777215, 2, 0, global.f_dmg, other.textScale);
        _offsetY += other.armorDurabilityHeight;
    }
    
    if (other.moraleHeight)
    {
        scr_drawText(_contentX, _contentY + _offsetY, ds_map_find_value(global.attribute, "Enemy_Morale"), 16777215, 0, 0, global.f_dmg, other.textScale);
        scr_drawText(_contentX + _contentWidth, _contentY + _offsetY, string(morale_value) + "%", 16777215, 2, 0, global.f_dmg, other.textScale);
        _offsetY += other.moraleHeight;
    }
    
    if (other.buffsHeight)
    {
        _offsetY += _spaceHeight;
        scr_drawText(_contentX + (_contentWidth / 2), _contentY + _offsetY, ds_list_find_value(global.other_hover, 38), 16777215, 1, 0, global.f_dmg, other.textScale);
        _offsetY += _fontDmgHeight;
        scr_hoversDrawLine(_contentX, _contentY + _offsetY, _contentWidth, _lineHeight, other.surfaceScale);
        _offsetY += _lineHeight;
        _offsetY += other.buffsHeight;
    }
    
    if (other.skillsHeight)
    {
        _offsetY += _spaceHeight;
        scr_drawText(_contentX + (_contentWidth / 2), _contentY + _offsetY, ds_list_find_value(global.other_hover, 39), 16777215, 1, 0, global.f_dmg, other.textScale);
        _offsetY += _fontDmgHeight;
        scr_hoversDrawLine(_contentX, _contentY + _offsetY, _contentWidth, _lineHeight, other.surfaceScale);
        _offsetY += _lineHeight;
        _offsetY += other.skillsHeight;
    }
    
    if (other.resistsHeight)
    {
        _offsetY += _spaceHeight;
        scr_drawText(_contentX + (_contentWidth / 2), _contentY + _offsetY, ds_list_find_value(global.other_hover, 40), 16777215, 1, 0, global.f_dmg, other.textScale);
        _offsetY += _fontDmgHeight;
        scr_hoversDrawLine(_contentX, _contentY + _offsetY, _contentWidth, _lineHeight, other.surfaceScale);
        _offsetY += _lineHeight;
        
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
            
            for (var _i = 0; _i < _statsCount; _i++)
            {
                var _varName = _allStats[_i];
                if (variable_instance_exists(id, _varName))
                {
                    var _val = variable_instance_get(id, _varName);
                    if (is_real(_val) && _val != 0)
                    {
                        var _displayName = ds_map_find_value(global.attribute, _varName);
                        if (is_undefined(_displayName))
                            _displayName = _varName;
                        
                        scr_drawText(_contentX, _contentY + _offsetY, _displayName, 16777215, 0, 0, global.f_dmg, other.textScale);
                        scr_drawText(_contentX + _contentWidth, _contentY + _offsetY, string(_val) + scr_atr_percent(_varName), 16777215, 2, 0, global.f_dmg, other.textScale);
                        _offsetY += _fontDmgHeight;
                    }
                }
            }
        }
        else
        {
            var _resistsListSize = ds_list_size(resistance_list);
            var _resistsIndex = 0;
            
            for (var _i = 0; _i < _resistsListSize; _i++)
            {
                var _variable = ds_list_find_value(resistance_list, _i);
                var _variableValue = variable_instance_get(id, _variable);
                var _variableRaw = _variable + "_RAW";
                
                if (variable_instance_exists(id, _variableRaw))
                    _variableValue = variable_instance_get(id, _variableRaw);
                
                if (_variableValue != 0)
                {
                    scr_drawText(_contentX, _contentY + _offsetY + (_resistsIndex * _fontDmgHeight), ds_map_find_value(global.attribute, _variable), 16777215, 0, 0, global.f_dmg, other.textScale);
                    scr_drawText(_contentX + _contentWidth, _contentY + _offsetY + (_resistsIndex * _fontDmgHeight), string(_variableValue) + scr_atr_percent(_variable), 16777215, 2, 0, global.f_dmg, other.textScale);
                    _resistsIndex++;
                }
            }
            
            _offsetY += other.resistsHeight;
        }
    }
    
    scr_hoversDrawLine(_contentX, _contentY + _offsetY, _contentWidth, _lineHeight, other.surfaceScale);
    _offsetY += _lineHeight;
    scr_drawTextExt(_contentX, _contentY + _offsetY, desc, make_colour_rgb(149, 121, 106), _contentWidth, 0, 0, global.f_dmg, other.textScale);
    _offsetY += other.descriptionHeight;
}
