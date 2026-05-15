if (!variable_instance_exists(global, "time_active")) {
    global.time_active = false; 
}

global.time_active = !global.time_active;
var _msg = global.time_active ? "时间显示：开启" : "时间显示：关闭";
scr_actionsLogUpdate(_msg);
