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

                fun eventLoop () : unit =
                    let
                    val ev  = SDL.mallocEvent ()
                    val got = SDL.pollEvent ev
                    in
                    if got = 0
                    then (SDL.delay 16; SDL.freeEvent ev; eventLoop ())
                    else
                        let
                            val t = SDL.getEventType ev
                        in
                            if t = SDL.SDL_QUIT orelse SDL.isQuit ev <> 0
                            then SDL.freeEvent ev
                            else
                                if t = SDL.SDL_KEYDOWN
                                then (SDL.print_key_down ev; SDL.freeEvent ev; eventLoop ())
                                else (SDL.freeEvent ev; eventLoop ())
                        end
                    end
            in
                eventLoop ();
                SDL.destroyWindow win;
                SDL.quit ()
            end
end
