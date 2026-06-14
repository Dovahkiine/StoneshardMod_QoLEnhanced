function scr_dungeonHasSecretRoom(argument0)
{
    if (global.forceSecret)
        return 1;
    
    if (argument0.Tier == 1)
        return false;
    
    return true;
}
