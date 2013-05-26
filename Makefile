SRC=src/main.d \
	src/camera.d \
	src/keys.d\
	src/map.d\
	src/container/geom/mesh.d\
	src/container/geom/model.d\
	src/container/geom/grid.d\
	src/container/list.d\
	src/lua/api.d\
	src/lua/luah.d\
	src/lua/state.d\
	src/lua/table.d\
	src/lua/lib/all.d\
	src/lua/lib/callback.d\
	src/lua/lib/libactor.d\
	src/lua/lib/libentity.d\
	src/lua/lib/libitem.d\
	src/lua/lib/libkey.d\
	src/entity/actor.d\
	src/entity/entity.d\
	src/entity/item.d\
	src/entity/sprite.d\
	src/math/matrix.d\
	src/math/vector.d\
	src/math/bv/box.d\
	src/math/bv/ball.d\
	src/ui/component.d\
	src/ui/glbComponent.d\
	src/ui/imageComponent.d\
	src/ui/hud/hud.d\
	src/ui/hud/itemSelectComponent.d\
	src/ui/hud/healthComponent.d\
	src/ui/hud/wealthComponent.d\
	/usr/local/include/d/gl/glb/*.d \
	/usr/local/include/d/c/*.d

INC=-I/usr/local/include/d \
	-Isrc

dmd:
	dmd $(SRC) -L-lglfw -L-lGL -L-llua -L-lglb $(INC) -g -debug -unittest -odbuild -ofa.out

ldc:
	ldc2 $(SRC) -L-lglfw -L-lGL -L-llua -L-lglb $(INC) -g  -unittest -od=build -of=a.out

gdc:
	gdc $(SRC) -lglfw -lGL -lglb -llua $(INC) -g -funittest

