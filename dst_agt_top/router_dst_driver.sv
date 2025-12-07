class router_dst_driver extends uvm_driver#(dst_xtn);
	`uvm_component_utils(router_dst_driver)
	dst_agt_cfg cfg;
	virtual router_if.D_DRV_MP vif;
	router_env_cfg env_cfg;
	mailbox #(dst_xtn) mbx;

	function new(string name = "router_dst_driver", uvm_component parent = null);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		if(!uvm_config_db#(dst_agt_cfg)::get(this,"","dst_agt_cfg",cfg))
			`uvm_fatal(get_type_name(),"config_db GET() method failed for vif")
		if(!uvm_config_db#(router_env_cfg)::get(this,"","router_env_cfg",env_cfg))
			`uvm_fatal(get_type_name(),"config_db GET() method failed for env_cfg")
		this.mbx = cfg.mbx;
	endfunction

	function void connect_phase(uvm_phase phase);
		vif = cfg.vif;
	endfunction
	
	task drive_dut(dst_xtn tr);
		uvm_event e1 = env_cfg.event_pool.get("e1");
		if(tr.delay>30)
			mbx.put(tr);	
		while(vif.d_drv_cb.valid_out!==1)
			@(vif.d_drv_cb);
		//`uvm_info(get_type_name(),$sformatf("valid out : %0b",vif.d_drv_cb.valid_out),UVM_LOW)
		//`uvm_info(get_type_name(),$sformatf("Read seq driven \n %s",tr.sprint()),UVM_LOW)
		repeat(tr.delay)
			@(vif.d_drv_cb);
		vif.d_drv_cb.read_enb<= 1;
		//`uvm_info(get_type_name(),$sformatf("valid out : %0b",vif.d_drv_cb.valid_out),UVM_LOW)
		//`uvm_info(get_type_name(),$sformatf("Read signal made 1"),UVM_LOW)
		while(vif.d_drv_cb.valid_out!==0)
			@(vif.d_drv_cb);
		vif.d_drv_cb.read_enb<= 0;
		//`uvm_info(get_type_name(),$sformatf("Read seq DRIVEN \n %s",tr.sprint()),UVM_LOW)
		repeat(2)
			@(vif.d_drv_cb);
		e1.trigger();
	endtask
	
	task run_phase(uvm_phase phase);
		forever begin
			seq_item_port.get_next_item(req);
		//	mbx.put(req);	
			drive_dut(req);
			seq_item_port.item_done();
		end	
	endtask
endclass
