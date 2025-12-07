class router_src_top extends uvm_env;
	`uvm_component_utils(router_src_top)
	router_src_agent src_agt[];
	router_env_cfg env_cfg;

	function new(string name = "router_src_top", uvm_component parent = null);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		if(!uvm_config_db#(router_env_cfg)::get(this,"","router_env_cfg",env_cfg))
			`uvm_fatal(get_type_name(),"config_db GET() method failed for env_cfg")
		super.build_phase(phase);
		src_agt = new[env_cfg.no_of_src];
		foreach(src_agt[i])
		begin
			src_agt[i] = router_src_agent::type_id::create($sformatf("src_agt[%0d]",i),this);
			uvm_config_db#(src_agt_cfg)::set(this,$sformatf("src_agt[%0d]*",i),"src_agt_cfg",env_cfg.src_cfg[i]);
		end
	endfunction	
endclass
