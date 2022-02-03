let rec derive e x = match e with 
  | Num _ -> Num 0
  | Var y -> if y = x then Num 1 else Num 0
  | App0 _ -> Num 0
  | App1 (op, e) -> derive_op1 op e x
  | App2 (op, e1, e2) -> derive_op2 op e1 e2 x

and derive_op1 op e x = match op with 
  | Sqrt -> App2 (Mult, App2 (Div, Num 1, Num 2),
                        App2 (Mult, derive e x, 
                                    App2 (Expo, e, 
                                                App1 (UMinus, App2 (Div, Num 1, Num 2))
                                         )
                              ) 
                 )
  | Exp -> App2 (Mult, derive e x, App1 (Exp, e))
  | Log -> App2 (Div, derive e x, e)
  | Sin -> App2 (Mult, derive e x, App1 (Cos, e))
  | Cos -> App1 (UMinus, App2 (Mult, derive e x, App1 (Sin, e)))
  | Tan -> App2 (Div, derive e x, 
                      App2 (Expo, App1 (Cos, e), Num 2))
  | ASin -> App2 (Div, derive e x, 
                       App1 (Sqrt, App2 (Minus, Num 1, 
                                                App2 (Expo, e, Num 2)
                                        )
                            )
                 )
  | ACos -> App2 (Div, App1 (UMinus, derive e x),
                      App1 (Sqrt, App2 (Plus, Num 1,
                                              App2 (Expo, e, Num 2)
                                        )
                            )
                )

  | ATan -> App2 (Div, derive e x,
                      App2 (Plus, Num 1, App2 (Expo, e, Num 2))
                )

  | UMinus -> App1 (Uminus, derive e x)

and derive_op2 op e1 e2 x = match op with 
  | Plus | Minus -> App2 (op, derive e1 x, derive e2 x)

  | Mult -> App2 (Plus, 
                    App2 (Mult, derive e1 x, e2),
                    App2 (Mult, e1, derive e2 x)
                 )

  | Div -> App2 (Div, 
                    App2 (Minus, 
                            App2 (Mult, derive e1 x, e2),
                            App2 (Mult, e1, derive e2 x)
                          ),
                    App2 (Expo, e2, Num 2)
                )

  | Expo -> e1
