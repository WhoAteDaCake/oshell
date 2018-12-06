open State
(* Needed for when path ends in / *)
let non_empty = List.filter (fun s -> String.length s <> 0)

let pretify path =
  let parts = String.split_on_char '/' path |> non_empty in
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

let no_runner _ state = Lwt_result.return state

let unknown_cmd cmd _ state =
  Lwt_result.fail (Printf.sprintf "command: '%s' not found\n" cmd)

let handle_cmd cmd =
  match String.split_on_char ' ' cmd with
  | [] ->  no_runner []
  | cmd :: args ->
    let runner = match cmd with
    | "ls" -> Ls.run
    | "cd" -> Cd.run
    | "reload" -> Reload.run 
    | "touch" -> Touch.run
    | cmd -> 
      if String.length cmd = 0 then
        no_runner
      else 
        unknown_cmd cmd
    in
    runner args


let handle_result state = function
| Ok(new_state) -> Lwt.return new_state
| Error(e) -> Lwt.bind (Lwt_io.fprint state.out e) (fun _ -> Lwt.return state)
  
let rec main state = 
  let open Lwt.Infix in
  cmd_line state.path state.out
  >>= (fun _ -> Read_cmd.run state)
  >>= (fun cmd -> (handle_cmd cmd) state)
  >>= handle_result state
  >>= main
