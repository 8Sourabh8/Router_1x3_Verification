class router_src_monitor extends uvm_monitor;
	`uvm_component_utils(router_src_monitor)
	src_agt_cfg cfg;
	virtual router_if.S_MON_MP vif;
	src_xtn tr;
	uvm_analysis_port#(src_xtn) src2sco;
	
	function new(string name = "router_src_monitor",uvm_component parent = null);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		if(!uvm_config_db#(src_agt_cfg)::get(this,"","src_agt_cfg",cfg))
			`uvm_fatal(get_type_name(),"config_db GET() method failed for vif")
		src2sco = new("src2sco",this);
	endfunction

	function void connect_phase(uvm_phase phase);
		vif = cfg.vif;
	endfunction

	task collect_data();
		tr = src_xtn::type_id::create("tr");
		while(vif.s_mon_cb.pkt_valid !== 1'b1)
			@(vif.s_mon_cb);
		while(vif.s_mon_cb.busy !== 1'b0)
			@(vif.s_mon_cb);
		tr.header = vif.s_mon_cb.data_in;
		//`uvm_info(get_type_name(),$sformatf("Header Sampled : %8b",tr.header),UVM_LOW)
		tr.payload = new[tr.header[7:2]];
			@(vif.s_mon_cb);
		foreach(tr.payload[i])
		begin
			while(vif.s_mon_cb.busy !== 1'b0)
				@(vif.s_mon_cb);
			tr.payload[i] = vif.s_mon_cb.data_in;
			//`uvm_info(get_type_name(),$sformatf("Payload[%0d] Sampled : %2h",i,tr.payload[i]),UVM_LOW)
				@(vif.s_mon_cb);
		end
		tr.parity =  vif.s_mon_cb.data_in;
		//`uvm_info(get_type_name(),$sformatf("Parity Sampled : %2h",tr.parity),UVM_LOW)
		repeat(1)
			@(vif.s_mon_cb);
		tr.error = vif.s_mon_cb.error;
		`uvm_info(get_type_name(),$sformatf("Packet Sampled : \n %s",tr.sprint()),UVM_LOW) // Final sampled Packet print
		src2sco.write(tr);
		//`uvm_info(get_type_name(),$sformatf("Error Sampled : %0b",tr.error),UVM_LOW)
	endtask

	task run_phase(uvm_phase phase);
		forever begin
			collect_data();
		end
	endtask
endclass
