class router_base_test extends uvm_test;
	`uvm_component_utils(router_base_test)
	router_env env;
	router_env_cfg env_cfg;
	src_agt_cfg src_cfg[];
	dst_agt_cfg dst_cfg[];
	mailbox #(dst_xtn) mbx[];
	int no_of_src = 1;
	int no_of_dst = 3;
	bit has_scoreboard = 1;
	bit has_functional_coverage = 1;
	bit has_virtual_sequencer = 1;
///
	/*router_small_seq seq0;
	router_delay_read seq1[];
	router_nor_read seq2[];*/
///	
	function new(string name = "router_base_test", uvm_component parent = null);
		super.new(name,parent);
	endfunction
	
	function void build_phase(uvm_phase phase);
		env_cfg = router_env_cfg::type_id::create("env_cfg");
		env_cfg.src_cfg = new[no_of_src];
		src_cfg = new[no_of_src];
		foreach(src_cfg[i])
		begin
			src_cfg[i] = src_agt_cfg::type_id::create($sformatf("src_cfg[%0d]",i));
			if(!uvm_config_db#(virtual router_if)::get(this,"",$sformatf("sif%0d",i),src_cfg[i].vif))
				`uvm_fatal(get_type_name(),"config db GET() method failed for interface")
			src_cfg[i].is_active = UVM_ACTIVE;
			env_cfg.src_cfg[i] = src_cfg[i];
		end
		env_cfg.dst_cfg = new[no_of_dst];
		dst_cfg = new[no_of_dst];
		mbx = new[no_of_dst];
		foreach(dst_cfg[i])
		begin
			dst_cfg[i] = dst_agt_cfg::type_id::create($sformatf("dst_cfg[%0d]",i));
			mbx[i] = new();
			if(!uvm_config_db#(virtual router_if)::get(this,"",$sformatf("dif%0d",i),dst_cfg[i].vif))
				`uvm_fatal(get_type_name(),"config db GET() method failed for interface")
			dst_cfg[i].is_active = UVM_ACTIVE;
			dst_cfg[i].mbx = mbx[i];
			env_cfg.dst_cfg[i] = dst_cfg[i];
		end
		env_cfg.no_of_src = no_of_src;
		env_cfg.no_of_dst = no_of_dst;
		env_cfg.has_scoreboard = has_scoreboard;
		env_cfg.has_functional_coverage = has_functional_coverage;
		env_cfg.has_virtual_sequencer = has_virtual_sequencer;
		uvm_config_db#(router_env_cfg)::set(this,"*","router_env_cfg",env_cfg);		

		super.build_phase(phase);
		env = router_env::type_id::create("env",this);
////
		/*seq0 = router_small_seq::type_id::create("seq0");
		seq1 = new[no_of_dst]; 
		seq2 = new[no_of_dst]; 
		foreach(seq1[i])
		seq1[i] = router_delay_read::type_id::create($sformatf("seq1[%0d]",i));
		foreach(seq2[i])
		seq2[i] = router_nor_read::type_id::create($sformatf("seq2[%0d]",i));*/
	endfunction

	function void end_of_elaboration_phase(uvm_phase phase);
		super.end_of_elaboration_phase(phase);
		uvm_top.print_topology();
		for(int i=0; i<no_of_src; i++)
			env.src_top.src_agt[i].seqr.set_arbitration(SEQ_ARB_RANDOM);
		for(int i=0; i<no_of_dst; i++)
			env.dst_top.dst_agt[i].seqr.set_arbitration(SEQ_ARB_RANDOM);
	endfunction

	/*task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		uvm_config_db#(bit[1:0])::set(this,"*.seq0","addr",2'b00);
		//for(int i=0; i<no_of_src; i++)
		fork
			seq0.start(env.src_top.src_agt[0].seqr);
			begin
			//for(int j=0; j<no_of_dst; j++)
			fork : A
			for(int j=0; j<no_of_dst; j++)
			begin
				fork
				`uvm_info(get_type_name(),$sformatf("READ SEQ started in agt[%0d]",j),UVM_LOW)
				seq1[j].start(env.dst_top.dst_agt[j].seqr);
				eve.trigger();
				join_none
			end
				//seq1[1].start(env.dst_top.dst_agt[1].seqr);
				//seq1[2].start(env.dst_top.dst_agt[2].seqr);
			join_any
			`uvm_info(get_type_name(),"ONE READ SEQS COMPLETED",UVM_LOW)
				`uvm_info(get_type_name(),"Disabling FORK",UVM_LOW)
				eve.wait_ptrigger();
				disable A;
				`uvm_info(get_type_name(),"Disabled FORK",UVM_LOW)
			end
		join
		phase.drop_objection(this);
	endtask*/

	/*task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		uvm_config_db#(int)::set(null,"*.seq1","no_of_trans",no_of_trans)
		uvm_config_db#(int)::set(this,"*.seq*","no_of_trans",200);
		//for(int i=0; i<no_of_src; i++)
		fork
			seq0.start(env.src_top.src_agt[0].seqr);
			begin
			fork : A
				fork
				seq1[0].start(env.dst_top.dst_agt[0].seqr);
				seq2[0].start(env.dst_top.dst_agt[0].seqr);
				join
				fork
				seq1[1].start(env.dst_top.dst_agt[1].seqr);
				seq2[1].start(env.dst_top.dst_agt[1].seqr);
				join
				fork
				seq1[2].start(env.dst_top.dst_agt[2].seqr);
				seq2[2].start(env.dst_top.dst_agt[2].seqr);
				join
			join_any
				`uvm_info(get_type_name(),"DISABLING FORK",UVM_LOW)
				disable A;
			end
		join
		phase.drop_objection(this);
	endtask*/
endclass

class router_sreset_test extends router_base_test;
	`uvm_component_utils(router_sreset_test)
	router_sreset_dst0 seqA;
	router_sreset_dst1 seqB;
	router_sreset_dst2 seqC;

	function new(string name = "router_sreset_test", uvm_component parent = null);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		seqA = router_sreset_dst0::type_id::create("seqA");
		seqB = router_sreset_dst1::type_id::create("seqB");
		seqC = router_sreset_dst2::type_id::create("seqC");
		uvm_config_db#(int)::set(null,"*.seqA","no_of_trans",10);
		uvm_config_db#(int)::set(null,"*.seqB","no_of_trans",10);
		uvm_config_db#(int)::set(null,"*.seqC","no_of_trans",10);
	endfunction

	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		seqA.start(env.v_seqr);
		seqB.start(env.v_seqr);
		seqC.start(env.v_seqr);
		phase.drop_objection(this);
	endtask
endclass

class router_dst0_test extends router_base_test;
	`uvm_component_utils(router_dst0_test)
	router_normal_dst0 seqA;

	function new(string name = "router_dst0_test", uvm_component parent = null);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		seqA = router_normal_dst0::type_id::create("seqA");
		uvm_config_db#(int)::set(null,"*.seqA","no_of_trans",50);
	endfunction
		
	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		seqA.start(env.v_seqr);
		#50;
		phase.drop_objection(this);
	endtask
endclass

class router_dst1_test extends router_base_test;
	`uvm_component_utils(router_dst1_test)
	router_normal_dst1 seqA;

	function new(string name = "router_dst1_test", uvm_component parent = null);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		seqA = router_normal_dst1::type_id::create("seqA");
		uvm_config_db#(int)::set(null,"*.seqA","no_of_trans",50);
	endfunction
		
	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		seqA.start(env.v_seqr);
		#50;
		phase.drop_objection(this);
	endtask
endclass

class router_dst2_test extends router_base_test;
	`uvm_component_utils(router_dst2_test)
	router_normal_dst2 seqA;

	function new(string name = "router_dst2_test", uvm_component parent = null);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		seqA = router_normal_dst2::type_id::create("seqA");
		uvm_config_db#(int)::set(null,"*.seqA","no_of_trans",50);
	endfunction
		
	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		seqA.start(env.v_seqr);
		#50;
		phase.drop_objection(this);
	endtask
endclass
