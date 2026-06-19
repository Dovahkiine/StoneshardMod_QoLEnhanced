event_inherited()

// QoLEnhanced - 运行时占位清理。
// 原版巨石 Create 会把自身格写入 posgrid/newgrid 类碰撞数据；本模组的合并机制会移动巨石，
// 因此 Destroy 时必须以“当前格”为准再做一次兜底清理，避免精力耗尽/脱离视野崩塌后留下不可召唤的空格。
// posgrid 只在当前格仍登记为本实例时清掉，防止误删后来站到同格的单位或其它实体。
var __qol_grid_x = x div 26
var __qol_grid_y = y div 26

if (ds_grid_get(o_controller.posgrid, __qol_grid_x, __qol_grid_y) == id)
    ds_grid_set(o_controller.posgrid, __qol_grid_x, __qol_grid_y, -4)

// newgrid 不保存实例 id，只保存阻挡权重；这里调用原版清理函数，让它按 cleangrid/weight_grid 恢复底层地形值。
scr_collision_clear(o_controller.newgrid, __qol_grid_x, __qol_grid_y)

with (light)
    instance_destroy()
if play_death
{
    death_sound = choose(snd_runic_boulder_destoy_2)
    if (!audio_is_playing(snd_runic_boulder_destoy_2))
        scr_audio_play_at(snd_runic_boulder_destoy_2)
}
scr_destroy_aura()
if (instance_exists(owner) && instance_exists(last_attacker))
{
    if (last_attacker.id != owner.id && instance_is(last_attacker, o_unit))
    {
        if ((!(scr_passive_skill_is_open(o_pass_skill_rune_of_impact, owner))) || scr_tile_distance(id, owner) > 2)
        {
            scr_damage_init()
            Arcane_Damage += (0.05 * owner.max_mp)
            scr_damage_with_calc(owner, true, 100, id, true)
            scr_effect_create(o_db_confuse, irandom_range(4, 6), owner, owner)
        }
    }
}
