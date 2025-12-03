open Hardcaml
open Signal

module I = struct
  type 'a t = {
    clock : 'a;
    clear : 'a;
    button: 'a; [@bits 1]
  } [@@deriving sexp_of, hardcaml]
end

module O = struct
  type 'a t = {
    inner : 'a[@bits 1];
    outer : 'a[@bits 1];
  } [@@deriving sexp_of, hardcaml]
end

let create (_scope : Scope.t) (i : Signal.t I.t) =
  let spec = Reg_spec.create ~clock:i.clock ~clear:i.clear () in

  (* TODO: YOUR LOGIC HERE *)
  (* 1. Detect the rising edge (0 -> 1) of the sensor *)
  (* 2. Increment a counter only on that edge *)
  let last = Signal.reg spec i.button in

  let pressed = last <: i.button in

  let state = Signal.reg_fb spec ~width:2 ~f:(fun d -> 
        mux2 pressed
            (d+:. 1)
            d
    ) in

  let state_is_one = state ==:. 1 in

  let state_is_three = state ==:. 3 in


  { O.
    inner =state_is_one;
    outer = state_is_three;
  }
