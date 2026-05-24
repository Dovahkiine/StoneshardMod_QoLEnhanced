function _scr_call_method(argument0, argument1)
{
    if (argument1 == undefined)
        argument1 = [];

    var _fn = argument0;
    var _args = argument1;

    if (is_method(_fn))
    {
        with (method_get_self(_fn))
        {
            return script_execute_ext(method_get_index(_fn), _args);
        }
    }

    return script_execute_ext(_fn, _args);
}
