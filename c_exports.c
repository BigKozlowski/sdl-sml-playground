#include <stdlib.h>
#include <SDL2/SDL.h>

int c_mult(int a, int b) {
	return a * b;
}

int c_puts(char * str) {
	return puts(str);
}

#include <SDL2/SDL.h>

int sdl_init (void) {
  return SDL_Init(SDL_INIT_VIDEO) == 0 ? 0 : -1;
}

void sdl_quit (void) {
  SDL_Quit();
}

SDL_Window *sdl_create_window (const char *title, int w, int h) {
  return SDL_CreateWindow(
    title,
    SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED,
    w, h,
    SDL_WINDOW_SHOWN
  );
}

void sdl_destroy_window (SDL_Window *win) {
  SDL_DestroyWindow(win);
}

int sdl_poll_event (SDL_Event *ev) {
  return SDL_PollEvent(ev);
}

int sdl_get_event_type (SDL_Event *ev) {
  return ev->type;
}

int sdl_quit_event (SDL_Event *ev) {
  return ev->type == SDL_QUIT ? 1 : 0;
}

void sdl_delay (int ms) {
  SDL_Delay(ms);
}

SDL_Event *sdl_event_new (void) {
  return (SDL_Event *) malloc (sizeof(SDL_Event));
}

void sdl_event_free (SDL_Event *ev) {
  free (ev);
}

SDL_Scancode sdl_get_key_scancode (SDL_Event *ev) {
  if (ev->type == SDL_KEYDOWN)
    return ev->key.keysym.scancode;
  return SDL_SCANCODE_UNKNOWN;
}

SDL_Keycode sdl_get_key_keycode (SDL_Event *ev) {
  if (ev->type == SDL_KEYDOWN)
    return ev->key.keysym.sym;
  return 0;
}

void sdl_print_key_down (SDL_Event *ev) {
  if (ev->type == SDL_KEYDOWN) {
    SDL_Keycode k = ev->key.keysym.sym;
    SDL_Scancode s = ev->key.keysym.scancode;
    const char *keyname = SDL_GetKeyName(k);
    printf("KEYDOWN: key=%d, scancode=%d", (int) k, (int) s);
    if (keyname)
      printf(" (\"%s\")", keyname);
    printf("\n");
  }
}