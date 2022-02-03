module type DEQUE = sig
 type 'a t
 val empty : 'a t
 val is_empty : 'a t -> bool
 val cons : 'a -> 'a t -> 'a t (* inserts a front element *)
 val snoc : 'a t -> 'a -> 'a t (* inserts a rear element *)
 val decons : 'a t -> 'a * 'a t (* extracts the front element or raises Not_found *)
 val snoced : 'a t -> 'a t * 'a (* extracts the rear element or raises Not_found *)
end
module Deque : DEQUE = struct
type 'a t = int * 'a list * 'a list (* length, front, rear *)

let empty = (0,[],[])
let is_empty (len,_,_) = (len=0)
let cons x (len,front,rear) = (len+1, x::front, rear)
let snoc (len,front,rear) x = (len+1, front, x::rear)

(* Split a list l (of size >= n) into l1++l2, with length l1 = n *)
let rec cut n l = match n, l with
  | 0, _ | _, [] -> [],l
  | _, x::l' -> let (l1,l2) = cut (n-1) l' in (x::l1,l2)

let decons (len,front,rear) =
  match front with
  | x::front' -> x, (len-1, front', rear)
  | [] ->
    let reartop, rearbottom = cut (len/2) rear in
    match List.rev rearbottom with
    | x::newfront -> x, (len-1, newfront, reartop)
    | [] -> raise Not_found

let snoced (len,front,rear) =
  match rear with
  | x::rear' -> (len-1, front, rear'), x
  | [] ->
    let fronttop, frontbottom = cut (len/2) front in
    match List.rev frontbottom with
    | x::newrear -> (len-1, fronttop, newrear), x
    | [] -> raise Not_found
end
