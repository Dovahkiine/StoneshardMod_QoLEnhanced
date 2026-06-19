// QoLEnhanced - 符文巨石绘制替换。
// 原版 Draw 直接使用 x/y 绘制，所以合并逻辑即使设置 draw_x/draw_y 也不会产生移动动画。
// 这里在合并动画期间把绘制坐标插值到旧召唤点和当前实体坐标之间；实体 x/y 已经在逻辑层移动到合并点，
// 因此这段代码只影响视觉，不影响碰撞、选点、敌人寻路、被攻击目标位置等运行时逻辑。
var __qol_draw_x = x
var __qol_draw_y = y
var __qol_draw_angle = 0
var __qol_draw_xscale = image_xscale
var __qol_draw_yscale = image_yscale

if (variable_instance_exists(id, "__qol_merge_anim_active") && __qol_merge_anim_active)
{
    var __qol_anim_duration = max(1, __qol_merge_anim_duration)
    var __qol_anim_progress = min(1, __qol_merge_anim_frame / __qol_anim_duration)
    
    // 与 Step 使用同一条 smoothstep 曲线，保证尘土位置和巨石绘制位置大体一致。
    var __qol_anim_eased = __qol_anim_progress * __qol_anim_progress * (3 - (2 * __qol_anim_progress))
    __qol_draw_x = __qol_merge_anim_start_x + ((__qol_merge_anim_end_x - __qol_merge_anim_start_x) * __qol_anim_eased)
    __qol_draw_y = __qol_merge_anim_start_y + ((__qol_merge_anim_end_y - __qol_merge_anim_start_y) * __qol_anim_eased)
    
    // 倾斜角随动画逐渐回正，避免到达终点后仍然歪斜。
    // 最大倾斜由 try_merge 计算，约 20 度；这里只做视觉使用，不长期污染 image_angle。
    __qol_draw_angle = __qol_merge_anim_tilt * (1 - __qol_anim_progress)
    
    // 合并体尺寸也跟随同一条动画曲线插值。
    // 这修复新召唤 survivor 在召唤动画结束后立刻跳到最大尺寸的问题：
    // 真实 image_xscale/image_yscale 在动画结束前不变，只有本 Draw 帧临时绘制为插值尺寸。
    if (variable_instance_exists(id, "__qol_merge_anim_start_scale_x") && variable_instance_exists(id, "__qol_merge_anim_end_scale_x"))
        __qol_draw_xscale = __qol_merge_anim_start_scale_x + ((__qol_merge_anim_end_scale_x - __qol_merge_anim_start_scale_x) * __qol_anim_eased)
    
    if (variable_instance_exists(id, "__qol_merge_anim_start_scale_y") && variable_instance_exists(id, "__qol_merge_anim_end_scale_y"))
        __qol_draw_yscale = __qol_merge_anim_start_scale_y + ((__qol_merge_anim_end_scale_y - __qol_merge_anim_start_scale_y) * __qol_anim_eased)
}

var __qol_sprite = s_boulder_shadows

// 暂时替换 x/y/draw_x/draw_y/image_angle，让原版后续绘制辅助函数也使用动画位置。
// 关键点：scr_draw_self_stuff() 内部会调用 scr_spriteTransformUpdate()，它读 draw_x/draw_y 而不是 x/y。
// 第一版只替换 x/y，导致阴影和巨石本体使用不同坐标；这里四个坐标一起替换，Draw 结束前立即恢复。
var __qol_real_x = x
var __qol_real_y = y
var __qol_real_draw_x = draw_x
var __qol_real_draw_y = draw_y
var __qol_real_angle = image_angle
var __qol_real_xscale = image_xscale
var __qol_real_yscale = image_yscale
x = __qol_draw_x
y = __qol_draw_y
draw_x = __qol_draw_x
draw_y = __qol_draw_y
image_angle = __qol_draw_angle
image_xscale = __qol_draw_xscale
image_yscale = __qol_draw_yscale

if (sprite_index == s_boulder_spawn)
{
    __qol_sprite = s_boulder_spawn_shadows
    draw_sprite_ext(s_boulder_spawn_cracks, image_index, x, y, 1, 1, image_angle, c_white, image_alpha)
}
else if (sprite_index == s_boulder_throw_start && image_index < 7)
{
    __qol_sprite = s_boulder_throw_start_shadows
    draw_sprite_ext(s_boulder_spawn_cracks, image_number - image_index - 1, x, y, 1, 1, image_angle, c_white, image_alpha)
}
else if (sprite_index == s_boulder_destroy)
{
    __qol_sprite = s_boulder_destroy_shadows
}

draw_sprite_ext(__qol_sprite, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, image_alpha)
scr_draw_self_stuff()

if (sprite_index == s_boulder_spawn && image_speed == 0)
    scr_highlight_ext()

x = __qol_real_x
y = __qol_real_y
draw_x = __qol_real_draw_x
draw_y = __qol_real_draw_y
image_angle = __qol_real_angle
image_xscale = __qol_real_xscale
image_yscale = __qol_real_yscale
