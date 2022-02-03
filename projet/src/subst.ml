let rec subst e x e' = match e with 
  | Num _ | App0 _ -> e 
  | Var y -> if y = x then e' else e 
  | App1 (op, e) -> App1 (op, subst e x e')
  | App2 (op, e1, e2) -> App2 (op, subst e1 x e', subst e2 x e') 