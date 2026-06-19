function _scr_qol_runic_boulder_apply_limit(argument0)
{
    // QoLEnhanced - 符文巨石上限结算。
    // argument0 是刚召唤出来、已经完成“可能合并”的符文巨石。
    // 这个 helper 专门放在合并之后调用，满足新设计：
    // 1) 如果新巨石与旧巨石发生融合，融合后只保留一个实例，场上数量先自然下降；
    // 2) 然后再判断是否超过上限；
    // 3) 只有在未发生合并且数量仍超限时，才沿用原版“摧毁最早扫描到的其它巨石”的风格。
    if (!instance_exists(argument0))
        return false;
    
    var _seed = argument0;
    var _owner = _seed.owner;
    
    if (!instance_exists(_owner))
        return false;
    
    // 上限来源为“3 + (地系已经开启的技能数量 - 1)”。
    // 上一版尝试组合 o_skill_ico 与 owner.pass_skill，但运行时表现退回固定 3，说明被动列表路径并不适合作为玩家技能树统计来源。
    // 这里改用主人指出的原版技能树分类容器：o_skill_category_geomancy.skill。
    // 已核对 BaseDataCode：
    // - o_skill_category_geomancy_Create_0 会把地系全部主动与被动技能图标对象放进 skill 数组；
    // - gml_Object_o_pass_skill_residual_charge_Other_15 的电系计数已经采用同一模式：
    //   with (o_skill_category_electromancy) 后直接读取 skill[i].is_open；
    // - 每个技能图标仍通过原版 is_open 字段表示是否已学习。
    // 这条路径能自然包含合一符文 rune_of_impact，因为它在地系分类数组中，而不需要写 o_pass_skill_* 对象名单。
    // 如果技能树 UI 容器在极早时机尚未创建，则 fallback 到 scr_unit_skill_count 统计主动地系技能，至少避免完全失效。
    var _opened_geomancy_count = 0;
    
    if (instance_exists(o_skill_category_geomancy))
    {
        with (o_skill_category_geomancy)
        {
            var _size = array_length(skill);
            
            for (var i = 0; i < _size; i++)
            {
                // 这里刻意不再进入 with (skill[i])：
                // 1) 原版 residual_charge 的技能树计数就是直接读 skill[i].is_open；
                // 2) 我们只需要读取技能图标实例的一个字段，不需要切换执行作用域；
                // 3) 避免双层 with 下外层局部变量累加路径变得不直观，降低运行时退回基础上限 3 的风险。
                if (skill[i].is_open)
                    _opened_geomancy_count++;
            }
        }
    }
    else
    {
        // fallback 只作为技能树分类实例缺失时的保底；它仍会漏掉合一符文等被动，所以正常情况下不应走到这里。
        _opened_geomancy_count = scr_unit_skill_count(_owner, false, "geomancy", -4, -4, -4, false, true);
    }
    
    // 若存档加载或 UI 初始化时出现极早调用，至少按“已经学会符文巨石”处理，保持基础上限为 3。
    _opened_geomancy_count = max(1, _opened_geomancy_count);
    var _max_count = 3 + (_opened_geomancy_count - 1);
    var _count = 1;
    var _removed = false;
    
    with (o_runic_boulder)
    {
        if (id != _seed && owner == _owner)
        {
            if (_count >= _max_count)
            {
                // 这里保留原版上限逻辑的“摧毁其它已存在巨石”风格。
                // 与融合吸收不同，上限触发仍应正常进入 event_user(3)，保留原版崩塌/结束表现。
                last_attacker = -4;
                event_user(3);
                _removed = true;
            }
            else
            {
                _count++;
            }
        }
    }
    
    return _removed;
}
