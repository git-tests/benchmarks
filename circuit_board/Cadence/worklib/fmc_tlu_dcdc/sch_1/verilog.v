`timescale 1ns/1ns

module fmc_tlu_dcdc ();
// generated by  HDL Direct 16.3-S013 (v16-3-85Y) 7/19/2010
// on Tue Mar 15 17:28:21 2011
// from fmc_tlu_v1_lib/FMC_TLU_DCDC/sch_1

  // global signal glbl.gnd_signal;
  // global signal glbl.m5v;
  // global signal glbl.p2v5;
  // global signal glbl.p5v;

  wire  gnd_signal;
  wire  page1_gnd_signal;
  wire  m5v;
  wire  page1_m5v;
  wire  p2v5;
  wire  page1_p2v5;
  wire  p5v;
  wire  page1_p5v;

  assign gnd_signal = glbl.gnd_signal;
  assign page1_gnd_signal = gnd_signal;
  assign m5v = glbl.m5v;
  assign page1_m5v = m5v;
  assign p2v5 = glbl.p2v5;
  assign page1_p2v5 = p2v5;
  assign p5v = glbl.p5v;
  assign page1_p5v = p5v;

  assign p5v  = glbl.p5v;
  assign m5v  = glbl.m5v;
  assign gnd_signal  = glbl.gnd_signal;
  assign p2v5  = glbl.p2v5;

// begin instances 

  capcersmdcl2 page1_i39  (.a({glbl.gnd_signal}),
	.b({glbl.p5v}));
  defparam page1_i39.size = 1;

  capcersmdcl2 page1_i40  (.a({glbl.gnd_signal}),
	.b({glbl.p5v}));
  defparam page1_i40.size = 1;

  capcersmdcl2 page1_i41  (.a({glbl.gnd_signal}),
	.b({glbl.p5v}));
  defparam page1_i41.size = 1;

  capcersmdcl2 page1_i43  (.a({glbl.gnd_signal}),
	.b({glbl.m5v}));
  defparam page1_i43.size = 1;

  capcersmdcl2 page1_i44  (.a({glbl.gnd_signal}),
	.b({glbl.m5v}));
  defparam page1_i44.size = 1;

  capcersmdcl2 page1_i46  (.a({glbl.gnd_signal}),
	.b({glbl.p2v5}));
  defparam page1_i46.size = 1;

  capcersmdcl2 page1_i47  (.a({glbl.gnd_signal}),
	.b({glbl.p2v5}));
  defparam page1_i47.size = 1;

  lt3471 page1_i48  (.fb1(/* unconnected */),
	.\fb1* (/* unconnected */),
	.fb2(/* unconnected */),
	.\fb2* (/* unconnected */),
	.\shdn/ss1* (/* unconnected */),
	.\shdn/ss2* (/* unconnected */),
	.sw1(/* unconnected */),
	.sw2(/* unconnected */),
	.vin(/* unconnected */),
	.vref(/* unconnected */));

  inductance page1_i49  (.a(/* unconnected */),
	.b(/* unconnected */));
  defparam page1_i49.size = 1;

endmodule // fmc_tlu_dcdc(sch_1) 
