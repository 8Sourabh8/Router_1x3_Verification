class router_env_cfg extends uvm_object;
	`uvm_object_utils(router_env_cfg)
	int no_of_src;
	int no_of_dst;
	bit has_scoreboard;
	bit has_functional_coverage;
	bit has_virtual_sequencer;
	src_agt_cfg src_cfg[];
	dst_agt_cfg dst_cfg[];
	uvm_event_pool event_pool = uvm_event_pool::get_global_pool();
	
	function new(string name = "router_env_config");
		super.new(name);
	endfunction
endclass
