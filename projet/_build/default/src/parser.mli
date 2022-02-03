
(* The type of tokens. *)

type token = 
  | TIMES
  | SUBST
  | SOLVE
  | SIMPL
  | RPARA
  | PLUS
  | PLOT
  | OP1 of (Syntax.op1)
  | OP0 of (Syntax.op0)
  | MINUS
  | LPARA
  | INTEG
  | INT of (int)
  | IDENT of (string)
  | EVAL
  | EOL
  | DIV
  | DERIVE
  | COL

(* This exception is raised by the monolithic API functions. *)

exception Error

(* The monolithic API. *)

val expr: (Lexing.lexbuf -> token) -> Lexing.lexbuf -> (Syntax.expr)

val command: (Lexing.lexbuf -> token) -> Lexing.lexbuf -> (Syntax.cmd)
