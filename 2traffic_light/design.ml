open Hardcaml
open Signal

module I = struct
  type 'a t = {
    clock : 'a;
    clear : 'a;
  } [@@deriving sexp_of, hardcaml]
end

module O = struct
  type 'a t = {
    red: 'a[@bits 1];
    yellow: 'a[@bits 1];
    green: 'a[@bits 1];
  } [@@deriving sexp_of, hardcaml]
end

let create (_scope : Scope.t) (i : Signal.t I.t) =
  let spec = Reg_spec.create ~clock:i.clock ~clear:i.clear () in

  let time = Signal.reg_fb spec ~width:3 ~f:(fun d ->
      mux2 (d>=:. 7)
        (zero 3)
        d+:. 1
  ) in

  let state_is_r = time <=:. 3  in
  let state_is_y = time ==:. 4 in
  let state_is_g = time >=:. 5 in


  { O.
    red=state_is_r;
    yellow=state_is_y;
    green= state_is_g;
  }
