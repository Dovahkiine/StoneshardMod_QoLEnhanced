function scr_hoversGetEnchantedAttributes()
{
    var _array = [];
    
    for (var _i = 0; _i < 17; _i++)
    {
        var _enchant = ds_map_find_value(data, "Char" + string(_i));
        
        if (__is_undefined(_enchant))
            break;
        
        var _enchantPartsArray = string_split_custom(_enchant);
        array_push(_array, _enchantPartsArray[0], string_to_real(_enchantPartsArray[1]));
    }
    
    return _array;
}
