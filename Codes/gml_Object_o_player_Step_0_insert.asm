call.i gml_Script_scr_is_cutscene(argc=0)
conv.v.b
not.b
bf [1016]

:[1012]
call.i gml_Script_is_allow_actions(argc=0)
conv.v.b
bf [1016]

:[1013]
push.v self.auto_move
conv.v.b
bf [1016]

:[1014]
push.s "pathfinder_dest"
conv.s.v
call.i variable_global_exists(argc=1)
conv.v.b
bf [1016]

:[1015]
pushglb.v global.pathfinder_dest
pushi.e -4
cmp.i.v NEQ
b [1017]

:[1016]
push.e 0

:[1017]
bf [end]

:[1018]
pushi.e 0
pop.v.b self.auto_move
pushi.e -5
pushi.e 1
push.v [array]global.pathfinder_dest
pushi.e -5
pushi.e 0
push.v [array]global.pathfinder_dest
call.i gml_Script__scr_auto_move_to_transition(argc=2)
popz.v