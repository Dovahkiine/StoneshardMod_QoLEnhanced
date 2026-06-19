function scr_runic_boulder_get_hp()
{
    // QoLEnhanced - 符文巨石生命值集中公式。
    // 默认占位保持原版同量级：30 * (Magic_Power + Geomantic_Power) / 100。
    // 主人后续调数值时优先改下面三个常量，不需要去 Alarm_1 / tooltip / 合并逻辑里追公式。
    var _base_hp = 0;
    var _magic_power_coef = 30;
    var _geomantic_power_coef = 30;
    var _extra_hp = 0;
    
    if (!instance_exists(owner))
        return _base_hp;
    
    return _base_hp + ((_magic_power_coef * owner.Magic_Power) / 100) + ((_geomantic_power_coef * owner.Geomantic_Power) / 100) + _extra_hp;
}
