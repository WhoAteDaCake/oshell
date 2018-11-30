(* let () =
  Lwt_main.run (Lib.Util.hello ()) *)

let () = 
  let cwd = Sys.getcwd () in
  Lwt_main.run (Lib.Main.main cwd) 