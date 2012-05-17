
// generated by NetAssembler Version 16.3-P2 (v16-3-85A) 10/19/2009 
// on Thu Apr 12 14:57:33 2012


`timescale 1ns/1ns

`define scale_fs	* 0.000001000000000
`define scale_ps	* 0.001000000000000
`define scale_ns	* 1.000000000000000
`define scale_us	* 1000.000000000000000
`define scale_ms	* 1000000.000000000000000
`define scale_sec	* 1000000000.000000000000000
`define scale_min	* 60000000000.000000000000000
`define scale_hr	* 3600000000000.000000000000000



module alias_vector (a, a);
 parameter size = 1;
 inout [size-1:0] a;
endmodule

module alias_bit (a, a);
 inout a;
endmodule


module glbl ();
// Verilog global signals module 
  wire gnd_signal;
  wire p1v5a;
  wire p2v5;
  wire p3v3;
  wire p5v;
	supply1 supply_1;
endmodule
