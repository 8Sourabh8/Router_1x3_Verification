module router_top(
    input clock,resetn,
    input pkt_valid,
    input [7:0]data_in,
    input read_enb_0,read_enb_1,read_enb_2,
    output valid_out_0,valid_out_1,valid_out_2,
    output [7:0]data_out_0,data_out_1,data_out_2,
    output error,busy
    );

wire [2:0]write_enb;
wire [7:0]dout;

router_fifo Fifo0(clock,resetn,soft_reset_0,write_enb[0],read_enb_0,lfd_state,dout,empty_0,full_0,data_out_0);

router_fifo Fifo1(clock,resetn,soft_reset_1,write_enb[1],read_enb_1,lfd_state,dout,empty_1,full_1,data_out_1);

router_fifo Fifo2(clock,resetn,soft_reset_2,write_enb[2],read_enb_2,lfd_state,dout,empty_2,full_2,data_out_2);

router_sync Synchronizer(clock,resetn,read_enb_0,read_enb_1,read_enb_2,detect_add,write_enb_reg,empty_0,empty_1,empty_2,full_0,full_1,full_2,data_in[1:0],write_enb,valid_out_0,valid_out_1,valid_out_2,fifo_full,soft_reset_0,soft_reset_1,soft_reset_2);

router_fsm controller(clock,resetn,pkt_valid,parity_done, soft_reset_0, soft_reset_1, soft_reset_2,fifo_full,empty_0,empty_1,empty_2,low_pkt_valid,data_in[1:0],busy,detect_add,ld_state,laf_state,full_state,lfd_state,write_enb_reg,rst_int_reg);

router_reg Register(clock,resetn,pkt_valid,data_in,fifo_full,rst_int_reg,detect_add,ld_state,laf_state,full_state,lfd_state,dout,low_pkt_valid,parity_done,error);

endmodule
