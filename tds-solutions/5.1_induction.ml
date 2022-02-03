let rec rev = function
  | [] -> []
  | a::l' -> (rev l')@[a]
let rec rev_append l1 l2 = match l1 with
  | [] -> l2
  | a::l1' -> rev_append l1' (a::l2)
let revopt l = rev_append l []

(*
Si on essaie de prouver directement la propriété voulue par
récurrence sur `l`, on se retrouve rapidement coincé: dans le cas de
récurrence, `revopt (a::l') = rev_append l' [a]` alors que l'hypothèse
de récurrence nous parle de `revopt l' = rev_append l' []`, et on n'a
pas de lien évident entre les deux.

La clé, c'est de prouver une propriété intermédiaire **plus générale**
que l'énoncé demandé: on va exprimer `rev_append` en fonction de
`rev` (et `@`) dans *tous* les cas, pas seulement pour `acc=[]`.
Nommons `P(l)` la propriété `∀ acc, rev_append l acc = rev l @ acc`.
On prouve `P(l)` pout tout `l` par récurrence sur `l` (en
gardant bien `acc` quelconque dans `P`, c'est important).

  - Pour le cas de base, il faut prouver `P([])`. Or pour tout `acc`,
    on a `rev_append [] acc = acc` et `rev [] @ acc = [] @ acc =
    acc`. Tout ceci provient des définitions des fonctions en
    questions.

  - Pour le cas de récurrence, il faut prouver `P(a::l')`, tout en
    disposant de l'hypothèse de récurrence (HR), ici `P(l')`.
    Or pour tout `acc`, on a `rev_append (a::l') acc = rev_append l' (a::acc)`.
    On profite d'un cas particulier de HR où on a choisi
    `a::acc` comme accumulateur, ce qui donne
    `rev_append l' (a::acc) = rev l' @ (a::acc)`. Ensuite, on réécrit
    `a::acc` en `[a]@acc` (calcul à l'envers), puis `rev l' @ ([a] @ acc)`
    en `(rev l' @ [a]) @ acc`. Ceci découle de l'associativité de
    `@` (qui se prouve également par récurrence...). Dans cette
    dernière version, on reconnait `rev (a::l') @ acc`, et c'est
    gagné.

Il reste maintenant à vérifier que `P(l)` implique bien la propriété
voulue au départ. Il suffit alors de choisir `acc=[]`, ce qui donne
`rev_append l [] = rev l @ []`. A gauche on reconnait `revopt l`, tandis
que la droite est égale à `rev l` (en utilisant la propriété
`∀ u, u @ [] = u` qui se prouve également par récurrence).
*)
