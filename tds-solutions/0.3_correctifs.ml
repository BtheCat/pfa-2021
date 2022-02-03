let addition =
  let add x y = x+y in
  add (add (add 1 2) 3) (add 4 (add 5 6))

let target = 123456789
let tegrat = 987654321

let checknumber = function
| n when n=target -> true
| n when n=tegrat -> true
| _ -> false

(* ou bien : let checknumber n = (n=target || n=tegrat) *)

let default d o =
  match o with
  | Some v -> v
  | None -> d

(* Solution de base *)
let rec is_sorted = function
| [] -> true
| [a] -> true
| a :: b :: l -> a < b && is_sorted (b::l)

(* Ou mieux : *)
let rec is_sorted = function
| a :: ((b :: _) as bl) -> a < b && is_sorted bl
| _ -> true


let rec reduce add zero = function
  | [] -> zero
  | [a] -> a
  | a :: bs -> add a (reduce add zero bs)

let combine choices f = List.flatten (List.map f choices)
let all_addition l n =
  combine l (fun x ->
    combine l (fun y ->
      if x + y <= n && x<>y then [(x,y)] else []
    ))

