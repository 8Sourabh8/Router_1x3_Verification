class router_dst_sequencer extends uvm_sequencer#(dst_xtn);
	`uvm_component_utils(router_dst_sequencer)
	
	function new(string name = "router_dst_component", uvm_component parent = null);
		super.new(name,parent);
	endfunction
endclass
