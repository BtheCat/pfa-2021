TD3 : Modules et foncteurs
==========================

**M1 Informatique - Programmation Fonctionnelle Avancée**

Note : les exercices 3 à 6 de ce TP sont extraits du [cours de Didier Rémy](http://gallium.inria.fr/~remy/isia).

## Foncteurs de la bibliothèque standard

#### Exercice 1 : Set.Make

Grâce au foncteur `Set.Make` de la librarie standard, créez une structure d'ensembles d'entiers. Comment peut-on visualiser le contenu d'un ensemble ? Ecrivez une fonction `powerset` qui prend en entrée un ensemble d'entiers, et génère tous les sous-ensembles possibles de cet ensemble. Dans un premier temps, vous pourrez utiliser en sortie une liste d'ensembles. Comment faire ensuite pour que `powerset` retourne un ensemble d'ensembles ?

#### Exercice 2 : Map.Make et Hashtbl.Make

Proposez des équivalents efficaces de `List.assoc` lorsque le type des clés est connu (par exemple `string`), en utilisant soit le foncteur `Map.Make`, soit `Hashtbl.Make`. Comparez vos deux solutions.

## Modules bancaires

#### Exercice 3 : Monnaies

L'euro et le dollar sont deux monnaies supportant les mêmes opérations mais incompatibles entre elles.

  - Définissez un module `Mfloat` contenant un type `t = float`, ainsi que les opérations `un : t`, `plus : t -> t -> t` et `prod : float -> t -> t` permettant	de créer l'unité pour le type `t`, d'additionner deux éléments de type `t`, et de multiplier un élément par un scalaire.
  - Écrivez une interface `MONNAIE` mentionnant ces mêmes types et opérations, mais telle que `t` soit abstrait.

On peut maintenant créer deux modules `Euro` et `Dollar` par le code suivant :

```ocaml
module Euro = (MFloat : MONNAIE)
module Dollar = (MFloat : MONNAIE)
```

  -	Vérifiez que les deux monnaies sont bien incompatibles entre elles.	Quel mécanisme de OCaml permet de s'en assurer ?
  - Ecrivez une fonction `euro : float -> Euro.t` qui fabrique des Euros.

#### Exercice 4 : Bureau de change

On souhaite maintenant créer un bureau de change sous forme de module qui permette de convertir une somme en euros en une somme en dollars.

  - Donnez une signature `BUREAU_DE_CHANGE` comportant deux sous-modules `Euro` et `Dollar` de type `MONNAIE`, ainsi que des fonctions de conversion entre ces monnaies.
  - Donnez-en une implémentation.

#### Exercice 5 : Restrictions de modules

On souhaite définir un module qui permette uniquement d'additionner des euros mais qu'il soit en revanche impossible d'en créer ou d'en multiplier.

  - Donnez une signature `MPLUS` qui permette cette restriction.
  - A partir de cette signature et du module `Euro` créé précédemment, créez un module `Mplus` de la façon la plus concise possible.
  - Vérifiez que votre code fonctionne :
    * L'expression `(MPlus.plus Euro.un Euro.un)` doit être bien typée.
	* Mais l'expression `(MPlus.plus Euro.un 1.0)` doit retourner une erreur.

#### Exercice 6 : Banques

  - Donnez deux signatures `Client` et `Banque` de modules qui représentent une banque.	L'une est destinée au client et comprendra les fonctions `depot` et `retrait` toutes deux de type
`t -> monnaie -> monnaie`. Les types `t` et `monnaie` seront abstraits.	L'autre signature est destinée au banquier et aura en plus de celle du client la possibilité de créer une Banque.
  - Donnez une implémentation du module `Banque` du type suivant, en donnant un type concret pour `t` :

```ocaml
module Banque : functor (M : MONNAIE) ->
 sig
   type t
   type monnaie = M.t
   val creer : unit -> t
   val depot : t -> monnaie -> monnaie
   val retrait : t -> monnaie -> monnaie
 end
```

  - Créez une banque `Toto` tenant ses comptes en euros.

  - Donnez une implémentation de la signature `Client` qui soit compatible avec la banque `Toto` précédemment crée, c'est-à-dire permettant de faire :

```ocaml
let mon_ccp = Toto.creer ()
let _ = Toto.depot mon_ccp (euro 100.0)
let _ = Client.depot mon_ccp (euro 100.0)
```

  - Créez une banque gérant les comptes en dollars et vérifier qu'il n'est pas possible d'ajouter des euros.

## Intermède informatique

#### Exercice 7 : compilation qui n'est plus séparée

Reprenez l'exercice 8 du [TD0](../td0/td0.md), et construisez un fichier source unique contenant des définitions de modules et interfaces de modules correspondantes aux fichiers `plus.ml`, `fois.ml`, `puis.ml` et `main.ml`. Attention, les fonctions doivent toujours être appelées `Plus.plus`, `Fois.fois` et `Puis.puissance`.

#### Exercice 8

On définit le module `Ordi` de la façon suivante :

```ocaml
module Ordi =
struct
  type t = int ref
  let create () = ref 0
  let start s = s:=1
  let read_state s = !s
end
```

Donnez deux signatures `USER_ORDI` et `ADMIN_ORDI` de telle façon à ce que le type `t` soit abstrait, et que seul l'administrateur puisse accéder aux fonctions `start` et `create`. L'utilisateur pourra seulement utiliser la fonction `read_state`.

#### Exercice 9

Voici un extrait du code de Menhir, un générateur de parseurs pour OCaml:

```ocaml
(* A uniform interface for output channels. *)
module type OUTPUT = sig
  type channel
  val char: channel -> char -> unit (* Ecrit un caractère sur le canal *)
  val substring: channel -> string -> int (* offset *) -> int (* length *) -> unit
  (* Ecrit length caractères de la chaine string à partir de l'offset
     sur le canal channel *)
end
```

On souhaite donner deux implémentations de cette interface : une fonctionnant avec l'entrée standard, l'autre avec le module `Buffer`. A partir de la documentation du module `Buffer` et du module `Pervasives` (le module chargé par défaut qui contient les informations sur les entrées/sorties standards), écrivez `ChannelOutput` qui a comme type concret la sortie standard, et `BufferOutput` qui a comme type concret le type abstrait des buffers.

## Plus de foncteurs

#### Exercice 10 : Foncteurs et arbres

  - Ecrivez un module `Tree` représentant des arbres binaires d'entiers. Créez ensuite une table de hachage avec pour éléments ces arbres en utilisant le foncteur `Hashtbl.Make`. Pour la fonction de hachage, vous pourrez utiliser la fonction polymorphe `Hashtbl.hash`.
  - Créez également un module contenant un ensemble d'arbres binaires ordonnées par leurs tailles grâce au foncteur `Set.Make` de la librairie standard. Que se passe-t'il si on insère
successivement deux arbres de même taille ?
  - Créez maintenant une table de hachage avec pour éléments des ensembles d'arbres (il peut être utile de recourir à l'instruction `include`).
  - Testez votre code en créant des ensembles d'arbres binaires.

#### Exercice 11 : Contraintes de types

  - Récupérez le fichier [td3_code.ml](td3_code.ml).
  - Grâce au foncteur `Set` de ce fichier, créez un module représentant les ensembles de chaînes de caractères.
  - Essayez de créer un ensemble contenant les éléments `"abc"`, `"def"`, `"ghi"`. Quel est le problème ?
  - Après avoir résolu le problème, créez l'ensemble demandé à la question précédente et vérifiez le résultat de la fonction `mem` sur différentes valeurs.
  - Réécrivez le module `Set` en utilisant la notation simplifiée pour les foncteurs.
