function scr_weapon_generation_prefix_search(argument0, argument1)
{
    // ========================================
    // 初始化计数器和映射表
    // ========================================
    
    var prefix_count = ds_map_create();
    var char_map = ds_map_create();
    
    // ========================================
    // 生成词缀
    // ========================================
    for (var i = 0; i < argument0; i++)
    {
        var attempts = 0;
        var max_attempts = 100;
        var found = false;
        var new_value = undefined;
        var new_char_value = undefined;
        
        // ========================================
        // 尝试找到符合条件的词缀
        // ========================================
        
        while (!found && attempts < max_attempts)
        {
            attempts++;
            
            var key = ds_map_find_first(argument1);
            var skip_count = floor(random(ds_map_size(argument1)));
            
            for (var j = 0; j < skip_count; j++)
                key = ds_map_find_next(argument1, key);
            
            var stat_name = ds_map_find_value(argument1, key);
            var slot_value = ds_map_find_value(global.weapon_slotmap, stat_name);
            var metatype = ds_map_find_value(data, "Metatype");
            
            if (metatype == slot_value || slot_value == "all")
                found = true;
        }
        
        if (!found)
            exit;
        
        // ========================================
        // ✅ 计算属性值（从全局配置读取）
        // ========================================
        
        // ✅ 从全局 effect 获取范围
        var value_range = ds_map_find_value(global.weapon_effect, stat_name);
        var char_value = 0;
        
        // ✅ 诅咒装备：使用上限值 × 1.3（固定）
        if (quality == Curse)
        {
            if (value_range != undefined)
            {
                var max_value = ds_list_find_value(value_range, 1);
                char_value = ceil(max_value * 1.3);
            }
        }
        // ✅ 非诅咒装备：使用随机值
        else
        {
            if (value_range != undefined)
            {
                var min_value = ds_list_find_value(value_range, 0);
                var max_value = ds_list_find_value(value_range, 1);
                char_value = ceil(random_range(min_value, max_value));
            }
        }
        
        // ========================================
        // 生成全名
        // ========================================
        
        var percent_suffix = scr_atr_percent(stat_name);
        if (percent_suffix == undefined)
            percent_suffix = "%";
        
        var full_name = char_value >= 0 ? stat_name + " +" + string(char_value) + percent_suffix : stat_name + " " + string(char_value) + percent_suffix;
        
        // ========================================
        // ✅ 检查是否可叠加（从全局配置读取）
        // ========================================
        
        var max_stack = ds_map_find_value(global.weapon_stackable, stat_name);  // ✅ 从全局配置读取
        var current_count = ds_map_find_value(prefix_count, key) != undefined ? ds_map_find_value(prefix_count, key) : 0;
        
        // ========================================
        // 检查是否达到最大次数
        // ========================================
        
        if (current_count >= max_stack)
        {
            // 已达到最大次数，跳过并重试
            i--;
            continue;
        }
        
        // ========================================
        // 叠加属性值
        // ========================================
        
        var existValue = ds_map_find_value(data, stat_name);
        
        if (existValue == undefined)
        {
            // 首次出现：直接添加
            ds_map_add(data, string(stat_name), char_value);
        }
        else
        {
            // 已存在：叠加数值
            new_value = real(char_value) + real(existValue);
            ds_map_replace(data, string(stat_name), new_value);
        }
        
        // ========================================
        // 更新 Char 字段（合并显示）
        // ========================================
        
        var existing_char_key = ds_map_find_value(char_map, stat_name);
        
        if (existing_char_key != undefined)
        {
            // 已存在：更新 Char 字段
            new_char_value = ds_map_find_value(data, stat_name);
            
            if (new_char_value >= 0)
                ds_map_replace(data, existing_char_key, stat_name + " +" + string(new_char_value) + percent_suffix);
            else
                ds_map_replace(data, existing_char_key, stat_name + " " + string(new_char_value) + percent_suffix);
        }
        else
        {
            // 不存在：添加新的 Char 字段
            var char_key = "Char" + string(n);
            ds_map_add(data, char_key, full_name);
            n++;
            
            // 记录映射关系
            ds_map_add(char_map, stat_name, char_key);
        }
        
        // ========================================
        // 更新词缀使用次数
        // ========================================
        
        ds_map_add(prefix_count, key, current_count + 1);
        
        // ========================================
        // 记录第一个词缀的 key
        // ========================================
        
        if (n == 1)
            ds_map_add(data, "key", key);
    }
    
    // ========================================
    // 清理临时 map
    // ========================================
    
    ds_map_destroy(prefix_count);
    ds_map_destroy(char_map);
}