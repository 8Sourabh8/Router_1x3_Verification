class src_agt_cfg extends uvm_object;
	`uvm_object_utils(src_agt_cfg)
	uvm_active_passive_enum is_active;
	virtual router_if vif;
	
	function new(string name = "src_agt_cfg");
		super.new(name);
	endfunction
endclass
