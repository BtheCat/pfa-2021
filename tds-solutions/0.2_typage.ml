(* Q1 : Prévoir les types et valeurs des phrases suivantes *)

let phrase1 = fun x -> x + 1
(* val phrase1 : int->int = <fun> *)

let phrase2 = fun x -> (x, x)
(* val phrase2 : 'a -> 'a * 'a = <fun> *)

let phrase3 = fun x y -> Some (x, y)
(* val phrase3 : 'a -> 'b -> ('a * 'b) option = <fun> *)

let phrase4 = (fun x y -> x*(x+y)) 2 3
(* val phrase4 : int = 10 *)

let phrase5 = (fun x y -> x*(x+y)) 2
(* val phrase5 : int -> int = <fun> *)

let phrase6 = (fun x -> (x, x)) 0
(* val phrase6 : int*int = (0,0) *)

let phrase7 = (fun x y -> (x, y)) 0 1
(* val phrase7 : int*int = (0,1) *)

let phrase8 = (fun x y -> (x, y)) 0
(* val phrase8 : 'a -> int*'a = <fun> *)

let phrase9 = fun f x y -> f y x
(* val phrase9 : ('a -> 'b -> 'c) -> 'b -> 'a -> 'c = <fun> *)

let phrase10 = List.map (fun x -> x*x) [1; 2; 3]
(* val phrase10 : int list = [1;4;9] *)

let phrase11 = List.map (fun x y -> x*y) [1; 2; 3]
(* val phrase11 : (int->int) list = [<fun>;<fun>;<fun>] *)

(* Q2 : Trouver des phrases ayant les types demandés *)

(* int*int -> int*int *)
let phrase12 = fun (x,y) -> (x+1,y+1)

(* (int -> int) -> (int -> int) *)
let phrase13 = fun f x -> 1+f (x+1)

(* (int -> int) -> int *)
let phrase14 = fun f -> f 0

(* ('a -> 'b) -> ('b -> 'c) -> ('a -> 'c) *)
let phrase15 = fun f g x -> g (f x)
