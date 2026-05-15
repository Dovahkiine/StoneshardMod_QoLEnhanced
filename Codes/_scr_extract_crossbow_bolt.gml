// 从指定手槽取出弩箭数据，并清空弩箭槽属性
// 参数: _slot_obj → o_inv_left_hand 或 o_inv_right_hand（对象类型）
// 返回: [missleSprite, usedObject, lootObject] 或 noone（弩未装填）
function _scr_extract_crossbow_bolt(argument0)
{
    var _result = noone;
    var _missleDataRef = global.missleData; // 在 with 块外捕获 global 引用

    with (argument0)
    {
        with (children)
        {
            if (equipped && haveAmmunitionSlot && isCrossbow)
            {
                var _bolt_name = scr_inv_atr("bolt");
                var _bolt_data = ds_map_find_value(_missleDataRef, _bolt_name);

                if (is_array(_bolt_data))
                {
                    _result = [_bolt_data[0], _bolt_data[1], _bolt_data[4]];
                    scr_inv_atr_set("bolt", "");
                }
                break;
            }
        }
    }

    return _result;
}
