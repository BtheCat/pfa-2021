module type RALIST = sig
 type 'a t (* the type of our random-access lists *)
 val empty : 'a t (* an empty random-access list *)
 val length : 'a t -> int (* how many elements in this list ? *)
 val cons : 'a -> 'a t -> 'a t (* add an extra element on the left *)
 val decons : 'a t -> 'a * 'a t (* leftmost element and rest *)
 val nth : 'a t -> int -> 'a (* access to the n-th element in the list *)
end

module QBList : RALIST = struct

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

type 'a t = 'a sized_tree list

let empty = []

let length l = List.fold_left (fun n st -> n + st.size) 0 l


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

(* decons. Constant cost *)

let decons = function
  | {tree=Node(x,Leaf,Leaf)} :: l -> (x,l)
  | {tree=Node(x,t1,t2); size=s} :: l ->
     (x,{tree=t1; size=s/2}::{tree=t2; size=s/2}::l)
  | _ -> raise Not_found

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

end
