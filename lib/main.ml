let pretify path =
  let parts = String.split_on_char '/' path in
  let partial = match List.rev parts with
  | x :: [] -> "/" ^ x
  | x :: y :: xs -> y ^ "/" ^ x
  (* Shouldn't really ever hapen with linux paths *)
  | _ -> "unknown"
  in
  Printf.sprintf "[%s] $" partial


let cmd_line path out = 
  let open Lwt.Infix in
  Lwt_io.fprint out (pretify path)
  >>= (fun _ -> Lwt_io.flush out)

let rec main path = 
  let open Lwt.Infix in
  cmd_line path Lwt_io.stdout
  >>= (fun c -> Lwt_io.read_line Lwt_io.stdin)
  >>= (fun c -> main path)