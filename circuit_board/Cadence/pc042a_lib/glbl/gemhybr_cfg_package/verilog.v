
// generated by NetAssembler Version 15.51-s002 12-Apr-2006 
// on Wed Jun 13 08:32:56 2007


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
  wire agnd;
  wire avdd;
  wire dgnd;
  wire dvdd;
endmodule
