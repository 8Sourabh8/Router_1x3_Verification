class dst_agt_cfg extends uvm_object;
	`uvm_object_utils(dst_agt_cfg)
	uvm_active_passive_enum is_active;
	virtual router_if vif;
	mailbox #(dst_xtn) mbx; 
	
	function new(string name = "dst_agt_cfg");
		super.new(name);
	endfunction

endclass


