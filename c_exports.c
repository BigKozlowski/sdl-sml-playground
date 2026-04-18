#include <stdlib.h>
#include <SDL2/SDL.h>

int c_mult(int a, int b) {
	return a * b;
}

int c_puts(char * str) {
	return puts(str);
}

SDL_Renderer *g_rend = NULL;

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

int create_renderer (SDL_Window *win) {
  g_rend = SDL_CreateRenderer(win, -1, 0);
  return g_rend ? 0 : -1;
}

void clear_renderer (void) {
  SDL_SetRenderDrawColor(g_rend, 0x00, 0x00, 0x00, 0xFF);  // чёрный
  SDL_RenderClear(g_rend);
}

void fill_rect (int x, int y, int w, int h, Uint8 r, Uint8 g, Uint8 b) {
  SDL_Rect rect = {x, y, w, h};
  SDL_SetRenderDrawColor(g_rend, r, g, b, 0xFF);
  SDL_RenderFillRect(g_rend, &rect);
}

void present_renderer (void) {
  SDL_RenderPresent(g_rend);
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

Uint32 get_sdlk_up   (void) { return SDLK_UP; }
Uint32 get_sdlk_down (void) { return SDLK_DOWN; }
Uint32 get_sdlk_left (void) { return SDLK_LEFT; }
Uint32 get_sdlk_right(void) { return SDLK_RIGHT; }