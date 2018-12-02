let pretify path =
  let parts = String.split_on_char '/' path in
  let partial = match List.rev parts with
    | x :: [] -> "/" ^ x
    | x :: y :: xs -> y ^ "/" ^ x
    (* Shouldn't really ever hapen with linux paths *)
    | _ -> "unknown"
    in
    Printf.sprintf "[%s] $ " partial


let cmd_line path out = 
  let open Lwt.Infix in
  Lwt_io.fprint out (pretify path)
  >>= (fun _ -> Lwt_io.flush out)

let no_runner out path args = Lwt_result.return path

let unknown_cmd cmd out path args =
  Lwt_result.fail (Printf.sprintf "command: '%s' not found\n" cmd)

let handle_cmd cmd =
  let open Lwt.Infix in
  match String.split_on_char ' ' cmd with
  | [] ->  (no_runner, [])
  | cmd :: args ->
    match cmd with
    (**
      TODO:
        Make sure all commands return Lwt_result type 
      *)
    | "ls" -> (Ls.run, args)
    | "cd" -> (Cd.run, args)
    | "reload" -> (Reload.run, args) 
    | cmd -> 
      if String.length cmd = 0 then
        (no_runner, args)
      else 
        (unknown_cmd cmd, args)


let handle_result out prev_path = function
| Ok(path) -> Lwt.return path
| Error(e) -> Lwt.bind (Lwt_io.fprint out e) (fun _ -> Lwt.return prev_path)
  
(* TODO:
  Create a record type that handles state changes.
    - Should contain path
      - This is needed for calling chdir if dir has changed
    - Command history
*)
let rec main path = 
  let open Lwt.Infix in
  let out = Lwt_io.stdout in
  cmd_line path out
  >>= (fun _ -> Lwt_io.read_line Lwt_io.stdin)
  >|= handle_cmd
  >>= (fun (runner, args) -> runner out path args)
  >>= handle_result out path
  >>= main
