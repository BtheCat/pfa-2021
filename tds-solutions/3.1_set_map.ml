
let eng_fra =
[ ("Monday","lundi");
("Tuesday", "mardi");
("Wednesday", "mercredi");
("Thursday", "jeudi");
("Friday", "vendredi");
("Saturday", "samedi");
("Sunday", "dimanche") ]

let rec powerlist = function
  | [] -> [[]]
  | x::l ->
     let ll = powerlist l in
     ll @ List.map (fun l -> x::l) ll

module Ints = Set.Make(struct type t = int let compare = compare end)

let powerset s =
  Ints.fold
    (fun x acc -> acc @ List.map (Ints.add x) acc) s
    [Ints.empty]

module Intss = Set.Make(Ints)

let powersetset s =
  Ints.fold
    (fun x acc -> Intss.union acc (Intss.map (Ints.add x) acc))
    s
    (Intss.singleton Ints.empty)

(* Map *)

let list_translate s = List.assoc s eng_fra

module StringMap = Map.Make(String)

let eng_fra_map =
  List.fold_left (fun acc (k,v) -> StringMap.add k v acc)
    StringMap.empty eng_fra

let map_translate s = StringMap.find s eng_fra_map

(* Hashtbl *)

module StringHashtbl =
  Hashtbl.Make
    (struct type t = string
            let equal = String.equal
            let hash = Hashtbl.hash end)

module H = StringHashtbl

let eng_fra_hash =
  let tbl = H.create 47 in
  let () = List.iter (fun (k,v) -> H.add tbl k v) eng_fra in
  tbl

let hash_translate s = H.find eng_fra_hash s

