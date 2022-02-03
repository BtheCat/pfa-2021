
let qb_0 = []
let qb_1 = [1]
let qb_2 = [1;1]
let qb_3 = [3]
let qb_4 = [1;3]
let qb_5 = [1;1;3]
let qb_6 = [3;3]
let qb_7 = [7]
let qb_8 = [1;7]
let qb_9 = [1;1;7]
let qb_10 = [3;7]

let next l = match l with
  | a::b::l' when a=b -> (1+a+b)::l'
  | _ -> 1::l

let prev l = match l with
  | [] -> raise Not_found
  | 1::l' -> l'
  | a::l' -> (a/2)::(a/2)::l'

let rec decomp n =
  if n = 0 then [] else next (decomp (n-1))
