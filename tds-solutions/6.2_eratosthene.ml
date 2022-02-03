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

(* Cf 6.1 *)

let rec take n s =
  if n = 0 then []
  else
    try let (x,s') = MyStream.get s in x :: take (n-1) s'
    with Empty -> []

let rec from n = lazy (MyStream.Cons (n, from (n+1)))

(* Une première solution simple pour no_multiple: *)

let rec no_multiple n s =
  let (x,s) = MyStream.get s in
  if x mod n = 0 then no_multiple n s
  else lazy (MyStream.Cons (x, no_multiple n s))

(* Si on veut éviter les modulo à chaque fois,
   on exploite le fait que s est croissant pour générer les multiples
   m de n les uns après les autres, et les enlever de s progressivement. *)

let no_multiple n s =
  let rec kill_next m s =
    let (x,s') = MyStream.get s in
    if x = m then kill_next (m+n) s'
    else if x < m then lazy (MyStream.Cons (x, kill_next m s'))
    else kill_next (m+n) s  (* ici x > m donc x peut encore être un multiple *)
  in kill_next n s

(* Au fait, que fait (no_multiple n s) si par malchanche la stream s
   ne contient que des multiples de n ? Et bien il bouclera (essayez !).
   On peut retarder cela via un `lazy` plus tôt:

   let rec no_multiple n s = lazy (no_multiple_cell n s)
   and no_multiple_cell n s = ...

   Mais c'est alors tout Lazy.force sur la stream produite qui divergera
   (p.ex. lors d'un take).
   Heureusement ce cas ne peut pas se produire lors du crible
   d'Eratosthène (pourquoi ?). *)

let sieve =
  let rec iter s =
    let (x,s) = MyStream.get s in
    lazy (MyStream.Cons (x, iter (no_multiple x s)))
  in iter (from 2)
