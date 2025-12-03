open Hardcaml

module Sim = Cyclesim.With_interface(Design.I)(Design.O)

let () =
  let sim = Sim.create (Design.create (Scope.create ())) in

  let i = {
    Design.I.
    clock  = Cyclesim.in_port sim "clock";
    clear  = Cyclesim.in_port sim "clear";
    button= Cyclesim.in_port sim "button";
  } in

  let o = {
    Design.O.
    inner = Cyclesim.out_port sim "inner";
    outer = Cyclesim.out_port sim "outer";
  } in

  let step sensor_val =
    i.button := Bits.of_int ~width:1 sensor_val;
    i.clear  := Bits.zero 1;

    Cyclesim.cycle sim;

    let result = Bits.to_int !(o.inner) in
    let outer = Bits.to_int !(o.outer) in
    Printf.printf "Sensor: %d | Count: %d %d\n" sensor_val result outer
  in

  print_endline "--- Simulation Start ---";
  step 0;
  step 1; (* Person walks in *)
  step 1; (* Person still walking *)
  step 0; (* Person still walking *)
  step 1;
  step 0; (* Person leaves *)
  step 1;
  step 1;
  step 0;
  step 1; (* Second person *)
  step 0
