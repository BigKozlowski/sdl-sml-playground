structure SDL =
struct
  type window   = MLton.Pointer.t
  type event    = MLton.Pointer.t
  type uint32   = Word32.word
  type scancode = Word32.word
  type keycode  = Word32.word

  val init =
    _import "sdl_init"
      private: unit -> int;

  val quit =
    _import "sdl_quit"
      private: unit -> unit;

  val createWindow =
    _import "sdl_create_window"
      private: string * int * int -> window;

  val destroyWindow =
    _import "sdl_destroy_window"
      private: window -> unit;

  val pollEvent =
    _import "sdl_poll_event"
      private: event -> int;  (* 0 = no event, 1 = event *)

  val getEventType =
    _import "sdl_get_event_type"
      private: event -> uint32;

  val isQuit =
    _import "sdl_quit_event"
      private: event -> int;  (* 1 = quit, 0 = not quit *)

  val delay =
    _import "sdl_delay"
      private: int -> unit;

  val mallocEvent =
    _import "sdl_event_new"
      private: unit -> MLton.Pointer.t;

  val freeEvent =
    _import "sdl_event_free"
      private: MLton.Pointer.t -> unit;

  val getKeyScancode =
    _import "sdl_get_key_scancode"
      private: event -> scancode;

  val getKeykeycode =
    _import "sdl_get_key_keycode"
      private: event -> keycode;

  val print_key_down =
    _import "sdl_print_key_down"
      private: event -> unit;

  val create_renderer =
    _import "create_renderer"
      private: MLton.Pointer.t -> int;

  val clear_renderer =
    _import "clear_renderer"
      private: unit -> unit;

  val fill_rect =
    _import "fill_rect"
      private: int * int * int * int * int * int * int -> unit;

  val present_renderer =
    _import "present_renderer"
      private: unit -> unit;

  val get_sdlk_up =
    _import "get_sdlk_up": unit -> keycode;

  val get_sdlk_down =
    _import "get_sdlk_down": unit -> keycode;

  val get_sdlk_left =
    _import "get_sdlk_left": unit -> keycode;

  val get_sdlk_right =
    _import "get_sdlk_right": unit -> keycode;

  (* SDL_QuitEvent type code *)
  val SDL_QUIT : uint32 = 0wx2401
  val SDL_KEYDOWN : uint32 = 0wx300
  val SDL_KEYUP : uint32 = 0wx301
  val SDLK_UP   = get_sdlk_up   () : keycode
  val SDLK_DOWN = get_sdlk_down () : keycode
  val SDLK_LEFT = get_sdlk_left () : keycode
  val SDLK_RIGHT= get_sdlk_right() : keycode

end