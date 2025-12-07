class router_scoreboard extends uvm_scoreboard;
	`uvm_component_utils(router_scoreboard)
	uvm_tlm_analysis_fifo #(src_xtn) src2sco[];
	uvm_tlm_analysis_fifo #(dst_xtn) dst2sco[];
	router_env_cfg env_cfg;
	src_xtn src_trans;
	dst_xtn dst_trans;

	covergroup src_cov;
		option.per_instance = 1;
		option.name = "SOURCE_COVERAGE";

		SRC_ADDR: coverpoint src_trans.header[1:0] {
			bins addr0 = {0};
			bins addr1 = {1};
			bins addr2 = {2};
			}

		SRC_PAYLOAD: coverpoint src_trans.header[7:2] {
			bins small_pkt = {[1:14]};
			bins medium_pkt = {[15:40]};
			bins large_pkt = {[41:63]};
			}
		
		ERROR: coverpoint src_trans.error;

		SRC_CROSS: cross SRC_ADDR,SRC_PAYLOAD,ERROR;
	endgroup

	covergroup dst_cov;
		option.per_instance = 1;
		option.name = "DESTINATION_COVERAGE";

		DST_ADDR: coverpoint dst_trans.header[1:0] {
			bins addr0 = {0};
			bins addr1 = {1};
			bins addr2 = {2};
			}

		DST_PAYLOAD: coverpoint dst_trans.header[7:2] {
			bins small_pkt = {[1:14]};
			bins medium_pkt = {[15:40]};
			bins large_pkt = {[41:63]};
			}
		
		READ_DELAY: coverpoint dst_trans.delay {
			bins soft_reset = {[31:40]};
			}

		SOFT_RESET: cross DST_ADDR, READ_DELAY;
	endgroup
	

	function new(string name = "router_scoreboard", uvm_component parent = null);
		super.new(name,parent);
	 	src_cov = new();
	 	dst_cov = new();
	endfunction
	
	function void build_phase(uvm_phase phase);
		if(!uvm_config_db#(router_env_cfg)::get(this,"","router_env_cfg",env_cfg))
			`uvm_fatal(get_type_name(),"config_db GET() method failed for env config")
		super.build_phase(phase);
		src2sco = new[env_cfg.no_of_src];
		foreach(src2sco[i])
			src2sco[i] = new($sformatf("src2sco[%0d]",i),this);
		dst2sco = new[env_cfg.no_of_dst];
		foreach(dst2sco[i])
			dst2sco[i] = new($sformatf("dst2sco[%0d]",i),this);
	endfunction

	function bit compare_pkt(src_xtn src_pkt, dst_xtn dst_pkt);
		if(src_pkt.header == dst_pkt.header && src_pkt.payload == dst_pkt.payload && src_pkt.parity == dst_pkt.parity)
			`uvm_info(get_type_name(),"PACKET COMPARISION SUCCESSFUL",UVM_LOW)
		else
			`uvm_fatal(get_type_name(),"PACKET COMPARISION FAILED")	
	endfunction

	task run_phase(uvm_phase phase);
	forever begin
		fork
			begin
				src2sco[0].get(src_trans);
				`uvm_info("SOURCE[0]",$sformatf("Data received at sco \n %s",src_trans.sprint()),UVM_LOW)
				src_cov.sample();
			end
			begin
			fork : A
				begin
					dst2sco[0].get(dst_trans);
					`uvm_info("DESTINATION[0]",$sformatf("Data received at sco \n %s",dst_trans.sprint()),UVM_LOW)
					dst_cov.sample();
				end
				begin
					dst2sco[1].get(dst_trans);
					`uvm_info("DESTINATION[1]",$sformatf("Data received at sco \n %s",dst_trans.sprint()),UVM_LOW)
					dst_cov.sample();
				end
				begin
					dst2sco[2].get(dst_trans);
					`uvm_info("DESTINATION[2]",$sformatf("Data received at sco \n %s",dst_trans.sprint()),UVM_LOW)
					dst_cov.sample();
				end
			join_any
			disable A;
			end
		join

		if(dst_trans.header!==0)
			compare_pkt(src_trans,dst_trans);
		else
			`uvm_info(get_type_name(),"SOFT RESET PACKET RECEIVED........... COMPARISION NOT INITIATED.........",UVM_LOW)
	end
	endtask
endclass
