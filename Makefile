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

.PHONY: clean all run show-flags

all: hello_sdl

hello_sdl: hello_sdl.mlb c_exports.c
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

clean:
	rm -f hello_sdl