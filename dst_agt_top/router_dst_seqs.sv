class router_dst_seqs extends uvm_sequence#(dst_xtn);
	`uvm_object_utils(router_dst_seqs)
	
	function new(string name = "router_dst_seqs");
		super.new();
	endfunction
endclass

class router_nor_read extends router_dst_seqs;
	`uvm_object_utils(router_nor_read)
	int no_of_trans;
	function new(string name = "normal_read");
		super.new();
	endfunction

	task body();
		if(!uvm_config_db#(int)::get(null,get_full_name(),"no_of_trans",no_of_trans))
			`uvm_fatal(get_type_name(),"config_db GET() method failed for no_of_trans")
		repeat(no_of_trans)
		begin
			req = dst_xtn::type_id::create("req");
			start_item(req);
			assert(req.randomize() with {delay inside {[1:14],[16:29]};}) else
				`uvm_warning(get_type_name(),"Randomization Failed")
			finish_item(req);
		end
	endtask 
endclass

class router_delay_read extends router_dst_seqs;
	`uvm_object_utils(router_delay_read)
	int no_of_trans;
	function new(string name = "delay_read");
		super.new();
	endfunction

	task body();
		if(!uvm_config_db#(int)::get(null,get_full_name(),"no_of_trans",no_of_trans))
			`uvm_fatal(get_type_name(),"config_db GET() method failed for no_of_trans")
		repeat(no_of_trans)
		begin
			req = dst_xtn::type_id::create("req");
			start_item(req);
			assert(req.randomize() with {delay inside {[31:40]};}) else
				`uvm_warning(get_type_name(),"Randomization Failed")
			finish_item(req);
		end
	endtask 
endclass
