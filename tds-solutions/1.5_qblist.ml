(* Unlike blists, in qblists we want to store 2^k-1 elements per
   tree, so we put data at the nodes and not at the leaves.
   The value at the root node is the head of the qblist, then
   comes the values in the left sub-tree, then the right sub-tree. *)

type 'a tree =
  | Leaf
  | Node of 'a * 'a tree * 'a tree

(* A tree with its number of nodes (to avoid recomputing it).
   We could also have used ('a tree * int) *)
type 'a sized_tree = { tree : 'a tree; size : int }

type 'a qblist = 'a sized_tree list

let empty = []

let example =
  [ { tree = Node(5,Leaf,Leaf); size = 1};
    { tree = Node(17,Leaf,Leaf); size = 1};
    { tree = Node(42,Node(127,Leaf,Leaf),Node(73,Leaf,Leaf)); size = 3 } ]

(* Optional: Conversion from qblist to regular list *)

let rec tree_to_list = function
  | Leaf -> []
  | Node (x,t1,t2) -> x :: tree_to_list t1 @ tree_to_list t2

let rec tolist = function
  | [] -> []
  | t::l -> tree_to_list t.tree @ tolist l

let _ = tolist example

(* Optional: Check whether the desired invariants of qblists are indeed ok.
   We first compute the size of a tree while checking it is perfect. *)

exception Unbalanced

let rec perfect_size = function
  | Leaf -> 0
  | Node (_,t1,t2) ->
     let s1 = perfect_size t1 and s2 = perfect_size t2 in
     if s1 = s2 then 1+s1+s2 else raise Unbalanced

let check_qblist l =
  (* minstep is used to check that the sizes are strictly increasing,
     except at the beginning where the same size could appear twice *)
  let rec check minstep minsize = function
  | [] -> true
  | t::l ->
     perfect_size t.tree = t.size && minsize <= t.size &&
     check 1 (t.size + minstep) l
  in
  try check 0 1 l with Unbalanced -> false

let _ = check_qblist example

(**************************************************************************)
(* cons *)

(* Regroup two sized trees. The resulting tree is perfect when
   the input trees have the same size. *)
let node x t1 t2 =
  { tree = Node (x,t1.tree,t2.tree); size = 1 + t1.size + t2.size }

let leaf = { tree = Leaf; size = 0 }

(* Insert an element into a qblist. Constant cost *)
let cons x = function
  | t1::t2::l when t1.size = t2.size -> (node x t1 t2)::l
  | l -> (node x leaf leaf)::l

let _ = cons 1 example
let _ = cons 1 (cons 2 example)
let _ = check_qblist (cons 1 (cons 2 example))

(* From a regular list to qblist: we iterate cons. Cost: O(n) *)
let fromlist l = List.fold_right cons l []

let _ = (fromlist (tolist example) = example)

(**************************************************************************)
(* decons. Constant cost *)

let decons = function
  | {tree=Node(x,Leaf,Leaf)} :: l -> (x,l)
  | {tree=Node(x,t1,t2); size=s} :: l ->
     (x,{tree=t1; size=s/2}::{tree=t2; size=s/2}::l)
  | _ -> raise Not_found

let _ = decons example
let _ = decons (snd (decons (snd (decons example))))

(***************************************************************************)
(* n-th *)

(* n-th element of tree t of size s. *)
let rec nth_tree t s n = match t with
  | Leaf -> raise Not_found
  | Node(x,_,_) when n = 0 -> x
  | Node(_,t1,_) when n-1 < s/2 -> nth_tree t1 (s/2) (n-1)
  | Node(_,_,t2) -> nth_tree t2 (s/2) (n-1-s/2)

(* n-th element of a qblist. Logarithmic cost *)

let rec nth l n = match l with
  | [] -> raise Not_found
  | t :: rest ->
     if n < t.size
     then nth_tree t.tree t.size n
     else nth rest (n-t.size)

(*
let _ = nth example 0
let _ = nth example 3
let _ = nth example 17
 *)

(***************************************************************************)

(* update_nth *)

(* update_nth n x l create a copy of l where x is now at the n-th position.
   The code is the same as nth, except that we now return a qblist. *)

let rec update_nth_tree t s n x = match t with
  | Leaf -> raise Not_found
  | Node(_,t1,t2) when n = 0 -> Node(x,t1,t2)
  | Node(y,t1,t2) when n-1 < s/2 -> Node(y,update_nth_tree t1 (s/2) (n-1) x, t2)
  | Node(y,t1,t2) -> Node(y,t1,update_nth_tree t2 (s/2) (n-1-s/2) x)

let rec update_nth l n x = match l with
  | [] -> raise Not_found
  | t :: rest ->
     if n < t.size
     then { tree = update_nth_tree t.tree t.size n x; size = t.size} :: rest
     else t :: update_nth rest (n-t.size) x

let _ = update_nth example 3 128

(****************************************************************)

(* drop *)

(* drop k t could be done via k repeated decons, but the complexity would
   not be garanteed to be logarithmic as with the code below. *)

(* Drop the k first elements of a tree. Precondition : k < t.size *)
let rec drop_tree k t acc = match t.tree with
  | _ when k <= 0 -> t::acc
  | Leaf -> assert false
  | Node (x,t1,t2) ->
     let size = t.size/2 in
     if k=1 then {tree=t1;size}::{tree=t2;size}::acc
     else if k-1 < size then
       drop_tree (k-1) {tree=t1;size} ({tree=t2;size}::acc)
     else drop_tree (k-1-size) {tree=t2;size} acc

let rec drop k l = match l with
  | _ when k <= 0 -> l
  | [] -> raise Not_found
  | t :: rest ->
       if k < t.size
       then drop_tree k t rest
       else drop (k-t.size) rest

let _ = drop 2 example
