open Lwt.Infix

(* let update_dir path = Lwt.map (Lwt_unix.chdir path) (fun _ -> path)  *)

let run out path args =
  match args with
  | dir :: xs ->
    Result_fn.fp_to_lwt (Path.append dir path)
    (* let new_path = Result_fn.fp_to_lwt (Path.append dir path) in
    (* Lwt_result.bind new_path update_dir *)
    new_path *)
  | _ -> Lwt_result.fail "Please supply a directory\n"
