function _scr_qol_runic_boulder_try_merge(argument0)
{
    // QoLEnhanced - 符文巨石合并第一阶段。
    // argument0 是刚完成召唤初始化的巨石。只从新巨石触发检测，可以避免每个巨石每步重复扫描导致连锁多次触发。
    if (!instance_exists(argument0))
        return false;
    
    var _seed = argument0;
    var _owner = _seed.owner;
    
    if (!instance_exists(_owner))
        return false;
    
    // 新召唤巨石进入 Alarm_1 时，落石/生成动画还可能没有播完。
    // 如果此时立刻移动，视觉上会出现“石头尚未完整生成就被牵走”的违和感。
    // 这里把合并请求挂起到 Step：等 s_boulder_spawn 动画停止后再重新调用本 helper。
    // 只延迟视觉/合并触发时机，不改变召唤落点吸引和真实伤害的结算。
    if (_seed.sprite_index == s_boulder_spawn && _seed.image_speed != 0)
    {
        _seed.__qol_merge_pending = true;
        return false;
    }
    
    _seed.__qol_merge_pending = false;
    
    var _group = [_seed];
    var _group_size = 1;
    var _odd_pair = false;
    
    // 找出同 owner 且 7 格内的巨石。这里只负责收集参与者，合并点在下面统一用“向量和/加权质心”计算。
    // 这样已经融合过的巨石可以用自身携带的 __qol_merged_count 作为质量，数量越多的一侧会自然拉动终点。
    with (o_runic_boulder)
    {
        if (id != _seed && owner == _owner)
        {
            // 原版 scr_tile_distance 已经是切比雪夫距离：
            // max(abs(grid_x差), abs(grid_y差))。这正好对应“允许斜向移动时，两点横纵差取较大值”的需求，
            // 因此这里直接复用原版函数，避免维护一个只包一层同样公式的 QoLEnhanced helper。
            var _dist = scr_tile_distance(id, _seed);
            
            if (_dist <= 7)
            {
                _group[_group_size] = id;
                _group_size++;
                
                // 两石格距为奇数时，最终伤害增加 25%。多石场景中只要存在奇数对，就启用这个第一阶段倍率。
                if ((_dist mod 2) == 1)
                    _odd_pair = true;
            }
        }
    }
    
    if (_group_size < 2)
        return false;
    
    // 本次融合后的“基础符文巨石数量”。
    // 每个参与者可能已经是融合体，所以不能简单使用 _group_size；必须把每个实例携带的融合数量累加。
    var _merged_total = 0;
    var _weighted_sum_x = 0;
    var _weighted_sum_y = 0;
    var _weight_total = 0;
    
    for (var m = 0; m < _group_size; m++)
    {
        var _merge_count_boulder = _group[m];
        
        if (instance_exists(_merge_count_boulder))
        {
            // “万有引力”的第一阶段实现采用位置向量加权求和：
            // - 每个符文巨石实例提供自身当前位置向量 (x, y)；
            // - 已融合的巨石用 _scr_qol_runic_boulder_get_merged_count 作为质量/权重；
            // - 最终合并点 = sum(位置向量 * 质量) / sum(质量)。
            // 这样两块已经融合在一起的旧巨石旁边再召唤一块新巨石时，终点会落在靠近旧融合体的约 1/3 处，
            // 符合“复数巨石按万有引力计算最终合并点”的设计目标，同时给后续更复杂的力学动画保留清晰接口。
            var _weight = max(1, _scr_qol_runic_boulder_get_merged_count(_merge_count_boulder));
            _merged_total += _weight;
            _weighted_sum_x += _merge_count_boulder.x * _weight;
            _weighted_sum_y += _merge_count_boulder.y * _weight;
            _weight_total += _weight;
        }
    }
    
    _merged_total = max(1, _merged_total);
    _weight_total = max(1, _weight_total);
    
    var _center_x = round(_weighted_sum_x / _weight_total);
    var _center_y = round(_weighted_sum_y / _weight_total);
    _center_x = (_center_x div 13) * 13;
    _center_y = (_center_y div 13) * 13;
    
    // 奇数格时按需求给上/左巨石“后退 0.5 格”、下/右巨石“前进 0.5 格”的表达空间。
    // 第一阶段不做复杂逐帧动画，只把半格偏移折算到合并点，保证位置和伤害倍率可验证。
    var _odd_multiplier = _odd_pair ? 1.25 : 1;
    var _offset_hint = _odd_pair ? 13 : 0;
    
    var _max_damage = _scr_qol_runic_boulder_merge_damage(_group, _center_x, _center_y, _odd_multiplier, _offset_hint);
    var _self_damage = _max_damage * 0.25;
    var _survivor = _seed;
    
    // 融合体缩放接口：
    // 1 块 = 1.00；2 块 = 1.05；3 块 = 1.10；...；6 块或更多 = 1.25。
    // 这里只改 image_xscale/image_yscale，不改碰撞格尺寸，避免 1x1 巨石突然变成多格实体导致路径/选点系统大范围连锁变更。
    var _merged_scale = 1 + (min(max(_merged_total - 1, 0), 5) * 0.05);
    
    // 同一批参与合并的巨石必须共用一个动画结束帧。
    // 之前每块巨石按“自己到终点的距离”单独计算 duration：质量更大的旧融合体往往离加权终点更近，
    // 于是它先到终点并被静默销毁，画面上就表现为“最大的那块突然消失，其它巨石继续滑行”。
    // 这里先找出本批参与者到终点的最大视觉移动距离，再用这个最大距离换算整批共用时长；
    // 距离短的巨石会移动得更慢，但所有视觉壳会同时抵达、同时完成融合。
    var _max_anim_tiles = 0;
    
    for (var d = 0; d < _group_size; d++)
    {
        var _duration_boulder = _group[d];
        
        if (instance_exists(_duration_boulder))
            _max_anim_tiles = max(_max_anim_tiles, point_distance(_duration_boulder.x, _duration_boulder.y, _center_x, _center_y) / 26);
    }
    
    // 距离越远动画越长。按秒数目标换算帧数：
    // - 最近距离合并，也就是相邻巨石各自约移动半格，目标约 0.6 秒；
    // - 7 格极限合并时，单个巨石大约移动 3.5 格，目标约 1.1 秒；
    // - 中间距离线性插值。实体占位和伤害仍然立即结算，这个时长只影响 Draw/Step 的视觉插值。
    // 使用 room_speed 而不是硬写 60，可以在游戏帧率配置变化时仍保持接近的秒数表现。
    var _duration_min = ceil(max(1, room_speed) * 0.6);
    var _duration_max = ceil(max(1, room_speed) * 1.1);
    var _duration_t = min(1, max(0, (_max_anim_tiles - 0.5) / 3));
    var _merge_anim_duration = round(_duration_min + ((_duration_max - _duration_min) * _duration_t));
    
    for (var i = 0; i < _group_size; i++)
    {
        var _boulder = _group[i];
        
        if (!instance_exists(_boulder))
            continue;
        
        with (_boulder)
        {
            var _is_survivor = id == _survivor;
            
            // 反作用伤害只需要落到最终融合体上。
            // 其它参与者会作为视觉壳静默吸收，若也扣血可能在动画结束前触发 HP<=0 的原版摧毁流程，产生不该出现的碎裂动画。
            if (_is_survivor && _self_damage > 0)
                scr_simple_damage(id, _self_damage);
            
            // 巨石不是普通单位，不能直接套用 scr_change_coordinat；这里手动维护实体占位。
            // 只有当前格确实登记为本巨石时才清理 posgrid，避免误清其它单位或地形占位。
            // 同时必须清理 newgrid：技能选点/路径阻挡会读取碰撞网格，若合并时只移动实例坐标，
            // 旧召唤点会继续被判定为被占用，表现为画面上没有巨石但该格不能再次召唤；切场景后网格重建才会恢复。
            var _old_grid_x = x div 26;
            var _old_grid_y = y div 26;
            var _new_grid_x = _center_x div 26;
            var _new_grid_y = _center_y div 26;
            var _anim_start_x = x;
            var _anim_start_y = y;
            var _anim_dx = _center_x - _anim_start_x;
            var _anim_dy = _center_y - _anim_start_y;
            
            if (ds_grid_get(o_controller.posgrid, _old_grid_x, _old_grid_y) == id)
                ds_grid_set(o_controller.posgrid, _old_grid_x, _old_grid_y, -4);
            
            scr_collision_clear(o_controller.newgrid, _old_grid_x, _old_grid_y);
            
            x = _center_x;
            y = _center_y;
            xx = _center_x;
            yy = _center_y;
            draw_x = _center_x;
            draw_y = _center_y;
            grid_x = _new_grid_x;
            grid_y = _new_grid_y;
            
            // survivor 是唯一保留的真实符文巨石实例，只有它重新写入实体占位。
            // 被吸收的旧巨石不再参与 posgrid/newgrid，避免合并后仍被算作多块巨石或继续阻挡召唤点。
            if (_is_survivor && !in_focus)
            {
                ds_grid_set(o_controller.posgrid, _new_grid_x, _new_grid_y, id);
                scr_collision_add_enemy(o_controller.newgrid, _new_grid_x, _new_grid_y);
            }
            
            // QoLEnhanced - 合并移动的视觉动画。
            // 实体坐标和碰撞网格已经立即切到合并点，避免旧格继续阻挡召唤/寻路；下面这些变量只给 Draw/Step 使用，
            // 让画面上仍能看到巨石从旧召唤点冲向合并点。这样动画不会延迟伤害、挤开、占位等战斗结算。
            __qol_merge_anim_active = true;
            __qol_merge_anim_start_x = _anim_start_x;
            __qol_merge_anim_start_y = _anim_start_y;
            __qol_merge_anim_end_x = _center_x;
            __qol_merge_anim_end_y = _center_y;
            __qol_merge_anim_frame = 0;
            __qol_merge_anim_duration = _merge_anim_duration;
            __qol_merge_anim_dir = point_direction(_anim_start_x, _anim_start_y, _center_x, _center_y);
            
            // 倾斜角按移动方向的水平分量给出，最大约 20 度。
            // 视觉意图是让巨石“上部滞后、底部更靠近终点”，产生被牵引加速的感觉；只在 Draw 中使用，不写回长期 image_angle。
            var _tilt_denominator = max(1, abs(_anim_dx) + abs(_anim_dy));
            __qol_merge_anim_tilt = 20 * (_anim_dx / _tilt_denominator);
            
            // 合并缩放也必须走视觉插值，而不是合并开始时立刻写 image_xscale/image_yscale。
            // 之前 survivor 是新召唤巨石时，会在召唤动画刚结束后直接跳到最终最大尺寸；
            // 现在真实 image_xscale/image_yscale 保持当前值，Draw 事件只临时使用插值缩放，Step 在动画结束后再落地最终缩放。
            __qol_merge_anim_start_scale_x = image_xscale;
            __qol_merge_anim_start_scale_y = image_yscale;
            __qol_merge_anim_end_scale_x = _is_survivor ? _merged_scale : image_xscale;
            __qol_merge_anim_end_scale_y = _is_survivor ? _merged_scale : image_yscale;
            
            if (_is_survivor)
            {
                // survivor 承载融合后的公开接口参数。
                // 后续其它地术技能可以通过 _scr_qol_runic_boulder_get_merged_count(id) 读取这个数量。
                // 注意：接口数量可以立即更新，因为其它逻辑需要知道融合后的质量；
                // 但显示尺寸不能立即更新，否则新召唤的 survivor 会在移动前突然膨胀。
                __qol_merged_count = _merged_total;
                max_hp = max(max_hp, HP);
            }
            else
            {
                // 非 survivor 只作为短暂视觉壳，播完移动动画后静默 instance_destroy。
                // 不调用 event_user(3)，不播放摧毁动画，不触发敌方摧毁巨石时的反噬/混乱逻辑。
                __qol_merge_absorbed = true;
                play_death = false;
                last_attacker = -4;
                can_broke = false;
                owner = -4;
            }
            
            image_speed = max(image_speed, 1);
            scr_camera_shake(max(2, 8 - _group_size));
            
            if (_is_survivor && HP <= 0)
            {
                last_attacker = -4;
                event_user(3);
            }
        }
    }
    
    return true;
}
