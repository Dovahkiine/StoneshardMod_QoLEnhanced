if ds_exists(guiChildrenList, 2)
    ds_list_destroy(guiChildrenList)
if (instance_exists(target))
    target.__qol_ehb_initialized = false
