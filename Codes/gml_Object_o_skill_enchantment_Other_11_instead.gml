{
    if (scr_chance_value(50))
        //quality = Uncommon;
        scr_rerrol_item_simple((2 << 0));
    else if (scr_chance_value(50))
        //quality = Rare;
        scr_rerrol_item_simple((3 << 0));
    else if (scr_chance_value(50))
        //quality = Epic;
        scr_rerrol_item_simple((4 << 0));
    else if (scr_chance_value(60))
        //quality = Unique;
        scr_rerrol_item_simple((6 << 0));
    else
        //quality = Treasure;
        scr_rerrol_item_simple((7 << 0));

