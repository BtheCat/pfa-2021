TD1 : Listes à accès arbitraire rapide
======================================

**M1 Informatique - Programmation Fonctionnelle Avancée**

On s'intéresse ici à des structures de données purement fonctionnelles (on dit également *persistantes*) permettant de représenter des *listes*, c'est-à-dire des séquences finies et ordonnées d'éléments ayant des opérations *par la gauche* efficaces: ajout via `cons` et retrait via `head` et `tail`. En outre, on souhaite disposer également d'une fonction `nth` sur nos structures, permettant d'accéder efficacement au n-ième élément.

Note : dans ce qui suit, au lieu de fonctions séparées `head` et `tail`, on utilisera désormais une unique fonction `decons` telle que `decons l = (head l, tail l)`.

#### Exercice 1 : Implémentation par listes OCaml

Implémentez les opérations suivantes, et indiquez leurs complexités. Dans tout ce TD, on parle
de complexité en temps, dans le pire cas, exprimée en fonction de la taille de la liste.

```ocaml
cons : 'a -> 'a list -> 'a list
decons : 'a list -> 'a * 'a list (* may raise Not_found *)
nth : 'a list -> int -> 'a (* may raise Not_found *)
```

#### Exercice 2 : Implémentation par b-listes

On va maintenant concevoir une structure de données pour laquelle les trois opérations `cons`, `decons` et `nth` seront au pire logarithmiques.

On appelle *b-liste* une liste (usuelle) d'arbres binaires parfaits ayant les données aux feuilles, satisfaisant de plus l'invariant suivant: la taille des arbres binaires est strictement croissante quand on avance vers la droite de cette liste.

  - Définir un type OCaml `'a blist` correspondant à cette structure, ainsi que quelques exemples de petites b-listes de ce type. Définir en particulier la b-liste `empty`. Peut-on avoir deux b-listes différentes contenant les mêmes données ?

  - Ajustez ce type `'a blist` afin qu'on puisse connaître la taille des arbres qui composent une b-liste sans avoir besoin de parcourir ces arbres.

  - Implémentez maintenant les trois opérations `cons`, `decons` et `nth` sur le type `'a blist`, de manière à ce qu'elles soient toutes logarithmiques au pire.

  - (Facultatif) Coder une opération `update_nth` de complexité logarithmique, telle que `update_nth l n a` donne une variante de la b-liste `l` où le n-ième élément est maintenant `a`.

  - (Facultatif) Coder une opération `drop` de complexité logarithmique, telle que `drop k l` retourne la b-liste `l` privée de ses `k` premiers arguments.

Cette structure montre donc qu'il est possible d'accéder en temps logarithmique à une position arbitraire dans nos listes. Malheureusement ce premier essai conduit à une perte de complexité des opérations *à gauche* (`cons` et `decons`), qui ne sont plus en temps constant. Nous allons maintenant voir comment remédier à cela. Mais tout d'abord, un petit détour par de l'arithmétique : notre première structure est très liée à la décomposition binaire des nombres, et pour faire mieux nous allons utiliser une autre décomposition moins usuelle.

#### Exercice 3 : Arithmétique quasi-binaire

On appelle *écriture quasi-binaire* (ou qb-écriture) d'un nombre entier sa décomposition comme somme de nombres de la forme 2^k -1 avec k>0. On demande de plus que tous les termes de la somme soient différents, à part éventuellement les deux plus petits.

  - Ecrire une fonction `decomp` qui donne l'écriture quasi-binaire de tout nombre entier `n`. Peut-on avoir plusieurs écritures quasi-binaires du même nombre ?

  - Ecrire deux fonction `next` et `pred` qui font passer de l'écriture quasi-binaire d'un nombre à celle de son successeur et de son prédecesseur, sans chercher à reconstituer les nombres en question, et le tout en temps constant.

On admet que la qb-écriture de `n` est une somme dont le nombre de termes est logarithmique en fonction de `n`.

#### Exercice 4 : Implémentation par qb-listes

  - En vous inspirant de ce qui précède, proposer une structure de *listes quasi-binaire* (ou qb-listes) pour laquelle `cons` et `decons` ont des complexités constantes tandis que `nth` et `update_nth` sont logarithmiques.

  - Comparer ces qb-listes avec les listes usuelles : quelles raisons peuvent expliquer la faible adoption des qb-listes en lieu et place des listes usuelles ?
