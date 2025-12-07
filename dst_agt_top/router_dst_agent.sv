class router_dst_agent extends uvm_agent;
	`uvm_component_utils(router_dst_agent)
	dst_agt_cfg dst_cfg;
	router_dst_driver drv;
	router_dst_monitor mon;
	router_dst_sequencer seqr;

	function new(string name = "router_dst_agent", uvm_component parent = null);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		if(!uvm_config_db#(dst_agt_cfg)::get(this,"","dst_agt_cfg",dst_cfg))
			`uvm_fatal(get_type_name(),"config_db GET() method failed for dst_cfg")
		super.build_phase(phase);
		mon = router_dst_monitor::type_id::create("mon",this);
		if(dst_cfg.is_active == UVM_ACTIVE)
		begin
			drv = router_dst_driver::type_id::create("drv",this);
			seqr = router_dst_sequencer::type_id::create("seqr",this);
		end
	endfunction

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		if(dst_cfg.is_active == UVM_ACTIVE)
			drv.seq_item_port.connect(seqr.seq_item_export);
	endfunction
endclass
