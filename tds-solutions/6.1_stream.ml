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

let of_list l = List.fold_right MyStream.cons l MyStream.empty

let rec take n s =
  if n = 0 then []
  else
    try let (x,s') = MyStream.get s in x :: take (n-1) s'
    with Empty -> []

let rec from n = lazy (MyStream.Cons (n, from (n+1)))

type 'a seq = unit -> 'a cell
and 'a cell = Cons of 'a * 'a seq

let rec seq_to_stream s =
  lazy
    (match s () with Cons (x,s') -> MyStream.Cons (x, seq_to_stream s'))

let rec stream_to_seq s =
  fun () ->
  match s with lazy (MyStream.Cons (x,s')) -> Cons (x, stream_to_seq s')

type 'a streamlike = 'a future ref
and 'a future =
  | Later of (unit -> 'a * 'a streamlike)
  | Done of 'a * 'a streamlike

let streamlike_make next = ref (Later next)

let streamlike_get s =
  match !s with
  | Done (x,s') -> x, s'
  | Later f ->
     let x,s' = f () in
     s := Done (x,s');
     x,s'
