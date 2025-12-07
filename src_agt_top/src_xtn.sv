class src_xtn extends uvm_sequence_item;
	rand bit [7:0]header;
	rand bit [7:0]payload[];
	bit [7:0]parity;
	bit error;
	
	`uvm_object_utils_begin(src_xtn)
	`uvm_field_int(header,UVM_ALL_ON|UVM_BIN)
	`uvm_field_array_int(payload,UVM_ALL_ON|UVM_HEX)
	`uvm_field_int(parity,UVM_ALL_ON|UVM_HEX)
	`uvm_field_int(error,UVM_ALL_ON|UVM_HEX)
	`uvm_object_utils_end

	function new(string name = "src_xtn");
		super.new(name);
	endfunction

	constraint vld_addr{ 
			header[1:0] != 2'b11;
			}
	constraint vld_pload{
			header[7:2] != 'b0;
			payload.size == header[7:2];
			}

	function void post_randomize();
		 parity = header;
		foreach(payload[i])
		parity = parity^payload[i];
	endfunction
endclass

class err_xtn extends src_xtn;
	`uvm_object_utils(err_xtn)
	
	function new(string name = "err_xtn");
		super.new(name);
	endfunction

	function void post_randomize();
		parity = $urandom;
	endfunction
endclass
