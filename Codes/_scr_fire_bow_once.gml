// 弓/投石索单次射击，消耗共用弹药池
// 必须在玩家实例上下文中调用
// 返回: 箭矢实例 ID 或 noone（无弹药）
// argument3: 可选初始速度，穿透给 _scr_do_shoot（默认 -1 不覆盖，0=延迟出发）
//
// 过滤规则：凡对象名含 "bolt" 的物品均视为弩箭，跳过不消耗
function _scr_fire_bow_once(argument0, argument1, argument2, argument3)
{
    if (argument2 == undefined) argument2 = o_inv_right_hand; // 是否强制从箭袋取弹（不检查装备的弹药槽）
    var _missle_sprite = -1;
    var _used_obj      = -1;
    var _loot_obj      = o_loot_arrows;
    var _got_ammo      = false;
    var _ammunitionType = ""; // 默认使用箭矢弹药槽，后续可根据需要扩展为投石索弹药槽等
    var _missleDataRef = global.missleData; // 在 with 块外捕获 global 引用，避免嵌套 with 中访问 global 报错
    with (argument2)
    {
        with (children){
            _ammunitionType = ammunitionType;
            break;
        }
    }

    // ---- 来源1：装备弹药槽 ----
    with (o_inv_ammunition_parent)
    {
        // 匹配弹药类型且有足够的弹药（stack > 0）时才进行消耗，避免不必要的实例遍历和潜在的误消耗
        if (stack > 0 && slot == _ammunitionType) {
            // 背包来源：玩家背包（o_inventory 中散装的 o_inv_ammunition_parent）
            // 作为最后兜底，逐个物品实例遍历，每种弩箭类型独立处理
            // stack 归零时销毁该物品实例（与装备槽行为不同，背包格会被清除）
            // 只处理在主背包中、未被装备的弩箭 
            if (owner.object_index == o_inventory)
            {
                var _name = object_get_name(object_index);
                var _arrow = ds_map_find_value(_missleDataRef, _name);
                if (instance_exists(o_pass_skill_thrift) && o_pass_skill_thrift.is_open)
                {
                    if irandom(100) < 50 // 50%概率不消耗弹药
                        stack--;
                }
                else
                    stack--;
                scr_item_stack_build(false);
                _missle_sprite = _arrow[0];
                _used_obj      = _arrow[1];
                _loot_obj      = _arrow[4];
                _got_ammo      = true;

                if (stack <= 0)
                    instance_destroy();

                break;
            }
            else if (equipped)
            {
                var _name = object_get_name(object_index);
                var _arrow = ds_map_find_value(_missleDataRef, _name);
                if (instance_exists(o_pass_skill_thrift) && o_pass_skill_thrift.is_open)
                {
                    if irandom(100) < 50 // 50%概率不消耗弹药
                        stack--;
                }
                else
                    stack--;
                scr_item_stack_build(false);
                _missle_sprite = _arrow[0];
                _used_obj      = _arrow[1];
                _loot_obj      = _arrow[4];
                _got_ammo      = true;
                break;
            }
        }
        _used_obj++; // 只要进入弹药槽检查，就视为使用过一次弹药（即使最终未找到合适的箭矢），避免无限尝试
        if (_got_ammo || _used_obj > 100) break;
    }

    // ---- 来源2：装备的箭袋 ----
    if (!_got_ammo)
    {
        with (o_inv_quiver_parent)
        {
            // 排除弩箭
            if ((owner.object_index == o_inventory || equipped) && slot == _ammunitionType)
            {
                var _loot_list = ds_map_find_value(data, "lootList");

                if (ds_list_size(_loot_list))
                {
                    var _item      = ds_list_find_value(_loot_list, 0);
                    var _item_name = ds_list_find_value(_item, 0);
                    var _arrow = ds_map_find_value(_missleDataRef, _item_name);
                    if (is_array(_arrow))
                    {   
                        if (instance_exists(o_pass_skill_thrift) && o_pass_skill_thrift.is_open)
                            {
                                if irandom(100) < 50 // 50%概率不消耗弹药
                                    stack--;
                            }
                        else
                            ds_list_set_post(_item, 6, ds_list_find_value(_item, 6) - 1);
                        _missle_sprite = _arrow[0];
                        _used_obj      = _arrow[1];
                        _loot_obj      = _arrow[4];

                        if (ds_list_find_value(_item, 6) == 0)
                        {
                            ds_list_delete(_loot_list, 0);
                            _item = __dsDebuggerListDestroy(_item);

                            if (object_is(object_index, o_inv_sling_ammo_quiver_parent))
                                scr_sort_sling_quiver(_loot_list, cells_x_size * 2);
                            else
                                scr_sort_item_in_container(_loot_list);

                            script_execute(update_ammo_order);
                        }

                        _got_ammo = true;
                    }
                    break;
                }
            }
        }
    }

    if (!_got_ammo)
        return noone;

    return _scr_do_shoot(argument0, argument1, _missle_sprite, _used_obj, _loot_obj, argument3);
}
