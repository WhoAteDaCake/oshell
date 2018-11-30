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

let no_runner out path args = Lwt.return ()

let handle command =
  match String.split_on_char ' ' command with
  | [] ->  (no_runner, [])
  | cmd :: args ->
    match cmd with
    | "ls" -> (Ls.run, args) 
    | _ -> (no_runner, args)

let rec main path = 
  let open Lwt.Infix in
  let out = Lwt_io.stdout in
  cmd_line path out
  >>= (fun _ -> Lwt_io.read_line Lwt_io.stdin)
  >|= handle
  >>= (fun (runner, args) -> runner out path args)
  >>= (fun _ -> main path)