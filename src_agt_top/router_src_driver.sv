class router_src_driver extends uvm_driver#(src_xtn);
	`uvm_component_utils(router_src_driver)
	src_agt_cfg cfg;
	virtual router_if.S_DRV_MP vif;
	router_env_cfg env_cfg;

	function new(string name = "router_src_driver", uvm_component parent = null);
		super.new(name,parent);
	endfunction
	
	function void build_phase(uvm_phase phase);
		if(!uvm_config_db#(src_agt_cfg)::get(this,"","src_agt_cfg",cfg))
			`uvm_fatal(get_type_name(),"config_db GET() method failed for vif")
		if(!uvm_config_db#(router_env_cfg)::get(this,"","router_env_cfg",env_cfg))
			`uvm_fatal(get_type_name(),"config_db GET() method failed for env_cfg")
	endfunction

	function void connect_phase(uvm_phase phase);
		vif = cfg.vif;
	endfunction

	task rst_dut();
		@(vif.s_drv_cb);
		vif.s_drv_cb.resetn <= 1'b0;
		@(vif.s_drv_cb);
		vif.s_drv_cb.resetn <= 1'b1;
	endtask
	task drive_dut(ref src_xtn tr);
		/*`uvm_info(get_type_name(),$sformatf("Packet driving started \n %0s",tr.sprint()),UVM_LOW)
		rst_dut(); // Router reset
		@(vif.s_drv_cb);
		wait(~vif.s_drv_cb.busy);
		vif.s_drv_cb.pkt_valid <= 1'b1;
		vif.s_drv_cb.data_in <= tr.header;
		`uvm_info(get_type_name(),$sformatf("Header Driven %8b",tr.header),UVM_LOW)
		@(vif.s_drv_cb);
			`uvm_info(get_type_name(),$sformatf(" Value of busy : %0b",vif.s_drv_cb.busy),UVM_LOW)
		@(vif.s_drv_cb);
			`uvm_info(get_type_name(),$sformatf(" Value of busy : %0b",vif.s_drv_cb.busy),UVM_LOW)
		foreach(tr.payload[i])
		begin
			vif.s_drv_cb.data_in <= tr.payload[i];
			`uvm_info(get_type_name(),$sformatf("Payload[%0d] Driven %2h",i,tr.payload[i]),UVM_LOW)
			//wait(~vif.s_drv_cb.busy);
			@(vif.s_drv_cb);
			`uvm_info(get_type_name(),$sformatf(" Value of busy : %0b",vif.s_drv_cb.busy),UVM_LOW)
			wait(~vif.s_drv_cb.busy);
		end
		vif.s_drv_cb.pkt_valid <= 1'b0;
		vif.s_drv_cb.data_in <= tr.parity;
		`uvm_info(get_type_name(),$sformatf("Parity Driven %2h",tr.parity),UVM_LOW)*/

		//rst_dut(); // Router reset
		uvm_event e1 = env_cfg.event_pool.get("e1");
		`uvm_info(get_type_name(),$sformatf("Packet driving started \n %0s",tr.sprint()),UVM_LOW)
		while(vif.s_drv_cb.busy!==1'b0)
		begin
			@(vif.s_drv_cb);
		end
		vif.s_drv_cb.pkt_valid <= 1'b1;
		vif.s_drv_cb.data_in <= tr.header;
		//`uvm_info(get_type_name(),$sformatf("Header Driven %8b",tr.header),UVM_LOW)
		@(vif.s_drv_cb);
		foreach(tr.payload[i])
		begin
			while(vif.s_drv_cb.busy!==1'b0)
			begin
				@(vif.s_drv_cb);
			end
			vif.s_drv_cb.data_in <= tr.payload[i];
			//`uvm_info(get_type_name(),$sformatf("Payload[%0d] Driven %2h",i,tr.payload[i]),UVM_LOW)
			@(vif.s_drv_cb);
		end	
		while(vif.s_drv_cb.busy!==1'b0)
		begin
			@(vif.s_drv_cb);
		end
		vif.s_drv_cb.pkt_valid <= 1'b0;
		vif.s_drv_cb.data_in <= tr.parity;
		//`uvm_info(get_type_name(),$sformatf("Parity Driven %2h",tr.parity),UVM_LOW)
			@(vif.s_drv_cb);
			@(vif.s_drv_cb);
			tr.error = vif.s_drv_cb.error;
		repeat(2)
			@(vif.s_drv_cb);
			e1.wait_trigger();
	endtask
	
	task run_phase(uvm_phase phase);
		rst_dut();
		forever begin
			seq_item_port.get_next_item(req);
			drive_dut(req);
			//if(req.error == 1)
				seq_item_port.put(req);
			seq_item_port.item_done();
		end
	endtask
endclass
