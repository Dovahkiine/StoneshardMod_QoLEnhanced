if (!instance_exists(parent) || !instance_exists(owner))
{
    instance_destroy();
    exit;
}

if (alarm[0] == -1)
{
    // ALT-refresh: if ALT key state changed while hover is open, rebuild content immediately
    var __alt_now = keyboard_check(vk_alt);
    if (!variable_instance_exists(id, "__alt_prev")) __alt_prev = __alt_now;
    if (__alt_now != __alt_prev)
    {
        contentRecreate = true;
        if (instance_exists(contentRender))
        {
            with (contentRender)
            {
                // Force surface to rebuild on this frame
                if (variable_instance_exists(id, "surfaceRecreate"))
                    surfaceRecreate = true;
            }
        }
        __alt_prev = __alt_now;
    }

    if (contentRecreate)
    {
        with (contentRender)
        {
            owner = other.owner;
            event_user(0);
        }
        
        overflowWidth = 999999;
        overflowHeight = 999999;
        contentRecreate = false;
    }
    
    scr_hoverUpdate(id, placementsArray);
    
    if (alarm[1] == -1 && overflowWidth != 0)
    {
        overflowWidthOffset = scr_approach(overflowWidthOffset, overflowWidthOffsetMax, 0.25);
        
        if (overflowWidthOffset == overflowWidthOffsetMax)
        {
            overflowWidthOffsetMax = (overflowWidthOffsetMax == 0) ? overflowWidth : 0;
            alarm[1] = room_speed;
        }
        
        surfaceRedraw = true;
    }
    
    if (alarm[2] == -1 && overflowHeight != 0)
    {
        overflowHeightOffset = scr_approach(overflowHeightOffset, overflowHeightOffsetMax, 0.25);
        
        if (overflowHeightOffset == overflowHeightOffsetMax)
        {
            overflowHeightOffsetMax = (overflowHeightOffsetMax == 0) ? overflowHeight : 0;
            alarm[2] = room_speed;
        }
        
        surfaceRedraw = true;
    }
    
    if (destroy)
    {
        image_alpha = scr_approach(image_alpha, 0, 0.2);
        
        if (image_alpha == 0)
            instance_destroy();
    }
    else
    {
        image_alpha = scr_approach(image_alpha, 1, 0.2);
    }
}
