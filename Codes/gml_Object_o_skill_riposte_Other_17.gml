event_inherited();

if (instance_exists(owner))
{
    ds_map_replace(data, "PRR", owner.AGL + owner.PRC);
    ds_map_replace(data, "Block_Power", owner.STR);
    ds_map_replace(data, "CTA", 10 + owner.PRC);
    ds_map_replace(text_map, "CTA_Damage", owner.STR + owner.AGL + owner.PRC - 28);
}
