function scr_playerSpritePartsUpdate()
{
    var _nameKey = scr_atr("nameKey");
    var _raceKey = scr_atr("raceKey");
    var _sexKey = scr_atr("sexKey");
    var _rest = scr_is_rest();
    var _twohands = scr_check_twohanded();
    var _qolRightBigWeapon = false;
    var _qolLeftBigWeapon = false;
    var _qolRightBigWeaponType = "";
    var _qolLeftBigWeaponType = "";
    var _qolRightBigWeaponName = "";
    var _qolLeftBigWeaponName = "";
    
    if (instance_exists(o_inv_right_hand))
    {
        var _qolRightChild = o_inv_right_hand.children;
        
        if (instance_exists(_qolRightChild) && variable_instance_exists(_qolRightChild, "qol_big_weapon_sprite") && _qolRightChild.qol_big_weapon_sprite)
        {
            _qolRightBigWeapon = true;
            _qolRightBigWeaponType = variable_instance_exists(_qolRightChild, "type") ? _qolRightChild.type : "";
            _qolRightBigWeaponName = variable_instance_exists(_qolRightChild, "data") ? ds_map_find_value_ext(_qolRightChild.data, "idName", "") : "";
        }
    }
    
    if (instance_exists(o_inv_left_hand))
    {
        var _qolLeftChild = o_inv_left_hand.children;
        
        if (instance_exists(_qolLeftChild) && variable_instance_exists(_qolLeftChild, "qol_big_weapon_sprite") && _qolLeftChild.qol_big_weapon_sprite)
        {
            _qolLeftBigWeapon = true;
            _qolLeftBigWeaponType = variable_instance_exists(_qolLeftChild, "type") ? _qolLeftChild.type : "";
            _qolLeftBigWeaponName = variable_instance_exists(_qolLeftChild, "data") ? ds_map_find_value_ext(_qolLeftChild.data, "idName", "") : "";
        }
    }
    
    var _qolDualBigWeapon = _qolRightBigWeapon && _qolLeftBigWeapon;
    var _backHasBackpack = scr_player_equipped_get(o_inv_backpack_parent, o_inv_back) != -4;
    var _leftHandTorchID = scr_player_equipped_get(o_inv_torches, o_inv_left_hand);
    var _leftHandTorchObjectIndex = (_leftHandTorchID == -4) ? -1 : _leftHandTorchID.object_index;
    var _leftHandHasTorch = _leftHandTorchObjectIndex != -1;
    var _rightHandTorchID = scr_player_equipped_get(o_inv_torches, o_inv_right_hand);
    var _rightHandTorchObjectIndex = (_rightHandTorchID == -4) ? -1 : _rightHandTorchID.object_index;
    var _rightHandHasTorch = _rightHandTorchObjectIndex != -1;
    var _torchClipSpriteIndex = -4;
    var _torchClipImageIndex = 0;
    var _imageNumberX = 1;
    var _imageNumberY = 1;
    
    if (_rightHandHasTorch && !_leftHandHasTorch)
    {
        if (object_is(_rightHandTorchObjectIndex, o_inv_lanterns))
        {
            _torchClipSpriteIndex = s_char_lantern_clip;
            _torchClipImageIndex = 0;
        }
        else
        {
            _torchClipSpriteIndex = s_char_torch_clip;
            _torchClipImageIndex = 0;
        }
    }
    else if (_leftHandHasTorch && !_rightHandHasTorch)
    {
        if (object_is(_leftHandTorchObjectIndex, o_inv_lanterns))
        {
            _torchClipSpriteIndex = s_char_lantern_clip;
            _torchClipImageIndex = 1;
        }
        else
        {
            _torchClipSpriteIndex = s_char_torch_clip;
            _torchClipImageIndex = 1;
        }
    }
    else if (_leftHandHasTorch && _rightHandHasTorch)
    {
        var _rightHandTorchIsLamp = object_is(_rightHandTorchObjectIndex, o_inv_lanterns);
        var _leftHandTorchIsLamp = object_is(_leftHandTorchObjectIndex, o_inv_lanterns);
        _torchClipSpriteIndex = s_char_lantern_torch_clip;
        
        if (!_rightHandTorchIsLamp && !_leftHandTorchIsLamp)
            _torchClipImageIndex = 0;
        else if (_rightHandTorchIsLamp && _leftHandTorchIsLamp)
            _torchClipImageIndex = 1;
        else if (!_rightHandTorchIsLamp && _leftHandTorchIsLamp)
            _torchClipImageIndex = 2;
        else if (_rightHandTorchIsLamp && !_leftHandTorchIsLamp)
            _torchClipImageIndex = 3;
    }
    
    if (global.playerSpriteGround != isGround)
    {
        global.playerSpriteGround = isGround;
        global.playerSpriteUpdate = true;
    }
    
    var _backSpriteIndex = -4;
    var _backMaskSpriteIndex = -4;
    var _backImageIndex = 0;
    var _backUpperSpriteIndex = -4;
    var _backUpperMaskSpriteIndex = -4;
    var _backUpperImageIndex = 0;
    
    with (o_inv_back)
    {
        with (children)
        {
            _backSpriteIndex = char_sprite;
            _backUpperSpriteIndex = char_upper_sprite;
            _backMaskSpriteIndex = char_sprite_mask;
            _backUpperMaskSpriteIndex = char_upper_sprite_mask;
            
            if (_rest)
            {
                _backImageIndex = 1;
                _backUpperImageIndex = 1;
            }
        }
    }
    
    scr_playerSpriteArrayUpdate(1, _backSpriteIndex, _backImageIndex, 0, 0, 0, 0, 0, 0, -4, 0, _backMaskSpriteIndex);
    scr_playerSpriteArrayUpdate(6, _backUpperSpriteIndex, _backUpperImageIndex, 0, 0, 0, 0, 0, 0, -4, 0, _backUpperMaskSpriteIndex);
    var _bodySpriteIndex = global.playerSpriteBody;
    var _bodyMaskSpriteIndex = global.playerSpriteBodyMask;
    var _bodyImageIndex = 0;
    var _bodyClipSpriteIndex = -4;
    var _bodyClipImageIndex = 0;
    
    if (_rest)
    {
        _bodyImageIndex = 2;
    }
    else if (_twohands)
    {
        _bodyImageIndex = 1;
    }
    else
    {
        _bodyClipSpriteIndex = _torchClipSpriteIndex;
        _bodyClipImageIndex = _torchClipImageIndex;
    }
    
    global.playerSpriteBodyIndex = _bodyImageIndex;
    scr_playerSpriteArrayUpdate(2, _bodySpriteIndex, _bodyImageIndex, 0, 0, 0, 0, 0, 0, _bodyClipSpriteIndex, _bodyClipImageIndex, _bodyMaskSpriteIndex);
    var _bootsSpriteIndex = -4;
    var _bootsMaskSpriteIndex = -4;
    var _bootsImageIndex = 0;
    
    with (o_inv_boots)
    {
        with (children)
        {
            _bootsSpriteIndex = char_sprite;
            _bootsMaskSpriteIndex = char_sprite_mask;
            
            if (_rest)
                _bootsImageIndex = 1;
        }
    }
    
    scr_playerSpriteArrayUpdate(3, _bootsSpriteIndex, _bootsImageIndex, 0, 0, 0, 0, 0, 0, -4, 0, _bootsMaskSpriteIndex);
    var _armorSpriteIndex = -4;
    var _armorMaskSpriteIndex = -4;
    var _armorImageIndex = 0;
    var _armorClipSpriteIndex = -4;
    var _armorClipImageIndex = 0;
    var _armorClipOffsetTop = 0;
    
    with (o_inv_armor)
    {
        with (children)
        {
            _armorSpriteIndex = char_sprite;
            _armorMaskSpriteIndex = char_sprite_mask;
            
            if (_rest)
            {
                _armorImageIndex = 2;
            }
            else if (_twohands)
            {
                _armorImageIndex = 1;
            }
            else
            {
                _armorClipSpriteIndex = _torchClipSpriteIndex;
                _armorClipImageIndex = _torchClipImageIndex;
            }
            
            if (!_backHasBackpack && global.playerSpritePartsArray[6][0] != -4)
                _armorClipOffsetTop = _rest ? 29 : 25;
        }
    }
    
    scr_playerSpriteArrayUpdate(4, _armorSpriteIndex, _armorImageIndex, 0, 0, 0, _armorClipOffsetTop, 0, 0, _armorClipSpriteIndex, _armorClipImageIndex, _armorMaskSpriteIndex);
    var _beltSpriteIndex = -4;
    var _beltImageIndex = 0;
    var _beltOffsetX = 0;
    var _beltOffsetY = 0;
    var _beltLampID = -4;
    var _beltChildrenID = -4;
    
    with (o_inv_belt)
    {
        _beltLampID = scr_lamp_attach_to_belt_get();
        _beltChildrenID = children;
        
        if (global.playerSpriteGround != -1 && _beltLampID != -4 && !_beltLampID.select)
            _beltSpriteIndex = s_char_belt_empty;
        
        if (_rest)
        {
            _beltOffsetX = 4;
            _beltOffsetY = 1;
        }
    }
    
    scr_playerSpriteArrayUpdate(5, _beltSpriteIndex, _beltImageIndex);
    
    if (scr_playerSpriteArrayIsUpdated(5))
    {
        with (o_inv_belt)
        {
            children = _beltLampID;
            scr_playerObjectEffectsUpdate(o_inv_belt, _beltSpriteIndex, _beltImageIndex, _beltOffsetX, _beltOffsetY);
            children = _beltChildrenID;
        }
    }
    
    var _gloveRightSpriteIndex = -4;
    var _gloveRightMaskSpriteIndex = -4;
    var _gloveRightImageIndex = 0;
    var _gloveLeftSpriteIndex = -4;
    var _gloveLeftMaskSpriteIndex = -4;
    var _gloveLeftImageIndex = 0;
    var _gloveRightTorchSpriteIndex = -4;
    var _gloveRightTorchMaskSpriteIndex = -4;
    var _gloveRightTorchImageIndex = 0;
    var _gloveLeftTorchSpriteIndex = -4;
    var _gloveLeftTorchMaskSpriteIndex = -4;
    var _gloveLeftTorchImageIndex = 0;
    var _gloveLeftTorchOffsetX = 0;
    
    with (o_inv_gloves)
    {
        with (children)
        {
            if (_rest)
            {
                _gloveRightSpriteIndex = char_sprite;
                _gloveRightMaskSpriteIndex = char_sprite_mask;
                _gloveRightImageIndex = 3;
            }
            else if (_twohands)
            {
                _gloveRightSpriteIndex = char_sprite;
                _gloveRightMaskSpriteIndex = char_sprite_mask;
                _gloveRightImageIndex = 2;
            }
            else
            {
                if (_leftHandHasTorch)
                {
                    _gloveLeftTorchSpriteIndex = char_sprite;
                    _gloveLeftTorchMaskSpriteIndex = char_sprite_mask;
                    
                    if (object_is(_leftHandTorchObjectIndex, o_inv_torch))
                        _gloveLeftTorchImageIndex = 4;
                    else if (object_is(_leftHandTorchObjectIndex, o_inv_candelabrum))
                        _gloveLeftTorchImageIndex = 6;
                    else if (object_is(_leftHandTorchObjectIndex, o_inv_copper_candelabrum))
                        _gloveLeftTorchImageIndex = 8;
                    else if (object_is(_leftHandTorchObjectIndex, o_inv_lanterns))
                        _gloveLeftTorchImageIndex = 10;
                    
                    if (_sexKey == "Female")
                        _gloveLeftTorchOffsetX = -1;
                }
                else
                {
                    _gloveLeftSpriteIndex = char_sprite;
                    _gloveLeftMaskSpriteIndex = char_sprite_mask;
                    _gloveLeftImageIndex = 0;
                }
                
                if (_rightHandHasTorch)
                {
                    _gloveRightTorchSpriteIndex = char_sprite;
                    _gloveRightTorchMaskSpriteIndex = char_sprite_mask;
                    
                    if (object_is(_rightHandTorchObjectIndex, o_inv_torch))
                        _gloveRightTorchImageIndex = 5;
                    else if (object_is(_rightHandTorchObjectIndex, o_inv_candelabrum))
                        _gloveRightTorchImageIndex = 7;
                    else if (object_is(_rightHandTorchObjectIndex, o_inv_copper_candelabrum))
                        _gloveRightTorchImageIndex = 9;
                    else if (object_is(_rightHandTorchObjectIndex, o_inv_lanterns))
                        _gloveRightTorchImageIndex = 11;
                }
                else
                {
                    _gloveRightSpriteIndex = char_sprite;
                    _gloveRightMaskSpriteIndex = char_sprite_mask;
                    _gloveRightImageIndex = 1;
                }
            }
        }
    }
    
    scr_playerSpriteArrayUpdate(8, _gloveRightSpriteIndex, _gloveRightImageIndex, 0, 0, 0, 0, 0, 0, -4, 0, _gloveRightMaskSpriteIndex);
    scr_playerSpriteArrayUpdate(17, _gloveRightTorchSpriteIndex, _gloveRightTorchImageIndex, 0, 0, 0, 0, 0, 0, -4, 0, _gloveRightTorchMaskSpriteIndex);
    scr_playerSpriteArrayUpdate(7, _gloveLeftSpriteIndex, _gloveLeftImageIndex, 0, 0, 0, 0, 0, 0, -4, 0, _gloveLeftMaskSpriteIndex);
    scr_playerSpriteArrayUpdate(16, _gloveLeftTorchSpriteIndex, _gloveLeftTorchImageIndex, _gloveLeftTorchOffsetX, 0, 0, 0, 0, 0, -4, 0, _gloveLeftTorchMaskSpriteIndex);
    var _headSpriteIndex = s_empty;
    var _headImageIndex = 0;
    var _headOffsetX = 0;
    var _headOffsetY = 0;
    var _headClipOffsetLeft = 0;
    var _headClipOffsetBottom = 0;
    var _helmetSpriteIndex = -4;
    var _helmetMaskSpriteIndex = -4;
    var _helmetImageIndex = 0;
    var _helmetOffsetX = 0;
    var _helmetOffsetY = 0;
    
    with (o_inv_head)
    {
        with (children)
        {
            _helmetSpriteIndex = char_sprite;
            _helmetMaskSpriteIndex = char_sprite_mask;
            _helmetImageIndex = i_index_shift * 2;
            
            if (isOpen == 0)
            {
                if (ds_map_find_value_ext(data, "idName", "N/A") == "Visoreal Cervellier")
                    _headClipOffsetLeft = 10;
                
                _headClipOffsetBottom = -13;
            }
            
            if (_rest)
                _helmetImageIndex = _helmetImageIndex + 1;
            
            if (_raceKey == "Dwarf")
                _helmetOffsetY += (_rest ? 0 : 1);
        }
    }
    
    if (_rest)
    {
        if (_sexKey == "Female")
        {
            _headOffsetX += 3;
            _headOffsetY += 5;
        }
        else
        {
            _headOffsetX += 2;
            _headOffsetY += 4;
        }
        
        if (_nameKey == "Leosthenes")
            _headOffsetY += 1;
        else if (_nameKey == "Hilda")
            _headOffsetX -= 1;
    }
    
    if (_headSpriteIndex != -4)
    {
        var _maxHP = math_round((max_hp * Health_Threshold) / 100);
        var _percentHP = HP / _maxHP;
        _imageNumberY = sprite_get_number(_headSpriteIndex);
        
        if (_percentHP > 0.3)
            _headSpriteIndex = (_helmetSpriteIndex == -4) ? global.playerSpriteHeadNormalArray[0] : global.playerSpriteHeadNormalArray[1];
        else
            _headSpriteIndex = (_helmetSpriteIndex == -4) ? global.playerSpriteHeadBloodArray[0] : global.playerSpriteHeadBloodArray[1];
    }
    
    scr_playerSpriteArrayUpdate(11, _headSpriteIndex, _headImageIndex, _headOffsetX, _headOffsetY, _headClipOffsetLeft, 0, 0, _headClipOffsetBottom);
    scr_playerSpriteArrayUpdate(12, _helmetSpriteIndex, _helmetImageIndex, _helmetOffsetX, _helmetOffsetY, 0, 0, 0, 0, -4, 0, _helmetMaskSpriteIndex);
    var _rightHandSpriteIndex = -4;
    var _rightHandMaskSpriteIndex = -4;
    var _rightHandImageIndex = 0;
    var _rightHandOffsetX = 0;
    var _rightHandOffsetY = 0;
    var _rightHandWeaponType = -4;
    var _rightHandAngle = 0;
    var _rightHandXScale = 1;
    
    with (o_inv_right_hand)
    {
        with (children)
        {
            if (global.playerSpriteGround != -1)
            {
                if (_rest)
                {
                    if (sprite_get_number(char_sprite) >= 4)
                    {
                        _rightHandSpriteIndex = char_sprite;
                        _rightHandMaskSpriteIndex = char_sprite_mask;
                        _rightHandImageIndex = 3;
                    }
                }
                else
                {
                    _rightHandSpriteIndex = char_sprite;
                    _rightHandMaskSpriteIndex = char_sprite_mask;
                    _rightHandImageIndex = 1;
                }
            }
            
            if (_rightHandSpriteIndex != -4)
            {
                if (object_index == o_inv_net)
                    _rightHandWeaponType = 0;
                else if (type == "shield")
                    _rightHandWeaponType = 1;
                else
                    _rightHandWeaponType = 2;
                
                if (type == "crossbow")
                    _rightHandImageIndex = (scr_crossbow_is_armed(o_inv_right_hand) == 1) ? 0 : 1;
            }
        }
    }
    
    switch (_rightHandWeaponType)
    {
        case 0:
            scr_playerSpriteArrayUpdate(9, _rightHandSpriteIndex, _rightHandImageIndex, _rightHandOffsetX, _rightHandOffsetY, 0, 0, 0, 0, -4, 0, _rightHandMaskSpriteIndex);
            scr_playerSpriteArrayUpdate(0, -4, 0);
            scr_playerSpriteArrayUpdate(13, -4, 0);
            break;
        
        case 1:
            scr_playerSpriteArrayUpdate(9, -4, 0);
            scr_playerSpriteArrayUpdate(0, _rightHandSpriteIndex, _rightHandImageIndex, _rightHandOffsetX, _rightHandOffsetY, 0, 0, 0, 0, -4, 0, _rightHandMaskSpriteIndex);
            scr_playerSpriteArrayUpdate(13, -4, 0);
            break;
        
        case 2:
            scr_playerSpriteArrayUpdate(9, -4, 0);
            scr_playerSpriteArrayUpdate(0, -4, 0);
            
            if (_qolRightBigWeapon && _rightHandWeaponType == 2)
            {
                var _qolRightOffsetX = -10.5;
                var _qolRightOffsetY = 0.5;
                var _qolRightAngle = -15;
                var _qolRightXScale = -1;
                
                switch (_qolRightBigWeaponType)
                {
                    case "2hsword":
                        _qolRightOffsetX = -9;
                        break;
                    
                    case "2haxe":
                        _qolRightOffsetX = -9;
                        break;
                    
                    case "2hmace":
                        _qolRightOffsetX = -9;
                        _qolRightOffsetY = 0.5;
                        break;
                    
                    case "2hStaff":
                        break;
                    
                    case "crossbow":
                        _qolRightOffsetX = -6.5;
                        _qolRightOffsetY = 3.5;
                        _qolRightAngle = 0;
                        _qolRightXScale = 1;
                        break;
                    
                    case "spear":
                        _qolRightOffsetX = -2;
                        _qolRightOffsetY = 2.5;
                        _qolRightXScale = 1;
                        _qolRightAngle = -15;
                        break;
                    
                    default:
                        switch (_qolRightBigWeaponName)
                        {
                            case "Pickaxe":
                            case "Broom":
                            case "Shackles":
                                break;
                            
                            default:
                        }
                        
                        break;
                }
                
                _rightHandOffsetX += _qolRightOffsetX;
                _rightHandOffsetY += _qolRightOffsetY;
                _rightHandAngle += _qolRightAngle;
                _rightHandXScale = _qolRightXScale;
            }
            
            scr_playerSpriteArrayUpdate(13, _rightHandSpriteIndex, _rightHandImageIndex, _rightHandOffsetX, _rightHandOffsetY, 0, 0, 0, 0, -4, 0, _rightHandMaskSpriteIndex, _rightHandAngle, _rightHandXScale);
            break;
        
        default:
            scr_playerSpriteArrayUpdate(9, -4, 0);
            scr_playerSpriteArrayUpdate(0, -4, 0);
            scr_playerSpriteArrayUpdate(13, -4, 0);
            break;
    }
    
    if (scr_playerSpriteArrayIsUpdated(13) || scr_playerSpriteArrayIsUpdated(0) || scr_playerSpriteArrayIsUpdated(9))
    {
        scr_playerObjectEffectsUpdate(o_inv_right_hand, _rightHandSpriteIndex, _rightHandImageIndex, _rightHandOffsetX, _rightHandOffsetY);
        scr_playerSpriteEffectsUpdate(o_inv_right_hand, _rightHandSpriteIndex, _rightHandImageIndex, _rightHandOffsetX, _rightHandOffsetY);
    }
    
    var _leftHandSpriteIndex = -4;
    var _leftHandMaskSpriteIndex = -4;
    var _leftHandImageIndex = 0;
    var _leftHandOffsetX = 0;
    var _leftHandOffsetY = 0;
    var _leftHandWeaponType = -4;
    var _leftHandAngle = 0;
    var _leftHandXScale = 1;
    
    with (o_inv_left_hand)
    {
        with (children)
        {
            if (global.playerSpriteGround != -1)
            {
                if (_rest)
                {
                    if (sprite_get_number(char_sprite) >= 4)
                    {
                        _leftHandSpriteIndex = char_sprite;
                        _leftHandMaskSpriteIndex = char_sprite_mask;
                        _leftHandImageIndex = 2;
                    }
                }
                else
                {
                    _leftHandSpriteIndex = char_sprite;
                    _leftHandMaskSpriteIndex = char_sprite_mask;
                    _leftHandImageIndex = 0;
                }
            }
            
            if (_leftHandSpriteIndex != -4)
            {
                if (object_index == o_inv_net)
                {
                    _leftHandWeaponType = 0;
                }
                else if (type == "shield")
                {
                    _leftHandWeaponType = 1;
                    
                    if (_sexKey == "Female")
                    {
                        _leftHandOffsetX = 1;
                        _leftHandOffsetY = 1;
                    }
                }
                else
                {
                    _leftHandWeaponType = 2;
                }
                
                if (_leftHandHasTorch && _sexKey == "Female")
                    _leftHandOffsetX = -1;
                
                if (type == "crossbow")
                    _leftHandImageIndex = (scr_crossbow_is_armed(o_inv_left_hand) == 1) ? 0 : 1;
            }
        }
    }
    
    switch (_leftHandWeaponType)
    {
        case 0:
            scr_playerSpriteArrayUpdate(10, _leftHandSpriteIndex, _leftHandImageIndex, _leftHandOffsetX, _leftHandOffsetY, 0, 0, 0, 0, -4, 0, _leftHandMaskSpriteIndex);
            scr_playerSpriteArrayUpdate(15, -4, 0);
            scr_playerSpriteArrayUpdate(14, -4, 0);
            break;
        
        case 1:
            scr_playerSpriteArrayUpdate(10, -4, 0);
            scr_playerSpriteArrayUpdate(15, _leftHandSpriteIndex, _leftHandImageIndex, _leftHandOffsetX, _leftHandOffsetY, 0, 0, 0, 0, -4, 0, _leftHandMaskSpriteIndex);
            scr_playerSpriteArrayUpdate(14, -4, 0);
            break;
        
        case 2:
            scr_playerSpriteArrayUpdate(10, -4, 0);
            scr_playerSpriteArrayUpdate(15, -4, 0);
            
            if (_qolLeftBigWeapon && _leftHandWeaponType == 2)
            {
                var _qolLeftOffsetX = 11.5;
                var _qolLeftOffsetY = 1;
                var _qolLeftAngle = 60;
                var _qolLeftXScale = -1;
                
                switch (_qolLeftBigWeaponType)
                {
                    case "2hsword":
                        _qolLeftOffsetY -= 1;
                        break;
                    
                    case "2haxe":
                        _qolLeftOffsetY -= 1;
                        break;
                    
                    case "2hmace":
                        _qolLeftOffsetX -= 0.5;
                        _qolLeftOffsetY -= 1;
                        break;
                    
                    case "2hStaff":
                        break;
                    
                    case "crossbow":
                        _qolLeftOffsetX = 9.5;
                        _qolLeftOffsetY = 1.5;
                        _qolLeftAngle = 0;
                        _qolLeftXScale = 1;
                        break;
                    
                    case "spear":
                        _qolLeftOffsetX = 0.5;
                        _qolLeftOffsetY = 0;
                        _qolLeftAngle = 0;
                        _qolLeftXScale = 1;
                        break;
                    
                    default:
                        switch (_qolLeftBigWeaponName)
                        {
                            case "Pickaxe":
                            case "Broom":
                            case "Shackles":
                                break;
                            
                            default:
                        }
                        
                        break;
                }
                
                _leftHandOffsetX += _qolLeftOffsetX;
                _leftHandOffsetY += _qolLeftOffsetY;
                _leftHandAngle += _qolLeftAngle;
                _leftHandXScale = _qolLeftXScale;
            }
            
            scr_playerSpriteArrayUpdate(14, _leftHandSpriteIndex, _leftHandImageIndex, _leftHandOffsetX, _leftHandOffsetY, 0, 0, 0, 0, -4, 0, _leftHandMaskSpriteIndex, _leftHandAngle, _leftHandXScale);
            break;
        
        default:
            scr_playerSpriteArrayUpdate(10, -4, 0);
            scr_playerSpriteArrayUpdate(15, -4, 0);
            scr_playerSpriteArrayUpdate(14, -4, 0);
            break;
    }
    
    if (scr_playerSpriteArrayIsUpdated(14) || scr_playerSpriteArrayIsUpdated(15) || scr_playerSpriteArrayIsUpdated(10))
    {
        scr_playerObjectEffectsUpdate(o_inv_left_hand, _leftHandSpriteIndex, _leftHandImageIndex, _leftHandOffsetX, _leftHandOffsetY);
        scr_playerSpriteEffectsUpdate(o_inv_left_hand, _leftHandSpriteIndex, _leftHandImageIndex, _leftHandOffsetX, _leftHandOffsetY);
    }
    
    if (_qolRightBigWeapon && _rightHandWeaponType == 2 && _gloveRightSpriteIndex != -4)
        scr_playerSpriteArrayUpdate(18, _gloveRightSpriteIndex, _gloveRightImageIndex, 0, 0, 0, 0, 0, 0, -4, 0, _gloveRightMaskSpriteIndex);
    else
        scr_playerSpriteArrayUpdate(18, -4, 0);
    
    if (_qolLeftBigWeapon && _leftHandWeaponType == 2 && _gloveLeftSpriteIndex != -4)
        scr_playerSpriteArrayUpdate(19, _gloveLeftSpriteIndex, _gloveLeftImageIndex, 0, 0, 0, 0, 0, 0, -4, 0, _gloveLeftMaskSpriteIndex);
    else
        scr_playerSpriteArrayUpdate(19, -4, 0);
    
    global.playerSpriteImageNumberX = _imageNumberX;
    global.playerSpriteImageNumberY = _imageNumberY;
}
