class router_dst_monitor extends uvm_monitor;
	`uvm_component_utils(router_dst_monitor)
	dst_agt_cfg cfg;
	virtual router_if.D_MON_MP vif;
	dst_xtn tr;
	mailbox #(dst_xtn) mbx;
	uvm_analysis_port#(dst_xtn) dst2sco;

	function new(string name = "router_dst_monitor",uvm_component parent = null);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		if(!uvm_config_db#(dst_agt_cfg)::get(this,"","dst_agt_cfg",cfg))
			`uvm_fatal(get_type_name(),"config_db GET() method failed for vif")
		dst2sco = new("dst2sco",this);
		this.mbx = cfg.mbx;
	endfunction

	function void connect_phase(uvm_phase phase);
		vif = cfg.vif;
	endfunction

	task collect_data();
		tr = dst_xtn::type_id::create("tr");
		while(vif.d_mon_cb.read_enb !==1)
		begin
			if(mbx.try_get(tr))
			begin
				dst2sco.write(tr);
				//`uvm_info(get_type_name(),$sformatf("PACKET SENT TO SCO \n %s",tr.sprint),UVM_LOW)
			end
			@(vif.d_mon_cb);
		end
		//@(vif.d_mon_cb);
		tr.header = vif.d_mon_cb.data_out;
		//`uvm_info(get_type_name(),$sformatf("Header Recieved \n %8b",tr.header),UVM_LOW)
		tr.payload = new[tr.header[7:2]];
		@(vif.d_mon_cb);
		foreach(tr.payload[i])
		begin
			tr.payload[i]=vif.d_mon_cb.data_out;
			//`uvm_info(get_type_name(),$sformatf("Payload[%0d] Recieved \n %2h",i,tr.payload[i]),UVM_LOW)
			@(vif.d_mon_cb);
		end
		tr.parity = vif.d_mon_cb.data_out;
		//`uvm_info(get_type_name(),$sformatf("Parity Recieved \n %2h",tr.parity),UVM_LOW)
			`uvm_info(get_type_name(),$sformatf("Packet Recieved \n %s",tr.sprint()),UVM_LOW)
			dst2sco.write(tr);
			//`uvm_info(get_type_name(),$sformatf("PACKET SENT TO SCO \n %s",tr.sprint),UVM_LOW)
		repeat(2)
			@(vif.d_mon_cb);
	endtask

	task run_phase(uvm_phase phase);
		forever begin
			collect_data();
		end
	endtask
endclass
