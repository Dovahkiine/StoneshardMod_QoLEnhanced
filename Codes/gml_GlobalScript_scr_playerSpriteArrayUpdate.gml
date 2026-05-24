function scr_playerSpriteArrayUpdate(argument0, argument1, argument2, argument3, argument4, argument5, argument6, argument7, argument8, argument9, argument10, argument11, argument12, argument13)
{
    if (argument3 == undefined) argument3 = 0;
    if (argument4 == undefined) argument4 = 0;
    if (argument5 == undefined) argument5 = 0;
    if (argument6 == undefined) argument6 = 0;
    if (argument7 == undefined) argument7 = 0;
    if (argument8 == undefined) argument8 = 0;
    if (argument9 == undefined) argument9 = -4;
    if (argument10 == undefined) argument10 = 0;
    if (argument11 == undefined) argument11 = -4;
    if (argument12 == undefined) argument12 = 0;
    if (argument13 == undefined) argument13 = 1;

    var _spritePartArray = global.playerSpritePartsArray[argument0];
    var _oldAngle = 0;
    var _oldXScale = 1;

    if (array_length(_spritePartArray) > 15)
        _oldAngle = _spritePartArray[15];

    if (array_length(_spritePartArray) > 16)
        _oldXScale = _spritePartArray[16];

    if (_spritePartArray[14] || _spritePartArray[0] != argument1 || _spritePartArray[1] != argument2 || _spritePartArray[2] != argument3 || _spritePartArray[3] != argument4 || _spritePartArray[4] != argument5 || _spritePartArray[5] != argument6 || _spritePartArray[6] != argument7 || _spritePartArray[7] != argument8 || _spritePartArray[9] != argument9 || _spritePartArray[10] != argument10 || _spritePartArray[11] != argument11 || _oldAngle != argument12 || _oldXScale != argument13)
    {
        _spritePartArray[0] = argument1;
        _spritePartArray[1] = argument2;
        _spritePartArray[2] = argument3;
        _spritePartArray[3] = argument4;
        _spritePartArray[4] = argument5;
        _spritePartArray[5] = argument6;
        _spritePartArray[6] = argument7;
        _spritePartArray[7] = argument8;
        _spritePartArray[9] = argument9;
        _spritePartArray[10] = argument10;
        _spritePartArray[11] = argument11;
        _spritePartArray[15] = argument12;
        _spritePartArray[16] = argument13;
        _spritePartArray[13] = true;
        _spritePartArray[14] = false;
        global.playerSpritePartsArray[argument0] = _spritePartArray;
        global.playerSpriteUpdate = true;
    }
    else
    {
        _spritePartArray[13] = false;
        _spritePartArray[14] = false;
        global.playerSpritePartsArray[argument0] = _spritePartArray;
    }
}
