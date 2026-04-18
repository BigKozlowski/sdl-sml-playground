structure Sml_sdl = struct
  fun main () : unit =
    if SDL.init () <> 0
    then print "SDL init failed.\n"
    else
      let
        val win =
          SDL.createWindow ("MLton SDL2 Event Loop", 640, 480)
          handle _ => (
            print "SDL_CreateWindow failed.\n";
            OS.Process.exit OS.Process.failure
          )

        val _ = case SDL.create_renderer win of
                  0 => ()
                | _ => (
                    print "SDL_CreateRenderer failed.\n";
                    OS.Process.exit OS.Process.failure
                  )

        val x0 = 100
        val y0 = 100
        val sz = 200

        fun renderFrame (x, y) : unit =
          let
            val _ = SDL.clear_renderer ()
            val _ = SDL.fill_rect (x, y, sz, sz, 255, 0, 0)  (* красный *)
            val _ = SDL.present_renderer ()
          in
            ()
          end

        fun moveKey (code : SDL.keycode, x, y) : int * int =
          (print (Word32.toString code);
          print "\n";
          if code = SDL.SDLK_UP
          then (x, Int.max (y - 10, 0))
          else if code = SDL.SDLK_DOWN
          then (x, Int.min (y + 10, 480 - sz))
          else if code = SDL.SDLK_LEFT
          then (Int.max (x - 10, 0), y)
          else if code = SDL.SDLK_RIGHT
          then (Int.min (x + 10, 640 - sz), y)
          else (x, y))

        fun pollEvents (x, y) : int * int =
          let
            val ev  = SDL.mallocEvent ()
            val got = SDL.pollEvent ev
          in
            if got = 0
            then (
              SDL.freeEvent ev;
              (x, y)
            )
            else
              let
                val t = SDL.getEventType ev
                val k = SDL.getKeykeycode ev
                val _ = SDL.freeEvent ev
                val _ = print (Int.toString(Word.toInt t))
                val _ = print "\n"
              in
                if t = SDL.SDL_QUIT orelse SDL.isQuit ev <> 0
                then (
                  renderFrame (x, y);
                  print "Quit event.\n";
                  OS.Process.exit OS.Process.success
                )
                else if t = SDL.SDL_KEYDOWN
                then
                  let
                    val (x', y') = moveKey (k, x, y)
                  in
                    (* print "KEYDOWN: "; SDL.print_key_down ev; print "\n"; *)
                    pollEvents (x', y')
                  end
                else (
                  (* SDL.print_key_down ev; *)
                  pollEvents (x, y)
                )
              end
          end

        fun gameLoop (x, y) =
          let
            val _ = SDL.delay 16
            val (x', y') = pollEvents (x, y)
            (* val _ = print ("POS: " ^ Int.toString x' ^ ", " ^ Int.toString y' ^ "\n") *)
            val _ = renderFrame (x', y')
          in
            gameLoop (x', y')
          end
      in
        renderFrame (x0, y0);
        gameLoop (x0, y0);
        SDL.destroyWindow win;
        SDL.quit ()
      end
end