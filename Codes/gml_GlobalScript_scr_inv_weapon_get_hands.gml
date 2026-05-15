function scr_inv_weapon_get_hands(argument0) {
    // 先根据武器类型设置基础属性
    switch (argument0) {
        case "2hsword":
            character_sprite_hands = 2;
            hands = 1;
            break;
            
        case "2haxe":
            character_sprite_hands = 2;
            hands = 1;
            break;

        case "2hmace":
            character_sprite_hands = 2;
            hands = 1;
            break;

        case "2hStaff":
            character_sprite_hands = 2;
            hands = 1;
            break;

        case "crossbow":
            character_sprite_hands = 2;
            hands = 1;
            haveAmmunitionSlot = true;
            ammunitionType = "bolt";
            isCrossbow = true;
            break;

        case "bow":
            character_sprite_hands = 1;
            hands = 1;
            haveAmmunitionSlot = true;
            ammunitionType = "arrow";
            break;

        case "sling":
            character_sprite_hands = 1;
            hands = 1;
            haveAmmunitionSlot = true;
            ammunitionType = "sling_ammo";
            isSling = true;
            break;

        case "spear":
            character_sprite_hands = 2;
            hands = 1;
            break;

        default:
            character_sprite_hands = 1;
            hands = 1;
            break;
    }

    // 再根据具体 idName 覆盖特殊规则
    switch (ds_map_find_value(data, "idName")) {
        case "Chain":
            character_sprite_hands = 1;
            hands = 1;
            break;

        case "Lute":
            character_sprite_hands = 1;
            hands = 1;
            break;

        case "Peasant Scythe":
            character_sprite_hands = 1;
            hands = 1;
            break;

        case "Pickaxe":
            character_sprite_hands = 1;
            hands = 1;
            break;

        case "Broom":
            character_sprite_hands = 1;
            hands = 1;
            break;

        case "Shackles":
            character_sprite_hands = 1;
            hands = 1;
            break;
    }
}
