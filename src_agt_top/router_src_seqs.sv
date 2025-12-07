class router_src_bseqs extends uvm_sequence#(src_xtn);
	`uvm_object_utils(router_src_bseqs)

	function new(string name = "router_src_bseqs");
		super.new(name);
	endfunction
endclass

class router_small_seq extends router_src_bseqs;
	`uvm_object_utils(router_small_seq)
	bit [1:0]addr;
	int no_of_trans;
	function new(string name = "router_small_seq");
		super.new(name);
	endfunction

	task body();
		if(!uvm_config_db#(bit[1:0])::get(null,get_full_name(),"addr",addr))
			`uvm_fatal(get_type_name(),"config_db GET() method failed for address")
		if(!uvm_config_db#(int)::get(null,get_full_name(),"no_of_trans",no_of_trans))
			`uvm_fatal(get_type_name(),"config_db GET() method failed for no_of_trans")
		repeat(no_of_trans)
		begin
			req = src_xtn::type_id::create("req");
			start_item(req);
			assert(req.randomize() with {header[1:0]==addr; header[7:2] inside {[1:14]};}) else 
				`uvm_warning(get_type_name(),"Randomization failed")
			finish_item(req);
			get_response(rsp);
		end
	endtask
endclass

class router_medium_seq extends router_src_bseqs;
	`uvm_object_utils(router_medium_seq)
	bit [1:0]addr;
	int no_of_trans;
	function new(string name = "router_medium_seq");
		super.new(name);
	endfunction

	task body();
		if(!uvm_config_db#(bit[1:0])::get(null,get_full_name(),"addr",addr))
			`uvm_fatal(get_type_name(),"config_db GET() method failed for address")
		if(!uvm_config_db#(int)::get(null,get_full_name(),"no_of_trans",no_of_trans))
			`uvm_fatal(get_type_name(),"config_db GET() method failed for no_of_trans")
		repeat(no_of_trans)
		begin
			req = src_xtn::type_id::create("req");
			start_item(req);
			assert(req.randomize() with {header[1:0]==addr; header[7:2] inside {15,[17:40]};}) else 
				`uvm_warning(get_type_name(),"Randomization failed")
			finish_item(req);
			get_response(rsp);
		end
	endtask
endclass

class router_large_seq extends router_src_bseqs;
	`uvm_object_utils(router_large_seq)
	bit [1:0]addr;
	int no_of_trans;
	function new(string name = "router_large_seq");
		super.new(name);
	endfunction

	task body();
		if(!uvm_config_db#(bit[1:0])::get(null,get_full_name(),"addr",addr))
			`uvm_fatal(get_type_name(),"config_db GET() method failed for address")
		if(!uvm_config_db#(int)::get(null,get_full_name(),"no_of_trans",no_of_trans))
			`uvm_fatal(get_type_name(),"config_db GET() method failed for no_of_trans")
		repeat(no_of_trans)
		begin
			req = src_xtn::type_id::create("req");
			start_item(req);
			assert(req.randomize() with {header[1:0]==addr; header[7:2] inside {[41:63]};}) else 
				`uvm_warning(get_type_name(),"Randomization failed")
			finish_item(req);
			get_response(rsp);
		end
	endtask
endclass

class router_error_seq extends router_src_bseqs;
	`uvm_object_utils(router_error_seq)
	bit [1:0]addr;
	int no_of_trans;
	function new(string name = "router_error_seq");
		super.new(name);
	endfunction
	
	task item_to_driver(src_xtn req);
		start_item(req);
		if(req.error !== 1)
		assert(req.randomize() with {header[1:0]==addr; header[7:2]!= 16;}) else 
			`uvm_warning(get_type_name(),"Randomization failed")
		//finish_item(req);
		send_request(req);
		wait_for_item_done();
		get_response(rsp);
		if(rsp.error == 1)
		begin
			m_sequencer.grab(this);
				`uvm_info(get_type_name(),"ERROR IN PACKET ...... SENDING AGAIN......",UVM_LOW)
				rsp.parity = rsp.header;
				foreach(rsp.payload[i])
					rsp.parity = rsp.parity^rsp.payload[i];
				item_to_driver(rsp);
		end
			m_sequencer.ungrab(this);
	endtask

	task body();
		if(!uvm_config_db#(bit[1:0])::get(null,get_full_name(),"addr",addr))
			`uvm_fatal(get_type_name(),"config_db GET() method failed for address")
		if(!uvm_config_db#(int)::get(null,get_full_name(),"no_of_trans",no_of_trans))
			`uvm_fatal(get_type_name(),"config_db GET() method failed for no_of_trans")
		repeat(no_of_trans)
		begin
			req = err_xtn::type_id::create("req");
			item_to_driver(req);
		end
	endtask
endclass




