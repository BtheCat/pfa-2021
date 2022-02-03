
(* Q1 *)

module Mfloat =
  struct
    type t = float
    let un = 1.0
    let plus = (+.)
    let prod = ( *. )
  end

(* Q2 *)

module type MONNAIE =
  sig
    type t
    val un  : t
    val plus : t -> t -> t
    val prod : float -> t -> t
  end

module Euro = (Mfloat : MONNAIE)
module Dollar = (Mfloat : MONNAIE)

(* Q3 *)

(*
Pour illustrer l'incompatibilité de typage, essayer par exemple
`let _ = Euro.plus Euro.un Dollar.un` et vérifier qu'OCaml rejette
bien cette phrase.
*)

(* Q4 *)

let euro x = Euro.prod x Euro.un
let _ = Euro.plus (euro 10.0) (euro 20.0)

(* Q5 *)

module type BUREAU_DE_CHANGE =
  sig
    module Euro : MONNAIE
    module Dollar : MONNAIE
    val euro_to_dollar : Euro.t -> Dollar.t
    val dollar_to_euro : Dollar.t -> Euro.t
  end

(* Q6 *)

module BureauDeChange : BUREAU_DE_CHANGE =
  struct
    module Euro = Mfloat
    module Dollar = Mfloat
    let un_euro_en_dollar = 0.95
    let euro_to_dollar x = x /. un_euro_en_dollar
    let dollar_to_euro x = x *. un_euro_en_dollar
  end

(* On peut alors donner de nouvelles definitions pour Euro
   et Dollar (incompatibles avec celles de l'exo 1) *)
module Euro = BureauDeChange.Euro
module Dollar = BureauDeChange.Dollar

let euro x = Euro.prod x Euro.un
let deux_euro = euro 2.0
let deux_euro_en_dollar = BureauDeChange.euro_to_dollar deux_euro

(* Q7 *)

module type MPLUS =
  sig
    type t
    val plus : t -> t -> t
  end

(* Q8 *)

module Mplus = (Euro : MPLUS with type t = Euro.t)

(* Q9 *)

(* Le 'with' précédent est essentiel pour pouvoir ecrire ceci: *)
let _ = Mplus.plus Euro.un Euro.un
(* Par contre ce code donne bien une erreur: *)
(* let _ = MPlus.plus Euro.un 1.0 *)

(* Q10 *)

module type CLIENT =            (* vue donnée au client *)
  sig
    type t
    type monnaie
    val depot : t -> monnaie -> monnaie
    val retrait : t -> monnaie -> monnaie
  end

module type BANQUE =            (* vue du banquier *)
  sig
    type t
    type monnaie
    val creer : unit -> t
    val depot : t -> monnaie -> monnaie
    val retrait : t -> monnaie -> monnaie
  end

(* on pourrait aussi ecrire
module type BANQUE =
  sig
    include CLIENT
    val creer: unit -> t
  end
 *)

(* Q11 *)

module Banque (M : MONNAIE) :
    BANQUE with type monnaie = M.t =
  struct
    type monnaie = M.t and t = monnaie ref
    let zero = M.prod 0.0 M.un and neg = M.prod (-1.0)
    let creer () =  ref zero
    let depot c x =
      if x > zero then c := M.plus !c x; !c
    let retrait c x =
      if !c > x then (c := M.plus !c (neg x); !c) else zero
  end

(* Q12 *)

module Toto = Banque (Euro)

(* Q13 *)

module Client = (Toto : CLIENT
     with type monnaie = Toto.monnaie
     with type t = Toto.t)

let mon_ccp = Toto.creer ()
let _ = Toto.depot mon_ccp (euro 100.0)
let _ = Client.depot mon_ccp (euro 100.0)

(* Q14 *)

module Citybank = Banque (Dollar)
let mon_compte_aux_US = Citybank.creer ()

(* Verification de l'incompatibilite *)
(* let _ = Citybank.depot mon_ccp                         *)
(* let _ = Citybank.depot mon_compte_aux_US (euro 100.0)  *)

