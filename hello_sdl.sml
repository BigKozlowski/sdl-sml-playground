(* val rawArgs = CommandLine.arguments ()

val resOpt = ArgParse.parse rawArgs

val { values, flags } =
  case resOpt of
    SOME r => r
  | NONE =>
      (print "Bad command line\n";
       OS.Process.exit OS.Process.failure)


val verbose = StringMap.find (flags, "verbose") = SOME "true"
val port    = 
  case StringMap.find (values, "port") of
    SOME s => (valOf (Int.fromString s) handle _ => 8080)
    | NONE => 8080



val name = CommandLine.name()
val args = CommandLine.arguments()

val _ = print ("Verbose: " ^ (Bool.toString verbose) ^ " Port: " ^ (Int.toString port) ^ "\n") *)
val _ = Sml_sdl.main()