module router_fsm(
    input clock,resetn,pkt_valid,
    input parity_done, soft_reset_0, soft_reset_1, soft_reset_2,
    input fifo_full,fifo_empty_0,fifo_empty_1,fifo_empty_2,low_pkt_valid,
    input [1:0]data_in,
    output reg busy,
    output reg detect_add,ld_state,laf_state,full_state,lfd_state,
    output reg write_enb_reg,rst_int_reg
    );
reg [2:0]state,next_state;
parameter Decode_address = 3'b000;
parameter Load_first_data = 3'b001;
parameter Load_data = 3'b010;
parameter Fifo_full_state = 3'b011;
parameter Load_after_full = 3'b100;
parameter Load_parity = 3'b101;
parameter Check_parity_error = 3'b110;
parameter Wait_till_empty = 3'b111;

always@(posedge clock)
begin
  if(!resetn)
    state<= Decode_address;
  else if(soft_reset_0 | soft_reset_1 | soft_reset_2)
    state<= Decode_address;
  else
    state<= next_state; 
end

always@(*)
begin
  case(state)
  Decode_address: begin
	                 detect_add=1'b1;
                    {busy,ld_state,laf_state,full_state,lfd_state,write_enb_reg,rst_int_reg} = 7'b0000000;
                    if((pkt_valid & (data_in==0) & fifo_empty_0)|(pkt_valid & (data_in==1) & fifo_empty_1)|(pkt_valid & (data_in==2) & fifo_empty_2))
	                   next_state= Load_first_data;
                    else if((pkt_valid & (data_in==0) & !fifo_empty_0)|(pkt_valid & (data_in==1) & !fifo_empty_1)|(pkt_valid & (data_in==2) & !fifo_empty_2))
	                   next_state= Wait_till_empty;
                    else
	                   next_state = Decode_address;
                  end
  Load_first_data: begin
                    {lfd_state,busy} = 2'b11;
						  {detect_add,ld_state,laf_state,full_state,write_enb_reg,rst_int_reg} = 6'b000000;
						  next_state = Load_data;
						end  
  Load_data: begin
               {ld_state,write_enb_reg} = 2'b11;
					{detect_add,lfd_state,laf_state,full_state,busy,rst_int_reg} = 6'b000000;
				   if(!fifo_full & !pkt_valid)
					  next_state = Load_parity;
					else if(fifo_full)
					  next_state = Fifo_full_state;
					else 
					  next_state = Load_data;
				 end  
  Load_parity: begin
                 {busy,ld_state,write_enb_reg} = 3'b111;
					  {detect_add,laf_state,full_state,lfd_state,rst_int_reg} = 5'b00000;
					  next_state = Check_parity_error;
					end
  Check_parity_error: begin
                        {rst_int_reg,busy} = 2'b11;
								{detect_add,ld_state,laf_state,full_state,lfd_state,write_enb_reg} = 6'b000000;
								if(!fifo_full)
								  next_state = Decode_address;
								else if(fifo_full)
								  next_state = Fifo_full_state;
								else 
								  next_state = Check_parity_error;
							 end
  Fifo_full_state: begin
                     {full_state,busy} = 2'b11;
							{detect_add,laf_state,ld_state,rst_int_reg,lfd_state,write_enb_reg} = 6'b000000;
							if(!fifo_full)
							  next_state = Load_after_full;
							else 
							  next_state = Fifo_full_state;
						 end
  Load_after_full: begin
                     {laf_state,busy,write_enb_reg} = 3'b111;
							{detect_add,ld_state,full_state,lfd_state,rst_int_reg} = 5'b00000;
                     if(parity_done)
							  next_state = Decode_address;
							else if(!parity_done & low_pkt_valid)
							  next_state = Load_parity;
							else if(!parity_done & !low_pkt_valid)
							  next_state = Load_data;
							else 
							  next_state = Load_after_full;
						 end
  Wait_till_empty: begin
                     busy = 1'b1;
							{detect_add,ld_state,full_state,laf_state,rst_int_reg,lfd_state,write_enb_reg} = 7'b0000000;
							if((data_in==0) & fifo_empty_0 |(data_in==1) & fifo_empty_1 |(data_in==2) & fifo_empty_2)
							  next_state = Load_first_data;
							else
							  next_state = Wait_till_empty;
						 end
  default: next_state = Decode_address;
  endcase
end
endmodule
