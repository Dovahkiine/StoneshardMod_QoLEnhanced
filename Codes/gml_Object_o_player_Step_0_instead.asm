pop.v.v self.max_xp
pushloc.v local._lvl
pushi.e 4
cmp.i.v LT
bf [lvlbelow4]

:[lvlisbelow4]
pushi.e 150
pushloc.v local._lvl
pushi.e 150
mul.i.v
add.v.i
pop.v.v self.max_xp

:[lvlbelow4]
pushloc.v local._lvl
pushi.e 4
cmp.i.v GTE
bf [lvlis4]

:[lvlbelow10]
pushloc.v local._lvl
pushi.e 10
cmp.i.v LT
b [lvlis10]

:[lvlis4]
push.e 0

:[lvlis10]
bf [jump5]

:[lvlover10]
pushi.e 300
pushloc.v local._lvl
pushi.e 200
mul.i.v
add.v.i
pop.v.v self.max_xp

:[jump5]
pushloc.v local._lvl
pushi.e 100
cmp.i.v EQ
bf [49]