type 'a arbre =
| Feuille
| Noeud of 'a * 'a arbre * 'a arbre
type marqueur = Gauche | Droite
type 'a block = marqueur * 'a * 'a arbre
type 'a path = 'a block list
type 'a arbrezipper = 'a path * 'a arbre
exception Zipper
let singleton n = Noeud (n,Feuille,Feuille)
let exemple = Noeud (5,Feuille,Noeud (3,singleton 2,singleton 4))

let bas_a_gauche (pile, arbre) = match arbre with
| Feuille -> raise Zipper
| Noeud (x, t1, t2) -> (Gauche, x, t2)::pile, t1

let bas_a_droite (pile, arbre) = match arbre with
| Feuille -> raise Zipper
| Noeud (x, t1, t2) -> (Droite, x, t1)::pile, t2

let en_haut (pile, arbre) = match pile with
| (Gauche, x, t)::p  -> p, Noeud (x, arbre, t)
| (Droite, x, t)::p -> p, Noeud (x, t, arbre)
| _ -> raise Zipper

let exemplebis =
  let modif1 =
    match ([],exemple) |> bas_a_droite with
    | (stk,Noeud(3,g,d)) -> (stk,Noeud(7,g,d))
    | _ -> assert false
  in
  let (stk,_) = modif1 |> bas_a_droite |> bas_a_gauche in
  (stk,singleton 1) |> en_haut |> en_haut |> en_haut |> snd

let rec z_to_tree = function
  | ([],t) -> t
  | z -> z_to_tree (en_haut z)

let rec infixz acc z = match z with
| _, Noeud _ -> infixz acc (bas_a_gauche z)
| [], Feuille -> List.rev acc
| (_, x, rt)::q, Feuille -> infixz (x::acc) (q, rt)

let parcours t = infixz [] ([],t)

let rec prefixz acc z = match z with
| _, Noeud (x,_,_) -> prefixz (x::acc) (bas_a_gauche z)
| [], Feuille -> List.rev acc
| (_, _, rt)::q, Feuille -> prefixz acc (q, rt)

let parcoursprefixe t = prefixz [] ([],t)

(* Une factorisation de droite et gauche en fonction du marquage m *)

let en_bas m z =
  match m with
  | Gauche -> bas_a_gauche z
  | Droite -> bas_a_droite z

let inverse = function Droite -> Gauche | Gauche -> Droite

(* Pour m = Droite ou Gauche, (descendre m n z) donne la position
   n niveaux plus bas que z qui soit la plus du côté m
   (ou l'exception Zipper s'il n'y a plus rien à ce niveau) *)

let rec descendre m n z =
  if n = 0 then z
  else
    try descendre m (n-1) (en_bas m z)
    with Zipper -> descendre m (n-1) (en_bas (inverse m) z)

(* Si z a un frère du côté m (Droite ou Gauche), alors (voisin m z)
   donne le zipper correspondant, et lève l'exception Zipper sinon *)

let voisin m = function
  | ((m',x,a)::ctx,a') when m<>m' -> ((m,x,a')::ctx,a)
  | _ -> raise Zipper

(* Prochain noeud du côté m de z et n niveaux plus bas.
   Note: à la fois voisin et descendre peuvent lever Zipper,
    et dans les deux cas on remonte essayer de passer plus haut *)

let rec remonte m n z =
  try descendre (inverse m) n (voisin m z)
  with Zipper -> remonte m (n+1) (en_haut z)

let a_gauche z = remonte Gauche 0 z
let a_droite z = remonte Droite 0 z
