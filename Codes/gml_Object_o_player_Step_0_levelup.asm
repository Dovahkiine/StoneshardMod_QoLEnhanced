popenv [54]
pushloc.v local._lvl
pushi.e 20
cmp.i.v LT
bf [over20]

:[below20]
push.d 3
conv.d.v
push.s "AP"
conv.s.v
call.i gml_Script_scr_atr_incr(argc=2)
popz.v
push.d 2
conv.d.v
push.s "SP"
conv.s.v
call.i gml_Script_scr_atr_incr(argc=2)
popz.v
b [pushPoints]

:[over20]
push.d 5
conv.d.v
push.s "AP"
conv.s.v
call.i gml_Script_scr_atr_incr(argc=2)
popz.v
push.d 3
conv.d.v
push.s "SP"
conv.s.v
call.i gml_Script_scr_atr_incr(argc=2)
popz.v

:[pushPoints]
push.v self.max_xp
pop.v.v self._oldXp
pushi.e 5735