let append p path =
  let open Fpath in
  let open Result_fn in
  lift2 (//) (of_string path) (of_string p)
  >|= normalize
  >|= to_string
