event_inherited();

var _altNow = keyboard_check(vk_alt);
if (!variable_instance_exists(id, "__qol_alt_prev"))
{
    __qol_alt_prev = _altNow;
    exit;
}

if (_altNow != __qol_alt_prev)
{
    __qol_alt_prev = _altNow;
    var _scrollable = false;
    var _contentWidth = 169;
    var _contentHeight = 0;
    
    if (!instance_exists(render))
        exit;
    
    with (render)
    {
        with (buffsContainer)
        {
            repeat (guiChildrenCount)
            {
                var _buff = ds_list_find_value(guiChildrenList, 0);
                
                with (_buff)
                {
                    x = -15000;
                    y = -15000;
                    guiVisibility = false;
                    scr_guiVisibleUpdate(id, false);
                    scr_guiContainerChildRemove(other.id, id);
                    scr_guiInteractiveEventUpdate(id, -4);
                }
            }
        }
        
        with (skillsContainer)
        {
            repeat (guiChildrenCount)
            {
                var _skill = ds_list_find_value(guiChildrenList, 0);
                
                with (_skill)
                {
                    if (object_is_ancestor(object_index, o_skill_passive))
                    {
                        x = -15000;
                        y = -15000;
                        guiVisibility = false;
                        scr_guiVisibleUpdate(id, false);
                        scr_guiContainerChildRemove(other.id, id);
                        scr_guiInteractiveEventUpdate(id, -4);
                    }
                    else
                    {
                        instance_destroy();
                    }
                }
            }
        }
        
        contentHeight = 0;
        buffsHeight = 0;
        skillsHeight = 0;
        titleHeight = 0;
        typeHeight = 0;
        statusHeight = 0;
        mainParamsHeight = 0;
        armorDurabilityHeight = 0;
        moraleHeight = 0;
        resistsHeight = 0;
        descriptionHeight = 0;
        event_user(0);
        _contentHeight = height / surfaceScale;
        
        if (_contentHeight > 303)
        {
            _scrollable = true;
            _contentHeight = 303;
        }
        
        drawAreaHeight = _contentHeight;
        event_user(11);
    }
    
    scr_guiContainerVisibleAreaUpdate(container, _contentWidth, _contentHeight);
    var _topPartSprite = -4;
    var _middlePartSprite = -4;
    var _bottomPartSprite = -4;
    
    if (_scrollable)
    {
        _topPartSprite = scr_adaptiveMenusGetSprite(s_explore_top_scrollable);
        _middlePartSprite = scr_adaptiveMenusGetSprite(s_explore_middle_scrollable);
        _bottomPartSprite = scr_adaptiveMenusGetSprite(s_explore_bottom_scrollable);
    }
    else
    {
        _topPartSprite = scr_adaptiveMenusGetSprite(s_explore_top);
        _middlePartSprite = scr_adaptiveMenusGetSprite(s_explore_middle);
        _bottomPartSprite = scr_adaptiveMenusGetSprite(s_explore_bottom);
    }
    
    var _topPartSpriteWidth = sprite_get_width(_topPartSprite);
    var _middlePartSpriteWidth = sprite_get_width(_middlePartSprite);
    var _bottomPartSpriteWidth = sprite_get_width(_bottomPartSprite);
    var _topPartSpriteHeight = sprite_get_height(_topPartSprite);
    var _middlePartSpriteHeight = max(0, _contentHeight - 70);
    var _bottomPartSpriteHeight = sprite_get_height(_bottomPartSprite);
    
    with (mask)
    {
        topPartSprite = _topPartSprite;
        topPartSpriteWidth = _topPartSpriteWidth;
        topPartSpriteHeight = _topPartSpriteHeight;
        middlePartSprite = _middlePartSprite;
        middlePartSpriteWidth = _middlePartSpriteWidth;
        middlePartSpriteHeight = _middlePartSpriteHeight;
        bottomPartSprite = _bottomPartSprite;
        bottomPartSpriteWidth = _bottomPartSpriteWidth;
        bottomPartSpriteHeight = _bottomPartSpriteHeight;
    }
    
    image_xscale = _topPartSpriteWidth;
    image_yscale = _topPartSpriteHeight + _middlePartSpriteHeight + _bottomPartSpriteHeight;
    scr_guiSizeUpdate(id, image_xscale, image_yscale);
    scr_adaptiveMenusPositionUpdate();
    
    with (scrollbarMask)
    {
        image_xscale = _contentWidth + (18 * _scrollable);
        image_yscale = 70 + _middlePartSpriteHeight;
    }
    
    with (scrollbar)
    {
        areaHeight = _contentHeight;
        trackHeight = 38 + _middlePartSpriteHeight;
    }
    
    with (scrollbarContainer)
    {
        image_xscale = 11;
        image_yscale = 40 + _middlePartSpriteHeight;
    }
    
    scr_guiLayoutOffsetUpdate(scrollbarDOWN, adaptiveOffsetX + 174, adaptiveOffsetY + _middlePartSpriteHeight + 57);
    scr_guiLayoutOffsetUpdate(closeButton, 192 + (18 * _scrollable), 3);
}
