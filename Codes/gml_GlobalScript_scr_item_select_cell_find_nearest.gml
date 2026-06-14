function scr_item_select_cell_find_nearest(argument0, argument1)
{
    var _cell = -4;
    
    // 原版逻辑先用 scr_findNearestInstanceDepthExt() 从鼠标中心点查找
    // o_inventory_cells_container。这个深度查询适合普通 GUI 点击，但不适合拖拽物品：
    // 拖拽期间物品本体、选中高亮、底部面板等 GUI 实例都可能位于格子容器前方。
    // 一旦最前方命中的对象不是格子容器，原函数会直接停止搜索，导致 select_cell_id
    // 在某些帧保持 -4，于是放置高亮闪烁，甚至第二次拖拽后几乎无法放下。
    //
    // 这里改为只扫描当前可交互的左右库存窗口，直接按坐标判断鼠标是否落入它们的
    // o_inventory_cells_container 范围。这样放置判定不再受前景装饰层、拖拽物品层、
    // 选中高亮层影响，同时仍保留原版后续的格子尺寸、可见性、边界计算逻辑。
    var _meetingCenterX = argument0 + (sprite_width / 2);
    var _meetingCenterY = argument1 + (sprite_height / 2);
    var _containerOnMouse = -4;
    var _leftOwners = scr_inventory_get_left_all();
    var _rightOwners = scr_inventory_get_right_all();
    
    // 直接扫描格子容器实例，而不是先从库存窗口反查 itemsContainer。
    // 原因是不同库存窗口/容器对象的内部变量命名不完全可靠；但所有实际可放置格子的
    // 父容器都是 o_inventory_cells_container，并且它们的 owner 字段稳定指向库存窗口。
    // 因此用 owner 白名单过滤，比依赖每个窗口都暴露 itemsContainer 更稳。
    with (o_inventory_cells_container)
    {
        // 不在 with 内使用 exit/continue：这些控制语句在 GML 的 with 作用域里容易
        // 直接结束外层脚本/函数，不能当作“跳过当前容器”的安全写法。
        // 因此所有过滤条件都用 if 包住，确保某个不合格容器不会中断整次扫描。
        if (_containerOnMouse == -4)
        {
            var _ownerAllowed = false;
            
            for (var _i = 0; _i < array_length(_leftOwners); _i++)
                _ownerAllowed = _ownerAllowed || owner == _leftOwners[_i];
            
            for (var _i = 0; _i < array_length(_rightOwners); _i++)
                _ownerAllowed = _ownerAllowed || owner == _rightOwners[_i];
            
            if (_ownerAllowed)
            {
                // o_inventory_cells_container 的 sprite 是 s_point，实际命中范围来自
                // image_xscale/image_yscale，它们在 scr_inventory_container_cells_add()
                // 里被设置为 guiWidth/guiHeight。这里使用 bbox/碰撞检测之外的显式矩形，
                // 是为了避免被其他 GUI 实例深度遮挡影响。
                //
                // 不要在这里检查容器自身 visible。原版 scr_inventory_container_cells_add()
                // 默认 arg3=false，会让格子容器经 scr_guiVisibleUpdate(id, false) 后处于
                // visible=false，但原版后续仍允许 cell.visible || !cell.guiVisibility 的格子
                // 被作为放置目标。若在容器层提前用 visible 过滤，会导致所有普通背包格子
                // 都被跳过，表现为拖拽物品完全无法放下。
                var _left = x;
                var _top = y;
                var _right = x + image_xscale - 1;
                var _bottom = y + image_yscale - 1;
                
                if (scr_isInBoundsPoint(_meetingCenterX, _meetingCenterY, _left, _top, _right, _bottom))
                    _containerOnMouse = id;
            }
        }
    }
    
    if (_containerOnMouse != -4)
    {
        var _containerOwner = _containerOnMouse.owner;
        var _containerIndex = _containerOnMouse.index;
        var _containerSize = scr_inventory_container_get_size(_containerOwner, _containerIndex);
        var _cellContainerColumns = _containerSize[0];
        var _cellContainerRows = _containerSize[1];
        
        if (_cellContainerColumns >= cells_x && _cellContainerRows >= cells_y)
        {
            var _cellTopLeft = scr_inventory_container_get_cell_by_coords(_containerOwner, _containerIndex, 0, 0);
            var _cellTargetColumn = clamp(math_round((argument0 - _cellTopLeft.x) / 27), 0, _cellContainerColumns - cells_x);
            var _cellTargetRow = clamp(math_round((argument1 - _cellTopLeft.y) / 27), 0, _cellContainerRows - cells_y);
            var _cellTarget = scr_inventory_container_get_cell_by_coords(_containerOwner, _containerIndex, _cellTargetColumn, _cellTargetRow);
            var _cellsAreVisible = false;
            
            for (var _c = 0; _c < cells_x; _c++)
            {
                for (var _r = 0; _r < cells_y; _r++)
                {
                    with (scr_inventory_container_get_cell_by_coords(_containerOwner, _containerIndex, _cellTargetColumn + _c, _cellTargetRow + _r))
                        _cellsAreVisible = visible || !guiVisibility;
                    
                    if (_cellsAreVisible)
                    {
                        _cell = _cellTarget;
                        break;
                    }
                }
                
                if (_cellsAreVisible)
                    break;
            }
        }
    }
    
    return _cell;
}
