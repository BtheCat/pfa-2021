TD8 : programmation OCaml en local, sans LearnOCaml
===================================================

**M1 Informatique - Programmation Fonctionnelle Avancée**

Référence : un [cours de L3](https://gaufre.informatique.univ-paris-diderot.fr/letouzey/pf5/blob/master/slides/cours-03-outils.md) sur les outils de l'écosystème OCaml (compilateur, etc).

## Installations

Pour programmer en OCaml localement sur vos machines (et en particulier réaliser le projet),
nous vous recommandons fortement l'usage des outils suivants: `make`, `menhir`, `dune`, `ocamlfind`,
ainsi qu'un éditeur de code connaissant la syntaxe OCaml (par exemple `emacs` avec l'extension
`tuareg-mode`).

Sur une Linux Debian (ou Ubuntu >= 20.4), ces outils peuvent s'installer simplement via:
`sudo apt install make ocaml menhir dune ocaml-findlib emacs tuareg-mode`.

Pour les autres systèmes, `make` et `emacs` sont disponibles sur toute plateforme raisonnable de
développement, et si les autres outils ne sont pas disponibles directement vous
pourrez les installer via [opam](http://opam.ocaml.org/), un gestionnaire de paquets OCaml.
Attention: si vous utiliser `opam`, il faudra modifier la configuration de votre shell,
soit à chaque fois en tapant `eval $(opam env)` soit une fois pour toute en ajoutant cette
ligne à votre fichier de configuration (p.ex. `~/.bashrc`).

Attention avec Ubuntu 18.04 (ou plus ancien), qui ne propose pas l'outil `dune`.
Pire encore, un binaire du même nom mais qui n'a **rien à voir** avec OCaml est présent
dans le paquet `whitedune`. Mieux vaut **désinstaller** ce paquet `whitedune` si vous
l'avez installé par erreur, pour éviter toute confusion. En outre, Ubuntu 18.04 propose
un `opam` obsolète (version 1 au lieu de 2). Ne pas s'en servir, mais plutôt voir les
[conseils suivants](https://opam.ocaml.org/doc/Install.html#Ubuntu) pour installer `opam`
depuis un "PPA" plutôt que la version d'origine du système.

En cas de souci avec ces installations sur votre machines, vous pouvez aussi fonctionner aujourd'hui
à distance via ssh sur le serveur `lulu` de l'UFR.

Facultatif : un outil comme [merlin](https://github.com/ocaml/merlin)
peut améliorer votre confort de programmation en OCaml (complétion,
indication des types, etc)


## Toplevel OCaml sous emacs

Pour lancer l'interpréteur OCaml sous `emacs` :

  - ouvrez un nouveau fichier `exemple.ml` (l'extension `.ml` est nécessaire),
  - dans le menu `Tuareg`, dans le sous-menu `Interactive Mode`, choisir `Run OCaml Toplevel`
  - en bas il est alors demandé le toplevel OCaml à utiliser, confirmer le choix par défaut en appuyant sur Entrée.

Chaque expression entrée dans la fenêtre de `exemple.ml` peut être évaluée en se plaçant sur un caractère quelconque de l'expression, puis en utilisant le raccourci `ctrl-x ctrl-e`, qui correspond à `Evaluate phrase` dans le sous-menu `Interactive Mode` du menu `Tuareg` d'emacs. Autres raccourcis utiles :
`tab` permet d'indenter la ligne courante, et `ctrl-c ctrl-c` dans la zone emacs du toplevel OCaml permet d'interrompre un calcul long ou infini.

**Nota Bene** : dans tout ce qui suit, nous n'utiliserons plus l'ancien terminateur `;;`. En contrepartie, *toutes* les phrases doivent commencer par `let`, même les tests. Au lieu de `1+2;;`, on écrira donc maintenant `let _ = 1+2`.

#### Exercice

Ouvrir un fichier OCaml dans emacs ou en créer un nouveau, puis saisir quelques phrases OCaml (par exemple le début d'un ancien TP) et les exécuter dans un toplevel.

## Trace

  - Ecrire une fonction récursive `sum` faisant la somme des entiers d'une liste.
  - Tracer les appels de `sum` grâce à `#trace sum`. Essayez ensuite `sum [1;2;3;4]`.
    Remarquez que l'on descend dans la structure puis que l'on remonte les résultats.
  - Essayer également avec une version récursive terminale de `sum`.
  - Tracer les appels à `List.flatten` lors de `List.flatten [[1;2];[];[3]]`. Malheureusement `#trace` ne permet pas de donner les valeurs lorsque celles-ci sont des instanciations de valeurs polymorphes (d'où l'indication `<poly>`). Définissez une fonction `flatten_int  : int list list -> int list` et tracer son appel sur `flatten_int [[1;2];[];[3]]`.

## Compilation

#### Compilation séparée manuelle

  - Préparation : écrivez trois fichiers `plus.ml`, `fois.ml` et `puis.ml` contenant respectivement la définition des fonctions `plus`, `fois`, et `puissance` sur les entiers naturels. La fonction `fois` devra utiliser la fonction `plus`, et la fonction `puissance` devra utiliser la fonction `fois`. Écrivez également un fichier `main.ml` qui affiche le résultat de 2^4 (via `print_int`).

  - Compiler votre programme en bytecode (ou code-octet), en utilisant directement des commandes du style:
    * `ocamlc -c a.ml` pour produire le fichier objet `a.cmo` à partir du fichier source `a.ml`.
    * `ocamlc a.cmo b.cmo -o monprog` pour produire l'exécutable `monprog` en liant différent fichiers objets. On peut ensuite vérifier que `./monprog` exécute bien le programme.

  - Compilez maintenant votre programme en version native, en utilisant `ocamlopt` au lieu de `ocamlc`. Quel est alors le nom des fichiers objets générés ?

#### Compilation séparée automatique

Des outils très commodes existent pour automatiser la compilation de votre programme OCaml, comme par exemple `dune` et `ocamlbuild`. Le plus en vogue actuellement est `dune`, nous ne parlerons ici que de celui-ci.

  - Commencer par nettoyer en supprimant tout fichier objet `.cm*` et `.o` qui existerait encore au même endroit, ainsi que les binaires obtenus auparavant (`monprog`, etc).
  
  - Créer un fichier nommé `dune` contenant la simple ligne `(executable (name main))` indiquant que ce programme est composé de `main.ml` et de ses dépendances (qui seront découvertes automatiquement). 
  
  - Compiler votre programme via la commande `dune build main.exe`. Oui, avec une extension `.exe`, même si on n'est pas sous windows, c'est la convention de nommage de `dune`. Notez alors l'apparition d'un sous-répertoire temporaire `_build` contenant les fichiers produits par `dune` (par exemple `_build/log` énumerant les commandes effectuées par `dune`). Ne pas modifier de fichiers de ce sous-répertoire, et ne jamais ajouter ce `_build` dans un dépôt git.
  
  - Exécuter votre programme via la commande `dune exec -- ./main.exe`.

  - Vérifier si le binaire produit (`main.exe` quelque-part dans dans `_build`) est du code natif ("assembleur") ou du code-objet ("bytecode"). Comparer avec le fichier produit par `dune build main.bc`.

#### Les fichiers signatures .mli

Créer en plus des fichiers signatures (ou interface) `plus.mli`, `fois.mli` et `puis.mli`. Que faut-il y mettre pour que la compilation de notre programme continue à bien se passer ?

Note : sous emacs, le raccourci `ctrl-c ctrl-a` permet de passer facilement d'un fichier OCaml à son interface et vice-versa.

#### Compilation via make

Il peut être pratique de "piloter" la compilation `dune` via l'outil `make`. Cela permet de raccourcir la commande à taper, et d'éviter de mémoriser certains détails. Pour cela créer un fichier nommé `Makefile` contenant ce qui suit (attention à bien mettre des tabulations au début des lignes en retrait):

```make
binary:
    dune build main.exe

byte:
    dune build main.bc
    
clean
    dune clean
```

**Exercice**: tester maintenant l'effet des commandes `make` puis `make byte` puis `make clean`.

#### Compilation depuis emacs

Dans emacs, le menu "Tools/Compile" (raccourci par défaut `ctrl-c ctrl-c`) permet de lancer une compilation depuis emacs, sans aller dans un shell.
Intérêt : en cas d'erreur, emacs peut nous positionner rapidement à la ligne de l'erreur (cliquer sur la ligne soulignée dans le message d'erreur, ou utiliser `M-x next-error` (NB: `M-x` est souvent `Alt-x`).

Par défaut, le "Compile" d'emacs propose la commande `make -k`. Si on a créé un `Makefile` à l'étape précédente, cette commande ira très bien. Sinon on peut la remplacer par ce qu'on souhaite (par exemple `dune build main.exe`).

Pour se simplifier la répétition "sauver / compiler / aller à l'erreur", vous pouvez ajouter les lignes suivantes dans la configuration d'emacs (p.ex. dans `~/.emacs`. Elles associent les raccourcis F2, F3, F4 respectivement aux actions "sauver", "recompiler", "aller à l'erreur" :

```elisp
(global-set-key [(f2)] 'save-buffer)
(global-set-key [(f3)] 'recompile)
(global-set-key [(f4)] 'next-error)
```

Fermer et relancer emacs après ce changement dans sa configuration.

Modifier ensuite votre programme (si possible avec une erreur ;-), recompiler et aller à cette erreur avec `next-error` et la corriger.

#### Le debugger : ocamldebug

Quand le comportement d'un programme devient trop énigmatique et que quelques `print` insérés ici ou là ne suffisent plus à s'y retrouver, il est tant d'utiliser le debugger OCaml nommé `ocamldebug`. Il peut s'utiliser seul, mais là encore s'en servir depuis emacs aide beaucoup.

 - Tout d'abord, compiler en version bytecode, par exemple avec `make byte` vu auparavant
 
 - Depuis emacs, lancer `M-x camldebug` (NB: `M-x` est souvent `Alt-x`).
   * A la question "Run ocamldebug on file:", indiquer `_build/default/main.bc`
   * A la question "Args for main.bc:", laisser vide et juste taper Entrée
   * A la question "OCaml debugger to run: " laiser le choix par défaut ocamldebug et taper Entrée
   
 - On arrive alors sur le prompt d'ocamldebug. La première chose à faire avant de lancer le programme est souvent de poser un "breakpoint", en aller dans un fichier source et en utilisant le raccourci `ctrl-x ctrl-a ctrl-b` à l'endroit voulu. Ensuite, de retour dans la console d'ocamldebug, on va pouvoir taper des commandes comme: 
 
   * `run` pour lancer le programme (qui va normalement s'arrêter sur notre breakpoint)
   * `step` ou `s` pour avancer d'un pas
   * `back` ou `b` pour reculer (et oui, c'est un debugger bidirectionnel)
   * `print ...` pour afficher une variable
   * et bien d'autres choses, voir <http://caml.inria.fr/pub/docs/manual-ocaml/debugger.html>
 
**Exercice:** suivre le déroulement du coeur de votre programme à l'aide du debugger.
