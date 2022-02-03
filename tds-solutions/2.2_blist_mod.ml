module type RALIST = sig
 type 'a t (* the type of our random-access lists *)
 val empty : 'a t (* an empty random-access list *)
 val length : 'a t -> int (* how many elements in this list ? *)
 val cons : 'a -> 'a t -> 'a t (* add an extra element on the left *)
 val decons : 'a t -> 'a * 'a t (* leftmost element and rest *)
 val nth : 'a t -> int -> 'a (* access to the n-th element in the list *)
end

module type RALIST_MAP = sig
 include RALIST
 val map : ('a -> 'b) -> 'a t -> 'b t
end

module BList : RALIST_MAP = struct

type 'a tree =
  | Leaf of 'a
  | Node of 'a tree * 'a tree

type 'a t = (int*'a tree) list

let empty = []

let length l = List.fold_left (fun n (m,_) -> n+m) 0 l

(* invariant : t est de taille n, et <= aux arbres dans bl *)
let rec constree n t bl =
  match bl with
  | [] -> [(n,t)]
  | (n',t')::bl' ->
     if n < n' then (n,t)::bl
     else constree (2*n) (Node (t,t')) bl'

let cons x bl = constree 1 (Leaf x) bl

(* invariant : t est de taille n, et < aux arbres dans bl *)
let rec deconstree n t bl =
  match t with
  | Leaf x -> (x,bl)
  | Node (g,d) -> deconstree (n/2) g ((n/2, d)::bl)

let decons = function
| [] -> raise Not_found
| (n,t)::bl -> deconstree n t bl

(* invariant : 0 <= n < size (qui est Tree.size t) *)
let rec nthtree size t n =
  match t with
  | Leaf x -> x (* n=0 obligatoirement ici *)
  | Node (g,d) ->
     let k = size/2 in
     if n < k then nthtree k g n else nthtree k d (n-k)

let rec nth bl n =
  match bl with
  | [] -> raise Not_found
  | (size,t)::bl ->
     if 0 <= n && n < size then nthtree size t n else nth bl (n-size)

let rec treemap f = function
  | Leaf x -> Leaf (f x)
  | Node (g,d) -> Node (treemap f g, treemap f d)

let rec map f = function
  | [] -> []
  | (size,t)::l -> (size,treemap f t)::map f l

end

let rec map f l =
  try
    let (x,l') = BList.decons l in
    BList.cons (f x) (map f l')
  with Not_found -> BList.empty

module GenMap (M:RALIST) = struct
  let rec map f l =
  try
    let (x,l') = M.decons l in
    M.cons (f x) (map f l')
  with Not_found -> M.empty
end

module BListMap = GenMap(BList)
