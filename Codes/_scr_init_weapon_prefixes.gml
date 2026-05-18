// 武器词缀初始化
// value_type 约定（直接用数字，无需宏）：
//   0 = 整数        irandom_range(min, max)
//   1 = 0.5 步进    min + irandom(steps)*0.5
//   2 = 0.2 步进    min + irandom(steps)*0.2
function _scr_init_weapon_prefixes()
{
    global.weapon_slotmap    = ds_map_create();
    global.weapon_common     = ds_map_create();
    global.weapon_rare       = ds_map_create();
    global.weapon_effect     = ds_map_create();
    global.weapon_stackable  = ds_map_create();
    global.weapon_value_type = ds_map_create(); // ✅ 新增

    // === 伤害类型 ===
    scr_weapon_prefix_generation("Arcane_Damage",  "Weapon", 2, [2, 4],   2, 0);
    scr_weapon_prefix_generation("Piercing_Damage","Weapon", 2, [2, 4],   2, 0);
    scr_weapon_prefix_generation("Sacred_Damage",  "Weapon", 2, [2, 4],   2, 0);
    scr_weapon_prefix_generation("Unholy_Damage",  "Weapon", 2, [2, 4],   2, 0);
    scr_weapon_prefix_generation("Psionic_Damage", "Weapon", 2, [2, 4],   2, 0);

    // === 元素伤害 ===
    scr_weapon_prefix_generation("Fire_Damage",    "Weapon", 2, [2, 4],   2, 0);
    scr_weapon_prefix_generation("Frost_Damage",   "Weapon", 2, [2, 4],   2, 0);
    scr_weapon_prefix_generation("Poison_Damage",  "Weapon", 2, [2, 4],   2, 0);
    scr_weapon_prefix_generation("Shock_Damage",   "Weapon", 2, [2, 4],   2, 0);
    scr_weapon_prefix_generation("Caustic_Damage", "Weapon", 2, [2, 4],   2, 0);

    // === 属性 ===
    scr_weapon_prefix_generation("Damage_Received",  "Armor",  1, [-5, -3], 2, 2);
    scr_weapon_prefix_generation("Lifesteal",        "Weapon", 2, [6, 10],  2, 2);
    scr_weapon_prefix_generation("Manasteal",        "Weapon", 2, [6, 10],  2, 2);
    scr_weapon_prefix_generation("Bleeding_Chance",  "Weapon", 2, [6, 10],  2, 1);
    scr_weapon_prefix_generation("Daze_Chance",      "Weapon", 2, [6, 10],  2, 1);
    scr_weapon_prefix_generation("Stun_Chance",      "Weapon", 2, [6, 10],  2, 1);
    scr_weapon_prefix_generation("Knockback_Chance", "Weapon", 2, [6, 10],  2, 1);

    // === 基础属性 ===
    scr_weapon_prefix_generation("STR",      "All",   1, [2, 6],   2, 0);
    scr_weapon_prefix_generation("AGL",      "All",   1, [2, 6],   2, 0);
    scr_weapon_prefix_generation("PRC",      "All",   1, [2, 6],   2, 0);
    scr_weapon_prefix_generation("Vitality", "All",   1, [2, 6],   2, 0);
    scr_weapon_prefix_generation("WIL",      "All",   1, [2, 6],   2, 0);
    scr_weapon_prefix_generation("HP",       "Armor", 2, [6, 12],  2, 0);
    scr_weapon_prefix_generation("MP",       "Armor", 2, [6, 12],  2, 0);
    scr_weapon_prefix_generation("Health_Restoration", "Armor", 2, [12, 20], 1, 1);
    scr_weapon_prefix_generation("MP_Restoration",     "Armor", 2, [12, 20], 1, 1);
    scr_weapon_prefix_generation("Weapon_Damage",      "Weapon", 2, [5, 10],  3, 1);
    scr_weapon_prefix_generation("Armor_Damage",       "Weapon", 2, [15, 24], 2, 1);
    scr_weapon_prefix_generation("Bodypart_Damage",    "Weapon", 2, [15, 24], 2, 1);
    scr_weapon_prefix_generation("Magic_Power",        "Weapon", 2, [5, 10],  3, 1);

    // === 消耗减免 ===
    scr_weapon_prefix_generation("Skills_Energy_Cost", "all", 2, [-8, -5], 1, 1);
    scr_weapon_prefix_generation("Spells_Energy_Cost", "all", 2, [-8, -5], 1, 1);
    scr_weapon_prefix_generation("Cooldown_Reduction", "all", 2, [-8, -5], 4, 1);

    // === 战斗属性 ===
    scr_weapon_prefix_generation("PRR",           "Weapon", 1, [4, 6],   1, 1);
    scr_weapon_prefix_generation("Block_Power",   "all",    1, [4, 6],   1, 0);
    scr_weapon_prefix_generation("EVS",           "all",    1, [3, 5],   2, 1);
    scr_weapon_prefix_generation("CTA",           "all",    1, [4, 6],   2, 1);
    scr_weapon_prefix_generation("Hit_Chance",    "all",    1, [3, 5],   1, 2);
    scr_weapon_prefix_generation("CRT",           "all",    1, [4, 6],   2, 2);
    scr_weapon_prefix_generation("CRTD",          "all",    1, [10, 18], 2, 1);
    scr_weapon_prefix_generation("FMB",           "all",    1, [-5, -3], 1, 3);
    scr_weapon_prefix_generation("Armor_Piercing","Weapon", 1, [5, 8],   1, 1);

    // === 生存属性 ===
    scr_weapon_prefix_generation("Fortitude",        "Armor", 1, [6, 10],  1, 2);
    scr_weapon_prefix_generation("Healing_Received", "Armor", 1, [16, 24], 1, 1);

    // === 抗性 ===
    scr_weapon_prefix_generation("Slashing_Resistance",  "Armor", 1, [10, 18], 1, 2);
    scr_weapon_prefix_generation("Piercing_Resistance",  "Armor", 1, [10, 18], 1, 2);
    scr_weapon_prefix_generation("Blunt_Resistance",     "Armor", 1, [10, 18], 1, 2);
    scr_weapon_prefix_generation("Rending_Resistance",   "Armor", 1, [10, 18], 1, 2);
    scr_weapon_prefix_generation("Unholy_Resistance",    "Armor", 1, [10, 18], 1, 2);
    scr_weapon_prefix_generation("Stun_Resistance",      "Armor", 1, [10, 18], 1, 2);
    scr_weapon_prefix_generation("Knockback_Resistance", "Armor", 1, [10, 18], 1, 2);
    scr_weapon_prefix_generation("Bleeding_Resistance",  "Armor", 1, [10, 18], 1, 2);
    scr_weapon_prefix_generation("Physical_Resistance",  "Armor", 1, [4, 6],   2, 2);
    scr_weapon_prefix_generation("Nature_Resistance",    "Armor", 1, [6, 10],  1, 2);
    scr_weapon_prefix_generation("Magic_Resistance",     "Armor", 1, [6, 10],  1, 2);
    scr_weapon_prefix_generation("Pain_Resistance",      "Armor", 1, [6, 10],  1, 2);
}
