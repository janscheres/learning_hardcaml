open Hardcaml

module Sim = Cyclesim.With_interface(Design.I)(Design.O)

let () =
  let sim = Sim.create (Design.create (Scope.create ())) in

  let i = {
    Design.I.
    clock  = Cyclesim.in_port sim "clock";
    clear  = Cyclesim.in_port sim "clear";
    sensor = Cyclesim.in_port sim "sensor";
  } in

  let o = {
    Design.O.
    count = Cyclesim.out_port sim "count";
  } in

  let step sensor_val =
    i.sensor := Bits.of_int ~width:1 sensor_val;
    i.clear  := Bits.zero 1;

    Cyclesim.cycle sim;

    let result = Bits.to_int !(o.count) in
    Printf.printf "Sensor: %d | Count: %d\n" sensor_val result
  in

  print_endline "--- Simulation Start ---";
  step 0;
  step 1; (* Person walks in *)
  step 1; (* Person still walking *)
  step 1;
  step 0; (* Person leaves *)
  step 0;
  step 1; (* Second person *)
  step 0
