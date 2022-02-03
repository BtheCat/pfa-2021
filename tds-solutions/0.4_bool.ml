let is_zero x = (x = 0)

let msg_zero x = if x = 0 then "zero" else "not zero"

let max3 a b c = max (max a b) c

let max4 a b c d = max (max a b) (max c d)

let checktauto f = f true && f false

(* ensuite on peut être bourrin ... *)
let checktauto2 f =
 f true true && f true false && f false true && f false false
(* ... ou utiliser de l'application partielle et les fonctions précédentes *)
let checktauto2 f = checktauto (fun b -> checktauto (f b))
let checktauto3 f = checktauto (fun b -> checktauto2 (f b))
(* ... idem en plus joli avec une fonction de composition: *)
let ($) f g = fun x -> f (g x)
let checktauto2 f = checktauto (checktauto $ f)
let checktauto3 f = checktauto (checktauto2 $ f)

let f x y z = match x, y, z with
  | _ , false , true -> 1
  | false , true , _ -> 2
  | _ , _ , false -> 3
  | _ , _ , true -> 4

(* Une manière d'écrire g (il y en a d'autres!) *)
let g x y z =
  if z && not y then 1
  else if y && not x then 2
  else if z then 4 else 3

(* vérifions que f et g sont bien d'accord partout : *)
let _ = checktauto3 (fun x y z -> f x y z = g x y z)
