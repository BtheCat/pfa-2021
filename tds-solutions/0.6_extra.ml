type 'a tree =
| Node of 'a tree * 'a tree
| Leaf of 'a

(* Question 1 : Récursion terminale *)

(* On commence par ré-écrire la fonction en utilisant un
accumulateur. Ce n'est toujours pas tail-récursif, mais on s'en
rapproche (un des deux appels récursifs est un appel terminal).
*)

let rec leaves_acc acc = function
| Leaf v -> v::acc
| Node (a, b) -> leaves_acc (leaves_acc acc b) a

let leaves tree = leaves_acc [] tree

(* Pour aller plus loin, on peut maintenant utiliser une pile explicite
de sommets à visiter (c'est une technique assez classique pour rendre
les parcours d'arbre tail-récursifs dans des langages moins élégants
que OCaml).
*)

let rec leaves_tail acc to_visit = function
| Node (a, b) -> leaves_tail acc (a :: to_visit) b
| Leaf v ->
  let acc = v::acc in
  match to_visit with
  | [] -> acc
  | tree::to_visit -> leaves_tail acc to_visit tree

let leaves tree = leaves_tail [] [] tree

(* Notez qu'on peut en fait ré-écrire cette fonction pour travailler
directement sur une liste d'arbres à visiter (une forêt) en entrée, au
lieu de séparer l'arbre en entrée de la liste `to_visit`.
*)

let rec leaves_tail acc = function
| [] -> acc
| Leaf v :: rest -> leaves_tail (v::acc) rest
| Node (a, b) :: rest -> leaves_tail acc (b::a::rest)

let leaves tree = leaves_tail [] [tree]

(* Note : dans un langage fonctionnel il est possible d'utiliser une
technique systématique pour passer automatiquement de la version
initiale à la version tail-récursive, sans changer d'algorithme ou
réfléchir trop. Cela utilise des *continuations*. Vous allez en
entendre parler ultérieurement. Par contre la mauvaise complexité
de la version d'origine est préservée.
*)

let rec leaves_cont tree return = match tree with
| Leaf v -> return [v]
| Node (a, b) ->
   leaves_cont a (fun la ->
    leaves_cont b (fun lb ->
     return (la @ lb)))

let leaves' tree = leaves_cont tree (fun res -> res)


(* Question 2 : Réinventons les paire *)

(* Certain-e-s élèves ont proposé des variantes (en général plus
   compliquées) de la solution suivante: *)

let pair a b = function
  | true -> a
  | false -> b

let first p = p true
let second p = p false

(* C'est déjà intéressant, mais les arguments `a` et `b` doivent alors
avoir le même type, car ils sont tous les deux renvoyés par un cas du
filtrage. On peut écrire `(1, "toto")` en OCaml, mais avec la solution
ci-dessus `pair 1 "toto"` est mal typé. *)

(* Une solution réellement polymorphe : *)

let pair a b = fun f -> f a b
let first p = p (fun x y -> x)
let second p = p (fun x y -> y)

let chk a b = (first (pair a b), second (pair a b))

