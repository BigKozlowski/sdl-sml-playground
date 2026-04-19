SDL_CFLAGS=$(pkg-config --cflags sdl2)
SDL_LIBS=$(pkg-config --libs sdl2)

echo "SDL_CFLAGS: $SDL_CFLAGS"
echo "SDL_LIBS: $SDL_LIBS"

mlton -default-ann 'allowFFI true' \
    -cc-opt "$SDL_CFLAGS" -link-opt "$SDL_LIBS" \
    hello_sdl.mlb c_exports.c