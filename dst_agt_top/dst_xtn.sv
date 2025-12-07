class dst_xtn extends uvm_sequence_item;
	bit [7:0]header;
	bit [7:0]payload[];
	bit [7:0]parity;
	rand int delay;

	`uvm_object_utils_begin(dst_xtn)
	`uvm_field_int(header,UVM_ALL_ON|UVM_BIN)
	`uvm_field_array_int(payload,UVM_ALL_ON|UVM_HEX)
	`uvm_field_int(parity,UVM_ALL_ON|UVM_HEX)
	`uvm_field_int(delay,UVM_ALL_ON|UVM_DEC)
	`uvm_object_utils_end

	function new(string name = "dst_xtn");
		super.new();
	endfunction
endclass
