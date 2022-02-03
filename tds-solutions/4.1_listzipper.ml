type 'a stack = 'a list
type 'a listzipper = 'a stack * 'a list
exception Zipper
let exemple = [1;2;4;5]

let agauche = function
  | ([],l) -> raise Zipper
  | (x::stk,l) -> (stk,x::l)

let adroite = function
  | (stk,[]) -> raise Zipper
  | (stk,x::l) -> (x::stk,l)

let add x (stk,l) = (stk,x::l)

let remove = function
  | (stk,_::l) -> (stk,l)
  | z -> z

let exemplebis =
  ([],exemple) |> adroite |> adroite |> add 3 |> agauche |> agauche |> snd

(* NB: (x |> f) c'est (f x) *)

let z_to_list (pile,liste) = List.rev_append pile liste
