class router_dst_top extends uvm_env;
	`uvm_component_utils(router_dst_top)
	router_dst_agent dst_agt[];
	router_env_cfg env_cfg;

	function new(string name = "router_dst_top", uvm_component parent = null);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		if(!uvm_config_db#(router_env_cfg)::get(this,"","router_env_cfg",env_cfg))
			`uvm_fatal(get_type_name(),"config_db GET() method failed for env_cfg")
		super.build_phase(phase);
		dst_agt = new[env_cfg.no_of_dst];
		foreach(dst_agt[i])
		begin
			dst_agt[i] = router_dst_agent::type_id::create($sformatf("dst_agt[%0d]",i),this);
			uvm_config_db#(dst_agt_cfg)::set(this,$sformatf("dst_agt[%0d]*",i),"dst_agt_cfg",env_cfg.dst_cfg[i]);
		end
	endfunction	
endclass
