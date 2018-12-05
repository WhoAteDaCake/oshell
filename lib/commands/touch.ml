let not_found path =
  try
    if Sys.is_directory path then
      Lwt_result.fail "Can't touch a directory\n"
    else
      Lwt_result.fail "File already exists\n"
  with
    Sys_error(_) -> Lwt_result.return path

let create_file ?perm:(p=0o640) path =
  let open Lwt.Infix in
  let open Lwt_unix in
  openfile path [O_CREAT] p >>= close

let run args state =
  let open State in
  let open Lwt_result.Infix in
  match args with
  | path :: rest ->  
    Result_fn.fp_to_lwt (Path.append path state.path)
    >>= not_found
    >>= (fun path -> Lwt.map (fun _ -> Ok state) (create_file path))
  | _ -> Lwt_result.fail "Expected path as argument\n"
