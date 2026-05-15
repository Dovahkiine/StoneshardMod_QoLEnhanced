if (!instance_exists(o_stash_inventory_left))
{
    with (scr_guiCreateContainer(global.guiBaseContainerSideLeft, o_stash_inventory_left))
        event_user(0);
}
//instance_destroy(inventoryCategories);
else
{
    audio_play_sound(snd_gui_accept_choose_click, 2, 0);
    with (o_stash_inventory_left)
    {
        closeRightMenu = false;
        event_user(15);
        closeRightMenu = true;
    }
}