class router_virtual_sequencer extends uvm_sequencer#(uvm_sequence_item);
	`uvm_component_utils(router_virtual_sequencer)
	router_env_cfg cfg;
	router_src_sequencer src_seqr[];
	router_dst_sequencer dst_seqr[];

	function new(string name = "router_virtual_sequencer", uvm_component parent);
		super.new(name,parent);
	endfunction

	function  void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db#(router_env_cfg)::get(this,"","router_env_cfg",cfg))
			`uvm_info(get_type_name(),"config_db GET() method failed for env_cfg",UVM_LOW)
		src_seqr = new[cfg.no_of_src];
		dst_seqr = new[cfg.no_of_dst];
	endfunction
endclass
