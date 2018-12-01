open Result

let (>>=) a f = match a with
| Error(e) -> Error e
| Ok(a) -> f a

let (>|=) a f = match a with
| Error(e) -> Error e
| Ok(a) -> Ok (f a)

let lift2 f ra rb =
  ra >>= (fun a -> rb >|= (fun b -> f a b))