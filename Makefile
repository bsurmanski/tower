SRC=src/*.d src/lua/*.d src/lua/lib/*.d /usr/local/include/d/gl/glb/*.d /usr/local/include/d/c/*.d
INC=-I/usr/local/include/d -Isrc

dmd:
	dmd $(SRC) -L-lglfw -L-lGL -L-llua -L-lglb $(INC) -g -debug -unittest -odbuild -ofa.out

ldc:
	ldc2 $(SRC) -L-lglfw -L-lGL -L-llua -L-lglb $(INC) -g  -unittest -od=build -of=a.out

gdc:
	gdc $(SRC) -lglfw -lGL -lglb -llua $(INC) -g -funittest

