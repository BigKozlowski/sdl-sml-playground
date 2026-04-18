signature STRING_MAP =
sig
  type 'a map
  val empty : 'a map
  val isEmpty : 'a map -> bool
  val insert : 'a map * string * 'a -> 'a map
  val find : 'a map * string -> 'a option
end

structure StringMap : STRING_MAP =
struct
  type 'a map = (string * 'a) list

  val empty : 'a map = []

  fun isEmpty [] = true
    | isEmpty _  = false

  fun insert (m, key, value) =
    (key, value) :: List.filter (fn (k, _) => k <> key) m

  fun find (m, key) =
    case List.find (fn (k, _) => k = key) m of
      SOME (_, v) => SOME v
    | NONE        => NONE
end