UNAME_S := $(shell uname -s)

SDL_CFLAGS := $(shell pkg-config --cflags sdl2)
SDL_LIBS   := $(shell pkg-config --libs sdl2)

ifeq ($(UNAME_S),Linux)
    OPENGL_CFLAGS := $(shell pkg-config --cflags gl glu glut)
    OPENGL_LIBS   := $(shell pkg-config --libs gl glu glut)
endif

ifeq ($(UNAME_S),Darwin)
    OPENGL_CFLAGS :=
    OPENGL_LIBS   := -framework OpenGL
endif

SML_FILES := $(wildcard *.sml) $(wildcard *.sig)

.PHONY: clean all run show-flags

all: hello_sdl

hello_sdl: hello_sdl.mlb c_exports.c $(SML_FILES)
	mlton -default-ann 'allowFFI true' \
	    -cc-opt '$(SDL_CFLAGS) $(OPENGL_CFLAGS)' \
	    -link-opt '$(SDL_LIBS) $(OPENGL_LIBS)' \
	    hello_sdl.mlb c_exports.c

show-flags:
	@echo "OS: $(UNAME_S)"
	@echo "SDL_CFLAGS: $(SDL_CFLAGS)"
	@echo "SDL_LIBS: $(SDL_LIBS)"
	@echo "OPENGL_LIBS: $(OPENGL_LIBS)"

run: hello_sdl
	./hello_sdl

lib: 
	mlton -default-ann 'allowFFI true' -format library -libname test test.sml

opengl_test: opengl_test.c
	gcc `pkg-config --cflags sdl2` opengl_test.c -framework OpenGL -framework Cocoa -framework IOKit -framework CoreVideo `sdl2-config --libs`

clean:
	rm -f hello_sdl