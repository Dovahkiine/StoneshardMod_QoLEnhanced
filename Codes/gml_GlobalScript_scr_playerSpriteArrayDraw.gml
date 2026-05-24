function scr_playerSpriteArrayDraw(argument0, argument1, argument2, argument3, argument4, argument5, argument6, argument7, argument8, argument9, argument10, argument11, argument12)
{
    if (argument4 == undefined) argument4 = -1;
    if (argument5 == undefined) argument5 = -4;
    if (argument6 == undefined) argument6 = 0;
    if (argument11 == undefined) argument11 = 0;
    if (argument12 == undefined) argument12 = 1;

    argument1 = floor(argument1);
    argument6 = floor(argument6);
    argument4 = (argument4 == -1) ? 0 : argument4;
    argument5 = (argument5 == -4) ? s_char_clip_empty : argument5;
    var _uBorders = shader_get_uniform(shd_player_part, "uBorders");
    var _uSpriteUVS = shader_get_uniform(shd_player_part, "uSpriteUVS");
    var _uClipTexture = shader_get_sampler_index(shd_player_part, "uClipTexture");
    var _uClipUVS = shader_get_uniform(shd_player_part, "uClipUVS");
    var _uMaskColorUse = shader_get_uniform(shd_player_part, "uMaskColorUse");
    var _bordersUVS = scr_spriteBordersUVS(argument0, argument1, argument7, argument8, argument9, argument10);
    var _spriteUVS = scr_spriteBordersUVS(argument0, argument1);
    var _clipTexture = sprite_get_texture(argument5, argument6);
    var _clipUVS = scr_spriteBordersUVS(argument5, argument6);
    shader_set(shd_player_part);
    shader_set_uniform_f_array(_uBorders, _bordersUVS);
    shader_set_uniform_f_array(_uSpriteUVS, _spriteUVS);
    texture_set_stage(_uClipTexture, _clipTexture);
    shader_set_uniform_f_array(_uClipUVS, _clipUVS);
    shader_set_uniform_f(_uMaskColorUse, argument4 != 0);
    draw_sprite_ext(argument0, argument1, argument2, argument3, argument12, 1, argument11, argument4, 1);
    shader_reset();
}
