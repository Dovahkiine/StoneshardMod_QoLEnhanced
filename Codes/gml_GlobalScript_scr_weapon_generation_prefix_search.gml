// 所有值类型逻辑完全内联，无需任何新增脚本
function scr_weapon_generation_prefix_search(argument0, argument1)
{
    var prefix_count = ds_map_create();
    var char_map     = ds_map_create();

    for (var i = 0; i < argument0; i++)
    {
        var attempts     = 0;
        var max_attempts = 100;
        var found        = false;
        var new_value    = undefined;
        var new_char_value = undefined;

        // ── 随机抽取符合槽位的词缀 ──────────────────────────────
        while (!found && attempts < max_attempts)
        {
            attempts++;

            var key = ds_map_find_first(argument1);
            var skip_count = floor(random(ds_map_size(argument1)));
            for (var j = 0; j < skip_count; j++)
                key = ds_map_find_next(argument1, key);

            var stat_name  = ds_map_find_value(argument1, key);
            var slot_value = ds_map_find_value(global.weapon_slotmap, stat_name);
            var metatype   = ds_map_find_value(data, "Metatype");

            if (metatype == slot_value || slot_value == "all")
                found = true;
        }

        if (!found) break;

        // ── 叠加上限检查 ─────────────────────────────────────────
        var max_stack    = ds_map_find_value(global.weapon_stackable, stat_name);
        if (max_stack == undefined) max_stack = 1;

        var current_count = ds_map_find_value(prefix_count, stat_name);
        if (current_count == undefined) current_count = 0;

        if (current_count >= max_stack)
        {
            i--;
            continue;
        }

        // ── 读取范围与值类型 ─────────────────────────────────────
        var value_range = ds_map_find_value(global.weapon_effect,     stat_name);
        var value_type  = ds_map_find_value(global.weapon_value_type, stat_name);
        if (value_type == undefined) value_type = 0;

        var char_value = 0;

        if (value_range != undefined)
        {
            var min_value = ds_list_find_value(value_range, 0);
            var max_value = ds_list_find_value(value_range, 1);

            if (quality == Curse)
            {
                // ── 诅咒：上限 × 1.3 后对齐到步进格点 ──────────
                var _raw = max_value * 1.3;
                switch (value_type)
                {
                    case 1: char_value = round(_raw * 2) / 2;  break; // 0.5步进
                    case 2: char_value = round(_raw * 5) / 5;  break; // 0.2步进
                    default: char_value = round(_raw);           break; // 整数
                }
            }
            else
            {
                // ── 正常随机：irandom 保证两端均可取到 ──────────
                if (value_type == 1)
                {
                    // 0.5 步进
                    var _steps = round((max_value - min_value) / 0.5);
                    char_value = min_value + irandom(_steps) * 0.5;
                }
                else if (value_type == 2)
                {
                    // 0.2 步进
                    var _steps = round((max_value - min_value) / 0.2);
                    char_value = min_value + irandom(_steps) * 0.2;
                }
                else
                {
                    // 整数（默认）：irandom_range [min, max] 闭区间
                    char_value = irandom_range(floor(min_value), floor(max_value));
                }
            }
        }

        // ── 格式化显示字符串（内联） ─────────────────────────────
        var val_str;
        if (value_type == 1 || value_type == 2)
            val_str = string_format(char_value, 0, 1); // 保留1位小数
        else
            val_str = string(char_value);

        var percent_suffix = scr_atr_percent(stat_name);
        if (percent_suffix == undefined) percent_suffix = "%";

        var full_name = (char_value >= 0)
            ? stat_name + " +" + val_str + percent_suffix
            : stat_name + " "  + val_str + percent_suffix;

        // ── 叠加到 data ──────────────────────────────────────────
        var existValue = ds_map_find_value(data, stat_name);

        if (existValue == undefined)
            ds_map_add(data, string(stat_name), char_value);
        else
        {
            new_value = real(char_value) + real(existValue);
            ds_map_replace(data, string(stat_name), new_value);
        }

        // ── 更新 Char 显示字段 ───────────────────────────────────
        var existing_char_key = ds_map_find_value(char_map, stat_name);

        if (existing_char_key != undefined)
        {
            new_char_value = ds_map_find_value(data, stat_name);
            var ncs;
            if (value_type == 1 || value_type == 2)
                ncs = string_format(new_char_value, 0, 1);
            else
                ncs = string(new_char_value);

            if (new_char_value >= 0)
                ds_map_replace(data, existing_char_key, stat_name + " +" + ncs + percent_suffix);
            else
                ds_map_replace(data, existing_char_key, stat_name + " "  + ncs + percent_suffix);
        }
        else
        {
            var char_key = "Char" + string(n);
            ds_map_add(data, char_key, full_name);
            n++;
            ds_map_add(char_map, stat_name, char_key);
        }

        // ── 记录首词缀 key / 更新计数 ────────────────────────────
        if (n == 1)
            ds_map_add(data, "key", key);

        if (current_count == 0)
            ds_map_add(prefix_count, stat_name, 1);
        else
            ds_map_replace(prefix_count, stat_name, current_count + 1);
    }

    ds_map_destroy(prefix_count);
    ds_map_destroy(char_map);
}
