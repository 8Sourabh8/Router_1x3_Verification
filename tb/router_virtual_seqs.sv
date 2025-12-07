class router_vbase_seqs extends uvm_sequence#(uvm_sequence_item);
	`uvm_object_utils(router_vbase_seqs)
	router_virtual_sequencer v_seqr;
	router_env_cfg cfg;
	router_src_sequencer src_seqr[];
	router_dst_sequencer dst_seqr[];

	function new(string name = "router_vbase_seqs");
			super.new(name);
	endfunction

	task body();
		if(!uvm_config_db#(router_env_cfg)::get(null,get_full_name(),"router_env_cfg",cfg))
			`uvm_fatal(get_type_name(),"config_db GET() method failed for env_cfg")
		src_seqr = new[cfg.no_of_src];
		dst_seqr = new[cfg.no_of_dst];
		assert($cast(v_seqr,m_sequencer)) else 
			`uvm_fatal(get_type_name(),"Casting of virtual sequencer failed")
		foreach(src_seqr[i])
			src_seqr[i] = v_seqr.src_seqr[i];
		foreach(dst_seqr[i])
			dst_seqr[i] = v_seqr.dst_seqr[i];
	endtask
endclass

class router_sreset_dst0 extends router_vbase_seqs;
	`uvm_object_utils(router_sreset_dst0)
	int no_of_trans;
	router_small_seq seq1;
	router_nor_read seq2;
	router_delay_read seq3;

	function new(string name = "router_sreset_dst0");
		super.new(name);
	endfunction

	task body();
		super.body();
		if(!uvm_config_db#(int)::get(null,get_full_name(),"no_of_trans",no_of_trans))
			`uvm_fatal(get_type_name(),"config_db GET() method method failed for no_of_trans")

		seq1 = router_small_seq::type_id::create("seq1");
		seq2 = router_nor_read::type_id::create("seq2");
		seq3 = router_delay_read::type_id::create("seq3");

		uvm_config_db#(bit[1:0])::set(null,"uvm_test_top.*.seq1","addr",2'b00);
		uvm_config_db#(int)::set(null,"*.seq1","no_of_trans",no_of_trans);
		uvm_config_db#(int)::set(null,"*.seq2","no_of_trans",no_of_trans/2);
		uvm_config_db#(int)::set(null,"*.seq3","no_of_trans",no_of_trans/2);

		fork
			seq1.start(src_seqr[0]);
			seq2.start(dst_seqr[0]);
			seq3.start(dst_seqr[0]);
		join
	endtask
endclass

class router_sreset_dst1 extends router_vbase_seqs;
	`uvm_object_utils(router_sreset_dst1)
	int no_of_trans;
	router_small_seq seq1;
	router_nor_read seq2;
	router_delay_read seq3;

	function new(string name = "router_sreset_dst1");
		super.new(name);
	endfunction

	task body();
		super.body();
		if(!uvm_config_db#(int)::get(null,get_full_name(),"no_of_trans",no_of_trans))
			`uvm_fatal(get_type_name(),"config_db GET() method method failed for no_of_trans")

		seq1 = router_small_seq::type_id::create("seq1");
		seq2 = router_nor_read::type_id::create("seq2");
		seq3 = router_delay_read::type_id::create("seq3");

		uvm_config_db#(bit[1:0])::set(null,"uvm_test_top.*.seq1","addr",2'b01);
		uvm_config_db#(int)::set(null,"*.seq1","no_of_trans",no_of_trans);
		uvm_config_db#(int)::set(null,"*.seq2","no_of_trans",no_of_trans/2);
		uvm_config_db#(int)::set(null,"*.seq3","no_of_trans",no_of_trans/2);

		fork
			seq1.start(src_seqr[0]);
			seq2.start(dst_seqr[1]);
			seq3.start(dst_seqr[1]);
		join
	endtask
endclass

class router_sreset_dst2 extends router_vbase_seqs;
	`uvm_object_utils(router_sreset_dst2)
	int no_of_trans;
	router_small_seq seq1;
	router_nor_read seq2;
	router_delay_read seq3;

	function new(string name = "router_sreset_dst2");
		super.new(name);
	endfunction

	task body();
		super.body();
		if(!uvm_config_db#(int)::get(null,get_full_name(),"no_of_trans",no_of_trans))
			`uvm_fatal(get_type_name(),"config_db GET() method method failed for no_of_trans")

		seq1 = router_small_seq::type_id::create("seq1");
		seq2 = router_nor_read::type_id::create("seq2");
		seq3 = router_delay_read::type_id::create("seq3");

		uvm_config_db#(bit[1:0])::set(null,"uvm_test_top.*.seq1","addr",2'b10);
		uvm_config_db#(int)::set(null,"*.seq1","no_of_trans",no_of_trans);
		uvm_config_db#(int)::set(null,"*.seq2","no_of_trans",no_of_trans/2);
		uvm_config_db#(int)::set(null,"*.seq3","no_of_trans",no_of_trans/2);

		fork
			seq1.start(src_seqr[0]);
			seq2.start(dst_seqr[2]);
			seq3.start(dst_seqr[2]);
		join
	endtask
endclass

class router_normal_dst0 extends router_vbase_seqs;
	`uvm_object_utils(router_normal_dst0)
	int no_of_trans;
	router_small_seq seq1;
	router_medium_seq seq2;
	router_large_seq seq3;
	router_error_seq seq4;
	router_nor_read seq5;

	function new(string name = "router_normal_dst0");
		super.new(name);
	endfunction
	
	task body();
		super.body();
		if(!uvm_config_db#(int)::get(null,get_full_name(),"no_of_trans",no_of_trans))
			`uvm_fatal(get_type_name(),"config_db GET() method method failed for no_of_trans")
		
		seq1 = router_small_seq::type_id::create("seq1");
		seq2 = router_medium_seq::type_id::create("seq2");
		seq3 = router_large_seq::type_id::create("seq3");
		seq4 = router_error_seq::type_id::create("seq4");
		seq5 = router_nor_read::type_id::create("seq5");

		uvm_config_db#(bit[1:0])::set(null,"uvm_test_top.*","addr",2'b00);
		uvm_config_db#(int)::set(null,"*.seq1","no_of_trans",no_of_trans);
		uvm_config_db#(int)::set(null,"*.seq2","no_of_trans",no_of_trans);
		uvm_config_db#(int)::set(null,"*.seq3","no_of_trans",no_of_trans);
		uvm_config_db#(int)::set(null,"*.seq4","no_of_trans",no_of_trans);
		uvm_config_db#(int)::set(null,"*.seq5","no_of_trans",5*no_of_trans);

		fork
			seq1.start(src_seqr[0]);
			seq2.start(src_seqr[0]);
			seq3.start(src_seqr[0]);
			seq4.start(src_seqr[0]);
			seq5.start(dst_seqr[0]);
		join
	endtask
endclass

class router_normal_dst1 extends router_vbase_seqs;
	`uvm_object_utils(router_normal_dst1)
	int no_of_trans;
	router_small_seq seq1;
	router_medium_seq seq2;
	router_large_seq seq3;
	router_error_seq seq4;
	router_nor_read seq5;

	function new(string name = "router_normal_dst1");
		super.new(name);
	endfunction
	
	task body();
		super.body();
		if(!uvm_config_db#(int)::get(null,get_full_name(),"no_of_trans",no_of_trans))
			`uvm_fatal(get_type_name(),"config_db GET() method method failed for no_of_trans")
		
		seq1 = router_small_seq::type_id::create("seq1");
		seq2 = router_medium_seq::type_id::create("seq2");
		seq3 = router_large_seq::type_id::create("seq3");
		seq4 = router_error_seq::type_id::create("seq4");
		seq5 = router_nor_read::type_id::create("seq5");

		uvm_config_db#(bit[1:0])::set(null,"uvm_test_top.*","addr",2'b01);
		uvm_config_db#(int)::set(null,"*.seq1","no_of_trans",no_of_trans);
		uvm_config_db#(int)::set(null,"*.seq2","no_of_trans",no_of_trans);
		uvm_config_db#(int)::set(null,"*.seq3","no_of_trans",no_of_trans);
		uvm_config_db#(int)::set(null,"*.seq4","no_of_trans",no_of_trans);
		uvm_config_db#(int)::set(null,"*.seq5","no_of_trans",5*no_of_trans);

		fork
			seq1.start(src_seqr[0]);
			seq2.start(src_seqr[0]);
			seq3.start(src_seqr[0]);
			seq4.start(src_seqr[0]);
			seq5.start(dst_seqr[1]);
		join
	endtask
endclass

class router_normal_dst2 extends router_vbase_seqs;
	`uvm_object_utils(router_normal_dst2)
	int no_of_trans;
	router_small_seq seq1;
	router_medium_seq seq2;
	router_large_seq seq3;
	router_error_seq seq4;
	router_nor_read seq5;

	function new(string name = "router_normal_dst2");
		super.new(name);
	endfunction
	
	task body();
		super.body();
		if(!uvm_config_db#(int)::get(null,get_full_name(),"no_of_trans",no_of_trans))
			`uvm_fatal(get_type_name(),"config_db GET() method method failed for no_of_trans")
		
		seq1 = router_small_seq::type_id::create("seq1");
		seq2 = router_medium_seq::type_id::create("seq2");
		seq3 = router_large_seq::type_id::create("seq3");
		seq4 = router_error_seq::type_id::create("seq4");
		seq5 = router_nor_read::type_id::create("seq5");

		uvm_config_db#(bit[1:0])::set(null,"uvm_test_top.*","addr",2'b10);
		uvm_config_db#(int)::set(null,"*.seq1","no_of_trans",no_of_trans);
		uvm_config_db#(int)::set(null,"*.seq2","no_of_trans",no_of_trans);
		uvm_config_db#(int)::set(null,"*.seq3","no_of_trans",no_of_trans);
		uvm_config_db#(int)::set(null,"*.seq4","no_of_trans",no_of_trans);
		uvm_config_db#(int)::set(null,"*.seq5","no_of_trans",5*no_of_trans);

		fork
			seq1.start(src_seqr[0]);
			seq2.start(src_seqr[0]);
			seq3.start(src_seqr[0]);
			seq4.start(src_seqr[0]);
			seq5.start(dst_seqr[2]);
		join
	endtask
endclass
