if (interact_id == noone)
    interact_id = scr_findNearestInstanceDepthExt(global.guiMouseX, global.guiMouseY, c_GUI, o_inv_slot_parent);

var _success = false;

with (interact_id)
{
    if (image_alpha == 1)
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
        
        if (inmouse)
        {
            scr_guiInteractiveEventPerform(id, 1);
            scr_guiInteractiveEventPerform(id, 0);
        }
        
        _success = true;
    }
}

if (_success)
{
    with (parent)
    {
        scr_actionsLog("useItem", [scr_actionsLogGetName(o_player), log_text, scr_actionsLogGetName(id)]);
        sh_diss = 200;
    }
    
    event_user(0);
}

interact_id = noone;
