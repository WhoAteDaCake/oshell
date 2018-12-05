(* let () =
  Lwt_main.run (Lib.Util.hello ()) *)

let () = 
  let cwd = Sys.getcwd () in
  Lwt_main.run (Lib.Main.main { path = cwd; history = []; out = Lwt_io.stdout; input = Lwt_io.stdin }) 
