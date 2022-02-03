module type Comparable =
sig
  type t
  val compare: t -> t -> int
end

module type SET =
sig
  type content
  type t
  val empty : t
  val add : content -> t -> t
  val mem : content -> t -> bool
end

module Set :
  (functor (T:Comparable) -> SET) = functor (T:Comparable) ->
struct
  type content = T.t
  type t = content list
  let empty = []
  let rec add x = function
      [] -> [x]
    | h::t as l when T.compare x h = 0 -> l
    | h::t as l when T.compare x h < 0 -> x::l
    | h::t -> h::add x t
  let rec mem x = function
      [] -> false
    | h::t -> (T.compare x h = 0) || (T.compare x h > 0 && mem x t)
end
