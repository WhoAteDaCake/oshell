
let run out path args =
  let open Lwt.Infix in
  let open Filename in
  match args with
  | dir :: [] -> Lwt.return () 
  (* Lwt. *)
  (* Should return an error *)
  | _ -> Lwt.return ()