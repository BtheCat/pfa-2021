TD2 : Listes à accès arbitraire rapide (version modulaire)
==========================================================

**M1 Informatique - Programmation Fonctionnelle Avancée**

Nous avons élaboré au TD précédent une [structure de liste à accès arbitraire rapide](td1/td1.md). Mais le code de la dernière fois présente un inconvénient important : il repose sur des invariants (lesquels, déjà ?) qui sont implicites en OCaml. Du coup, rien n'empêche pour l'instant l'utilisateur de fabriquer des listes d'arbres ne respectant pas ces invariants puis de les donner à nos fonctions `cons` ou `nth`. Les modules d'OCaml vont nous permettre de cacher aux utilisateurs de notre structure ses détails d'implémentation, et donc de restreindre l'usage de notre code aux seules données légales.

On considère pour cela l'interface (ou signature) suivante:

```ocaml
module type RALIST = sig
 type 'a t (* the type of our random-access lists *)
 val empty : 'a t (* an empty random-access list *)
 val length : 'a t -> int (* how many elements in this list ? *)
 val cons : 'a -> 'a t -> 'a t (* add an extra element on the left *)
 val decons : 'a t -> 'a * 'a t (* leftmost element and rest *)
 val nth : 'a t -> int -> 'a (* access to the n-th element in the list *)
end
```

On conviendra que la fonction `decons` lève l'exception `Not_found` si elle est utilisée sur une liste vide. De même pour `nth` si l'index donné ne correspond pas à une position légale dans la liste.

#### Exercice 1 : Implémentation modulaire par listes OCaml

Proposez un module implémentant cette interface de manière naïve, en utilisant pour `'a t` de simples listes d'OCaml. Donner la complexité de chaque opération.

#### Exercice 2 : Taille efficace

  - Proposez une seconde implémentation où l'opération `length` est maintenant en temps constant, tandis que les autres opérations gardent la même complexité.
  - Plus généralement, donner un *foncteur* qui transforme n'importe quelle implémentation de `RALIST` en une nouvelle implémentation pour laquelle `length` est en temps constant (question à garder pour plus tard si la notion de foncteur n'a pas encore été vue en cours).

#### Exercice 3 : Implémentation modulaire par b-listes

  - Reprenez (ou finissez !) le code des *b-listes* de la dernière fois et transformez-le en un module implémentant l'interface `RALIST`.
  - Quelle est la complexité de chaque opération ?
  - Vérifiez que l'utilisateur ne peut construire des b-listes que via les opérations proposées par l'interface `RALIST`. Est-il encore possible de manipuler des b-listes qui ne satisferaient pas les invariants de cette structure de donnnées ?

#### Exercice 4 : Extension de signature

On souhaite disposer d'une opération supplémentaire `map : ('a -> 'b) -> 'a t -> 'b t`

  - Pour l'instant, on ne souhaite pas modifier l'interface `RALIST` ni les modules déjà fabriqués. Comment peut-on fournir cette opération `map` pour chacun des modules des questions précédentes ? Quelle est sa complexité dans chacun des cas ?
  - Proposez un foncteur qui permet de fabriquer systématiquement l'opération `map` pour tout module satisfaisant l'interface `RALIST`.
  - Modifier maintenant l'interface `RALIST` pour y ajouter directement l'opération `map`, et adaptez en conséquence vos trois implémentations. Y a-t'il des gains en complexité ?

#### Exercice 5 : Implémentation modulaire par qb-listes

Proposez une implémentation de l'interface `RALIST` basée sur les *qb-listes* du TP précédent. Quels sont maintenant les complexités ? Est-ce que cette nouvelle implémentation entraîne des changements du côté des utilisateurs de l'interface `RALIST` ?
