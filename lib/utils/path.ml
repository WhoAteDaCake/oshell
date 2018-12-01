let append p path =
  let open Fpath in
  Result_fn.lift2 (fun p path -> append p path) (of_string p) (of_string path)
  |> to_string