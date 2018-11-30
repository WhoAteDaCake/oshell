let cmd_prefix path = path ^ " $ "

let cmd_line path out = 
  let open Lwt.Infix in
  Lwt_io.fprint out (cmd_prefix path)
  >>= (fun _ -> Lwt_io.flush out)

let rec main path = 
  let open Lwt.Infix in
  cmd_line path Lwt_io.stdout
  >>= (fun c -> Lwt_io.read_line Lwt_io.stdin)
  >>= (fun c -> main path)