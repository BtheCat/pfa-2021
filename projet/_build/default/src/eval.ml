let eval_op0 = function 
  | Pi  -> Float.pi 
  | E   -> exp 1.

let eval_op1 op v = match op with
  | Sqrt    -> sqrt v 
  | Exp     -> exp v 
  | Log     -> log v
  | Sin     -> sin v 
  | Cos     -> cos v 
  | Tan     -> tan v 
  | ASin    -> asin v 
  | ACos    -> acos v 
  | ATan    -> atan v 
  | UMinus  -> -. v 

let eval_op2 op v1 v2 = match op with 
  | Plus  -> v1 +. v2 
  | Mult  -> v1 *. v2 
  | Minus -> v1 -. v2 
  | Div   -> v1 /. v2 
  | Expo  -> v1 ** v2 

let rec eval = function 
  | Num n               -> float_of_int n 
  | Var x               -> assert false
  | App0 op0            -> eval_op0 op0 
  | App1 (op1, e)       -> eval_op1 op1 (eval e)
  | App2 (op2, e1, e2)  -> eval_op2 op2 (eval e1) (eval e2)