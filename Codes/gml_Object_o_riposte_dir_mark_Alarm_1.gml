// Alarm_1 — 1 tick after Create_0（target_x/target_y 已由 scr_cast_spell 设置）
// 计算方向 + 创建 o_b_riposte buff + 启动箭头动画 + 推进回合

// 用 target_x/target_y（目标地块）而非 x/y（玩家坐标）计算角度
if (target_x != 0 || target_y != 0)
{
    var _angle = point_direction(o_player.x, o_player.y, target_x, target_y);
    o_player.__riposte_dir = (round(_angle / 45) mod 8);
    image_angle = round(_angle / 45) * 45;
}
else
{
    o_player.__riposte_dir = -4;
    image_angle = 0;
}

// 启动动画
image_speed = 1;
// 安全后备：sprite 无效时用默认值
var _frames = max(1, image_number);
alarm[0] = _frames;

// 在 owner（玩家）身上创建 o_b_riposte buff
// 使用技能表原始 duration=3，而非 mark 自身的 duration（2）
// mark 的 duration 用于 c_tile_mark_Other_10 自毁计时，不应用于 buff
// buff 的 Create_0（含 insert）会读取 o_player.__riposte_dir
scr_effect_create(__asset_get_index("o_b_riposte"), 3, owner, owner);

// 推进回合 — 模拟 No Target 技能 o_skill alarm[1]=2 → scr_allturn() 的流程
// Target Point 技能的 scr_skill_prepare_to_use 不会触发此 alarm，需在此补调用
scr_allturn();
