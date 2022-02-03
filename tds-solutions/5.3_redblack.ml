type color = R | B
type 'a tree =
 | E
 | T of color * 'a tree * 'a * 'a tree
(* Test la fonction booleenne f sur tous les noeuds d'un arbre *)
let rec forall_tree f = function
| E -> true
| T(_,g,x,d) -> f x && forall_tree f g && forall_tree f d

let rec is_abr = function
| E -> true
| T(_,g,x,d) ->
  is_abr g && is_abr d && forall_tree ((>) x) g && forall_tree ((<) x) d

(* Ou bien une version avec une unique visite de l'arbre, en utilisant
   des intervalles (et des options pour marquer -infini et +infini) *)

let check = function
  | (Some x, Some y) -> x < y
  | _ -> true

let rec between (a,b) = function
| E -> true
| T(_,g,x,d) ->
  let ax = (a, Some x) and xb = (Some x, b) in
  check ax && check xb && between ax g && between xb d

let is_abr t = between (None,None) t

(* Cette version du is_abr est maintenant linéaire, tandis que la
   version précédente est en O(n.lg n) au pire: l'équation des coûts est
   T(n) = 2*T(n/2) + O(n) dans le cas d'un arbre binaire complet,
   et on utilise ensuite le "master theorem" *)

exception NoRedBlack

let rec black_height = function
  | E -> 0
  | T(c,g,_,d) ->
    let hg = black_height g and hd = black_height d in
    if hg <> hd then raise NoRedBlack
    else hg + (if c=B then 1 else 0)

let check_black_height t =
  try let _ = black_height t in true with NoRedBlack -> false

let rec check_red red_ok = function
  | E -> true
  | T(R,g,_,d) -> red_ok && check_red false g && check_red false d
  | T(B,g,_,d) -> check_red true g && check_red true d

let is_redblack t = is_abr t && check_red true t && check_black_height t

(* mk_rb n h l construit un arbre rouge-noir avec les n premiers
   éléments de l, et retourne cet arbre ainsi que les éléments
   restants de l. On suppose que l contient bien au moins n éléments.
   Le paramètre h est la hauteur noire que l'on souhaite obtenir.
   La hauteur des arbres non-vides produits sera (h+1), et les noeuds
   à profondeur (h+1) sont les seuls noeuds rouges. *)

let rec mk_rb n h l =
  if n = 0 then E, l
  else if h = 0 then begin
    assert (n = 1);
    match l with
    | [] -> assert false (* n=1 *)
    | x::l' -> T(R,E,x,E), l'
  end else
    let n1 = n/2 in
    let t1,l1 = mk_rb n1 (h-1) l in
    match l1 with
    | [] -> assert false (* n1 < n *)
    | x::l1' ->
      let n2 = n-1-n1 in (* n = 1+n1+n2 *)
      let t2,l2 = mk_rb n2 (h-1) l1' in
      T(B,t1,x,t2), l2

let rec lg n = if n<=1 then 0 else 1+lg (n/2)

let mk_redblack l =
  let n = List.length l in
  let h = lg n in
  let t,l' = mk_rb n h l in
  assert (l' = []);
  t

(* mk_redblack est linéaire en le nombre d'elements, tandis
   qu'une succession d'insertions donnerait une complexité au pire
   lg(1)+lg(2)+...+lg(n) = lg(n!) = O(n*lg(n)) (via la formule
   de Stirling). *)

(* l'operation inverse: la liste ordonnée des elements d'un abr *)
let rec elements_acc acc = function
  | E -> acc
  | T(_,g,x,d) -> elements_acc (x :: elements_acc acc d) g

let elements t = elements_acc [] t

let rec union_slist l1 l2 = match l1,l2 with
  | [],_ -> l2
  | _,[] -> l1
  | x1::l1', x2::l2' ->
    if x1 = x2 then x1::union_slist l1' l2'
    else if x1 < x2 then x1::union_slist l1' l2
    else (* x1 > x2 *) x2::union_slist l1 l2'

let union t1 t2 =
  mk_redblack (union_slist (elements t1) (elements t2))

(* Cette opération est linéaire en le max des tailles de t1 et t2 *)

(* Idem pour intersection and différence *)

let rec inter_slist l1 l2 = match l1,l2 with
  | [],_ | _,[] -> []
  | x1::l1', x2::l2' ->
    if x1 = x2 then x1::inter_slist l1' l2'
    else if x1 < x2 then inter_slist l1' l2
    else (* x1 > x2 *) inter_slist l1 l2'

let inter t1 t2 =
  mk_redblack (inter_slist (elements t1) (elements t2))

let rec diff_slist l1 l2 = match l1,l2 with
  | [],_ -> []
  | _,[] -> l1
  | x1::l1', x2::l2' ->
    if x1 = x2 then diff_slist l1' l2'
    else if x1 < x2 then x1::diff_slist l1' l2
    else (* x1 > x2 *) diff_slist l1 l2'

let diff t1 t2 =
  mk_redblack (diff_slist (elements t1) (elements t2))
