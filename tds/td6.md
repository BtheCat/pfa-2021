TD6 : Paresse
=============

**M1 Informatique - Programmation Fonctionnelle Avancée**

On considère la mini-bibliothèque suivante de flots infinis (ou *streams*) :

```ocaml
exception Empty

module type STREAM = sig
  type 'a t = ('a cell) Lazy.t
  and 'a cell = Cons of 'a * 'a t
  val empty : 'a t
  val cons : 'a -> 'a t -> 'a t
  val get : 'a t -> 'a * 'a t
end

module MyStream : STREAM = struct
  type 'a t = ('a cell) Lazy.t
  and 'a cell = Cons of 'a * 'a t
  let empty = lazy (raise Empty)
  let cons x s = lazy (Cons (x,s))
  let get s = match s with lazy (Cons (x,s')) -> (x,s')
end
```

Par rapport aux transparents du cours, notez l'absence du constructeur `Nil` : la paresse permet de le remplacer par une exception !

#### Exercice 1

  1. Écrire une fonction `of_list : 'a list -> 'a MyStream.t` utilisant `List.fold_right`.
  2. Écrire une fonction `take : int -> 'a MyStream.t -> 'a list` donnant les `n` premiers éléments d'une stream, ou bien tous les éléments s'il y en a moins que `n`. Tester à l'aide de la fonction précédente.
  3. Écrire une fonction `from : int -> int MyStream.t` donnant une stream de tous les entiers successifs à partir de `n` inclus: `n`, `n+1`, `n+2`, etc. Tester avec la fonction `take`.
  4. Pourrait-on écrire cette fonction `from` si le type `t` est rendu abstrait dans la signature `STREAM` ?


#### Exercice 2

Le *crible d'Ératosthène* est une méthode pour calculer la séquence des nombres premiers:

  - Un générateur engendre le flot de nombres à partir de 2.
  - La sortie du générateur passe par une chaîne de filtres, dont chacun supprime tous les éléments qui sont divisibles par un certain nombre.

![Portrait of Eratosthenes](https://upload.wikimedia.org/wikipedia/commons/a/a2/Portrait_of_Eratosthenes.png)

Le crible fonctionne comme suit :

  - Il laisse passer le premier élément (appelé `x`).
  - Pour tous les éléments suivants de l'entrée il élimine ceux qui sont multiples de `x`. Le flot des nombres qui restent après cette élimination est passé à une nouvelle instance du crible.

  1. Écrire une fonction `no_multiple n s` qui produit une nouvelle stream à partir de la stream `s` en enlevant tous les multiples de `n`. En supposant que `s` est triée dans l'ordre croissant, essayer de coder cette fonction sans utiliser de multiplication ou division.
  2. Écrire une fonction `sieve` produisant le flot infini des nombres premiers par la méthode d'Eratosthène. En afficher les 1000 premiers.

#### Exercice 3

Reprendre tout le TP en utilisant maintenant le type `'a Stream.t` fourni en standard par OCaml, et les fonctions de la bibliothèque `Stream`. Attention, dans cette bibliothèque un certain nombre de fonctions sont impératives, par exemple `Stream.next`. Remarquez également que cette bibliothèque ne documente pas de fonctions du style de notre `MyStream.cons` : comme `Stream.t` est abstrait, cela aboutirait aux soucis évoqués question 1.3. En fait `Stream` propose bien des constructeurs de base tel que `Stream.icons`, mais pour un usage interne au système uniquement, tandis que les utilisateurs sont vivement encouragés à utiliser un *pré-processeur* nommé Camlp4, proposant une syntaxe dédiée (et paresseuse) pour les streams.

```ocaml
#load "dynlink.cma"
#load "camlp4o.cma"
let cons x s = [< 'x; s >]
let get s = parser [< 'x; s' >] -> (x,s')
```

Plus d'information ici dans le [Tutoriel Camlp4](http://caml.inria.fr/pub/docs/tutorial-camlp4/tutorial002.html)
