module par_calc (
input wire clk ,
input wire [7:0] p_data,
input wire d_valid ,
input wire par_typ,
output reg par_bit_x
);


always@(posedge clk) 
begin 
  if (d_valid && par_typ==1)
     par_bit_x <= ~(p_data[0] ^ p_data [1] ^ p_data[2] ^ p_data[3] ^ p_data [4] ^ p_data[5] ^ p_data [6] ^ p_data [7]) ;  //~^p_data  
  else if (d_valid && par_typ == 0)
     par_bit_x <= p_data[0] ^ p_data [1] ^ p_data[2] ^ p_data[3] ^ p_data [4] ^ p_data[5] ^ p_data [6] ^ p_data [7] ;     // ^p_data
  	 
end
endmodule	 