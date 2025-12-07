module router_reg(
    input clock,resetn,pkt_valid,
    input [7:0]data_in,
    input fifo_full,rst_int_reg,detect_add,ld_state,laf_state,full_state,lfd_state,
    output reg [7:0] dout,
    output reg low_pkt_valid,parity_done,
    output reg err
    );
reg [7:0]header,pload,prity,int_prity;

always@(posedge clock)  // Writing into int reg
begin
  if(!resetn)
    {header,pload,prity} <= 32'h000000;
  else if(detect_add & pkt_valid)
    header<= data_in;
  else if(ld_state & fifo_full & pkt_valid)
    pload<= data_in;
  else if((ld_state & !pkt_valid & !fifo_full) | (laf_state & !pkt_valid & !parity_done))
    prity<= data_in;
  else 
  begin
    header<= header;
    pload<= pload;
    prity<= prity;
  end
end

always@(posedge clock)  // Dout assignment
begin
  if(!resetn)
    dout<= 8'h00;
  else if(lfd_state)
    dout<= header;
  else if(ld_state & !fifo_full)
    dout<= data_in;
  else if(laf_state & !pkt_valid & parity_done)
    dout<= prity;
  else if(laf_state & pkt_valid)
    dout<= pload;
  else
    dout<= dout;
end

always@(*)  // parity_done assignment
begin
  if(!resetn)
    parity_done <= 1'b0;
  else if(detect_add)
    parity_done <= 1'b0;
  else if((ld_state & !pkt_valid & !fifo_full) | (laf_state & !pkt_valid & !parity_done))
    parity_done <= 1'b1;
  else
    parity_done <= parity_done; 
end

always@(posedge clock)  // low_pkt_valid assignment
begin
  if(!resetn)
    low_pkt_valid <= 1'b0;
  else if(rst_int_reg)
    low_pkt_valid <= 1'b0;
  else if(ld_state & !pkt_valid)
    low_pkt_valid <= 1'b1;
  else
    low_pkt_valid <= low_pkt_valid; 
end

always@(posedge clock)  // Internal parity calculation
begin
  if(!resetn | detect_add)
    int_prity <= 8'h00;
  else if(full_state)
    int_prity <= int_prity;
  else if(lfd_state & pkt_valid)
    int_prity <= int_prity^header;
  else if(ld_state & pkt_valid)
    int_prity <= int_prity^data_in;
  else 
    int_prity <= int_prity; 
end

always@(*)  // Error detection
begin
  if(!resetn)
    err = 1'b0;
  else if(parity_done)
  begin
    if(int_prity != prity)
      err  = 1'b1;
    else 
      err = 1'b0;
  end
  else
    err = 1'b0;
end


endmodule
