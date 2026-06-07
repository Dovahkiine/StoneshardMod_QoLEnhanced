push.v local._gain_xp
pushi.e 1
conv.i.v
push.d 0.25
conv.d.v
pushi.e 1
push.d 0.15
pushloc.v local._lvl
pushi.e 5
conv.i.d
div.d.v
push.v self.Tier
sub.v.v
mul.v.d
sub.v.i
call.i clamp(argc=3)