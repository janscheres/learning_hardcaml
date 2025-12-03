open Hardcaml
open Signal

module I = struct
  type 'a t = {
    clock : 'a;
    clear : 'a;
    sensor : 'a; [@bits 1] (* 1 bit: 0 = Empty, 1 = Person *)
  } [@@deriving sexp_of, hardcaml]
end

module O = struct
  type 'a t = {
    count : 'a; [@bits 8] 
  } [@@deriving sexp_of, hardcaml]
end

let create (_scope : Scope.t) (i : Signal.t I.t) =
  let spec = Reg_spec.create ~clock:i.clock ~clear:i.clear () in

  (* TODO: YOUR LOGIC HERE *)
  (* 1. Detect the rising edge (0 -> 1) of the sensor *)
  (* 2. Increment a counter only on that edge *)
  let last = Signal.reg spec i.sensor in

  let rising = last <: i.sensor in

  let current_count = Signal.reg_fb spec ~width:8 ~f:(fun d -> 
        mux2 rising
            (d+:. 1)
            d
    ) in


  { O.
    count = current_count
  }
