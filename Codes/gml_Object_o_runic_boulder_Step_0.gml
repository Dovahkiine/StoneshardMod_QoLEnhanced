event_inherited()

// QoLEnhanced - 延迟触发合并。
// Alarm_1 可能在 s_boulder_spawn 生成动画尚未播完时运行；如果立刻合并，新召唤巨石会在未完全出现时开始位移。
// try_merge 在这种情况下只写 __qol_merge_pending，本 Step 等待动画停止后再真正触发合并。
if (variable_instance_exists(id, "__qol_merge_pending") && __qol_merge_pending)
{
    if (sprite_index != s_boulder_spawn || image_speed == 0)
    {
        _scr_qol_runic_boulder_try_merge(id)
        _scr_qol_runic_boulder_apply_limit(id)
    }
}

// QoLEnhanced - 符文巨石合并移动动画推进。
// 合并逻辑会立即把实体坐标/碰撞网格移动到合并点；这里仅推进视觉插值帧，并在插值位置生成尘土。
// 这样既能看到巨石沿轨迹冲撞，又不会让旧坐标继续占用地图格子。
if (variable_instance_exists(id, "__qol_merge_anim_active") && __qol_merge_anim_active)
{
    __qol_merge_anim_frame += 1
    
    var __qol_anim_duration = max(1, __qol_merge_anim_duration)
    var __qol_anim_progress = min(1, __qol_merge_anim_frame / __qol_anim_duration)
    
    // smoothstep 曲线：起步和停止都更缓，解决第一版“刚开始就冲太快”的观感问题。
    var __qol_anim_eased = __qol_anim_progress * __qol_anim_progress * (3 - (2 * __qol_anim_progress))
    var __qol_anim_x = __qol_merge_anim_start_x + ((__qol_merge_anim_end_x - __qol_merge_anim_start_x) * __qol_anim_eased)
    var __qol_anim_y = __qol_merge_anim_start_y + ((__qol_merge_anim_end_y - __qol_merge_anim_start_y) * __qol_anim_eased)
    
    // 沿移动轨迹持续扬尘。方向取移动反方向并给较大扩散角，避免粒子像直线投射物一样僵硬。
    if (scr_chance_value(70))
        scr_dust_emition(4 + irandom(4), 2, __qol_merge_anim_dir + 180, 70, __qol_anim_x + random_range(-10, 10), __qol_anim_y + random_range(-8, 8))
    
    // 动画期间的小幅震屏只做视觉强调；强合并造成的主震屏仍在 try_merge 中按参与巨石数量触发。
    if (scr_chance_value(45))
        scr_camera_shake(random_range(0, 1.5))
    
    if (__qol_merge_anim_frame >= __qol_anim_duration)
    {
        __qol_merge_anim_active = false
        image_angle = 0
        
        // survivor 的最终尺寸只在动画结束时落到真实 image_xscale/image_yscale。
        // 动画期间 Draw 会临时使用插值缩放并在帧末恢复，避免实体刚开始移动前突然变成最大尺寸。
        if (variable_instance_exists(id, "__qol_merge_anim_end_scale_x"))
            image_xscale = __qol_merge_anim_end_scale_x
        
        if (variable_instance_exists(id, "__qol_merge_anim_end_scale_y"))
            image_yscale = __qol_merge_anim_end_scale_y
        
        scr_dust_emition(10 + irandom(8), 3, 90, 180, x + random_range(-12, 12), y + random_range(-10, 10))
        
        // 被融合吸收的旧巨石只承担视觉飞行动画。
        // 到达融合点后静默销毁：不走 event_user(3)，因此不会播出原版摧毁动画，也不会触发“敌方摧毁巨石”的反噬逻辑。
        if (variable_instance_exists(id, "__qol_merge_absorbed") && __qol_merge_absorbed)
        {
            play_death = false
            last_attacker = -4
            instance_destroy()
            exit
        }
    }
}

if (image_speed)
{
    scr_camera_shake(random_range(0, 2))
    
    if (sprite_index == s_boulder_spawn)
    {
        if (scr_chance_value(27))
            scr_dust_emition(irandom(25) + 12, 1, 270, 180, x + random_range(-20, 15), y + random_range(-15, 20))
    }
}

// 被融合吸收的视觉壳会在动画结束时静默 instance_destroy。
// 这里不能让 HP<=0 走 event_user(3)，否则会播放原版摧毁动画，违背“融合不播摧毁”的新设计。
if (HP <= 0 && (!(variable_instance_exists(id, "__qol_merge_absorbed") && __qol_merge_absorbed)))
    event_user(3)
