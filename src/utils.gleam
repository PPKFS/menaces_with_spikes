import gleam/erlang/process
import gleam/otp/actor
import gleam/result
import gleam/iterator

pub fn init_fail_error(result: Result(a, b), msg: String) -> Result(a, actor.StartError) {
  result.map_error(result, fn(_x) { actor.InitFailed(process.Abnormal(msg)) })
}

pub fn take_list(iter: iterator.Iterator(a), n: Int) -> List(a) {
  iter
  |> iterator.take(n)
  |> iterator.to_list
}

pub fn trust_me(result: Result(a, b)) -> a {
  let assert Ok(a) = result
  a
}