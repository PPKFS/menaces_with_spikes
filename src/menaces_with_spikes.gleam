import gleam/io
import simplifile
import gleam/result
import gleam/list

import gleam/otp/supervisor
import gleam/otp/actor
import gleam/erlang/process
import gleam/string
import gleam/int
import utils.{init_fail_error}

type Token {
  id: String
}
// given a folder, we want to:
// run a supervisor that has 1 child per file
// loads each file, works out where to break the files
// makes a task for each child
pub fn main() {
  let assert Ok(filepaths) = simplifile.get_files(in: "raws/v50")
  io.debug("Found " <> int.to_string(list.length(filepaths)) <> " files.")
  let _res =
    supervisor.start(fn(children) {
      list.fold(filepaths, children, fn(c, path) {
        supervisor.add(c, supervisor.worker( fn(_)
          { use file_contents <- result.try(simplifile.read(path) |> init_fail_error(_, "Failed to read the file " <> path))
            io.debug("successfully read the file " <> path <> " of length " <> int.to_string(string.length(file_contents)))
            actor.start(file_contents, run_parse)
          }))
      })
    })
  process.sleep(1000)
}

fn run_parse(msg: a, s: state) -> actor.Next(a, state) {
  actor.continue(s)
}
