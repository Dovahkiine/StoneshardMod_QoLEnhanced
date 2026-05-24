function scr_playerSpriteUpdate()
{
    if (!global.playerSpriteUpdate)
        exit;

    var _imageNumberX = global.playerSpriteImageNumberX;
    var _imageNumberY = global.playerSpriteImageNumberY + 1;
    var _spriteWidth = 64;
    var _spriteHeight = 64;
    var _surfaceWidth = _spriteWidth * _imageNumberX;
    var _surfaceHeight = _spriteHeight * _imageNumberY;
    var _surface = surface_create(_surfaceWidth, _surfaceHeight);
    var _premultSurface = surface_create(_surfaceWidth, _surfaceHeight);
    var _surfaceMaskSrc = surface_create(_spriteWidth, _spriteHeight);
    var _surfaceMaskDst = surface_create(_spriteWidth, _spriteHeight);
    var _bodyWidth = sprite_get_width(global.playerSpriteBody);
    var _bodyHeight = sprite_get_height(global.playerSpriteBody);
    var _bodyOffsetX = sprite_get_xoffset(global.playerSpriteBody);
    var _bodyOffsetY = sprite_get_yoffset(global.playerSpriteBody);
    var _differenceWidth = (_spriteWidth - _bodyWidth) / 2;
    var _differenceHeight = (_spriteHeight - _bodyHeight) / 2;
    var _x = _bodyOffsetX + _differenceWidth;
    var _y = _bodyOffsetY + _differenceHeight;
    surface_set_target(_premultSurface);
    gpu_set_blendmode_normal(100);
    draw_clear_alpha(c_black, 0);

    for (var _i = 0; _i < _imageNumberY; _i++)
    {
        for (var _j = 0; _j < global.playerSpritePartsArrayHeight; _j++)
        {
            var _spritePartArray = global.playerSpritePartsArray[_j];
            _spriteIndex = _spritePartArray[0];

            if (_spriteIndex != -4)
            {
                var _imageIndex = _spritePartArray[1];
                var _offsetX = _spritePartArray[2];
                var _offsetY = _spritePartArray[3];
                var _clipOffsetLeft = _spritePartArray[4];
                var _clipOffsetTop = _spritePartArray[5];
                var _clipOffsetRight = _spritePartArray[6];
                var _clipOffsetBottom = _spritePartArray[7];
                var _clipSpriteIndex = _spritePartArray[9];
                var _clipImageIndex = _spritePartArray[10];
                var _maskSpriteIndex = _spritePartArray[11];
                var _maskColor = _spritePartArray[12];
                var _partAngle = 0;
                var _partXScale = 1;

                if (array_length(_spritePartArray) > 15)
                    _partAngle = _spritePartArray[15];

                if (array_length(_spritePartArray) > 16)
                    _partXScale = _spritePartArray[16];

                for (var _k = 0; _k < _imageNumberX; _k++)
                {
                    var _spriteX = _spriteWidth * _k;
                    var _spriteY = _spriteHeight * _i;
                    var _partX = _x + _offsetX + _spriteX;
                    var _partY = _y + _offsetY + _spriteY;
                    var _indexModifier = 0;
                    var _isMask = (_i + 1) == _imageNumberY;

                    if (_j == 11)
                        _indexModifier = _i;
                    else if (_j == 14 || _j == 13 || _j == 15 || _j == 0)
                        _indexModifier = _k;

                    var _partImageIndex = _imageIndex + _indexModifier;
                    var _partClipLeft = _clipOffsetLeft;
                    var _partClipTop = _clipOffsetTop;
                    var _partClipRight = sprite_get_width(_spriteIndex) + _clipOffsetRight;
                    var _partClipBottom = sprite_get_height(_spriteIndex) + _clipOffsetBottom;

                    if (_isMask)
                    {
                        var _partMaskSpriteIndex = (_maskSpriteIndex == -4) ? _spriteIndex : _maskSpriteIndex;
                        var _partMaskColor = (_maskSpriteIndex == -4) ? _maskColor : -1;
                        gpu_set_blendmode_ext(bm_one, bm_zero);
                        surface_set_target(_surfaceMaskDst);
                        draw_clear_alpha(c_black, 0);
                        draw_surface(_premultSurface, 0, 0 - _spriteY);
                        __surface_reset_target();
                        surface_set_target(_surfaceMaskSrc);
                        draw_clear_alpha(c_black, 0);
                        scr_playerSpriteArrayDraw(_partMaskSpriteIndex, _partImageIndex, _partX - _spriteX, _partY - _spriteY, _partMaskColor, _clipSpriteIndex, _clipImageIndex, _partClipLeft, _partClipTop, _partClipRight, _partClipBottom, _partAngle, _partXScale);
                        __surface_reset_target();
                        scr_playerSpriteArrayDrawMask(_spriteX, _spriteY, _surfaceMaskDst, _surfaceMaskSrc);
                        __gpu_set_blendmode(0);
                    }
                    else
                    {
                        scr_playerSpriteArrayDraw(_spriteIndex, _partImageIndex, _partX, _partY, -1, _clipSpriteIndex, _clipImageIndex, _partClipLeft, _partClipTop, _partClipRight, _partClipBottom, _partAngle, _partXScale);
                    }
                }
            }
        }
    }

    gpu_set_blendmode_normal(0);
    __surface_reset_target();
    surface_set_target(_surface);
    gpu_set_blendmode_ext(bm_one, bm_zero);
    draw_clear_alpha(c_black, 0);
    shader_set(shd_unpremultiplyAlpha);

    if (global.playerSpriteGround == -1)
    {
        var _heightTop = ceil(_spriteHeight * 0.55);

        for (var _i = 0; _i < _imageNumberY; _i++)
        {
            var _top = _spriteHeight * _i;
            draw_surface_part(_premultSurface, 0, _top, _surfaceWidth, _heightTop, 0, _top + 13);
        }
    }
    else
    {
        draw_surface(_premultSurface, 0, 0);
    }

    shader_reset();
    __gpu_set_blendmode(0);
    __surface_reset_target();
    scr_playerSpriteDelete();

    for (var _i = 0; _i < _imageNumberY; _i++)
    {
        global.playerSpriteArray[_i] = sprite_create_from_surface(_surface, 0, _spriteHeight * _i, _spriteWidth, _spriteHeight, false, false, _x, _y);

        for (var _j = 1; _j < _imageNumberX; _j++)
            sprite_add_from_surface(global.playerSpriteArray[_i], _surface, _spriteWidth * _j, _spriteHeight * _i, _spriteWidth, _spriteHeight, false, false);
    }

    var _spriteIndex = global.playerSpriteArray[0];
    var _BBoxWidthMax = sprite_get_bbox_right(global.playerSpriteBody) - sprite_get_bbox_left(global.playerSpriteBody);
    var _BBoxHeightMax = sprite_get_bbox_bottom(global.playerSpriteBody) - sprite_get_bbox_top(global.playerSpriteBody);
    var _BBoxOffsetX = _bodyOffsetX - sprite_get_bbox_left(global.playerSpriteBody);
    var _BBoxOffsetY = _bodyOffsetY - sprite_get_bbox_top(global.playerSpriteBody);
    var _BBoxLeft = sprite_get_bbox_left(_spriteIndex);
    var _BBoxTop = sprite_get_bbox_top(_spriteIndex);
    var _BBoxRight = sprite_get_bbox_right(_spriteIndex);
    var _BBoxBottom = sprite_get_bbox_bottom(_spriteIndex);
    var _BBoxWidth = min(_BBoxWidthMax, _BBoxRight - _BBoxLeft);
    var _BBoxHeight = min(_BBoxHeightMax, _BBoxBottom - _BBoxTop);
    _BBoxLeft = max(_BBoxLeft, _x - _BBoxOffsetX);
    _BBoxTop = max(_BBoxTop, _y - _BBoxOffsetY);
    _BBoxRight = _BBoxLeft + _BBoxWidth;
    _BBoxBottom = _BBoxTop + _BBoxHeight;

    for (var _i = 0; _i < _imageNumberY; _i++)
        sprite_collision_mask(global.playerSpriteArray[_i], false, 2, _BBoxLeft, _BBoxTop, _BBoxRight, _BBoxBottom, 1, 0);

    if (_imageNumberY == 2)
    {
        var _maskSpriteIndex = global.playerSpriteArray[1];
        global.playerSpriteArray[1] = global.playerSpriteArray[0];
        global.playerSpriteArray[2] = global.playerSpriteArray[0];
        global.playerSpriteArray[3] = global.playerSpriteArray[0];
        global.playerSpriteArray[4] = _maskSpriteIndex;
    }

    surface_free(_surface);
    surface_free(_premultSurface);
    surface_free(_surfaceMaskSrc);
    surface_free(_surfaceMaskDst);
    global.playerSpriteUpdate = false;
    __show_debug_message("[PLAYER SPRITE] Redraw");
}
