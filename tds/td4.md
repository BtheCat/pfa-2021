TD4 : Zippers
=============

**M1 Informatique - Programmation Fonctionnelle Avancée**

#### Exercice 1 : Manipulation pas-à-pas de listes

On rappelle le type des zippers de listes:

```ocaml
type 'a stack = 'a list
type 'a listzipper = 'a stack * 'a list
```

Utilisez le toplevel OCaml afin de vous promener dans la liste `[1;2;4;5]` à l'aide de son zipper, y ajouter 3 au milieu, puis refermer.

#### Exercice 2 : Manipulation pas-à-pas d'arbres binaires

On rappelle le type des zippers d'arbres binaires:

```ocaml
type 'a arbre =
| Feuille
| Noeud of 'a * 'a arbre * 'a arbre
type marqueur = Gauche | Droite
type 'a block = marqueur * 'a * 'a arbre
type 'a path = 'a block list
type 'a arbrezipper = 'a path * 'a arbre
```

Utilisez le toplevel OCaml afin de vous promener dans un arbre binaire particulier. Par exemple:

  - Observez le résultat de `bas_a_droite` puis `bas_a_gauche` puis `en_haut` sur l'arbre suivant:

```html
   │
┌──5──┐
    ┌─3─┐
   ┌2┐ ┌4┐
```

  - En partant du zipper précédent, effectuer les modifications suivantes de cet arbre : le label 3 devient 7, et le noeud marqué 4 a maintenant un fils gauche non-vide.


#### Exercice 3 : Manipulation pas-à-pas d'arbres n-aires

En s'inspirant de ce qui précède, donnez le type des zippers d'arbres n-aires. Dans l'arbre n-aire ci-dessous, observez l'effet de `en_bas` puis `a_droite`, puis descendez la feuille marquée 8 d'un niveau.

```html
 ┌───┬─┴────┐
 5  ┌┴┐  ┌─┬┴┬─┐
    3 9  2 8 7 1
 ```

#### Exercice 4 : Reconstruction

A partir d'un zipper, on souhaite retrouver la structure de données d'origine.

  - Ecrivez une fonction `z_to_list : 'a listzipper -> 'a list` qui reconstruit la liste représentée par le zipper de liste `(pile,liste)`. Privilégiez l'utilisation de fonctions prédéfinies du module `List`.

  - Donnez une fonction `z_to_bintree : 'a arbrezipper -> 'a arbre` qui prend en argument un zipper d'arbre binaire et retourne l'arbre binaire représenté par celui-ci.

  - Comment généraliser ces fonctions à tout type de zipper ?

#### Exercice 5 : Parcours dans des arbres binaires

Ecrivez des fonctions récursives terminales	définissant un parcours infixe et préfixe sur un arbre en utilisant des zippers. Vous pourrez en particulier utiliser la fonction `bas_a_gauche` pour descendre dans l'arbre et empiler ce qui reste à afficher.


#### Exercice 6 : Visite d'un niveau d'arbre

Dans un zipper d'arbre binaire, programmer des fonctions `a_gauche` et `a_droite` qui décale le zipper vers le noeud voisin au même niveau dans l'arbre.


#### Exercice 7

Donnez les types des structures de données suivantes, et dérivez-en automatiquement les blocs de pile pour leurs zippers :

  - Arbre ternaire avec données contenues uniquement dans les noeuds
  - Arbre ternaire avec données contenues uniquement dans les feuilles
