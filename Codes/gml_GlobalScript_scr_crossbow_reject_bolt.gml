// 退回所有已装填的十字弩弹药（双手版本）
function scr_crossbow_reject_bolt()
{
    var _bolts = [];

    with (o_inv_weapon_slot)
    {
        var _children = children;
        with (_children)
        {
            if (haveAmmunitionSlot)
            {
                var _bolt = scr_inv_atr("bolt");

                if (!__is_undefined(_bolt))
                {
                    scr_inv_atr_set("bolt", "");
                    array_push(_bolts, __asset_get_index(_bolt));
                }
            }
        }
    }

    var _bolt_count = array_length(_bolts);
    if (_bolt_count == 0)
        return;

    with (o_player)
    {
        scr_guiAnimation(s_gui_anim_crossbow_discharge, 1, 1, false);
        scr_audio_play_at(snd_crossbow_discharge);
    }

    for (var i = 0; i < _bolt_count; i++)
    {
        with (scr_guiCreateInteractive(global.guiBaseContainerVisible, _bolts[i]))
        {
            owner = o_inventory.id;
            stack = 1;
            event_user(2);
            event_perform(ev_alarm, 0);
            var _check_inventory = true;

            if (instance_exists(o_container_quiver))
                _check_inventory = false;

            if (!scr_inventory_stack(o_inventory.id, id, true, _check_inventory, true))
                event_user(15);
        }
    }

    scr_allturn();
}
