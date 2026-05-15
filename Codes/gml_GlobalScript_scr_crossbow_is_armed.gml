// 检查十字弩装填状态
//
// 无参数调用（默认行为，供 o_skill_ico 等全局检查使用）：
//   同时检查左右手，任意一把已装填即返回 1
//   返回:  1 = 至少一把弩已装填
//          0 = 有弩但全部未装填
//         -4 = 双手均无十字弩
//
// 传入指定手槽（o_inv_left_hand 或 o_inv_right_hand）：
//   只检查该手槽
//   返回:  1 = 已装填 / 0 = 未装填 / -4 = 无弩
function scr_crossbow_is_armed(argument0)
{
    // ---- 无参数：检查双手 ----
    if (argument0 == undefined)
        argument0 = o_weapon_slot_parent; // 默认检查双手（o_weapon_slot_parent 的子对象）

    var _is_crossbow = false; // 默认无弩
    
    with (argument0)
    {
        with (children)
        {
             if (equipped && haveAmmunitionSlot && isCrossbow)
            {
                _is_crossbow = true;

                var _bolt = scr_inv_atr("bolt");
                if (_bolt != "" && !__is_undefined(_bolt))
                    return 1;
            }
        }
    }

    if (_is_crossbow)
        return 0; // 有弩但未装填

    return -4;

}
