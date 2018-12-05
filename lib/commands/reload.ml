(**
  Currently only supports windows.
  Approach taken from:
  https://stackoverflow.com/questions/933850/how-do-i-find-the-location-of-the-executable-in-c 
 *)
let script_file = Unix.readlink "/proc/self/exe"

let run args state = 
  Unix.execv script_file [||] |> ignore;
  (* If execv works, this will never execute *)
  Lwt_result.return state
