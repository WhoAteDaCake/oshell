let append p path =
  let open Fpath in
  let open Result_fn in
  lift2 (fun p path -> append p path) (of_string p) (of_string path)
  >|= to_string