event_inherited()

// 被融合吸收的旧巨石在短暂移动动画期间只是视觉壳，owner 已被清成 -4，且不再算作符文巨石数量。
// 如果继续执行原版回合维护逻辑，会因为 owner 不存在而触发 event_user(3)，导致不该出现的摧毁动画。
if (variable_instance_exists(id, "__qol_merge_absorbed") && __qol_merge_absorbed)
    exit

// QoLEnhanced - 延迟崩塌计数器。
// 原版 Other_12 是符文巨石的回合更新入口；计数必须放在这里，不能放到 Step，否则会按帧累计。
if (!variable_instance_exists(id, "__qol_out_of_sight_turns"))
    __qol_out_of_sight_turns = 0

if (!variable_instance_exists(id, "__qol_no_energy_turns"))
    __qol_no_energy_turns = 0

if (instance_exists(owner))
{
    var _is_player = is_player(owner)
    var _is_visible = is_visible()
    
    if (!_is_player)
        _is_visible = scr_enemy_vision_check(id, owner)
    
    // 旧逻辑 owner.MP < 1 立刻崩塌；新逻辑连续 2 回合精力耗尽才崩塌。
    // 精力恢复时清零，避免一次短暂耗尽在之后被错误累计。
    if (owner.MP < 1)
        __qol_no_energy_turns += 1
    else
        __qol_no_energy_turns = 0
    
    if (__qol_no_energy_turns >= 2)
    {
        last_attacker = -4
        event_user(3)
    }
    else if (_is_visible)
    {
        // 重新进入视野立即清零脱离视野计数，确保“连续 5 回合”语义成立。
        __qol_out_of_sight_turns = 0
        var buff = scr_instance_exists_in_list(o_b_runic_power, owner.buffs)
        
        if (!buff)
            scr_effect_create(o_b_runic_power, 1, owner, owner)
        
        // 保留原版 Rune of Fortifying 邻接减伤逻辑。
        if (scr_passive_skill_is_open(o_pass_skill_rune_of_fortifying, owner) && scr_tile_distance(id, owner) == 1)
        {
            var _boulder_count = 1
            
            with (object_index)
            {
                if (id != other.id && owner == other.owner)
                {
                    if (is_visible() || (scr_tile_distance(id, owner) < owner.VSN && !_is_player))
                        _boulder_count++
                }
            }
            
            if (scr_temp_effect_count(object_index, owner, "Damage_Received") < _boulder_count)
            {
                scr_temp_incr_atr("Damage_Received", -5, 1, owner, owner, 1, 1, object_index)
                scr_temp_incr_atr("Backfire_Damage_Change", -5, 1, owner, owner, 1, 1, object_index)
            }
        }
    }
    else
    {
        // 旧逻辑脱离视野立即崩塌；新逻辑连续 5 回合脱离视野才崩塌。
        // 脱离视野期间仍清掉符文强化 buff，保持“视野之内每有一块巨石才给层数”的原版语义。
        __qol_out_of_sight_turns += 1
        
        with (o_b_runic_power)
            event_user(0)
        
        if (__qol_out_of_sight_turns >= 5)
        {
            last_attacker = -4
            event_user(3)
        }
    }
}
else
{
    event_user(3)
}
