interface router_if(input bit clock);
	logic resetn;
	logic pkt_valid;
    	logic [7:0]data_in;
    	logic read_enb;
   	logic valid_out;
    	logic [7:0]data_out;
    	logic error,busy;
	
	parameter Tsetup= 0;
	parameter Thold = 1;

	clocking s_drv_cb @(posedge clock);
		default input #0 output #(Thold);
		input busy,error;
		output resetn,pkt_valid,data_in; 
	endclocking

	clocking s_mon_cb @(posedge clock);
		default input #(Tsetup) output #(Thold);
		input busy,error;
		input resetn,pkt_valid,data_in; 
	endclocking

	clocking d_drv_cb @(posedge clock);
		default input #0 output #(Thold);
		input valid_out;
		output read_enb; 
	endclocking

	clocking d_mon_cb @(posedge clock);
		default input #(Tsetup) output #(Thold);
		input valid_out;
		input read_enb,data_out; 
	endclocking

	modport S_DRV_MP (clocking s_drv_cb);
	modport S_MON_MP (clocking s_mon_cb);
	modport D_DRV_MP (clocking d_drv_cb);
	modport D_MON_MP (clocking d_mon_cb);
endinterface
