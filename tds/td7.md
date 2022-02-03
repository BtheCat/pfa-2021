TD7 : Hashconsing et BDD
========================

**M1 Informatique - Programmation Fonctionnelle Avancée**

Les BDD (Binary Decision Diagrams) sont des représentations efficaces de formules booléennes comme `b0 && b1 || b2`. Ils sont très utilisés en vérification formelle (cf. *model checking*) et en conception de circuits, la [page Wikipédia](https://en.wikipedia.org/wiki/Binary_decision_diagram) correspondante vous en dira plus à ce sujet.

A la base, on commence avec des arbres de décisions (BDT, pour Binary Decision Tree): chaque noeud correspond à une conditionelle sur une variable, et les feuilles sont des valeurs booléennes.

```ocaml
type variable_index = int
type bdt =
| True
| False
| If of variable_index * bdt * bdt
```

On utilise ici des entiers pour représenter le nom des variables booléennes `b0`, `b1`, `b2`, ... de nos formules. Première restriction importante: dans les BDT, un ordre sur les variables est choisi (p.ex. ici l'ordre habituel sur les entiers), et les noeuds `If` portent sur des variables de plus en plus grandes (strictement) quand on va de la racine d'un BDT à ses feuilles.

#### Exercice 1 : Conversion vers BDT

Voici une présentation plus habituelle des formules booléennes:

```ocaml
type binop = And | Or | Xor | Impl | Iff
type formula =
| Cst of bool
| Var of variable_index
| Neg of formula
| Binop of binop * formula * formula
```

Ecrire une fonction de traduction `bdt_of_formula : formula -> bdt` respectant la convention précédente sur l'ordre des variables.


Les BDT présentent plusieurs inconvénients:

  - (a) Ils peuvent rapidement devenir très gros: ils sont similaires à des tables de vérités, donc peuvent être exponentiels en le nombre de variables.
  - (b) De plus deux BDT différents peuvent correspondre à des formules logiques équivalentes, par exemple `If(0,True,True)` et `True`.

Les BDD sont une évolution des BDT qui améliorent le point (a) et résolvent le point (b). On parle maintenant de *Diagram* car il ne s'agit plus d'arbres mais plutôt de graphes acycliques, dans lesquels un même emplacement peut éventuellement être accédé par plusieurs chemins distincts depuis la racine. Cela permet maintenant d'exiger la propriété fondamentale des BDD concernant le *partage*: aucune zone ne doit être dupliquée dans un BDD. De plus, pour obtenir l'aspect *canonique* des BDD (c'est-à-dire le point (b)), on interdit aussi les conditionnelles triviale `If(x,t,t)` (avec le même sous-diagramme des deux côtés de la conditionnelle). Avec ces conditions, deux BDD équivalents au sens logique sont forcément égaux. Ainsi, le seul BDD représentant une tautologie est `True`.

Au lieu de chercher à coder des graphes acycliques en OCaml, nous allons ici garder le type `bdt` pour coder nos BDD: `type bdd = bdt`. Simplement, on prendra soin dans un `bdd` à ce que les zones identiques de ces arbres soient réellement partagées en mémoire, c'est-à-dire égaux via l'égalité de pointeur `==`.

#### Exercice 2 : Normalisation

Ecrire une fonction `norm : bdt -> bdd` qui prend un BDT quelconque (respectant l'ordre des variables), et produit le BDD équivalent. Quelle est la complexité de cette fonction ? Attention au coût de la comparaison d'arbres en OCaml.

#### Exercice 3 : Hash-consing

Utiliser le hash-consing pour garantir la présence en mémoire d'une unique copie d'un arbre donné. Fournir en particulier un *smart constructor* `smartIf : int -> bdd -> bdd -> bdd` qui alloue un nouveau noeud `If` uniquement si ce noeud n'existe pas déjà en mémoire. Modifier ensuite votre fonction de normalisation pour bénéficier de la comparaison `==` sur les arbres hash-consés. Quel est alors la complexité de la fonction de normalisation ?

Pour les opérations de hashcons, voir par exemple https://github.com/backtracking/ocaml-hashcons

#### Exercice 4 : Opérations optimisées sur les BDD

Toujours à l'aide du hash-consing, fournir les différentes opérations logiques sur les BDD :  `neg : bdd -> bdd`, `and : bdd -> bdd -> bdd`, etc. Tous les arbres (en entrée et sortie) devront être des BDD. Donner les complexités de vos opérations. En déduire une fonction `bdd_of_formula : formula -> bdd` plus efficace que la combinaison de `bdt_of_formula` suivi de `norm`.

#### Pour aller plus loin

Se servir de ce qui précède pour tester si une formule booléenne est une tautologie. Si une formule est satisfiable, trouver une affectation des variables qui la satisfait.

Vous pourrez utiliser le [code fourni](code) pour charger des formules non triviales.
