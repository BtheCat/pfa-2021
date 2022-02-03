module type RALIST = sig
 type 'a t (* the type of our random-access lists *)
 val empty : 'a t (* an empty random-access list *)
 val length : 'a t -> int (* how many elements in this list ? *)
 val cons : 'a -> 'a t -> 'a t (* add an extra element on the left *)
 val decons : 'a t -> 'a * 'a t (* leftmost element and rest *)
 val nth : 'a t -> int -> 'a (* access to the n-th element in the list *)
end

module Basic : RALIST = struct

type 'a t = 'a list

let empty = []

let length = List.length

let cons x l = x::l

let decons = function
| [] -> raise Not_found
| x::l -> (x,l)

let nth l n =
  try List.nth l n
  with _ -> raise Not_found

end

module FastLen : RALIST = struct

type 'a t = int * 'a list

let empty = (0,[])

let length = fst

let cons x (n,l) = (n+1,x::l)

let decons = function
| (_,[]) -> raise Not_found
| (n,x::l) -> (x,(n-1,l))

let nth l n =
  try List.nth (snd l) n
  with _ -> raise Not_found

end

module OptimizeLen (M:RALIST) : RALIST = struct

type 'a t = int * 'a M.t

let empty = (0,M.empty)

let length = fst

let cons x (n,l) = (n+1,M.cons x l)

let decons (n,l) =
  let (x,l) = M.decons l in
  (x,(n-1,l))

let nth l n =
  try M.nth (snd l) n
  with _ -> raise Not_found

end

