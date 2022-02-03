type 'a tree =
  | Leaf of 'a
  | Node of 'a tree * 'a tree

type 'a blist = ('a tree) list
module Tree = struct
let rec size = function
  | Leaf _ -> 1
  | Node (g,d) -> size g + size d

let rec tolist =  function
  | Leaf x -> [x]
  | Node (g,d) -> tolist g @ tolist d
end

let empty = []

let undeuxtrois = [Leaf 1; Node (Leaf 2, Leaf 3)]

let unasix =
  [ Node (Leaf 1, Leaf 2);
    Node (Node (Leaf 3, Leaf 4),
          Node (Leaf 5, Leaf 6))]

let tolist bl =
  List.fold_right (fun t acc -> Tree.tolist t @ acc) bl []

(* invariant : t est de taille <= aux arbres dans bl *)
let rec constree t bl =
  match bl with
  | [] -> [t]
  | t'::bl' ->
     if Tree.size t < Tree.size t' then t::bl
     else constree (Node (t,t')) bl'

let cons x bl = constree (Leaf x) bl

(* invariant : t est de taille < aux arbres dans bl *)
let rec deconstree t bl =
  match t with
  | Leaf x -> (x,bl)
  | Node (g,d) -> deconstree g (d::bl)

let decons = function
| [] -> raise Not_found
| t::bl -> deconstree t bl

(* invariant : 0 <= n < Tree.size t *)
let rec nthtree t n =
  match t with
  | Leaf x -> x (* n=0 obligatoirement ici *)
  | Node (g,d) ->
     let k = Tree.size g in
     if n < k then nthtree g n else nthtree d (n-k)

let rec nth bl n =
  match bl with
  | [] -> raise Not_found
  | t::bl ->
     let k = Tree.size t in
     if 0 <= n && n < k then nthtree t n else nth bl (n-k)

let fromlist l =
  List.fold_right cons l []
