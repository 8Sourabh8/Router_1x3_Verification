class router_src_agent extends uvm_agent;
	`uvm_component_utils(router_src_agent)
	src_agt_cfg src_cfg;
	router_src_driver drv;
	router_src_monitor mon;
	router_src_sequencer seqr;

	function new(string name = "router_src_agent", uvm_component parent = null);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		if(!uvm_config_db#(src_agt_cfg)::get(this,"","src_agt_cfg",src_cfg))
			`uvm_fatal(get_type_name(),"config_db GET() method failed for src_cfg")
		super.build_phase(phase);
		mon = router_src_monitor::type_id::create("mon",this);
		if(src_cfg.is_active == UVM_ACTIVE)
		begin
			drv = router_src_driver::type_id::create("drv",this);
			seqr = router_src_sequencer::type_id::create("seqr",this);
		end
	endfunction

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		if(src_cfg.is_active == UVM_ACTIVE)
			drv.seq_item_port.connect(seqr.seq_item_export);
	endfunction
endclass
