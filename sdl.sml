

structure Sml_sdl = struct
    type Keys = { up: bool, down: bool, left: bool, right: bool }
    datatype KeyEvent = PRESS | RELEASE
    val initKeys: Keys = { up = false, down = false, left = false, right = false }
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

        fun handleQuit(code: SDL.keycode): unit =
          if code = SDL.SDLK_Q
          then (OS.Process.exit OS.Process.success)
          else ()

        fun moveKey (keys : Keys, x, y) : int * int =
            let
                val dx = (if #left keys then ~10 else 0) + (if #right keys then 10 else 0)
                val dy = (if #up   keys then ~10 else 0) + (if #down  keys then 10 else 0)
            in
                (Int.max (Int.min (x + dx, 640 - sz), 0),
                Int.max (Int.min (y + dy, 480 - sz), 0))
            end

        fun updateKeys (k, keys : Keys, t) : Keys =
            if t = PRESS
            then
                if k = SDL.SDLK_UP    then { up = true, down = #down keys, left = #left keys, right = #right keys }
                else if k = SDL.SDLK_DOWN  then { up = #up keys, down = true, left = #left keys, right = #right keys }
                else if k = SDL.SDLK_LEFT  then { up = #up keys, down = #down keys, left = true, right = #right keys }
                else if k = SDL.SDLK_RIGHT then { up = #up keys, down = #down keys, left = #left keys, right = true }
                else keys
            else if t = RELEASE
            then
                if k = SDL.SDLK_UP    then { up = false, down = #down keys, left = #left keys, right = #right keys }
                else if k = SDL.SDLK_DOWN  then { up = #up keys, down = false, left = #left keys, right = #right keys }
                else if k = SDL.SDLK_LEFT  then { up = #up keys, down = #down keys, left = false, right = #right keys }
                else if k = SDL.SDLK_RIGHT then { up = #up keys, down = #down keys, left = #left keys, right = false }
                else keys
            else
                keys

        fun pollEvents (keys: Keys, x, y) : Keys =
          let
            val ev  = SDL.mallocEvent ()
            val got = SDL.pollEvent ev
          in
            if got = 0
            then (
              SDL.freeEvent ev;
              keys
            )
            else
              let
                val (t, k, r) = SDL.getEventDetails ev
                val _ = handleQuit k
                val _ = SDL.freeEvent ev
              in
                if t = SDL.SDL_QUIT orelse SDL.isQuit ev <> 0
                then (
                  renderFrame (x, y);
                  print "Quit event.\n";
                  OS.Process.exit OS.Process.success
                )
                else if r <> SDL.SDL_NON_REPEAT
                then keys
                else if t = SDL.SDL_KEYDOWN
                then
                  let
                    val keys' = updateKeys(k, keys, PRESS)
                  in
                    keys'
                  end
                else if t = SDL.SDL_KEYUP
                then
                  let
                    val keys' = updateKeys(k, keys, RELEASE)
                  in
                    keys'
                  end
                else keys   
              end
          end

        fun gameLoop (keys: Keys, x, y) =
          let
            val _ = SDL.delay 16
            val (keys': Keys) = pollEvents (keys, x, y)
            val (x', y') = moveKey (keys, x, y)
            val _ = renderFrame (x', y')
          in
            gameLoop (keys', x', y')
          end
      in
        renderFrame (x0, y0);
        gameLoop (initKeys, x0, y0);
        SDL.destroyWindow win;
        SDL.quit ()
      end
end