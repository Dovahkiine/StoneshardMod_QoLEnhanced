function scr_playerSpriteInit()
{
    var _bodySpriteName = scr_atr("BodySprite");
    var _headSpriteName = scr_atr("Head");
    global.playerSpriteBody = sprite_get_index(_bodySpriteName);
    global.playerSpriteBodyMask = sprite_get_index(_bodySpriteName + "_mask");
    global.playerSpriteBodyIndex = 0;
    global.playerSpriteHeadNormalArray = [sprite_get_index(_headSpriteName + "_normal"), sprite_get_index(_headSpriteName + "_helmet_normal")];
    global.playerSpriteHeadBloodArray = [sprite_get_index(_headSpriteName + "_blood"), sprite_get_index(_headSpriteName + "_helmet_blood")];
    global.playerSpriteGround = -4;
    global.playerSpriteImageNumberX = 0;
    global.playerSpriteImageNumberY = 0;
    global.playerSpriteArray = [-4, -4, -4, -4];
    global.playerSpriteSpeed = 0;
    global.playerSpriteIndex = 0;
    global.playerSpriteUpdate = false;
    global.playerSpritePartsArray = [];
    global.playerSpritePartsArrayHeight = 20;

    for (var _i = 0; _i < global.playerSpritePartsArrayHeight; _i++)
    {
        global.playerSpritePartsArray[_i][0] = -4;
        global.playerSpritePartsArray[_i][1] = 0;
        global.playerSpritePartsArray[_i][2] = 0;
        global.playerSpritePartsArray[_i][3] = 0;
        global.playerSpritePartsArray[_i][4] = 0;
        global.playerSpritePartsArray[_i][5] = 0;
        global.playerSpritePartsArray[_i][6] = 0;
        global.playerSpritePartsArray[_i][7] = 0;
        global.playerSpritePartsArray[_i][9] = -4;
        global.playerSpritePartsArray[_i][10] = 0;
        global.playerSpritePartsArray[_i][11] = -4;

        switch (_i)
        {
            case 1:
            case 2:
            case 4:
            case 6:
            case 3:
                global.playerSpritePartsArray[_i][12] = make_color_rgb(32, 0, 0);
                break;

            case 11:
            case 12:
                global.playerSpritePartsArray[_i][12] = make_color_rgb(64, 0, 0);
                break;

            case 7:
            case 8:
            case 16:
            case 17:
                global.playerSpritePartsArray[_i][12] = make_color_rgb(0, 32, 0);
                break;

            case 15:
            case 0:
            case 14:
            case 13:
            case 10:
            case 9:
            case 18:
            case 19:
                global.playerSpritePartsArray[_i][12] = make_color_rgb(0, 64, 0);
                break;
        }

        global.playerSpritePartsArray[_i][13] = false;
        global.playerSpritePartsArray[_i][14] = false;
    }

    __show_debug_message("[PLAYER SPRITE] Init");
}
