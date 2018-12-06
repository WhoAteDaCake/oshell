(*
 let cmd_line path out = 
  let open Lwt.Infix in
  Lwt_io.fprint out (pretify path)
  >>= (fun _ -> Lwt_io.flush out)
  *)
open State

let suffix_char s c = s ^ String.make 1 c

(*
 * str - accumulated command string
 * i - current history index
 * *)
let rec read state str i =
  let open Lwt.Infix in
  Lwt_io.read ~count:1 state.input
  >>=
    (function
      | "" -> print_endline "none";Lwt.return str
      (*| Some(c) -> read state (suffix_char str c) i)*)
      | c -> print_endline ("some: " ^ c);read state (str ^ " " ^ c) i)
          (*match c with
          | a -> read state (suffix_char str a) i)*)

let run state = read state "" (-1)
