var _tent2IsOpen = scr_caravanUpgradeIsOpen("Tent2");
var _tent3IsOpen = scr_caravanUpgradeIsOpen("Tent3");
var _incenseIsOpen = scr_caravanUpgradeIsOpen("Incense");
var _herbsIsOpen = scr_caravanUpgradeIsOpen("Herbs");
var _foragingIsOpen = scr_caravanUpgradeIsOpen("Foraging");
var _hungerModifier = 0.75;
var _thirstyModifier = 0.75;
var _intoxicModifier = 1;
var _immunityModifier = (1 * _herbsIsOpen) + (0.5 * _foragingIsOpen * _herbsIsOpen);
var _painModifier = 1;
var _moraleModifier = 1 + _incenseIsOpen;
var _sanityModifier = 1 + _incenseIsOpen;
var _healthModifier = 1 + (0.5 * _herbsIsOpen) + (0.5 * _foragingIsOpen * _herbsIsOpen);
var _bodypartModifier = 1 + (0.5 * _herbsIsOpen) + (0.5 * _foragingIsOpen * _herbsIsOpen);
var _fatigueModifier = 0.5 + (0.5 * _tent2IsOpen) + (0.5 * _tent3IsOpen);
var _sleepModifier = 2;
scr_lifeParamsUpdate(sleepHours, _hungerModifier, _thirstyModifier, _intoxicModifier, _immunityModifier, _painModifier, _moraleModifier, _sanityModifier, _healthModifier, _bodypartModifier, _fatigueModifier, _sleepModifier);

scr_modifier_change(o_player, o_b_fresh, 600 * sleepHours, 7200);

if (_incenseIsOpen && sleepHours > 0)
    scr_psy_negative_states_remove();
