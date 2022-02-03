TD0 : Rappels OCaml
===================

**M1 Informatique - Programmation Fonctionnelle Avancée**

## Démarrage

Pour lancer l'interpréteur OCaml sous `emacs` :

  - ouvrez un nouveau fichier `tp0.ml` (l'extension `.ml` est nécessaire),
  - dans le menu `Tuareg`, dans le sous-menu `Interactive Mode`, choisir `Run OCaml Toplevel`
  - confirmez le lancement de `ocaml` par un retour-chariot.

Chaque expression entrée dans la fenêtre de `tp0.ml` peut être évaluée en se plaçant sur un caractère quelconque de l'expression, puis en utilisant le raccourci `ctrl-x,ctrl-e`, qui correspond à `Evaluate phrase` dans le sous-menu `Interactive Mode` du menu `Tuareg` d'emacs.

**Nota Bene** : dans tout ce qui suit, nous n'utiliserons plus l'ancien terminateur `;;`. En contrepartie, *toutes* les phrases doivent commencer par `let`, même les tests. Au lieu de `1+2;;`, on écrira donc maintenant `let _ = 1+2`.

## Liaison, fonctions d'ordre supérieur, filtrage

#### Exercice 1 : Rappels sur le mécanisme de liaison

Prévoir le résultat fourni par l'interpréteur OCaml après chacune des commandes suivantes :

```ocaml
let x = 2
```

```ocaml
let x = 3 in
let y = x + 1 in
x + y
```

```ocaml
let x = 3
and y = x + 1 in
x + y
```

Pourquoi la deuxième et la troisième commande ne fournissent-elles pas le même résultat ?

Considérons maintenant les phrases suivantes :

```ocaml
let x = 3
let f y = y + x
let _ = f 2
let x = 0
let _ = f 2
```

Quels sont les résultats des appels de fonctions successifs `f 2` ?

#### Exercice 2 : Placement des parenthèses

Ajouter les parenthèses nécessaires pour que le code ci-dessous compile:

```ocaml
let somme x y = x + y
let _ = somme somme somme 2 3 4 somme 2 somme 3 4
```

#### Exercice 3 : Fonctions booléennes

  - Écrire une fonction `checktauto : (bool->bool)->bool` qui teste si une fonction booléenne à un argument répond toujours `true`.

  - Même chose avec `checktauto2` et `checktauto3` pour des fonctions booléennes à 2 puis 3 arguments. On peut faire ça en énumerant à la main tous les cas, mais il y a évidemment plus malin, par exemple réutiliser `checktauto`.

  - En utilisant des conditionnelles, écrivez une fonction `g` qui se comporte comme la fonction `f` ci-dessous. Vérifier ensuite à l'aide de `checktauto3` que `f` et `g` produisent bien toujours le même résultat.

```ocaml
let f x y z = match x, y, z with
  | _ , false , true -> 1
  | false , true , _ -> 2
  | _ , _ , false -> 3
  | _ , _ , true -> 4
```

#### Exercice 4 : Fonctions sur les listes

Proposer une implémentation des fonctions suivantes:

  - `append : 'a list -> 'a list -> 'a list` qui concatène deux listes.
  Exemple : `append [1;2] [3;4] = [1;2;3;4]`.
  
  - `flatten : 'a list list -> 'a list` qui aplanit d'un niveau une liste de listes.
  Exemple : `flatten [[2];[];[3;4;5]] = [2;3;4;5]`.
  
  - `rev : 'a list -> 'a list` qui inverse l'ordre des éléments d'une liste (une version naïve suffira).
  Exemple : `rev [1;2;3] = [3;2;1]`.
  
**Nota Bene** : ces fonctions sont disponibles dans la bibliothèque standard OCaml sous les noms `List.append`, `List.flatten`, `List.rev`. La première peut simplement s'utiliser avec la syntaxe infixe `@`.

#### Exercice 5 : Utilisation de la bibliothèque List

  - Écrivez une fonction `somme_liste : int list -> int`
  - Ré-implémentez la fonction `List.fold_left`, puis `somme_liste` en utilisant ce `fold_left`.
  - Écrivez une fonction `scal` telle que `scal l l'` calcule le produit scalaire des vecteurs `l` et `l'` représentés sous forme de listes. Servez-vous des fonctions `List.fold_left` et `List.map2`.
  - Même question en utilisant uniquement `List.fold_left2`.

#### Exercice 6 : Filtrage et variables

Considérons le code suivant:

```ocaml
type contact =
| Tel of int
| Email of string

let mon_tel = 0123456789
let mon_email = "moi.je@ici.fr"

let est_ce_moi = function
| Tel mon_tel -> true
| Email mon_email -> true
| _ -> false
```

Que donne `est_ce_moi (Tel 0987654321)` ? Modifier cette fonction `est_ce_moi` pour en faire un véritable test d'identité.


## Manipulation des outils standards

#### Exercice 7 : Trace et ses limitations

  - Quelle est la complexité de la version naïve de `rev` ?
  - Tracez les appels de `rev` grâce à `#trace rev`. Essayez avec `rev [1;2;3;4]`.
  - Malheureusement `#trace` ne permet pas de donner les valeurs lorsque celles-ci sont des instanciations de valeurs polymorphes (d'où l'indication `<poly>`). Restreignez maintenant la fonction `rev` au type `int list -> int list` et tracer son appel sur `rev [1;2;3;4]`. Remarquez que l'on descend dans la structure puis que l'on remonte.

#### Exercice 8 : Compilation séparée

  - **Préparation** : écrivez trois fichiers `plus.ml`, `fois.ml` et `puis.ml` contenant respectivement la définition des fonctions `plus`, `fois`, et `puissance` sur les entiers naturels. La fonction `fois` devra utiliser la fonction `plus`, et la fonction `puissance` devra utiliser la fonction `fois`. Écrivez également un fichier `main.ml` qui affiche le résultat de 2^4 (via `print_int`).

  - **Compilation manuelle** : compiler votre programme en bytecode (ou code-octet), en utilisant directement des commandes du style:
    * `ocamlc -c a.ml` pour produire le fichier objet `a.cmo` à partir du fichier source `a.ml`.
    * `ocamlc a.cmo b.cmo -o monprog` pour produire l'exécutable `monprog` en liant différent fichiers objets. On peut ensuite vérifier que `./monprog` exécute bien le programme.

  - Compilez maintenant votre programme en version native, en utilisant `ocamlopt` au lieu de `ocamlc`. Quel est alors le nom des fichiers objets générés ?

  - **Compilation automatisée** : la plupart du temps on pourra simplement utiliser la commande `ocamlbuild` qui permet d'automatiser la compilation de n'importe quel fichier en code-octet ou natif, en s'occupant des dépendances et de l'ordre de compilation. Utilisez-le pour générer le code-octet du module `main`, via `ocamlbuild main.byte`, ou bien le programme natif via `ocamlbuild main.native`. Attention à supprimer d'abord tout fichier objet `.cm*` qui existerait au même endroit.

## Questions avancées

#### Exercice 9 : Réinventons les paires

En utilisant seulement les constructions `let` et `fun` du langage (en particulier, pas le droit aux paires `(a,b)`), définir trois fonctions `pair`, `first`, `second` telles que pour toutes valeurs `a` et `b`, on ait `first (pair a b)` qui soit égal à `a` et `second (pair a b)` soit égal à `b`. Idéalement, `a` et `b` devront pouvoir avoir des types différents.

#### Exercice 10 : Récursion terminale

Écrire une implémentation récursive terminale ( *tail-recursive* en anglais) de la fonction `leaves` suivante :

```ocaml
type 'a tree =
| Node of 'a tree * 'a tree
| Leaf of 'a

let rec leaves = function
| Leaf v -> [v]
| Node (a, b) -> leaves a @ leaves b
```
