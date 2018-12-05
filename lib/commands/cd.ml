open Lwt.Infix

let update_dir state = function
| Ok(path) ->
  Lwt_unix.chdir path
  >>= (fun _ -> Lwt_result.return (State.update_path state path))
| Error(e) -> Lwt_result.fail e

let run args state =
  let open State in
  match args with
  | dir :: xs ->
    Result_fn.fp_to_lwt (Path.append dir state.path)
    >>= update_dir state
  | _ -> Lwt_result.fail "Please supply a directory\n"
