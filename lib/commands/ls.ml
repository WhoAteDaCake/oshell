let not_special_path p = p <> "." && p <> ".."

(* TODO: rewrite in using Lwt unix *)
let dir_entries path =
  let rec loop desc xs =
    match Unix.readdir desc with
    | exception End_of_file -> xs
    | entry -> loop desc (entry :: xs)
  in
  let handle = Unix.opendir path in
  let entries = loop handle [] in
  Unix.closedir handle;
  List.filter not_special_path entries

let run out path args = 
  let open Lwt.Infix in
  let entries = dir_entries path in
  Lwt_list.map_s (fun p -> Lwt_io.fprint out (p ^ " ")) entries
  >>= (fun _ -> Lwt_io.fprint out "\n")
  >>= (fun _ ->Lwt_result.return path)