class router_src_sequencer extends uvm_sequencer#(src_xtn);
	`uvm_component_utils(router_src_sequencer)
	
	function new(string name = "router_src_component", uvm_component parent = null);
		super.new(name,parent);
	endfunction
endclass
