event_inherited()
culling = 2
alarm[2] = 40
depth -= 15
image_speed = 1
scr_material_stone_geo()
scr_damage_init()
scr_light_constructor(x, y, 0, o_spotlight, 65280, 0)
scr_light_off()
HP = 30
aura = __dsDebuggerListCreate()
inside_particles = o_empty
particles = array_create(0)
corpse_type = o_empty
is_crit = false
target = -4
name = "Runic Boulder"
alarm[1] = 10
duration = 20
play_death = true
is_created = false
child_buff = -4
in_focus = false
owner = -4
scr_set_lt()
scr_set_hl()
__dsDebuggerListClear(impact_sound)
ds_list_add(impact_sound, snd_stone_impact_1, snd_stone_impact_2, snd_stone_impact_3, snd_stone_impact_4)
scr_noise_produce(scr_noise_AOE(id), grid_x, grid_y)
fogBehaviourEnabled = true
