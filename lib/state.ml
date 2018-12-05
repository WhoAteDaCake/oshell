type state = 
  {
    history: string list;
    path: string;
    out: Lwt_io.output_channel
  }

let update_path state path = { state with path = path }

let update_history state entry = { state with history = entry :: state.history }
