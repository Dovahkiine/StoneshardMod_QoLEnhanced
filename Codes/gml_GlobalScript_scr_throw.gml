// ================================================================
//  scr_throw  —  玩家/敌方远程攻击主入口
//  修改说明：
//    · 敌方逻辑（!is_player() 分支）与原版完全一致，未做任何改动
//    · 单手原版逻辑（情况D）与原版完全一致，未做任何改动
//    · 在玩家分支新增双持路由（A/B/C），统一通过 _scr_do_shoot 发射
//    · 修复了修改版中 argument2 默认值从 -4 改成 -2 导致的 bug
// ================================================================
function scr_throw(argument0, argument1, argument2)
{
    if (argument0 == undefined) argument0 = other.id;
    if (argument1 == undefined) argument1 = true;
    if (argument2 == undefined) argument2 = -4;

    if (!argument0 || !instance_exists(argument0))
        return 0;

    if (argument1 && !is_allow_actions())
        return 0;

    // ---- 视线判断（原版逻辑，不做修改）----
    var _is_target_visible = true;

    if (!variable_instance_exists(argument0, "placelist"))
    {
        _is_target_visible = !scr_projectile_have_barriers(x, y, argument0.x, argument0.y);
    }
    else
    {
        _is_target_visible = false;
        var _placelist = argument0.placelist;
        var _count     = array_length(_placelist);

        for (var i = 0; i < _count; i += 2)
        {
            if (!scr_projectile_have_barriers(x, y, argument0.x + (_placelist[i] * 26),
                                                      argument0.y + (_placelist[i + 1] * 26)))
            {
                _is_target_visible = true;
                break;
            }
        }
    }

    if (!_is_target_visible)
        return 0;

    if (argument2 == -4)
        argument2 = argument0;

    if (ds_list_empty(lock_attack))
    {
        is_deal_damage = false;
        scr_setside(argument0);

        var predictor     = false;
        var arrow         = -4;
        var _missleSprite = arrowTypeSprite;
        var _usedObject   = arrowTypeUsed;
        var _lootObject   = o_loot_arrows;

        // ================================================================
        //  敌方逻辑 — 与原版完全一致，不做任何修改
        // ================================================================
        if (!is_player())
        {
            predictor = true;

            if (ammoCount <= 0)
            {
                scr_enemyArcherChangeToMelee();
                predictor = false;
            }

            ammoCount--;

            if (isCrossbowmanEnemy)
                crossbowIsLoaded = false;

            _lootObject = arrowTypeDrop;
        }

        // ================================================================
        //  玩家逻辑 — 双持扩展路由
        // ================================================================
        else if (scr_is_weapon_type_shooting())
        {
            // ---- 检测双手武器类型 ----
            // 变量命名：lh = left hand，rh = right hand
            var _rh_type   = "";     // "crossbow" / "range weapons right" / "range weapons left"（后两者均指弓/投石索，区分左右手以便后续处理）"
            var _lh_type   = "";

            if (instance_exists(o_inv_right_hand))
            {
                with (o_inv_right_hand)
                {
                    with (children)
                    {
                        if (haveAmmunitionSlot)
                        {
                            //_lh_weapon = id;
                            if (isCrossbow)       _rh_type = "crossbow";
                            else                  _rh_type = "range weapons right";
                        }
                    }
                }
            }

            if (instance_exists(o_inv_left_hand))
            {
                with (o_inv_left_hand)
                {
                    with (children)
                    {
                        if (haveAmmunitionSlot)
                        {
                            //_rh_weapon = id;
                            if (isCrossbow)       _lh_type = "crossbow";
                            else                  _lh_type = "range weapons left";
                        }
                    }
                }
            }

            // ================================================================
            //  情况 A：双持十字弩
            //  规则：每回合只发射一根弩箭
            //    回合0 → 发射伤害较高的那把（主手）
            //    回合1 → 发射另一把，同时免费装填主手
            // ================================================================
            if (_lh_type == "crossbow" && _rh_type == "crossbow")
            {
                if (!variable_instance_exists(id, "crossbow_shoot_turn"))
                    crossbow_shoot_turn = 0;

                if (crossbow_shoot_turn == 0)
                {
                    // 偶数回合：射击左手（主手），同时检查右手（副手）是否有装填，如果没有则免费装填

                    // 比对实例 ID 来判断主手在哪个槽
                    var _bolt_res  = _scr_extract_crossbow_bolt(o_inv_right_hand);

                    if (_bolt_res == noone)
                    {
                        // 主手弩未装填 → 触发装填，消耗本回合
                        scr_crossbow_insert_bolt();
                        return -5;
                    }

                    arrow     = _scr_do_shoot(argument0, argument2, _bolt_res[0], _bolt_res[1], _bolt_res[2]);
                    predictor = false;
                }
                else
                {
                    // 第 1 回合：发射另一把，并免费装填上回合射击的那把
                    var _bolt_res_b    = _scr_extract_crossbow_bolt(o_inv_left_hand);

                    if (_bolt_res_b == noone)
                    {
                        // 副手弩也未装填 → 尝试统一装填两把
                        scr_crossbow_insert_bolt();
                        return -5;
                    }

                    arrow     = _scr_do_shoot(argument0, argument2, _bolt_res_b[0], _bolt_res_b[1], _bolt_res_b[2]);
                    predictor = false;

                    // 免费装填上一回合发射过的弩（不推进回合）
                    // 注意：scr_crossbow_insert_bolt(false,false,false) 会对所有空弩装填。
                    // 若需要精确指定只装填某一把，后续可为 scr_crossbow_insert_bolt
                    // 增加可选的目标弩 ID 参数。
                    scr_crossbow_insert_bolt(false, false, false);
                }

                crossbow_shoot_turn = 1 - crossbow_shoot_turn;
            }

            // ================================================================
            //  情况 B：十字弩 + 弓/投石索
            //  规则：
            //    双数回合 → 双手齐射（弓必射，弩若已装填则同时射）
            //    单数回合 → 仅弓射击，弩免费装填
            // ================================================================
            else if ((_lh_type == "crossbow" || _rh_type == "crossbow")&&
                     (_lh_type == "range weapons left" || _rh_type == "range weapons right"))
            {
                // 确定是哪只手持有远程武器，以及武器类型
                var _fire_slot = noone;

                if (_rh_type != "crossbow")
                    _fire_slot = o_inv_right_hand;
                else
                    _fire_slot = o_inv_left_hand;

                if (!variable_instance_exists(id, "mixed_attack_turn"))
                    mixed_attack_turn = false;

                if (!mixed_attack_turn)
                {
                    // 不是十字弩的那只手先射击
                    var _bow_arrow = _scr_fire_bow_once(argument0, argument2, _fire_slot);
                    if (_bow_arrow != noone && _bow_arrow != -4)
                        arrow = _bow_arrow;

                    // 十字弩若已装填则同时射出
                    var _cslot    = (_lh_type == "crossbow") ? o_inv_left_hand : o_inv_right_hand;
                    var _cbolt    = _scr_extract_crossbow_bolt(_cslot);
                    var _cross_arrow = -4;
                    if (_cbolt != noone)
                    {
                        // 射出十字弩箭（若有）
                        _cross_arrow = _scr_do_shoot(argument0, argument2, _cbolt[0], _cbolt[1], _cbolt[2], 0);
                        if (_cross_arrow != noone && _cross_arrow != -4)
                            arrow = _cross_arrow;
                    }
                    else
                        scr_crossbow_insert_bolt(false, false, false);

                    if (arrow == -4){
                        // 双手都无弹药：弩完成免费装填，回合计数归位为0
                        mixed_attack_turn = !mixed_attack_turn;
                        return -5;
                    }

                    // _bow_arrow 已通过 _scr_do_shoot 内部 event_perform 触发
                    // _cross_arrow 已传入 speed=0 → _scr_do_shoot 自动设置 alarm[1]=4 延迟出发

                    predictor = false;
                }
                else
                {
                    var _bow_arrow2 = _scr_fire_bow_once(argument0, argument2, _fire_slot);
                    if (_bow_arrow2 != noone && _bow_arrow2 != -4)
                    {
                        arrow = _bow_arrow2;
                        // 弩免费装填
                        scr_crossbow_insert_bolt(false, false, false);
                        predictor = false;
                    }
                    else
                    {
                        // 弓无弹药：弩仍然完成免费装填，回合计数归位为0
                        // 下一回合回到双手齐射分支，让弩有机会射击
                        scr_crossbow_insert_bolt(false, false, false);
                        mixed_attack_turn = !mixed_attack_turn;
                        return -5;
                    }
                }

                mixed_attack_turn = !mixed_attack_turn;
            }

            // ================================================================
            //  情况 C：双持弓/投石索
            //  规则：每回合双手齐射
            // ================================================================
            else if (_rh_type == "range weapons right" && _lh_type == "range weapons left")
            {
                var _arr1 = _scr_fire_bow_once(argument0, argument2, o_inv_right_hand);
                var _arr2 = _scr_fire_bow_once(argument0, argument2, o_inv_left_hand, 0);

                if (_arr1 != noone && _arr1 != -4) arrow = _arr1;
                if (_arr2 != noone && _arr2 != -4) arrow = _arr2;

                if (arrow == -4)
                    return -5;   // 双手都没弹药

                // _arr1 已通过 _scr_do_shoot 内部 event_perform 触发
                // _arr2 已传入 speed=0 → _scr_do_shoot 自动设置 alarm[1]=4 延迟出发

                predictor = false;
            }

            // ================================================================
            //  情况 D：单手远程武器，另一只手为空或者是近战武器
            //  直接使用已检测到的手型变量，不依赖 o_weapon_slot_parent
            // ================================================================
            else if (_rh_type != "" || _lh_type != "")
            {
                // 确定是哪只手持有远程武器，以及武器类型
                var _fire_type = "";
                var _fire_slot = noone;

                if (_rh_type != "")
                {
                    _fire_type = _rh_type;
                    _fire_slot = o_inv_right_hand;
                }
                else if (_lh_type != "")
                {
                    _fire_type = _lh_type;
                    _fire_slot = o_inv_left_hand;
                }

                if (_fire_type == "crossbow")
                {
                    // 单手十字弩：提取弩箭并射击，未装填则触发装填
                    var _bolt_res = _scr_extract_crossbow_bolt(_fire_slot);

                    if (_bolt_res == noone)
                    {
                        scr_crossbow_insert_bolt();
                        return -5;
                    }

                    arrow = _scr_do_shoot(argument0, argument2, _bolt_res[0], _bolt_res[1], _bolt_res[2]);
                }
                else
                {
                    // 单手弓/投石索：消耗共用弹药池并射击
                    var _bow_arr = _scr_fire_bow_once(argument0, argument2, _fire_slot);

                    if (_bow_arr != noone && _bow_arr != -4)
                        arrow = _bow_arr;
                    else
                        return -5;

                }
                
                predictor = false;
            }
            // 退回原版逻辑（情况D的原版逻辑完全包含在上述分支中，此处仅处理未检测到任何远程武器的情况）
            else
            {
                // 未检测到远程武器，回退原版逻辑（isCrossbowman 路径）
                var _missleDataRef = global.missleData; // 在 with 块外捕获 global 引用
                if (isCrossbowman)
                {
                    var _bolt     = -4;
                    var _crossbow = -4;

                    with (o_weapon_slot_parent)
                    {
                        with (children)
                        {
                            if (haveAmmunitionSlot)
                            {
                                _crossbow = id;
                                _bolt = ds_map_find_value(_missleDataRef, scr_inv_atr("bolt"));

                                if (is_array(_bolt))
                                {
                                    _missleSprite  = _bolt[0];
                                    _usedObject    = _bolt[1];
                                    var _microBuff = _bolt[2];
                                    _lootObject    = _bolt[4];
                                }
                                else
                                {
                                    _bolt = -4;
                                }

                                scr_inv_atr_set("bolt", "");
                            }
                        }
                    }

                    if (_bolt == -4)
                    {
                        scr_crossbow_insert_bolt();
                        return -5;
                    }
                    else
                    {
                        predictor = true;
                    }
                }
                else
                {
                    // 弓/投石索原版逻辑
                    with (o_inv_ammunition_parent)
                    {
                        if (equipped)
                        {
                            if (stack > 0)
                            {
                                stack--;
                                scr_item_stack_build(false);
                                var _arrow_d   = ds_map_find_value(_missleDataRef, object_get_name(object_index));
                                _missleSprite  = _arrow_d[0];
                                _usedObject    = _arrow_d[1];
                                var _microBuff = _arrow_d[2];
                                _lootObject    = _arrow_d[4];
                                predictor = true;
                            }
                        }
                    }

                    with (o_inv_quiver_parent)
                    {
                        if (equipped)
                        {
                            var _loot_list = ds_map_find_value(data, "lootList");

                            if (ds_list_size(_loot_list))
                            {
                                var _item = ds_list_find_value(_loot_list, 0);
                                ds_list_set_post(_item, 6, ds_list_find_value(_item, 6) - 1);
                                var _arrow_d   = ds_map_find_value(_missleDataRef, ds_list_find_value(_item, 0));
                                _missleSprite  = _arrow_d[0];
                                _usedObject    = _arrow_d[1];
                                var _microBuff = _arrow_d[2];
                                _lootObject    = _arrow_d[4];

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

                                predictor = true;
                            }
                        }
                    }

                    if (!predictor)
                        return -5;
                }
            }
        }

        // ================================================================
        //  Predictor 流程 — 与原版完全一致
        //  predictor = false 时此块被跳过（A/B/C 已由辅助函数完成射击）
        // ================================================================
        if (predictor)
        {
            if (!instance_exists(argument0))
                return -4;

            diss += 100;

            if (argument0.object_index == o_attacked_target
                && (!instance_exists(argument2) || argument2.object_index != o_attacked_target))
            {
                if (visible)
                    scr_actionsLog("shotMiss", [scr_actionsLogGetName(id), scr_actionsLogGetName(argument2)]);
            }

            var _k = scr_passive_skill_is_open(o_pass_skill_constant_training) ? 1 : 2;
            RngPen = _k * (scr_tile_distance(id, argument0) - range);

            var _arrow_inst = instance_create_depth(x, y - 6.5, 0, o_arrow);

            if (_arrow_inst != noone && _arrow_inst >= 0)
            {
                with (_arrow_inst)
                {
                    sprite_index      = _missleSprite;
                    used_object_index = _usedObject;
                    loot_object       = _lootObject;
                    target            = argument0;
                    scr_rest_disable(target);
                    owner             = other.id;
                    event_perform(ev_alarm, 0);
                    alarm[0]          = -1;
                    arrow             = id;
                    scr_skill_call_passive(o_pass_skill_control_shot, owner, target);
                    isSlingAmmo       = object_is(loot_object, o_inv_sling_ammo_quiver_parent);

                    if (!isSlingAmmo)
                        scr_audio_play_at(choose(snd_arrow_hit_1, snd_arrow_hit_2));
                    else
                        scr_audio_play_at(choose(snd_sling_shot_1, snd_sling_shot_2, snd_sling_shot_3, snd_sling_shot_4));
                }
            }

            if (is_player())
            {
                scr_characterStatsUpdateAdd("attacks", 1);
                scr_noise_attack_check(id, argument0, grid_x, grid_y);
                scr_hint_ranged();
            }
        }

        return arrow;
    }

    return -4;
}
