structure ArgParse =
struct
  type result =
    { values : string StringMap.map,
      flags  : string StringMap.map  (* flag -> true *)
    }

  fun empty () : result =
    { values = StringMap.empty,
      flags  = StringMap.empty }

  fun parse (args : string list) : result option =
    let
      fun isKey (s : string) : bool =
        String.size s > 0 andalso String.sub (s, 0) = #"-"

      fun loop (res, []) = SOME res
        | loop (res, arg :: rest) =
            if isKey arg
            then
              let
                val key = String.extract (arg, 1, NONE)
              in
                if key = "" then NONE
                else
                  case rest of
                    next :: rest' =>
                      if String.size next > 0 andalso String.sub (next, 0) <> #"-"
                      then
                        (* у ключа есть значение: -key value *)
                        let
                          val values = StringMap.insert (#values res, key, next)
                        in
                          loop ({ values = values, flags = #flags res }, rest')
                        end
                      else
                        (* нет значения или следующее тоже -key: это флаг -key *)
                        let
                          val flags = StringMap.insert (#flags res, key, "true")
                        in
                          loop ({ values = #values res, flags = flags }, rest)
                        end
                  | [] =>
                      (* флаг без значения, последний в списке *)
                      let
                        val flags = StringMap.insert (#flags res, key, "true")
                      in
                        loop ({ values = #values res, flags = flags }, [])
                      end
              end
            else
              NONE
    in
      loop (empty (), args)
    end
end