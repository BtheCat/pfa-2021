
let cons x l = x::l

let decons = function
| [] -> raise Not_found
| x::l -> (x,l)

let nth l n =
  try List.nth l n
  with _ -> raise Not_found
