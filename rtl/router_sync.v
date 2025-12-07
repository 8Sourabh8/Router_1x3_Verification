module router_sync(
    input clock,resetn,read_enb_0,read_enb_1,read_enb_2,
    input detect_add,write_enb_reg,empty_0,empty_1,empty_2,full_0,full_1,full_2,
    input [1:0]data_in,
    output reg [2:0]write_enb,
    output vld_out_0,vld_out_1,vld_out_2,
    output reg fifo_full,soft_reset_0,soft_reset_1,soft_reset_2
    );
reg [1:0]temp;
reg [4:0] count0,count1,count2;
wire c0_0 = (count0==1);
wire c1_0 = (count1==1);
wire c2_0 = (count2==1);

always@(posedge clock) // Latching header
begin
  if(!resetn)
    temp<= 2'b00;
  else if(detect_add)
    temp<= data_in;
  else 
    temp<= temp;
end

assign vld_out_0 = ~empty_0;  // vld_out assignment
assign vld_out_1 = ~empty_1;
assign vld_out_2 = ~empty_2;

always@(*)  // Fifo full assignment
begin
  case(temp)
    2'b00: fifo_full = full_0;
    2'b01: fifo_full = full_1;
    2'b10: fifo_full = full_2;
    default: fifo_full = 1'b0;
  endcase
end

always@(*)  // Write enable assignment
begin
  if(write_enb_reg)
  begin
    case(temp)
    2'b00: write_enb = 3'b001;
    2'b01: write_enb = 3'b010;
    2'b10: write_enb = 3'b100;
    default: write_enb = 3'b000;
    endcase
  end
  else 
    write_enb = 3'b000;
end

always@(posedge clock)  // Fifo 0 counter
begin
  if(!resetn)
  begin
    count0<= 5'd30;
    soft_reset_0<= 0;
  end
  else if(vld_out_0)
  begin
    if(read_enb_0)
    begin
      count0<= 5'd30;
      soft_reset_0<= 0;
    end
    else if(c0_0)
    begin
      soft_reset_0<= 1'b1;
      count0<= 5'd30;
    end
    else
    begin
      count0<= count0-1'b1;
      soft_reset_0<= 0;
    end
  end
  else 
  begin
      count0<= count0;
      soft_reset_0<= 0;
  end
end

always@(posedge clock)  // Fifo 1 counter
begin
  if(!resetn)
  begin
    count1<= 5'd30;
    soft_reset_1<= 0;
  end
  else if(vld_out_1)
  begin
    if(read_enb_1)
    begin
      count1<= 5'd30;
      soft_reset_1<= 0;
    end
    else if(c1_0)
    begin
      soft_reset_1<= 1'b1;
      count1<= 5'd30;
    end
    else
    begin
      count1<= count1-1'b1;
      soft_reset_1<= 0;
    end
  end
  else 
  begin
      count1<= count1;
      soft_reset_1<= 0;
  end
end

always@(posedge clock)  // Fifo 2 counter
begin
  if(!resetn)
  begin
    count2<= 5'd30;
    soft_reset_2<= 0;
  end
  else if(vld_out_2)
  begin
    if(read_enb_2)
    begin
      count2<= 5'd30;
      soft_reset_2<= 0;
    end
    else if(c2_0)
    begin
      soft_reset_2<= 1'b1;
      count2<= 5'd30;
    end
    else
    begin
      count2<= count2-1'b1;
      soft_reset_2<= 0;
    end
  end
  else 
  begin
      count2<= count2;
      soft_reset_2<= 0;
  end
end

endmodule
