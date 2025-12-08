open Hardcaml

module Sim = Cyclesim.With_interface(Design.I)(Design.O)

let () =
  let sim = Sim.create (Design.create (Scope.create ())) in

  let i = {
    Design.I.
    clock  = Cyclesim.in_port sim "clock";
    clear  = Cyclesim.in_port sim "clear";
  } in

  let o = {
    Design.O.
    red = Cyclesim.out_port sim "red";
    yellow = Cyclesim.out_port sim "yellow";
    green = Cyclesim.out_port sim "green";
  } in

  let step () =
    i.clear  := Bits.zero 1;

    Cyclesim.cycle sim;

    let r = Bits.to_int !(o.red) in
    let y = Bits.to_int !(o.yellow) in
    let g = Bits.to_int !(o.green) in
    Printf.printf "r: %d | y: %d | g: %d\n" r y g
  in

  print_endline "--- Simulation Start ---";
  for _ = 1 to 20 do step () done
