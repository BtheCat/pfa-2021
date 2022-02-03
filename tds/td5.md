TD5 : Structures de données fonctionnelles efficaces
====================================================

**M1 Informatique - Programmation Fonctionnelle Avancée**

#### Exercice 1

Considérons les deux fonctions suivantes:

```ocaml
(* reverse naive *)
let rec rev = function
    [] -> []
  | a::r -> (rev r)@[a]

(* reverse efficace *)
let rec rev_append l acc = match l with
  | [] -> acc
  | a :: l' -> rev_append l' (a :: acc)
let rev' l = rev_append l []
```

Prouvez par récurrence (ou *induction*, c'est pareil) que pour toute liste `l`, on a `rev' l = rev l`.

#### Exercice 2

Implementer la signature `DEQUE` ci-dessous des *Double Ended Queues* mentionnés en cours, en gardant une complexité constante en temps amorti. Analysez le coût amorti de votre algorithme.

```ocaml
module type DEQUE = sig
  type 'a queue

  val empty : 'a queue
  val is_empty : 'a queue -> bool

  (* insert or extract the front element *)
  val cons : 'a -> 'a queue -> 'a queue
  val decons : 'a queue -> 'a * 'a queue (* raises Not_found if empty *)

  (* insert or extract the rear element *)
  val snoc : 'a queue -> 'a -> 'a queue
  val snoced : 'a queue -> 'a queue * 'a (* raises Not_found if empty *)
end
```

#### Exercice 3

On considère le type des arbres rouges-noirs vu en cours

```ocaml
type color = R | B
type 'a tree =
 | E
 | T of color * 'a tree * 'a * 'a tree
```

Par rapport aux transparents du cours, ces arbres sont ici polymorphes envers les éléments qu'ils contiennent. On supposera que les fonctions standards de comparaison d'OCaml (`<`, `=`, etc) sont bien utilisables sur ces éléments.

  - Implémenter une fonction `is_abr : 'a tree -> bool` qui vérifie si un tel arbre est bien un arbre binaire de recherche.
  - Implémenter une fonction `is_redblack : 'a tree -> bool` qui vérifie si un tel arbre satisfait bien les conditions des arbres rouges-noirs. Tester sur quelques arbres, fabriqués par exemple avec la fonction `insert` du cours, ou bien délibérément mal équilibrés.
  - Implémenter une fonction `mk_redblack : 'a list -> 'a tree` qui fabrique un arbre rouge-noir correct à partir d'une liste triée. Quel est le gain vis-à-vis d'un usage répété de la fonction `insert` ?
  - En déduire des fonctions ensemblistes efficaces sur les arbres rouges-noirs : union, intersection, différence.
