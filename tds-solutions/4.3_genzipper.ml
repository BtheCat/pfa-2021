type 'a stack = 'a list
type 'a listzipper = 'a stack * 'a list
exception Zipper

type 'a narbre =
  | Feuille of 'a
  | Noeud of 'a narbre list

type 'a nblock = 'a narbre listzipper
type 'a npath = 'a nblock list
type 'a narbrezipper = 'a npath * 'a narbre

let en_bas = function
  | ctx, Noeud (a::arbres) -> ([],arbres)::ctx, a
  | _ -> raise Zipper

let en_haut = function
  | (lg,ld)::ctx, a -> ctx, Noeud (List.rev_append lg (a::ld))
  | _ -> raise Zipper

let a_gauche = function
  | (a::lg,ld)::ctx, a' -> (lg,a'::ld)::ctx, a
  | _ -> raise Zipper

let a_droite = function
  | (lg,a::ld)::ctx, a' -> (a'::lg,ld)::ctx, a
  | _ -> raise Zipper

let exemple =
  Noeud [Feuille 5;
         Noeud [Feuille 3; Feuille 9];
         Noeud [Feuille 2; Feuille 8; Feuille 7; Feuille 1]]

let zipper = ([],exemple) |> en_bas |> a_droite
(* Correspond au noeud parent de 3 et 9 *)

let exemplebis = match zipper |> a_droite |> en_bas |> a_droite with
| p, (Feuille 8 as f) -> (p, Noeud [f]) |> en_haut |> en_haut |> snd
| _ -> assert false

