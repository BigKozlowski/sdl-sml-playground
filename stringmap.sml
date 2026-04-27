structure StringOrdKey = struct
  type ord_key = string
  val compare = String.compare
end

structure StringMap = BinaryMapFn (StringOrdKey)