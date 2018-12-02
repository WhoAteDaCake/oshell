open Result

let (>>=) a f = match a with
| Error(e) -> Error e
| Ok(a) -> f a

let (>|=) a f = match a with
| Error(e) -> Error e
| Ok(a) -> Ok (f a)

let lift2 f ra rb =
  ra >>= (fun a -> rb >|= (fun b -> f a b))

let fp_to_lwt = function
| Ok(a) -> Lwt_result.return a
| Error(`Msg m) -> Lwt_result.fail m
