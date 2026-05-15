sprite_index = s_npc_tott;
event_inherited();
name = ds_list_find_value(global.npc_constant_name, 89);
id_name = "coachman";
occupation = "ragpicker_tott";
sex = "male";
avatar = s_npc_tott_P;
interract_distance = 2;

with (npc_target)
{
    is_teleport = true;
    is_single_point = true;
    npc_sprite = s_npc_tott_riding;
}

show_town = false;
depth_add = -30;
idle_spr = sprite_index;
scr_buying_loot_category("alcohol", "armor", "medicine", "beverage", "potion", "jewelry", "food", "tool", "weapon", "scroll", "valuable", "drug", "scroll", "junk", "ingredient", "curse", "herb", "bag", "book", "backpack", "additive", "treatise", "treasure", "upgrade", "ammo", "material", "recipe", "schematic", "comm_wheat", "comm_ale", "comm_wine", "comm_cider", "comm_timber", "comm_coal", "comm_salt");
Selling_Prices = 1;
Price_Fluctuations = false;
Global_Restock = false;
Durability_Threshold = 5;
scr_npc_gold_init(14500, 17500);
Restock_Time = 6;
Restock_Type = "Random";
Equipment_Tier_Min = 1;
Equipment_Tier_Max_Base = 4;
Durability_Range_Min = 50;
Durability_Range_Max = 100;
Equipment_Uncommon_Chance = 25;
Equipment_Rare_Chance = 10;
Trade_Hovers = true;
trade_tags = "aldor fjall elven nistra skadia brynn aldwynn maen common uncommon rare magic";
idle_state = false;
ai_script = scr_enemy_choose_state;
dialog_move_key = "";
xx = xstart;
yy = ystart;
x = xx;
y = yy;
draw_x = x;
draw_y = y;
can_trade_array = [1, 1, 1, 1];
voice_tag_crimeKill = "";
voice_tag_admiration = "";
voice_tag_amity = "";
voice_tag_crimeAlarm = "";
voice_tag_crimeBrawl = "";
voice_tag_crimeGeneric = "";
voice_tag_crimeKill = "";
voice_tag_crimeTheft = "";
voice_tag_dislike = "";
voice_tag_hatred = "";
voice_tag_neutral = "";
voice_tag_respect = "";
dialog_id = "coachman_tott";
