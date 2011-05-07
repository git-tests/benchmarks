`timescale 1ns/1ns

module \fmc_tlu_2-5ns_delay  (out, \out* , in, \in*  );
// generated by  HDL Direct 16.3-S013 (v16-3-85Y) 7/19/2010
// on Sat Mar 26 20:11:59 2011
// from fmc_tlu_v1_lib/FMC_TLU_2-5NS_DELAY/sch_1

  output  out;
  output  \out* ;
  input  in;
  input  \in* ;

  wire  page1_in;
  wire  \page1_in* ;
  wire  page1_out;
  wire  \page1_out* ;

  assign page1_in = in;
  assign \page1_in*  = \in* ;
  assign page1_out = out;
  assign \page1_out*  = \out* ;

  assign out  = in;
  assign \out*   = \in* ;

// begin instances 

endmodule // \fmc_tlu_2-5ns_delay (sch_1) 