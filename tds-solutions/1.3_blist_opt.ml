type 'a tree =
  | Leaf of 'a
  | Node of 'a tree * 'a tree
module Tree = struct
(*
let rec size = function
  | Leaf _ -> 1
  | Node (g,d) -> size g + size d
*)
let rec tolist =  function
  | Leaf x -> [x]
  | Node (g,d) -> tolist g @ tolist d
end

type 'a blist = (int*'a tree) list

let tolist bl =
  List.fold_right (fun (_,t) acc -> Tree.tolist t @ acc) bl []

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

let fromlist l =
  List.fold_right cons l []
