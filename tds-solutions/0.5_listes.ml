let rec append l1 l2 = match l1 with
| [] -> l2
| h::t -> h :: append t l2

let rec flatten li = match li with
| [] -> []
| h::t -> append h (flatten t)

let rec rev l = match l with
| [] -> []
| h::l -> append (rev l) [h]

let rec fold_left f acc = function
| [] -> acc
| t::q -> fold_left f (f acc t) q

(* ou bien la version efficace: *)

let rec rev_append l1 l2 = match l1 with
| [] -> l2
| h::t -> rev_append t (h::l2)

let rev l = rev_append l []

(* Par la suite on utilisera directement `@` au lieu de `List.append`. *)

let rec somme_liste = function
| [] -> 0
| t::q -> t + somme_liste q

let somme_liste li = fold_left (+) 0 li

let scal v v' = List.fold_left (+) 0 (List.map2 ( * ) v v')

let scal v v' = List.fold_left2 (fun s x x' -> s + x * x') 0 v v'

