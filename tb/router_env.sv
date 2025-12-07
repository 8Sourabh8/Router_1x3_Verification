class router_env extends uvm_env;
	`uvm_component_utils(router_env)
	router_env_cfg env_cfg;
	router_src_top src_top;
	router_dst_top dst_top;
	router_scoreboard sco;
	router_virtual_sequencer v_seqr;

	function new(string name = "router_env", uvm_component parent = null);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		if(!uvm_config_db#(router_env_cfg)::get(this,"","router_env_cfg",env_cfg))
			`uvm_fatal(get_type_name(),"config_db GET() method failed for env config")
		super.build_phase(phase);
		src_top = router_src_top::type_id::create("src_top",this);
		dst_top = router_dst_top::type_id::create("dst_top",this);
		if(env_cfg.has_scoreboard)
			sco = router_scoreboard::type_id::create("sco",this);
		if(env_cfg.has_virtual_sequencer)
			v_seqr = router_virtual_sequencer::type_id::create("v_seqr",this);
	endfunction

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		foreach(v_seqr.src_seqr[i])
			v_seqr.src_seqr[i] = src_top.src_agt[i].seqr;
		foreach(v_seqr.dst_seqr[i])
			v_seqr.dst_seqr[i] = dst_top.dst_agt[i].seqr;

		foreach(src_top.src_agt[i])
			src_top.src_agt[i].mon.src2sco.connect(sco.src2sco[i].analysis_export);
		foreach(dst_top.dst_agt[i])
			dst_top.dst_agt[i].mon.dst2sco.connect(sco.dst2sco[i].analysis_export);
	endfunction
endclass
