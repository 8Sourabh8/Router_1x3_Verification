module top;
	import uvm_pkg::*;
	import router_pkg::*;
	`include "uvm_macros.svh"

	bit clock;
	parameter cycle = 10;
	always #(cycle/2) clock = ~clock;

	router_if sif(clock);
	router_if dif0(clock);
	router_if dif1(clock);
	router_if dif2(clock);
	
	router_top DUT(clock,sif.resetn,sif.pkt_valid,sif.data_in,dif0.read_enb,dif1.read_enb,dif2.read_enb,dif0.valid_out,dif1.valid_out,dif2.valid_out,dif0.data_out,dif1.data_out,dif2.data_out,sif.error,sif.busy);

	initial begin
		uvm_config_db#(virtual router_if)::set(null,"*","sif0",sif);
		uvm_config_db#(virtual router_if)::set(null,"*","dif0",dif0);
		uvm_config_db#(virtual router_if)::set(null,"*","dif1",dif1);
		uvm_config_db#(virtual router_if)::set(null,"*","dif2",dif2);

		run_test();
	end

	initial begin
		`ifdef VCS
        	$fsdbDumpvars(0, top);
        	`endif
	end
endmodule
