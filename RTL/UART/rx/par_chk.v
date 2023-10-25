module parity_check(
input wire clk,
input wire[7:0]p_data,
input wire sampled_bit,
input wire par_chk_en,
input wire par_typ,
output reg par_err
);

reg parity ;
always@(posedge clk)
begin 
   case(par_typ)
      1'b0 : begin 
	         parity <= ^p_data  ;     // Even Parity
			 end
	  1'b1 	:  begin 
             parity <= ~^p_data ;     // Odd Parity	
               end			 
    endcase
end

always @ (posedge clk )
 begin
  if(par_chk_en)
   begin
    par_err <= parity ^	sampled_bit ;
   end	
 end
endmodule	 
